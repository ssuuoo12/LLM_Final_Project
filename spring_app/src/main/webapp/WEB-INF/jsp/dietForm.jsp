<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>식단 추천 입력</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
/* 헤더 스타일 */
.header {
	width: 98%;
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

body {
	font-family: 'Noto Sans KR', sans-serif;
	background-color: #f4f4f4;
	margin: 0;
	padding: 0;
}

.div {
	display: flex;
	margin-top: 80px;
}

.content {
	flex: 1;
	padding: 140px;
	display: flex;
	justify-content: center;
	align-items: center;
}

.form-container {
	background-color: #ffffff;
	padding: 40px;
	border-radius: 15px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
	max-width: 500px;
	width: 100%;
}

h2 {
	text-align: center;
	margin-bottom: 30px;
	color: #333333;
}

form {
	display: flex;
	flex-direction: column;
	gap: 20px;
}

label {
	font-size: 16px;
	font-weight: bold;
	color: #444444;
}

input[type="text"], select {
	padding: 12px;
	border: 1px solid #cccccc;
	border-radius: 8px;
	font-size: 15px;
}

button {
	background-color: #007bff;
	color: white;
	padding: 12px;
	border: none;
	border-radius: 8px;
	font-size: 16px;
	cursor: pointer;
	transition: background-color 0.3s, transform 0.2s;
}

button:hover {
	background-color: #0056b3;
	transform: translateY(-2px);
}

button:active {
	transform: translateY(1px);
}
</style>
</head>
<body>

	<jsp:include page="header.jsp" />
	<jsp:include page="sidebar.jsp" />


	<div class="content">
		<div class="form-container">
			<h2>📝 질병 및 식사시간 입력</h2>
			<form method="post" action="/recommend-diet">

				<label for="disease">🦠 질병명:</label> <input type="text" id="disease"
					name="disease" required placeholder="예: 고혈압"> <label
					for="mealTime">⏰ 식사시간:</label> <select id="mealTime"
					name="mealTime" required>
					<option value="">-- 선택 --</option>
					<option value="아침">🌅 아침</option>
					<option value="점심">🌞 점심</option>
					<option value="저녁">🌙 저녁</option>
				</select>

				<button type="submit">🍽 식단 추천 받기</button>
			</form>

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

</body>
</html>
