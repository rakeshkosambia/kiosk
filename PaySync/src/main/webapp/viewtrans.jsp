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
    
     <div class="title-table">
          <!-- title --> 
<jsp:include page="common.jsp"/> 
          <% 
              String breadcrumb = "";
              String vUserRole = "";
              if (session.getAttribute("role") != null){
        	      vUserRole = (String)session.getAttribute("role");
        	      if(vUserRole.equalsIgnoreCase("user")){
                      breadcrumb = "<span class='breadcrumb'> You are here: PAST PAYMENTS</span>";
                  }
              }
              String title = "My Payments "+breadcrumb;  
          %>           
          
          <table>
             <tr width="25px">
               <td><img src="./image/sannera.jpg" alt="" width="25px" height="25px"><%=title%></td>   
             </tr>
          </table>
          <!-- title -->
        </div>        
    
<jsp:include page="navigation.jsp"/>

<%@page import="com.midz.dao.SanneraPayDao,com.midz.bean.*,java.util.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
List<SanneraPay> list=SanneraPayDao.getAllRecordsUserId(Integer.parseInt(request.getParameter("userid")));
request.setAttribute("list",list);
%>
<div class="custom-center-container"> 
   <div class="responsive-table">
		<table border="0" width="90%">
		<thead> 
		  <tr>
		     <th>Pay Id</th> 
		     <th>Name</th>
		     <th>Paid Date</th>
		     <th>Paid Amount</th>
		     <th>Status</th>
		     <th>Bill Amount Paid</th>
		     <th>Extra Amount Paid </th>
		  </tr>
		 </thead>  
		 <tbody>
		<c:forEach items="${list}" var="u">
		  <tr> 
		     <td>${u.getPayId()}</td>
		     <td>${u.getName()}</td>
		     <td>${u.getPaidDate()}</td>
		     <td>${u.getPaidAmount()}</td>
		     <td>${u.getOffsetDisplay()}</td>
		     <td>${u.getOffsetAmount()}</td>
		     <td>${u.getOffsetPendAmount()}</td>
		  </tr>
		</c:forEach>
		</tbody>
		   <c:if test="${empty list}">
			  <tr>
			     <td align="center" colspan="7">No Records Found for <b><%=request.getParameter("name")%></b></td>
			  </tr>
		   </c:if>
		</table>
   </div>
</div>   
</body>
<jsp:include page="footer.jsp"/>
</html>