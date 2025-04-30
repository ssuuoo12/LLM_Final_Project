# init_faiss.py
from app.routers.llm_service import build_faiss_store

if __name__ == "__main__":
    build_faiss_store("insurance")
    build_faiss_store("medical")
    print("✅ 보험 & 의료 벡터 인덱스 생성 완료!")