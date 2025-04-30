<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <title>헬슈케어 메인 + 챗봇</title>
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
		/**/
		#main-content {
		            padding: 80px 30px 150px 30px;
		            transition: margin-left 0.3s ease;
		            min-height: 100vh;
		            display: flex;
		            flex-direction: column;
		            align-items: center;
		            justify-content: flex-start;
		        }
		        .chat-welcome {
		            font-size: 28px;
		            font-weight: 600;
		            color: #333;
		            text-align: center;
		            margin-bottom: 20px;
		        }
		        .slider {
		            width: 100%;
		            max-width: 800px;
		            height: 300px;
		            overflow: hidden;
		            border-radius: 10px;
		            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
		            margin-bottom: 30px;
		        }
		        .slides {
		            display: flex;
		            transition: transform 0.5s ease-in-out;
		        }
		        .slides img {
		            width: 800px;
		            height: 300px;
		            object-fit: cover;
		            flex-shrink: 0;
		        }
		        .grid-container {
		            display: grid;
		            grid-template-columns: repeat(2, 1fr);
		            gap: 40px;
		            max-width: 1000px;
		            margin: 0 auto 60px auto;
		        }
		        .feature-box {
		            background: #ffffff;
		            border-radius: 16px;
		            padding: 30px;
		            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.05);
		            transition: all 0.3s ease;
		            display: flex;
		            flex-direction: column;
		            align-items: flex-start;
		        }
		        .feature-title {
		            font-size: 22px;
		            font-weight: 600;
		            color: #34495e;
		            margin-bottom: 12px;
		            display: flex;
		            align-items: center;
		            gap: 12px;
		        }
		        .feature-title i {
		            color: #007bff;
		            font-size: 22px;
		        }
		        .feature-desc {
		            font-size: 15px;
		            color: #666;
		            line-height: 1.6;
		        }
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
		        }
		        .chat-input-wrapper {
		            display: flex;
		            align-items: center;
		            width: 100%;
		        }
		        .chat-input {
		            flex-grow: 1;
		            padding: 15px 20px 15px 50px;
		            border: 1px solid #ddd;
		            border-radius: 25px;
		            font-size: 16px;
		            outline: none;
		            min-height: 55px;
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
		            margin-left: 10px;
		        }
		        .send-btn i {
		            color: white;
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
				/*대화 내역기록*/
				.history-box {
				            background: white;
				            border-radius: 10px;
				            padding: 20px;
				            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
				            margin-bottom: 20px;
				        }
				        .question {
				            font-weight: bold;
				            color: #0d47a1;
				        }
				        .response {
				            margin-top: 10px;
				            color: #333;
				        }
						/*페이징*/
						.pagination {
						           display: flex;
						           justify-content: center;
						           margin-top: 20px;
						       }
						       .pagination a {
						           color: #007bff;
						           padding: 8px 12px;
						           margin: 0 4px;
						           text-decoration: none;
						           border: 1px solid #ddd;
						           border-radius: 5px;
						           transition: background-color 0.3s;
						       }
						       .pagination a.active, .pagination a:hover {
						           background-color: #007bff;
						           color: white;
						           border-color: #007bff;
						       }
   </style>
</head>
<body>
<jsp:include page="header.jsp" />
<jsp:include page="sidebar.jsp" />
	<h2>🧾 최근 질문 내역</h2>
    <c:forEach var="item" items="${historyList}">
        <div class="history-box">
            <div class="question">🙋‍♂️ 질문: ${item.question}</div>
            <div class="response">🤖 응답: <c:out value="${item.response}" escapeXml="false"/></div>
        </div>
    </c:forEach>
    <div class="pagination">
        <c:if test="${currentPage > 1}">
            <a href="?userId=${userId}&page=${currentPage - 1}">&laquo; 이전</a>
        </c:if>
        <c:forEach begin="1" end="${totalPages}" var="i">
            <a href="?userId=${userId}&page=${i}" class="${i == currentPage ? 'active' : ''}">${i}</a>
        </c:forEach>
        <c:if test="${currentPage < totalPages}">
            <a href="?userId=${userId}&page=${currentPage + 1}">다음 &raquo;</a>
        </c:if>
    </div>
<script>
	document.addEventListener("DOMContentLoaded", () => {
	      const sidebar = document.getElementById('sidebar');
	      const content = document.getElementById('main-content');
	      window.toggleSidebar = () => {
	        sidebar.classList.toggle('active');
	        content.classList.toggle('content-shifted');
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