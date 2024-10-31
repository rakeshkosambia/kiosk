<%@ page language="java" contentType="text/html; charset=UTF-8" 
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Arduino Serial Data Example</title>
<script src="./js/jquery-3.6.4.min.js"></script>
<script>
$(document).ready(function() {
    setInterval(function() {
        $.get("SerialDataServlet", function(data) {
            $("#data").text(data);
        });
    }, 1000); // refresh every 1 second 1000, 1 min 10000
});
</script>
</head>
<body>
<%@ page import="java.util.Date" %>    
      <%
       //  Date date = new Date();
      //   out.print( "<h2 align = \"center\">" +date.toString()+"</h2>");
      %>

    <h1>Arduino Serial Data Example</h1>
    <div id="data"></div>
    	<form method="post" action="${pageContext.request.contextPath}/SerialDataServlet">
		<input type="submit" name="action" value="start">
		<input type="submit" name="action" value="stop">
	</form>
</body>
</html>
