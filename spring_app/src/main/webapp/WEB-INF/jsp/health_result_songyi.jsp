<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chatbot - Chat</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
   <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
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
                 /*미세조정*/
                 .header-right span {
                     margin-top: 2px; /* 유저명 텍스트 위로 */
                     display: flex;
                     align-items: center;
                 }
                 /*미세조정*/
                 .header-right .btn {
                     margin-top: 2px; /* 버튼도 살짝 위로 */
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
         .container {
             max-width: 800px;
             margin: 100px auto 60px auto; /* 헤더 고려해서 상단 여백 추가 */
             background: #ffffff;
             padding: 2.5rem;
             border-radius: 12px;
             box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
             text-align: center;
         }

         h1 {
             font-size: 28px;
             color: #2c3e50;
             margin-bottom: 1.5rem;
         }

         h3 {
             color: #2c3e50;
             margin-top: 2rem;
             font-size: 20px;
         }

         .file-name,
         .score,
         .risk,
         .ai-explanation {
             font-size: 1.15rem;
             margin: 1rem 0;
             color: #333;
         }

         .score strong {
             color: #27ae60; /* 건강 점수 초록 강조 */
         }
         .risk strong {
             color: #e74c3c; /* 위험도는 붉게 강조 */
         }

         ul {
             text-align: left;
             margin-top: 1rem;
             padding-left: 1.5rem;
         }

         .btn {
             display: inline-block;
             margin: 1.5rem 0.5rem 0 0.5rem;
             padding: 0.7rem 1.5rem;
             background-color: #3498db;
             color: white;
             text-decoration: none;
             border-radius: 6px;
             font-size: 15px;
             transition: background-color 0.3s ease;
         }

         .btn:hover {
             background-color: #2980b9;
         }

         .shap-image {
             margin-top: 2rem;
             text-align: center;
         }

         .shap-image img {
             max-width: 100%;
             max-height: 400px;
             margin-top: 1rem;
             border-radius: 12px;
             box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
         }
         /* 버튼 그룹 중앙 정렬 */
         .button-group {
             display: flex;
             justify-content: center;
             align-items: center;
             gap: 16px;
             margin-top: 2rem;
             flex-wrap: wrap;
         }

         .download-btn {
             background-color: #2ecc71;
         }
         .download-btn:hover {
             background-color: #27ae60;
         }

         .retry-btn {
             background-color: #3498db;
         }
         .retry-btn:hover {
             background-color: #2980b9;
         }
       </style>
</head>

<body>
    <jsp:include page="header.jsp" />
    <jsp:include page="sidebar.jsp" />
   <div class="container">
       <h1>📊 건강 점수 분석 결과</h1>
       <div class="file-name">📁 파일명: <strong>${fileName}</strong></div>
       <div class="score">🔢 건강 점수: <strong>${score}</strong></div>
       <div class="risk">🚨 위험 수준: <strong>${risk}</strong></div>

       <c:if test="${not empty explanation}">
           <div class="ai-explanation">🧠 AI 해석: <strong>${explanation}</strong></div>
       </c:if>

       <c:if test="${not empty topFeatures}">
           <h3>📌 예측에 영향을 미친 주요 지표 Top 3</h3>
           <ul>
               <c:forEach var="feature" items="${topFeatures}">
                   <li>${feature}</li>
               </c:forEach>
           </ul>
       </c:if>

       <c:if test="${not empty shapImage}">
           <div class="shap-image">
               <h3>📈 SHAP 시각화</h3>
               <img src="data:image/png;base64,${shapImage}" alt="SHAP 이미지" />
           </div>
       </c:if>

       <form method="post" action="/health/download-report">
           <input type="hidden" name="score" value="${score}" />
           <input type="hidden" name="risk" value="${risk}" />
           <input type="hidden" name="explanation" value="${explanation}" />
           <input type="hidden" name="fileName" value="${fileName}" />
           <input type="hidden" name="shapImage" value="${shapImage}" />
           
       </form>

       
   </div>
   <!-- ✅ 버튼 그룹 통합 -->
   <div class="button-group">
       <button type="button" class="btn download-btn" onclick="downloadPdf()">📥 PDF 리포트 다운로드</button>
       <a href="/health" class="btn retry-btn">🔄 다시 분석하기</a>
       <a href="/supplement" class="btn" style="background-color: #9b59b6;">💬 챗봇에게 상담하러 가기</a>
   </div>
<script>
   const sidebar = document.getElementById('sidebar');
   const content = document.getElementById('main-content');
   function toggleSidebar() {
               sidebar.classList.toggle('active');
               content.classList.toggle('content-shifted');
           }
   // pdf 다운
   function downloadPdf() {
       const element = document.querySelector('.container'); // PDF로 만들고 싶은 DOM 요소

       const opt = {
           margin:       0.5,
           filename:     'health_report.pdf',
           image:        { type: 'jpeg', quality: 0.98 },
           html2canvas:  { scale: 2 },
           jsPDF:        { unit: 'in', format: 'a4', orientation: 'portrait' }
       };

       html2pdf().set(opt).from(element).save();
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
