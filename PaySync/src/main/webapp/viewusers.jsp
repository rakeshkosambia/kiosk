<!DOCTYPE html>

<html>
<head>
<title>Village Maintenance Payment Kiosk</title>
    <link rel="stylesheet" href="./css/new_style.css">
     <meta name="viewport" content="width=device-width, initial-scale=1.0">
     <script src="./js/xlsx.full.min.js"> </script>
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
        	      if(vUserRole.equalsIgnoreCase("admin")){
                      breadcrumb = "<span class='breadcrumb'> You are here: MEMBER LIST </span>";
                  } else {
                      breadcrumb = "";
                  }
              }
              String title = "List of Members "+breadcrumb; 
          %>           
          
          <table>
             <tr width="25px">
               <td><img src="./image/sannera.jpg" alt="" width="25px" height="25px"><%=title%></td>   
             </tr>
          </table>
          <!-- title -->
        </div>       
<jsp:include page="navigation.jsp"/>
<%@page import="com.midz.dao.SanneraUserDao,com.midz.bean.*,java.util.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
List<SanneraUser> list=SanneraUserDao.getAllRecords();
request.setAttribute("list",list);
%>
    <div class="custom-center-container"> 
		<div class="responsive-table">
		    <table id="user-table">
		     <thead> 
		      <tr>
		         <th>Id</th> 
		         <th>Role</th>
		         <th>User Name</th>
		         <th>Name</th>
		         <!--  <th>Login Attempted</th>  -->
		         <th>Phase/Block/Lot</th>
		         <th>Mobile</th>
		         <th colspan="2">HomeOwner's Bill</th>
		         <th colspan="2">User Active</th>
		      </tr>
		    </thead> 
		      <tbody>
		        <c:forEach items="${list}" var="u">
		          <tr>
		             <td>${u.getId()}</td>
		             <td>${u.getRole()}</td>
		             <td>${u.getUsername()}</td>
		             <td>${u.getName()}</td>
		             <!--  <td>${u.getLoginAttempt()}</td>  -->
		             <td>${u.getPhase()} / ${u.getBlock()} / ${u.getLot()}</td>
		             <td>${u.getMobile()}</td>
		                <c:choose>
		                    <c:when test="${u.getRole() == 'admin'}">
		                        <td>&nbsp;</td> 
		                        <td>&nbsp;</td>   
		                    </c:when>
		                    <c:otherwise>
		                        <td><a href="addbill.jsp?userid=${u.getId()}&name=${u.getName()}">Add Individual Bill</a></td> 
		                        <td><a href="viewbill.jsp?userid=${u.getId()}&name=${u.getName()}">View Individual Bill</a></td>   
		                    </c:otherwise>
		                </c:choose> 
		             <td><a href="edituser.jsp?id=${u.getId()}">Edit</a></td>
		             <td>${u.getActive()}</td>
		          </tr>
		        </c:forEach>
		      </tbody>
		    </table>
		</div>  
    </div>		
    
    <div class="custom-center">
        <form>
          <table>
              <tr>
                  <td style="font-size: 10px">&nbsp;</td>
              </tr>    
              <tr>
                  <td>
                    <div class="custom-center">
                        <input type="submit" style="width: 260px;" value=" Download Member List " onclick="exportToExcel()" class="custom-button">
                    </div>
                  </td>
              </tr>                                
          </table>
        </form> 
    </div>
    
  <script>
    function exportToExcel() {
        var wb = XLSX.utils.book_new();
        var table = document.getElementById('user-table');
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
        XLSX.writeFile(wb, 'users.xlsx');
      }
   </script>    
    
</body>
</html>