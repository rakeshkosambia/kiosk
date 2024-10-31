<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <meta charset="UTF-8">
    <title> Village Maintenance Payment Kiosk </title>
    <link rel="stylesheet" href="./css/new_style.css">
     <meta name="viewport" content="width=device-width, initial-scale=1.0">
   </head>
<body>
 <body>
 
<jsp:include page="common.jsp"/>
 
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
                      breadcrumb = "<span class='breadcrumb'> You are here: GENERATE BILL </span>";
                  } else {
                      breadcrumb = "";
                  }
              }
              String title = "HomeOwner Bill "+breadcrumb;
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
      <form action="billaddallsubmit.jsp">
         <input type="hidden" name="userid" value="<%=request.getParameter("userid")%>">
         <table class="user-details">         
            <tr>
                <td class="details">Name</td>
                <td>&nbsp;</td>
                <td>All Users</td>     
            </tr>   
            <tr>
                <td class="details">Bill Date</td>
                <td>&nbsp;</td>
                <td><input type="date" name="duration" placeholder="" required></td>     
            </tr> 
            <tr>
                <td class="details">Bill Amount</td>
                <td>&nbsp;</td>
                <td><input type="float" name="amount" placeholder="" value="<%=com.midz.util.ConstantParameters.MINPAYMENT%>" required></td>     
            </tr>      
            <tr>
                <td colspan="3">
                    <div class="custom-center">
		                <table>
				             <tr>
				                <td>
				                    <input type="submit" value=" Bill All " class="custom-button">
				                </td>
				             </tr> 
				        </table> 
			        </div>
                </td>
            </tr>                                
         </table>       
      </form> 
   </div>
</body>
</html>