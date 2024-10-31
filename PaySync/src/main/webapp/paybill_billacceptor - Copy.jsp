<!DOCTYPE html>
<html lang="en" dir="ltr">
<%@page import="com.midz.util.*,com.midz.dao.SanneraPayDao,com.midz.bean.SanneraPay"%>
<%
String message = "";
String billTotal = "0";
String billRefresh = "0";
String action = "";
String sessionRefreshMessage = "";
String sessionTotalMessage = "";
String sessionMessage = "";

    // either by session or query string 
    if ( (com.midz.util.ConstantParameters.readQueryStringOrSession.toString()).equalsIgnoreCase("SESSION") ){
	    if (session.getAttribute("message") != null){
	           message = session.getAttribute("message").toString();
	    } 
		if (session.getAttribute("billRefresh") != null){
           billRefresh = session.getAttribute("billRefresh").toString();
           sessionRefreshMessage = com.midz.util.ConstantParameters.success+" "+billRefresh;
           sessionMessage = sessionRefreshMessage;
		}     
        if (session.getAttribute("billTotal") != null){
            billTotal = session.getAttribute("billTotal").toString();
            sessionTotalMessage = com.midz.util.ConstantParameters.total_bill+" "+billTotal;
            sessionMessage = sessionMessage + sessionTotalMessage;
         }		
		Logging.log("jsp1.session =>message->"+message+":sessionTotalMessage->"+sessionTotalMessage+":sessionRefreshMessage->"+sessionRefreshMessage);
    } else {
	    if (request.getParameter("billTotal")!=null){
	        billTotal = (String)request.getParameter("billTotal");
	    } 
	    if (request.getParameter("message")!=null){
		    message = (String)request.getParameter("message");
	    }
	    Logging.log("jsp1.querystring =>message->"+message+":billTotal->"+billTotal);
    }
    //---------------------- COMMON -------------------------
    if (request.getParameter("action")!=null){
        action = (String)request.getParameter("action");
    } 
  //---------------------------------------------------------
    if (message!=null){
       switch (message) {
           case "start_1":
               message = com.midz.util.ConstantParameters.start_1;
               break;
           case "start_2":
               message = com.midz.util.ConstantParameters.start_2;
               break;
           case "start_3":
               message = com.midz.util.ConstantParameters.start_3;
               if (sessionMessage!=null){
        	      message = sessionMessage;
               }
               break;
           case "start_4":
               message = com.midz.util.ConstantParameters.start_4;
               break;
           case "stop_1":
               message = com.midz.util.ConstantParameters.stop_1;
               break;
           case "fail":
               message = com.midz.util.ConstantParameters.fail;
               break;  
           default:
               //success_
               if (message.startsWith("success")) {
        		   billRefresh = message.replaceAll("[^0-9]", "");
                   message = com.midz.util.ConstantParameters.success+" "+billRefresh;
               }
               break;
       } // switch
       Logging.log("3.message =>message->"+message);
    } // message request/session parameter  
