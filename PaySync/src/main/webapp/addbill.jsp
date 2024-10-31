<!DOCTYPE html> 
<html lang="en" dir="ltr">
  <head>
    <meta charset="UTF-8">
    <title> Village Maintenance Payment Kiosk </title>
    <link rel="stylesheet" href="./css/new_style.css">
     <meta name="viewport" content="width=device-width, initial-scale=1.0">
   </head>
 <body>
    <div class="container">
      <div class="content">    
       <!-- title -->
       <div class="title-table">
          <% 
          String breadcrumb = " MEMBER LIST > Add Individual Bill";
          String title = "Add Bill <span class='breadcrumb'> You are here: "+breadcrumb+"</span>";
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
		 <form action="billaddsubmit.jsp">
		     <input type="hidden" name="userid" value="<%=request.getParameter("userid")%>">
	         <table class="user-details">         
	            <tr>
	                <td class="details">Name</td>
	                <td><%=request.getParameter("name")%></td>     
	            </tr>   
	            <tr>
	                <td class="details">Bill Date</td>
	                <td><input type="date" name="duration" placeholder="" required></td>     
	            </tr> 
	            <tr>
	                <td class="details">Bill Amount</td>
	                <td><input type="float" name="amount" placeholder="" value="<%=com.midz.util.ConstantParameters.MINPAYMENT%>" required></td>     
	            </tr>                                      
	         </table>
	         <table>
	             <tr class="user-details">
                      <td colspan="1">
                          <div class="custom-center">
                              <input type="submit" value=" Add Bill " class="custom-button">
                          </div>
                      </td>	 
	             </tr> 
	         </table>        
	      </form>
      </div>
    </div>
  </div>    
</body>
</html>