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
        <div class="container">
            <div class="row pad-botm">
                <div class="col-md-12">
                    <h4 class="header-line">Edit Product</h4>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <div class="panel panel-info">
                        <div class="panel-heading">Edit Product</div>
                        <div class="panel-body">
                            <%
                                // Getting input from the admin
                                int id = Integer.parseInt(request.getParameter("id"));
                                Connection conn = null;
                                PreparedStatement stmt = null;
                                ResultSet rs = null;
                                
                                try {
                                    // Querying the database
                                    conn = DatabaseConnection.getConnection();
                                    String query = "SELECT * FROM tblproduct WHERE id = ?";
                                    stmt = conn.prepareStatement(query);
                                    stmt.setInt(1, id);
                                    rs = stmt.executeQuery();

                                    if (rs.next()) {
                            %>
                            <form role="form" action="admin-edit-product-process.jsp" method="post">
                                <div class="form-group">
                                    <label>Product Id</label>
                                    <input class="form-control" type="text" name="pid" value="<%= rs.getInt("id") %>" readonly />
                                </div>
                                <div class="form-group">
                                    <label>Enter Name</label>
                                    <input class="form-control" type="text" name="pname" value="<%= rs.getString("name") %>" />
                                </div>
                                <div class="form-group">
                                    <label>Price</label>
                                    <input class="form-control" type="text" name="price" value="<%= rs.getString("price") %>" />
                                </div>
                                <div class="form-group">
                                    <label>Description</label>
                                    <textarea class="form-control" name="description" style="min-height: 100px;"><%= rs.getString("description") %></textarea>
                                </div>
                                <div class="form-group">
                                    <label>MRP Price</label>
                                    <input class="form-control" type="text" name="mprice" value="<%= rs.getString("mrp_price") %>" />
                                </div>
                                <div class="form-group">
                                    <label>Status</label>
                                    <select class="form-control" name="status">
                                        <option value="Active" <%= "Active".equals(rs.getString("status")) ? "selected" : "" %>>Active</option>
                                        <option value="In-Active" <%= "In-Active".equals(rs.getString("status")) ? "selected" : "" %>>In-Active</option>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-success">Update Product</button>
                            </form>
                            <%
                                    } else {
                                        out.println("<p>Product not found.</p>");
                                    }
                                } catch (SQLException e) {
                                    out.println("<p>Error: " + e.getMessage() + "</p>");
                                } finally {
                                    // Clean up resources
                                    if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                                    if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
                                    if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
                                }
                            %>
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
