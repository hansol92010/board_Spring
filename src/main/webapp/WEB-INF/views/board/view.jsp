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
	
	<div class="container">
		<h2>게시물 보기</h2>
		<div class="row">
			<table class="table">
				<thead>
					<tr class="table-active">
						<th scope="col" colspan="3" style="font-size: 25px">
							${board.bbsTitle}
						</th>
					</tr>
					<tr class="table-active">
						<th>
							${board.userName}&nbsp;&nbsp;&nbsp;
							<a href="mailto:${board.userEmail}" style="color:#828282;">${board.userEmail}</a>
							<c:if test="${!empty board.boardFile}">
							&nbsp;&nbsp;&nbsp;<a href="#"  style="color:#000;">[첨부파일]</a>
							</c:if>
						</th>
						<th scope="col">
							${board.regDate}
						</th>
						<th>
							조회 : <fmt:formatNumber type="number" maxFractionDigits="3" value="${board.bbsReadCnt}" />
						</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td colspan="3"><pre>${board.bbsContent}</pre></td>
					</tr>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="3">
							<button type="button" id="btnList" class="btn btn-secondary" onclick="listBtnClick()">리스트</button>
							<button type="button" id="btnReply" class="btn btn-secondary" onclick="replyBtnClick()">답변</button>
							
							<c:if test="${boardMe eq 'Y'}">
							<button type="button" id="btnUpdate" class="btn btn-secondary" onclick="updateBtnClick()">수정</button>
							<button type="button" id="btnDelete" class="btn btn-secondary" onclick="deleteBtnClick('${board.bbsSeq}')">삭제</button>
							</c:if>	
						</td>
					</tr>
				</tfoot>
			</table>
		</div>
		
	</div>
	
	<form name="viewForm" method="get">
		<input type="hidden" name="bbsSeq" id="bbsSeq" value="${board.bbsSeq }" />
		<input type="hidden" name="searchType" id="searchType" value="${searchType}"/>	
		<input type="hidden" name="searchValue" id="searchValue" value="${searchValue}"/>	
		<input type="hidden" name="curPage" id="curPage" value="${curPage}"/>	
	</form>
		
	
	<!-- 자바스크립트 -->
	<script type="text/javascript" src="/resources/js/jquery-3.5.1.min.js"></script>
	<script type="text/javascript" src="/resources/js/icia.common.js"></script>
	<script type="text/javascript" src="/resources/js/icia.ajax.js"></script>
	
	<script type="text/javascript">
		const listBtnClick = () => {
			window.history.back();
		}
		
		const replyBtnClick = () => {
			document.viewForm.bbsSeq.value = $("#bbsSeq").val();
			document.viewForm.searchType.value = $("#searchType").val();
			document.viewForm.searchValue.value = $("#searchValue").val();
			document.viewForm.curPage.value = $("#curPage").val();
			document.viewForm.action = "/board/reply";
			document.viewForm.submit();
		}
		
		const updateBtnClick = () => {
			
		}
		
		const deleteBtnClick = (bbsSeq) => {
			$("#btnDelete").prop("disabled", true);
			
			$.ajax({
				type : "GET",
				url : "/board/deleteProc",
				data : {
					bbsSeq : bbsSeq
				},
				beforeSend : function(xhr) {
					xhr.setRequestHeader("AJAX", "true");
				},
				success : function(response) {
					if(response.code == 0) {
						alert("게시물이 삭제되었습니다");
						location.href = "/board/list";
					} else if(response.code == 400) {
						alert("요청이 올바르지 않습니다. 다시 시도해주세요");
						$("#btnDelete").prop("disabled", false);
					} else if(response.code == 404) {
						alert("등록된 게시물이 존재하지 않습니다");
						location.href = "/board/list";
					} else if(response.code == -999) {
						alert("해당 게시물에는 답변 글이 존재하여 삭제할 수 없습니다");
						$("#btnDelete").prop("disabled", false);
					} else {
						alert("게시물 삭제 중 오류가 발생하였습니다.다시 시도해주세요");
						location.reload();
					}
				},
				error : function(error) {
					icia.common.error(error);
				}
			})
		}
	</script>
</body>
</html>