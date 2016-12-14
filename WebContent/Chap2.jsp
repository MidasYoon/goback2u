<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script>
//getXMLHttpRequest() �Լ��� ������ ��ü�� �����ϱ� ���� ������ ���� ����
var httpRequest = null;

//1. XMLHttpRequest ��ü ���ϱ�
function getXMLHttpRequest(){
	if (window.ActiveXObject) {
		//IE���� XMLHttpRequest ��ü ���ϱ�
		try {
			return new ActiveXObject("Msxml2.XMLHTTP");
		} catch(e) {
			try {
				return new ActiveXObject("Microsoft.XMLHTTP");
			} catch(e1) { return null; }
		}
	} else if (window.XMLHttpRequest) {
		//IE �̿��� ���������� XMLHttpRequest ��ü ���ϱ�
		return new XMLHttpRequest();
	} else {
		return null;
	}
}

//2. �� ������ ��û ����
function processEvent(){
	httpRequest = getXMLHttpRequest();
	
	//onreadystatechange : �� �����κ��� ������ �����ϸ� Ư���� �ڹٽ�ũ��Ʈ �Լ��� ȣ���ϴ� ����� ����
	//�ݹ� �Լ� : onreadystatechange ������Ƽ�� ������ �Լ�
	httpRequest.onreadystatechange = callbackFunction;
	
	//open() �Լ� : ��û�� �ʱ�ȭ. GET/POST ����, ������ URL �Է�
	//	ù ��° ���� : HTTP �޼���(GET/POST)
	//	�� ��° ���� : ������ URL, �� �������� ���Ȼ� ������ ������ URL�� ���� �������� ���� �����ο� �־�� ��
	//	�� ��° ���� : ����/�񵿱� ����� ����, true(�񵿱� ������� ȣ��)
	//send() �Լ� : �� ������ ��û ���� 
	
	//get ��� ���� : �Ķ���͸� ������ ������ URL �ڿ� �Ķ���͸� ����, ������ �Ķ���Ͱ� ���ٸ� URL�� �Է� 
	httpRequest.open("GET", "./test.jsp?id=madvirus&pw=1234", true);
	httpRequest.send(null);
	//���� ��İ� �񵿱� ��� : �񵿱� ���(send()�Լ��� ȣ��� �� ��ٷ� ������ �ڵ尡 ����), ���� ���(�������� ����� ������ �Ϸ�� ���Ŀ� send() �Լ� ������ �ڵ尡 ����)
	//�Ķ������ �ѱ� ó�� ��� : XMLHttpRequest ��ü�� �� ������ �����ϴ� ��û �Ķ������ ��쿡�� �ݵ�� UTF-8�� ���ڵ��ؼ� ����, �׷��� ���� ��� �߸��� �Ķ���� ���� ����
	/* var params = "name=" + encodeURIComponent("�ֹ���");
	httpRequest.open("GET", "./test.jsp?"+params, true); */

	//����/JSP�� ���� HttpServletRequest.setCharacterEncoding()�޼��带 ����ؼ� �о�� �Ķ������ ĳ���ͼ��� ���
	<%-- <% 
		request.setCharacterEncoding("UTF-8");
		String name = request.getParameter("name");
	%> --%>

	
	//post ��� ����
/* 	httpRequest.open("POST", "./test.jsp", true);
	httpRequest.send("id=madvirus&pw=1234"); */
}

//3. ���� ���� ó��
function callbackFunction(){
	//readyState : XMLHttpRequest�� ���¸� ǥ���� �� ���
	//0/UNINITIALIZED/��ü�� �����ǰ� ���� �ʱ�ȭ���� ���� ����(open �޼��尡 ȣ����� ����) 
	//1/LOADING/open �޼��尡 ȣ��ǰ� ���� send �޼��尡 �Ҹ��� ���� ����
	//2/LOADED/send �޼��尡 �ҷ����� status�� ����� �������� ���� ����
	//3/INTERACTIVE/�������� �Ϻθ� ���� ����
	//4/COMPLETED/�����͸� ���� ���� ����. ������ �������� �̿� ����
	
	//readyState�� ���� ����� ������ �ݹ� �Լ��� ȣ��ǹǷ� readyState�� ���� ���Ͽ� �� ���� ���� �˸��� ó���� ���� 
	if(httpRequest.readyState==1 || httpRequest.readyState==2 || httpRequest.readyState==3){
		//ȭ�鿡 �������� �۾� ���̶�� �޽��� ���
		alert("processing" + httpRequest.readyState);
	}else if (httpRequest.readyState==4){
		//�����κ��� �����ϰ� ������ ������ ��� ���� ����� ���� �˸��� �۾� ó��
		
		//status : �� ������ ������ ���� �ڵ尡 ����Ǵ� ������Ƽ, statusText : status ������Ƽ�� ���� �����ϴ� �ؽ�Ʈ ������ ����
		//202/OK/��û ����
		//403/Forbidden/���� �ź�
		//404/Not Found/������ ����
		//500/Internal Server Error/���� ���� �߻�
		if(httpRequest.status==200){
			//���������� ����
			alert("completed" + httpRequest.status + httpRequest.statusText);
			
			//responseText : �������� ������ �ܼ� ���� �ؽ�Ʈ�� ������ �� ����ϴ� ������Ƽ
			var txt = httpRequest.responseText;
			//txt�� ����ؼ� �˸��� �۾� ����
			alert(txt);
		}else{
			alert("error : " + httpRequest.status + httpRequest.statusText);
		}	
	}
}

