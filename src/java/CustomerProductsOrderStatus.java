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

@WebServlet("/CustomerProductsOrderStatus")
public class CustomerProductsOrderStatus extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderId = request.getParameter("orderId");

        // Check if orderId is provided
        if (orderId == null || orderId.trim().isEmpty()) {
            response.sendRedirect("admin-all-orders.jsp");
            return;
        }

        try (Connection con = DatabaseConnection.getConnection()) {
            // Check current status
            String currentStatusQuery = "SELECT order_status FROM tblorders WHERE order_no=?";
            String newStatus;
            try (PreparedStatement pst = con.prepareStatement(currentStatusQuery)) {
                pst.setString(1, orderId);
                try (ResultSet rs = pst.executeQuery()) {
                    if (rs.next()) {
                        String currentStatus = rs.getString("order_status");
                        if ("Deliver".equalsIgnoreCase(currentStatus)) {
                            newStatus = "Pending";
                        } else {
                            newStatus = "Deliver";
                        }
                    } else {
                        // If orderId does not exist, redirect to orders page
                        response.sendRedirect("admin-all-orders.jsp");
                        return;
                    }
                }
            }

            // Update status
            String updateStatusQuery = "UPDATE tblorders SET order_status=? WHERE order_no=?";
            try (PreparedStatement pst = con.prepareStatement(updateStatusQuery)) {
                pst.setString(1, newStatus);
                pst.setString(2, orderId);
                int rowsAffected = pst.executeUpdate();

                // Redirect based on update success
                if (rowsAffected > 0) {
                    response.sendRedirect("admin-all-orders.jsp");
                } else {
                    response.sendRedirect("admin-all-orders.jsp");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();  // Consider using a logging framework for better logging
            response.sendRedirect("admin-all-orders.jsp");
        }
    }
}

