<%@page import="com.midz.dao.SanneraBillDao,java.text.*,java.util.*"%>
<jsp:useBean id="u" class="com.midz.bean.SanneraBill"></jsp:useBean>
<jsp:setProperty property="*" name="u"/>
<%
try {  
	   Date billDate = new SimpleDateFormat("yyyy-MM-dd").parse(u.getDuration());
	   SimpleDateFormat sm = new SimpleDateFormat("yyyy-MM-dd");
	   
       u.setBillDate(billDate);
       u.setCreatedBy((Integer)session.getAttribute("id"));
       u.setUpdatedBy((Integer)session.getAttribute("id"));
       u.setUserId(Integer.parseInt(request.getParameter("userid")));
       
	   //out.println(u.getBillDate().toString());
	   //out.println(u.getAmount());
	   //out.println(u.getUserId());
	   
	   int i=SanneraBillDao.save(u);
       if(i>0) {
	       response.sendRedirect("dashboard.jsp?msg='Bill Added Successfully.'");
	   } 
    }
catch (Exception ex) {
	response.sendRedirect("dashboard.jsp?msg="+ex.getMessage());
}
%>