<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page import="java.security.Principal" %>
<%
    Principal principal = request.getUserPrincipal();
    String oauthUserEmail = principal != null ? principal.getName() : null;
%>
<html>
<head>
    <title>마이페이지</title>
    <style>
        .mypage-container {
            max-width: 500px;
            margin: 100px auto;
            padding: 30px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .mypage-container h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        .mypage-container label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
        }
        .mypage-container input {
            width: 100%;
            padding: 10px;
            margin-top: 6px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        .mypage-container button {
            margin-top: 20px;
            width: 100%;
            padding: 12px;
            background-color: #007bff;
            border: none;
            color: white;
            font-size: 16px;
            border-radius: 6px;
            cursor: pointer;
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
		.alert-box.warning {
			    padding: 12px;
			    background-color: #fff3cd;
			    border: 1px solid #ffeeba;
			    color: #856404;
			    border-radius: 6px;
			    margin-bottom: 20px;
			    text-align: center;
			    font-weight: bold;
			}
    </style>
</head>
<body>
    <div class="mypage-container">
        <h2>마이페이지</h2>
		<c:if test="${not empty message}">
		    <div class="alert-box success">
		        <c:out value="${message}" />
		    </div>
		</c:if>

		<!-- 에러 메시지 -->
		<c:if test="${not empty errorMessage}">
		    <div class="alert-box error">
		        <c:out value="${errorMessage}" />
		    </div>
		</c:if>
        <c:choose>
            <c:when test="${not empty sessionScope.loginUser}">
                <form action="/mypage/update" method="post">
                    <label for="userName">이름</label>
                    <input type="text" name="userName" value="${loginUser.userName}" required>

                    <label for="password">비밀번호</label>
                    <input type="password" name="password" value="${loginUser.password}" required>

                    <label for="email">이메일</label>
                    <input type="email" name="email" value="${loginUser.email}" required>

                    <label for="gender">성별</label>
                    <input type="text" name="gender" value="${loginUser.gender}" required>

                    <button type="submit">정보 수정</button>
                </form>

                <form id="deleteForm" action="/mypage/delete" method="post">
                    <input type="hidden" name="userId" value="${loginUser.userId}" />
                    <button type="button" class="btn delete-btn" onclick="confirmDelete()">회원 탈퇴</button>
                </form>
            </c:when>

            <c:otherwise>
                <form id="deleteForm" action="/mypage/delete" method="post">
                    <input type="hidden" name="userId" value="<%= oauthUserEmail %>" />
                    <button type="button" class="btn delete-btn" onclick="confirmDelete()">회원 탈퇴</button>
                </form>
            </c:otherwise>
        </c:choose>

        <button onclick="location.href='/index'" style="background-color:#28a745; margin-top:10px;">홈으로 이동</button>
    </div>

    <script>
        function confirmDelete() {
            if (confirm("정말 탈퇴하시겠습니까?")) {
                document.getElementById("deleteForm").submit();
            }
        }
    </script>

    <style>
        .btn.delete-btn {
            margin-top: 20px;
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 10px 16px;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
            width: 100%;
        }

        .btn.delete-btn:hover {
            background-color: #c82333;
        }
    </style>
</body>
</html>
