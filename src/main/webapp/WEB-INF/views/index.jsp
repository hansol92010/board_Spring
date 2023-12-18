<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<title><spring:eval expression="@env['site.title']" /></title>
	
	<link rel="shortcut icon" href="/resources/images/favicon.ico" type="image/x-icon">
	<link rel="stylesheet" href="/resources/css/bootstrap.min.css" type="text/css">

	<style>
		body {
			padding-bottom: 40px;
		}
		
		.form-signin {
			max-width: 330px;
			padding: 15px;
			margin: 0 auto;
		}
		.form-signin .form-signin-heading, .form-signin .checkbox {
			margin-bottom: 10px;
		}
		.form-signin .checkbox {
			font-weight: 400;
		}
		.form-signin .form-control {
			position: relative;
			-webkit-box-sizing: border-box;
			-moz-box-sizing: border-box;
			box-sizing: border-box;
			height: auto;
			padding: 10px;
			font-size: 16px;
		}
		.form-signin .form-control:focus {
			z-index: 2;
		}
		.form-signin input[type="text"] {
			margin-bottom: 5px;
			border-bottom-right-radius: 0;
			border-bottom-left-radius: 0;
		}
		.form-signin input[type="password"] {
			margin-bottom: 10px;
			border-top-left-radius: 0;
			border-top-right-radius: 0;
		}
	</style>
	
</head>
<body>
	<!-- nav -->
	<%@ include file="/WEB-INF/views/include/nav.jsp" %>
	
	<!--  로그인 화면 -->
	<div class="container">
		<form class="form-signin">
			<h2 class="form-signin-heading m-b3">로그인</h2>
			<label for="userId" class="sr-only">아이디</label>
			<input type="text" id="userId" name="userId" class="form-control" maxlength="20" placeholder="아이디를 입력하세요"/>
			<label for="userPwd" class="sr-only">비밀번호</label>
			<input type="password" id="userPwd" name="userPwd" class="form-control" maxlength="20" placeholder="비밀번호를 입력하세요"/>
			<button type="button" id="loginBtn" class="btn btn-lg btn-primary btn-block">로그인</button>
			<button type="button" id="regBtn" class="btn btn-lg btn-primary btn-block">회원가입</button>
		</form>
	</div>
	
	<!-- 자바스크립트 -->
	<script type="text/javascript" src="/resources/js/jquery-3.5.1.min.js"></script>
	<script type="text/javascript" src="/resources/js/icia.common.js"></script>
	<script type="text/javascript" src="/resources/js/icia.ajax.js"></script>
	
	<script type="text/javascript">
		// 회원가입
		$("#regBtn").click(() => {
			location.href = "/user/regForm";
		})
		
		// 로그인
		$("#loginBtn").click(() => {
			
			if($.trim($("#userId").val()) <= 0) {
				alert("아이디를 입력해주세요");
				$("#userId").val("");
				$("#userId").focus();
				return;
			}
			
			if($.trim($("#userPwd").val()) <= 0) {
				alert("비밀번호를 입력해주세요");
				$("#userPwd").val("");
				$("#userPwd").focus();
				return;
			}
			
			$.ajax({
				method: "POST",
				url: "/user/loginProc",
				data: {
					userId : $("#userId").val(),
					userPwd : $("#userPwd").val()
				},
				beforeSend: function(xhr) {
					xhr.setRequestHeader("AJAX", "true");
				},
				success: function(response) {
					if(response.code == 0 ) {
						location.href = "/"
					} else if(response.code == -1) {
						alert("비밀번호를 잘못 입력했습니다. 다시 입력해주세요");
						$("#userPwd").val("");
						$("#userPwd").focus();
					} else if(response.code == 404) {
						alert("아이디가 존재하지 않습니다");
						location.reload();
					} else if(response.code == 400){
						alert("아이디와 비밀번호를 모두 입력해주세요");
						$("#usreId").focus();
					} else {
						alert("로그인 중 오류가 발생하였습니다. 다시 로그인을 시도해주세요");
						location.reload();
					}
				},
				error: function(error) {
					icia.common.error(error);
				}
			})
		})
	</script>
</body>
</html>