//4. XMLHttpRequest ��� ����� (httpRequest.js)
//XMLHttpRequest ��ü�� ����ؼ� �� ������ ��û�� ������ ���� �Ź� ���� ���� �ڵ带  �ۼ��ϴ� ���� �ſ� �����ϹǷ�
//������ �ڵ带 ����ؼ� XMLHttpRequest ��ü�� ����ؼ� ��û�� ���� �� �ִ� ����� httpRequest.js ������ �ۼ�
//httpRequest.js ����� sendRequest() �Լ��� ȣ���� ������ ���� ���� ������� ��û URL, �Ķ���� ���, �ݹ� �Լ�, HTTP ���(GET/POST)�� �Է�
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
httpRequest.js ���
//XMLHttpRequest ��ü�� ������ �ִ� getXMLHttpRequest()�Լ�
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

//������ XMLHttpRequest ��ü�� ������ ��������
var httpRequest = null;							

//XMLHttpRequest ��ü�� ����ؼ� ������ ����, ������ URL, ÷���� �Ķ���� ���� ����Ͽ� �� ������ ��û�� ����
function sendRequest(url, params, callback, method) {	
	httpRequest = getXMLHttpRequest();
	var httpMethod = method ? method : 'GET';
	if (httpMethod != 'GET' && httpMethod != 'POST') {
		httpMethod = 'GET';
	}
	var httpParams = (params == null || params == '') ? null : params;
	var httpUrl = url;
	//HTTP ��û ����� 'GET'�̸� URL �ڿ� �Ķ���͸� ����
	if (httpMethod == 'GET' && httpParams != null) {	
		httpUrl = httpUrl + "?" + httpParams;
	}
	//���� ��Ŀ��� �������� ���̰� �߻��ϹǷ�, ũ�ν� �������� ���� �׻� �񵿱������ XMLHttpRequest ��ü ���
	httpRequest.open(httpMethod, httpUrl, true);		
	//�� ������ ������ ����Ʈ Ÿ�� ����
	httpRequest.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');	
	httpRequest.onreadystatechange = callback;
	//HTTP ��û ����̸� send() �Լ��� ���� �Ķ���� ����
	httpRequest.send(httpMethod == 'POST' ? httpParams : null);	
} */
</script>

<input type="button" value="������ �ۼ���" onclick="processEvent()">


<!-- ����1 -->

<!-- <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
	<meta http-equiv="content-type" content="text/html; charset=euc-kr" />
	<title>������ Ajax ���ø����̼�!</title>
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
				alert("����: "+httpRequest.status);
			}
		}
	}
	</script>
</head>
<body>
<input type="button" value="simple.txt" onclick="load('simple.txt')"/>		//UTF-8		txt������ ��� UTF-8�� �ۼ��� ��쿡�� �ùٸ� ����� ���
<input type="button" value="simple2.txt" onclick="load('simple2.txt')"/>	//EUC-KR
<input type="button" value="simple.jsp" onclick="load('simple.jsp')"/>		//UTF-8		JSP�� ��쿡�� UTF-8�̳� EUC-KR�� ������� �ùٸ� ����� ���
<input type="button" value="simple2.jsp" onclick="load('simple2.jsp')"/>	//EUC-KR
</body>
</html> -->

<!-- ����2 -->
<!-- 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
	<meta http-equiv="content-type" content="text/html; charset=euc-kr" />
	<title>�ȳ��ϼ���!</title>
	<script type="text/javascript" src="httpRequest.js"></script>
	<script type="text/javascript">
	function helloToServer() {
		var params = "name="+encodeURIComponent(document.f.name.value);
		sendRequest("hello.jsp", params, helloFromServer, "POST");
	}
	function helloFromServer() {
		if (httpRequest.readyState == 4) {
			if (httpRequest.status == 200) {
				alert("��������:"+httpRequest.responseText);
			}
		}
	}
	</script>
</head>
<body>
<form name="f">
<input type="text" name="name" />
<input type="button" value="�Է�" onclick="helloToServer()" />
</form>
</body>
</html>

<%-- <%@ page contentType="text/plain; charset=euc-kr" %>
<%
	request.setCharacterEncoding("utf-8");
	String name = request.getParameter("name");
%>
�ȳ��ϼ���, <%= name %> ȸ����! --%>
 -->