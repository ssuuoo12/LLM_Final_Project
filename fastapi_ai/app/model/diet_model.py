# 1. app/model/diet_model_loader.py
import pickle
from sqlalchemy import Column, BigInteger, String, Text, DateTime
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime

class DietModelLoader:
    def __init__(self, model_path='meal_model.pkl'):
        try:
            with open(model_path, 'rb') as f:
                self.model, self.vectorizer, self.label_encoder = pickle.load(f)
        except Exception as e:
            print("모델 로드 실패:", e)
            self.model, self.vectorizer, self.label_encoder = None, None, None

    def get_model_components(self):
        return self.model, self.vectorizer, self.label_encoder


Base = declarative_base()

class ChatHistory(Base):  # ✅ Base 상속 필수
    __tablename__ = "chat_history"

    id = Column(BigInteger, primary_key=True, autoincrement=True)
    user_id = Column(String(100), nullable=False)
    message = Column(Text, nullable=False)
    response = Column(Text, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
