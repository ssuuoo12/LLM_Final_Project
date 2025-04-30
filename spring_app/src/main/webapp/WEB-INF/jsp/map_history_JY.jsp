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
               padding: 80px 30px 150px 30px; /* 하단 패딩을 더 늘려서 대화창 공간 확보 */
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
               padding: 15px 20px; /* 패딩 증가 */
               background-color: #ffffff;
               border-radius: 15px;
               box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
               min-height: 100px; /* 대화창 높이 증가 */
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
             padding: 15px 20px 15px 50px; /* 왼쪽 패딩을 늘려 모델 선택 버튼 공간 확보 */
             border: 1px solid #ddd;
             border-radius: 25px;
             font-family: 'Roboto', sans-serif; /* 글꼴 변경 */
             font-size: 16px;
             line-height: 1.5;
             min-height: 55px; /* 최소 높이 설정 */
             max-height: 150px; /* 최대 높이 제한 */
             overflow-y: auto; /* 최대 높이 초과 시 스크롤 표시 */
             outline: none;
             transition: border-color 0.3s ease;
             resize: none; /* 크기 조절 비활성화 */
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
			   white-space: pre-line;  /* ✅ 이 줄을 추가하세요! */
			 }
			 
			 body {
			            font-family: 'Segoe UI', sans-serif;
			            background: #f5f5f5;
			            padding: 2rem;
			        }
			        .history-container {
			            max-width: 800px;
			            margin: auto;
			            background: #ffffff;
			            border-radius: 12px;
			            padding: 2rem;
			            box-shadow: 0 0 10px rgba(0,0,0,0.1);
			        }
			        .entry {
			            margin-bottom: 1.5rem;
			            padding: 1rem;
			            border-left: 6px solid #42a5f5;
			            background-color: #f0f8ff;
			            border-radius: 8px;
			        }
			        .entry.assistant {
			            border-left-color: #ab47bc;
			            background-color: #fce4ec;
			        }
			        .timestamp {
			            font-size: 0.85rem;
			            color: gray;
			        }
			 
			 
       </style>
</head>

<body>

    <jsp:include page="header.jsp" />
    <jsp:include page="sidebar.jsp" />

	
	<div class="history-container">
	    <h2>📜 대화 이력</h2>
	    <c:if test="${empty history}">
	        <p>대화 이력이 없습니다.</p>
	    </c:if>
	    <c:forEach var="msg" items="${history}">
	        <div class="entry ${msg.role}">
	            <strong>${msg.role == 'user' ? '🙋 사용자' : '🤖 챗봇'}:</strong>
	            <p>${msg.content}</p>
	            <div class="timestamp">${msg.timestamp}</div>
	        </div>
	    </c:forEach>
	    <br>
	    <a href="/mapc">← 챗봇으로 돌아가기</a>
	</div>
	
	
	
	
	
	
	

		
<script>
	const sidebar = document.getElementById('sidebar');
	const content = document.getElementById('main-content');
	function toggleSidebar() {
	            sidebar.classList.toggle('active');
	            content.classList.toggle('content-shifted');
	        }

</script>
   
</body>
</html>
