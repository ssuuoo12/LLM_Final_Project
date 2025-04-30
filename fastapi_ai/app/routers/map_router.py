from fastapi import APIRouter
from pydantic import BaseModel
from app.services.map_service import get_place_recommendation, get_chat_history_db

router = APIRouter()

# 사용자 요청 형식
class Query(BaseModel):
    user_id: str
    message: str

# 챗봇 응답
@router.post("/recommend2")
def recommend_place(query: Query):
    reply = get_place_recommendation(query.user_id, query.message)
    return {"response": reply}

# 대화 이력 조회
@router.get("/history/{user_id}")
def get_history(user_id: str):
    history = get_chat_history_db(user_id)
    return [{"role": role, "content": content, "timestamp": str(ts)} for role, content, ts in history]
