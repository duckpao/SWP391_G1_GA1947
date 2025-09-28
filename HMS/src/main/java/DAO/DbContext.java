/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DbContext {
    private static DbContext instance;
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=hwms;encrypt=true;trustServerCertificate=true";
    private static final String USER = "sa"; // Thay bằng username của bạn
    private static final String PASSWORD = "123"; // Thay bằng password của bạn
    
    private Connection connection;

    private DbContext() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            this.connection = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Connected to HWMS database successfully!");
        } catch (ClassNotFoundException e) {
            System.err.println("SQL Server JDBC Driver not found: " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("Connection failed: " + e.getMessage());
        }
    }

    public static synchronized DbContext getInstance() {
        if (instance == null) {
            instance = new DbContext();
        }
        return instance;
    }

    public Connection getConnection() {
        return connection;
    }

    public void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("Database connection closed.");
            } catch (SQLException e) {
                System.err.println("Error closing connection: " + e.getMessage());
            }
        }
    }

    public ResultSet executeQuery(String sql, Object... params) {
        try {
            PreparedStatement pstmt = connection.prepareStatement(sql);
            for (int i = 0; i < params.length; i++) {
                pstmt.setObject(i + 1, params[i]);
            }
            return pstmt.executeQuery();
        } catch (SQLException e) {
            System.err.println("Query execution failed: " + e.getMessage());
            return null;
        }
    }

    public int executeUpdate(String sql, Object... params) {
        try {
            PreparedStatement pstmt = connection.prepareStatement(sql);
            for (int i = 0; i < params.length; i++) {
                pstmt.setObject(i + 1, params[i]);
            }
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Update execution failed: " + e.getMessage());
            return -1;
        }
    }

    public void cleanup(PreparedStatement pstmt, ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                System.err.println("Error closing ResultSet: " + e.getMessage());
            }
        }
        if (pstmt != null) {
            try {
                pstmt.close();
            } catch (SQLException e) {
                System.err.println("Error closing PreparedStatement: " + e.getMessage());
            }
        }
    }
  public static void main(String[] args) {
        DbContext db = DbContext.getInstance();
        if (db.getConnection() != null) {
            System.out.println("Connection established successfully!");
            
            // Thử truy vấn đơn giản để kiểm tra
            String sql = "SELECT COUNT(*) as userCount FROM Users";
            ResultSet rs = db.executeQuery(sql);
            
            try {
                if (rs != null && rs.next()) {
                    int userCount = rs.getInt("userCount");
                    System.out.println("Number of users in database: " + userCount);
                } else {
                    System.out.println("No data found or query failed.");
                }
            } catch (SQLException e) {
                System.err.println("Error executing query: " + e.getMessage());
            } finally {
                db.cleanup(null, rs); // Đóng ResultSet
                db.closeConnection(); // Đóng kết nối
            }
        } else {
            System.err.println("Failed to establish connection.");
        }
    }
}