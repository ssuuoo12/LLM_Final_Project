# 송이
from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime


# 응답용 모델 (Spring Boot에서 결과 요청 시 사용하는 구조)
class HealthScoreResponse(BaseModel):
    fileName: str
    score: float
    risk: str
    