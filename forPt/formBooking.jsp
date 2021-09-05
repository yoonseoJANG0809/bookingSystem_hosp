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
<form name="frmInsertPatient" action="insertPatient.jsp" method="post" >
 	<fieldset><legend>예약 정보 등록</legend>
		<label for="txtPatientName">환자 이름:&nbsp;</label><input type="text" name="PtName" id="txtPatientName" placeholder="환자 이름" size="10" value="" />
		<br>
		<label >성별:&nbsp;</label> <label for="rdoGenderFemale">여성</label><input type="radio" name="Gender" id="rdoGenderFemale" value="F" />
                                       <label for="rdoGenderMale">남성</label><input type="radio" name="Gender" id="rdoGenderMale" value="M" />
		<br>
		<label for="txtBirthDay">생년월일:&nbsp;</label><input type="text" name="BirthDay" id="txtBirthDay" placeholder="YYYY-MM-DD" size="20" value="" />
		<br>
		<label for="txtPhoneNum">핸드폰번호:&nbsp;</label><input type="text" name="PhoneNum" id="txtPhoneNum" placeholder="010-1234-5678" size="20" value=""/> 
		<br>
		<label for="txtEmail">이메일:&nbsp;</label><input type="text" name="email" id="txtEmail" placeholder="id@email.com" size="20" value=""/> 
		<br>
		<label for="txtMediSubj">진료과목:&nbsp;</label> 
		<select name="MediSubj" id="txtMediSubj"    value=""  >
		<%     
            sql = "SELECT DISTINCT MEDISUBJ FROM DOCTOR ORDER BY MEDISUBJ ";
            res = conn.prepareStatement(sql).executeQuery(); 
             
            while (res.next()) {            
               String MediSubj = res.getString("MEDISUBJ");         
             %>
                <option value="<%=MediSubj%>"><%=MediSubj%></option>
            <%
            }
             %>
		</select>
          <br>
          <label for="txtBookDay">예약날짜:&nbsp;</label><input type="text" name="BookDay" id="txtBookDay" placeholder="YYYY-MM-DD" size="20" value="" />  
          <br>
          <label for="txtRemark">요청사항:&nbsp;</label><input type="text" name="Remark" id="txtRemark"   size="80" value="" />  
          <br><br>
            <button type="submit">예약 요청</button>
	</fieldset>
</form>   
    
</body>
</html>