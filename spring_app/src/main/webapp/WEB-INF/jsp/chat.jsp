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

	        .history-list {
	            list-style: none;
	            padding: 0;
	            margin: 0 0 0 30px;
	            display: none;
	        }

	        .history-list li {
	            padding: 10px 20px;
	            font-size: 14px;
	            color: #bdc3c7;
	        }

	        .history-list li:hover {
	            background-color: #3e5c76;
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

	        /* 모델 선택 드롭다운 스타일 */
			.model-dropdown-container {
			    position: absolute;
			    top: -12px;
			    left: 20px;
			    z-index: 10;
			}


	        .model-dropdown-toggle {
	            background-color: #007bff;
	            border: none;
	            border-radius: 50%;
	            width: 30px;
	            height: 30px;
	            display: flex;
	            justify-content: center;
	            align-items: center;
	            cursor: pointer;
	        }

	        .model-dropdown-toggle i {
	            color: white;
	            font-size: 14px;
	        }

			.model-dropdown {
			    display: none;
			    position: absolute;
			    bottom: 40px; /* top 대신 bottom 사용 */
			    left: 0;
			    background-color: white;
			    border: 1px solid #ccc;
			    border-radius: 8px;
			    list-style: none;
			    padding: 10px 0;
			    width: 160px;
			    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
			    z-index: 1000;
			}
	        .model-dropdown li {
	            padding: 8px 16px;
	            cursor: pointer;
	            font-size: 14px;
	            color: #333;
	        }

	        .model-dropdown li:hover {
	            background-color: #f0f0f0;
	        }

	        /* 파일 및 이미지 업로드 버튼 스타일 */
	        .upload-buttons {
	            display: flex;
	            gap: 8px;
	            width: 100%;
	            justify-content: flex-start; /* 왼쪽 정렬 */
	            padding: 0 15px 10px 15px;
	        }

	        .upload-btn {
	            display: flex;
	            justify-content: center;
	            align-items: center;
	            cursor: pointer;
	            transition: color 0.3s ease;
	        }

	        .upload-btn i {
	            color: #6c757d; /* 기본 색상 */
	            font-size: 14px; /* 아이콘 크기 줄임 */
	        }

	        .upload-btn.image i {
	            color: #17a2b8; /* 이미지 업로드 아이콘 색상 */
	        }

	        .upload-btn:hover i {
	            color: #5a6268;
	        }

	        .upload-btn.image:hover i {
	            color: #138496;
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
	    </style>
</head>
<body>
	
    <jsp:include page="header.jsp" />
    <jsp:include page="sidebar.jsp" />
	
    <div id="main-content">
        <div class="chat-welcome">안녕하세요! 챗봇과 대화를 시작해보세요!</div>

        <div class="chat-input-container">
            <div class="model-dropdown-container">
                <button id="model-dropdown-toggle" class="model-dropdown-toggle">
                    <i class="fas fa-robot"></i>
                </button>
                <ul id="model-dropdown" class="model-dropdown">
                    <li onclick="selectModel('image')">이미지 진단</li>
                    <li onclick="selectModel('score')">건강점수 체크</li>
                    <li onclick="selectModel('diet')">식단 추천</li>
                </ul>
            </div>
			<sec:authorize access="isAuthenticated()">
			    <!-- 로그인된 사용자 UI -->
			    <div class="chat-input-wrapper">
			        <textarea class="chat-input" placeholder="메시지를 입력하세요..." rows="1"></textarea>
			        <button class="send-btn"><i class="fas fa-paper-plane"></i></button>
			    </div>
			</sec:authorize>

			<sec:authorize access="isAnonymous()">
			    <!-- 로그인하지 않은 사용자 -->
			    <h3>로그인 또는 회원가입 후 이용 가능합니다.</h3>
			</sec:authorize>
            <div class="upload-buttons">
                <label for="file-upload" class="upload-btn">
                    <i class="fas fa-paperclip"></i>
                </label>
                <input type="file" id="file-upload" style="display: none;" multiple />

                <label for="image-upload" class="upload-btn image">
                    <i class="fas fa-image"></i>
                </label>
                <input type="file" id="image-upload" style="display: none;" accept="image/*" multiple />
            </div>
        </div>
    </div>

    <script>
        function toggleSidebar() {
            const sidebar = document.getElementById('sidebar');
            const content = document.getElementById('main-content');
            sidebar.classList.toggle('active');
            content.classList.toggle('content-shifted');
        }

        function toggleHistory(event) {
            event.preventDefault();
            const historyList = document.getElementById('history-list');
            historyList.style.display = historyList.style.display === 'block' ? 'none' : 'block';
        }

        const dropdownToggle = document.getElementById('model-dropdown-toggle');
        const dropdown = document.getElementById('model-dropdown');
        dropdownToggle.addEventListener('click', (e) => {
            e.stopPropagation();
            dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
        });

        document.addEventListener('click', (e) => {
            if (dropdown.style.display === 'block' && !dropdown.contains(e.target)) {
                dropdown.style.display = 'none';
            }
        });

        function selectModel(modelName) {
            alert(`선택된 모델: ${modelName}`);
            dropdown.style.display = 'none';
        }

        document.getElementById('file-upload').addEventListener('change', function () {
            const files = this.files;
            if (files.length > 0) {
                alert(`${files.length}개의 파일을 업로드했습니다.`);
            }
        });

        document.getElementById('image-upload').addEventListener('change', function () {
            const images = this.files;
            if (images.length > 0) {
                alert(`${images.length}개의 이미지를 업로드했습니다.`);
            }
        });

        const chatInput = document.querySelector('.chat-input');
        chatInput.addEventListener('input', function() {
            this.style.height = 'auto';
            this.style.height = Math.min(this.scrollHeight, 150) + 'px';
        });
        chatInput.style.height = '55px';
    </script>
	<c:if test="${not empty welcomeMessage}">
		<c:if test="${sessionScope.loginUser.forceChange}">
			    <script>
			        alert("임시 비밀번호로 로그인하셨습니다.\n마이페이지에서 반드시 비밀번호를 변경해주세요!");
			    </script>
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
