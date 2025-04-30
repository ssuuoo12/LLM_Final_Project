<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chatbot - Chat</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/image_JY.css">
</head>
<body>
    <jsp:include page="header.jsp" />
    <jsp:include page="sidebar.jsp" />

    <div id="main-content">
        <div class="upload-section">
            <h1>이미지기반 질환 진단 시스템</h1>
            <h3>진단할 이미지를 업로드하세요</h3>
            <form action="/diagnose" method="post" enctype="multipart/form-data">
                <input type="hidden" name="user_id" value="${sessionScope.loginUser.userId}" />
                <input type="hidden" name="user_name" value="${sessionScope.loginUser.userName}" />
                <div class="input-group">
                    <select name="disease" style="padding: 8px 12px; font-size: 16px; border: 1px solid #ccc; border-radius: 5px;">
                        <option value="eye">안구 질환</option>
                        <option value="Brain">뇌종양</option>
                        <option value="lc">폐암</option>
                    </select>
                    <input type="file" name="image" accept="image/*" style="padding: 8px 12px; border: 1px solid #ccc; border-radius: 5px;" />
                    <button type="submit" class="diagnose-btn">
                        <i class="fas fa-stethoscope"></i> 진단 요청
                    </button>
                </div>
            </form>

            <c:if test="${not empty resultImage}">
                <div class="result-section">
                    <h3>진단 결과</h3>
                    <div class="result-container">
                        <div class="result-image">
                            <img src="data:image/png;base64,${resultImage}" style="width: 100%; max-width: 600px;" />
                        </div>
                        <div class="result-info">
                            <div class="diagnosis-result">진단: ${diagnosis}</div>
                            <div class="confidence">
                                신뢰도: <fmt:formatNumber value="${confidence}" maxFractionDigits="3" />%
                            </div>
                            <div style="text-align: left; margin-top: 10px;">업로드된 파일명: ${fileName}</div>
                            <c:if test="${not empty response}">
                               <strong> <div class="bot-message" style="margin-top: 15px;">${response}</div></strong>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:if>
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