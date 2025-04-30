from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import List
from app.services.Diet_services import DietService
import logging


logging.basicConfig(level=logging.INFO)
router = APIRouter()

# ✅ DietService 인스턴스 생성
diet_service = DietService(csv_path="app/dataset/Diet.csv")

# 요청/응답 모델
class DietRequest(BaseModel):
    disease: str
    meal_time: str

class DietResponse(BaseModel):
    recommend: str
    allowed: str
    restricted: str

@router.post("", response_model=DietResponse)
async def recommend_diet(request: DietRequest):
    logging.info(f"📥 POST /recommend 호출됨")
    logging.info(f"🧾 요청 받은 질병: {request.disease}")
    logging.info(f"🕒 요청 받은 식사시간: {request.meal_time}")

    result = diet_service.get_diet_info(request.disease, request.meal_time)

    if "error" in result:
        logging.warning("❌ 추천 결과 없음")
        raise HTTPException(status_code=404, detail=result["error"])

    logging.info(f"📤 추천 결과 반환: {result}")
    return DietResponse(
        recommend=result["recommend"],
        allowed=result["allowed"],
        restricted=result["restricted"]
    )
