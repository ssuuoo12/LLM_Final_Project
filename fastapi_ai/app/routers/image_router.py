from fastapi import APIRouter, UploadFile, File, Form
from fastapi.responses import JSONResponse
from typing import Optional
from PIL import Image
from io import BytesIO
import base64
import traceback
import os
import numpy as np
import onnxruntime as ort
from scipy.special import softmax
from app.services.image_service import (
    create_result_image,
    save_result_to_db,
    predict_lung_cancer
)

router = APIRouter()

def preprocess_image(img, size):
    img = img.resize(size).convert("RGB")
    img_array = np.array(img) / 255.0
    return np.expand_dims(img_array, axis=0).astype(np.float32)

# def predict_onnx(session, img_array, class_names):
#     outputs = session.run(None, {'input': img_array})[0]
#     probabilities = np.softmax(outputs[0])
#     confidence = np.max(probabilities)
#     diagnosis = class_names[np.argmax(probabilities)]
#     return diagnosis, float(confidence), probabilities.tolist()

def predict_onnx(session, img_array, class_names):
    # 모델 입력 이름 동적으로 가져오기
    input_name = session.get_inputs()[0].name
    print(f"모델 입력 이름: {input_name}")
    
    # 동적 입력 이름으로 실행
    outputs = session.run(None, {input_name: img_array})[0]
    
    # softmax 구현
    def softmax(x):
        e_x = np.exp(x - np.max(x))
        return e_x / e_x.sum()
    
    probabilities = softmax(outputs[0])
    confidence = np.max(probabilities)
    diagnosis = class_names[np.argmax(probabilities)]
    return diagnosis, float(confidence*100), (probabilities*100).tolist()


@router.post("/diagnose/{disease_type}")
async def diagnose_disease(disease_type: str, file: UploadFile = File(...),
                           user_id: str = Form(...), user_name: str = Form(...),
                           title: Optional[str] = Form(None)):
    try:
        print(f"\n🔍 질병 타입: {disease_type}")
        img_bytes = await file.read()
        img = Image.open(BytesIO(img_bytes)).convert("RGB")
        file_name = file.filename
        print(f"📷 파일명: {file_name}, 파일크기: {len(img_bytes)} bytes")

        if disease_type == "eye":
            model_path = os.path.abspath('./app/model/eye_classification4_model.onnx')  # .onnx 확장자로 변경
            print(f"🧠 Eye Model Path: {model_path}")
            class_names = ['cataract', 'diabetic_retinopathy', 'glaucoma', 'normal']
            try:
                session = ort.InferenceSession(model_path)
                print("✅ Eye model loaded successfully.")
            except Exception as e:
                print(f"🚨 Eye model 로딩 실패: {e}")
                traceback.print_exc()
                raise
            try:
                img_array = preprocess_image(img, (256, 256))
                diagnosis, confidence, all_probabilities = predict_onnx(session, img_array, class_names)
                print(f"Eye prediction: {diagnosis}, {confidence}")
            except Exception as e:
                print(f"🚨 Eye 이미지 예측 실패: {e}")
                traceback.print_exc()
                raise

        elif disease_type == "Brain":
            model_path = os.path.abspath('./app/model/brain_tumor_model.onnx')  # .onnx 확장자 사용
            print(f"🧠 Brain Model Path: {model_path}")
            class_names = ['glioma', 'meningioma', 'notumor', 'pituitary']
            try:
                session = ort.InferenceSession(model_path)
                print("✅ Brain model loaded successfully.")
            except Exception as e:
                print(f"🚨 Brain model 로딩 실패: {e}")
                traceback.print_exc()
                raise
            try:
                img_array = preprocess_image(img, (150, 150))
                diagnosis, confidence, all_probabilities = predict_onnx(session, img_array, class_names)
                print(f"Brain prediction: {diagnosis}, {confidence}")
            except Exception as e:
                print(f"🚨 Brain 이미지 예측 실패: {e}")
                traceback.print_exc()
                raise

        elif disease_type == "lc":
            model_path = os.path.abspath('./app/model/best_model.pth')
            class_names = ['adenocarcinoma', 'large.cell.carcinoma', 'normal', 'squamous.cell.carcinoma']
            print(f"🫁 Lung Model Path: {model_path}")
            try:
                diagnosis, confidence, all_probabilities = predict_lung_cancer(img, model_path, class_names)
                print(f"Lung prediction: {diagnosis}, {confidence}")
            except Exception as e:
                print(f"🚨 Lung 이미지 예측 실패: {e}")
                traceback.print_exc()
                raise

        else:
            return JSONResponse(status_code=400, content={"error": "지원되지 않는 질환 유형입니다."})

        print(f"✅ 예측 완료: {diagnosis} ({confidence:.2f})")
        result_img = create_result_image(img, diagnosis, confidence)
        title = f"{file_name} - {diagnosis}"
        save_result_to_db(user_id, user_name, file_name, disease_type, diagnosis, confidence, title)

        buffered = BytesIO()
        result_img.save(buffered, format="PNG")
        result_b64 = base64.b64encode(buffered.getvalue()).decode("utf-8")

        return {
            "title": title,
            "user_id": user_id,
            "user_name": user_name,
            "diagnosis": diagnosis,
            "confidence": confidence,
            "probabilities": all_probabilities,
            "result_image": result_b64
        }

    except Exception as e:
        print("❌ 전체 예외 발생:")
        traceback.print_exc()
        return JSONResponse(status_code=500, content={"error": str(e)})