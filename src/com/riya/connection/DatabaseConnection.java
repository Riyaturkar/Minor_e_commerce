package com.riya.connection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DatabaseConnection {

    // Singleton Connection instance
    private static Connection connection;

    // Database URL, username, and password
    private static final String URL = "jdbc:mysql://localhost:3308/shoppingsystem";
    private static final String USER = "root";
    private static final String PASSWORD = "Narend-10";

    // Get Connection
    public static Connection getConnection() throws SQLException {
        if (connection == null || connection.isClosed()) {
            try {
                // Registering with MySQL Driver
                Class.forName("com.mysql.cj.jdbc.Driver"); // Use "com.mysql.cj.jdbc.Driver" for newer MySQL versions
                connection = DriverManager.getConnection(URL, USER, PASSWORD);
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
                throw new SQLException("Driver not found.", e);
            }
        }
        return connection;
    }

    // Close Connection
    public static void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
                connection = null;
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }

    // Execute Query and Retrieve ResultSet
    public static ResultSet getResultFromSqlQuery(String sqlQuery) throws SQLException {
        Connection conn = getConnection();
        Statement stmt = conn.createStatement();
        return stmt.executeQuery(sqlQuery);
    }

    // Execute Update/Insert Query
    public static int insertUpdateFromSqlQuery(String sqlQuery) throws SQLException {
        Connection conn = getConnection();
        Statement stmt = conn.createStatement();
        return stmt.executeUpdate(sqlQuery);
    }
     
    public static int insertUpdateFromSqlQuery(String query, Object... params) {
		return 0;
       
    }


    
            // ...

            public static ResultSet getResultFromSqlQuery(String query, Object... params) throws SQLException {
                Connection conn = getConnection(); // assume you have a method to get a connection
                PreparedStatement pstmt = conn.prepareStatement(query);
                
                for (int i = 0; i < params.length; i++) {
                    pstmt.setObject(i + 1, params[i]);
                }
                
                return pstmt.executeQuery();
            }
            public static ResultSet getResultFromSqlQuery(String query, String... params) throws Exception {
                Connection conn = getConnection();
                PreparedStatement pstmt = conn.prepareStatement(query);
                for (int i = 0; i < params.length; i++) {
                    pstmt.setString(i + 1, params[i]);
                }
                return pstmt.executeQuery();
            }
    
}

