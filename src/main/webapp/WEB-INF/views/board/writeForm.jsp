<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<title><spring:eval expression="@env['site.title']" /></title>
	
	<!-- CSS -->
	<link rel="shortcut icon" href="/resources/images/favicon.ico" type="image/x-icon">
	<link rel="stylesheet" href="/resources/css/bootstrap.min.css" type="text/css">

</head>
<body>
	<!-- nav -->
	<%@ include file="/WEB-INF/views/include/nav.jsp" %>
	
	<!-- 게시물 입력 폼 -->
	<div class="container">
		<h2>게시물 쓰기</h2>
		<form name="writeForm" id="writeForm" method="post" enctype="multipart/form-data">
			<input type="text" name="userName" id="userName" maxlength="20" value="${user.userName}" style="ime-mode:active;" class="form-control mt-4 mb-2" placeholder="이름을 입력해주세요." readonly />
			<input type="text" name="userEmail" id="userEmail" maxlength="30" value="${user.userEmail}" style="ime-mode:inactive;" class="form-control mb-2" placeholder="이메일을 입력해주세요." readonly />
			<input type="text" name="bbsTitle" id="bbsTitle" maxlength="100" style="ime-mode:active;" class="form-control mb-2" placeholder="제목을 입력해주세요." required />
			<div class="form-group">
				<textarea class="form-control" rows="10" name="bbsContent" id="bbsContent" style="ime-mode:active;" placeholder="내용을 입력해주세요" required></textarea>
			</div>
			<input type="file" id="bbsFile" name="bbsFile" class="form-control mb-2" placeholder="파일을 선택하세요." required />
			<div class="form-group row">
				<div class="col-sm-12">
					<button type="button" id="btnWrite"  class="btn btn-primary" title="저장" onclick="writeBtnClick()">저장</button>
					<button type="button" id="btnList"  class="btn btn-secondary" title="리스트" onclick="list()">리스트</button>
				</div>
			</div>
		</form>
	</div>
	
	<form name="bbsForm" id="bbsForm" method="post">
		<input type="hidden" name="searchType" value="" />
		<input type="hidden" name="searchValue" value="" />
		<input type="hidden" name="curPage" value="" />
	</form>
	
	
	<!-- 자바스크립트 -->
	<script type="text/javascript" src="/resources/js/jquery-3.5.1.min.js"></script>
	<script type="text/javascript" src="/resources/js/icia.common.js"></script>
	<script type="text/javascript" src="/resources/js/icia.ajax.js"></script>
	
	<script type="text/javascript">
		$(document).ready(function() {
			$("#bbsTitle").focus();
		});
		
	
		const writeBtnClick = () => {
			$("#btnWrite").prop("disabled", true);
			
			if($.trim($("#bbsTitle").val()).length <= 0) {
				alert("제목을 입력하세요");
				$("#bbsTitle").val("");
				$("#bbsTitle").focus();
				$("#btnWrite").prop("disabled", false);
				return;
			}
			
			if($.trim($("#bbsContent").val()).length <= 0) {
				alert("내용을 입력하세요");
				$("#bbsContent").val("");
				$("#bbsContent").focus();
				$("#btnWrite").prop("disabled", false);
				return;
			}
			
			const bbsTitle = $("#bbsTitle").val();
			const bbsContent = $("#bbsContent").val();
			
			const form = $("#writeForm")[0];
			const formData = new FormData(form);

			$.ajax({
				type: "POST",
				enctype: "multipart/form-data",
				url: "/board/writeProc",
				data: formData,
				processData: false,		// formData를 string으로 변환하지 않음
				contentType: false,		// 헤더 -> content-type을 multipart/form-data로 전송
				cache: false,
				beforeSend: function(xhr) {
					xhr.setRequestHeader("AJAX", "true");
				},
				success: function(response) {
					if(response.code == 0) {
						alert("게시물이 등록되었습니다");
					} else if(response.code == 400) {
						alert("입력 정보가 잘못되었습니다. 다시 입력해주세요");
						location.reload();
					} else if(response.code == 500) {
						alert("게시물 둥록 중 오류가 발생하였습니다. 다시 시도해주세요");
						location.reload();
					} else {
						alert("게시물 등록 중 알 수 없는 오류가 발생하였습니다");
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