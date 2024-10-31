<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <meta charset="UTF-8">
    <title> Village Maintenance Payment Kiosk </title>
    <link rel="stylesheet" href="./css/new_style.css">
     <meta name="viewport" content="width=device-width, initial-scale=1.0">
   </head>
 <body>
<%@page import="com.midz.dao.SanneraBillDao,com.midz.bean.SanneraBill"%>
<%
int billid=Integer.parseInt(request.getParameter("billid"));
SanneraBill u = SanneraBillDao.getRecordByBillId(billid);
%>
    <div class="container">
      <div class="content">    
       <!-- title -->
       <div class="title-table">
	   <jsp:include page="common.jsp"/>

		  <% 
              String breadcrumb = "";
              String vUserRole = "";
              if (session.getAttribute("role") != null){
        	      vUserRole = (String)session.getAttribute("role");
        	      if(vUserRole.equalsIgnoreCase("admin")){
                      breadcrumb = "<span class='breadcrumb'> You are here: MEMBER LIST > View Individual Bill > Edit Bill </span>";
                  } else {
                          breadcrumb = "";
                  }
              }
              String title = "Edit Bill "+breadcrumb; 
          %> 
          <table>
             <tr width="25px">
               <td><img src="./image/sannera.jpg" alt="" width="25px" height="25px"><%=title%></td>   
             </tr>
          </table>    
       </div>    
       <!-- title -->   
           
           <jsp:include page="navigation.jsp"/>
     <div class="custom-center-container">        
	 <form action="billeditsubmit.jsp">
	   <input type="hidden" name="userid" value="<%=u.getUserId()%>">
       <input type="hidden" name="billid" value="<%=billid%>"> 
	     <table >         
            <tr>
                <td class="details">Name</td>
                <td><%=u.getName()%></td>     
            </tr>   
            <tr>
                <td class="details">Bill Date</td>
                <td><input type="date" name="duration" placeholder="" value="<%=u.getDuration()%>" required></td>     
            </tr> 
            <tr>
                <td class="details">Bill Amount</td>
                <td><input type="float" name="amount" placeholder="" value="<%=u.getAmount()%>" required></td>     
            </tr>                                      
         </table>
         <table width="100%">
             <tr>
                 <td colspan="2">
                     <div class="custom-center">
                         <input type="submit" value=" Update Bill" class="custom-button">
                     </div> 
                 </td>
             </tr> 
         </table>
      </form>  
     </div>       
</body>
</html>