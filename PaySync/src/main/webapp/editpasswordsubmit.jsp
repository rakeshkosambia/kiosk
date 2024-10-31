<%@page import="com.midz.dao.SanneraUserDao"%>
<jsp:useBean id="u" class="com.midz.bean.SanneraUser"></jsp:useBean>
<jsp:setProperty property="*" name="u"/>
<jsp:include page="common.jsp"/>
<%
try {
        if (session.getAttribute("id") != null){
             int i=SanneraUserDao.updatePassword(u);
             if(i>0){
                response.sendRedirect("homeowner.jsp?loginmessage="+com.midz.util.ConstantParameters.updatedPassword);
             }
        } else {
            response.sendRedirect("login.jsp?loginmessage=-"+com.midz.util.ConstantParameters.loginExpired);
        }
    }
catch (Exception ex) {
    response.sendRedirect("dashboard.jsp?msg="+ex.getMessage());
}
%>