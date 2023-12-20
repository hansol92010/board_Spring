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
						<th scope="col">
							${board.bbsTitle}<br/>
							${board.userName}&nbsp;&nbsp;&nbsp;
							<a href="mailto:${board.userEmail}">${board.userEmail}</a>
						</th>
						<th scope="col">
							조회 : ${board.bbsReadCnt}<br />
							${board.regDate}
						</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td colspan="2">${board.bbsContent}</td>
					</tr>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="2"></td>
					</tr>
				</tfoot>
			</table>
		</div>
		
		<button type="button" id="btnList" class="btn btn-secondary">리스트</button>
		<button type="button" id="btnReply" class="btn btn-secondary">답변</button>
	
		<button type="button" id="btnUpdate" class="btn btn-secondary">수정</button>
		<button type="button" id="btnDelete" class="btn btn-secondary">삭제</button>
	</div>
		
	
	<!-- 자바스크립트 -->
	<script type="text/javascript" src="/resources/js/jquery-3.5.1.min.js"></script>
	<script type="text/javascript" src="/resources/js/icia.common.js"></script>
	<script type="text/javascript" src="/resources/js/icia.ajax.js"></script>
	
	<script type="text/javascript">
		
	</script>
</body>
</html>