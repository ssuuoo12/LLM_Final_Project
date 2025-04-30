import os
import json
import pickle
import pandas as pd
import random
from sqlalchemy import create_engine, text
from langchain_ollama import ChatOllama
from langchain_community.embeddings import HuggingFaceEmbeddings
from langchain_community.vectorstores import FAISS
from langchain.schema import Document
from tqdm import tqdm

# DB 연결 설정
DB_URL = "mysql+pymysql://nask8543:tnsrb0313!@223.26.253.91:3306/test"
engine = create_engine(DB_URL)

# 임베딩 모델과 LLM 정의
embedding_model = HuggingFaceEmbeddings(model_name="sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2")
llm = ChatOllama(model="gemma3")

# 질문-답변 쌍 로딩 함수 (샘플링 적용)
def load_medical_qa_qa_pairs(sample_limit=50000):
    question_base = "app/dataset/medical_qa/question"
    answer_base = "app/dataset/medical_qa/answer"

    print("📥 질문 파일 로딩 시작...")
    q_map = {}
    question_files = []
    for root, _, files in os.walk(question_base):
        for file in files:
            if file.endswith(".json"):
                question_files.append(os.path.join(root, file))
    random.shuffle(question_files)

    for q_file in tqdm(question_files, desc="📄 질문 파일 처리 중"):
        try:
            with open(q_file, "r", encoding="utf-8") as f:
                q_data = json.load(f)
                key = (
                    q_data.get("disease_category", ""),
                    q_data.get("disease_name", {}).get("kor", ""),
                    q_data.get("intention", "")
                )
                question = q_data.get("question", "").strip()
                if question:
                    q_map.setdefault(key, []).append(question)
        except Exception as e:
            print(f"질문 파일 오류: {q_file} - {e}")

    print(f"질문 파일 처리 완료: {sum(len(v) for v in q_map.values()):,}건")

    print("답변 파일 로딩 시작...")
    qa_pairs = []
    answer_files = []
    for root, _, files in os.walk(answer_base):
        for file in files:
            if file.endswith(".json"):
                answer_files.append(os.path.join(root, file))
    random.shuffle(answer_files)

    for a_file in tqdm(answer_files, desc="🧾 답변 파일 처리 중"):
        if len(qa_pairs) >= sample_limit:
            break

        try:
            with open(a_file, "r", encoding="utf-8") as f:
                a_data = json.load(f)
                key = (
                    a_data.get("disease_category", ""),
                    a_data.get("disease_name", {}).get("kor", ""),
                    a_data.get("intention", "")
                )
                answer_parts = a_data.get("answer", {})
                answer_text = " ".join([answer_parts.get(k, "") for k in ["intro", "body", "conclusion"]]).strip()

                questions = q_map.get(key, [])
                for q in questions:
                    if q and answer_text:
                        qa_pairs.append((q, answer_text))
                        if len(qa_pairs) >= sample_limit:
                            break
        except Exception as e:
            print(f"답변 파일 오류: {a_file} - {e}")

    print(f"샘플링된 질문-답변 쌍: {len(qa_pairs):,}개")
    return qa_pairs

# FAISS 병합 수동 구현 함수
def manual_merge_vectorstores(vectorstores):
    if not vectorstores:
        return None
    base = vectorstores[0]
    for vs in vectorstores[1:]:
        base.merge_from(vs)
    return base

def load_medical_vectorstore():
    path = "app/vector_index/medical_faiss_store_sample"
    if os.path.exists(path):
        print(f"medical vectorstore 로드 중: {path}")
        return FAISS.load_local(path, embeddings=embedding_model, allow_dangerous_deserialization=True)
    print("medical vectorstore가 존재하지 않습니다.")
    return None

# 보험 벡터 인덱스 로드
def load_insurance_vectorstore():
    path = "app/vector_index/insurance_faiss_store"
    return FAISS.load_local(path, embeddings=embedding_model, allow_dangerous_deserialization=True)

# 벡터스토어 선택 (source 기반)
def load_vectorstore(source: str):
    if source == "insurance":
        return load_insurance_vectorstore()
    elif source == "medical":
        return load_medical_vectorstore()
    else:
        raise ValueError("지원되지 않는 source입니다 (insurance / medical)")

