<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chatbot - Chat</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Noto Sans KR', 'Segoe UI', sans-serif;
            background-color: #f4f4f9;
            overflow-y: auto;
        }

        /* 헤더 스타일 */
        .header {
            width: 100%;
            height: 60px;
            background-color: #ffffff;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            position: fixed;
            top: 0;
            left: 0;
            z-index: 1000;
        }

        .header-left {
            display: flex;
            align-items: center;
        }

        .toggle-icon {
            font-size: 24px;
            color: #333;
            cursor: pointer;
            margin-right: 12px;
            transition: transform 0.3s ease, color 0.3s ease;
        }

        .toggle-icon:hover {
            transform: rotate(90deg);
            color: #007bff;
        }

        .header-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .user-icon {
            font-size: 30px;
            color: #666;
        }

        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            color: white;
            transition: background-color 0.3s ease;
        }

        .login-btn {
            background-color: #007bff;
        }

        .login-btn:hover {
            background-color: #0056b3;
        }

        .signup-btn {
            background-color: #28a745;
        }

        .signup-btn:hover {
            background-color: #218838;
        }

        /* 사이드바 스타일 */
        .sidebar {
            width: 220px;
            height: 100vh;
            background: linear-gradient(180deg, #1a2a44 0%, #2c3e50 100%);
            color: white;
            padding-top: 80px;
            position: fixed;
            top: 0;
            left: 0;
            transform: translateX(-220px);
            transition: transform 0.3s ease;
            z-index: 999;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .sidebar.active {
            transform: translateX(0);
        }

        .menu {
            list-style: none;
            padding: 0;
            margin: 0;
            flex-grow: 1;
        }

        .menu li {
            padding: 15px 20px;
            cursor: pointer;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 12px;
            transition: background-color 0.3s ease;
        }

        .menu li:hover {
            background-color: #3b5998;
        }

        .menu li a {
            color: #e0e0e0;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 12px;
            width: 100%;
            transition: color 0.3s ease;
        }

        .menu li a:hover {
            color: #ffffff;
        }

        .menu li a i {
            font-size: 18px;
            color: #a3bffa;
            transition: color 0.3s ease;
        }

        .menu li a:hover i {
            color: #ffffff;
        }

        .sidebar-footer {
            padding: 20px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .footer-btn {
            padding: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            color: #e0e0e0;
            background-color: #34495e;
            text-align: center;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .footer-btn i {
            font-size: 16px;
            color: #a3bffa;
        }

        .footer-btn:hover {
            background-color: #3b5998;
            color: #ffffff;
        }

        .footer-btn:hover i {
            color: #ffffff;
        }

        /* 메인 콘텐츠 스타일 */
        #main-content {
            padding: 80px 30px 150px 30px;
            transition: margin-left 0.3s ease;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .content-shifted {
            margin-left: 220px;
        }

        /* 중앙 텍스트 스타일 */
        .chat-welcome {
            font-size: 28px;
            font-weight: 600;
            color: #333;
            text-align: center;
            margin-bottom: 20px;
        }

        /* 대화창 스타일 */
        .chat-input-container {
            position: fixed;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            width: 100%;
            max-width: 800px;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
            padding: 15px 20px;
            background-color: #ffffff;
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            min-height: 100px;
        }

        .chat-input-wrapper {
            display: flex;
            align-items: center;
            width: 100%;
            position: relative;
            padding: 10px 0;
        }

        .chat-input {
            flex-grow: 1;
            padding: 15px 20px 15px 50px;
            border: 1px solid #ddd;
            border-radius: 25px;
            font-family: 'Roboto', sans-serif;
            font-size: 16px;
            line-height: 1.5;
            min-height: 55px;
            max-height: 150px;
            overflow-y: auto;
            outline: none;
            transition: border-color 0.3s ease;
            resize: none;
        }

        .chat-input:focus {
            border-color: #007bff;
        }

        .send-btn {
            background-color: #007bff;
            border: none;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            margin-left: 10px;
            transition: background-color 0.3s ease;
        }

        .send-btn i {
            font-size: 16px;
            color: white;
        }

        .send-btn:hover {
            background-color: #0056b3;
        }

        .alert-box {
            padding: 12px;
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
            border-radius: 6px;
            margin-bottom: 20px;
            text-align: center;
            font-weight: bold;
        }

        #chat-output {
            width: 100%;
            max-width: 800px;
            padding: 10px;
            margin-top: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            color: #333;
            font-size: 16px;
            line-height: 1.6;
            white-space: pre-line;
        }
        
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #e0f7fa, #fce4ec);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .chat-wrapper {
            width: 80%;
            max-width: 1000px;
            height: 90vh;
            background-color: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .chat-header {
            padding: 1.5rem;
            background: linear-gradient(135deg, #42a5f5, #7e57c2);
            color: white;
            font-size: 1.8rem;
            font-weight: bold;
        }

        .chat-box {
            flex: 1;
            padding: 2rem;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .bubble {
            padding: 1rem 1.5rem;
            border-radius: 15px;
            max-width: 70%;
            font-size: 1.1rem;
            line-height: 1.5;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            position: relative;
        }

        .user {
            align-self: flex-end;
            background-color: #e3f2fd;
            color: #0d47a1;
        }

        .bot {
            align-self: flex-start;
            background-color: #fce4ec;
            color: #880e4f;
        }

        .bubble i {
            margin-right: 8px;
        }

        form {
            display: flex;
            padding: 1.2rem;
            background-color: #f1f1f1;
            border-top: 1px solid #ddd;
            gap: 1rem;
        }

        input[type="text"] {
            flex: 1;
            padding: 0.9rem;
            font-size: 1rem;
            border: 1px solid #ccc;
            border-radius: 12px;
        }

        .btn {
            background-color: #42a5f5;
            color: white;
            padding: 0.9rem 1.5rem;
            border: none;
            border-radius: 12px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s ease;
        }

        .btn:hover {
            background-color: #1e88e5;
        }

        ::-webkit-scrollbar {
            width: 6px;
        }

        ::-webkit-scrollbar-thumb {
            background-color: #ccc;
            border-radius: 3px;
        }

        /* 로딩 스피너 스타일 */
        .loading-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 9999;
            justify-content: center;
            align-items: center;
        }
        
        .loading-spinner {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .spinner-icon {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #3498db;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin: 0 auto 15px;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .loading-text {
            color: #333;
            font-size: 16px;
            font-weight: 500;
        }
    </style>
</head>

<body>
    <!-- 로딩 오버레이 추가 -->
    <div id="loadingOverlay" class="loading-overlay">
        <div class="loading-spinner">
            <div class="spinner-icon"></div>
            <div class="loading-text">로딩중...</div>
        </div>
    </div>

    <jsp:include page="header.jsp" />
    <jsp:include page="sidebar.jsp" />

    <div class="chat-wrapper">
        <div class="chat-header">
            <i class="fas fa-capsules"></i> 장소 추천 챗봇
        </div>

        <!-- 대화 내역 전체 출력 -->
        <div class="chat-box">
            <c:forEach var="msg" items="${history}">
                <div class="bubble ${msg.role == 'user' ? 'user' : 'bot'}">
                    <i class="fas ${msg.role == 'user' ? 'fa-user' : 'fa-robot'}"></i>
                    ${msg.content}
                </div>
            </c:forEach>
        </div>
        
        <form method="post" action="/mapc/ask" id="chatForm">
            <input type="text" name="question" placeholder="찾고 싶은 장소 물어보세요" required />
            <button type="submit" class="btn">전송</button>
        </form>
    </div>

    <script>
        const sidebar = document.getElementById('sidebar');
        const content = document.getElementById('main-content');
        
        function toggleSidebar() {
            sidebar.classList.toggle('active');
            content.classList.toggle('content-shifted');
        }

        // 로딩 스피너 관련 스크립트
        document.getElementById('chatForm').addEventListener('submit', function(e) {
            // 로딩 오버레이 표시
            document.getElementById('loadingOverlay').style.display = 'flex';
        });
        
        // 페이지가 로드될 때 로딩 오버레이 숨기기
        window.addEventListener('load', function() {
            document.getElementById('loadingOverlay').style.display = 'none';
        });
    </script>
</body>
</html>