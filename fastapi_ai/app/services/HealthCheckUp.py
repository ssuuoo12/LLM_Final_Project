# 송이
import pandas as pd
import joblib
import shap
import matplotlib.pyplot as plt
import numpy as np
import base64
import io
import matplotlib
import matplotlib.pyplot as plt

# ✅ 한글 폰트 설정 (Windows 기준)
matplotlib.rcParams['font.family'] = 'Malgun Gothic'   # 또는 'AppleGothic' (Mac), 'NanumGothic' (Linux 설치 필요)
matplotlib.rcParams['axes.unicode_minus'] = False  # 마이너스 기호 깨짐 방지
# 모델 및 스케일러 로딩
model = joblib.load('app/RandomForestRegressor.pkl')
scaler = joblib.load('app/scaler.pkl')

# 입력 컬럼 순서
FEATURE_ORDER = [
    '성별코드','신장(5cm단위)', '허리둘레', '수축기혈압',
    '식전혈당(공복혈당)', '총콜레스테롤','트리글리세라이드','HDL콜레스테롤','LDL콜레스테롤','혈청지오티(AST)', '혈청지피티(ALT)', '감마지티피',
    '흡연상태', '음주여부'
]

# 사전 계산된 가중치 (정규화된 상관계수 기반)
normalized_weights = pd.read_pickle('app/normalized_weights.pkl')


# ✅ 건강 점수 계산 함수
def calculate_health_score(row):
    score = 100

    if row['허리둘레'] >= (90 if row['성별코드'] == 1 else 85):
        score -= 10 * normalized_weights.get('허리둘레', 1)

    if row['수축기혈압'] >= 140:
        score -= 15 * normalized_weights.get('수축기혈압', 1)
    elif row['수축기혈압'] >= 120:
        score -= 5 * normalized_weights.get('수축기혈압', 1)

    if row['식전혈당(공복혈당)'] >= 126:
        score -= 20 * normalized_weights.get('식전혈당(공복혈당)', 1)
    elif row['식전혈당(공복혈당)'] >= 100:
        score -= 10 * normalized_weights.get('식전혈당(공복혈당)', 1)

    if row['총콜레스테롤'] >= 240:
        score -= 10 * normalized_weights.get('총콜레스테롤', 1)
    elif row['총콜레스테롤'] >= 200:
        score -= 5 * normalized_weights.get('총콜레스테롤', 1)

    if row['트리글리세라이드'] >= 200:
        score -= 10 * normalized_weights.get('트리글리세라이드', 1)
    elif row['트리글리세라이드'] >= 150:
        score -= 5 * normalized_weights.get('트리글리세라이드', 1)

    if ((row['성별코드'] == 1 and row['HDL콜레스테롤'] < 40) or
        (row['성별코드'] == 2 and row['HDL콜레스테롤'] < 50)):
        score -= 10 * normalized_weights.get('HDL콜레스테롤', 1)

    if row['LDL콜레스테롤'] >= 160:
        score -= 10 * normalized_weights.get('LDL콜레스테롤', 1)
    elif row['LDL콜레스테롤'] >= 130:
        score -= 5 * normalized_weights.get('LDL콜레스테롤', 1)

    if row['혈청지오티(AST)'] >= 50:
        score -= 5 * normalized_weights.get('혈청지오티(AST)', 1)

    if row['혈청지피티(ALT)'] >= 50:
        score -= 5 * normalized_weights.get('혈청지피티(ALT)', 1)

    if ((row['성별코드'] == 1 and row['감마지티피'] >= 80) or
        (row['성별코드'] == 2 and row['감마지티피'] >= 55)):
        score -= 10 * normalized_weights.get('감마지티피', 1)

    if row['흡연상태'] == 1:
        score -= 10 * normalized_weights.get('흡연상태', 1)

    if row['음주여부'] == 1:
        score -= 5 * normalized_weights.get('음주여부', 1)

    return max(score, 0)


# ✅ 모델 기반 예측
def predict_score(input_data: dict):
    df = pd.DataFrame([input_data])
    X_scaled = scaler.transform(df[FEATURE_ORDER])
    predicted_score = float(model.predict(X_scaled)[0])
    return round(predicted_score, 2)


# ✅ 위험군 분류
def classify_risk(score: float) -> str:
    if score >= 80:
        return "저위험군"
    elif score >= 50:
        return "중위험군"
    else:
        return "고위험군"


# ✅ SHAP 주요 요인 추출 + 설명 텍스트
def explain_features(input_data: dict):
    df = pd.DataFrame([input_data])
    X_scaled = scaler.transform(df[FEATURE_ORDER])
    X_df = pd.DataFrame(X_scaled, columns=FEATURE_ORDER)

    explainer = shap.TreeExplainer(model)
    shap_values = explainer.shap_values(X_df)

    importance = np.abs(shap_values[0])
    top_indices = np.argsort(importance)[-3:][::-1]
    top_features = [FEATURE_ORDER[i] for i in top_indices]

    explanation = f"AI는 다음 요소들이 건강 점수에 주요한 영향을 주었다고 분석했습니다: {', '.join(top_features)}"
    return top_features, explanation


# ✅ SHAP 시각화 이미지 → base64
def generate_shap_plot_base64(input_data: dict) -> str:
    df = pd.DataFrame([input_data])
    X_scaled = scaler.transform(df[FEATURE_ORDER])
    X_df = pd.DataFrame(X_scaled, columns=FEATURE_ORDER)

    explainer = shap.TreeExplainer(model)
    shap_values = explainer.shap_values(X_df)

    plt.figure()
    shap.summary_plot(shap_values, X_df, plot_type="bar", show=False)

    buf = io.BytesIO()
    plt.tight_layout()
    plt.savefig(buf, format='png')
    plt.close()
    buf.seek(0)

    return base64.b64encode(buf.read()).decode("utf-8")


# ✅ FastAPI에서 사용할 통합 예측 함수
def predict_score_and_risk(input_data: dict):
    score = predict_score(input_data)
    risk = classify_risk(score)
    top_features, explanation = explain_features(input_data)
    return score, risk, top_features, explanation
