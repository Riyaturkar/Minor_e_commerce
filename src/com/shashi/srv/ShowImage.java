package com.shashi.srv;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.imageio.ImageIO;

import com.shashi.service.impl.ProductServiceImpl;

@WebServlet("/ShowImage")
public class ShowImage extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ShowImage() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String prodId = request.getParameter("pid");

        ProductServiceImpl dao = new ProductServiceImpl();

        byte[] image = dao.getImage(prodId);

        if (image == null) {
            File fnew = new File(request.getServletContext().getRealPath("images/noimage.jpg"));
            BufferedImage originalImage = ImageIO.read(fnew);
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ImageIO.write(originalImage, "jpg", baos);
            image = baos.toByteArray();
        }

        response.setContentType("image/jpeg"); // Set the response content type to JPEG
        ServletOutputStream sos = response.getOutputStream();

        sos.write(image);
        sos.flush(); // Ensure all data is sent
        sos.close(); // Close the stream

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}

