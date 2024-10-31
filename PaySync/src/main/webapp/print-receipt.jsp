<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" href="./css/receipt.css">
    <title>Sannera San Pablo</title>
</head>
<body>
    <%@page import="com.midz.util.ConstantParameters,com.midz.dao.SanneraPayDao,com.midz.bean.SanneraPay,java.util.*"%>
    <%
    
    request.setAttribute("userid", session.getAttribute("id"));
    request.setAttribute("name", session.getAttribute("name")); 
    String payid = "";
    int intPayId = 0;
    if (request.getParameter("pay_id") != null) {
        payid = request.getParameter("pay_id").toString();
        intPayId = Integer.parseInt(payid);
    }
    int userid = Integer.parseInt(session.getAttribute("id").toString());
    String name = session.getAttribute("name").toString();
    
    SanneraPay pay = SanneraPayDao.getRecordByPayId(intPayId);
    String showDate = pay.getShowDate();
    Float paid_amount = pay.getPaidAmount();
    Date date = new Date();
    %>
    <div class="ticket">
        <img src="./image/sannera.jpg" alt="Logo">
        <p class="centered">ACKNOWLEDGEMENT RECEIPT
            <br> <%=date.toLocaleString()%>
            <br>Receipt No: <span><%=payid%></span>
        </p>
        <table>
            <thead>
                <tr>
                    <th class="quantity">Month</th>
                    <th class="description"></th>
                    <th class="price">PHP</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td class="quantity"><%=showDate%></td>
                    <td class="description">Village Maintenance Fee</td>
                    <td class="price"><%=paid_amount%></td>
                </tr>
                <tr>
                    <td class="quantity"></td>
                    <td class="description">TOTAL</td>
                    <td class="price"><%=paid_amount%></td>
                </tr>
            </tbody>
        </table>
        <p class="centered">Thanks for your payment!
            <br>www.sannerahoa.com
            <br>Paid by: <%=name%>
        </p>
    </div>
  <script>
    // Automatically close the window after printing (optional)
    window.onload = function() {
      window.print();
      window.close();
    };
  </script>    
</body>
</html>
