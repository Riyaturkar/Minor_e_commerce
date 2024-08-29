<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="java.sql.*"%>
<%@ page import="com.connection.*"%>

<!DOCTYPE html>
<html>
<head>
    <title>Online Shopping System</title>
    <!-- Importing all UI libs -->
    <link href="assets/css/bootstrap.css" rel="stylesheet" />
    <link href="assets/css/font-awesome.css" rel="stylesheet" />
    <link href="assets/css/style.css" rel="stylesheet" />
    <link href="css/bootstrap.css" rel="stylesheet" type="text/css" media="all" />
    <link href="css/style.css" rel="stylesheet" type="text/css" media="all" />
    <script type="text/javascript" src="js/jquery-2.1.4.min.js"></script>
    <script src="js/simpleCart.min.js"></script>
    <script type="text/javascript" src="js/bootstrap-3.1.1.min.js"></script>
    <link href='https://fonts.googleapis.com/css?family=Montserrat:400,700' rel='stylesheet' type='text/css'>
    <link href='https://fonts.googleapis.com/css?family=Lato:400,100,100italic,300,300italic,400italic,700,900,900italic,700italic' rel='stylesheet' type='text/css'>
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css" integrity="sha384-lZN37f5QGtY3VHgisS14W3ExzMWZxybE1SJSEsQp9S+oqd12jhcu+A56Ebc1zFSJ" crossorigin="anonymous">
    <script src="js/jquery.easing.min.js"></script>
    <link href='https://fonts.googleapis.com/css?family=Open+Sans' rel='stylesheet' type='text/css' />
</head>
<body>
    <%
        // Checking whether admin is in session or not
        String adminUsername = (String) session.getAttribute("uname");
        if (adminUsername != null && !adminUsername.isEmpty()) {
    %>
    <jsp:include page="adminHeader.jsp"></jsp:include>
    <div class="content-wrapper">
        <div class="container-fluid">
            <div class="row pad-botm">
                <div class="col-md-12">
                    <h4 class="header-line">Delivered Orders</h4>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12 col-sm-12 col-xs-12">
                    <div class="panel panel-success">
                        <div class="panel-heading">Delivered Orders</div>
                        <div class="panel-body">
                            <div class="table-responsive">
                                <table class="table table-striped table-bordered table-hover">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Order No</th>
                                            <th>Customer Details</th>
                                            <th>Product</th>
                                            <th>Qty</th>
                                            <th>Total Amount</th>
                                            <th>Status</th>
                                            <th>Date</th>
                                            <th>Payment Mode</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            Connection conn = null;
                                            PreparedStatement stmt = null;
                                            ResultSet resultOrders = null;
                                            try {
                                                conn = DatabaseConnection.getConnection(); // Ensure this method returns a valid connection
                                                String query = "SELECT * FROM tblorders WHERE order_status = ?";
                                                stmt = conn.prepareStatement(query);
                                                stmt.setString(1, "Deliver");
                                                resultOrders = stmt.executeQuery();
                                                while (resultOrders.next()) {
                                        %>
                                        <tr>
                                            <td><%= resultOrders.getInt("id") %></td>
                                            <td><%= resultOrders.getInt("order_no") %></td>
                                            <td><%= resultOrders.getString("customer_name") %> | <%= resultOrders.getString("customer_email") %> | <%= resultOrders.getString("customer_phone") %></td>
                                            <td>
                                                <img src="uploads/<%= resultOrders.getString("product_image") %>" alt="" class="pro-image-front" style="width: 150px; height: 100px;"><br>
                                                <%= resultOrders.getString("product_name") %>
                                            </td>
                                            <td><%= resultOrders.getInt("quantity") %></td>
                                            <td><%= resultOrders.getDouble("total_amount") %></td>
                                            <td><span class="label label-success">Delivered</span></td>
                                            <td><%= resultOrders.getTimestamp("order_date") %></td>
                                            <td><%= resultOrders.getString("payment_mode") %></td>
                                        </tr>
                                        <%
                                                }
                                            } catch (SQLException e) {
                                                out.println("<tr><td colspan='9'>Error fetching orders: " + e.getMessage() + "</td></tr>");
                                            } finally {
                                                // Clean up resources
                                                if (resultOrders != null) try { resultOrders.close(); } catch (SQLException ignored) {}
                                                if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
                                                if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
                                            }
                                        %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="footer.jsp"></jsp:include>
    <script src="assets/js/jquery-1.10.2.js"></script>
    <script src="assets/js/bootstrap.js"></script>
    <script src="assets/js/custom.js"></script>
    <%
        } else {
            response.sendRedirect("admin-login.jsp");
        }
    %>
</body>
</html>
