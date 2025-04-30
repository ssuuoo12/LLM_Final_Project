import pandas as pd
import logging
from app.services.diet_model_loader import model_loader



logging.basicConfig(level=logging.INFO)

class DietService:
    def __init__(self, csv_path: str):
        logging.info(f"📂 CSV 로드 중... 경로: {csv_path}")
        self.df = pd.read_csv(csv_path, encoding='utf-8')
        self.df.columns = self.df.columns.str.strip()
        logging.info(f"✅ CSV 로드 완료! 데이터 개수: {len(self.df)}")

    def get_diet_info(self, disease: str, meal_time: str):
        logging.info(f"🔍 질병: {disease}, 식사시간: {meal_time} → 추천 식단 조회")

        matched = self.df[(self.df['질병'] == disease) & (self.df['식사시간'] == meal_time)]
        logging.info(f"🔎 매칭된 행 수: {len(matched)}")

        if matched.empty:
            logging.warning("❌ 일치하는 데이터 없음!")
            return {"error": "No recommendation found for given disease and meal time."}
        
        row = matched.iloc[0]
        logging.info(f"✅ 추천식단: {row['추천식단']}, 권장: {row['권장']}, 제한: {row['제한']}")

        return {
            "recommend": row["추천식단"],
            "allowed": row["권장"],
            "restricted": row["제한"]
        }
