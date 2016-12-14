<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script>
//getXMLHttpRequest() 함수로 생성한 객체를 저장하기 위해 선언한 전역 변수
var httpRequest = null;

//1. XMLHttpRequest 객체 구하기
function getXMLHttpRequest(){
	if (window.ActiveXObject) {
		//IE에서 XMLHttpRequest 객체 구하기
		try {
			return new ActiveXObject("Msxml2.XMLHTTP");
		} catch(e) {
			try {
				return new ActiveXObject("Microsoft.XMLHTTP");
			} catch(e1) { return null; }
		}
	} else if (window.XMLHttpRequest) {
		//IE 이외의 브라우저에서 XMLHttpRequest 객체 구하기
		return new XMLHttpRequest();
	} else {
		return null;
	}
}

//2. 웹 서버에 요청 전송
function processEvent(){
	httpRequest = getXMLHttpRequest();
	
	//onreadystatechange : 웹 서버로부터 응답이 도착하면 특정한 자바스크립트 함수를 호출하는 기능이 있음
	//콜백 함수 : onreadystatechange 프로퍼티에 지정한 함수
	httpRequest.onreadystatechange = callbackFunction;
	
	//open() 함수 : 요청의 초기화. GET/POST 선택, 접속할 URL 입력
	//	첫 번째 인자 : HTTP 메서드(GET/POST)
	//	두 번째 인자 : 접속할 URL, 웹 브라우저의 보안상 이유로 접속할 URL은 현재 페이지와 같은 도메인에 있어야 함
	//	세 번째 인자 : 동기/비동기 방식을 지정, true(비동기 방식으로 호출)
	//send() 함수 : 웹 서버에 요청 전송 
	
	//get 방식 전달 : 파라미터를 전송할 때에는 URL 뒤에 파라미터를 붙임, 전송할 파라미터가 없다면 URL만 입력 
	httpRequest.open("GET", "./test.jsp?id=madvirus&pw=1234", true);
	httpRequest.send(null);
	//동기 방식과 비동기 방식 : 비동기 방식(send()함수가 호출된 뒤 곧바로 다음의 코드가 실행), 동기 방식(서버와의 통신이 완전히 완료된 이후에 send() 함수 이후의 코드가 실행)
	//파라미터의 한글 처리 방법 : XMLHttpRequest 객체가 웹 서버에 전송하는 요청 파라메터의 경우에는 반드시 UTF-8로 인코딩해서 전송, 그렇지 않을 경우 잘못된 파라미터 값이 전송
	/* var params = "name=" + encodeURIComponent("최범균");
	httpRequest.open("GET", "./test.jsp?"+params, true); */

	//서블릿/JSP의 경우는 HttpServletRequest.setCharacterEncoding()메서드를 사용해서 읽어올 파라미터의 캐릭터셋을 명시
	<%-- <% 
		request.setCharacterEncoding("UTF-8");
		String name = request.getParameter("name");
	%> --%>

	
	//post 방식 전달
/* 	httpRequest.open("POST", "./test.jsp", true);
	httpRequest.send("id=madvirus&pw=1234"); */
}

//3. 서버 응답 처리
function callbackFunction(){
	//readyState : XMLHttpRequest의 상태를 표시할 때 사용
	//0/UNINITIALIZED/객체만 생성되고 아직 초기화되지 않은 상태(open 메서드가 호출되지 않음) 
	//1/LOADING/open 메서드가 호출되고 아직 send 메서드가 불리지 않은 상태
	//2/LOADED/send 메서드가 불렸지만 status와 헤더는 도착하지 않은 상태
	//3/INTERACTIVE/데이터의 일부를 받은 상태
	//4/COMPLETED/데이터를 전부 받은 상태. 완전한 데이터의 이용 가능
	
	//readyState의 값이 변경될 때마다 콜백 함수가 호출되므로 readyState의 값을 비교하여 각 값에 따라 알맞은 처리를 수행 
	if(httpRequest.readyState==1 || httpRequest.readyState==2 || httpRequest.readyState==3){
		//화면에 서버에서 작업 중이라는 메시지 출력
		alert("processing" + httpRequest.readyState);
	}else if (httpRequest.readyState==4){
		//서버로부터 완전하게 응답이 도착한 경우 응답 결과에 따라 알맞은 작업 처리
		
		//status : 웹 서버가 전달한 상태 코드가 저장되는 프로퍼티, statusText : status 프로퍼티의 값을 설명하는 텍스트 문장을 저장
		//202/OK/요청 성공
		//403/Forbidden/접근 거부
		//404/Not Found/페이지 없음
		//500/Internal Server Error/서버 오류 발생
		if(httpRequest.status==200){
			//정상적으로 수행
			alert("completed" + httpRequest.status + httpRequest.statusText);
			
			//responseText : 웹서버가 생성한 단순 응답 텍스트를 참조할 때 사용하는 프로퍼티
			var txt = httpRequest.responseText;
			//txt를 사용해서 알맞은 작업 수행
			alert(txt);
		}else{
			alert("error : " + httpRequest.status + httpRequest.statusText);
		}	
	}
}

