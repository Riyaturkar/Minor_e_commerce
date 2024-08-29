package java;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.connection.DatabaseConnection;

@WebServlet("/AddToCart")
public class AddToCart extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = 0;

        // Getting all the parameters from the user
        int productId = Integer.parseInt(request.getParameter("productId"));
        String price = request.getParameter("price");
        String mrp_price = request.getParameter("mrp_price");
        HttpSession hs = request.getSession();
        try {
            // If user session is null, user has to re-login
            if (hs.getAttribute("name") == null) {
                response.sendRedirect("customer-login.jsp");
                return; // Exit to avoid further processing
            }

            // Inserting cart details to the database
            int customerId = (int) hs.getAttribute("id");
            int addToCart = DatabaseConnection.insertUpdateFromSqlQuery(
                "INSERT INTO tblcart(id, price, quantity, mrp_price, customer_id, product_id) " +
                "VALUES (?, ?, ?, ?, ?, ?)",
                id, price, 1, mrp_price, customerId, productId
            );
            
            if (addToCart > 0) {
                response.sendRedirect("index.jsp");
            } else {
                // Handle the case where insertion failed
                response.sendRedirect("error.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
