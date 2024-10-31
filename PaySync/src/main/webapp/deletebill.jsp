<%@page import="com.midz.dao.SanneraBillDao"%>
<jsp:useBean id="u" class="com.midz.bean.SanneraBill"></jsp:useBean>
<jsp:setProperty property="*" name="u"/>
<%
try {
	 u.setBillId(Integer.parseInt(request.getParameter("billid")));
     int i=SanneraBillDao.delete(u);
     if(i>0){
        response.sendRedirect("dashboard.jsp?msg='Record Deleted Successfully.'");
       }
    }
catch (Exception ex) {
	response.sendRedirect("dashboard.jsp?msg="+ex.getMessage());
}
%>