%>       
 <head>
    <meta charset="UTF-8">
    <title> Village Maintenance Payment Kiosk </title>
    <link rel="stylesheet" href="./css/new_style.css">
     <meta name="viewport" content="width=device-width, initial-scale=1.0">
     <!------------------------------------------------->
        <script src="./js/jquery-3.6.4.min.js"></script>
        <script>
            var intervalID = null;
           
            function displaySessionVariableValue() {
                //var sessionVariable = "${sessionVariable}"; 
                //document.getElementById("sessionVariableValue").textContent = sessionVariable;  
                
                //**************** TIME ****************
                var now = new Date();
				var year = now.getFullYear();
				var month = now.getMonth() + 1; // Month is zero-based, so add 1
				var day = now.getDate();
				var hours = now.getHours();
				var minutes = now.getMinutes();
				var seconds = now.getSeconds();
				var formattedDateTime = year + '-' + month + '-' + day + ' ' + hours + ':' + minutes + ':' + seconds;
                //**************** TIME ****************
                console.log("=== loadButtonEvent from window.onload === ");
                console.log(" formattedDateTime --> "+formattedDateTime);
                loadButtonEvent(); 
            }
            // Call the function when the page loads
            window.onload = function() {
                displaySessionVariableValue();
            };
            function refreshPage() {
                location.reload();
            }
            $(document).ready(function() {
                setInterval(refreshPage, 5000);
            });
                    
            function startAction(event) {
                event.preventDefault(); // Prevent the default form submission behavior
                var actionValue = 'start';     
                $("#action").val(actionValue);
                var userid = $("#userid").val();
                var name = $("#name").val();
                var action = $("#action").val();
                var timestamp = new Date().getTime();
                console.log("userid = " + userid + ", name = " + name + ", action = " + action);
                   $.get("BillAcceptorServlet", {
                         userid: userid,
                         name: name,
                         action: action,
                         timestamp: timestamp
                   }, 
                       function(data) {
                          $("#billTotal").html(data);
                       }); 
                document.getElementById("actionstart").style.display = "none";
                document.getElementById("actionstop").style.display = "block";
                document.getElementById("paybill").style.display = "none";
                $("#servletform").submit();
            }
            
            function stopAction(event) {
                 event.preventDefault(); // Prevent the default form submission behavior
                 clearInterval(intervalID);
                 // startValidate here
                 var paidamount = parseFloat($("#paidamount").val());
                 var minamount = parseFloat($("#minamount").val());
                 
                 if (paidamount < minamount) {
                     var errorMsg = "Amount to pay must be at least " + minamount;
                     $("#message").text(errorMsg);           
                 } else {
                     $("#message").text("");

	                 var actionValue = 'stop';       
	                 $("#action").val(actionValue);
	                 var userid = $("#userid").val();
	                 var name = $("#name").val();
	                 var action = $("#action").val();
	                 var timestamp = new Date().getTime();
	                 var payOffsetPendId = $("#payOffsetPendId").val();
	                 
	                    $.get("BillAcceptorServlet", {
	                          userid: userid,
	                          name: name,
	                          action: action,
	                          timestamp: timestamp,
	                          paidamount: paidamount,
	                          payOffsetPendId: payOffsetPendId
	                    }, 
	                        function(data) {
	                           $("#billTotal").html(data);
	                        });
	                    
	                 document.getElementById("actionstart").style.display = "none";
	                 document.getElementById("actionstop").style.display = "block";
	                 document.getElementById("paybill").style.display = "none";                           
	                 $("#servletform").submit();
                 }
            }       
            
            function startValidate(event) {
                event.preventDefault(); // Prevent the default form submission behavior
                var paidamount = parseFloat($("#paidamount").val());
                var minamount = parseFloat($("#minamount").val());
                if (paidamount < minamount) {
                     var errorMsg = "Amount to pay must be at least " + minamount;
                     $("#message").text(errorMsg);           
                } else {
                    $("#message").text("");
                    //$("#validateform").submit();
                    var dbform = document.getElementById("validateform");
                    dbform.action = "paybillsubmit.jsp";
                    dbform.method = "POST";
                    dbform.submit();
                }
            }

            function loadButtonEvent(){ 
            	//console.log("jsp5.loadbuttonevent()");
                event.preventDefault();
                var messageShow = "<%=message%>";
                sessionStorage.setItem("messageShow", messageShow);
                var storedMessageValue = sessionStorage.getItem("messageShow");         
                if (storedMessageValue !== null && storedMessageValue !== undefined) {
                    var messageDiv = document.getElementById("message");
                    messageDiv.innerHTML = storedMessageValue;
                    //console.log("jsp6.messageDiv.innerHTML->"+storedMessageValue.toString());
                }                
            <%  
                if (request.getParameter("action")!=null){
                    String actionjs = (String)request.getParameter("action");
                    if (actionjs.equals("start")) {
                          if(request.getParameter("message")!=null 
                                 && (request.getParameter("message").toString().equals("start_1") 
                                     || request.getParameter("message").toString().equals("start_4"))) {
            %>
                              // actionstart:block, actionstop:none, paybill:none =>  show again actionstart
                              document.getElementById("actionstart").style.display = "block";
                              //document.getElementById('actionstop').parentNode.remove();
                              document.getElementById("actionstop").style.display = "none";
                              document.getElementById("paybill").style.display = "none";    
                              
                              //var buttonDiv = document.querySelector('.button');
                              //var messageDiv = document.querySelector('.message-err');
                              //var parentDiv = buttonDiv.parentNode;
                              //parentDiv.insertBefore(messageDiv, buttonDiv);
            <% 
                          } else if(request.getParameter("message")!=null 
                                      && (request.getParameter("message").toString().equals("start_2") 
                                          || request.getParameter("message").toString().equals("start_3"))) {
            %>
                              document.getElementById("actionstart").style.display = "none";
                              document.getElementById("actionstop").style.display = "block";
                              document.getElementById("paybill").style.display = "none";         
            <%
                          }
                    } else if (actionjs.equals("stop")) {
            %>
                       // removed both actionstart & actionstop by parentNode.remove() instead of making both display = none
                       document.getElementById("actionstop").parentNode.remove();
                       document.getElementById("paybill").style.display = "block";
            <%
                    }
                } else { // action is null
            %>
                    document.getElementById("actionstart").style.display = "block";
                    document.getElementById("actionstop").style.display = "none";
                    document.getElementById("paybill").style.display = "none";
            <%
                 }  
            %>
            } // loadButtonEvent
            
            // Bind the startValidate() function to the form's submit event
            $("#validateform").submit(startValidate);
            $("#servletform").submit(startAction);
            $("#servletform").submit(stopAction);
            
            // On load event
            document.addEventListener("DOMContentLoaded", function() {
                //console.log("jsp4.domcontentloaded");
                //document.forms[0].addEventListener("load", loadButtonEvent);
                var newDiv = document.createElement("div");
                newDiv.style.display = "none";
                document.body.appendChild(newDiv);
                loadButtonEvent();
            });
        </script>   
      <!------------------------------------------------->  
   </head>
 <body>
    <div class="container">
      <div class="content">
         <div class="title-table">
            <table>
                <tr>
                    <td>Pay Bill</td>          
                </tr>
            </table>
         </div>
         <jsp:include page="navigation.jsp"/>            
