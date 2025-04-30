<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>이미지 진단 이력</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/image_JY.css">

		<style>
		    body {
		        font-family: Arial, sans-serif;
		        margin: 0;
		        padding-top: 70px;
		        background-color: #f8f9fa;
		    }
		    .chat-entry {
		        border: 1px solid #ccc;
		        padding: 10px;
		        margin: 15px auto;
		        border-radius: 6px;
		        width: 80%;
		        max-width: 800px;
		        background-color: #fff;
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
		        text-align: center;
		    }
			
			
			.fancy-button {
			    background-color: #28a745;
			    color: white;
			    border: none;
			    padding: 12px 24px;
			    font-size: 16px;
			    border-radius: 8px;
			    cursor: pointer;
			    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
			    transition: all 0.3s ease;
			    margin: 20px auto;
			    display: block;
			    font-weight: 500;
			}

			.fancy-button:hover {
			    background-color: #218838;
			    box-shadow: 0 6px 10px rgba(0, 0, 0, 0.15);
			    transform: translateY(-2px);
			}
			
			
		</style>

</head>
<body>
    <jsp:include page="header.jsp" />
    <jsp:include page="sidebar.jsp" />

    
	<div style="padding-top: 70px;" id="main-content">


	<c:choose>
	    <c:when test="${not empty imagehistory}">
	        <c:forEach var="chat2" items="${imagehistory}">
	            <div class="chat-entry">
	                <div class="question">Q. ${chat2.fileName}</div>
	                <div class="answer">A. ${chat2.diagnosis}</div>
					<div class="answer2">A. ${chat2.diseaseType}</div>
	                <div style="font-size: 0.8em; color: gray;">${chat2.createdAt}</div>
	            </div>
	        </c:forEach>
	    </c:when>
	    <c:otherwise>
	        <div class="empty-message">이미지 진단 이력이 없습니다.</div>
	    </c:otherwise>
	</c:choose>
<button class="fancy-button" onclick="location.href='/diagnose'">이미지 진단 페이지로 이동</button>
	
</div>
	

<c:if test="${totalPages > 0}">
  <div style="text-align:center; margin-top: 20px;">
       <c:forEach var="i" begin="0" end="${totalPages - 1}">
           <c:choose>
               <c:when test="${i == currentPage}">
                   <span style="font-weight: bold; margin: 0 5px;">${i + 1}</span>
               </c:when>
               <c:otherwise>
                   <a href="/imagehistory?page=${i}" style="margin: 0 5px; text-decoration: none;">${i + 1}</a>
               </c:otherwise>
           </c:choose>
       </c:forEach>
  </div>
</c:if>
</div>

	<script>
	       const sidebar = document.getElementById('sidebar');
	       const content = document.getElementById('main-content');
	       function toggleSidebar() {
	           sidebar.classList.toggle('active');
	           content.classList.toggle('content-shifted');
	       }
	   </script>
	
</body>
</html>