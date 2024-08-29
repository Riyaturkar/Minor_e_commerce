package java;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.connection.DatabaseConnection;

@WebServlet("/UpdateProductQuantity")
public class UpdateProductQuantity extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        try {
            // Getting all the data from the user/customer
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            int productId = Integer.parseInt(request.getParameter("productId"));
            Integer customerId = (Integer) session.getAttribute("id");
            
            if (customerId == null) {
                response.sendRedirect("login.jsp"); // Redirect to login if session ID is missing
                return;
            }

            double productPrice = 0.0;

            // Fetch the discount price from the database
            String discountPriceQuery = "SELECT discount_price FROM tblcart WHERE customer_id = ? AND product_id = ?";
            try (Connection con = DatabaseConnection.getConnection();
                 PreparedStatement pst = con.prepareStatement(discountPriceQuery)) {
                pst.setInt(1, customerId);
                pst.setInt(2, productId);

                try (ResultSet rs = pst.executeQuery()) {
                    if (rs.next()) {
                        String discountPriceStr = rs.getString("discount_price");
                        productPrice = Double.parseDouble(discountPriceStr);
                    } else {
                        response.sendRedirect("checkout.jsp"); // Redirect if no product found
                        return;
                    }
                }
            }

            productPrice *= quantity;

            // Update the product quantity and total price in the database
            String updateQuery = "UPDATE tblcart SET quantity = ?, total_price = ? WHERE customer_id = ? AND product_id = ?";
            try (Connection con = DatabaseConnection.getConnection();
                 PreparedStatement pst = con.prepareStatement(updateQuery)) {
                pst.setInt(1, quantity);
                pst.setDouble(2, productPrice);
                pst.setInt(3, customerId);
                pst.setInt(4, productId);

                int rowsAffected = pst.executeUpdate();
                if (rowsAffected > 0) {
                    response.sendRedirect("checkout.jsp");
                } else {
                    response.sendRedirect("checkout.jsp");
                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace(); // Log error details for debugging
            response.sendRedirect("error.jsp"); // Redirect to error page
        } catch (SQLException e) {
            e.printStackTrace(); // Log error details for debugging
            response.sendRedirect("error.jsp"); // Redirect to error page
        } catch (Exception e) {
            e.printStackTrace(); // Log error details for debugging
            response.sendRedirect("error.jsp"); // Redirect to error page
        }
    }
}
