<!DOCTYPE html>

<html>
<head>
<title>Village Maintenance Payment Kiosk</title>
	<link rel="stylesheet" href="./css/new_style.css">
     <meta name="viewport" content="width=device-width, initial-scale=1.0">
     <script src="./js/xlsx.full.min.js"> </script>
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
                      breadcrumb = "<span class='breadcrumb'> You are here: REPORT > PENDING AMOUNT </span>";
                  } else {
                      breadcrumb = "";
                  }
              }
              String title = "Members Pending Amount Report "+breadcrumb; 
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
List<SanneraBill> billlist=SanneraBillDao.getAllRecordsAllUsers();
request.setAttribute("billlist",billlist);
String report = "";
if (request.getParameter("report")!=null){
    report = request.getParameter("report").toString();
}
%>
<div class="custom-center-container">
    <div class="responsive-table">
    
             <table width="10px" border="1">
                  <thead> 
                     <tr width="20px">
                        <th colspan="2" class="msgRedBkgWhiteFont2Colspan" style="background: green; text-align: left;" >
                            <div id="total-value" ></div>
                        </th>
                     </tr>
                  </thead>    
             </table>  
    
		<table border="0" width="90%" id="pending-amount-table"> 
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
			         if(report.equalsIgnoreCase("report")){
		     %>
		             <th colspan="3"></td>
		     <%
			         } else {
			 %>
				     <th>Add Bill</th> 
				     <th>Edit Bill</th>
				     <th>Delete Bill</th>
		     <%      }
		        } else { %> 
			        <th colspan="3"></td>
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
				      if(report.equalsIgnoreCase("report")){
			     %>
			             <td colspan="3"> </td>       		     
				 <%	  
				      } else {
			     %> 	 
				     	<td><a href="addbill.jsp?userid=${u.getUserId()}&name=${u.getName()}">Add Bill</a></td> 
				     	<td><a href="editbill.jsp?billid=${u.getBillId()}">Edit Bill</a></td>
				     	<td><a href="deletebill.jsp?billid=${u.getBillId()}">Delete Bill</a></td>
			     <%   }
			     } else { %> 
			        <td colspan="3"></td>
			     <% } %> 	
			  </tr>
		  </c:forEach>
		  <c:if test="${empty billlist}">
			  <tr>
			     <td align="center" colspan="4">No Records Found for <b><%=request.getParameter("name")%></b></td>
			     <%
			     if(vUserRole.equalsIgnoreCase("admin")){
			     %> 
			     	<td><a href="addbill.jsp?userid=<%=request.getParameter("userid")%>&name=<%=request.getParameter("name")%>">Add&nbsp;Bill</a></td>
			     	<td>&nbsp;</td>
			     	<td>&nbsp;</td>
			     <% } else { %> 
			        <td colspan="3"></td>
			     <% } %> 		
			  </tr>
		  </c:if>
		</tbody>
		</table>
   </div>
</div>

    <div class="custom-center">
        <form>
          <table>
              <tr>
                  <td style="font-size: 10px">&nbsp;</td>
              </tr>    
              <tr>
                  <td>
                    <div class="custom-center">
                        <input type="submit" style="width: 330px;" value=" Download Pending Amount " onclick="exportToExcel()" class="custom-button">
                    </div>
                  </td>
              </tr>                                
          </table>
        </form> 
    </div>
 
<script>
  var total = 0; // Declare total variable outside functions

  function calculateTotal() {
    var table = document.getElementById('pending-amount-table');
    var data = [];
    var rows = table.getElementsByTagName('tr');
    for (var i = 0; i < rows.length; i++) {
      var row = rows[i];
      var rowData = [];
      var cells = row.getElementsByTagName('td');
      for (var j = 0; j < cells.length; j++) {
        var cell = cells[j];
        rowData.push(cell.innerText);
      }
      if (rowData.length > 0) {
        data.push(rowData);
      }
    }

    // Calculate total
    total = 0; // Assign value to the existing variable
    for (var i = 0; i < data.length; i++) {
      total += parseInt(data[i][3], 10); // Assuming the total is in column 4 (index 3)
    }

    var totalValueElement = document.getElementById('total-value');
    totalValueElement.innerHTML = 'Total Pending Amount : ' + total;
  }

  window.onload = calculateTotal;

  function exportToExcel() {
    var wb = XLSX.utils.book_new();
    var table = document.getElementById('pending-amount-table');
    var data = [];
    var headers = [];
    var rows = table.getElementsByTagName('tr');
    for (var i = 0; i < rows.length; i++) {
      var row = rows[i];
      var rowData = [];
      var cells = row.getElementsByTagName('th'); // Capture <th> elements as well
      for (var j = 0; j < cells.length; j++) {
        var cell = cells[j];
        if (i === 0) {
          headers.push(cell.innerText);
        } else {
          rowData.push(cell.innerText);
        }
      }
      cells = row.getElementsByTagName('td'); // Capture <td> elements
      for (var j = 0; j < cells.length; j++) {
        var cell = cells[j];
        rowData.push(cell.innerText);
      }
      if (rowData.length > 0) {
        data.push(rowData);
      }
    }
    var ws = XLSX.utils.aoa_to_sheet([headers, ...data]);
    XLSX.utils.book_append_sheet(wb, ws, 'Sheet1');

    XLSX.utils.sheet_add_aoa(ws, [['Total', '', '', total]], { origin: -1 });

    XLSX.writeFile(wb, 'pending-amount.xlsx');
  }
</script>   
   
   
</body>
</html>