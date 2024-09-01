<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.riya.service.impl.*,com.riya.service.*,com.riya.beans.*, java.util.*, jakarta.servlet.ServletOutputStream, java.io.*" %>
<%@ page import="jakarta.servlet.http.HttpServletRequest" %>
<%@ page import="jakarta.servlet.http.HttpServletResponse" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
    <title>Profile Details</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/changes.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body style="background-color:  #85adad;">

    <%
        // Checking the user credentials
        String userName = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");

        if (userName == null || password == null) {
            response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
        }

        UserService dao = new UserServiceImpl();
        UserBean user = dao.getUserDetails(userName, password);
        if (user == null) {
            user = new UserBean("Test User", 98765498765L, "test@gmail.com", "ABC colony, Patna, Bihar", 87659, "lksdjf");
        }
    %>

    <jsp:include page="header.jsp" />

    <div class="container bg-secondary" style=" padding-left:-100px margin-left:-50px">
        <div class="row" style="padding-top:40px;">
            <div class="col">
                <nav aria-label="breadcrumb" class="bg-light rounded-3 p-3 mb-4">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="index.jsp">Home</a></li>
                        <li class="breadcrumb-item"><a href="profile.jsp">User Profile</a></li>
                    </ol>
                </nav>
            </div>
        </div>

        <div class="row">
            <div class="col-lg-4">
                <div class="card mb-4">
                    <div class="card-body text-center">
                        <h2 class="my-3">
                            Hello <%= user.getName() %> here!!
                        </h2>
                        <!-- <p class="text-muted mb-1">Full Stack Developer</p>
                        <p class="text-muted mb-4">Bay Area, San Francisco, CA</p> -->
                    </div>
                </div>
                <div class="card mb-4 mb-lg-0">
                    <div class="card-body p-0">
                        <ul class="list-group list-group-flush rounded-3">
                                
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="col-lg-8">
                <div class="card mb-4">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-sm-3">
                                <h3 class="mb-0">Full Name</h3>
                            </div>
                            <div class="col-sm-9">
                                <h4 class="text-muted mb-0"><%= user.getName() %></h4>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-sm-3">
                                <h3 class="mb-0">Email</h3>
                            </div>
                            <div class="col-sm-9">
                                <h4 class="text-muted mb-0" ><%= user.getEmail() %></h4>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-sm-3">
                                <h3 class="mb-0">Phone</h3>
                            </div>
                            <div class="col-sm-9">
                                <h4 class="text-muted mb-0"><%= user.getMobile() %></h4>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-sm-3">
                                <h3 class="mb-0">Address</h3>
                            </div>
                            <div class="col-sm-9">
                                <h4 class="text-muted mb-0"><%= user.getAddress() %></h4>
                            </div>
                        </div>
                        <hr>
                        <div class="row">
                            <div class="col-sm-3">
                                <h3 class="mb-0">PinCode</h3>
                            </div>
                            <div class="col-sm-9">
                                <h4 class="text-muted mb-0"><%= user.getPinCode() %></h4>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <br><br><br>
 

</body>
</html>
