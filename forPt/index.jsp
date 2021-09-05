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
<link rel="stylesheet" type="text/css" href="style.css">
<title>숙명 병원 예약 관리</title>
</head>
<body>    
<table> 
	<tr> 
		<td>   <img src="img\swmu.png" width="50" height = "50">    </td> 
		<td>  <h1> 숙명여자대학교 병원 예약 안내  </h1>   </td>
	</tr>
</table>  

<br> 
<h2> 의료진 목록 </h2>
<table border="1" width="50%">
	<tr>
		<th>진료과목</th>
		<th>의사명</th>
		<th>의사번호</th>  
	</tr>    
    <%     
    sql = "SELECT MEDISUBJ, DRNAME,  DR# FROM DOCTOR  ORDER BY MEDISUBJ, DRNAME " ;
    res = conn.prepareStatement(sql).executeQuery(); 
    
    while (res.next()) {            
      String DbMediSubj = res.getString("MEDISUBJ");
      String DbDrName = res.getString("DRNAME");   
      String DbDrNum = res.getString("DR#");
    %>   
      <tr>
         <td><%=DbMediSubj%></td> 
         <td><%=DbDrName%></td> 
         <td><%=DbDrNum%></td>  
      </tr>      
         <%
         }
       %>                 
</table>       
          
<br>      
<br>
   
<h2> 온라인 예약 </h2>      
<div class="reserve">
	<ul>
		<li>온라인 진료예약이란 홈페이지와 모바일을 통해 원하는 진료일정을 직접 선택하여 예약과 취소를 할 수 있는 편리한 예약방법입니다.</li>
		<br>
		<li>홈페이지와 모바일의 [진료예약등록]에서 의료진의 실시간 예약 상황을 확인하여 환자 분이 원하시는 예약 가능한 시간에 예약을 진행할 수 있습니다. </li> 
		<br>  
		<li>환자 분의 연락처 정보와 요청 사항을 남기시면, 전문 의료진이 빠른 진료를 도와드리고 있습니다.</li>
		<br>
		<li>예약 등록이 완료되면, [예약조회 및 취소]에서 예약하신 진료 내역을 확인하실 수 있고, 예약 취소도 진행할 수 있습니다. </li>
		<br> 
	    <li>상담 문의 시간
	    <br>
	    &nbsp;&nbsp;평일 09:00~18:00, 토요일 09:00~12:00 (공휴일제외)</li>
	    <br>
	</ul>
<table> 
	<tr>   
		<td> 
			<form name="frmBooking" action="formBooking.jsp" method="post" >           
				<button type="submit"   class="button" >진료 예약 등록</button>
			</form>   
		</td>
		<td>
			<form name="frmSearch" action="formSearch.jsp" method="post" >           
				<button type="submit" class="button" >예약 조회 및 취소</button>
			</form>   
		</td>    
	</tr>
</table>   
</div>   
</body>
</html>