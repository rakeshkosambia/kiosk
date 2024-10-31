<%@page import="com.midz.dao.SanneraUserDao"%>
<jsp:useBean id="u" class="com.midz.bean.SanneraUser"></jsp:useBean>
<jsp:setProperty property="*" name="u"/>
<%
try {
	    if (session.getAttribute("id") != null){
		     int i=SanneraUserDao.save(u, Integer.parseInt(session.getAttribute("id").toString()));
		     if(i>0){
		        response.sendRedirect("dashboard.jsp?msg='Record Added Successfully.'");
		     }
	    } else {
		    response.sendRedirect("login.jsp?loginmessage='Login expired.'");
	    }
    }
catch (Exception ex) {
	response.sendRedirect("dashboard.jsp?msg="+ex.getMessage());
}
%>