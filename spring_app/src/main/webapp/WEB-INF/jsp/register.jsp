<!--register.jsp-->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
	<style>
	    body {
	        font-family: 'Segoe UI', 'Noto Sans KR', sans-serif;
	        background: linear-gradient(135deg, #e8f0fe, #ffffff);
	        margin: 0;
	        padding: 0;
	        display: flex;
	        justify-content: center;
	        align-items: center;
	        min-height: 100vh;
	    }

	    .register-container {
	        background-color: #ffffff;
	        padding: 40px;
	        border-radius: 12px;
	        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
	        width: 100%;
	        max-width: 400px;
	        box-sizing: border-box;
	    }

	    .register-container h2 {
	        text-align: center;
	        margin-bottom: 30px;
	        color: #333;
	        font-weight: 600;
	    }

	    label {
	        display: block;
	        margin-bottom: 6px;
	        font-size: 14px;
	        color: #555;
	        font-weight: 500;
	    }

	    input[type="text"],
	    input[type="password"],
	    input[type="email"] {
	        width: 100%;
	        padding: 12px;
	        margin-bottom: 20px;
	        border: 1px solid #ccc;
	        border-radius: 6px;
	        font-size: 14px;
	        transition: border-color 0.3s;
	    }

	    input[type="text"]:focus,
	    input[type="password"]:focus,
	    input[type="email"]:focus {
	        border-color: #007bff;
	        outline: none;
	    }

	    button[type="submit"] {
	        width: 100%;
	        padding: 12px;
	        background-color: #007bff;
	        border: none;
	        border-radius: 6px;
	        color: #fff;
	        font-size: 16px;
	        font-weight: 500;
	        cursor: pointer;
	        transition: background-color 0.3s;
	    }

	    button[type="submit"]:hover {
	        background-color: #0056b3;
	    }

	    p {
	        text-align: center;
	        margin-top: 20px;
	        font-size: 14px;
	    }

	    p a {
	        color: #007bff;
	        text-decoration: none;
	        font-weight: 500;
	    }

	    p a:hover {
	        text-decoration: underline;
	    }
		select {
		    width: 100%;
		    padding: 12px;
		    margin-bottom: 20px;
		    border: 1px solid #ccc;
		    border-radius: 6px;
		    font-size: 14px;
		    background-color: #fff;
		    appearance: none;
		    background-image: url('data:image/svg+xml;utf8,<svg fill="%23666" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg"><path d="M7 10l5 5 5-5z"/></svg>');
		    background-repeat: no-repeat;
		    background-position: right 12px center;
		    background-size: 16px 16px;
		    cursor: pointer;
		}

		select:focus {
		    border-color: #007bff;
		    outline: none;
		}
</style>
    <title>회원가입</title>
    <link rel="stylesheet" href="/css/style.css">
</head>
<body>
    <div class="register-container">
        <h2>회원가입</h2>
        <form action="/register" method="post">
            <label for="userId">아이디</label>
            <input type="text" name="userId" id="userId" required>

            <label for="password">비밀번호</label>
            <input type="password" name="password" id="password" required>

            <label for="user_name">이름</label>
            <input type="text" name="userName" id="user_name" required>

            <label for="email">이메일</label>
            <input type="email" name="email" id="email" required>
			
			<label for="gender">성별</label>
			<select name="gender" id="gender" required>
			    <option value="" disabled selected>성별을 선택하세요</option>
			    <option value="남성">남성</option>
			    <option value="여성">여성</option>
			</select>
						
            <button type="submit">회원가입</button>
        </form>
		<div style="text-align: center; margin-top: 20px;">
		    <h4>소셜 계정으로 가입</h4>
		    <a href="/oauth2/authorization/google">
		        <img src="https://developers.google.com/identity/images/g-logo.png" alt="Google Login" style="height: 40px;">
		    </a>
		</div>
        <p>이미 계정이 있으신가요? <a href="/chat">로그인</a></p>
    </div>
</body>
</html>
