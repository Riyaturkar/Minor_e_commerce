<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.riya.service.impl.*,com.riya.service.*,com.riya.beans.*, java.util.*, jakarta.servlet.ServletOutputStream, java.io.*"%>
<%@ page import="jakarta.servlet.http.HttpServletRequest" %>
<%@ page import="jakarta.servlet.http.HttpServletResponse" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
    <title>View Products</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/changes.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
</head>
<body style="background-color: black;">

    <%
        /* Checking the user credentials */
        String userName = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");
        String userType = (String) session.getAttribute("usertype");

        if (userType == null || !userType.equals("admin")) {
            response.sendRedirect("login.jsp?message=Access Denied, Login as admin!!");
        } else if (userName == null || password == null) {
            response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
        }

        ProductServiceImpl prodDao = new ProductServiceImpl();
        List<ProductBean> products = new ArrayList<ProductBean>();

        String search = request.getParameter("search");
        String type = request.getParameter("type");
        String message = "All Products";
        if (search != null) {
            products = prodDao.searchAllProducts(search);
            message = "Showing Results for '" + search + "'";
        } else if (type != null) {
            products = prodDao.getAllProductsByType(type);
            message = "Showing Results for '" + type + "'";
        } else {
            products = prodDao.getAllProducts();
        }
        if (products.isEmpty()) {
            message = "No items found for the search '" + (search != null ? search : type) + "'";
            products = prodDao.getAllProducts();
        }
    %>

    <jsp:include page="header.jsp" />

    <div class="text-center" style="color: black; font-size: 14px; font-weight: bold; " padding-left:150px""><%=message%></div>
    <!-- Start of Product Items List -->
    <div class="container"  >
        <div class="row text-center" style="border-radius:60px;  ">
            <%
                for (ProductBean product : products) {
            %>
            <div class="col-sm-4" style='height: 450px;"border-radius:60px;  background-color:#D8E3D8" '>
            <div style="">
                <div class="thumbnail" style="border-radius:60px; width:360px; background-color:#D8E3D8" >
                    <img src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product" style="height: 150px; max-width: 180px;">
                    <p class="productname"style ="color:#285A59"><%=product.getProdName()%> (<%=product.getProdId()%>)</p>
                    
                    <p class="price" style="color:black">Rs <%=product.getProdPrice()%></p>
                    <form method="post" style ="color:#285A59">
                        <button  type="submit" formaction="./RemoveProductSrv?prodid=<%=product.getProdId()%>" class="btn btn-danger" style ="background-color:#285A59">Remove Product</button>
                        &nbsp;&nbsp;&nbsp;
                        <button type="submit" formaction="updateProduct.jsp?prodid=<%=product.getProdId()%>" class="btn btn-primary"style ="background-color:#53A3A2">Update Product</button>
                    </form>
                </div>
            </div>
            </div>
            <%
                }
            %>
        </div>
    </div>
    <!-- End of Product Items List -->

    

</body>
</html>
