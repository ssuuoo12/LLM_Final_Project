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
	    margin: 0;
	    padding: 0;
	    font-family: 'Segoe UI', sans-serif;
	    background: linear-gradient(135deg, #e0f7fa, #fce4ec);
	    height: 100vh;
	    display: flex;
	    align-items: center;
	    justify-content: center;
	}

	/* 헤더 스타일 */
	.header {
	    width: 100%;
	    height: 60px;
	    background-color: #ffffff;
	    display: flex;
	    justify-content: space-between;
	    align-items: center; /* ✅ 핵심 수직 정렬 */
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
	    margin-right: 20px;
	    height: 60px;
	    background-color: transparent; /* 혹시라도 회색 박스가 있을 경우 제거 */
	}
	.header-right form {
	    display: flex;           /* ✅ inline-block 대신 명확히 정렬 */
	    align-items: center;
	    background-color: transparent !important; /* ✅ 배경 회색 제거 */
	    box-shadow: none;        /* ✅ 혹시 모를 그림자 제거 */
	    margin: 0;
	    padding: 0;
	}
	.header-right span {
	    font-weight: bold;
	    color: #333;
	    display: flex;
	    align-items: center;
	}

	.user-icon {
	    font-size: 24px;
	    color: #666;
	}

	.btn {
	    display: inline-flex;          /* ✅ 버튼 내부 텍스트 정렬 */
	    align-items: center;
	    justify-content: center;
	    padding: 6px 14px;
	    height: 36px;                  /* ✅ 고정 높이로 정렬 균형 확보 */
	    font-size: 13px;
	    font-weight: 600;
	    border: none;
	    border-radius: 8px;
	    cursor: pointer;
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

	/* 사이드바 */
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

	/* 메인 콘텐츠 */
	.chat-wrapper {
	    width: 80%;
	    max-width: 1000px;
	    height: calc(100vh - 80px); /* 헤더 제외한 높이 */
	    margin: 80px auto 30px auto;
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

	form .btn {
	    background-color: #42a5f5;
	    color: white;
	    padding: 0.9rem 1.5rem;
	    border: none;
	    border-radius: 12px;
	    font-weight: bold;
	    cursor: pointer;
	    transition: 0.3s ease;
	    height: auto;
	}

	form .btn:hover {
	    background-color: #1e88e5;
	}

	/* 스크롤바 */
	::-webkit-scrollbar {
	    width: 6px;
	}
	::-webkit-scrollbar-thumb {
	    background-color: #ccc;
	    border-radius: 3px;
	}

	   /* 로딩 메시지 스타일 */
	    #loadingMessage {
	        display: none;
	        position: fixed;
	        top: 50%;
	        left: 50%;
	        transform: translate(-50%, -50%);
	        background-color: rgba(255, 255, 255, 0.9);
	        padding: 30px 40px;
	        border-radius: 10px;
	        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
	        font-size: 18px;
	        font-weight: bold;
	        text-align: center;
	        z-index: 2000;
	    }
	    #loadingMessage img {
	        width: 40px;
	        height: 40px;
	        margin-top: 10px;
	        animation: spin 1s linear infinite;
	    }
	    @keyframes spin {
	        from { transform: rotate(0deg); }
	        to { transform: rotate(360deg); }
	    }
	</style>
</head>
<body data-user-id="${sessionScope.loginUser.id}">
    <jsp:include page="header.jsp" />
    <jsp:include page="sidebar.jsp" />
    <div class="chat-wrapper">
        <div class="chat-header">
            <i class="fas fa-capsules"></i> 영양제 추천 챗봇
        </div>
        <div class="chat-box" id="chat-box"></div>
        <form id="chat-form">
            <input type="text" id="question-input" name="question" placeholder="궁금한 점을 입력해 보세요..." required />
            <button type="submit" class="btn">전송</button>
        </form>
    </div>
    <div id="loadingMessage">
        ⏳ 로딩 중입니다...<br>
        <img src="https://i.gifer.com/ZZ5H.gif" alt="로딩중">
    </div>
	<script>
	        let globalUserId = null;

	        const sidebar = document.getElementById('sidebar');
	        const content = document.getElementById('main-content');

	        function toggleSidebar() {
	            sidebar.classList.toggle('active');
	            content.classList.toggle('content-shifted');
	        }

	        function showLoadingMessage() {
	            document.getElementById('loadingMessage').style.display = 'block';
	        }

	        function hideLoadingMessage() {
	            document.getElementById('loadingMessage').style.display = 'none';
	        }

	        document.getElementById('chat-form').addEventListener('submit', function(e) {
	            e.preventDefault();

	            const question = document.getElementById('question-input').value;

	            if (!globalUserId || isNaN(globalUserId)) {
	                alert("❗ 로그인 정보가 없어 대화 기록을 불러올 수 없습니다.");
	                return;
	            }

	            const chatBox = document.getElementById('chat-box');

	            const userBubble = document.createElement('div');
	            userBubble.className = 'bubble user';
	            userBubble.innerHTML = '<i class="fas fa-user"></i> ' + question;
	            chatBox.appendChild(userBubble);
	            chatBox.scrollTop = chatBox.scrollHeight;

	            showLoadingMessage();

	            fetch('http://localhost:8000/supplement/recommend', {
	                method: 'POST',
	                headers: {
	                    'Content-Type': 'application/x-www-form-urlencoded'
	                },
	                body: new URLSearchParams({ question, user_id: globalUserId })
	            })
	            .then(res => res.json())
	            .then(data => {
	                hideLoadingMessage();
	                const botBubble = document.createElement('div');
	                botBubble.className = 'bubble bot';
	                botBubble.innerHTML = '<i class="fas fa-robot"></i> ' + data.response;
	                chatBox.appendChild(botBubble);
	                chatBox.scrollTop = chatBox.scrollHeight;
	            })
	            .catch(err => {
	                hideLoadingMessage();
	                console.error("❌ 응답 오류:", err);
	                alert("❌ 챗봇 응답 중 문제가 발생했습니다.");
	            });

	            document.getElementById('question-input').value = '';
	        });

	        window.addEventListener("DOMContentLoaded", () => {
	            const rawId = document.body.dataset.userId;
	            const parsedId = parseInt(rawId);
	            console.log("✅ DOM 로드 완료 - rawId:", rawId, "→ parsed:", parsedId);
	            if (!isNaN(parsedId)) {
	                globalUserId = parsedId;
	            } else {
	                console.warn("⚠️ userId 파싱 실패:", rawId);
	            }
	        });
	    </script>
    <c:if test="${not empty welcomeMessage}">
        <c:if test="${sessionScope.loginUser.forceChange}">
            <script>alert("임시 비밀번호로 로그인하셨습니다.\n마이페이지에서 반드시 비밀번호를 변경해주세요!");</script>
        </c:if>
        <script>alert('${welcomeMessage}');</script>
    </c:if>
    <c:if test="${not empty error}">
        <script>alert('${error}');</script>
    </c:if>
    <c:if test="${not empty regmessage}">
        <script>alert("${regmessage}");</script>
    </c:if>
    <c:if test="${not empty regerrorMessage}">
        <script>alert("${regerrorMessage}");</script>
    </c:if>
</body>
</html>
