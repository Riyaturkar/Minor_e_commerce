package com.shashi.srv;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.shashi.beans.ProductBean;
import com.shashi.service.impl.ProductServiceImpl;

/**
 * Servlet implementation class UpdateProductSrv
 */
@WebServlet("/UpdateProductSrv")
public class UpdateProductSrv extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public UpdateProductSrv() {
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
            return;
        } else if (userName == null || password == null) {
            response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
            return;
        }

        // Login success
        String prodId = request.getParameter("pid");
        String prodName = request.getParameter("name");
        String prodType = request.getParameter("type");
        String prodInfo = request.getParameter("info");
        Double prodPrice = null;
        Integer prodQuantity = null;

        // Error handling for parsing numeric values
        try {
            prodPrice = Double.parseDouble(request.getParameter("price"));
            prodQuantity = Integer.parseInt(request.getParameter("quantity"));
        } catch (NumberFormatException e) {
            response.sendRedirect("updateProduct.jsp?prodid=" + prodId + "&message=Invalid input for price or quantity.");
            return;
        }

        // Create ProductBean object
        ProductBean product = new ProductBean();
        product.setProdId(prodId);
        product.setProdName(prodName);
        product.setProdInfo(prodInfo);
        product.setProdPrice(prodPrice);
        product.setProdQuantity(prodQuantity);
        product.setProdType(prodType);

        // Update product
        ProductServiceImpl dao = new ProductServiceImpl();
        String status = dao.updateProductWithoutImage(prodId, product);

        // Forward to updateProduct.jsp
        RequestDispatcher rd = request
                .getRequestDispatcher("updateProduct.jsp?prodid=" + prodId + "&message=" + status);
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}

