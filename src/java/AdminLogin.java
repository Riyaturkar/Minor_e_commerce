package java;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.connection.DatabaseConnection;

@WebServlet("/AdminLogin")
public class AdminLogin extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get all parameters from the frontend (admin)
        String email = request.getParameter("email");
        String pass = request.getParameter("upass");

        // Create session
        HttpSession session = request.getSession();

        // Validate inputs
        if (email == null || email.trim().isEmpty() || pass == null || pass.trim().isEmpty()) {
            session.setAttribute("credential", "Email or Password cannot be empty.");
            response.sendRedirect("admin-login.jsp");
            return;
        }

        try (Connection con = DatabaseConnection.getConnection();
             PreparedStatement pst = con.prepareStatement("SELECT * FROM tbladmin WHERE email=? AND password=?")) {

            // Set parameters in the PreparedStatement
            pst.setString(1, email);
            pst.setString(2, pass);

            // Execute query
            ResultSet resultSet = pst.executeQuery();

            // If all details are correct
            if (resultSet.next()) {
                session.setAttribute("uname", resultSet.getString("name"));
                // Redirect to dashboard page
                response.sendRedirect("dashboard.jsp");
            } else {
                // If details are wrong
                String message = "Incorrect email or password.";
                session.setAttribute("credential", message);
                // Redirect to admin login page
                response.sendRedirect("admin-login.jsp");
            }
        } catch (Exception e) {
            // Logging exception
            e.printStackTrace();  // Consider using a logging framework in production
            session.setAttribute("credential", "An error occurred. Please try again.");
            response.sendRedirect("admin-login.jsp");
        }
    }
}

