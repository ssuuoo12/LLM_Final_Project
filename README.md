# 헬스케어 AI 챗봇 시스템
<p align="center">
  <img src="https://img.shields.io/badge/python-3776AB?style=for-the-badge&logo=python&logoColor=white" />
  <img src="https://img.shields.io/badge/fastapi-009688?style=for-the-badge&logo=fastapi&logoColor=white" />
  <img src="https://img.shields.io/badge/spring-boot-6DB33F?style=for-the-badge&logo=spring&logoColor=white" />
  <img src="https://img.shields.io/badge/mariadb-003545?style=for-the-badge&logo=mariadb&logoColor=white" />
  <img src="https://img.shields.io/badge/tensorflow-FF6F00?style=for-the-badge&logo=tensorflow&logoColor=white" />
  <img src="https://img.shields.io/badge/pytorch-EE4C2C?style=for-the-badge&logo=chainlink&logoColor=white" />
</p>

## 프로젝트 기간
기간 : 25/04/01~2025/04/30

## 프로젝트 개요
이 프로젝트는 FastAPI와 Spring Boot를 기반으로 한 헬스케어 AI 챗봇 시스템입니다. 사용자의 증상 입력과 의료 이미지를 AI로 분석하여 질병을 예측하고, 건강검진 데이터를 기반으로 맞춤형 건강 관리 솔루션을 제공합니다.

### 팀원 구성

| 이름 | 역할 |
|------|------|
| 권순규 | 팀장, spring security, RAG기반 헬스케어 챗봇 |
| 하인솔 | 사용자 맞춤 식단 추천|
| 석송이 | 부팀장, 건강 점수 체크, 건강 점수 기반 영양제 추천 챗봇 |
| 송지연 | 의료 이미지 질환 예측 모델, 장소 추천 챗봇 |

<table>
  <tr>
    <td align="center">
      <a href="https://github.com/SK-Kwon90">
        <img src="https://github.com/SK-Kwon90.png" width="100px;" alt="권순규 프로필"/>
        <br />
        <sub><b>권순규</b></sub>
      </a>
      <br />
    </td>
    <td align="center">
      <a href="https://github.com/insol-ha">
        <img src="https://github.com/insol-ha.png" width="100px;" alt="하인솔 프로필"/>
        <br />
        <sub><b>하인솔</b></sub>
      </a>
      <br />
    </td>
    <td align="center">
      <a href="https://github.com/songyiseok">
        <img src="https://github.com/songyiseok.png" width="100px;" alt="석송이 프로필"/>
        <br />
        <sub><b>석송이</b></sub>
      </a>
      <br />
    </td>
    <td align="center">
      <a href="https://github.com/ssuuoo12">
        <img src="https://github.com/ssuuoo12.png" width="100px;" alt="송지연 프로필"/>
        <br />
        <sub><b>송지연</b></sub>
      </a>
      <br />
    </td>
  </tr>
</table>

## 주요 기능
- **증상 기반 진단 챗봇**: 증상 입력 시 가능성 있는 질병 분석 및 조치 안내
- **의료 이미지 AI 분석**: 폐 X-ray, 안저 사진, 뇌 MRI 등을 분석하여 관련 질환 예측
- **건강검진 데이터 분석**: 건강검진 결과 기반 위험군 분류 및 맞춤형 영양제 추천
- **맞춤형 건강 관리**: 개인화된 식단 및 건강 시설 추천 제공
- **사용자 이력 관리**: 분석 기록 저장 및 건강 상태 변화 추적


## 기술 스택 세부 설명
### Spring Boot 애플리케이션

- **프레임워크**: Spring Boot 2.6.7
- **빌드 도구**: Gradle
- **뷰 템플릿**: JSP (JavaServer Pages)
- **인증**: Spring Security + OAuth2
- **데이터베이스 연결**: JDBC Template, MyBatis
- **HTTP 클라이언트**: RestTemplate

### FastAPI 애플리케이션

- **프레임워크**: FastAPI
- **ORM**: SQLAlchemy
- **데이터 처리**: Pandas, NumPy
  
| AI 모델 |
|------|------|
| 기능 | 라이브러리 |
| 챗봇 | LangChain, Gemma, LM studio (LLM) |
| 식단 | pandas, logging, pydantic |
| 건강 점수 | RandomForest, SHAP |
| 이미지 진단 | Tensorflow, PyTorch, ONNX Runtime |


## FastApi 디렉토리 구조
```
├── app/                    # 애플리케이션 핵심 모듈
│   ├── database/           # 데이터베이스 연결 및 ORM 정의
│   ├── dataset/            # 학습 및 서비스용 데이터셋
│   ├── model/              # 사전 학습된 AI 모델 파일 저장
│   ├── routers/            # REST API 엔드포인트 정의
│   └── services/           # 비즈니스 로직 및 모델 추론 서비스
├── vector_index/           # 벡터 인덱스 저장 (FAISS)
├── .env                    # API 키 및 환경 설정
├── Brain.py                # 뇌종양 진단 모델 ONNX 변환
├── eye.py                  # 안구질환 진단 모델 ONNX 변환
├── init_faiss.py           # FAISS 벡터 인덱스 초기화 스크립트
└── main.py                 # 메인 애플리케이션 시작점
```



## 실행 방법

FastAPI 서버 실행
python main.py 또는 uvicorn main:app --reload
Spring Boot 서버 실행

웹 애플리케이션 접속
http://localhost:8080

