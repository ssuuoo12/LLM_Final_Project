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
			   background-color: #007bff;
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
			    background-color: #ffffff;
			    border-radius: 15px;
			    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
			    padding: 15px 20px;
			    display: flex;
			    flex-direction: column;
			    gap: 10px;
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
			 /* 전송 버튼 위치 및 스타일 */
			 #chat-form .btn {
			     min-width: 80px;
			     height: 44px;
			     border-radius: 25px;
			     background-color: #007bff;
			     color: white;
			     font-weight: bold;
			     font-size: 15px;
			     border: none;
			     transition: background-color 0.3s ease;
			 }
			 /* 입력 필드 및 버튼을 나란히 정렬 */
			 #chat-form {
			     width: 100%;
			     display: flex;
			     align-items: center;
			     gap: 10px;
			 }
			 				
			 #chat-form .btn:hover {
			     background-color: #0056b3;
			 }
			 /* 입력창 스타일 개선 */
			 #userInput {
			     flex-grow: 1;
			     padding: 14px 20px;
			     border: 1px solid #ddd;
			     border-radius: 25px;
			     font-size: 16px;
			     font-family: 'Roboto', sans-serif;
			     outline: none;
			     transition: border-color 0.3s ease;
			     background-color: #f9f9f9;
			 }

			 #userInput:focus {
			     border-color: #007bff;
			     background-color: #fff;
			 }
       </style>
</head>

<body>

    <jsp:include page="header.jsp" />
    <jsp:include page="sidebar.jsp" />

    <div id="main-content">
        <div class="chat-welcome">헬슈케어 챗봇</div>
		<!-- 챗봇 응답 출력 전 '답변 생성중...' 표시 -->
		<div id="loading-msg" style="display:none; font-weight: bold; color: #007bff; margin-bottom: 10px;">
		    답변 생성중...
		</div>

		<!-- 챗봇 응답 출력 영역 -->
		<div id="chat-output"></div>

			<div class="chat-input-container">
			        <!-- 인증된 사용자만 입력 가능 -->
			        <sec:authorize access="isAuthenticated()">
						<form id="chat-form">
						    <input type="text" id="userInput" name="question" placeholder="증상 또는 보험관련 질문을 해주세요!" required />
						    <button type="submit" class="btn">전송</button>
						</form>
			        </sec:authorize>

			        <sec:authorize access="isAnonymous()">
			            <h3>로그인 또는 회원가입 후 이용 가능합니다.</h3>
			        </sec:authorize>
			    </div>
    </div>
	<script>
	    const sidebar = document.getElementById('sidebar');
	    const content = document.getElementById('main-content');
	    function toggleSidebar() {
	        sidebar.classList.toggle('active');
	        content.classList.toggle('content-shifted');
	    }

	    function sendMessage() {
	        const input = document.getElementById("userInput");
	        const message = input.value.trim();
	        const loading = document.getElementById("loading-msg");
	        const output = document.getElementById("chat-output");

	        if (!message) return;

	        // 로딩 메시지 표시
	        loading.style.display = "block";
	        loading.innerText = "답변 생성중...";

	        fetch("/chat/send-ajax", {
	            method: "POST",
	            headers: {
	                "Content-Type": "application/json"
	            },
	            body: JSON.stringify({
	                user_id: "${sessionScope.loginUser.userId}",
	                message: message
	            })
	        })
	        .then(res => res.json())
	        .then(data => {
	            loading.style.display = "none";
	            input.value = "";
	            const userBubble = document.createElement("div");
	            userBubble.className = "bubble user";
	            userBubble.innerHTML = '<i class="fas fa-user"></i> ' + message;
	            output.appendChild(userBubble);

	            const botBubble = document.createElement("div");
	            botBubble.className = "bubble bot";
	            botBubble.innerHTML = '<i class="fas fa-robot"></i> ' + data.response + '<hr>';
	            output.appendChild(botBubble);

	            output.scrollTop = output.scrollHeight;
	        })
	        .catch(err => {
	            loading.innerText = "❗ 오류 발생: " + err;
	        });
	    }

	    document.getElementById("userInput").addEventListener("keydown", function(event) {
	        if (event.key === "Enter" && !event.shiftKey) {
	            event.preventDefault();
	            sendMessage();
	        }
	    });
		document.getElementById("chat-form").addEventListener("submit", function(event) {
		    event.preventDefault();
		    sendMessage();
		});

		document.getElementById("userInput").addEventListener("keydown", function(event) {
		    if (event.key === "Enter" && !event.shiftKey) {
		        event.preventDefault();
		        // ❌ 여기서 sendMessage()를 또 호출하지 않도록 함
		        // 이미 submit 이벤트에서 처리함
		    }
		});
	</script
</body>
</html>
