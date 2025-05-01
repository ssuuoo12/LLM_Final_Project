from concurrent.futures import ThreadPoolExecutor, as_completed
import os
import requests
from dotenv import load_dotenv
from langchain_openai import ChatOpenAI
from langchain_core.prompts import PromptTemplate
from langchain_core.output_parsers import StrOutputParser

# ✅ 환경 변수 로드
load_dotenv()
NAVER_CLIENT_ID = os.getenv("NAVER_CLIENT_ID")
NAVER_CLIENT_SECRET = os.getenv("NAVER_CLIENT_SECRET")

# ✅ LLM 초기화
llm = ChatOpenAI(
    base_url="http://192.168.0.90:1234/v1",
    api_key="lm-studio",
    model="gemma-2-2b-it",
    temperature=0.7
)

# ✅ 키워드 추출용 체인
prompt_template = PromptTemplate.from_template("""
다음은 사용자의 건강 관련 질문입니다.
질문에서 **영양제 제품명 또는 건강기능 키워드**만 추출하여 **쉼표로 구분된 리스트** 형태로 응답하세요.
- 예: 비타민, 유산균
입력: {question}
출력:
""")
parser = StrOutputParser()
keyword_chain = prompt_template | llm | parser

def extract_keywords(question: str) -> list:
    result = keyword_chain.invoke({"question": question})
    return [k.strip() for k in result.split(",") if k.strip()]

def fetch_naver_shopping(keyword: str, display: int = 3) -> list:
    url = "https://openapi.naver.com/v1/search/shop.json"
    headers = {
        "X-Naver-Client-Id": NAVER_CLIENT_ID,
        "X-Naver-Client-Secret": NAVER_CLIENT_SECRET
    }
    params = {"query": keyword, "display": display, "sort": "sim"}
    try:
        res = requests.get(url, headers=headers, params=params)
        if res.status_code == 200:
            return res.json().get("items", [])
    except Exception as e:
        print("❌ 요청 실패:", e)
    return []

def get_products_by_keywords(keywords: list, max_results: int = 3) -> list:
    results = []
    with ThreadPoolExecutor(max_workers=5) as executor:
        futures = [executor.submit(fetch_naver_shopping, kw, max_results) for kw in keywords]
        for future in as_completed(futures):
            try:
                results.extend(future.result())
            except Exception as e:
                print("❌ 병렬 처리 오류:", e)
    return results

def format_product_info(items: list) -> str:
    info = ""
    for item in items:
        title = item.get("title", "").strip()
        link = item.get("link", "").strip().replace(" ", "")
        lprice = item.get("lprice", "0").strip()
        mall = item.get("mallName", "").strip()
        try:
            price = f"{int(float(lprice)):,}"
        except:
            price = lprice
        info += f"""
        <p>
        🏦 <strong>{title}</strong><br>
        💰 가격: {price}원<br>
        🏍 판매차: {mall}<br>
        🔗 <a href=\"{link}\" target=\"_blank\">제품보기</a>
        </p>
        <hr style='border: 0; border-top: 1px dashed #ccc; margin: 1rem 0;'>
        """
    return info

# ✅ 건강 상태 기반 추천 키워드 생성
def generate_condition_based_keywords(health_info: dict) -> list:
    score = health_info.get("score", 0)
    top_features = [f.lower() for f in health_info.get("top_features", [])]
    keywords = set()
    if score < 50:
        if "협염" in top_features:
            keywords.add("포 건강")
        if "향승" in top_features or "수출기협염" in top_features:
            keywords.add("협염 조절")
        if "향당" in top_features:
            keywords.add("향당 관리")
        keywords.add("멈종력")
    elif score < 70:
        if "간" in top_features:
            keywords.add("간 건강")
        if "음주" in top_features:
            keywords.add("간 기능")
        if "체중" in top_features:
            keywords.add("다이어트")
        keywords.add("피로회복")
    else:
        keywords.add("스트레스 완화")
        keywords.add("수면 보조")
    return list(keywords)

def generate_health_analysis(health_info: dict) -> str:
    # LLM 기반 조언 문장 생성
    prompt = f"""
    사용자의 건강 점수: {health_info.get("score")}점
    위험 수준: {health_info.get("risk")}
    주요 요인: {', '.join(health_info.get('top_features', []))}
    AI 해석: {health_info.get("explanation")}

    위 정보를 기반으로:
    - 건강 상태 해석
    - 생활 습관 개선 조언 2~3가지
    - HTML로 출력 (<br> 및 <ul><li> 사용)
    """
    try:
        summary_html = llm.invoke(prompt).content
    except:
        summary_html = "<p>⚠️ 요약 생성 실패</p>"

    # 추가 제품 추천
    condition_keywords = generate_condition_based_keywords(health_info)
    condition_products = get_products_by_keywords(condition_keywords)
    condition_product_html = format_product_info(condition_products)

    return f"""
    <div style='font-family: Noto Sans KR; line-height: 1.6;'>
        <h3>🧠 AI 건강 분석 및 조언</h3>
        {summary_html}

        <h3>💊 건강 상태 기반 추천 제품</h3>
        {condition_product_html}

        <p style='font-style: italic;'>😊 건강을 위해 노력하는 당신을 응원합니다!</p>
    </div>
    """

def generate_supplement_response(question: str, health_info: dict = None) -> str:
    keywords = extract_keywords(question)
    if not keywords:
        return "❗ 키워드가 추출되지 않았습니다. 다시 질문해 주세요."

    if any(k in question for k in ["건강 분석", "건강점수", "위험도", "상태", "해석"]):
        return generate_health_analysis(health_info)
    else:
        products = get_products_by_keywords(keywords)
        product_info = format_product_info(products)
        prompt = f"""
        사용자 질문: {question}

        추천 제품 정보:
        {product_info}

        HTML 형식으로 응답 생성
        """
        return llm.invoke(prompt).content