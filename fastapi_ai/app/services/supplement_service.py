from concurrent.futures import ThreadPoolExecutor, as_completed
import os
import requests
from dotenv import load_dotenv
from langchain_openai import ChatOpenAI
from langchain_core.prompts import PromptTemplate
from langchain_core.output_parsers import StrOutputParser

# ✅ 환경변수 로드
load_dotenv()
NAVER_CLIENT_ID = os.getenv("NAVER_CLIENT_ID")
NAVER_CLIENT_SECRET = os.getenv("NAVER_CLIENT_SECRET")

# ✅ LLM 설정
llm_exaone = ChatOpenAI(
    base_url="http://192.168.0.90:1234/v1",
    api_key="lm-studio",
    model="gemma-2-2b-it",
    temperature=0.7
)

# ✅ 키워드 추출 체인
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

# ✅ 네이버 쇼핑 API 호출
def fetch_naver_shopping(keyword: str, display: int = 3) -> list:
    url = "https://openapi.naver.com/v1/search/shop.json"
    headers = {
        "X-Naver-Client-Id": NAVER_CLIENT_ID,
        "X-Naver-Client-Secret": NAVER_CLIENT_SECRET
    }
    params = {
        "query": keyword,
        "display": display,
        "sort": "sim"
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

# ✅ 병렬 호출로 여러 키워드 처리
def get_products_by_keywords(keywords: list, max_results: int = 3) -> list:
    results = []
    with ThreadPoolExecutor(max_workers=5) as executor:
        futures = [executor.submit(fetch_naver_shopping, kw, max_results) for kw in keywords]
        for future in as_completed(futures):
            try:
                results.extend(future.result())
            except Exception as e:
                print("❌ 병렬 처리 중 오류:", e)
    return results

# ✅ 제품 정보 포맷팅 (HTML용)
def format_product_info(items: list) -> str:
    info = ""
    for item in items:
        title = item.get("title", "")
        link = item.get("link", "")
        lprice = item.get("lprice", "0")
        mall = item.get("mallName", "")
        info += f"📦 <strong>{title}</strong><br>💰 가격: {lprice}원<br>🛍 판매처: {mall}<br><a href='{link}' target='_blank'>제품보기</a><br>" + ("-" * 30) + "<br>"
    return info

# ✅ 프롬프트 길이 제한
def safe_prompt(prompt: str, max_chars: int = 1000) -> str:
    return prompt[:max_chars] if len(prompt) > max_chars else prompt

# ✅ 개선된 프롬프트 생성 함수
def create_prompt(user_question: str, product_info: str, health_info: dict = None) -> str:
    health_summary = ""
    if health_info:
        health_summary = f"""
[사용자 건강 상태 분석]
- 예측된 건강 점수는 {health_info.get('score')}점이며,
- 전반적인 위험 수준은 "{health_info.get('risk')}"로 분류됩니다.
- 주요 영향 요인은 {', '.join(health_info.get('top_features', []))}입니다.
- AI 분석 결과: {health_info.get('explanation')}

💡 위 건강 정보를 바탕으로 사용자의 건강을 개선하기 위한 맞춤형 기능성 성분 또는 영양제를 추천하세요.
특히 사용자의 약점이나 위험군과 관련된 기능을 보완하는 제품이 우선적으로 고려되어야 합니다.
"""

    return safe_prompt(f"""
{health_summary}

[사용자 질문]
{user_question}

[관련 제품 정보]
{product_info}

📝 출력 형식:
- 먼저 사용자의 건강 상태에 대해 한두 문장으로 요약하고,
- 그 상태에 적합한 영양제를 HTML 형식으로 추천하세요.
- 각 제품은 다음 정보를 포함해야 합니다:
  📦 제품명, 💰 가격, 🛍 판매처, 🔗 제품 링크
- 각 제품은 <p> 태그로 구분하고, 줄바꿈은 <br> 태그로 표현
- 마지막에 😊 건강 응원 메시지 한 줄 포함
""")

# ✅ 전체 응답 생성
def generate_supplement_response(user_question: str, health_info: dict = None) -> str:
    keywords = extract_keywords(user_question)
    print(f"🔍 추출된 키워드: {keywords}")

    # 🧠 건강 분석 요청 여부 판별
    analysis_keywords = ["건강 분석", "건강점수", "위험도", "건강 상태", "내 건강", "나의 건강", "건강 해석"]
    if any(k in user_question for k in analysis_keywords):
        # 분석 전용 프롬프트 구성
        return generate_health_analysis_response(user_question, health_info)

    # 기본 추천 프로세스
    if not keywords:
        return "❗ 건강 관련 키워드를 찾지 못했습니다. 다시 질문해 주세요."

    products = get_products_by_keywords(keywords)
    product_info = format_product_info(products)
    prompt = create_prompt(user_question, product_info, health_info)

    print("🧾 최종 프롬프트:\n", prompt)
    response = llm_exaone.invoke(prompt)
    return response.content
def generate_health_analysis_response(user_question: str, health_info: dict) -> str:
    if not health_info:
        return "❗ 예측된 건강 정보가 없습니다. 먼저 건강 점수를 분석해주세요."

    prompt = f"""
📋 [사용자 건강 정보]
- 건강 점수: {health_info.get('score')}점
- 위험 수준: {health_info.get('risk')}
- 주요 영향 요인: {', '.join(health_info.get('top_features', []))}
- AI 해석: {health_info.get('explanation')}

위 건강 데이터를 바탕으로 건강 상태를 전문가처럼 설명해 주세요.
❗ 단순 나열이 아닌, 분석과 해석을 포함해 사용자가 이해하기 쉽게 알려 주세요.
또한, 건강 상태에 맞는 주요 기능성 성분(예: 심혈관 건강, 항산화 등)을 추천해 주세요.

그리고 해당 기능에 맞는 영양제를 2~3개 추천해 주세요.
제품은 HTML 형식으로 제공하며, 다음 정보를 포함해야 합니다:

📝 출력 형식:
- 1~2 문단으로 건강 상태 설명
- 추천하는 기능성 이유 설명
- 제품은 <p>로 구분하며, 각 항목에 다음 정보 포함:
  📦 제품명, 💰 가격, 🛍 판매처, 🔗 링크 (<br> 사용)
- 마지막에 😊 건강 응원 멘트 한 줄 포함
"""

    print("🧾 건강 분석 프롬프트 (한국어):\n", prompt)
    response = llm_exaone.invoke(prompt)
    return response.content


