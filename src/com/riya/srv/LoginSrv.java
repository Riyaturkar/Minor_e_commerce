package com.riya.srv;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.riya.beans.UserBean;
import com.riya.service.impl.UserServiceImpl;

/**
 * Servlet implementation class LoginSrv
 */
@WebServlet("/LoginSrv")
public class LoginSrv extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public LoginSrv() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userName = request.getParameter("username");
        String password = request.getParameter("password");
        String userType = request.getParameter("usertype");
        response.setContentType("text/html");

        String status = "Login Denied! Invalid Username or password.";

        if ("admin".equals(userType)) { // Login as Admin

            if ("admin".equals(password) && "admin@gmail.com".equals(userName)) {
                // valid

                RequestDispatcher rd = request.getRequestDispatcher("adminViewProduct.jsp");

                HttpSession session = request.getSession();

                session.setAttribute("username", userName);
                session.setAttribute("password", password);
                session.setAttribute("usertype", userType);

                rd.forward(request, response);

            } else {
                // Invalid;
                RequestDispatcher rd = request.getRequestDispatcher("login.jsp?message=" + status);
                rd.include(request, response);
            }

        } else { // Login as customer

            UserServiceImpl udao = new UserServiceImpl();

            status = udao.isValidCredential(userName, password);

            if ("valid".equalsIgnoreCase(status)) {
                // valid user

                UserBean user = udao.getUserDetails(userName, password);

                HttpSession session = request.getSession();

                session.setAttribute("userdata", user);
                session.setAttribute("username", userName);
                session.setAttribute("password", password);
                session.setAttribute("usertype", userType);

                RequestDispatcher rd = request.getRequestDispatcher("userHome.jsp");

                rd.forward(request, response);

            } else {
                // invalid user;

                RequestDispatcher rd = request.getRequestDispatcher("login.jsp?message=" + status);

                rd.forward(request, response);

            }
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

