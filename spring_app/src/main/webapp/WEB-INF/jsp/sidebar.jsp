<!--sidebar.jsp-->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<div id="sidebar" class="sidebar">
    <ul class="menu">
        <sec:authorize access="isAuthenticated()">
            <li><a href="/mypage"><i class="fas fa-user-cog"></i> 마이페이지</a></li>
        </sec:authorize>

        <%-- 추후 대화 기록 구현 예정 --%>
        <!--
        <li>
            <a href="/history" onclick="toggleHistory(event)"><i class="fas fa-history"></i> 대화 기록</a>
            <ul id="history-list" class="history-list">
                <li>2025-04-10 챗봇 상담</li>
                <li>2025-04-09 건강점수 체크</li>
                ...
            </ul>
        </li>
        -->
    </ul>

    <div class="sidebar-footer">
        <a href="/logout" class="footer-btn"><i class="fas fa-sign-out-alt"></i> 로그아웃</a>
    </div>
</div>