# RAG + LLM 기반 답변 생성
prompt_template = """
당신은 친절한 건강 상담 AI입니다. 아래 참고 정보를 기반으로 사용자 질문에 정확하고 부드럽게 답해주세요.

[참고 정보]
{context}

[질문]
{question}

[답변]
"""

def ask_llm(user_id: str, message: str, source: str = "medical") -> str:
    print("🤖 RAG 기반 답변 생성 중...")
    vectorstore = load_vectorstore(source)
    docs = vectorstore.similarity_search(message, k=3) if vectorstore else []

    # medical에서 못 찾으면 insurance로 fallback
    if not docs and source == "medical":
        print("🔄 medical에서 결과 없음 → insurance fallback")
        vectorstore = load_vectorstore("insurance")
        docs = vectorstore.similarity_search(message, k=3) if vectorstore else []

    if docs:
        context = "\n".join([
            doc.page_content + "\n" + doc.metadata.get("answer", "") 
            for doc in docs
        ])
        prompt = prompt_template.format(context=context, question=message)
        raw = llm.invoke(prompt)
    else:
        print("유사 문서 없음 → LLM 단독 응답")
        raw = llm.invoke(message)

    # 핵심: content만 추출
    answer = raw.content if hasattr(raw, "content") else str(raw)

    save_chat_history(user_id, message, answer)
    return answer


# 채팅 이력 저장
def save_chat_history(user_id: str, question: str, answer: str):
    question = question.strip().lower()
    answer = answer.strip().lower()
    
    with engine.connect() as conn:
        result = conn.execute(
            text("SELECT COUNT(*) FROM chat_history WHERE user_id=:user_id AND LOWER(TRIM(message))=:message AND LOWER(TRIM(response))=:response"),
            {"user_id": user_id, "message": question, "response": answer}
        )
        count = result.scalar()
        if count == 0:
            conn.execute(
                text("INSERT INTO chat_history (user_id, message, response) VALUES (:user_id, :message, :response)"),
                {"user_id": user_id, "message": question, "response": answer}
            )
            conn.commit()
            print("채팅 이력 저장 완료")
        else:
            print("이미 존재하는 이력 - 저장 생략")


# ✅ FAISS 인덱스 생성 함수 (insurance / medical)
'''
def build_faiss_store(source: str):
    if source == "insurance":
        df = pd.read_csv("app/dataset/insurance_qar.csv")
        qa_pairs = [(row["question"], row["answer"] + " 추천상품: " + row["recommended_product"]) for _, row in df.iterrows()]
        print(f"🔍 {source} 질문 {len(qa_pairs):,}건 임베딩 시작...")
        docs = [Document(page_content=q, metadata={"answer": a}) for q, a in tqdm(qa_pairs, desc="📄 문서 변환 중")]
        vectorstore = FAISS.from_documents(docs, embedding_model)
        save_path = f"app/vector_index/{source}_faiss_store"
        vectorstore.save_local(save_path)
        with open(f"app/vector_index/questions_{source}.pkl", "wb") as f:
            pickle.dump(qa_pairs, f)
        print(f"보험 벡터 인덱스 저장 완료: {save_path}")

    elif source == "medical":
        qa_pairs = load_medical_qa_qa_pairs(sample_limit=50000)
        print(f"🔍 {source} 질문 {len(qa_pairs):,}건 임베딩 시작...")
        docs = [Document(page_content=q, metadata={"answer": a}) for q, a in tqdm(qa_pairs, desc="📄 문서 변환 중 (샘플)")]
        vectorstore = FAISS.from_documents(docs, embedding_model)
        save_path = f"app/vector_index/{source}_faiss_store_sample"
        vectorstore.save_local(save_path)
        with open(f"app/vector_index/questions_{source}_sample.pkl", "wb") as f:
            pickle.dump(qa_pairs, f)
        print(f"의료 샘플 벡터 인덱스 저장 완료: {save_path}")

    else:
        raise ValueError("지원되는 source는 'insurance' 또는 'medical'입니다.")
        '''