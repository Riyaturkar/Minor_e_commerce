package java;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.riya.connection.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "GetProductsOrder", urlPatterns = {"/GetProductsOrder"})
public class GetProductOrders extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Creating Session
        HttpSession session = request.getSession();
        int orderNo = 1000;
        int orderProducts = 0;

        // Getting all parameters from the user
        int paymentId = Integer.parseInt(request.getParameter("payment_id"));
        String customerName = request.getParameter("name");
        String mobileNumber = request.getParameter("phone");
        String emailId = request.getParameter("email");
        String address = request.getParameter("address");
        String addressType = request.getParameter("addressType");
        String pincode = request.getParameter("pincode");
        String paymentMode = request.getParameter("payment");

        // Storing payment attribute in session
        session.setAttribute("paymentId", paymentId);

        // Validate session ID
        Integer customerId = (Integer) session.getAttribute("id");
        if (customerId == null) {
            response.sendRedirect("error.jsp"); // Handle the case where the session ID is missing
            return;
        }

        try (Connection con = DatabaseConnection.getConnection()) {
            // Get maximum order number and increment it
            String maxOrderNoQuery = "SELECT COALESCE(MAX(order_no), 999) FROM tblorders";
            try (PreparedStatement pst = con.prepareStatement(maxOrderNoQuery);
                 ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    orderNo = rs.getInt(1) + 1;
                }
            }

            // Get all products in the cart for the customer
            String getCartProductsQuery = "SELECT p.image_name, p.name, c.quantity, c.mrp_price, c.discount_price, c.total_price, c.product_id " +
                    "FROM tblproduct p JOIN tblcart c ON p.id = c.product_id WHERE c.customer_id = ?";
            try (PreparedStatement pst = con.prepareStatement(getCartProductsQuery)) {
                pst.setInt(1, customerId);
                try (ResultSet rs = pst.executeQuery()) {
                    while (rs.next()) {
                        String imageName = rs.getString("image_name");
                        String productName = rs.getString("name");
                        int quantity = rs.getInt("quantity");
                        String productPrice = rs.getString("mrp_price");
                        String productSellingPrice = rs.getString("discount_price");
                        String productTotalPrice = rs.getString("total_price");
                        String orderStatus = "Pending";

                        // Insert product details into the orders table
                        String insertOrderQuery = "INSERT INTO tblorders (order_no, customer_name, mobile_number, email_id, address, address_type, pincode, image, product_name, quantity, product_price, product_selling_price, product_total_price, order_status, payment_mode, payment_id) " +
                                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                        try (PreparedStatement insertPst = con.prepareStatement(insertOrderQuery)) {
                            insertPst.setInt(1, orderNo);
                            insertPst.setString(2, customerName);
                            insertPst.setString(3, mobileNumber);
                            insertPst.setString(4, emailId);
                            insertPst.setString(5, address);
                            insertPst.setString(6, addressType);
                            insertPst.setString(7, pincode);
                            insertPst.setString(8, imageName);
                            insertPst.setString(9, productName);
                            insertPst.setInt(10, quantity);
                            insertPst.setString(11, productPrice);
                            insertPst.setString(12, productSellingPrice);
                            insertPst.setString(13, productTotalPrice);
                            insertPst.setString(14, orderStatus);
                            insertPst.setString(15, paymentMode);
                            insertPst.setInt(16, paymentId);
                            orderProducts += insertPst.executeUpdate();
                        }
                    }
                }
            }

            // Remove items from the cart
            String deleteCartQuery = "DELETE FROM tblcart WHERE customer_id = ?";
            try (PreparedStatement pst = con.prepareStatement(deleteCartQuery)) {
                pst.setInt(1, customerId);
                pst.executeUpdate();
            }

            if (orderProducts > 0) {
                // Send response back to the user/customer
                String message = "Thank you for your order.";
                session.setAttribute("success", message);
                response.sendRedirect("checkout.jsp");
            } else {
                response.sendRedirect("checkout.jsp");
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Consider using a logging framework
            response.sendRedirect("error.jsp");
        }
    }
}

