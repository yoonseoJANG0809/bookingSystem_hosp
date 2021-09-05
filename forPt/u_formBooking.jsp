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
    
    String PtNum = request.getParameter("PtNum");
    String prevDrNum = request.getParameter("prevDrNum");
    String prevBOOKDATETIME = request.getParameter("prevBOOKDATETIME");
    
    

    
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>숙명 병원 예약 변경</title>
</head>
<body>
<table> 
	<tr> 
		<td>   <img src="img\swmu.png" width="50" height = "50">    </td> 
		<td>  <h1> 숙명여자대학교 병원 예약 수정  </h1>   </td>
	</tr>
</table> 
<br>
<br>
환자번호 : <%=PtNum%> <br><br>
	<form name="frmU_insertPatient" action="u_insertPatient.jsp" method="post" >
        <fieldset><legend>예약 정보 수정</legend>
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
            <input type="hidden" name="PtNum" value="<%=PtNum %>" />
            <input type="hidden" name="prevDrNum" value="<%=prevDrNum %>" />
            <input type="hidden" name="prevBOOKDATETIME" value="<%=prevBOOKDATETIME %>" />
        </fieldset>
    </form>   
    
</body>
</html>