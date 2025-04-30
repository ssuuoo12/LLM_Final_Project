import tensorflow as tf
import numpy as np
import torch
from torchvision import transforms, models
from PIL import ImageDraw, ImageFont
import mysql.connector
from datetime import datetime


def predict_image(img, model, class_names):
    img = img.convert('RGB').resize((256, 256))
    img_array = tf.keras.preprocessing.image.img_to_array(img)
    img_array = tf.expand_dims(img_array, 0)
    predictions = model.predict(img_array)
    score = tf.nn.softmax(predictions[0])
    all_probabilities = {class_name: float(score[i] * 100) for i, class_name in enumerate(class_names)}
    return class_names[np.argmax(score)], float(np.max(score) * 100), all_probabilities


def predict_brain_tumor(img, model, class_names):
    img = img.convert('RGB').resize((150, 150))
    img_array = tf.keras.preprocessing.image.img_to_array(img) / 255.0
    img_array = tf.expand_dims(img_array, 0)
    predictions = model.predict(img_array)[0]
    all_probabilities = {class_name: float(prob * 100) for class_name, prob in zip(class_names, predictions)}
    return class_names[np.argmax(predictions)], float(np.max(predictions) * 100), all_probabilities


def predict_lung_cancer(img, model_path, class_names):
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    model = models.resnet18(pretrained=False)
    model.fc = torch.nn.Sequential(
        torch.nn.ReLU(),
        torch.nn.Linear(model.fc.in_features, len(class_names))
    )
    model.load_state_dict(torch.load(model_path, map_location=device))
    model.to(device).eval()
    preprocess = transforms.Compose([
        transforms.Resize((224, 224)),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
    ])
    img = img.convert('RGB')
    input_tensor = preprocess(img).unsqueeze(0).to(device)
    with torch.no_grad():
        output = model(input_tensor)
        probabilities = torch.nn.functional.softmax(output, dim=1)[0]
    all_probabilities = {class_name: float(probabilities[i] * 100) for i, class_name in enumerate(class_names)}
    return class_names[probabilities.argmax().item()], float(probabilities.max().item() * 100), all_probabilities


def create_result_image(original_image, diagnosis, confidence):
    result_img = original_image.copy()
    draw = ImageDraw.Draw(result_img)
    font = ImageFont.load_default()
    text = f"Diagnosis: {diagnosis} ({confidence:.2f}%)"
    text_width, text_height = draw.textbbox((0, 0), text, font=font)[2:4]
    draw.rectangle([(0, 0), (text_width + 10, text_height + 10)], fill='black')
    draw.text((5, 5), text, fill='white', font=font)
    return result_img


def save_result_to_db(user_id, user_name, file_name, disease_type, diagnosis, confidence, title):
    try:
        conn = mysql.connector.connect(
            host="223.26.253.91",
            user="nask8543",
            password="tnsrb0313!",
            database="test"
        )
        cursor = conn.cursor()
        sql = """
        INSERT INTO diagnosis_result (user_id, user_name, file_name, disease_type, diagnosis, confidence, created_at, title)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """
        values = (user_id, user_name, file_name, disease_type, diagnosis, confidence, datetime.now(), title)
        cursor.execute(sql, values)
        conn.commit()
        cursor.close()
        conn.close()
        print("진단 결과 DB 저장 완료.")
    except mysql.connector.Error as err:
        print(f"[DB Error] {err}")