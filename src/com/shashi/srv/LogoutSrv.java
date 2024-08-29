package com.shashi.srv;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class LogoutSrv
 */
@WebServlet("/LogoutSrv")
public class LogoutSrv extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public LogoutSrv() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");

        HttpSession session = request.getSession();

        // Invalidate the session
        session.invalidate();

        // Forward the request to login.jsp with a logout message
        RequestDispatcher rd = request.getRequestDispatcher("login.jsp?message=Successfully Logged Out!");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}

