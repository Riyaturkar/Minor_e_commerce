<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.riya.service.impl.*,com.riya.service.*,com.riya.beans.*, java.util.*, jakarta.servlet.ServletOutputStream, java.io.*"%>
<%@ page import="jakarta.servlet.http.HttpServletRequest" %>
<%@ page import="jakarta.servlet.http.HttpServletResponse" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
    <title>Order Details</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="css/changes.css">
</head>
<body style="background-color :  #85adad;">

    <%
        // Checking the user credentials
        String userName = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");

        if (userName == null || password == null) {
            response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
        }

        OrderService dao = new OrderServiceImpl();
        List<OrderDetails> orders = dao.getAllOrderDetails(userName);
    %>

    <jsp:include page="header.jsp" />

    <div class="text-center" style="color: green; font-size: 24px; font-weight: bold;">
        Order Details
    </div>

    <!-- Start of Product Items List -->
    <div class="container" style="heigth:50px">
        <div class="table-responsive" style="border-radius:30px; padding-top:10px; ">
            <table class="table table-hover table-sm" style="border-radius:10px">
                <thead style="background-color: white; color: white; font-size: 14px; font-weight: bold;">
                    <tr>
                        <th style="color:grey">Picture</th>
                        <th style="color:grey">ProductName</th>
                        <th style="color:grey">OrderId</th>
                        <th style="color:grey">Quantity</th>
                        <th style="color:grey">Price</th>
                        <th style="color:grey">Time</th>
                        <th style="color:grey">Status</th>
                    </tr>
                </thead>
                <tbody style="background-color: white; font-size: 15px; font-weight: bold;">
                    <%
                        for (OrderDetails order : orders) {
                    %>
                    <tr>
                        <td><img src="./ShowImage?pid=<%= order.getProductId() %>" style="width: 50px; height: 50px;"></td>
                        <td><%= order.getProdName() %></td>
                        <td><%= order.getOrderId() %></td>
                        <td><%= order.getQty() %></td>
                        <td><%= order.getAmount() %></td>
                        <td><%= order.getTime() %></td>
                        <td class="text-success"><%= order.getShipped() == 0 ? "ORDER_PLACED" : "ORDER_SHIPPED" %></td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
    <!-- End of Product Items List -->

    
</body>
</html>
