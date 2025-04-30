# 송이
from fastapi import APIRouter, Form,Depends
from app.services.supplement_service import generate_supplement_response
from app.model.models import SupChatHistory
from sqlalchemy.orm import Session
from app.database.database import SessionLocal
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder
from pydantic import conint
from app.services.user_health_memory import user_health_info_store
# 송이 추가 2025-04-22
router = APIRouter()
# ✅ DB 세션 의존성 주입
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
@router.post("/recommend")
async def recommend_supplement(
    question: str = Form(...),
    user_id: int = Form(...),
    db: Session = Depends(get_db)
):
    print("✅ 질문 수신:", question)
    try:
        health_info = user_health_info_store.get(user_id)  # 🔍 건강 정보 조회
        response = generate_supplement_response(question, health_info)


        # ✅ DB 저장
        chat = SupChatHistory(
            user_id=user_id,
            question=question,
            response=response
        )
        db.add(chat)
        db.commit()
        db.refresh(chat)

        print("✅ 저장 및 응답 완료")
        return {"response": response}
    except Exception as e:
        print("❌ 예외 발생:", str(e))
        return {"response": f"❌ 오류 발생: {str(e)}"}


# 대화이력
@router.get("/history/{user_id}")
def get_chat_history(user_id: int, page: int = 1, size: int = 5, db: Session = Depends(get_db)):
    offset = (page - 1) * size
    query = db.query(SupChatHistory).filter(SupChatHistory.user_id == user_id)
    total_count = query.count()
    total_pages = (total_count + size - 1) // size
    history = query.order_by(SupChatHistory.created_at.desc()).offset(offset).limit(size).all()

    result = [
        {
            "question": item.question,
            "response": item.response,
            "created_at": item.created_at.isoformat()
        }
        for item in history
    ]
    print("▶ FastAPI 응답 데이터:", {
    "history": result,
    "total_pages": total_pages
})
    return JSONResponse(content={
        "history": result,
        "total_pages": total_pages
    })