package DAO;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    protected Connection connection;
    
    public DBContext() {
        try {
            // Edit URL , username, password to authenticate with your MS SQL Server
            String url = "jdbc:sqlserver://localhost:1433;databaseName=SWP391";
            String username = "sa";
            String password = "123";
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException | SQLException ex) {
            System.out.println(ex);
        }
    }
    
    // Thêm method này để tạo connection mới mỗi lần gọi
    public Connection getConnection() throws SQLException {
        try {
            String url = "jdbc:sqlserver://localhost:1433;databaseName=SWP391";
            String username = "sa";
            String password = "123";
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            return DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException ex) {
            throw new SQLException("SQL Server Driver not found", ex);
        }
    }
    
    public void closeConnection() {
    try {
        if (connection != null && !connection.isClosed()) {
            connection.close();
        }
    } catch (SQLException e) {
        System.err.println("Error closing connection: " + e.getMessage());
    }
}

}