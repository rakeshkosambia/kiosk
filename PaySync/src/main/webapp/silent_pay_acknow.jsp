<%@page import="com.midz.util.ConstantParameters,com.midz.dao.SanneraPayDao,com.midz.bean.SanneraPay,java.util.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<head>
 <!-- <link rel="stylesheet" href="./css/new_style.css"> -->
<style>
    *{
        font-family: 'Poppins',sans-serif;
        font-size: 14px;
    }
    .custom-table {
        background: white;
        padding: 0;
        margin: 0;
    }
    .custom-cell {
        text-align: center;
        vertical-align: top;
    }
    .centered-image {
        display: block;
        margin-left: auto;
        margin-right: auto;
    }
</style>
</head>    
<%
    String str_ack_payid = "";
    int int_ack_payid = 0;
    String str_dash_userid = "";
    int int_dash_userid = 0;
    String str_dash_name = "";
    SanneraPay pay = null;
    String showDate = null;
    Float paid_amount = null;
    
    if (request.getParameter("pay_id") != null) {
        str_ack_payid = request.getParameter("pay_id").toString();
        int_ack_payid = Integer.parseInt(str_ack_payid);
        
        pay = SanneraPayDao.getRecordByPayId(int_ack_payid);
        showDate = pay.getShowDate();
        paid_amount = pay.getPaidAmount();
    }
    if (request.getParameter("dash_userid") != null) {
        str_dash_userid = request.getParameter("dash_userid").toString();
        int_dash_userid = Integer.parseInt(str_dash_userid);
    }
    if (request.getParameter("dash_name") != null) {
        str_dash_name = request.getParameter("dash_name").toString();
    }       
    Date date = new Date();
%>
<html>
<body class="custom-cell">
<div class="custom-cell">
    <table class="custom-table" border="1" width="150px">
        <tr>
            <td class="custom-cell">
                <img src="./image/sannera.jpg" alt="Logo" class="centered-image" style="width: 120px; height: 120px;">
            </td>
        </tr>
        <tr class="custom-cell">
            <td>ACKNOWLEDGEMENT RECEIPT</td>
        </tr>
        <tr class="custom-cell">
            <td>for</td>
        </tr>
        <tr class="custom-cell">
            <td>Village Maintenance Fee</td>
        </tr>
        <tr class="custom-cell">
            <td><%=date.toLocaleString()%></td>
        </tr>
        <tr class="custom-cell">
            <td>Receipt No: <span><%=int_ack_payid%></span></td>
        </tr>   
        <tr>
            <td class="custom-cell">
                <div class="custom-center">
                    <table style="border-collapse: collapse; margin: 0 auto;">
                        <tr style="border-top: 1px solid black; border-bottom: 1px solid black; background: #a3c585; font-weight: 600;">
                            <td class="quantity">Month</td>
                            <td class="description"></td>
                            <td class="price">PHP</td>
                        </tr>
                        <tr>
                            <td class="quantity" style="white-space: nowrap;"><%=showDate%></td>
                            <td class="description"></td>
                            <td class="price"><%=paid_amount%></td>
                        </tr>           
                        <tr style="border-top: 3px double black;  border-bottom:3px double black;">
                            <td class="quantity"></td>
                            <td class="description">TOTAL&nbsp;&nbsp;</td>
                            <td class="price"><%=paid_amount%></td>
                        </tr>                               
                    </table>   
                </div>    
            </td>
        </tr> 
        <tr class="custom-cell">
           <td style="font-size:5px">&nbsp;</td>
        </tr>  
        <tr class="custom-cell">
           <td colspan="3">Thanks for your payment!</td>
        </tr>
        <tr class="custom-cell">
               <td>www.sannerahoa.com</td>
        </tr>           
        <tr class="custom-cell">
           <td>Paid by: <span><%=str_dash_name%></span></td>
        </tr>
    </table>
</div>
</body>
</html>    
    