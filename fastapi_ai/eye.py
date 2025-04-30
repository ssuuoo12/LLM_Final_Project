# 사전설치 : pip install tf2onnx 
import tensorflow as tf
import tf2onnx
import onnx
import os

# 현재 디렉토리 출력
print(f"현재 작업 디렉토리: {os.getcwd()}")

# Eye 모델 변환
print("Eye 모델 변환 중...")
eye_model_path = './app/model/eye_classification4_model_clean.keras'
eye_model = tf.keras.models.load_model(eye_model_path)
input_signature = [tf.TensorSpec([1, 256, 256, 3], tf.float32, name='input')]
onnx_model, _ = tf2onnx.convert.from_keras(eye_model, input_signature, opset=12)
onnx.save_model(onnx_model, './app/model/eye_classification4_model.onnx')
print("Eye 모델 변환 완료!")