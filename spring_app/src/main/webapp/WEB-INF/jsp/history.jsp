<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>대화 이력</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .chat-entry {
            border: 1px solid #ccc;
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 6px;
        }
        .question {
            font-weight: bold;
        }
        .answer {
            margin-top: 8px;
            color: #555;
        }
        .empty-message {
            margin-top: 20px;
            font-style: italic;
            color: #888;
        }
    </style>
</head>
<body>
    <h2>헬슈테크 대화 이력</h2>
	<button onclick="location.href='/chat'" style="background-color:#28a745; margin-top:10px;">채팅 페이지로 이동</button>
    <c:choose>
        <c:when test="${not empty chatHistory}">
            <c:forEach var="chat" items="${chatHistory}">
                <div class="chat-entry">
                    <div class="question">Q. ${chat.message}</div>
                    <div class="answer">A. ${chat.response}</div>
                    <div style="font-size: 0.8em; color: gray;">${chat.createdAt}</div>
                </div>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="empty-message">대화 이력이 없습니다.</div>
        </c:otherwise>
    </c:choose>
</body>
</html>
