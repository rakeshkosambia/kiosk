<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Add User Success</title>
<link rel="stylesheet" href="./css/new_style.css">
</head>
<body>
   <div class="container">
    <div class="content">    
        <div class="title">Message</div>
   <jsp:include page="navigation.jsp"/>

   <div style="background-color:red;color:white;padding:2%;">
       <%=request.getParameter("msg")%>
   </div> 
   <a href="history.back()">Back</a>
</body>   
</html>