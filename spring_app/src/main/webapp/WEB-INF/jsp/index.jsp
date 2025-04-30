<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <title>헬슈케어</title>
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
		/**/
		#main-content {
		            padding: 80px 30px 150px 30px;
		            transition: margin-left 0.3s ease;
		            min-height: 100vh;
		            display: flex;
		            flex-direction: column;
		            align-items: center;
		            justify-content: flex-start;
		        }
		        .chat-welcome {
		            font-size: 28px;
		            font-weight: 600;
		            color: #333;
		            text-align: center;
		            margin-bottom: 20px;
		        }
		        .slider {
		            width: 100%;
		            max-width: 800px;
		            height: 300px;
		            overflow: hidden;
		            border-radius: 10px;
		            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
		            margin-bottom: 30px;
		        }
		        .slides {
		            display: flex;
		            transition: transform 0.5s ease-in-out;
		        }
		        .slides img {
		            width: 800px;
		            height: 300px;
		            object-fit: cover;
		            flex-shrink: 0;
		        }
		        .grid-container {
		            display: grid;
		            grid-template-columns: repeat(2, 1fr);
		            gap: 40px;
		            max-width: 1000px;
		            margin: 0 auto 60px auto;
		        }
		        .feature-box {
		            background: #ffffff;
		            border-radius: 16px;
		            padding: 30px;
		            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.05);
		            transition: all 0.3s ease;
		            display: flex;
		            flex-direction: column;
		            align-items: flex-start;
		        }
		        .feature-title {
		            font-size: 22px;
		            font-weight: 600;
		            color: #34495e;
		            margin-bottom: 12px;
		            display: flex;
		            align-items: center;
		            gap: 12px;
		        }
		        .feature-title i {
		            color: #007bff;
		            font-size: 22px;
		        }
		        .feature-desc {
		            font-size: 15px;
		            color: #666;
		            line-height: 1.6;
		        }
		        .chat-input-container {
		            position: fixed;
		            bottom: 20px;
		            left: 50%;
		            transform: translateX(-50%);
		            width: 100%;
		            max-width: 800px;
		            background-color: #ffffff;
		            border-radius: 15px;
		            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
		            padding: 15px 20px;
		        }
		        .chat-input-wrapper {
		            display: flex;
		            align-items: center;
		            width: 100%;
		        }
		        .chat-input {
		            flex-grow: 1;
		            padding: 15px 20px 15px 50px;
		            border: 1px solid #ddd;
		            border-radius: 25px;
		            font-size: 16px;
		            outline: none;
		            min-height: 55px;
		            resize: none;
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
		            margin-left: 10px;
		        }
		        .send-btn i {
		            color: white;
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
		            white-space: pre-line;
		        }
   </style>
</head>
<body>
<jsp:include page="header.jsp" />
<jsp:include page="sidebar.jsp" />
<div id="main-content">
   <div class="slider">
       <div class="slides">
           <img src="https://plus.unsplash.com/premium_photo-1699387204388-120141c76d51?w=800&auto=format&fit=crop&q=60" alt="AI Health Monitoring" />
           <img src="https://plus.unsplash.com/premium_photo-1683121710572-7723bd2e235d?w=800&auto=format&fit=crop&q=60" alt="Medical AI" />
           <img src="https://plus.unsplash.com/premium_photo-1661329820722-3a38e945083b?w=800&auto=format&fit=crop&q=60" alt="Insurance Tech" />
       </div>
   </div>
   <div class="grid-container">
       <div class="feature-box"><div class="feature-title"><i class="fas fa-comments"></i> 상담 챗봇</div><div class="feature-desc">증상 입력 → 질병 예측 + 보험 추천</div></div>
       <div class="feature-box"><div class="feature-title"><i class="fas fa-chart-line"></i> 건강 점수 체크</div><div class="feature-desc">건강검진파일 업로드 → 건강 점수 + 위험도 분석</div></div>
       <div class="feature-box"><div class="feature-title"><i class="fas fa-utensils"></i> 식단 추천</div><div class="feature-desc">건강 상태 기반 AI 식단 제공</div></div>
       <div class="feature-box"><div class="feature-title"><i class="fas fa-x-ray"></i> 이미지 진단</div><div class="feature-desc">X-ray/CT/MRI 업로드 → 질환 AI 예측</div></div>
       <div class="feature-box"><div class="feature-title"><i class="fas fa-map-marked-alt"></i> 장소 추천 챗봇</div><div class="feature-desc">위치 기반 건강시설 추천 + 지도 연동</div></div>
       <div class="feature-box"><div class="feature-title"><i class="fas fa-capsules"></i> 영양제 추천 챗봇</div><div class="feature-desc">공공데이터 기반 사용자 맞춤형 건강기능식품 추천</div></div>
   </div>
</div>
<script>
	document.addEventListener("DOMContentLoaded", () => {
	      // 사이드바 toggle
	      const sidebar = document.getElementById('sidebar');
	      const content = document.getElementById('main-content');
	      window.toggleSidebar = () => {
	        sidebar.classList.toggle('active');
	        content.classList.toggle('content-shifted');
	      }
	      // 등장 애니메이션
	      const observer = new IntersectionObserver((entries) => {
	        entries.forEach(entry => {
	          if (entry.isIntersecting) {
	            entry.target.classList.add("show");
	          }
	        });
	      }, { threshold: 0.1 });
	      document.querySelectorAll('.feature-box').forEach(el => observer.observe(el));
	      document.querySelectorAll('.feature-box').forEach(box => {
	        box.addEventListener('click', () => {
	          box.classList.toggle('expanded');
	        });
	      });
	      // 이미지 슬라이더
	      const slides = document.querySelector(".slides");
	      const slideImages = document.querySelectorAll(".slides img");
	      console.log("\u{1F4E6} 슬라이더 디버깅 시작");
	      console.log("slides 요소:", slides);
	      console.log("이미지 수:", slideImages.length);
	      if (!slides || slideImages.length === 0) {
	        console.error("슬라이더 요소 또는 이미지가 존재하지 않습니다.");
	        return;
	      }
	      let currentIndex = 0;
	      setTimeout(() => {
	        const imageWidth = slideImages[0].clientWidth;
	        console.log("첫 이미지 너비:", imageWidth);
			 function showNextSlide() {
			     currentIndex = (currentIndex + 1) % slideImages.length;
			     const offset = currentIndex * imageWidth;
			     console.log("➡️ 슬라이드 이동 - 인덱스:", currentIndex, "이동 거리:", offset + "px");
			     slides.style.transform = "translateX(-" + offset + "px)";
			 }
	        setInterval(showNextSlide, 3000);
	      }, 100);
	    });
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