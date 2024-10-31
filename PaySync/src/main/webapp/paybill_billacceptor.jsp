<!DOCTYPE html>
<html lang="en" dir="ltr">
<%@page import="com.midz.util.ConstantParameters,com.midz.util.Logging,com.midz.dao.SanneraPayDao,com.midz.bean.SanneraPay"%>
<%
String techmessage = "";
String billTotal = "0";
String billRefresh = "0";
String action = "";
String sessionMessage = "";
String isDBSubmit = "";
String paidamount = "";
String payOffsetPendId = "";   
String resourceURL = "";
String initialTechMessage = "";

    // either by session or query string 
    if ( (com.midz.util.ConstantParameters.readQueryStringOrSession.toString()).equalsIgnoreCase("SESSION") ){
        if (session.getAttribute("techmessage") != null){
               techmessage = session.getAttribute("techmessage").toString();
               initialTechMessage = techmessage;
        } 
        if (session.getAttribute("billRefresh") != null){
           billRefresh = session.getAttribute("billRefresh").toString();
           //sessionMessage = com.midz.util.ConstantParameters.success+" "+billRefresh;
        }  
        if (session.getAttribute("billTotal") != null){
            billTotal = session.getAttribute("billTotal").toString();
            //sessionMessage = sessionMessage + com.midz.util.ConstantParameters.total_bill+" "+billTotal;
         }
    } else {
        if (request.getParameter("billTotal")!=null){
            billTotal = (String)request.getParameter("billTotal");
        } 
        if (request.getParameter("techmessage")!=null){
            techmessage = (String)request.getParameter("techmessage");
            initialTechMessage = techmessage;
        }                                               
    }
    //---------------------- COMMON -------------------------
    if (request.getParameter("action")!=null){
        action = (String)request.getParameter("action");
    } else {
        if(session.getAttribute("sessionaction")!=null){
            action = session.getAttribute("sessionaction").toString();
        }
    }
    if (request.getParameter("isDBSubmit")!=null){
        isDBSubmit = (String)request.getParameter("isDBSubmit");
    } else {
        if(session.getAttribute("isDBSubmit")!=null){
            isDBSubmit = session.getAttribute("isDBSubmit").toString();
        }
    }
    if (request.getParameter("paidamount")!=null){
        paidamount = (String)request.getParameter("paidamount");
    } else {
        if(session.getAttribute("paidamount")!=null){
           paidamount = session.getAttribute("paidamount").toString();
        }
    }
    if (request.getParameter("payOffsetPendId")!=null){
        payOffsetPendId = (String)request.getParameter("payOffsetPendId");
    } else {
        if(session.getAttribute("payOffsetPendId")!=null){
            payOffsetPendId = session.getAttribute("payOffsetPendId").toString();
        }
    }
    Logging.log("REQUEST PARAMETER:action->"+action+":initialTechMessage->"+initialTechMessage+":billTotal->"+billTotal+":billRefresh->"+billRefresh+
                ":isDBSubmit->"+isDBSubmit+":paidamount->"+paidamount+":payOffsetPendId->"+payOffsetPendId);
    //---------------------------------------------------------
    if (techmessage!=null){
       switch (techmessage) {
           case "start_1":
               techmessage = com.midz.util.ConstantParameters.start_1;
               break;
           case "start_2":
               techmessage = com.midz.util.ConstantParameters.start_2;
               break;
           case "start_3":
               techmessage = com.midz.util.ConstantParameters.start_3;
               /* if (sessionMessage!=null){
                  techmessage = sessionMessage;
               } */
               break;
           case "start_4":
               techmessage = com.midz.util.ConstantParameters.start_4;
               break;
           case "stop_1":
               techmessage = com.midz.util.ConstantParameters.stop_1;
               break;
           case "fail":
               techmessage = com.midz.util.ConstantParameters.fail;
               break;  
           default:
               //success_
               if (techmessage.startsWith("success")) {
                   billRefresh = techmessage.replaceAll("[^0-9]", "");
                   techmessage = com.midz.util.ConstantParameters.success+" "+billRefresh;
               }
               break;
       } // switch
       Logging.log("REQUEST PARAMETER: TRANSFORMED techmessage->"+techmessage);                                         
    } // techmessage request/session parameter 
    //---------------------------------------------------------   
    if ( (action != null && action.equalsIgnoreCase("stop")) &&
         (isDBSubmit != null && isDBSubmit.equalsIgnoreCase("Y")) &&
         (paidamount != null && payOffsetPendId != null)
        ) {
             Logging.log("##############################>>>>>>>>>>>> FINAL DB COMMIT >>>>>>>>>>>>>>>");
             //********* redirect to paybillsubmit.jsp page
             //response.setContentType("text/html; charset=UTF-8");
             resourceURL = request.getContextPath() + "/paybillsubmit.jsp";
             resourceURL = resourceURL + "?" + "&action=" + action;
             resourceURL = resourceURL + "&billTotal=" + billTotal + "&techmessage=" + techmessage + "&paidamount=";
             resourceURL = resourceURL + paidamount + "&payOffsetPendId=" + payOffsetPendId + "&isDBSubmit=Y&initialTechMessage="+initialTechMessage;
             Logging.log("##############################>>>>>>>>>>>> resourceURL:"+resourceURL);
             //response.sendRedirect(resourceURL);
%>                    
           <script>          
               function submitFormWithPost(url, params) {
                 var form = document.createElement("form");
                 form.method = "POST";
                 form.action = url;
                 for (var key in params) {
                   if (params.hasOwnProperty(key)) {
                     var input = document.createElement("input");
                     input.type = "hidden";
                     input.name = key;
                     input.value = params[key];
                     form.appendChild(input);
                   }
                 }
                 document.body.appendChild(form);
                 form.submit();
               }
               var resourceURL = "paybillsubmit.jsp";
               var params = {
                   action: '<%= action %>',
                   billTotal: '<%= billTotal %>',
                   techmessage: '<%= techmessage %>',
                   paidamount: '<%= paidamount %>',
                   payOffsetPendId: '<%= payOffsetPendId %>',
                   isDBSubmit: 'Y',
                   initialTechMessage: '<%= initialTechMessage %>'
               };
               submitFormWithPost(resourceURL, params);
           </script>   
<%
    } else { 
    Logging.log("##############################>>>>>>>>>>>> TO PAGE ITSELF >>>>>>>>>>>>>>>");
%>       
 <head>
    <meta charset="UTF-8">
    <title> Village Maintenance Payment Kiosk </title>
    <link rel="stylesheet" href="./css/new_style.css">
     <meta name="viewport" content="width=device-width, initial-scale=1.0">
     <!------------------------------------------------->
        <script src="./js/jquery-3.6.4.min.js"></script>
        <script>
           var count = 0;    
           var errorMsg = "";
           var intervalID = null;
           
           function debug(inputString){
             var printString;
             count = count + 1;
             printString = "STEP "+count+" :"+inputString;
             console.log(printString);
             //alert(printString);
           }                             
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
                debug("-->formattedDateTime-->"+formattedDateTime);
                loadButtonEvent(event);  // calling defaul load page            
            }
           
            window.onload = function() {
              displaySessionVariableValue();
            };
            function refreshPage() {
              location.reload();
            }
            $(document).ready(function() {
              intervalID = setInterval(refreshPage, 5000);
            });
                      
            function startAction(event) {
                event.preventDefault(); // Prevent the default form submission behavior
                var actionValue = 'start';     
                $("#action").val(actionValue);
                var userid = $("#userid").val();
                var name = $("#name").val();
                var action = $("#action").val();
                var timestamp = new Date().getTime();
                
                debug("startAction ->userid="+userid+":name="+name+":action="+action);

                   $.get("BillAcceptorServlet", {
                         userid: userid,
                         name: name,
                         action: action,
                         timestamp: timestamp
                                       
                   }, 
                       function(responseData) {
                          $("#billTotal").html(responseData);
                       }); 
                document.getElementById("actionstart").style.display = "none";
                document.getElementById("actionstop").style.display = "block";
                //document.getElementById("paybill").style.display = "none";
                //$("#servletform").submit();
            }
            
            function stopAction(event, intervalID) {
                 event.preventDefault(); // Prevent the default form submission behavior
                 //clearInterval(intervalID);
                 // startValidate here
                 var paidamount = parseFloat($("#paidamount").val());
                 var minamount = parseFloat($("#minamount").val());                 
                 var actionValue = 'stop';
                 $("#action").val(actionValue);
                 var action = $("#action").val();
                 var userid = $("#userid").val();
                 var name = $("#name").val();
                 var timestamp = new Date().getTime();
                 var payOffsetPendId = $("#payOffsetPendId").val(); 
                 var errormessageDiv = document.getElementById("errormessage");
       //alert('paidamount:'+paidamount);
       //alert('minamount:'+minamount);
                 if (paidamount < minamount) {
                     errorMsg = "Amount to pay must be at least " + minamount;
                     errormessageDiv.innerHTML = errorMsg;
                     document.getElementById("actionstart").style.display = "none";
                     document.getElementById("actionstop").style.display = "block"; 
                     //$("#errormessage").text(errorMsg);           
                 } else {
                    errorMsg = ""; 
                    errormessageDiv.innerHTML = errorMsg;
                    //$("#errormessage").text("");
      //alert('payOffsetPendId:'+payOffsetPendId);
      //alert("stopAction:payOffsetPendId->"+payOffsetPendId+":paidamount->"+paidamount+":userid->"+userid+":action->"+action);
                                            
                    $.get("BillAcceptorServlet", {
                          userid: userid,
                          name: name,
                          action: action,
                          timestamp: timestamp,
                          paidamount: paidamount,
                          payOffsetPendId: payOffsetPendId
                    }, 
                        function(responseData) {
                           $("#billTotal").html(responseData);
                           if (responseData!=null){
                               clearInterval(intervalID);
                           }
                        });
                    document.getElementById("actionstart").style.display = "none";
                    document.getElementById("actionstop").style.display = "none"; 
                    //document.getElementById("paybill").style.display = "block"; //changed from block to none                             
                    //$("#servletform").submit();
                }       
            } //stopAction

            function loadButtonEvent(event){  
                if (event) {
                    event.preventDefault();
                }
                <!-- ************************* START OF LOGIC TO SHOW ON AUTO-REFRESH ON JSP PAGE ************************* -->
                <!-- techmessage -->
                var elementBackground = document.querySelector('.msgRedBkgWhiteFont2Colspan'); // background-color
                var messageShow = "<%=techmessage%>"; 
                var msginitialTechMessage = "<%=initialTechMessage%>";
                if (messageShow !=null && (messageShow.toString()).length > 0){
                    elementBackground.style.backgroundColor = '#ff0000'; //red -> default
                    if(msginitialTechMessage!=null && (msginitialTechMessage.toString()).length > 0){
                        if ((msginitialTechMessage == "start_2") || (msginitialTechMessage == "start_3")){
                            elementBackground.style.backgroundColor = 'green'; //green
                        } 
                    }
                } else {
                    elementBackground.style.backgroundColor = '#ffffff'; //white
                }
                var messageDiv = document.getElementById("techmessage");
                sessionStorage.setItem("messageShow", messageShow);
                var storedMessageValue = sessionStorage.getItem("messageShow");         
                if (storedMessageValue !== null && storedMessageValue !== undefined) {
                    messageDiv.innerHTML = storedMessageValue;
                }  
                <!-- billRefresh -->
                var billRefreshConstMsg = "<%=com.midz.util.ConstantParameters.success%>";
                var billRefreshMsg = "<%=billRefresh%>";
                    <!-- New added -->
                    var elementBackgroundBills = document.getElementsByClassName('msgRedBkgWhiteFont');  // background-color
                    for (var i = 0; i < elementBackgroundBills.length; i++) {
                      var element = elementBackgroundBills[i];
                      if (billRefreshMsg !=null && (billRefreshMsg.toString()).length > 0){
                          element.style.backgroundColor = 'rgb(254, 221, 255)';  // blue  '#0000ff';
                          element.style.color = '#0000ff';                      // white '#ffffff';
                      } else { 
                          element.style.backgroundColor = '#ffffff';  // white
                          element.style.color = '#ffffff';            // white
                      }   
                    }
                    <!-- End New added -->
                var billRefreshConstMsgDiv = document.getElementById("billRefreshConstMsg");
                var billRefreshMsgDiv = document.getElementById("billRefreshMsg");
                sessionStorage.setItem("billRefreshConstMsg", billRefreshConstMsg);
                sessionStorage.setItem("billRefreshMsg", billRefreshMsg);      
                var storedbillRefreshConstMsg = sessionStorage.getItem("billRefreshConstMsg");     
                var storedbillRefreshMsg  = sessionStorage.getItem("billRefreshMsg");

                if (storedbillRefreshMsg !== null && storedbillRefreshMsg !== undefined && storedbillRefreshMsg !== "0") {
                    //billRefreshConstMsgDiv.innerHTML = storedbillRefreshConstMsg;
                    billRefreshConstMsgDiv.innerHTML = "";
                    //billRefreshMsgDiv.innerHTML = storedbillRefreshMsg;
                    billRefreshMsgDiv.innerHTML = "";
                    messageDiv.innerHTML = "<%=com.midz.util.ConstantParameters.reminder_submit%>";
                } else if (storedbillRefreshMsg !== null && storedbillRefreshMsg !== undefined && storedbillRefreshMsg == "0") {
                    billRefreshConstMsgDiv.innerHTML = "";
                    billRefreshMsgDiv.innerHTML = "";
                }
                <!-- billTotal -->
                <!-- start new message -->
                var elementBackgroundBill = document.querySelector('.msgRedBkgWhiteFont');
                <!-- end new message -->
                var billTotalConstMsg = "<%=com.midz.util.ConstantParameters.total_bill%>";
                var billTotalMsg = "<%=billTotal%>";
                var billTotalConstMsgDiv = document.getElementById("billTotalConstMsg");
                var billTotalMsgDiv = document.getElementById("billTotalMsg");
                sessionStorage.setItem("billTotalConstMsg", billTotalConstMsg);
                sessionStorage.setItem("billTotalMsg", billTotalMsg);      
                var storedbillTotalConstMsg = sessionStorage.getItem("billTotalConstMsg");     
                var storedbillTotalMsg  = sessionStorage.getItem("billTotalMsg");
                if (storedbillTotalMsg !== null && storedbillTotalMsg !== undefined && storedbillTotalMsg !== "0") {
                    billTotalConstMsgDiv.innerHTML = storedbillTotalConstMsg;
                    billTotalMsgDiv.innerHTML = storedbillTotalMsg;
                    messageDiv.innerHTML = "<%=com.midz.util.ConstantParameters.reminder_submit%>";
                } else if (storedbillTotalMsg !== null && storedbillTotalMsg !== undefined && storedbillTotalMsg == "0") {
                    billTotalConstMsgDiv.innerHTML = "";
                    billTotalMsgDiv.innerHTML = "";
                }
                <!-- ************************* END OF LOGIC TO SHOW ON AUTO-REFRESH ON JSP PAGE ************************* -->
            <%  
            Logging.log("top of button hide and show");
            Logging.log("action->"+action);
            if (action == ""){
             Logging.log("action is null");
                action = null;
            }
            Logging.log("initialTechMessage->"+initialTechMessage);
                if (action!=null){
                    if (action.equals("start")) {
                        if(initialTechMessage!=null 
                             && (initialTechMessage.equals("start_1")
                                    ||initialTechMessage.equals("start_4"))) {
                Logging.log("block 1 ->actionjs->"+action);
                Logging.log("initialTechMessage->"+initialTechMessage);
            %>
                             document.getElementById("actionstart").style.display = "block";
                             document.getElementById("actionstop").style.display = "none";   

           <% 
                         } else if(initialTechMessage!=null 
                                     && (initialTechMessage.equals("start_2") 
                                         || initialTechMessage.equals("start_3"))) {
           Logging.log("block 2 ->actionjs->"+action);
           Logging.log("initialTechMessage->"+initialTechMessage);
           %>
                             document.getElementById("actionstart").style.display = "none";
                             document.getElementById("actionstop").style.display = "block";         
           <%
                         } else {
           Logging.log("block 3 ->actionjs->"+action);
           Logging.log("initialTechMessage->"+initialTechMessage);   
           %>
                             document.getElementById("actionstart").style.display = "block";
                             document.getElementById("actionstop").style.display = "none";
           <%
                         }
                    } else if (action.equals("stop")) {
           Logging.log("block 4 ->actionjs->"+action);
           Logging.log("initialTechMessage->"+initialTechMessage);      
           %>
                        // removed both actionstart & actionstop by parentNode.remove() instead of making both display = none
                        document.getElementById("actionstart").style.display = "none";
                        document.getElementById("actionstop").style.display = "none";
                        //document.getElementById("paybill").style.display = "block";
            <%
                    } //action stop
                } else { //action is null
            Logging.log("block 4");
            Logging.log("initialTechMessage->"+initialTechMessage);              
            %>
                    document.getElementById("actionstart").style.display = "block";
                    document.getElementById("actionstop").style.display = "none";
                    //document.getElementById("paybill").style.display = "none";
            <%
                } //action
            %>
            } // loadButtonEvent
            
            // Bind the startValidate() function to the form's submit event
            //$("#validateform").submit(startValidate);
            $("#servletform").submit(startAction);
            $("#servletform").submit(stopAction);
            
            // On load event
            document.addEventListener("DOMContentLoaded", function() {
                debug("js1.onload.addeventlistener:"+document.forms);
                //document.forms[0].addEventListener("load", loadButtonEvent);
                
                var newDiv = document.createElement("div");
                newDiv.style.display = "none";
                document.body.appendChild(newDiv);

                loadButtonEvent(event);
            });
        </script>
   <!------------------------------------------------->  
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
                      breadcrumb = "<span class='breadcrumb'> You are here: MY BILL > PAY BILL </span>";
                  } 
              }
              String title = "Pay Bill "+breadcrumb;
          %> 		  
          <table>
             <tr width="25px">
               <td><img src="./image/sannera.jpg" alt="" width="25px" height="25px"><%=title%></td>   
             </tr>
          </table>
          <!-- title -->
        </div>    
         <jsp:include page="navigation.jsp"/>            
