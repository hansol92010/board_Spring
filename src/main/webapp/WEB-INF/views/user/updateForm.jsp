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
						<input type="text" id="userId" name="userId" class="form-control" placeholder="아이디" maxlength="12" value="${user.userId}" disabled="true" />
					</div>
					<div class="form-group">
						<label for="userPwd1">비밀번호</label>
						<input type="password" id="userPwd1" name="userPwd1" class="form-control" placeholder="비밀번호"  maxlength="12" value="${user.userPwd}" />
					</div>
					<div class="form-group">
						<label for="userPwd2">비밀번호 확인</label>
						<input type="password" id="userPwd2" name="userPwd2" class="form-control" placeholder="비밀번호 확인" maxlength="12" value="${user.userPwd}"/>
					</div>
					<div class="form-group">
						<label for="userName">이름</label>
						<input type="text" id="userName" name="userName" class="form-control" placeholder="이름" maxlength="15" value="${user.userName}"/>
					</div>
					<div class="form-group">
						<label for="userEmail">이메일</label>
						<input type="text" id="userEmail" name="userEmail" class="form-control" placeholder="이메일" maxlength="30" value="${user.userEmail}" />
					</div>
					<input type="hidden" id="userPwd" name="userPwd" value="" />
					<button type="button" id="regBtn" class="btn btn-primary btn-block" onclick="updateBtnClick()">수정</button>
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
			$("#userPwd1").focus();
		})
		
		const updateBtnClick = () => {
			// 공백 체크 정규표현식
			const emptCheck = /\s/g;
			
			// 비밀번호 - 영문 대소문자와 숫자로 이루어진 4~12자리 정규표현식
			const idPwdCheck = /^[a-zA-Z0-9]{4,12}$/;
			
			// 이메일 - 영문 소문자와 숫자, 특수기호_,-만 사용 가능하고, 뒤에는 이메일 형식이어야 하는 정규표현식 
			const emailCheck = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			// /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/
			
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
			
			// ajax(비동기 통신)
			$.ajax({
				method: "POST",
				url: "/user/updateProc",
				data: {
					userId : $("#userId").val(),
					userPwd : $("#userPwd").val(),
					userName : $("#userName").val(),
					userEmail : $("#userEmail").val(),
				},
				datatype: "JSON",
				beforeSend: function(xhr) {
					xhr.setRequestHeader("AJAX", "true");
				},
				success: function(response) {
					if(response.code == 0) {
						alert("회원 정보가 수정되었습니다.");
						location.href = "/board/list"
					} else if(response.code == -1) {
						alert("회원을 찾을 수 없습니다. 다시 로그인 해주세요");
						location.href = "/"
					} else if(response.code == 401) {
						alert("입력된 정보가 잘못되었습니다. 다시 입력해주세요");
						location.reload();
					} else if(response.code == 402) {
						alert("이용 정지 회원입니다. 고객센터에 문의해주세요");
						location.reload();
					} else if(response.code == 404) {
						alert("회원 정보를 찾을 수 없습니다");
						location.href = "/"
					} else if(response.code == 500) {
						alert("회원 정보 수정 중 오류가 발생하였습니다.");
						location.reload();
					} else {
						alert("회원 정보 수정 중 오류가 발생하였습니다.");
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