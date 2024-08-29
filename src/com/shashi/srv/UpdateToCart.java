package com.shashi.srv;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.shashi.beans.DemandBean;
import com.shashi.beans.ProductBean;
import com.shashi.service.impl.CartServiceImpl;
import com.shashi.service.impl.DemandServiceImpl;
import com.shashi.service.impl.ProductServiceImpl;

/**
 * Servlet implementation class UpdateToCart
 */
@WebServlet("/UpdateToCart")
public class UpdateToCart extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public UpdateToCart() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userName = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");

        if (userName == null || password == null) {
            response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
            return;
        }

        // Login Check Success
        String userId = userName;
        String prodId = request.getParameter("pid");
        int pQty = 0;

        // Error handling for parsing quantity
        try {
            pQty = Integer.parseInt(request.getParameter("pqty"));
        } catch (NumberFormatException e) {
            response.sendRedirect("cartDetails.jsp?message=Invalid quantity format.");
            return;
        }

        CartServiceImpl cart = new CartServiceImpl();
        ProductServiceImpl productDao = new ProductServiceImpl();

        ProductBean product = productDao.getProductDetails(prodId);
        int availableQty = product.getProdQuantity();

        String status;

        if (availableQty < pQty) {
            status = "Only " + availableQty + " of " + product.getProdName() 
                    + " are available in the shop! Adding only " + availableQty 
                    + " products to your cart.";

            DemandBean demandBean = new DemandBean(userName, product.getProdId(), pQty - availableQty);
            DemandServiceImpl demand = new DemandServiceImpl();
            boolean flag = demand.addProduct(demandBean);

            if (flag) {
                status += "<br/>We will notify you when " + product.getProdName() 
                        + " becomes available in the store!";
            }

            cart.updateProductToCart(userId, prodId, availableQty);
        } else {
            status = cart.updateProductToCart(userId, prodId, pQty);
        }

        // Forward to cartDetails.jsp with status message
        request.setAttribute("message", status);
        RequestDispatcher rd = request.getRequestDispatcher("cartDetails.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
