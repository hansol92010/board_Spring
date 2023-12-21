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
		<form name="replyForm" id="replyForm" method="post" enctype="multipart/form-data">
			<input type="text" name="userName" id="userName" maxlength="20" value="${user.userName}" style="ime-mode:active;" class="form-control mt-4 mb-2" placeholder="이름을 입력해주세요." readonly />
			<input type="text" name="userEmail" id="userEmail" maxlength="30" value="${user.userEmail}" style="ime-mode:inactive;" class="form-control mb-2" placeholder="이메일을 입력해주세요." readonly />
			<input type="text" name="bbsTitle" id="bbsTitle" maxlength="100" style="ime-mode:active;" class="form-control mb-2" placeholder="제목을 입력해주세요." required />
			<div class="form-group">
				<textarea class="form-control" rows="10" name="bbsContent" id="bbsContent" style="ime-mode:active;" placeholder="내용을 입력해주세요" required></textarea>
			</div>
			<input type="file" id="bbsFile" name="bbsFile" class="form-control mb-2" placeholder="파일을 선택하세요." required />
			<input type="hidden" name="bbsSeq" value="${board.bbsSeq }" />
			<input type="hidden" name="searchType" value="${searchType }" />
			<input type="hidden" name="searchValue" value="${searchValue }" />
			<input type="hidden" name="curPage" value="${curPage }" />
			<div class="form-group row">
				<div class="col-sm-12">
					<button type="button" id="btnReply"  class="btn btn-primary" title="저장" onclick="replyBtnClick()">답변</button>
					<button type="button" id="btnList"  class="btn btn-secondary" title="리스트" onclick="listBtnClick()">리스트</button>
				</div>
			</div>
		</form>
	</div>

	<form name="replyForm" method="get">

	</form>
	
	<!-- 자바스크립트 -->
	<script type="text/javascript" src="/resources/js/jquery-3.5.1.min.js"></script>
	<script type="text/javascript" src="/resources/js/icia.common.js"></script>
	<script type="text/javascript" src="/resources/js/icia.ajax.js"></script>
	
	<script type="text/javascript">
		$(document).ready(function() {
			<c:if test="${empty board}">
				alert("답변할 게시물이 존재하지 않습니다");
				locatio.href = "/board/list";
			</c:if>
			$("#bbsTitle").focus();
		});
		
		const listBtnClick = () => {
			window.history.back();
		}
		
		/* 답변 쓰기 */
		const replyBtnClick = () => {
			
			$("#btnReply").prop("disabled", true);
			
			if($.trim($("#bbsTitle").val()).length <= 0) {
				alert("제목을 입력하세요");
				$("#bbsTitle").val("");
				$("#bbsTitle").focus();
				$("#btnReply").prop("disabled", false);
				return;
			}
			
			if($.trim($("#bbsContent").val()).length <= 0) {
				alert("내용을 입력하세요");
				$("#bbsContent").val("");
				$("#bbsContent").focus();
				$("#btnReply").prop("disabled", false);
				return;
			}
			
			const form = $("#replyForm")[0];
			const formData = new FormData(form);
			
			$.ajax({
				type : "POST",
				url : "/board/replyProc",
				enctype : "multipart/form-data",
				data : formData,
				processData : false,
				contentType : false,
				cache : false,
				beforeSend : function(xhr) {
					xhr.setRequestHeader("AJAX", "ture");
				},
				success : function(response) {
					if(response.code == 0) {
						alert("답변이 등록되었습니다");
						location.href = "/board/list";
					} else if(response.code == 400) {
						alert("입력 정보가 올바르지 않습니다. 다시 시도해주세요");
						$("#btnReply").prop("disabled", false);
					} else if(response.code == 404) {
						alert("답변할 게시물이 존재하지 않습니다");
						location.href = "/board/list";
					} else {
						alert("게시물 답변 중 오류가 발생하였습니다. 다시 시도해주세요");
						$("#btnReply").prop("disabled", false);
					}
				},
				error : function(error) {
					icia.common.error(error);
					alert("게시물 답변 중 오류가 발생하였습니다.");
					$("#btnReply").prop("disabled", false);
				}
			})
		}
	</script>
</body>
</html>