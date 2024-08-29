<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.shashi.service.impl.*, com.shashi.service.*, com.shashi.beans.*, java.util.*, jakarta.servlet.ServletOutputStream, java.io.*"%>
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
<body style="background-color: #E6F9E6;">

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
    <div class="container">
        <div class="table-responsive">
            <table class="table table-hover table-sm">
                <thead style="background-color: black; color: white; font-size: 14px; font-weight: bold;">
                    <tr>
                        <th>Picture</th>
                        <th>ProductName</th>
                        <th>OrderId</th>
                        <th>Quantity</th>
                        <th>Price</th>
                        <th>Time</th>
                        <th>Status</th>
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

    <jsp:include page="footer.html" />
</body>
</html>
