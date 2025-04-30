import pandas as pd
import pickle


class DietModelLoader:
    def __init__(self, model_path: str, csv_path: str):
        try:
            with open(model_path, 'rb') as f:
                self.model, self.vectorizer, self.label_encoder = pickle.load(f)
            print("✅ 모델, 벡터라이저, 라벨 인코더 로드 완료")
        except Exception as e:
            print(f"❌ 모델 로드 실패: {e}")
            self.model, self.vectorizer, self.label_encoder = None, None, None

        try:
            self.df = pd.read_csv(csv_path, encoding='utf-8')
            self.df.columns = self.df.columns.str.strip()
            print("✅ CSV 데이터 로드 완료")
        except Exception as e:
            print(f"❌ CSV 로드 실패: {e}")
            self.df = pd.DataFrame()

    def predict(self, input_text: str) -> dict:
        if not self.model or not self.vectorizer or not self.label_encoder:
            return {"error": "모델 구성 요소가 로드되지 않았습니다."}

        try:
            X = self.vectorizer.transform([input_text])
            y_pred = self.model.predict(X)
            decoded_label = self.label_encoder.inverse_transform(y_pred)[0]
            print(f"📌 예측된 식단 라벨: {decoded_label}")

            matched = self.df[self.df['추천식단'] == decoded_label]
            if matched.empty:
                print(f"❌ '{decoded_label}' 식단이 CSV에 없음")
                return {"error": f"추천 식단 '{decoded_label}' 이 데이터셋에 없습니다."}

            row = matched.iloc[0]

            return {
                "recommend": row["추천식단"],
                "allowed": row["권장식품"] if pd.notna(row["권장식품"]) else "-",
                "restricted": row["제한식품"] if pd.notna(row["제한식품"]) else "-"
            }

        except Exception as e:
            print(f"❌ 예측 중 예외 발생: {e}")
            return {"error": f"예측 오류: {str(e)}"}

# ✅ FastAPI에서 직접 import할 수 있도록 인스턴스 정의
model_loader = DietModelLoader(
    model_path="app/model/diet_model.pkl",  # ✅ 여기만 정확히 수정!
    csv_path="app/dataset/Diet.csv"
)
