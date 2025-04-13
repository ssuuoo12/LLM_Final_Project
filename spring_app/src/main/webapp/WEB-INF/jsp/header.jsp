<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div class="header">
    <div class="header-left">
        <i class="fas fa-bars toggle-icon" onclick="toggleSidebar()"></i>
        <span class="header-title">헬스케어</span>
    </div>

    <div class="header-right">
        <i class="fas fa-user-circle user-icon"></i>

        <sec:authorize access="isAnonymous()">
            <button class="btn login-btn" onclick="openLoginModal()">로그인</button>
            <button class="btn signup-btn" onclick="location.href='/register'">회원가입</button>
        </sec:authorize>

        <sec:authorize access="isAuthenticated()">
            <c:choose>
                <c:when test="${not empty sessionScope.loginUser}">
                    <%-- 일반 로그인 --%>
                    <span style="margin-right:10px; font-weight:bold; color: #333;">
                        ${sessionScope.loginUser.userName}님 접속중
						<c:if test="${sessionScope.loginUser.forceChange}">
							<span style="color: red;">(비밀번호 변경 필요!)</span>
						</c:if>
                    </span>
                </c:when>
                <c:otherwise>
                    <%-- 소셜 로그인 --%>
                    <span style="margin-right:10px; font-weight:bold; color: #333;">
                        ${pageContext.request.userPrincipal.name} 님 접속중
                    </span>
                </c:otherwise>
            </c:choose>

            <form id="logoutForm" action="/logout" method="post" style="display:inline;">
                <button class="btn signup-btn" type="button" onclick="confirmLogout()">로그아웃</button>
            </form>
        </sec:authorize>
    </div>
</div>

<!-- 로그인 모달 -->
<div id="loginModal" class="modal" style="display:none;">
    <div class="modal-content">
        <span class="close" onclick="closeLoginModal()">&times;</span>
        <h2>로그인</h2>
        <form action="/login" method="post">
            <input type="text" name="userId" placeholder="아이디" required><br>
            <input type="password" name="password" placeholder="비밀번호" required><br>
            <button type="submit" class="btn login-btn" style="width: 100%; margin-top: 10px;">로그인</button>
        </form>
		
		<div style="margin-top: 15px; text-align:center;">
			<a href="/find" style="margin-right: 10px; color: #007bff;">아이디 찾기</a>
			<a href="/find" style="margin-left: 10px; color: #007bff;">비밀번호 찾기</a>
		</div>
        
		<div style="text-align: center; margin-top: 20px;">
            <h4>소셜 로그인</h4>
            <a href="/oauth2/authorization/google">
                <img src="https://developers.google.com/identity/images/g-logo.png" alt="Google Login" style="height: 40px;">
            </a>
        </div>
    </div>
</div>

<style>
.modal {
    position: fixed;
    z-index: 2000;
    left: 0; top: 0;
    width: 100%; height: 100%;
    overflow: auto;
    background-color: rgba(0,0,0,0.4);
}

.modal-content {
    background-color: #fff;
    margin: 10% auto;
    padding: 20px 30px;
    border-radius: 10px;
    width: 360px;
    box-shadow: 0 5px 15px rgba(0,0,0,0.3);
}

.modal-content input {
    width: 100%;
    padding: 10px;
    margin-top: 10px;
    font-size: 14px;
    border: 1px solid #ccc;
    border-radius: 5px;
}

.close {
    float: right;
    font-size: 24px;
    font-weight: bold;
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
</style>

<script>
function openLoginModal() {
    document.getElementById('loginModal').style.display = 'block';
}
function closeLoginModal() {
    document.getElementById('loginModal').style.display = 'none';
}
window.onclick = function(event) {
    const modal = document.getElementById('loginModal');
    if (event.target === modal) {
        modal.style.display = 'none';
    }
}
function confirmLogout() {
    if (confirm('정말 로그아웃 하시겠습니까?')) {
        document.getElementById('logoutForm').submit();
    }
}
</script>
