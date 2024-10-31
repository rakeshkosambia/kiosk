<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <meta charset="UTF-8">
    <title> Village Maintenance Payment Kiosk </title>
    <link rel="stylesheet" href="./css/new_style.css">
     <meta name="viewport" content="width=device-width, initial-scale=1.0">
     <!------------------------------------------------->
     	<script src="./js/jquery-3.6.4.min.js"></script>
     	
		<!--  
		<script>
			        $(document).ready(function() {
			    	  setInterval(function() {
			    	    var userid = $("#userid").val();
			    	    var name = $("#name").val();
			    	    var action = $("#action").val();
			    	    var timestamp = new Date().getTime();
			    	    console.log("userid = " + userid + ", name = " + name + ", action = " + action);
			    	    $.get("SerialDataServlet", {
			    	      userid: userid,
			    	      name: name,
			    	      action: action,
			    	      timestamp: timestamp
			    	    }, function(data) {
			    	      $("#billdata").html(data);
			    	    });
			    	  }, 10000);
			    	});
		</script>
		-->
		
		<script>
		    var intervalID = null;
		    function startAction() {
		        // Clear the interval if it's already running
		        clearInterval(intervalID);
		        // Set the value of the action input field to "start"
		        $("#servletform input[name='action']").val("start");
		        
		        // Submit the form
		        $("#servletform").submit();
		        
		        // Start the interval
		        intervalID = setInterval(function() {
		            var userid = $("#userid").val();
		            var name = $("#name").val();
		            var action = $("#action").val();
		            var timestamp = new Date().getTime();
		            console.log("userid = " + userid + ", name = " + name + ", action = " + action);
		            $.get("SerialDataServlet", {
		                userid: userid,
		                name: name,
		                action: action,
		                timestamp: timestamp
		            }, function(data) {
		                $("#billdata").html(data);
		            });
		        }, 10000);
		    }
		
		    function stopAction() {
		        // Clear the interval
		        clearInterval(intervalID);
		        
		        // Set the value of the action input field to "stop"
		        $("#servletform input[name='action']").val("stop");
		        
		        // Submit the form
		        var timestamp = new Date().getTime();
		        $.get("SerialDataServlet", {
		            userid: $("#userid").val(),
		            name: $("#name").val(),
		            action: "stop",
		            timestamp: timestamp
		        }, function(data) {
		            $("#billdata").html(data);
		        });
		        
		        // Submit the form
		        $("#servletform").submit();
		    }
		    
		    $(document).ready(function() {
		        setInterval(function() {
		            var userid = $("#userid").val();
		            var name = $("#name").val();
		            var action = $("#action").val();
		            var timestamp = new Date().getTime();
		            console.log("userid = " + userid + ", name = " + name + ", action = " + action);
		            $.get("SerialDataServlet", {
		                userid: userid,
		                name: name,
		                action: action,
		                timestamp: timestamp
		            }, function(data) {
		                $("#billdata").html(data);
		            });
		        }, 10000);
		    });
		</script>	
	  <!------------------------------------------------->	
   </head>
 <body>
    <div class="container">
      <div class="content">    
        <div class="title">Pay Bill</div>
           <!--  <c:set var="instance" value="${your.value}" scope="request"/>  -->      
           
           <jsp:include page="navigation.jsp"/>

<%@page import="com.midz.util.ConstantParameters,com.midz.dao.SanneraPayDao,com.midz.bean.SanneraPay"%>
<%
request.setAttribute("userid", session.getAttribute("id"));
request.setAttribute("name", session.getAttribute("name"));	

//int userid=Integer.parseInt(request.getParameter("userid"));
int userid = Integer.parseInt(session.getAttribute("id").toString());
String name = session.getAttribute("name").toString();
String billdata = "";
String action = "";

    if (request.getParameter("billdata")!=null){
   		billdata = (String)request.getParameter("billdata");
    } 
    if (request.getParameter("action")!=null){
    	action = (String)request.getParameter("action");
    } 

//out.print(" paybill session.getAttribute(id).toString():"+session.getAttribute("id").toString());
//out.print(" paybill int userid:"+userid);
//out.print(" paybill String name :"+name);

float offset_pending_amount = 0;
float min_amount_to_pay = 0;
int paypendingId = 0; 
SanneraPay u = SanneraPayDao.getRecordById(userid);

if (u != null){
	offset_pending_amount=u.getOffsetPendAmount();
	paypendingId = u.getPayOffsetPendId();
}

min_amount_to_pay = ConstantParameters.MINPAYMENT - offset_pending_amount;
%>        
	 <!-- Form to start bill acceptor to accept -->
	 <!--------------------------------------------------->
   	    <%
   	        
   	    %>		  
   	    <!--   <div id="billdata"> <%//=billdata%></div>   -->
		<form id="servletform" action="${pageContext.request.contextPath}/SerialDataServlet" method="GET">
		    <div class="user-details">
		        <div class="button">
		            <input type="hidden" id="userid" name="userid" value="<%=userid%>">
		            <input type="hidden" id="name" name="name" value="<%=name%>">
		            <input type="hidden" id="billdata" name="billdata" value="<%=billdata%>">
		            <button type="button" id="start-button" value="start" name="action" onclick="startAction()">&nbsp;&nbsp;Click to Insert Money to Pay&nbsp;&nbsp;</button>
		            <button type="button" id="stop-button" value="stop" name="action"  onclick="stopAction()">&nbsp;&nbsp;Submit Payment&nbsp;&nbsp;</button>
		        </div>
		    </div>
		</form>		


		
		
     <!--------------------------------------------------->
     <div id="action">${action}</div>
     <div id="billdata">${billdata}</div>
	 <form action="paybillsubmit.jsp">
	   <p>&nbsp;</p>     
	      
		      <div class="input-box">
	            <span class="details">Name:</span>
	            <span class="text" type="text"><h4><%=name%></h4></span>
	          </div> 

	      <% if (offset_pending_amount != 0) { %>
	      <div class="user-details">
		      <div class="input-box">
	            <span class="details">Extra Paid Amount Previously</span>
	            <span class="text" type="text"><h4><%=offset_pending_amount%></h4></span>
	          </div> 
	      </div>  
	      <% } %>   
       <div class="user-details">
          <div class="input-box">
            <span class="details">Pay Amount</span>
            <span class="details" type="text" id="newbilldata" name="newbilldata"><%=billdata%></span>
            <input type="number" id="paidamount" name="paidamount" value="<%=billdata%>" min="<%=min_amount_to_pay%>" placeholder="" required>
          </div>
       </div>
       <div id="output">${arduinoData}</div>  
       <input type="hidden" name="userid" value="<%=userid%>">       
       <div class="user-details">
          <div class="button">
            <input type="submit" value=" Pay Bill ">
          </div>
       </div>
       <h5>*Please pay minimum amount of <%=min_amount_to_pay%>*</h5>  
       <input type="hidden" name="payOffsetPendId" value="<%=paypendingId%>">
      </form>
</body>
</html>