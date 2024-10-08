<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.riya.service.impl.*,com.riya.service.*,com.riya.beans.*, java.util.*, jakarta.servlet.ServletOutputStream, java.io.*"%>
<%@ page import="jakarta.servlet.http.HttpServletRequest" %>
<%@ page import="jakarta.servlet.http.HttpServletResponse" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
    <title>Product Stocks</title>
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
        String userType = (String) session.getAttribute("usertype");
        String userName = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");

        if (userType == null || !userType.equals("admin")) {
            response.sendRedirect("login.jsp?message=Access Denied, Login as admin!!");
        } else if (userName == null || password == null) {
            response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
        }
    %>

    <jsp:include page="header.jsp" />

    
    <div class="container-fluid" style="border-radius:50px">
        <div class="table-responsive">
            <table class="table table-hover table-sm">
                <thead style=" color: black; font-size: 18px;">
                    <tr>
                       
                        <th>ProductId</th>
                        <th>Name</th>
                        <th>Type</th>
                        <th>Price</th>
                        <th>Sold Qty</th>
                        <th>Stock Qty</th>
                        <th colspan="2" style="text-align: center">Actions</th>
                    </tr>
                </thead>
                <tbody style="color:black; font-size: 16px;">
                    <%
                        ProductServiceImpl productDao = new ProductServiceImpl();
                        List<ProductBean> products = productDao.getAllProducts();
                        for (ProductBean product : products) {
                    %>
                    <tr>
                         <td><a href="./updateProduct.jsp?prodid=<%=product.getProdId()%>"><%=product.getProdId()%></a></td>
                        <%
                            String name = product.getProdName();
                            name = name.substring(0, Math.min(name.length(), 25)) + "..";
                        %>
                        <td><%=name%></td>
                        <td><%=product.getProdType().toUpperCase()%></td>
                        <td><%=product.getProdPrice()%></td>
                        <td><%=new OrderServiceImpl().countSoldItem(product.getProdId())%></td>
                        <td><%=product.getProdQuantity()%></td>
                        <td>
                            <form method="post" style="background-color:#3D6263">
                                <button type="submit" formaction="updateProduct.jsp?prodid=<%=product.getProdId()%>" class="btn btn-primary"  style="background-color:#3D6263">Update</button>
                            </form>
                        </td>
                        <td>
                            <form method="post" style="background-color:#3D6263">
                                <button type="submit" formaction="./RemoveProductSrv?prodid=<%=product.getProdId()%>" class="btn btn-danger"  style="background-color:#3D6263; border:none">Remove</button>
                            </form>
                        </td>
                    </tr>
                    <%
                        }
                        if (products.size() == 0) {
                    %>
                    <tr style="background-color: grey; color: white;">
                        <td colspan="8" style="text-align: center;">No Items Available</td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

 
</body>
</html>
