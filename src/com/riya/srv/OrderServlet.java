package com.riya.srv;

import java.io.IOException;
import java.io.PrintWriter;

import com.riya.service.impl.OrderServiceImpl;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class OrderServlet
 */
@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userName = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");

        if (userName == null || password == null) {
            response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
            return; // Ensure no further processing happens after redirect
        }

        double paidAmount = Double.parseDouble(request.getParameter("amount"));
        String status = new OrderServiceImpl().paymentSuccess(userName, paidAmount);

        response.setContentType("text/html");
        PrintWriter pw = response.getWriter();

        RequestDispatcher rd = request.getRequestDispatcher("orderDetails.jsp");

        rd.include(request, response);

        pw.println("<script>document.getElementById('message').innerHTML='" + status + "'</script>");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
