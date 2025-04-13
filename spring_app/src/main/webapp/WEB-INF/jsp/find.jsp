<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
<head>
    <title>아이디 / 비밀번호 찾기</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 0;
        }

        .find-container {
            max-width: 500px;
            margin: 100px auto;
            padding: 30px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        h3 {
            margin-bottom: 15px;
            font-size: 20px;
            color: #333;
        }

        form {
            margin-bottom: 30px;
        }

        input[type="text"], input[type="email"] {
            width: 100%;
            padding: 10px;
            margin-top: 6px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        button {
            width: 100%;
            padding: 12px;
            background-color: #007bff;
            border: none;
            color: white;
            font-size: 16px;
            border-radius: 6px;
            cursor: pointer;
        }

        button:hover {
            background-color: #0056b3;
        }

        .message-box {
            text-align: center;
            margin-top: 10px;
            font-weight: bold;
        }

        .message-box.success {
            color: green;
        }

        .message-box.error {
            color: red;
        }
    </style>
</head>
<body>
    <div class="find-container">
        <form action="/find/id" method="post">
            <h3>아이디 찾기</h3>
            <input type="text" name="userName" placeholder="이름" required>
            <input type="email" name="email" placeholder="이메일" required>
            <button type="submit">아이디 찾기</button>
        </form>

        <form action="/find/password" method="post">
            <h3>비밀번호 찾기</h3>
            <input type="text" name="userId" placeholder="아이디" required>
            <input type="email" name="email" placeholder="이메일" required>
            <button type="submit">비밀번호 찾기</button>
        </form>

        <c:if test="${not empty message}">
            <div class="message-box success">
                <c:out value="${message}" />
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="message-box error">
                <c:out value="${error}" />
            </div>
        </c:if>
		
		<c:if test="${not empty message or not empty error}">
		    <div style="margin-top: 20px; text-align: center;">
		        <button onclick="location.href='/chat'" style="width: 100%; padding: 12px; background-color: #28a745; border: none; color: white; font-size: 16px; border-radius: 6px; cursor: pointer;">
		            로그인하러 가기
		        </button>
		    </div>
		</c:if>
		
    </div>
</body>
</html>
