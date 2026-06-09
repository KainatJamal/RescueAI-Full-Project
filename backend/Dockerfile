# ===========================
# Base Image
# ===========================
FROM python:3.10-slim

# ===========================
# Set working directory
# ===========================
WORKDIR /app

# ===========================
# Install minimal system dependencies
# ===========================
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 \
    libglib2.0-0 \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# ===========================
# Copy all files including .env
# ===========================
COPY . /app

# ===========================
# Upgrade pip
# ===========================
RUN pip install --upgrade pip

# ===========================
# Install CPU-only PyTorch first
# ===========================
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# ===========================
# Install FastAPI, Uvicorn, OpenCV, and multipart
# ===========================
RUN pip install fastapi uvicorn[standard] opencv-python-headless python-multipart

# ===========================
# Install Ultralytics (YOLO) without dependencies
# ===========================
RUN pip install ultralytics[all] 

# ===========================
# Install remaining dependencies used in your backend
# ===========================
RUN pip install azure-storage-blob python-dotenv pillow numpy

# ===========================
# Expose the port the app runs on
# ===========================
EXPOSE 8000

# ===========================
# Start the FastAPI app
# ===========================
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]