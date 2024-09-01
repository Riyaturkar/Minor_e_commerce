package com.riya.srv;

import java.io.IOException;

import com.riya.service.impl.ProductServiceImpl;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/RemoveProductSrv")
public class RemoveProductSrv extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public RemoveProductSrv() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("usertype");
        String userName = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");

        if (userType == null || !userType.equals("admin")) {
            response.sendRedirect("login.jsp?message=Access Denied, Login As Admin!!");
            return; // Ensure no further processing happens after redirect
        }

        if (userName == null || password == null) {
            response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
            return; // Ensure no further processing happens after redirect
        }

        // login checked

        String prodId = request.getParameter("prodid");

        ProductServiceImpl product = new ProductServiceImpl();
        String status = product.removeProduct(prodId);

        RequestDispatcher rd = request.getRequestDispatcher("removeProduct.jsp?message=" + status);
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

