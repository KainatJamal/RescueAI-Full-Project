from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
from ultralytics import YOLO
import numpy as np
from PIL import Image
import io
import base64
import json
import torch
import cv2

# ======================
# APP INIT
# ======================
app = FastAPI(title="PakRescue AI – WebSocket Victim Tracking")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ======================
# LOAD YOLOv8 TRACKING MODEL
# ======================
model = YOLO(r"D:\FYP\pakrescue_ai\backend\models\yolov8x.pt")  # replace with your trained model
device = "cuda" if torch.cuda.is_available() else "cpu"
model.to(device)
print(f"[INFO] Using device: {device}")

# ======================
# WEBSOCKET FOR REAL-TIME DETECTION
# ======================
@app.websocket("/ws/detect")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    print("Client connected")

    try:
        while True:
            data = await websocket.receive_text()

            # Decode frame
            frame_bytes = base64.b64decode(data)
            pil_image = Image.open(io.BytesIO(frame_bytes)).convert("RGB")
            image = np.array(pil_image)

            img_h, img_w, _ = image.shape

            # 🔥 Upscale very small images for better small object detection
            if max(img_h, img_w) < 1000:
                scale_factor = 2
                image = cv2.resize(image, (img_w*scale_factor, img_h*scale_factor), interpolation=cv2.INTER_LINEAR)
            else:
                scale_factor = 1

            # ✅ TRACKING for all sizes of victims
            results = model.track(
                image,
                persist=True,       # keeps track IDs consistent
                conf=0.15,          # lower confidence to catch smaller/faint victims
                iou=0.3,            # lower IoU to separate overlapping boxes
                device=device,
                verbose=False,
                tracker="bytetrack.yaml"  # or any other tracker config
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
                    # Scale back coordinates if image was upscaled
                    x1 /= scale_factor
                    y1 /= scale_factor
                    x2 /= scale_factor
                    y2 /= scale_factor

                    victims.append({
                        "id": int(track_id),
                        "x1": float(x1),
                        "y1": float(y1),
                        "x2": float(x2),
                        "y2": float(y2),
                        "confidence": float(conf_score)
                    })

            await websocket.send_text(json.dumps({
                "victims": victims,
                "image_width": img_w,
                "image_height": img_h
            }))

    except WebSocketDisconnect:
        print("Client disconnected")