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

// DB에 Insert
sql = String.format( "Insert into JYS.PTBOOK (DR#,BOOKDATETIME,PT#,REMARK) values ('%s',to_date('%s','YYYY-MM-DD HH24:MI'),'%s','%s') ", 
      DrNum, BookDay + " " + WorkTime, PtNum, Remark);

System.out.println(sql);
conn.prepareStatement(sql).executeUpdate();
conn.commit();

//Insert 한 결과를 다시 조회해서 확인 
sql = String.format( "SELECT  B.PT#, P.PTNAME, P.PHONE#, P.EMAIL, D.MEDISUBJ, D.DRNAME, " +
                         "    TO_CHAR (B.BOOKDATETIME, 'YYYY-MM-DD HH24:MI')  BOOKDATETIME, NVL(B.REMARK, ' ') REMARK " +
                         "FROM PTBOOK B JOIN DOCTOR D ON B.DR# = D.DR# " + 
                         "              JOIN PATIENT P ON B.PT# = P.PT# " +
                         "WHERE B.PT# = '%s'  " +
                         "AND TO_CHAR(B.BOOKDATETIME, 'YYYY-MM-DD HH24:MI') = '%s' ", 
                         PtNum, BookDay + " " + WorkTime );

res = conn.prepareStatement(sql).executeQuery();
res.next();
String DbPtNum = res.getString("PT#");
String DbPtName = res.getString("PTNAME");
String DbPhoneNum = res.getString("PHONE#");
String DbEmail = res.getString("EMAIL");
String DbMediSubj = res.getString("MEDISUBJ");
String DbDrName = res.getString("DRNAME");
String DbBookDateTime = res.getString("BOOKDATETIME");
String DbRemark = res.getString("REMARK");

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>숙명 병원 예약 등록</title>
</head>
<body>
<table> 
	<tr> 
		<td>   <img src="img\swmu.png" width="50" height = "50">    </td> 
		<td>  <h1> 숙명여자대학교 병원 진료 예약</h1>   </td>
	</tr>
</table>
<br>
<h3><%=DbPtName %>님 예약이 완료되었습니다.</h3>
<br>
<div style = "width: 40%; border: 1px solid black">
환자번호 : <%=DbPtNum %>
<br>
핸드폰번호 : <%=DbPhoneNum %>
<br>
e-mail : <%=DbEmail %>
<br>
요청사항 : <%=DbRemark %>
<br>
<br>

진료과목 : <%=DbMediSubj %>
<br>
의사명 : <%=DbDrName %>
<br>
의사번호 : <%=DrNum %>
<br>
예약시간 : <%=DbBookDateTime %>
<br>
</div>
<br><br><br>
<hr>
<a href="index.jsp"><button>메인화면으로</button></a>
   
</body>
</html>