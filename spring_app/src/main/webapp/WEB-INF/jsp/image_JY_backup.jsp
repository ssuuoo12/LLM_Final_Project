<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>이미지 질병 진단</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/diagnosis_JY.css">
</head>
<body>

<div class="container">
    <div class="header">
        <h1>이미지기반 질환 진단 시스템</h1>
    </div>

    <div class="upload-section" style="text-align: center;">
        <h3>진단할 이미지를 업로드하세요</h3>
        <form action="/diagnose" method="post" enctype="multipart/form-data">
			
			<input type="hidden" name="user_id" value="${sessionScope.loginUser.userId}" />
			 <input type="hidden" name="user_name" value="${sessionScope.loginUser.userName}" />
			    
			
			
            <div class="input-group" style="display: flex; justify-content: center; align-items: center; gap: 10px; margin-bottom: 10px;">
                <select name="disease" style="padding: 5px 8px; font-size: 0.9em; width: 120px;">
                    <option value="eye">안구 질환</option>
                    <option value="Brain">뇌종양</option>
                    <option value="lc">폐암</option>
                </select>
                <input type="file" name="image" accept="image/*" style="margin: 0; padding: 6px; border: 1px solid #ccc;" />
                <button type="submit" >진단 요청</button>
            </div>
        </form>
    </div>

    <c:if test="${not empty resultImage}">
        <div class="result-section">
            <h3>진단 결과</h3>
            <div class="result-container">
                <div class="result-image">
                    <img src="data:image/png;base64,${resultImage}" style="width: 100%; max-width: 512px;" />
                </div>

                <div class="result-info">
                    <div class="diagnosis-result">
                        진단: ${diagnosis}
                    </div>
                    <div class="confidence">
                        신뢰도: <fmt:formatNumber value="${confidence}" maxFractionDigits="3" />%
                    </div>
                    <div style="text-align: left; margin-top: 10px;">
                        업로드된 파일명: ${fileName}
                    </div>

                    <!-- 진단 결과 메시지 포함 -->
                    <c:if test="${not empty response}">
                        <div class="bot-message" style="margin-top: 15px;">
                            ${response}
                        </div>
                    </c:if>

                </div>
            </div>
        </div>
    </c:if>
</div>
</body>
</html>
