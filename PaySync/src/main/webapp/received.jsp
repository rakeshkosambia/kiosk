<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <meta charset="UTF-8">
    <title> Village Maintenance Payment Kiosk </title>
     <link rel="stylesheet" href="./css/new_style.css">
     <meta name="viewport" content="width=device-width, initial-scale=1.0">
     <script src="./js/xlsx.full.min.js"> </script>
   </head>
<body>

<div class="container">   
   <div classs="content">
   
          <div class="title-table">           
<jsp:include page="common.jsp"/> 
          <% 
              String breadcrumb = "";
              String vUserRole = "";
              if (session.getAttribute("role") != null){
        	      vUserRole = (String)session.getAttribute("role");
        	      if(vUserRole.equalsIgnoreCase("admin")){
                      breadcrumb = "<span class='breadcrumb'> You are here: REPORT </span>";
                  } else {
                      breadcrumb = "";
                  }
              }
              String title = "Received Amount Report "+breadcrumb;
          %>               
	          <table>
	             <tr width="25px">
	               <td><img src="./image/sannera.jpg" alt="" width="25px" height="25px"><%=title%></td>   
	             </tr>
	          </table>    
         </div> 
        
            <jsp:include page="navigation.jsp"/>

<%@page import="com.midz.dao.SanneraPayDao,com.midz.bean.*,java.util.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
List<SanneraPay> paylist=SanneraPayDao.getAllRecordsPayment();
request.setAttribute("paylist",paylist);
%>
<div class="content">
	<form action="#"> 
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

	      <table id="received-amount-table">
	         <thead> 
	          <tr>
			    <th>List of Members</th>
			    <th>Address</th>
			    <th>Period</th>
			    <th>Amount Received</th>
			    <th>Status</th>
	          </tr>
	        </thead>      
	        <tbody>
	        <c:forEach items="${paylist}" var="u">
	          <tr>
			    <td>${u.getName()}</td>
			    <td>${u.getAddress()}</td>
			    <td>${u.getPaidMonthYear()}</td>
			    <td>${u.getPaidAmount()}</td>
			    <td>${u.getOffsetDisplay()}</td>
	          </tr>
	        </c:forEach>  
	        </tbody>
	      </table>
	    </div>     
      </div>   
	</form>		
</div>	
    <div class="custom-center">
      <form action="viewbillAll.jsp"> 
        <input type="hidden" name="report" value="report"> 
        <table border=0>
           <tr>
                <td colspan="3" style="font-size=5px">&nbsp;</td>
           </tr>
           <tr>
                <td>
                    <div class="custom-center">
                       <input type="button" style="width: 330px;" value=" Download Received Amount " onclick="exportToExcel()" class="custom-button">
                    </div>
                </td>
                <td style="font-size=10px">&nbsp;</td>
                <td>
                    <div class="custom-center">
                       <input type="submit" style="width: 200px;" value=" Pending Amount " class="custom-button">
                    </div>
                </td>            
           </tr> 
        </table>
       </form> 
    </div>   
    
<script>
  var total = 0; // Declare total variable outside functions

  function calculateTotal() {
    var table = document.getElementById('received-amount-table');
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
    totalValueElement.innerHTML = 'Total Received Amount : ' + total;
  }

  window.onload = calculateTotal;

  function exportToExcel() {
    var wb = XLSX.utils.book_new();
    var table = document.getElementById('received-amount-table');
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

    XLSX.writeFile(wb, 'received-amount.xlsx');
  }
</script>

</body>
</html>