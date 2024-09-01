package java;

import java.io.IOException;
import java.sql.ResultSet;

import com.riya.connection.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/CustomerLogin")
public class CustomerLogin extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get all data from user/customer
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        

        // Create Session
        HttpSession session = request.getSession();

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            // If email or password is empty or null
            String message = "Email or Password is empty";
            session.setAttribute("credential", message);
            response.sendRedirect("customer-login.jsp");
            return;
        }

        
        	try {
        		String query = "SELECT * FROM tblcustomer WHERE email=? AND password=?";
                ResultSet resultSet = DatabaseConnection.getResultFromSqlQuery(query, email, password);


            if (resultSet.next()) {
                // Storing the login details in session
                session.setAttribute("id", resultSet.getInt("id"));
                session.setAttribute("name", resultSet.getString("name"));
                // Redirecting response to index.jsp
                response.sendRedirect("index.jsp");
            } else {
                // If wrong credentials are entered
                String message = "Invalid credentials";
                session.setAttribute("credential", message);
                response.sendRedirect("customer-login.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Handling unexpected errors
            session.setAttribute("credential", "An error occurred. Please try again.");
            response.sendRedirect("customer-login.jsp");
        }
    }
}
