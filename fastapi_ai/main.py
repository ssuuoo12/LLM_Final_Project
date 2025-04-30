import uvicorn
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers.predict import router as predict_router
from app.routers import predict_songyi
from app.routers import supplement_router
from app.routers.map_router import router as map_router
from app.routers.image_router import router as image_router
from app.database.database import Base, engine
from fastapi import FastAPI, File, UploadFile
from fastapi.responses import JSONResponse
from io import BytesIO
from PIL import Image, ImageDraw, ImageFont
import numpy as np
import tensorflow as tf
import base64
import os
import mysql.connector
from datetime import datetime
from fastapi import Form
from typing import Optional
from pydantic import BaseModel
from app.services.diet_model_loader import model_loader
from app.routers import Diet_routers

# 데이터베이스 테이블 생성
Base.metadata.create_all(bind=engine)
app = FastAPI()

# CORS 허용 설정
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 배포시 특정 도메인으로 제한 가능
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 라우터 등록
app.include_router(predict_router, prefix="/chat")
app.include_router(supplement_router.router, prefix="/supplement", tags=["supplement"])
app.include_router(predict_songyi.router, prefix="/predict_songyi", tags=["Prediction"])
app.include_router(image_router, prefix="", tags=["image"])
app.include_router(map_router, prefix="/mapc", tags=["mapc"])
app.include_router(Diet_routers.router, prefix="/diet")

@app.get("/")
def root():
    return {"message": "LLM 챗봇 실행 중"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)