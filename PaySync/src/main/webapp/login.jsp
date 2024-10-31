<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <meta charset="UTF-8">
    <title> Village Maintenance Payment Kiosk </title>
    <link rel="stylesheet" href="./css/new_style.css">
     <meta name="viewport" content="width=device-width, initial-scale=1.0">
   </head>
<body>
<script>
  function redirectPage(url) {
    var form = document.getElementById('dataForm');
    form.action = url;
    form.submit();
  }
</script>
<%   
     String loginMessageValue = "";
     if (request.getParameter("loginmessage")!=null){
	   loginMessageValue = request.getParameter("loginmessage");
     }
%>
<div class="container">   
   <div classs="content">
        <div class="title">
          <!-- title -->
          <% String title = "For Sannera Homeowners only"; %>
          <table>
             <tr width="25px">
               <td><img src="./image/sannera.jpg" alt="" width="25px" height="25px"><%=title%></td>   
             </tr>
          </table>
          <!-- title -->
        </div>  
   <div class="custom-center-container">
   <form id="dataForm" action="verify-login.jsp">
        
   <div class="container">   
      <div class="content"> 
          <div style="font-size: 5px;">&nbsp;</div>
          <div class="custom-center">
            <span class="details">User Type:&nbsp;&nbsp;</span>
            <input class="dot" type="radio" name="role" value="admin" required/>Admin
            &nbsp;&nbsp;
            <input class="dot" type="radio" name="role" value="user" checked required/>User
          </div>           

          <table>
            <tr>
                <td>
		              <table class="custom-center">
		                 <tr>
                             <td colspan="2">
                                <div class="message-red-err" id="loginmessage">
                                    <%=loginMessageValue%>
                                </div>  
                             </td>
                         </tr> 
		                 <tr>
                             <td colspan="2">
                                <div style="font-size:10px">&nbsp;</div>  
                             </td>
                         </tr>   
		                 <tr>
		                   <td colspan="2"></td>   
		                 </tr> 
		                 <tr>
		                   <td width="10px">Username</td>
		                   <td width="10px">
		                       <input type="text" name="username" placeholder="Enter your Username" required>
		                   </td>  
		                 </tr>
		                 <tr>
                             <td colspan="2">
                                <div style="font-size:10px">&nbsp;</div>  
                             </td>
                         </tr>   
		                 <tr>
		                   <td class="details">Password</td>
		                   <td>
		                        <input type="password" name="password" placeholder="Enter your Password" required>
		                   </td> 
		                 </tr>             
		                 <tr>
                             <td colspan="2">
                                <div style="font-size:10px">&nbsp;</div>  
                             </td>
                         </tr>   
		                 <tr>
		                     <td colspan="2">
		                       <div class="custom-center">  
			                      <table>
			                        <tr>
			                            <td>
			                                <div class="custom-right">
			                                    <input type="submit" value=" Cancel " class="custom-button" onclick="redirectPage('index.jsp');">
			                                </div>
			                            </td>
			                            <td width="10px">&nbsp;</td>
			                            <td>
			                                <div class="custom-left">
			                                    <input type="submit" value=" Login " class="custom-button">
			                                </div>
			                            </td>
			                        </tr>
			                      </table>
		                      </div>   
		                     </td>
		                 </tr> 
		              </table>   
                </td>
                <td style="vertical-align: top;">
                      &nbsp;
                </td>
            </tr>
             <tr>
                <td style="vertical-align: top;" colspan="2">
                     <table>
                        <tr>
                           <td style="color: blue; font-size: 18px; vertical-align: top;">
                              *Please contact your admin for your username and password*
                           </td>
                        </tr>  
                      </table>
                </td>
            </tr>
          </table>
      </form>	
    </div>
  </div>
  <%
	 session.invalidate();
     session = request.getSession(true);
	 session.setAttribute("role","no-login");
  %>
</body>
<jsp:include page="footer.jsp"/>
</html>
