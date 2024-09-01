<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.riya.service.impl.*,com.riya.service.*,com.riya.beans.*, java.util.*, jakarta.servlet.ServletOutputStream, java.io.*"%>
<%@ page import="jakarta.servlet.http.HttpServletRequest" %>
<%@ page import="jakarta.servlet.http.HttpServletResponse" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
    <title>Cart Details</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/changes.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body style="background-color:  #85adad;">

    <%
        /* Checking the user credentials */
        String userName = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");

        if (userName == null || password == null) {
            response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
        }

        String addS = request.getParameter("add");
        if (addS != null) {
            int add = Integer.parseInt(addS);
            String uid = request.getParameter("uid");
            String pid = request.getParameter("pid");
            int avail = Integer.parseInt(request.getParameter("avail"));
            int cartQty = Integer.parseInt(request.getParameter("qty"));
            CartServiceImpl cart = new CartServiceImpl();

            if (add == 1) {
                // Add Product into the cart
                cartQty += 1;
                if (cartQty <= avail) {
                    cart.addProductToCart(uid, pid, 1);
                } else {
                    response.sendRedirect("./AddtoCart?pid=" + pid + "&pqty=" + cartQty);
                }
            } else if (add == 0) {
                // Remove Product from the cart
                cart.removeProductFromCart(uid, pid);
            }
        }
    %>

    <jsp:include page="header.jsp" />

    

    <!-- Start of Product Items List -->
    <div class="container">
        <table class="table table-hover">
            <thead style="; color:#2F5052; font-size: 16px; font-weight: bold;">
                <tr>
                    
                    <th>Products</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Add</th>
                    <th>Remove</th>
                    <th>Amount</th>
                </tr>
            </thead>
            <tbody style="color: #294B4C; font-size: 15px; font-weight: bold;">
                <%
                    CartServiceImpl cart = new CartServiceImpl();
                    List<CartBean> cartItems = cart.getAllCartItems(userName);
                    double totAmount = 0;
                    for (CartBean item : cartItems) {
                        String prodId = item.getProdId();
                        int prodQuantity = item.getQuantity();
                        ProductBean product = new ProductServiceImpl().getProductDetails(prodId);
                        double currAmount = product.getProdPrice() * prodQuantity;
                        totAmount += currAmount;

                        if (prodQuantity > 0) {
                %>
                <tr>
                    <td><%=product.getProdName()%></td>
                    <td><%=product.getProdPrice()%></td>
                    <td>
                        <form method="post" action="./UpdateToCart">
                            <input type="number" name="pqty" value="<%=prodQuantity%>" style="max-width: 70px;" min="0">
                            <input type="hidden" name="pid" value="<%=product.getProdId()%>">
                            <input type="submit" name="Update" value="Update" style="max-width: 80px;">
                        </form>
                    </td>
                    <td><a href="cartDetails.jsp?add=1&uid=<%=userName%>&pid=<%=product.getProdId()%>&avail=<%=product.getProdQuantity()%>&qty=<%=prodQuantity%>"><i class="fa fa-plus"></i></a></td>
                    <td><a href="cartDetails.jsp?add=0&uid=<%=userName%>&pid=<%=product.getProdId()%>&avail=<%=product.getProdQuantity()%>&qty=<%=prodQuantity%>"><i class="fa fa-minus"></i></a></td>
                    <td><%=currAmount%></td>
                </tr>
                <%
                        }
                    }
                %>
                <tr>
                    <td colspan="6" style="text-align: center;">Total Amount to Pay (in Rupees)</td>
                    <td><%=totAmount%></td>
                </tr>
                <%
                    if (totAmount != 0) {
                %>
                <tr style=" color: black;">
                    <td colspan="4" style="text-align: center;"></td>
                    <td><form method="post">
                            <button formaction="userHome.jsp" style="background-color: #294B4C; color: white;">Cancel</button>
                        </form>
                    </td>
                    <td colspan="2" align="center">
                        <form method="post">
                            <button style="background-color: #294B4C; color: white;" formaction="payment.jsp?amount=<%=totAmount%>">Pay Now</button>
                        </form>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
    <!-- End of Product Items List -->

   
</body>
</html>

