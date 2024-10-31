    <script>
        function submitFormPayBill(param1, param2) {
          var form = document.createElement('form');
          form.method = 'post';
          form.action = 'paybill_billacceptor.jsp';
          form.style.display = 'none';
        
          var param1Field = document.createElement('input');
          param1Field.type = 'hidden';
          param1Field.name = 'userid';
          param1Field.value = param1;
        
          var param2Field = document.createElement('input');
          param2Field.type = 'hidden';
          param2Field.name = 'name';
          param2Field.value = param2;
        
          form.appendChild(param1Field);
          form.appendChild(param2Field);
        
          document.body.appendChild(form);
          form.submit();
        }
    </script>

<jsp:include page="common.jsp"/>
    
<%
try {
		String vUserRole = (String)session.getAttribute("role");
	    request.setAttribute("userid", session.getAttribute("id"));
	    request.setAttribute("name", session.getAttribute("name")); 
	    
	    String roleStr = "";
	    String linkLogInOut = "";
	    String screenName = "";
	    screenName = (session.getAttribute("name") != null) ? session.getAttribute("name").toString() : "";
	    if( vUserRole.equalsIgnoreCase("user") ){    
		    roleStr = "&nbsp;&nbsp;";
		    linkLogInOut = "Log Out";
		} else if (vUserRole.equalsIgnoreCase("no-login")) {
		    roleStr = "&nbsp;<span class=\"bluebkg-whitetext\">(no-login)</span>&nbsp;";
		    linkLogInOut = "Log In";
	    } else if(vUserRole.equalsIgnoreCase("admin")) {
		    roleStr = "&nbsp;<span class=\"bluebkg-whitetext\">(admin)</span>&nbsp;";
		    linkLogInOut = "Log Out";
	    }	
%>	    
                              
                <!-- Starts here profile-table -->
                    <div class="profile-table">
                      <table>
                         <tr>
                           <td><%=screenName%><%=roleStr%></td>
                           <td style="width: 45px;"><a href="login.jsp"><%=linkLogInOut%></a> </td>
                         </tr>
                         <tr>
                           <td colspan="2" style="font-size: 3px;">&nbsp:</td>
                         </tr>
                      </table>
                    </div>
                <!-- Ends here profile-table -->	    
               
<%	            
		if(vUserRole.equalsIgnoreCase("user")){		
%>			
					<nav class="user-menu">
					  <div class="user-menu">
					    <a href="homeowner.jsp" class="active">My Profile</a>
					    <a href="viewbill.jsp?userid=<%=session.getAttribute("id")%>&name=<%=session.getAttribute("name")%>">My Bill</a>
					    <!--
					    <a href="#" onclick="submitFormPayBill('<%//=session.getAttribute("id")%>', '<%//=session.getAttribute("name")%>')" class="active">Pay Bill</a>
					    -->
					    <a href="viewtrans.jsp?userid=<%=session.getAttribute("id")%>&name=<%=session.getAttribute("name")%>" class="active">Past Payments</a>
					    <div class="animation start-home"></div>
					    <div class="start-monthlybill"></div>
					    <div class="start-paybill"></div>
					    <div class="start-paymenthistory"></div>
					  </div>  
					</nav>
					<div style="font-size: 5px;">&nbsp;</div>
<%
     	} else if(vUserRole.equalsIgnoreCase("admin")) {
%>		     
				      <nav class="admin-menu">
				         <div class="admin-menu">
					        <a href="viewusers.jsp">Member List</a>
					        <a href="register.jsp">New Members</a>
					        <a href="inputbill.jsp">Generate Bill</a>
					        <a href="received.jsp">Report</a>
					        <div class="animation admin-members"></div>
                            <div class="admin-register"></div>
                            <div class="admin-bill"></div>
                            <div class="admin-amount"></div>
					     </div>   
				      </nav> 
				      <div style="font-size: 5px;">&nbsp;</div>
<%
     	} else if(vUserRole.equalsIgnoreCase("no-login")) {
            request.setAttribute("loginmessage", "Unknown username/password. Please retry.");
        	//request.getRequestDispatcher("index.jsp").forward(request, response);	
        	response.sendRedirect("login.jsp");
	 	}
	}
	catch (Exception ex) {
	    request.setAttribute("loginmessage", "Unknown username/password. Please retry.");
        //request.getRequestDispatcher("index.jsp").forward(request, response);	
        response.sendRedirect("login.jsp");
	}
%>	 
