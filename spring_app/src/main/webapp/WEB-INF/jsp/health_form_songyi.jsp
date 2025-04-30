<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

<!DOCTYPE html>
<html>
<head>
    <title>건강 정보 업로드</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 2rem;
            background-color: #f0f4f8;
        }
        .container {
            max-width: 500px;
            margin: auto;
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
            color: #2c3e50;
        }
        form {
            margin-top: 2rem;
        }
        input[type="file"] {
            display: block;
            margin: 1rem 0;
            padding: 0.5rem;
            width: 100%;
        }
        input[type="submit"] {
            width: 100%;
            padding: 0.75rem;
            background-color: #27ae60;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 1rem;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #219150;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>🩺 건강 점수 예측</h2>
    <form action="/health/save" method="post" enctype="multipart/form-data">
        <label for="csvFile">CSV 파일 선택:</label>
        <input type="file" name="csvFile" id="csvFile" accept=".csv" required />
        <input type="submit" value="분석 시작하기" />
    </form>
</div>
</body>
</html>
