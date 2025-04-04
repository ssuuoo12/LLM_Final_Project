# LLM 기반 헬스케어 & 인슈테크 시스템

FastAPI + Spring Boot 기반 챗봇 시스템으로, 사용자의 증상 입력을 바탕으로 질병을 유추하고 해당 질병에 적합한 보험 상품을 추천하는 서비스입니다.

---

## 주요 기능

- 회원가입 / 로그인 (Spring Security)
- 증상 기반 챗봇 상담 (FastAPI + LangChain)
- 이미지 기반 피부 질환 판단 (AI 모델)
- 보험 추천 시스템 (CSV 기반 매핑)
- JSP 기반 마이페이지 / 게시판

---

## 기술 스택

| 영역       | 기술 |
|------------|------|
| 프론트     | JSP, HTML, CSS |
| 백엔드     | Spring Boot, FastAPI |
| AI         | Python, LangChain, PyTorch |
| DB/파일    | CSV, SQLite (또는 MySQL 예정) |
| 배포       | Localhost (시연용) |

---

## 실행 방법

### FastAPI 서버 실행 (VSCode)

```bash
cd fastapi_ai
uvicorn main:app --reload
