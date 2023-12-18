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
</head>
<body>
	<!-- nav -->
	<%@ include file="/WEB-INF/views/include/nav.jsp" %>
	
	<div class="container" style="width:400px">
		<div class="row mt-5">
			<h3>회원가입</h1>
		</div>
		<div class="row mt-2">
			<div class="col-12">
				<form id="regForm" name="regForm">
					<div class="form-group">
						<label for="userId">아이디</label>
						<input type="text" id="userId" name="userId" class="form-control" placeholder="아이디" maxlength="12" />
					</div>
					<div class="form-group">
						<label for="userPwd1">비밀번호</label>
						<input type="password" id="userPwd1" name="userPwd1" class="form-control" placeholder="비밀번호"  maxlength="12" />
					</div>
					<div class="form-group">
						<label for="userPwd2">비밀번호 확인</label>
						<input type="password" id="userPwd2" name="userPwd2" class="form-control" placeholder="비밀번호 확인" maxlength="12" />
					</div>
					<div class="form-group">
						<label for="userName">이름</label>
						<input type="text" id="userName" name="userName" class="form-control" placeholder="이름" maxlength="15" />
					</div>
					<div class="form-group">
						<label for="userEmail">이메일</label>
						<input type="text" id="userEmail" name="userEmail" class="form-control" placeholder="이메일" maxlength="30" />
					</div>
					<input type="hidden" id="userPwd" name="userPwd" value="" />
					<button type="button" id="regBtn" class="btn btn-primary btn-block" onclick="regBtnClick()" >회원가입</button>
				</form>
			</div>
		</div>
	</div>
	
	<!-- 자바스크립트 -->
	<script type="text/javascript" src="/resources/js/jquery-3.5.1.min.js"></script>
	<script type="text/javascript" src="/resources/js/icia.common.js"></script>
	<script type="text/javascript" src="/resources/js/icia.ajax.js"></script>
	
	<script type="text/javascript">
		$(document).ready(function() {
			$("#userId").focus();
		});
		
		// 회원가입 버튼 => 입력값 체크 + 아이디 중복 체크
		const regBtnClick = () => {
			// 공백 체크 정규표현식
			const emptCheck = /\s/g;
			
			// 아이디&비밀번호 - 영문 대소문자와 숫자로 이루어진 4~12자리 정규표현식
			const idPwdCheck = /^[a-zA-Z0-9]{4,12}$/;
			
			// 이메일 - 영문 소문자와 숫자, 특수기호_,-만 사용 가능하고, 뒤에는 이메일 형식이어야 하는 정규표현식 
			const emailCheck = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			// /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/

			// ######## 아이디 체크 ########
			if($.trim($("#userId").val()).length <= 0) {
				alert("아이디를 입력하세요");
				$("#userId").val("");
				$("#userId").focus();
				return;
			}
			
			if(emptCheck.test($("#userId").val())) {
				alert("아이디에 공백을 포함할 수 없습니다");
				$("#userId").val("");
				$("#userId").focus();
				return;
			}
			
			if(!idPwdCheck.test($("#userId").val())) {
				alert("아이디는 4~12자리의 영문 대소문자와 숫자로만 입력하세요");
				$("#userId").val("");
				$("#userId").focus();
				return;
			}
			
			// ######## 비밀번호 체크 ########
			if($.trim($("#userPwd1").val()).length <= 0) {
				alert("비밀번호를 입력하세요");
				$("#userPwd1").val("");
				$("#userPwd1").focus();
				return;
			}
			
			if(emptCheck.test($("#userPwd1").val())) {
				alert("비밀번호에 공백을 포함할 수 없습니다");
				$("#userPwd1").val("");
				$("#userPwd1").focus();
				return;
			}
			
			if(!idPwdCheck.test($("#userPwd1").val())) {
				alert("비밀번호는 4~12자리의 영문 대소문자와 숫자로만 입력하세요");
				$("#userPwd1").val("");
				$("#userPwd1").focus();
				return;
			}
			
			// ######## 비밀번호 확인 체크 ########
			if($("#userPwd2").val() != $("#userPwd1").val()) {
				alert("비밀번호가 일치하지 않습니다");
				$("#userPwd2").val("");
				$("#userPwd2").focus();
				return;
			}
			
			// ######## 이름 체크 ########
			if($.trim($("#userName").val()).length <= 0) {
				alert("이름을 입력하세요");
				$("#userName").val("");
				$("#userName").focus();
				return;
			}
			
			if(emptCheck.test($("#userName").val())) {
				alert("이름에 공백을 포함할 수 없습니다");
				$("#userName").val("");
				$("#userName").focus();
				return;
			}
			
			// ######## 이메일 체크 ########
			if($.trim($("#userName").val()).length <= 0) {
				alert("이름을 입력하세요");
				$("#userName").val("");
				$("#userName").focus();
				return;
			}
			
			if(emptCheck.test($("#userName").val())) {
				alert("이름에 공백을 포함할 수 없습니다");
				$("#userName").val("");
				$("#userName").focus();
				return;
			}
			
			if(!emailCheck.test($("#userEmail").val())) {
				alert("이메일을 형식에 맞게 작성하세요.");
				$("#userEmail").val("");
				$("#userEmail").focus();
				return;
			}
			
			// hidden에 비밀번호 넘기기
			$("#userPwd").val($("#userPwd1").val());
			
			// 중복 아이디 체크
			$.ajax({
				method: "POST",
				url: "/user/idCheck",
				data : {
					userId : $("#userId").val()
				},
				beforeSend: function(xhr) {
					xhr.setRequestHeader("AJAX", "true");
				},
				success: function(response) {
					if(response.code == 0) {
						userReg();
					} else if(response.code == 100) {
						alert("중복된 아이디입니다");
						$("#userId").focus();
					} else if(response.code == 400) {
						alert("입력된 아이디가 올바르지 않습니다");
						$("#userId").focus();
					} else {
						alert("아이디 중복 체크 중 오류가 발생하였습니다");
						$("#userId").focus();
					}
				},
				error: function(error) {
					icia.common.error(error);
				}
			});	
		}
		
		const userReg = () => {
			$.ajax({
				method: "POST",
				url: "/user/regProc",
				data: {
					userId : $("#userId").val(),
					userPwd : $("#userPwd").val(),
					userName : $("#userName").val(),
					userEmail : $("#userEmail").val(),
				},
				datatype: "JSON",
				success: function(response) {
					if(response.code == 0) {
						alert("회원가입에 성공하였습니다");
					} else if(response.code == 100) {
						alert("아이디가 중복되었습니다.");
						$("#usreId").focus();
					} else if(response.code == 400) {
						alert("입력된 정보가 잘못되었습니다. 다시 입력해주세요");
						$("#userId").focus();
					} else {
						alert("회원 가입 중 오류가 발생하였습니다. 회원가입을 다시 시도해주세요");
						location.reload();
					}
				},
				error: function(error) {
					icia.common.error(error);
				}
			});
		}
	</script>
</body>
</html>