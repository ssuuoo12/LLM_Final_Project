from concurrent.futures import ThreadPoolExecutor, as_completed
import os
import requests
from dotenv import load_dotenv
from langchain_openai import ChatOpenAI
from langchain_core.prompts import PromptTemplate
from langchain_core.output_parsers import StrOutputParser
# 송이 추가 2025-04-22
# ✅ 환경변수 로드
load_dotenv()
NAVER_CLIENT_ID = os.getenv("NAVER_CLIENT_ID")
NAVER_CLIENT_SECRET = os.getenv("NAVER_CLIENT_SECRET")

# ✅ LLM 설정 (Exaone 모델 사용)
llm_exaone = ChatOpenAI(
    base_url="http://192.168.0.90:1234/v1",
    api_key="lm-studio",
    model="gemma-2-2b-it",
    temperature=0.7
)

# ✅ 키워드 추출 체인 구성
prompt_template = PromptTemplate.from_template("""
다음은 사용자의 건강 관련 질문입니다.  
질문에서 **영양제 제품명 또는 건강기능 키워드**만 추출하여 **쉼표로 구분된 리스트** 형태로 응답하세요.

❗ 아래 조건을 지켜야 합니다:
- **한 단어 또는 두 단어로만** 추출
- **기능성 또는 성분명 중심** (예: 비타민, 유산균, 오메가3, 면역력, 장 건강 등)
- **추가 설명은 하지 마세요**, 키워드 리스트만 출력

예시:
- 입력: 피로 회복에 좋은 영양제 추천해줘  
  출력: 피로, 영양제  
- 입력: 유산균 제품 추천해줘  
  출력: 유산균  
- 입력: 면역력 높이는 비타민 추천  
  출력: 면역력, 비타민

입력: {question}
출력:
""")

parser = StrOutputParser()
keyword_chain = prompt_template | llm_exaone | parser

# ✅ 키워드 추출 함수
def extract_keywords(question: str) -> list:
    result = keyword_chain.invoke({"question": question})
    return [k.strip() for k in result.split(",") if k.strip()]

# ✅ 네이버 쇼핑 API 호출 함수
def fetch_naver_shopping(keyword: str, display: int = 3) -> list:
    url = "https://openapi.naver.com/v1/search/shop.json"
    headers = {
        "X-Naver-Client-Id": NAVER_CLIENT_ID,
        "X-Naver-Client-Secret": NAVER_CLIENT_SECRET
    }
    params = {
        "query": keyword,
        "display": display,
        "sort": "sim"  # 또는 "date", "asc", "dsc" 등
    }
    try:
        res = requests.get(url, headers=headers, params=params)
        if res.status_code == 200:
            return res.json().get("items", [])
        else:
            print("❌ 네이버 API 오류:", res.status_code)
    except Exception as e:
        print(f"❌ 요청 실패: {e}")
    return []

# ✅ 병렬 호출 처리 함수
def get_products_by_keywords(keywords: list, max_results: int = 3) -> list:
    results = []
    with ThreadPoolExecutor(max_workers=5) as executor:
        futures = [executor.submit(fetch_naver_shopping, keyword, max_results) for keyword in keywords]
        for future in as_completed(futures):
            try:
                items = future.result()
                results.extend(items)
            except Exception as e:
                print("❌ 병렬 처리 중 오류:", e)
    return results

# ✅ 제품 정보 포맷팅 (네이버 기준)
def format_product_info(items: list) -> str:
    info = ""
    for item in items:
        title = item.get("title", "")
        link = item.get("link", "")
        lprice = item.get("lprice", "0")
        mallName = item.get("mallName", "")
        info += f"📦 <strong>{title}</strong><br>💰 가격: {lprice}원<br>🛍 판매처: {mallName}<br><a href='{link}' target='_blank'>제품보기</a><br>" + ("-" * 30) + "<br>"
    return info

# ✅ 프롬프트 길이 안전 처리
def safe_prompt(prompt: str, max_chars: int = 1000) -> str:
    return prompt[:max_chars] if len(prompt) > max_chars else prompt

# ✅ 프롬프트 생성 함수
def create_prompt(user_question: str, product_info: str) -> str:
    return safe_prompt(f"""
아래는 네이버 쇼핑 API를 통해 검색된 영양제 정보입니다. 
이 정보를 바탕으로 사용자의 질문에 HTML 형식으로 정답을 생성하세요.

[제품 정보]
{product_info}

[사용자 질문]
{user_question}

📝 반드시 다음 항목을 포함하세요:
- 📦 <strong>제품명</strong>
- 💰 <strong>가격</strong>
- 🛍 <strong>판매처</strong>
- 🔗 <strong>제품 링크</strong>

📌 출력 조건:
- 각 제품은 <p>로 구분
- 항목마다 줄바꿈(<br>) 적용
- 마지막에 😊 건강을 위한 간단한 마무리 문장 포함
""")

# ✅ 전체 응답 생성 함수
def generate_supplement_response(user_question: str) -> str:
    keywords = extract_keywords(user_question)
    print(f"🔍 추출된 키워드: {keywords}")

    if not keywords:
        return "❗ 건강 관련 키워드를 찾지 못했습니다. 다시 질문해 주세요."

    items = get_products_by_keywords(keywords)
    product_info = format_product_info(items)
    prompt = create_prompt(user_question, product_info)
    print("🧾 생성된 프롬프트:\n", prompt)
    response = llm_exaone.invoke(prompt)
    return response.content