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
	
	<!-- 게시물 전체 목록 -->
	<div class="container">
		<div class="d-flex">
			<div style="width:50%;">
			   <h2>게시판</h2>
			</div>
			<div class="ml-auto input-group" style="width:50%;">
				<select name="_searchType" id="_searchType" class="custom-select" style="width:auto;">
					<option value="">조회 항목</option>
					<option value="1">작성자</option>
					<option value="2">제목</option>
					<option value="3">내용</option>
				</select>
				<input type="text" name="_searchValue" id="_searchValue" value="${searchValue}" class="form-control mx-1" maxlength="20" style="width:auto;ime-mode:active;" placeholder="조회값을 입력하세요." />
				<button type="button" id="btnSearch" class="btn btn-secondary mb-3 mx-1" onclick="searchBtnClick()">조회</button>
			</div>
	 	</div>	
	
		<table class="table table-hover">
			<thead>
				<tr>
					<th scope="col" class="text-center">번호</th>
					<th scope="col" class="text-center">제목</th>
					<th scope="col" class="text-center">작성자</th>
					<th scope="col" class="text-center">날짜</th>
					<th scope="col" class="text-center">조회수</th>
				</tr>
			</thead>
			<tbody>
		<c:if test="${!empty list}">
			<c:forEach var="board" items="${list}" varStatus="status">
				<tr>
				<c:choose>
					<c:when test="${board.bbsIndent eq 0}">
					<td scope="row" class="text-center">${board.bbsSeq }</td>
					</c:when>
					<c:otherwise>
					<td scope="row" class="text-center"></td>
					</c:otherwise>
				</c:choose>
					<td scope="row" class="text-center">
						<a href="javascript:void(0)" onclick="detailView('${board.bbsSeq}')">
							<c:if test="${board.bbsIndent > 0}">
							<img src="/resources/images/icon_reply.gif" style="margin-left:${board.bbsIndent}em;"/>
							</c:if>
							${board.bbsTitle}
						</a>
					</td>
					<td scope="row" class="text-center">${board.userName}</td>
					<td scope="row" class="text-center">${board.regDate}</td>
					<td scope="row" class="text-center"><fmt:formatNumber type="number"  maxFractionDigits="3" value="${board.bbsReadCnt}" /></td>
				</tr>
			</c:forEach>
		</c:if>
			</tbody>
		</table>
		
		
		<nav>
			<ul class="pagination justify-content-center">
			<c:if test="${!empty paging}">
				<c:if test="${paging.prevBlockPage gt 0}">
					<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_page(${paging.prevBlockPage})">이전블럭</a></li>
				</c:if>
		
				<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
				<c:choose>
				<c:when test="${i ne curPage}">
					<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_page(${i})">${i}</a></li>
				</c:when>
				<c:otherwise>
					<li class="page-item"><a class="page-link" href="javascript:void(0)" style="cursor:default;">${i}</a></li>
				</c:otherwise>
				</c:choose>
				</c:forEach>
		
				<c:if test="${paging.nextBlockPage gt 0}">
				<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_page(${paging.nextBlockPage})">다음블럭</a></li>
				</c:if>
			</c:if>		
			</ul>
		</nav>
		
		<input type="hidden" id="curPage" name="curPage" value="${curPage}" />
		<button type="button" id="btnWrite" class="btn btn-secondary mb-3" onclick="writeForm()">글쓰기</button>
	</div>
	
	<form name="bbsForm" id="bbsForm" method="get">
		<input type="hidden" name="searchType" id="searchType" value="${searchType}"/>
		<input type="hidden" name="searchValue" id="searchValue" value="${searchValue}"/>
		<input type="hidden" name="curPage" id="curPage" value="${curPage}"/>
	</form>
		
	
	<!-- 자바스크립트 -->
	<script type="text/javascript" src="/resources/js/jquery-3.5.1.min.js"></script>
	<script type="text/javascript" src="/resources/js/icia.common.js"></script>
	<script type="text/javascript" src="/resources/js/icia.ajax.js"></script>
	
	<script type="text/javascript">
		// 게시물 쓰기 페이지 이동
		const writeForm = () => {
			location.href = "/board/write";
		}
		
		// 특정 게시물 조회(작성자, 제목, 내용)
		const searchBtnClick = () => {
			document.bbsForm.searchType.value = $("#_searchType").val();
			document.bbsForm.searchValue.value = $("#_searchValue").val();
			document.bbsForm.action = "/board/list";
			document.bbsForm.submit();
		}
		
		// 해당 게시물의 상세 페이지로 이동
		const detailView = (bbsSeq) => {
			const searchType = $("#_searchType").val();
			const searchValue = $("#_searchValue").val();
			const curPage = $("#curPage").val();
			location.href = "/board/view?bbsSeq=" + bbsSeq + "&searchType=" + searchType + "&searchValue=" + searchValue + "&curPage=" + curPage;
		}

	</script>
</body>
</html>