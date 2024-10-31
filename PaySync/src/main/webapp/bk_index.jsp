<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <meta charset="UTF-8">
    <title> Village Maintenance Payment Kiosk </title>
    <link rel="stylesheet" href="./css/new_style.css">
     <meta name="viewport" content="width=device-width, initial-scale=1.0">
   </head>
<body>
   <div class="container">
     <div class="title">Welcome to Sannera San Pablo </div>
        <div class="custom-center-container">
          <form action="login.jsp">
	           <table>
	               <tr>
                       <td>
                           <div class="custom-center">
                                <img src="./image/sannera.jpg" alt="" width="20%" height="20%"> 
                           </div>     
                       </td>
                   </tr>
                   <tr>
					   <td>
				            <table width="100%" class="custom-center">
				                <tr>
				                    <td>
				                        This kiosk is not able to dispatch change, you need to pay an exact amount
				                    </td>
				                </tr>
				                <tr>
                                    <td>
                                        This kiosk only accept bill note denomination of 20, 50, 100, 500 and 1,000 peso
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Read and agree the terms and condition before we proceed
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                    </td>
                                </tr>     
				                <tr>
                                    <td>
                                        <div class="custom-center">
                                            <input type="submit" value=" Proceed " class="custom-button">
                                        </div>
                                    </td>
                                </tr>                                
				            </table>
					   </td>
					</tr>
	          </table>
         </form>
     </div>
  </div>
</body>
<jsp:include page="footer.jsp"/>
</html>
