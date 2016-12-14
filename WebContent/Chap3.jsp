<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
//innerHTML 속성을 사용한 화면 변경
//1.웹 서버 응답 결과를 innerHTML을 사용하여 반영
//1-1.웹 서버의 응답 텍스트의 값이 HTML 코드이고, 그 응답 텍스트를 innerHTML을 사용하여 그대로 화면에 반영
//1-2.웹 서버의 응답 텍스트가 임의의 포맷에 맞춰져 있고, 자바스크립트는 그 응답 텍스트를 분석해서 HTML 코드를 생성한 뒤 innerHTML을 사용해서 화면에 반영
// 
 --%>
<%--예제 1 --%>
<!-- <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
	<meta http-equiv="content-type" content="text/html; charset=euc-kr" />
	<title>뉴스</title>
	<script type="text/javascript" src="httpRequest.js"></script>
	<script type="text/javascript">
	function loadNews() {
		sendRequest("getNewsTitles.jsp", null, loadedNews, "GET");
	}
	function loadedNews() {
		if (httpRequest.readyState == 4) {
			if (httpRequest.status == 200) {
				var newsList = document.getElementById("newsList");
				newsList.innerHTML = httpRequest.responseText;
			}
		}
	}
	window.onload = function() {
		loadNews();
	}
	</script>
</head>
<body>
<div id="newsList"></div>
</body>
</html> -->
<%-- <%@ page contentType = "text/plain; charset=euc-kr" %>
<%
	String[] titles = {
		"서재응 완벽투구… 게레로 3구 삼진",
		"리틀 감독 '서재응 12일부터 고정 선발'",
		"박찬호 김선우 시범경기 등판 호투"
	};
	for (int i = 0 ; i < titles.length ; i++) {
%>
<% if (i == 0) { %><strong><% } %>
<%= titles[i] %>
<% if (i == 0) { %></strong><% } %>
<br/>
<%
	}
%> --%>