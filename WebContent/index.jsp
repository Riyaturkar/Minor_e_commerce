<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.riya.service.impl.*,com.riya.service.*,com.riya.beans.*, java.util.*, jakarta.servlet.ServletOutputStream, java.io.*"%>
<%@ page import="jakarta.servlet.http.HttpServletRequest" %>
<%@ page import="jakarta.servlet.http.HttpServletResponse" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
    <title>E-commerce</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/changes.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
</head>
<body style="background-color: black;">

    <%
        // Checking the user credentials
        String userName = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");
        String userType = (String) session.getAttribute("usertype");

        boolean isValidUser = true;

        if (userType == null || userName == null || password == null || !userType.equals("customer")) {
            isValidUser = false;
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

    <div class="text-center" style="color: black; font-size: 14px; font-weight: bold;"><%=message%></div>
    <div class="text-center" id="message" style="color: black; font-size: 14px; font-weight: bold;"></div>

    <!-- Start of Product Items List -->
    <div class="container">
        <div class="row text-center">

            <%
                for (ProductBean product : products) {
                    int cartQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId());
            %>
            <div class="col-sm-4" style='height: 350px; width:400px padding-left:40px'>
                <div class="thumbnail" style="border-radius:50px;  ">
                    <img src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product" style="height: 150px; max-width: 180px">
                    <p class="productname"><%=product.getProdName()%></p>
                    <%
                        String description = product.getProdInfo();
                        description = description.substring(0, Math.min(description.length(), 100));
                    %>
                    
                    <p class="price" style="color:black">Rs <%=product.getProdPrice()%></p>
                    <form method="post">
                        <%
                            if (cartQty == 0) {
                        %>
                        <button type="submit" formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1" class="btn btn-success "style ="background-color:#285A59"">Add to Cart</button>
                        &nbsp;&nbsp;&nbsp;
                        <button type="submit" formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1" class="btn btn-primary"style ="background-color:#285A59">Buy Now</button>
                        <%
                            } else {
                        %>
                        <button type="submit" formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0" class="btn btn-danger" style ="background-color:#285A59">Remove From Cart</button>
                        &nbsp;&nbsp;&nbsp;
                        <button type="submit" formaction="cartDetails.jsp" class="btn btn-success">Checkout</button>
                        <%
                            }
                        %>
                    </form>
                    <br />
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
