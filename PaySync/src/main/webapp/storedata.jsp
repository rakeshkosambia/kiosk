<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <meta charset="UTF-8">
    <title> Village Maintenance Payment Kiosk </title>
   </head>
<%@page import="com.midz.util.ConstantParameters,com.midz.dao.SanneraPayDao,com.midz.bean.SanneraPay"%>
<%
int data=Integer.parseInt(request.getParameter("data"));

%>      
 <body>  
   <form>
      <div>
           <span>Data:</span>
           <span><%=data%></span>
      </div>
   </form>
</body>
</html>