# 송이
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form, Request
from fastapi.responses import JSONResponse
from sqlalchemy.orm import Session
from datetime import datetime
import pandas as pd
import io

from app.database.database import SessionLocal
from app.model.models import HealthScore
from app.services.HealthCheckUp import (
    predict_score_and_risk,
    generate_shap_plot_base64,
    FEATURE_ORDER
)
from app.services.user_health_memory import user_health_info_store

router = APIRouter()

# ✅ DB 세션 의존성 주입
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# ✅ 예측 및 저장 API 엔드포인트
@router.post("/upload-predict-save")
async def upload_and_predict(
    request: Request,
    file: UploadFile = File(...),
    user_id: int = Form(...),
    db: Session = Depends(get_db),
):
    try:
        # 👉 로그 확인용
        form = await request.form()
        print(f"📁 수신된 파일 이름: {file.filename}")
        print(f"🙋 수신된 user_id: {user_id}")

        # ✅ 파일 디코딩 및 CSV 로딩
        contents = await file.read()
        decoded = decode_file(contents)
        df = pd.read_csv(io.StringIO(decoded))

        if df.empty:
            raise HTTPException(status_code=400, detail="❌ CSV 파일에 데이터가 없습니다.")
        missing_cols = set(FEATURE_ORDER) - set(df.columns)
        if missing_cols:
            raise HTTPException(status_code=400, detail=f"❌ 누락된 컬럼: {missing_cols}")

        # ✅ 예측 수행
        input_data = dict(df.iloc[0])
        score, risk, top_features, explanation = predict_score_and_risk(input_data)
        shap_image = generate_shap_plot_base64(input_data)

        # FastAPI 파일 업로드 후 예측 수행 시
        user_health_info_store[user_id] = {
        "score": score,
        "risk": risk,
        "top_features": top_features,  # 리스트 형태
        "explanation": explanation
        }
        # ✅ DB 저장
        record = HealthScore(
            file_name=file.filename,
            score=score,
            risk_level=risk,
            user_id=user_id,
            reg_date=datetime.now()
        )
        db.add(record)
        db.commit()

        # ✅ JSON 응답 반환
        return {
            "fileName": file.filename,
            "score": score,
            "risk": risk,
            "top_features": top_features,
            "explanation": explanation,
            "shap_image": shap_image  # ⬅️ base64 인코딩 이미지 포함
        }

    except UnicodeDecodeError:
        raise HTTPException(status_code=400, detail="❌ 파일 인코딩 오류: UTF-8/CP949 지원")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"❌ 예측 처리 오류: {str(e)}")


# ✅ 파일 인코딩 자동 감지 함수
def decode_file(contents: bytes) -> str:
    for encoding in ("utf-8", "cp949"):
        try:
            return contents.decode(encoding)
        except UnicodeDecodeError:
            continue
    raise UnicodeDecodeError("지원되지 않는 인코딩입니다.")
