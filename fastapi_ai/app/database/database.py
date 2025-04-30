# 송이
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

DATABASE_URL = "mysql+pymysql://nask8543:tnsrb0313!@223.26.253.91:3306/test"

engine = create_engine(DATABASE_URL, echo=True) #데이터베이스 연결을 위한 엔진을 생성
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine) # 세션 만들기
Base = declarative_base() # ORM 테이블을 위한 기본 클래스