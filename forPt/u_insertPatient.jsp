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

String action = request.getParameter("action");

String writer = request.getParameter("writer");
String content = request.getParameter("content");
String idx = request.getParameter("idx");

String PtNum = request.getParameter("PtNum");
String MediSubj = request.getParameter("MediSubj");
String BookDay = request.getParameter("BookDay");
String Remark = request.getParameter("Remark");

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
<div style="width: 40%; border: 1px solid black;">
환자번호 : <%=PtNum%> <br>
선택한 진료과목 : <%=MediSubj%> <br>
선택한 예약날짜 : <%=BookDay%> <br>
</div>
<br>
 
아래 목록에서 예약을 선택하세요.
   <table border="1" width="40%">
      <tr>
        <th>진료과목</th>
        <th>의사번호</th>
        <th>의사명</th>
        <th>진료시간</th>  
        <th>예약상태</th> 
      </tr>   
        
      <%     
         sql = "SELECT  D.MEDISUBJ, W.DR#, D.DRNAME,  TO_CHAR( W.WORKDATETIME ,'HH24:MI') WORKTIME, " +
               "  DECODE ( B.BOOKDATETIME, NULL, '수정하기', '예약완료')  BOOK_YN " +  
               "  FROM DRWORK W LEFT OUTER JOIN PTBOOK B ON W.DR# = B.DR# AND W.WORKDATETIME = B.BOOKDATETIME  " + 
               "                LEFT OUTER JOIN DOCTOR D ON W.DR# = D.DR# " + 
               "  WHERE D.MEDISUBJ = '" +  MediSubj   +  "' " + 
               "  AND   TO_CHAR(W.WORKDATETIME,'YYYY-MM-DD') = '" + BookDay + "'  " +
               "  AND   W.WORK_YN = 'Y'  " +
               "  ORDER BY D.MEDISUBJ, W.DR#, W.WORKDATETIME " ;
      
      System.out.println(sql);
         res = conn.prepareStatement(sql).executeQuery(); 
          
         int count = res.getRow();     // 조회 결과 갯수가 0개 이면 
         
         
         while (res.next()) {            
            String DbMediSubj = res.getString("MEDISUBJ");
            String DbDrNum = res.getString("DR#");
            String DbDrName = res.getString("DRNAME");         
            String DbWorkTime = res.getString("WORKTIME");
            String DbBookYn = res.getString("BOOK_YN");
      %>   
      <tr>
      
       
         <td align="center"><%=DbMediSubj%></td> 
         <td align="center"><%=DbDrNum%></td> 
         <td align="center"><%=DbDrName%></td> 
         <td align="center"><%=DbWorkTime%></td> 
         <td align="center">  
             <form name="frmUpdateBook" action="updateBooking.jsp" method="post" > 
                 <input type="hidden" name="PtNum" value="<%=PtNum %>" />
                <input type="hidden" name="DrNum" value="<%=DbDrNum %>" />
                <input type="hidden" name="BookDay" value="<%=BookDay %>" />
                <input type="hidden" name="WorkTime" value="<%=DbWorkTime %>" />
                <input type="hidden" name="Remark" value="<%=Remark %>" />
                <input type="hidden" name="prevDrNum" value="<%=prevDrNum %>" /> 
                <input type="hidden" name="prevBOOKDATETIME" value="<%=prevBOOKDATETIME %>" /> 
                <%  
                if ( DbBookYn.equals("수정하기") )
                {
                %>
                <button type="submit">수정하기</button>
                <%    
                }
                else
                {
                %>   
                <%=DbBookYn%>     
                <%}%>             
                
             </form> 
         </td> 
      </tr>         
      <%
         }
       %>          
   </table>    
   <p>      <%  
          int cnt = res.getRow();     // 조회 결과 갯수가 0개 이면 
          if ( cnt == 0  ) 
         {
          %>   
          <tr>예약 가능한 의사와 시간이 없습니다. 예약 날짜를 변경하세요.</tr>
          <% 
         }
           %>      
	</p>
</body>
</html>