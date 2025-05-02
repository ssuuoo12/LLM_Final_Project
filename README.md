헬스케어 AI 챗봇 시스템
<p align="center">
  <img src="https://img.shields.io/badge/python-3776AB?style=for-the-badge&logo=python&logoColor=white" />
  <img src="https://img.shields.io/badge/fastapi-009688?style=for-the-badge&logo=fastapi&logoColor=white" />
  <img src="https://img.shields.io/badge/spring-6DB33F?style=for-the-badge&logo=spring&logoColor=white" />
  <img src="https://img.shields.io/badge/tensorflow-FF6F00?style=for-the-badge&logo=tensorflow&logoColor=white" />
  <img src="https://img.shields.io/badge/mariadb-003545?style=for-the-badge&logo=mariadb&logoColor=white" />
  <img src="https://img.shields.io/badge/langchain-000000?style=for-the-badge&logo=chainlink&logoColor=white" />
</p>
프로젝트 개요
이 프로젝트는 FastAPI와 Spring Boot를 기반으로 한 헬스케어 AI 챗봇 시스템입니다. 사용자의 증상 입력과 의료 이미지를 AI로 분석하여 질병을 예측하고, 건강검진 데이터를 기반으로 맞춤형 건강 관리 솔루션을 제공합니다.
주요 기능

증상 기반 진단 챗봇: 증상 입력 시 가능성 있는 질병 분석 및 조치 안내
의료 이미지 AI 분석: 폐 X-ray, 안저 사진, 뇌 MRI 등을 분석하여 관련 질환 예측
건강검진 데이터 분석: 건강검진 결과 기반 위험군 분류 및 맞춤형 영양제 추천
맞춤형 건강 관리: 개인화된 식단 및 건강 시설 추천 제공
사용자 이력 관리: 분석 기록 저장 및 건강 상태 변화 추적

기술 스택
영역기술프론트엔드JSP, HTML, CSS, JavaScript백엔드Spring Boot, FastAPI, Java, PythonAILangChain, TensorFlow, PyTorch데이터베이스MariaDB파일관리CSV 기반 데이터 매핑
시스템 아키텍처
├── spring_boot/                     # Spring Boot 애플리케이션
│   ├── src/main/java                # Java 소스 코드
│   │   ├── controller/              # 컨트롤러 클래스
│   │   ├── service/                 # 서비스 로직
│   │   ├── model/                   # 데이터 모델
│   │   └── config/                  # 보안 및 설정
│   ├── src/main/resources           # 리소스 파일
│   └── src/main/webapp/WEB-INF      # JSP 뷰 파일
└── fastapi_ai/                      # FastAPI 애플리케이션
    ├── main.py                      # 메인 API 엔드포인트
    ├── models/                      # AI 모델 파일
    │   ├── symptom_analyzer.py      # 증상 분석 모델
    │   ├── image_classifier.py      # 의료 이미지 분석 모델
    │   └── health_data_processor.py # 건강검진 데이터 분석 모델
    ├── data/                        # 데이터 파일
    │   ├── symptoms_diseases.csv    # 증상-질병 매핑 데이터
    │   └── nutrients_mapping.csv    # 건강상태-영양제 매핑 데이터
    └── utils/                       # 유틸리티 함수
실행 방법
FastAPI 서버 실행
bashcd fastapi_ai
python main.py
Spring Boot 서버 실행
bashcd spring_boot
./gradlew bootRun
# 또는 IDE에서 프로젝트를 열고 애플리케이션 restart
웹 애플리케이션 접속
http://localhost:8080
개발팀 구성
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
