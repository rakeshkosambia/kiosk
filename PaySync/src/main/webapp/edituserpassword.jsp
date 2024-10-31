<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <meta charset="UTF-8">
    <title> Village Maintenance Payment Kiosk </title>
    <link rel="stylesheet" href="./css/new_style.css">
     <meta name="viewport" content="width=device-width, initial-scale=1.0">
   </head>
 <body>
 <%@page import="com.midz.dao.SanneraUserDao,com.midz.bean.SanneraUser"%>
<%
String id=request.getParameter("id");
SanneraUser u = SanneraUserDao.getRecordById(Integer.parseInt(id));
%>
      <script src="./js/jquery-3.6.4.min.js"></script>
      <script>
		function startValidate(event) {
		    event.preventDefault(); // Prevent the default form submission behavior
		   
		    var password = $("#password").val();
		    var confirm = $("#confirm").val();	    
		    var errormessageDiv = document.getElementById("errormessage");
			  if (password == "" || confirm == "") {
		            errorMsg = "&nbsp;Password or Confirm Password is required."
		            errormessageDiv.innerHTML = errorMsg;
		      } else if (password !== confirm) {
	              errorMsg = "&nbsp;Password & Confirm Password should be same."
	              errormessageDiv.innerHTML = errorMsg;
	          } else {
	             errorMsg = ""; 
	             errormessageDiv.innerHTML = "";                          
	             $("#validateform").submit();
	           }       
		}
	  </script>
    <div class="container">
       <div class="content">
        <div class="title-table">
          <!-- title --> 
		  <jsp:include page="common.jsp"/> 
          <% 
              String breadcrumb = "";
              String vUserRole = "";
              if (session.getAttribute("role") != null){
        	      vUserRole = (String)session.getAttribute("role");
        	      if(vUserRole.equalsIgnoreCase("user")){
                       breadcrumb = "<span class='breadcrumb'> You are here: MY PROFILE > Change Password </span>";
                  }
              }
              String title = "Update Password "+breadcrumb;
          %> 
          <table>
             <tr width="25px">
               <td><img src="./image/sannera.jpg" alt="" width="25px" height="25px"><%=title%></td>   
             </tr>
          </table>
          <!-- title -->        
        </div>  
           
           <jsp:include page="navigation.jsp"/>
           
   <div class="custom-center-container"> 
	 <form id="validateform" action="editpasswordsubmit.jsp" method="POST"> 
		 <input type="hidden" name="id" value="<%=u.getId() %>"/>
         <input type="hidden" name="createdby" value="<%=session.getAttribute("id")%>">
         <input type="hidden" name="updatedby" value="<%=session.getAttribute("id")%>">		 
         
	     <!-- <div style="font-size: 14px; color: red;" id="errormessage"></div>    -->
	          
         <table class="user-details">   
            <tr>
                <div id ="class="custom-center">
                    <td colspan="2" >
                       <div id="errormessage" class="message-red-err"></div>
                    </td>
                </div>         
            </tr> 
            <tr>
                <td class="details">Name</td>
                <td> <%=u.getName()%> </td>
            </tr>         
            <tr>
                <td class="details">Username</td>    
                <td> <%=u.getUsername()%> </td>           
            </tr>         
            <tr>
                <td class="details">Password</td>
                <td><input type="text" id="password" name="password" placeholder="" required></td>
            </tr>
            <tr>
                <td class="details">Confirmed Password</td>
                <td><input type="text" id="confirm" name="confirm" placeholder="" required></td>           
            </tr>  
            <tr>
                <td colspan="2" style="font-size:10px"></td>    
                       
            </tr> 
            <tr>
                <td colspan="2">
                     <div class="custom-center">
                        <table> 
				             <tr>
				                 <td colspan="2">
				                    <div class="custom-center">
				                      <input type="submit" value=" Update " onclick="startValidate(event)" class="custom-button">
				                    </div>
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
<jsp:include page="footer.jsp"/>
</html>