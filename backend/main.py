from fastapi import FastAPI, UploadFile, File, WebSocket, WebSocketDisconnect, Form
from fastapi.middleware.cors import CORSMiddleware
from ultralytics import YOLO
import cv2
import numpy as np
import json
import base64
from datetime import datetime
from typing import List
import torch
from PIL import Image
import io
import os
from azure.storage.blob import BlobServiceClient
from dotenv import load_dotenv

# ======================
# APP INIT
# ======================
app = FastAPI(title="PakRescue AI – Advanced Drone Victim Detection & Tracking")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # allow all origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ======================
# GPU CHECK
# ======================
device = "cuda" if torch.cuda.is_available() else "cpu"
print(f"[INFO] Using device: {device}")
load_dotenv()

# ======================
# AZURE BLOB CONFIG
# ======================
AZURE_CONNECTION_STRING = os.getenv("AZURE_STORAGE_CONNECTION_STRING")
CONTAINER_NAME = "models"
BLOB_NAME = "yolov8n.pt"

# Download model from Azure Blob if not exists locally
if not os.path.exists("yolov8n.pt"):
    print("[INFO] Downloading YOLO model from Azure Blob Storage...")
    blob_service_client = BlobServiceClient.from_connection_string(AZURE_CONNECTION_STRING)
    blob_client = blob_service_client.get_blob_client(container=CONTAINER_NAME, blob=BLOB_NAME)
    with open("yolov8n.pt", "wb") as f:
        f.write(blob_client.download_blob().readall())
    print("[INFO] Model downloaded successfully!")

# ======================
# LOAD YOLOv8 MODEL
# ======================
model = YOLO("yolov8n.pt")
model.to(device)
print("[INFO] YOLO model loaded successfully!")

# ======================
# ANALYTICS
# ======================
analytics_data = {
    "total_requests": 0,
    "total_victims_detected": 0,
    "last_detection_time": None,
    "average_victims_per_image": 0
}

connected_clients: List[WebSocket] = []

async def notify_clients(data):
    for ws in connected_clients[:]:
        try:
            await ws.send_text(json.dumps(data))
        except:
            connected_clients.remove(ws)

# ======================
# DETECTION FUNCTION
# ======================
def detect_victims(img):
    results = model.predict(
        source=img,
        imgsz=1280,
        conf=0.1,
        iou=0.3,
        max_det=2000,
        augment=True,
        device=device,
        verbose=False
    )

    victims = []
    for r in results:
        boxes = r.boxes
        for box in boxes:
            cls = int(box.cls[0])
            if cls == 0:  # person class
                x1, y1, x2, y2 = box.xyxy[0].tolist()
                confidence = float(box.conf[0])
                victims.append({
                    "x": float(x1),
                    "y": float(y1),
                    "width": float(x2 - x1),
                    "height": float(y2 - y1),
                    "confidence": confidence,
                    "label": "victim"
                })
    return victims

# ======================
# DENSITY CALCULATION
# ======================
def compute_density(victims, img_shape):
    h, w, _ = img_shape
    area = h * w
    count = len(victims)
    density = count / (area / 1e6)
    if density < 5:
        level = "Low"
    elif density < 15:
        level = "Medium"
    else:
        level = "High"
    return density, level

# ======================
# DRAW BOXES
# ======================
def draw_boxes(img, victims):
    for v in victims:
        x = int(v["x"])
        y = int(v["y"])
        w = int(v["width"])
        h = int(v["height"])
        cv2.rectangle(img, (x, y), (x+w, y+h), (0, 0, 255), 2)
        cv2.putText(img, f"{v['confidence']:.2f}",
                    (x, y-5),
                    cv2.FONT_HERSHEY_SIMPLEX,
                    0.5,
                    (0, 0, 255),
                    1)
    return img

# ======================
# DETECT ENDPOINT (API)
# ======================
@app.post("/detect")
async def detect_endpoint(file: UploadFile = File(...), request_id: str = Form(...)):
    analytics_data["total_requests"] += 1
    image_bytes = await file.read()
    np_img = np.frombuffer(image_bytes, np.uint8)
    img = cv2.imdecode(np_img, cv2.IMREAD_COLOR)

    if img is None:
        return {"error": "Invalid image"}

    victims = detect_victims(img)
    density_value, density_level = compute_density(victims, img.shape)

    analytics_data["total_victims_detected"] += len(victims)
    analytics_data["last_detection_time"] = str(datetime.now())
    analytics_data["average_victims_per_image"] = (
        analytics_data["total_victims_detected"] / analytics_data["total_requests"]
    )

    annotated = draw_boxes(img.copy(), victims)
    _, buffer = cv2.imencode(".jpg", annotated)
    img_base64 = base64.b64encode(buffer).decode("utf-8")

    payload = {
        "request_id": request_id,
        "event": "victims_detected" if victims else "no_victims",
        "count": len(victims),
        "density_score": density_value,
        "density_level": density_level,
        "victims": victims,
        "image": img_base64
    }

    await notify_clients(payload)
    return payload

# ======================
# WEBSOCKET FOR REAL-TIME TRACKING
# ======================
@app.websocket("/ws/detect")
async def websocket_tracking(ws: WebSocket):
    await ws.accept()
    connected_clients.append(ws)
    print("Client connected")

    try:
        while True:
            data = await ws.receive_text()
            frame_bytes = base64.b64decode(data)
            pil_image = Image.open(io.BytesIO(frame_bytes)).convert("RGB")
            image = np.array(pil_image)
            img_h, img_w, _ = image.shape

            results = model.track(
                image,
                persist=True,
                conf=0.15,
                iou=0.3,
                device=device,
                verbose=False,
                tracker="bytetrack.yaml"
            )

            victims = []
            for r in results:
                if r.boxes is None:
                    continue
                boxes = r.boxes.xyxy.cpu().numpy()
                confs = r.boxes.conf.cpu().numpy()
                ids = r.boxes.id
                if ids is None:
                    continue
                ids = ids.cpu().numpy()
                for box, conf_score, track_id in zip(boxes, confs, ids):
                    x1, y1, x2, y2 = box.tolist()
                    victims.append({
                        "id": int(track_id),
                        "x1": float(x1),
                        "y1": float(y1),
                        "x2": float(x2),
                        "y2": float(y2),
                        "confidence": float(conf_score)
                    })

            await ws.send_text(json.dumps({
                "humans": victims,
                "image_width": img_w,
                "image_height": img_h
            }))

    except WebSocketDisconnect:
        connected_clients.remove(ws)
        print("Client disconnected")

# ======================
# ANALYTICS
# ======================
@app.get("/analytics")
async def get_analytics():
    return analytics_data

