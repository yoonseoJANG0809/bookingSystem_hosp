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

String PtNum = request.getParameter("PtNum");
String DrNum = request.getParameter("DrNum");
String BookDay = request.getParameter("BookDay");
String WorkTime = request.getParameter("WorkTime");
String Remark = request.getParameter("Remark");

String prevDrNum = request.getParameter("prevDrNum");
String prevBOOKDATETIME = request.getParameter("prevBOOKDATETIME");


//DB에 Update
sql = String.format( "UPDATE PTBOOK SET DR# = '" + DrNum + "', BOOKDATETIME = TO_DATE('" + BookDay + " " + WorkTime + "','YYYY-MM-DD HH24:MI'), REMARK = '" + Remark + "' "+
					"WHERE BOOKDATETIME = TO_DATE('" + prevBOOKDATETIME +  "', 'YYYY-MM-DD HH24:MI') AND DR# = '" + prevDrNum + "'");

System.out.println(sql);
conn.prepareStatement(sql).executeUpdate();
conn.commit();


%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>숙명 병원 예약 변경</title>
</head>
<body>
<table> 
	<tr> 
		<td>   <img src="img\swmu.png" width="50" height = "50">    </td> 
		<td>  <h1> 숙명여자대학교 병원 예약 수정  </h1></td>
	</tr>
</table><br><br>
<h3>[수정되었습니다.]</h3><br><br>
<table border="1" width="50%">
	<tr>
		<th>이름</th>
		<th>환자번호</th>
		<th>핸드폰번호</th>
		<th>e-mail</th>
		<th>요청사항</th>
		<th>진료과목</th>
		<th>의사명</th>
		<th>예약시간</th>  
	</tr>    
<% 
//Update 한 결과를 다시 조회해서 확인 
sql = String.format( "SELECT  B.PT#, P.PTNAME, P.PHONE#, P.EMAIL, D.MEDISUBJ, D.DRNAME, " +
                         "    TO_CHAR (B.BOOKDATETIME,  'YYYY-MM-DD HH24:MI')  BOOKDATETIME, NVL(B.REMARK, ' ') REMARK " +
                         "FROM PTBOOK B JOIN DOCTOR D ON B.DR# = D.DR# " + 
                         "              JOIN PATIENT P ON B.PT# = P.PT# " +
                         "WHERE B.PT# = '%s'  " +
                         "AND TO_CHAR(B.BOOKDATETIME, 'YYYY-MM-DD HH24:MI') = '%s' ", 
                         PtNum, BookDay + " " + WorkTime );

res = conn.prepareStatement(sql).executeQuery();
while(res.next()){
	String DbPtNum = res.getString("PT#");
	String DbPtName = res.getString("PTNAME");
	String DbPhoneNum = res.getString("PHONE#");
	String DbEmail = res.getString("EMAIL");
	String DbMediSubj = res.getString("MEDISUBJ");
	String DbDrName = res.getString("DRNAME");
	String DbBookDateTime = res.getString("BOOKDATETIME");
	String DbRemark = res.getString("REMARK");
	%>
	<tr>
    <td align="center"><%=DbPtName%></td> 
    <td align="center"><%=DbPtNum%></td> 
    <td align="center"><%=DbPhoneNum%></td> 
    <td align="center"><%=DbEmail%></td>
    <td align="center"><%=DbRemark%></td>
    <td align="center"><%=DbMediSubj%></td>
    <td align="center"><%=DbDrName%></td> 
    <td align="center"><%=DbBookDateTime%></td> 
	</tr> 
<%} %>
</table><br><br>
<hr>
<a href="index.jsp"><button>메인화면으로</button></a>
</body>
</html>