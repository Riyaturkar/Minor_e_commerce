package com.riya.srv;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.riya.service.impl.OrderServiceImpl;
import com.riya.service.impl.UserServiceImpl;
import com.riya.utility.MailMessage;

/**
 * Servlet implementation class ShipmentServlet
 */
@WebServlet("/ShipmentServlet")
public class ShipmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ShipmentServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("usertype");
        if (userType == null) {
            response.sendRedirect("login.jsp?message=Access Denied, Login Again!!");
            return; // Ensure no further processing happens after redirect
        }

        String orderId = request.getParameter("orderid");
        String prodId = request.getParameter("prodid");
        String userName = request.getParameter("userid");
        Double amount = Double.parseDouble(request.getParameter("amount"));
        String status = new OrderServiceImpl().shipNow(orderId, prodId);
        String pagename = "shippedItems.jsp";
        if ("FAILURE".equalsIgnoreCase(status)) {
            pagename = "unshippedItems.jsp";
        } else {
            // Ensure MailMessage is properly configured
            MailMessage.orderShipped(userName, new UserServiceImpl().getFName(userName), orderId, amount);
        }

        response.setContentType("text/html");
        PrintWriter pw = response.getWriter();

        RequestDispatcher rd = request.getRequestDispatcher(pagename);
        rd.include(request, response);

        pw.println("<script>document.getElementById('message').innerHTML='" + status + "'</script>");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

