from fastapi import APIRouter
from pydantic import BaseModel
from .llm_service import ask_llm

router = APIRouter()

class ChatRequest(BaseModel):
    user_id: str
    message: str

@router.post("/chat")
async def chat_with_bot(request: ChatRequest):
    raw_answer = ask_llm(request.user_id, request.message)
    
    # ✅ 텍스트만 추출
    if hasattr(raw_answer, "content"):
        clean_answer = raw_answer.content
    else:
        clean_answer = str(raw_answer)
    
    return {"response": clean_answer}

