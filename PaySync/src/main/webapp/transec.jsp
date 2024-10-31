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
    <div class="title">My Payment History</div>
    <div class="content">
    
<jsp:include page="navigation.jsp"/>

	<form action="#"> 
  <table>
    <thead>  
  <tr>
    <th>Date of Payment</th>
    <th>Amount Paid</th>
  </tr>
  <tr>
    <td>January 15, 2023</td>
    <td>500</td>
  </tr>
</table>
		  <div class="button">
          <input type="submit" value="Download">
        </div>
      </form>
	
</body>
</html>