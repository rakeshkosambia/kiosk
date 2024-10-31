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
   <div classs="content">
        <div class="title-table">
          <!-- title -->
<jsp:include page="common.jsp"/> 
          <% 
              String breadcrumb = "";
              String vUserRole = "";
              if (session.getAttribute("role") != null){
        	      vUserRole = (String)session.getAttribute("role");
        	      if(vUserRole.equalsIgnoreCase("admin")){
                      breadcrumb = "<span class='breadcrumb'> You are here: NEW MEMBERS </span>";
                  } else {
                      breadcrumb = "";
                  }
              }
              String title = "Register New Member "+breadcrumb; 
          %> 		  
          <table>
             <tr width="25px">
               <td><img src="./image/sannera.jpg" alt="" width="25px" height="25px"><%=title%></td>   
             </tr>
          </table>
          <!-- title -->        
        </div>       
            <jsp:include page="navigation.jsp"/>

<div class="container">
   <div class="content">  
     <div class="custom-center-container">         
     <form action="adduser.jsp">    
         <input type="hidden" name="createdby" value="<%=session.getAttribute("id")%>">
         <input type="hidden" name="updatedby" value="<%=session.getAttribute("id")%>">

         <table class="user-details">
            <tr>
                <td class="details">User Type:</td>
                <td> 
                      <input class="dot" type="radio" name="role" value="admin" required/>Admin
                      <input class="dot" type="radio" name="role" value="user" checked required/>User
                </td>
                <td width="8px"></td>
                <td class="details" colspan="5"></td>               
            </tr>           
            <tr>
                <td class="details">Name</td>
                <td><input type="text" name="name" placeholder="" required></td>
                <td width="8px"></td>
                <td class="details" colspan="5"></td>               
            </tr>         
            <tr>
                <td class="details">Phase #</td>
                <td><input type="number" name="phase" placeholder="" required></td>
                <td width="8px"></td>
                <td class="details">Block #</td>
                <td><input type="number" name="block" placeholder="" required></td> 
                <td width="8px"></td>
                <td class="details">Lot #</td>
                <td><input type="number" name="lot" placeholder="" required></td>               
            </tr>
            <tr>
                <td class="details">Email Address</td>
                <td><input type="email" name="email" placeholder="" required></td>
                <td width="8px"></td>
                <td class="details">Mobile Number</td>
                <td><input type="number" name="mobile" placeholder="" required></td>  
                <td width="8px"></td>
                <td class="details" colspan="2"></td>              
            </tr>  
            <tr>
                <td class="details">Username</td>
                <td><input type="text" name="username" placeholder="" value="" required></td>
                <td width="8px"></td>
                <td class="details">Password</td>
                <td><input type="password" name="password" placeholder="" value="" required></td>  
                <td width="8px"></td>
                <td class="details">Active User</td>
                <td>
                    <select name="active" required>
                      <option value="" disabled selected>Select an option</option>
                      <option value="Y">Yes</option>
                      <option value="N">No</option>
                    </select>
                </td>                      
            </tr>     
            <tr>
                <td colspan="8">
                    <div class="custom-center">
	                    <table>
				             <tr>
				                <td>
				                   <input type="submit" value=" Register " class="custom-button">
				                </td>
				             </tr> 
				         </table>
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