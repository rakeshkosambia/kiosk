<%@page import="com.midz.dao.SanneraPayDao,java.text.*,java.util.*"%>
<jsp:useBean id="u" class="com.midz.bean.SanneraPay"></jsp:useBean>
<jsp:setProperty property="*" name="u"/>

<jsp:include page="common.jsp"/>

<%
try {  
       //Date paidDate = new SimpleDateFormat("yyyy-MM-dd").parse(u.getDuration());
       //SimpleDateFormat sm = new SimpleDateFormat("yyyy-MM-dd");
       
       Integer.parseInt(session.getAttribute("id").toString());
       
       u.setUserId(Integer.parseInt(session.getAttribute("id").toString()));
       u.setPaidAmount(Float.parseFloat(request.getParameter("paidamount")));
       u.setOffsetStatus(0);
       u.setOffsetAmount(Float.parseFloat(request.getParameter("paidamount")));
       u.setOffsetAmount(0);
       u.setCreatedBy(Integer.parseInt(session.getAttribute("id").toString()));
       u.setUpdatedBy(Integer.parseInt(session.getAttribute("id").toString()));
       u.setPayOffsetPendId(Integer.parseInt(request.getParameter("payOffsetPendId")));

       int i=SanneraPayDao.save(u);
       if(i>0) {
    	   if (com.midz.util.ConstantParameters.PRINT_SILENT_NORMAL.equalsIgnoreCase("NORMAL")) {
    		   response.sendRedirect("receipt.jsp?pay_id="+i);
    	   } else if (com.midz.util.ConstantParameters.PRINT_SILENT_NORMAL.equalsIgnoreCase("SILENT")) {
    		   response.sendRedirect("dashboard.jsp?msg=<br><br><br>Payment is successful.<br><b>Thank you for paying on CashVilla Kiosk!</b><br><br><br>&pay_id="+i);
    	   }
           
       } 
    }
catch (Exception ex) {
    response.sendRedirect("dashboard.jsp?msg="+ex.getMessage());
}
%>