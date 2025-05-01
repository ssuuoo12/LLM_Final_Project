<!--sidebar.jsp-->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<div id="sidebar" class="sidebar">
    <ul class="menu">
		<sec:authorize access="isAuthenticated()">
			<li><a href="/diagnose"><i class="fas fa-image"></i> 이미지 진단</a></li>	    
		</sec:authorize>
		<sec:authorize access="isAuthenticated()">
			<li><a href="/imagehistory"><i class="fas fa-history"></i> 이미지 진단 이력</a></li>
		</sec:authorize>
		
		<sec:authorize access="isAuthenticated()">
			<li><a href="/health"><i class="fas fa-heartbeat"></i> 건강점수 체크</a></li>
		</sec:authorize>
		<sec:authorize access="isAuthenticated()">
			<li><a href="/health/history"><i class="fas fa-notes-medical"></i> 건강점수 이력</a></li> 
		</sec:authorize>		
		<sec:authorize access="isAuthenticated()">
			<li><a href="/supplement"><i class="fas fa-capsules"></i> 건강점수기반 건강기능식품 추천 챗봇</a></li>
		</sec:authorize>
		<sec:authorize access="isAuthenticated()">
			<li><a href="/SupplementHistory?userId=${sessionScope.loginUser.id}"><i class="fas fa-history"></i>건강점수기반 건강기능식품 추천 챗봇 대화 이력</a></li>
		</sec:authorize>
		<sec:authorize access="isAuthenticated()">
			<li><a href="dietForm"><i class="fas fa-utensils"></i> 식단 추천</a></li>
		</sec:authorize>
		<sec:authorize access="isAuthenticated()">
			<li><a href="/chat"><i class="fas fa-robot"></i> 헬슈 챗봇</a></li>
		</sec:authorize>
		<sec:authorize access="isAuthenticated()">
			<li><a href="/history"><i class="fas fa-history"></i> 대화 이력조회</a></li>
		</sec:authorize>

		<sec:authorize access="isAuthenticated()">
			<li><a href="/mapc"><i class="fas fa-history"></i> 장소 추천 챗봇</a></li>
		</sec:authorize>
					
		<sec:authorize access="isAuthenticated()">
			<li><a href="/mapc/history"><i class="fas fa-user-cog"></i> 장소 대화 이력</a></li>
		</sec:authorize>
		<sec:authorize access="isAuthenticated()">
			<li><a href="/mypage"><i class="fas fa-user-cog"></i> 마이페이지</a></li>
		</sec:authorize>
					
    </ul>

    <div class="sidebar-footer">
        <a href="/logout" class="footer-btn"><i class="fas fa-sign-out-alt"></i> 로그아웃</a>
    </div>
</div>