<%
float offset_pending_amount = 0;
float min_amount_to_pay = 0;
int paypendingId = 0; 
request.setAttribute("userid", session.getAttribute("id"));
request.setAttribute("name", session.getAttribute("name")); 

int userid = Integer.parseInt(session.getAttribute("id").toString());
String name = session.getAttribute("name").toString();
SanneraPay u = SanneraPayDao.getRecordById(userid);

if (u != null){
    offset_pending_amount=u.getOffsetPendAmount();
    paypendingId = u.getPayOffsetPendId();
}
min_amount_to_pay = ConstantParameters.MINPAYMENT - offset_pending_amount;
%>        
<div class="custom-center-container">       
  <form id="validateform" action="paybillsubmit.jsp" method="POST"> 
     <input type="hidden" id="paidamount" name="paidamount" value="<%=billTotal%>">
     <input type="hidden" id="minamount" name="minamount" value="<%=min_amount_to_pay%>">      
     <input type="hidden" id="payOffsetPendId" name="payOffsetPendId" value="<%=paypendingId%>">
          <div class="responsive-table">
            <table width="100%" border="0">
              <thead> 
                 <tr>
                    <th colspan="2" class="msgRedBkgWhiteFont2Colspan">
                        <div id="techmessage">$(#techmessage)</div>
                        <div id="errormessage" style="background: red;"></div>
                    </th>
                 </tr>
              </thead>    
              <tbody>
                  <tr>
                    <td colspan="2" class="divNoBkg"></td>
                  </tr>
                  <tr>
                    <td>Name</td>
                    <td><%=name%></td>
                  </tr>
                  <tr>
                    <td colspan="2" class="divNoBkg"></td>
                  </tr>
              </tbody>  
              <thead>
                  <tr>
                    <th class="msgRedBkgWhiteFont">
                       <div id="billRefreshConstMsg">$(#billRefreshConstMsg)</div>
                    </th>
                    <th class="msgRedBkgWhiteFont">
                       <div id="billRefreshMsg">$(#billRefreshMsg)</div>
                    </th>
                  </tr>
                  <tr>
                    <td colspan="2" class="divNoBkg"></td>
                  </tr>
                  <tr>
                    <!--  <th>Total Money Paid in KIOSK</th> -->
                    <th class="msgRedBkgWhiteFont">
                       <div id="billTotalConstMsg">$(#billTotalConstMsg)</div>
                    </th>
                    <!--  <th><%//billTotal%></th>  -->
                    <th class="msgRedBkgWhiteFont">
                       <div id="billTotalMsg">$(#billTotalMsg)</div>
                    </th>
                  </tr>
              </thead>    
              <tbody>     
           <% if (offset_pending_amount != 0) { %>
                  <tr>
                    <td colspan="2" class="divNoBkg"></td>
                  </tr>
                  <tr style="color: #0000ff; font-weight: 500;">
                    <td>Extra Paid Amount Previously</td>
                    <td><%=offset_pending_amount%></td>
                  </tr>
           <% } %>      
                  <tr>
                    <td colspan="2" class="divNoBkg"></td>
                  </tr>
              </tbody>
              <thead> 
                 <tr>
                    <th colspan="2" class="msgBlueBkgWhiteFont2Colspan">
                       *** Please pay minimum amount of <%=min_amount_to_pay%> to pay the bill ***
                    </th>
                 </tr>
              </thead>
       <!--   
              <tbody>
                 <tr class="user-details" style="display: flex; justify-content: center; align-items: center; width: 100%">
                    <td colspan="2" class="button" style="height: 20px;">
                        <input type="submit" id="paybill" value="   Pay Bill   " onclick="startValidate(event)">
                    </td>
                 </tr>
              </tbody>  
       -->  
            </table>
        </div>  
  </form>   
  
</div>  <!--  <div class="custom-center-container"> --> 
        <!---------------------------------------------------> 
        <!-- Form to start bill acceptor to accept action="${pageContext.request.contextPath}/BillAcceptorServlet" method="GET"  -->   
        <div class="custom-center">
        <form id="servletform">                      
            <input type="hidden" id="userid" name="userid" value="<%=userid%>">
            <input type="hidden" id="name" name="name" value="<%=name%>">
            <input type="hidden" id="billTotal" name="billTotal" value="<%=billTotal%>">
            <input type="hidden" id="action" name="action" value="">
            <div style="font-size:10px">&nbsp;</div>
                <div class="custom-center">
                    <input type="submit" id="actionstart" value=" Pay Now " name="actionstart" onclick="startAction(event)" class="custom-button"> 
                    <input type="submit" id="actionstop" value="  Submit " name="actionstop"  onclick="stopAction(event, intervalID)" class="custom-button">
                </div>
                <div style="font-size:5px">&nbsp;</div>
        </form>
        </div>
        <!-- Form to start bill acceptor to accept -->
        <!---------------------------------------------------> 
</body>
<%
    }
%>
<jsp:include page="footer.jsp"/>
</html>
