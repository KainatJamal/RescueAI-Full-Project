from fastapi import FastAPI, UploadFile
import shutil
from backend.VisDrone_convert import detect_humans

app = FastAPI()

@app.post("/detect")
async def detect(file: UploadFile):
    with open("temp.jpg", "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    detections = detect_humans("temp.jpg")

    return {
        "status": "success",
        "humans_detected": len(detections),
        "detections": detections
    }
