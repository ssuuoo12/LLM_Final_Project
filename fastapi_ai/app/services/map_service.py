# map_service.py (FastAPI 서비스 로직)
import mysql.connector
import requests

LM_API_URL = "http://192.168.0.38:1234/v1/chat/completions"
HEADERS = {
    "Content-Type": "application/json",
    "Authorization": "Bearer no-key"
}

def save_chat_message(user_id: str, role: str, content: str):
    conn = mysql.connector.connect(
        host="223.26.253.91",
        user="nask8543",
        password="tnsrb0313!",
        database="test"
    )
    cursor = conn.cursor()
    sql = "INSERT INTO map_history (user_id, role, content) VALUES (%s, %s, %s)"
    cursor.execute(sql, (user_id, role, content))
    conn.commit()
    cursor.close()
    conn.close()

def get_chat_history_db(user_id: str):
    conn = mysql.connector.connect(
        host="223.26.253.91",
        user="nask8543",
        password="tnsrb0313!",
        database="test"
    )
    cursor = conn.cursor()
    sql = "SELECT role, content, created_at FROM map_history WHERE user_id = %s ORDER BY created_at"
    
    # print(f"🔍 쿼리: {sql} → user_id={user_id}")  # ✅ 로그 찍기

    cursor.execute(sql, (user_id,))
    result = cursor.fetchall()

    # print(f"📦 쿼리 결과 개수: {len(result)}")  # ✅ 확인용
    # for r in result:
    #     print(r)

    cursor.close()
    conn.close()
    return result


def get_place_recommendation(user_id: str, user_input: str) -> str:
    # 대화 이력 불러오기
    history = get_chat_history_db(user_id)
    messages = [
    {
        "role": "system",
        "content": (
            "너는 장소 추천을 도와주는 어시스턴트야. 사용자가 이전 대화에서 말한 인물, 장소, 지시어(예: '거기', '그곳', '그의')는 "
            "항상 바로 직전 대화 내용과 연결지어서 이해해야 해. 즉, 대화의 흐름을 유지하며 사용자 의도를 맥락 속에서 파악해야 해.\n\n"
            "또한 장소에 대한 질문이라면 주소, 특징, 관련 정보 등을 정확히 요약해서 알려줘. 불필요하게 개인정보로 오해하지 마.\n\n"
            "응답은 1~2문장 이내로 간결하고 명확하게 해줘."
        )
    }
]

    recent_history = history[-4:]
    for role, content, _ in recent_history:
    # 새로운 질문 추가
        messages.append({"role": "user", "content": user_input})

    payload = {
        "model": "exaone-3.0-7.8b-instruct",
        "messages": messages,
        "temperature": 0.5,
        "max_tokens": 300,
        "top_p": 0.9
    }

    try:
        response = requests.post(LM_API_URL, headers=HEADERS, json=payload)
        result = response.json()

        if "choices" not in result or not result["choices"]:
            return f"\u274c LM 응답 오류: {result}"

        reply = result["choices"][0]["message"]["content"].strip()

        # DB에 저장
        save_chat_message(user_id, "user", user_input)
        save_chat_message(user_id, "assistant", reply)

        return reply

    except Exception as e:
        return f"\u274c 예외 발생: {e}"
