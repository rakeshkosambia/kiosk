<%@page import="com.midz.dao.SanneraUserDao"%>
<jsp:useBean id="u" class="com.midz.bean.SanneraUser"></jsp:useBean>
<jsp:setProperty property="*" name="u"/>
<%
try {
     int i=SanneraUserDao.delete(u);
     if(i>0){
        response.sendRedirect("dashboard.jsp?msg='User is marked not active Successfully.'");
       }
    }
catch (Exception ex) {
	response.sendRedirect("dashboard.jsp?msg="+ex.getMessage());
}
%>

