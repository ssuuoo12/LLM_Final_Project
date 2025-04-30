import pandas as pd
import pickle
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.preprocessing import LabelEncoder
from sklearn.naive_bayes import MultinomialNB  # 또는 다른 분류기
from sklearn.pipeline import make_pipeline

# 1. 데이터 로드
df = pd.read_csv("app/dataset/Diet.csv", encoding="utf-8")
df.columns = df.columns.str.strip()

# 2. 텍스트 입력 생성 ("질병 식사시간" 형식)
df["입력문장"] = df["질병"].str.strip() + " " + df["식사시간"].str.strip()

# 3. 라벨: 추천식단
label_encoder = LabelEncoder()
y = label_encoder.fit_transform(df["추천식단"].values)

# 4. 벡터라이저 + 분류기
vectorizer = TfidfVectorizer()
X = vectorizer.fit_transform(df["입력문장"].values)

# 5. 모델 학습
model = MultinomialNB()
model.fit(X, y)

# 6. 저장: (모델, 벡터라이저, 라벨인코더)
with open("app/model/diet_model.pkl", "wb") as f:
    pickle.dump((model, vectorizer, label_encoder), f)

print("✅ 모델 저장 완료: app/model/diet_model.pkl")
