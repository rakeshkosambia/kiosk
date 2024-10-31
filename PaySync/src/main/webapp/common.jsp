
<%@page import="com.midz.util.ConstantParameters"%>
<%
String mesgtopass = com.midz.util.ConstantParameters.loginExpired;
try {
	    if(session.getAttribute("id") == null){
             request.getRequestDispatcher("login.jsp?loginmessage="+mesgtopass).forward(request, response);
	    } 
    }
	catch (Exception ex) {
	    request.getRequestDispatcher("login.jsp?loginmessage="+mesgtopass).forward(request, response);
	}
%>	 
