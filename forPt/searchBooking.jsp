<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    

	String PtName = request.getParameter("PtName");
	String Gender = request.getParameter("Gender");
	String BirthDay = request.getParameter("BirthDay");
//	sql = String.format( "SELECT PT# FROM PATIENT WHERE  PTNAME = '%s' AND GENDER = '%s' AND BIRTHDAY = TO_DATE('%s', 'YYYY-MM-DD') ", PtName, Gender, BirthDay);
//	res = conn.prepareStatement(sql).executeQuery();
//	res.next();
//	String PtNum = res.getString("PT#");
 
	sql = String.format("SELECT PT# FROM PATIENT WHERE  PTNAME = '%s' AND GENDER = '%s' AND BIRTHDAY = TO_DATE('%s', 'YYYY-MM-DD') ", PtName, Gender, BirthDay);
	res = conn.prepareStatement(sql).executeQuery();
	String PtNum = "";
	
	if(res.next()){
		PtNum = res.getString("PT#");
		request.setAttribute("PT#", PtNum);
		
	}

	
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>숙명 병원 예약 조회</title>
</head>
<body>
<table> 
	<tr> 
		<td>   <img src="img\swmu.png" width="50" height = "50">    </td> 
		<td>  <h1> 숙명여자대학교 병원 예약 조회  </h1>   </td>
	</tr>
</table> 
<br><br>
<%     
	sql = " SELECT D.MEDISUBJ, D.DRNAME, TO_CHAR (P.BOOKDATETIME, 'YYYY-MM-DD HH24:MI')  BOOKDATETIME, P.DR# " +
	        "FROM PTBOOK P JOIN DOCTOR D ON P.DR# = D.DR# " + 
	        "WHERE P.PT# = '" + PtNum + "'  ";
	System.out.println(sql);
	res = conn.prepareStatement(sql).executeQuery(); 
         
         
	while (res.next()) {            
		String DbMediSubj = res.getString("MEDISUBJ");
		String DbDrName = res.getString("DRNAME");         
		String DbBookDateTime = res.getString("BOOKDATETIME");
		String DbDRNum = res.getString("DR#");
         
      %> 
	<table border="1" width="50%">
		<tr>
			<th>진료과목</th>
			<th>의사명</th>
			<th>예약 일시</th>
			<th>수정</th>
			<th>삭제</th>
		</tr>   
		<tr>
			<td><%=DbMediSubj%></td> 
			<td><%=DbDrName%></td> 
			<td><%=DbBookDateTime%></td> 
			<td align="center">
				<form name="frmUpdateBooking" action="u_formBooking.jsp" method="post" >
					<button type="submit"   class="button" >수정</button>
					<input type="hidden" name="PtNum" value="<%=PtNum %>" />
					<input type="hidden" name="DbMediSubj" value="<%=DbMediSubj %>" />
					<input type="hidden" name="DbDrName" value="<%=DbDrName %>" />
					<input type="hidden" name="prevDrNum" value="<%=DbDRNum%>" />
					<input type="hidden" name="prevBOOKDATETIME" value="<%=DbBookDateTime %>" />
       			</form> 
			</td>
			<td align="center">
				<form name="frmDeleteBooking" action="deleteBooking.jsp" method="post" >           
					<button type="submit"   class="button" >삭제</button>
					<input type="hidden" name="prevDrNum" value="<%=DbDRNum%>" />
					<input type="hidden" name="prevBOOKDATETIME" value="<%=DbBookDateTime %>" />
       			</form> 
			</td>
		</tr> 
	
	</table><br><br>
	<%}%>
	<hr>
	<a href="index.jsp"><button>메인화면으로</button></a>
</body>
</html>