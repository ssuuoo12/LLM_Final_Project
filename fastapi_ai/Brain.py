import os
import sys
import tensorflow as tf
import numpy as np

# 필요한 모듈이 설치되어 있는지 확인
try:
    import onnx
    import tf2onnx
except ImportError:
    print("onnx 또는 tf2onnx가 설치되어 있지 않습니다. 설치 중...")
    os.system('pip install onnx tf2onnx')
    import onnx
    import tf2onnx

# 모델 경로
MODEL_PATH = './app/model/brain_tumor_model.h5'
OUTPUT_PATH = './app/model/brain_tumor_model.onnx'

print(f"TensorFlow 버전: {tf.__version__}")
print(f"모델 경로: {os.path.abspath(MODEL_PATH)}")

# 모델 로드
print("모델 로드 중...")
model = tf.keras.models.load_model(MODEL_PATH)

# 모델 요약
model.summary()

# 입력 모양 감지
input_shape = model.input_shape
if input_shape[0] is None:
    input_shape = (1,) + input_shape[1:]
print(f"감지된 입력 모양: {input_shape}")

# 모델을 SavedModel 형식으로 먼저 저장
saved_model_path = './temp_saved_model'
print(f"모델을 SavedModel 형식으로 저장 중: {saved_model_path}")
tf.saved_model.save(model, saved_model_path)

# SavedModel에서 ONNX로 변환
print("SavedModel에서 ONNX로 변환 중...")
os.system(f'python -m tf2onnx.convert --saved-model {saved_model_path} --output {OUTPUT_PATH} --opset 12')

# 임시 디렉토리 정리
import shutil
if os.path.exists(saved_model_path):
    shutil.rmtree(saved_model_path)

# 결과 확인
if os.path.exists(OUTPUT_PATH):
    print(f"변환 성공! ONNX 모델이 저장됨: {os.path.abspath(OUTPUT_PATH)}")
    print(f"모델 크기: {os.path.getsize(OUTPUT_PATH) / (1024*1024):.2f} MB")
else:
    print(f"변환 실패: {OUTPUT_PATH}가 존재하지 않습니다")