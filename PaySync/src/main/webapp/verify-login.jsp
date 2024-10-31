<%@page import="com.midz.dao.SanneraUserDao, com.midz.bean.SanneraUser, java.util.*"%>
<jsp:useBean id="u" class="com.midz.bean.SanneraUser"></jsp:useBean>
<jsp:setProperty property="*" name="u"/>

<%
try {
     List<SanneraUser> list=SanneraUserDao.getLoginVerification(u);
     int i=0;  
	     for (SanneraUser user: list) {
	    	 session.setAttribute("name", (user.getName()).toUpperCase()); 
	     	 session.setAttribute("username", user.getUsername());
	     	 session.setAttribute("role", user.getRole());
	     	 session.setAttribute("id", user.getId());
	     	 session.setAttribute("userid", user.getId());
	     	 i=i+1;
	     	 break;
	     }     
	     if(i>0){
	    	 if ( session.getAttribute("role").toString().equalsIgnoreCase("admin")   )
	    		 response.sendRedirect("viewusers.jsp");
	    	 else 
	    		 response.sendRedirect("data-privacy.jsp");
	    	 
	     } else {
	    	response.sendRedirect("login.jsp?loginmessage=Unknown User Type/Username/Password or Not active User. Please retry.");
	     }
     }
	 catch (Exception ex) {
	     response.sendRedirect("dashboard.jsp?msg="+ex.getMessage());
	 }	     
%>            