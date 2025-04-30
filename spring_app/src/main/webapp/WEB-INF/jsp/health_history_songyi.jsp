<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>검사 이력 조회</title>
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
			 /*나의 검진 이력 스타일*/
			 h2 {
			             color: #2c3e50;
			             text-align: center;
			         }
			         table {
			             width: 90%;
			             margin: 20px auto;
			             border-collapse: collapse;
			             background-color: #fff;
			             box-shadow: 0 4px 10px rgba(0,0,0,0.1);
			         }
			         th, td {
			             border: 1px solid #ddd;
			             padding: 14px;
			             text-align: center;
			         }
			         th {
			             background-color: #3498db;
			             color: white;
			         }
			         tr:hover {
			             background-color: #f1f1f1;
			         }
			         .message {
			             text-align: center;
			             margin-top: 40px;
			             color: #888;
			             font-size: 16px;
			         }
					 /* 생략된 스타일 정의 (header, sidebar 등) */
					 .pagination {
					   margin-top: 20px;
					   text-align: center;
					 }
					 .pagination a {
					   display: inline-block;
					   padding: 8px 12px;
					   margin: 0 4px;
					   background-color: #3498db;
					   color: white;
					   border-radius: 4px;
					   text-decoration: none;
					 }
					 .pagination a.active {
					   background-color: #2c3e50;
					 }
					 .pagination a:hover {
					   background-color: #2980b9;
					 }
					 /* 표 위치 조정 */
					 .table-wrapper {
					     margin-top: 40px; 
					 }
      </style>
</head>
<body>
   <jsp:include page="header.jsp" />
   <jsp:include page="sidebar.jsp" />
	<h2>📂 나의 건강검진 이력</h2>
	<c:if test="${not empty historyPage.content}">
		<div class="table-wrapper">
	    <table>
	        <thead>
	        <tr>
	            <th>파일명</th>
	            <th>건강 점수</th>
	            <th>위험도</th>
	            <th>등록일</th>
	        </tr>
	        </thead>
	        <tbody>
	        <c:forEach var="item" items="${historyPage.content}">
	            <tr>
	                <td>${item.fileName}</td>
	                <td>${item.score}</td>
	                <td>${item.riskLevel}</td>
	                <td><fmt:formatDate value="${item.regDateAsDate}" pattern="yyyy-MM-dd HH:mm"/></td>
	            </tr>
	        </c:forEach>
	        </tbody>
	    </table>
	</c:if>
	<c:if test="${empty historyPage.content}">
	    <div class="message">이력이 존재하지 않습니다.</div>
	</c:if>
	<!-- ✅ 페이징 네비게이션 -->
	<div style="text-align:center; margin-top: 20px;">
	    <c:forEach var="i" begin="0" end="${totalPages - 1}">
	        <c:choose>
	            <c:when test="${i == currentPage}">
	                <span style="font-weight: bold; margin: 0 5px;">${i + 1}</span>
	            </c:when>
	            <c:otherwise>
	                <a href="/health/history?page=${i}" style="margin: 0 5px; text-decoration: none;">${i + 1}</a>
	            </c:otherwise>
	        </c:choose>
    </c:forEach>
	</div>
</div>
  
<script>
	const sidebar = document.getElementById('sidebar');
	const content = document.getElementById('main-content');
	function toggleSidebar() {
	            sidebar.classList.toggle('active');
	            content.classList.toggle('content-shifted');
	        }
</script>
   <!-- ✅ Flash 메시지 알림 -->
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