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
		<td>  <h1> 숙명여자대학교 병원 예약 관리 시스템  </h1>   </td>
	</tr>
</table><br>
<form name="frmSearchBooking" action="searchBooking.jsp" method="post" >
	<fieldset><legend>본인 확인</legend>
		<label for="txtPatientName">환자 이름:&nbsp;</label><input type="text" name="PtName" id="txtPatientName" placeholder="환자 이름" size="10" value="" />
		<br>
		<label >성별:&nbsp;</label> <label for="rdoGenderFemale">여성</label><input type="radio" name="Gender" id="rdoGenderFemale" value="F" />
                                       <label for="rdoGenderMale">남성</label><input type="radio" name="Gender" id="rdoGenderMale" value="M" />
		<br>
		<label for="txtBirthDay">생년월일:&nbsp;</label><input type="text" name="BirthDay" id="txtBirthDay" placeholder="YYYY-MM-DD" size="20" value="" />
		<br><br>
		<button type="submit">예약 조회</button>
	</fieldset>
</form>   
</body>
</html>