//4. XMLHttpRequest 모듈 만들기 (httpRequest.js)
//XMLHttpRequest 객체를 사용해서 웹 서버에 요청을 보내기 위해 매번 위와 같은 코드를  작성하는 것은 매우 불편하므로
//간단한 코드를 사용해서 XMLHttpRequest 객체를 사용해서 요청을 보낼 수 있는 모듈인 httpRequest.js 파일을 작성
//httpRequest.js 모듈의 sendRequest() 함수를 호출할 때에는 인자 값에 순서대로 요청 URL, 파라미터 목록, 콜백 함수, HTTP 방식(GET/POST)을 입력
<%-- 	
<script type="text/javascript" src="httpRequest.js"></script>
<script type="text/javascript">
function processEvent(){
	var params = "name=" + encodeURIComponent(someName);
	sendRequest("/test.jsp", params, callback, "POST");
}

function callback(){
	
} 
--%>
/* 
httpRequest.js 모듈
//XMLHttpRequest 객체를 생성해 주는 getXMLHttpRequest()함수
function getXMLHttpRequest() {					
	if (window.ActiveXObject) {
		try {
			return new ActiveXObject("Msxml2.XMLHTTP");
		} catch(e) {
			try {
				return new ActiveXObject("Microsoft.XMLHTTP");
			} catch(e1) { return null; }
		}
	} else if (window.XMLHttpRequest) {
		return new XMLHttpRequest();
	} else {
		return null;
	}
}

//생성된 XMLHttpRequest 객체를 저장할 전역변수
var httpRequest = null;							

//XMLHttpRequest 객체를 사용해서 지정한 벙식, 지정한 URL, 첨부할 파라미터 값을 사용하여 웹 서버에 요청을 전송
function sendRequest(url, params, callback, method) {	
	httpRequest = getXMLHttpRequest();
	var httpMethod = method ? method : 'GET';
	if (httpMethod != 'GET' && httpMethod != 'POST') {
		httpMethod = 'GET';
	}
	var httpParams = (params == null || params == '') ? null : params;
	var httpUrl = url;
	//HTTP 요청 방식이 'GET'이면 URL 뒤에 파라미터를 붙임
	if (httpMethod == 'GET' && httpParams != null) {	
		httpUrl = httpUrl + "?" + httpParams;
	}
	//동기 방식에서 브라우저간 차이가 발생하므로, 크로스 브라우저를 위해 항상 비동기식으로 XMLHttpRequest 객체 사용
	httpRequest.open(httpMethod, httpUrl, true);		
	//웹 서버에 전송할 컨텐트 타입 지정
	httpRequest.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');	
	httpRequest.onreadystatechange = callback;
	//HTTP 요청 방식이면 send() 함수를 통해 파라미터 전송
	httpRequest.send(httpMethod == 'POST' ? httpParams : null);	
} */
</script>

<input type="button" value="데이터 송수신" onclick="processEvent()">


<!-- 예제1 -->

<!-- <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
	<meta http-equiv="content-type" content="text/html; charset=euc-kr" />
	<title>간단한 Ajax 어플리케이션!</title>
	<script type="text/javascript">
	var httpRequest = null;
	
	function getXMLHttpRequest() {
		if (window.ActiveXObject) {
			try {
				return new ActiveXObject("Msxml2.XMLHTTP");
			} catch(e) {
				try {
					return new ActiveXObject("Microsoft.XMLHTTP");
				} catch(e1) {
					return null;
				}
			}
		} else if (window.XMLHttpRequest) {
			return new XMLHttpRequest();
		} else {
			return null;
		}
	}
	function load(url) {
		httpRequest = getXMLHttpRequest();
		httpRequest.onreadystatechange = viewMessage;
		httpRequest.open("GET", url, true);
		httpRequest.send(null);
	}
	function viewMessage() {
		if (httpRequest.readyState == 4) {
			if (httpRequest.status == 200) {
				alert(httpRequest.responseText);
			} else {
				alert("실패: "+httpRequest.status);
			}
		}
	}
	</script>
</head>
<body>
<input type="button" value="simple.txt" onclick="load('simple.txt')"/>		//UTF-8		txt파일의 경우 UTF-8로 작성한 경우에만 올바른 결과가 출력
<input type="button" value="simple2.txt" onclick="load('simple2.txt')"/>	//EUC-KR
<input type="button" value="simple.jsp" onclick="load('simple.jsp')"/>		//UTF-8		JSP인 경우에는 UTF-8이나 EUC-KR에 상관없이 올바른 결과가 출력
<input type="button" value="simple2.jsp" onclick="load('simple2.jsp')"/>	//EUC-KR
</body>
</html> -->

<!-- 예제2 -->
<!-- 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
	<meta http-equiv="content-type" content="text/html; charset=euc-kr" />
	<title>안녕하세요!</title>
	<script type="text/javascript" src="httpRequest.js"></script>
	<script type="text/javascript">
	function helloToServer() {
		var params = "name="+encodeURIComponent(document.f.name.value);
		sendRequest("hello.jsp", params, helloFromServer, "POST");
	}
	function helloFromServer() {
		if (httpRequest.readyState == 4) {
			if (httpRequest.status == 200) {
				alert("서버응답:"+httpRequest.responseText);
			}
		}
	}
	</script>
</head>
<body>
<form name="f">
<input type="text" name="name" />
<input type="button" value="입력" onclick="helloToServer()" />
</form>
</body>
</html>

<%-- <%@ page contentType="text/plain; charset=euc-kr" %>
<%
	request.setCharacterEncoding("utf-8");
	String name = request.getParameter("name");
%>
안녕하세요, <%= name %> 회원님! --%>
 -->