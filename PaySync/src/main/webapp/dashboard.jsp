<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Dashboard</title>
<link rel="stylesheet" href="./css/new_style.css">
    <script src="./js/jquery-3.6.4.min.js"></script>
</head>
<body>

    <div class="container">
	      <div class="title-table">
	          <!-- title -->
	          <% String title = "For Sannera Homeowners only"; %>
	          <table>
	             <tr width="25px">
	               <td><img src="./image/sannera.jpg" alt="" width="25px" height="25px"><%=title%></td>   
	             </tr>
	          </table>
	          <!-- title -->
	      </div>  

<jsp:include page="common.jsp"/>
	      
<jsp:include page="navigation.jsp"/>
	      
 <%
 if ((com.midz.util.ConstantParameters.PRINT_SILENT_NORMAL.equalsIgnoreCase("SILENT")) && request.getParameter("pay_id")!=null) {
     String receipt = "";
     String pay_id = "";
     String dash_userid = "";
     String dash_name = "";
     if(request.getParameter("pay_id")!=null){
	     pay_id = request.getParameter("pay_id");
     }
     dash_userid = session.getAttribute("id").toString();
     dash_name = session.getAttribute("name").toString(); 
     
     if (request.getParameter("pay_id")!=null) {
 %> 
 <script src="./js/jquery-3.6.4.min.js"></script>
 <script>
    /*
    function printReceipt() {
    	  var printWindow = window.open('silent_print_receipt.jsp?pay_id=<%=pay_id%>&dash_userid=<%=dash_userid%>&dash_name=<%=dash_name%>', 'blank');

    	  printWindow.onload = function() {
    	    if (!printWindow.printTriggered) {
    	      printWindow.print();
    	      printWindow.printTriggered = true;

    	      // Close the window after a short delay (e.g., 1 second)
    	      setTimeout(function() {
    	        printWindow.close();
    	      }, 1000);
    	    }
    	  };
    	}
    */
    $(document).ready(function() {
    	  $('#printButton').on('click', function() {
    	    printReceipt();
    	  });

    	  function printReceipt() {
    		  //silent_print_receipt.jsp
    	    var printWindow = window.open('silent_pay_acknow.jsp?pay_id=<%=pay_id%>&dash_userid=<%=dash_userid%>&dash_name=<%=dash_name%>', 'blank');

    	    printWindow.onload = function() {
    	      if (!printWindow.printTriggered) {
    	        printWindow.print();
    	        printWindow.printTriggered = true;

    	        setTimeout(function() {
    	          printWindow.close();
    	        }, 1000);
    	      }
    	    };
    	  }
    	});

 </script>
    
     <div class="custom-center">
       <table style="width: 50%;" border="0">
          <tr>
            <td style="text-align: center;" width="50%">
                <div class="message">  <%=request.getParameter("msg")%> </div>
                <div class="custom-center">
                    <!--  <input type="button" id="printButton" value=" Print " onclick="printReceipt()" class="custom-button">  -->
                    <input type="button" id="printButton" value=" Print Receipt " class="custom-button"> 
                </div>  
            </td>
            <td style="text-align: left;" width="20%">
                <div class="custom-left">
                  <% // <jsp:include page="silent_pay_acknow.jsp?pay_id=<%=pay_id%&dash_userid=<%=dash_userid%&dash_name=<%=dash_name%" /> %>
                  <jsp:include page="thankkiosk.jsp"/>
                </div>
            </td>
          </tr>
      </table> 
    </div>  
 <%
     }
 } else {
%>
      <table style="width: 100%;">
          <tr>
            <td style="text-align: center;">
                <div class="message">
                   <%=request.getParameter("msg")%>
                </div>
            </td>
          </tr>
      </table> 
<%
 }
 %>
  </div> 
</body>   
<jsp:include page="footer.jsp"/>
</html>