<%
request.setAttribute("userid", session.getAttribute("id"));
request.setAttribute("name", session.getAttribute("name")); 
int userid = Integer.parseInt(session.getAttribute("id").toString());
String name = session.getAttribute("name").toString();
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
     <div class="user-details">  
        <form id="servletform" action="${pageContext.request.contextPath}/BillAcceptorServlet"  method="GET">
            <input type="hidden" id="userid" name="userid" value="<%=userid%>">
            <input type="hidden" id="name" name="name" value="<%=name%>">
            <input type="hidden" id="billTotal" name="billTotal" value="<%=billTotal%>">
            <input type="hidden" id="action" name="action" value="">
            <div class="message-err" id="message">$(#message)</div>        
            <div class="user-details">
                <div class="button">
                    <input type="submit" id="actionstart" value=" Click to Pay in KIOSK " name="actionstart" onclick="startAction(event)"> 
                    <input type="submit" id="actionstop" value=" Click to Submit Payment of ( <%=billTotal%> ) inserted in KIOSK" name="actionstop"  onclick="stopAction(event)">
                </div>
            </div>
        </form>
     </div>  
     <!-- Form to start bill acceptor to accept -->
     <form id="validateform" action="" method="POST"> 
       <div class="input-box">
           <span>Name: <%=name%></span>
       </div>          
       <input type="hidden" id="paidamount" name="paidamount" value="<%=billTotal%>">
       <input type="hidden" id="minamount" name="minamount" value="<%=min_amount_to_pay%>">   
       <div class="input-box">
          <span class="redbkg-whitetext">Total Money Paid in KIOSK : <%=billTotal%></span>
       </div>
       <h6><font color="red"><div id="errShow"></div></font></h6>     
       <input type="hidden" name="userid" value="<%=userid%>">       
       <input type="hidden" name="payOffsetPendId" value="<%=paypendingId%>">
         <% if (offset_pending_amount != 0) { %>
                <h5>&nbsp;
                    <div class="input-box">
                        <font color="blue">Extra Paid Amount Previously: <%=offset_pending_amount%></font>
                    </div>   
                </h5>
         <% } %> 
         <h5><font color="blue">**Please pay minimum amount of <%=min_amount_to_pay%> to pay the bill**</font></h5>  
         <div class="user-details">
             <div class="button">
                <input type="submit" id="paybill" value="   Pay Bill   " onclick="startValidate(event)">
                <div class="message-err" id="errShow"></div>
             </div>        
         </div>     
      </form>
</body>
</html>