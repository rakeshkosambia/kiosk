<%@page import="com.midz.dao.SanneraBillDao,java.text.*,java.util.*"%>
<jsp:useBean id="u" class="com.midz.bean.SanneraBill"></jsp:useBean>
<jsp:setProperty property="*" name="u"/>

<jsp:include page="common.jsp"/>

<%
try {  
    
	   Date billDate = new SimpleDateFormat("yyyy-MM-dd").parse(u.getDuration());
	   SimpleDateFormat sm = new SimpleDateFormat("yyyy-MM-dd");
	   
       u.setBillDate(billDate);
       u.setCreatedBy((Integer)session.getAttribute("id"));
       u.setUpdatedBy((Integer)session.getAttribute("id"));
	   
       //System.out.println("RAKESH--->2:"+u.getBillDate().toLocaleString());
	   //System.out.println("RAKESH--->"+u.getAmount());
	   //System.out.println("RAKESH--->"+u.getUserId());
	   
	   int i=SanneraBillDao.saveAll(u);
       if(i>0) {
	       response.sendRedirect("dashboard.jsp?msg='Bill Added To All Users Successfully.'");
	   } 
    }
catch (Exception ex) {
    ex.printStackTrace();
	response.sendRedirect("dashboard.jsp?msg=error:"+ex.getMessage());
}
%>