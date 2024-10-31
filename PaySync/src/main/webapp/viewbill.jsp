<!DOCTYPE html>

<html>
<head>
<title>Village Maintenance Payment Kiosk</title>
	<link rel="stylesheet" href="./css/new_style.css">
     <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>

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
                      breadcrumb = "<span class='breadcrumb'> You are here: MEMBER LIST > View Individual Bill </span>";
                  } else {
                      breadcrumb = "<span class='breadcrumb'> You are here: MY BILL</span>";
                  }
              }
              String title = "Member Bill "+breadcrumb;
          %> 		  
          <table>
             <tr width="25px">
               <td><img src="./image/sannera.jpg" alt="" width="25px" height="25px"><%=title%></td>   
             </tr>
          </table>    
       </div>    
       <!-- title -->
    
<jsp:include page="navigation.jsp"/>

<%@page import="com.midz.dao.SanneraBillDao,com.midz.bean.*,java.util.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
List<SanneraBill> billlist=SanneraBillDao.getAllRecordsUserId(Integer.parseInt(request.getParameter("userid")));
request.setAttribute("billlist",billlist);
%>
<div class="custom-center-container">
    <div class="responsive-table">
		<table border="0" width="90%"> 
		  <thead>
		    <tr>
		     <th>Bill Id</th> 
		     <th>User Name</th>
		     <th>Bill Date</th>
		     <th>Bill Amount</th>    
		     <th>Status</th>
		     <th>Paid Amount</th>
		     <th>Paid Extra Amount</th>
		     <%
			 if(vUserRole.equalsIgnoreCase("admin")){
			 %>
		     <th>Edit Bill</th>
		     <th>Delete Bill</th>
		     <% } else { %> 
			        <th colspan="2"></td>
			 <% } %> 
		    </tr>
		  </thead>
		  <tbody>  
		  <c:forEach items="${billlist}" var="u">
			  <tr>
			     <td>${u.getBillId()}</td>
			     <td>${u.getName()}</td>
			     <td>${u.getBillDate()}</td>
			     <td>${u.getAmount()}</td>
			     <td>${u.getPayOffsetDisplay()}</td>
			     <td>${u.getPayOffsetAmount()}</td>
			     <td>${u.getPayOffsetPendAmount()}</td>
			     <%
			     if(vUserRole.equalsIgnoreCase("admin")){
			     %> 
			        <c:choose>
					  <c:when test="${u.getPayOffsetDisplay() eq 'Paid'}">
					     <td colspan="2"><div class="custom-left"> Paid Bill cannot be Edit or Delete </div></td>
					  </c:when>
					  <c:otherwise>
					     <td><a href="editbill.jsp?billid=${u.getBillId()}">Edit Bill</a></td>
                         <td><a href="deletebill.jsp?billid=${u.getBillId()}">Delete Bill</a></td>
					  </c:otherwise>
					</c:choose>
			     <% } else { %> 
			        <td colspan="2"></td>
			     <% } %> 	
			  </tr>
		  </c:forEach>
		  <c:if test="${empty billlist}">
			  <tr>
			     <td align="center" colspan="9">No Records Found for <b><%=request.getParameter("name")%></b></td>
			     <% 
			     //if(vUserRole.equalsIgnoreCase("admin")){/
			     //	<td><a href="addbill.jsp?userid=<%=request.getParameter("userid")&name=<%=request.getParameter("name")">Add&nbsp;Bill</a></td>
			     //	<td>&nbsp;</td>
			     // } else { 
			     // <td colspan="2"></td>
			     // } 
			     %> 		
			  </tr>
		  </c:if>
		</tbody>
		</table>
   </div>
</div>
<%
if(vUserRole.equalsIgnoreCase("user")){
%> 
	<div class="custom-center">
		<form method="GET" action="paybill_billacceptor.jsp">
		  <input type="hidden" name="userid" value="<%=session.getAttribute("id")%>">
		  <input type="hidden" name="name" value="<%=session.getAttribute("name")%>">
		  <table>
		      <tr>
                  <td style="font-size: 10px">&nbsp;</td>
              </tr>    
		      <tr>
		          <td>
		              <div class="custom-center">
		                  <input type="submit" value=" Pay Bill " class="custom-button">
		              </div>
		          </td>
		      </tr>                                
		  </table>
		</form> 
	</div>
<%
}
%> 	
</body>
<jsp:include page="footer.jsp"/>
</html>