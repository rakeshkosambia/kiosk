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
        	      if(vUserRole.equalsIgnoreCase("user")){
                       breadcrumb = "<span class='breadcrumb'> You are here: MY PROFILE</span>";
                  } 
              }
              String title = "Owner Profile "+breadcrumb; 
          %> 
          <table>
             <tr width="25px">
               <td><img src="./image/sannera.jpg" alt="" width="25px" height="25px"><%=title%></td>   
             </tr>
          </table>
          <!-- title -->
        </div>       
            
            <jsp:include page="navigation.jsp"/>
            
<%@page import="com.midz.dao.SanneraUserDao,com.midz.bean.*,java.util.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
SanneraUser user=SanneraUserDao.getRecordById((int)session.getAttribute("id") );
String changePassMessage = "";

if (request.getParameter("loginmessage")!= null){
    changePassMessage = request.getParameter("loginmessage");
} else if (user.getLoginAttempt()==1){
    changePassMessage = com.midz.util.ConstantParameters.loginFirst;
} else {
    changePassMessage = "";
}
System.out.println("request.getParameter(loginmessage)-->"+request.getParameter("loginmessage"));
System.out.println("changePassMessage-->"+changePassMessage);
System.out.println("loginattempt-->"+user.getLoginAttempt());

%> 
        <div class="custom-center-container">
		    <form>
			    <table width="500px" style="margin: 0 auto;">
			        <tr>
			            <td>
					         <table class="responsive-table">        
					            <tr>
					                <td>Name</td>
					                <td><%=user.getName()%></td>
					                <td>Phase #</td>   
					                <td><%=user.getPhase()%></td>            
					            </tr>         
					            <tr>
					                <td>Block #</td>
					                <td><%=user.getBlock()%></td>
					                <td>Lot #</td>   
					                <td><%=user.getLot()%></td>            
					            </tr>  
			                    <tr>
			                        <td>Email Address</td>
			                        <td colspan="3"><%=user.getEmail()%></td>
			                    </tr>  		             
					            <tr>
					                <td>Username</td>
					                <td><%=user.getUsername()%></td>
					                <td>Mobile Number</td>   
					                <td><%=user.getMobile()%></td>            
					            </tr>              
					            <tr>
					                <td>Change Password</td>   
					                <td><a href="edituserpassword.jsp?id=<%=(int)session.getAttribute("id")%>">Click here</a></td>            
					                <td colspan="2"></td>
					            </tr>  
					            <tr>
			                        <td colspan="4"><div class="message-green-err" id=loginmessage><%=changePassMessage%></div></td>  
			                    </tr>       
					         </table>
			            </td>
			        </tr>
			    </table>   
		    </form>
      </div>   		
   </div>        
</div>   	    
</body>
<jsp:include page="footer.jsp"/>
</html>