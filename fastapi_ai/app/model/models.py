from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Float,func,BigInteger, Boolean,Text
from app.database.database import Base
from sqlalchemy.orm import relationship

class HealthScore(Base):
    __tablename__ = "HealthScore"

    file_id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    file_name = Column(String(100), nullable=False)
    score = Column(Float(precision=2), nullable=True)
    risk_level = Column(String(40), nullable=True)
    reg_date = Column(DateTime(timezone=True), server_default=func.now())
    # ✅ 외래키 컬럼 추가
    user_id = Column(BigInteger, ForeignKey("user.id"), nullable=False)
class User(Base):
    __tablename__ = "user"

    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(String(255), unique=True, nullable=False)
    password = Column(String(255), nullable=False)
    user_name = Column(String(255))
    gender = Column(String(255))
    email = Column(String(255), unique=True)
    role = Column(String(255))
    provider = Column(String(255))
    provider_id = Column(String(255))
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())
    force_change = Column(Boolean, default=False)
# 송이 추가 2025-04-22
class SupChatHistory(Base):
    __tablename__ = "sup_chat_history"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(BigInteger, ForeignKey("user.id"), nullable=False)  # ✅ 외래키와 타입 일치
    question = Column(Text, nullable=False)
    response = Column(Text, nullable=False)
    created_at = Column(DateTime, default=func.now())