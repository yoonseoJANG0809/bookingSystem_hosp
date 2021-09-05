<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
/* 한글 깨짐 방지 */
request.setCharacterEncoding("UTF-8");

/* db connection */
String user = "JYS";
String pw = "JYS";
String url = "jdbc:oracle:thin:@localhost:1521:xe";
String sql = "";
Class.forName("oracle.jdbc.driver.OracleDriver");
Connection conn = DriverManager.getConnection(url, user, pw);
ResultSet res;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약 삭제</title>
</head>
<body>
<table> 
	<tr> 
		<td>   <img src="img\swmu.png" width="50" height = "50">    </td> 
		<td>  <h1> 숙명여자대학교 병원  </h1>   </td>
	</tr>
</table> 
<hr>
<br><br>
	<% 
	String prevDrNum = request.getParameter("prevDrNum");
	String prevBOOKDATETIME = request.getParameter("prevBOOKDATETIME");
	%>
	<h3>[삭제되었습니다.]</h3>
	<%
	sql = String.format("delete from PTBOOK where DR# = '%s' AND BOOKDATETIME = to_date('%s','YYYY-MM-DD HH24:MI')", prevDrNum, prevBOOKDATETIME);
	System.out.println(sql);
	conn.prepareStatement(sql).executeUpdate();
	conn.commit();
	%>
<br><br>
<hr>
<a href="index.jsp"><button>메인화면으로</button></a>
</body>
</html>