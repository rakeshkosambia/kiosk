<%@page import="com.midz.dao.SanneraUserDao"%>
<jsp:useBean id="u" class="com.midz.bean.SanneraUser"></jsp:useBean>
<jsp:setProperty property="*" name="u"/>
<jsp:include page="common.jsp"/>
<%
try {
        if (session.getAttribute("id") != null){
             int i=SanneraUserDao.update(u, Integer.parseInt(session.getAttribute("id").toString()) );
             if(i>0){
                response.sendRedirect("dashboard.jsp?msg='Record Updated Successfully.'");
             }
        }
    }
catch (Exception ex) {
    response.sendRedirect("dashboard.jsp?msg="+ex.getMessage());
}
%>