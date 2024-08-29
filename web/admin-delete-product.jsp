<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.connection.*"%>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="java.sql.*"%>
<%
    // Retrieve the 'id' parameter from the request
    String idParam = request.getParameter("id");
    
    if (idParam != null && !idParam.isEmpty()) {
        try {
            int id = Integer.parseInt(idParam);

            // Create an instance of DatabaseConnection to execute the SQL query
            int deleteProduct = DatabaseConnection.insertUpdateFromSqlQuery("DELETE FROM tblproduct WHERE id=" + id);

            // Redirect based on the result of the SQL operation
            if (deleteProduct > 0) {
                response.sendRedirect("admin-view-product.jsp?message=Product+deleted+successfully");
            } else {
                response.sendRedirect("admin-view-product.jsp?message=Failed+to+delete+product");
            }
        } catch (NumberFormatException e) {
            // Handle the case where 'id' is not a valid integer
            response.sendRedirect("admin-view-product.jsp?message=Invalid+product+id");
        } catch (SQLException e) {
            // Handle SQL exceptions
            response.sendRedirect("admin-view-product.jsp?message=Database+error");
        }
    } else {
        // Handle the case where 'id' parameter is missing
        response.sendRedirect("admin-view-product.jsp?message=Product+id+missing");
    }
%>
