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
<jsp:include page="common.jsp"/>

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
        	      if(vUserRole.equalsIgnoreCase("admin")){
                      breadcrumb = "<span class='breadcrumb'> You are here: MEMBER LIST > Edit </span>";
                  } else {
                          breadcrumb = "";
                  }
              }
              String title = "Edit Member "+breadcrumb; 
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
	 <form action="editusersubmit.jsp">
		 <input type="hidden" name="id" value="<%=u.getId() %>"/>
         <input type="hidden" name="createdby" value="<%=session.getAttribute("id")%>">
         <input type="hidden" name="updatedby" value="<%=session.getAttribute("id")%>">		 
	          <%     
	          		String adminselected = "";
	          		String userselected = "";
	          		
	          		if(u.getRole().equalsIgnoreCase("admin")){
	          			adminselected="checked";
	          			userselected="";
	          		} else if((u.getRole().equalsIgnoreCase("user"))){
	          		    adminselected="";
	          			userselected="checked";
	          		}
	          %>
	          <p>&nbsp;</p> 
	          
         <table >
            <tr>
                <td class="details">User Type:</td>
                <td> 
                      <input class="dot" type="radio" name="role" value="admin" <%=adminselected%> required/>Admin
                      <input class="dot" type="radio" name="role" value="user" <%=userselected%> required/>User
                </td>
                <td width="8px"></td>
                <td class="details" colspan="5"></td>               
            </tr>           
            <tr>
                <td class="details">Name</td>
                <td><input type="text" name="name" placeholder="" value="<%=u.getName()%>" required></td>
                <td width="8px"></td>
                <td class="details" colspan="5"></td>               
            </tr>         
            <tr>
                <td class="details">Phase #</td>
                <td><input type="number" name="phase" placeholder="" value="<%=u.getPhase()%>" required></td>
                <td width="8px"></td>
                <td class="details">Block #</td>
                <td><input type="number" name="block" placeholder="" value="<%=u.getBlock()%>" required></td> 
                <td width="8px"></td>
                <td class="details">Lot #</td>
                <td><input type="number" name="lot" placeholder="" value="<%=u.getLot()%>" required></td>               
            </tr>
            <tr>
                <td class="details">Email Address</td>
                <td><input type="email" name="email" placeholder="" value="<%=u.getEmail()%>" required></td>
                <td width="8px"></td>
                <td class="details">Mobile Number</td>
                <td><input type="number" name="mobile" placeholder="" value="<%=u.getMobile()%>" required></td>  
                <td width="8px"></td>
                <td class="details" colspan="2"></td>              
            </tr>  
            <tr>
                <td class="details">Username</td>
                <td><input type="text" name="username" placeholder="" value="<%=u.getUsername()%>" required></td>
                <td width="8px"></td>
                <td class="details">Password</td>
                <td><input type="password" name="password" placeholder="" value="<%=u.getPassword()%>" required></td>  
                <td width="8px"></td>
                <td class="details">Active User</td>
                <td>
                <% 
                   String yesSelected = "";
                   String noSelected = "";
                   if(u.getActive().equalsIgnoreCase("Y")) {
                       yesSelected = "selected";
                   }
                   if(u.getActive().equalsIgnoreCase("N")) {
                       noSelected = "selected";
                   }                   
                %>
                    <select name="active" required>
					  <option value="" disabled selected>Select an option</option>
					  <option value="Y" <%=yesSelected%>>Yes</option>
					  <option value="N" <%=noSelected%>>No</option>
					</select>
                </td>             
            </tr>              
         </table>	          
	     <table width="100%">
             <tr>
                 <td colspan="2">
                      <div class="custom-center">
                          <input type="submit" value=" Update " class="custom-button">
                      </div>
                 </td>
             </tr> 
         </table>
      </form>
      </div>
</body>
</html>