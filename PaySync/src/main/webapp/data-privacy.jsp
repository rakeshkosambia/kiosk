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
<div class="container">   
   <div classs="content">
      <div class="title">
          <!-- title -->
          <% String title = "Data Privacy Consent"; %>
          <table>
             <tr width="25px">
               <td><img src="./image/sannera.jpg" alt="" width="25px" height="25px"><%=title%></td>   
             </tr>
          </table>
          <!-- title -->
      </div>  
	  <div classs="custom-center-container">       
	     <form id="dataForm" action="homeowner.jsp">
	         <div class="container">   
			      <div class="custom-center">        
			          <table class="custom-center-container" width="90%" style="box-shadow: 0 10px 15px rgba(255, 0.15, 0.15, 0.35); padding-left: 25px; padding-right: 25px; padding-top: 15px; padding-bottom: 15px;">
			            <tr>
			                <td>
			                    <b>The personal information you provide will be used to process and complete your payment/transaction.</b>
			                </td>
			            </tr>
			             <tr>
			                <td style="font-size:5px"></td>
			            </tr>
			            <tr>
			                <td>
			                    By clicking CONTINUE, I agree to the collection and use of data that I have provided through this payment kiosk
			                by CashVilla for the purpose of the transaction process.
			                </td>
			            </tr>
			            <tr>
			                <td style="font-size:5px"></td>
			            </tr>
			            <tr>
			                <td>
			                    I understand that the collection and the use of this data 
			                which may include with the Data Privacy Act of 2012 and the Privacy Policy of CashVilla.
			                </td>
			            </tr>
			            <tr>
			                <td style="font-size:10px"></td>
			            </tr>
			            <tr>
			                <td>
			                    <h4>CASHVILLA POLICY</h4>
			                </td>
			            </tr>
			            <tr>
			                <td style="font-size:5px"></td>
			            </tr>
			            <tr>
			                <td>
			                    This machine does not dispense change. Any excess amount
			                will be credited to your ExtraPayment account that automatically minus from
			                your next bill.
			                </td>
			            </tr>
			            <tr>
			                <td style="font-size:5px">
			                </td>
			            </tr>
			            <tr>
			                <td>
			                    Ang machine na ito ay hindi nagsusukli. Ang iyong sukli ay
			                mapupunta sa iyong ExtraPayment account na mababawas sa iyong susunod na bill
			                </td>
			            </tr>
			            <tr>
			               <td style="font-size:5px">
			               </td>
			            </tr>
			            <tr>
			               <td style="vertical-align: center; text-align: center; color: red;">
			                   <input type="checkbox" class="details" required> By clicking the box, you read & agreed to the terms and condition 
			               </td>
			            </tr>  
			            <tr>
			              <td>
			                  <div class="custom-center">  
						          <table>
						            <tr>
						                <td>
						                    <div class="custom-right">
						                        <input type="submit" value=" Cancel " class="custom-button" onclick="redirectPage('index.jsp');">
						                    </div>
						                </td>
						                <td width="10px"></td>
						                <td>
						                    <div class="custom-left">
						                        <input type="submit" value=" Continue " class="custom-button">
						                    </div>
						                </td>
						            </tr>
						          </table>
						      </div>     
					     </td>     
				      </table>     
				  </div>  <!-- <div class="custom-center"> -->
	         </div> <!-- <div class="container"> -->
	     </form>
	  </div> <!-- <div classs="custom-center-container"> -->  	
  </div> <!-- <div classs="content"> -->
</div> <!-- <div class="container">  -->
</body>
</html>
