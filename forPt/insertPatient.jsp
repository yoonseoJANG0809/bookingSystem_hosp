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

String PtName = request.getParameter("PtName");
String Gender = request.getParameter("Gender");
String BirthDay = request.getParameter("BirthDay");
String PhoneNum = request.getParameter("PhoneNum");
String email = request.getParameter("email");
String MediSubj = request.getParameter("MediSubj");
String BookDay = request.getParameter("BookDay");
String Remark = request.getParameter("Remark");


/* 이미 등록된 환자인지 확인, 체크 방법 (이름+성별+생년월일) */
sql = String.format( "SELECT PT# FROM PATIENT WHERE  PTNAME = '%s' AND GENDER = '%s' AND BIRTHDAY = TO_DATE('%s', 'YYYY-MM-DD') ", 
      PtName, Gender, BirthDay);
res = conn.prepareStatement(sql).executeQuery();

String PtNum = "";

if (res.next()) {
   // 이미 등록된 환자이면 이메일과 핸드폰 번호를 업데이트 
   PtNum = res.getString("PT#");
   sql = String.format( " UPDATE PATIENT SET PHONE# = '%s' , EMAIL = '%s' WHERE PT# = '%s'", PhoneNum, email, PtNum ); 
   
}
else 
{
   //신규 환자이면 환자 번호 발급   
   sql = String.format("SELECT 'PT' || LPAD( TO_CHAR( PATIENT_SEQ.NEXTVAL) , 8, '0') PT# FROM DUAL ");
   res = conn.prepareStatement(sql).executeQuery();
   res.next();
   PtNum = res.getString("PT#");
   
   //환자번호 넣어서 등록
    sql = String.format( "INSERT INTO PATIENT (PT#,PTNAME,GENDER,BIRTHDAY,PHONE#,EMAIL) values ('%s','%s','%s',to_date('%s','YYYY-MM-DD'),'%s','%s')",
          PtNum, PtName, Gender, BirthDay, PhoneNum, email);                  
}

System.out.println(sql);
conn.prepareStatement(sql).executeUpdate();

//response.sendRedirect("checkBookingTime.jsp?PtNum=" + PtNum);
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
<div style = "width: 40%; border: 1px solid black">
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
               "  DECODE ( B.BOOKDATETIME, NULL, '예약하기', '예약완료')  BOOK_YN " +  
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
             <form name="frmInsertBook" action="insertBooking.jsp" method="post" > 
                 <input type="hidden" name="PtNum" value="<%=PtNum %>" />
                <input type="hidden" name="DrNum" value="<%=DbDrNum %>" />
                <input type="hidden" name="BookDay" value="<%=BookDay %>" />
                <input type="hidden" name="WorkTime" value="<%=DbWorkTime %>" />
                <input type="hidden" name="Remark" value="<%=Remark %>" />             
                <%  
                if ( DbBookYn.equals("예약하기") )
                {
                %>
                <button type="submit">예약하기</button>
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