package DAO;

import Model.User;
import Model.Permission;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    private Connection conn;

    public UserDAO(Connection conn) {
        this.conn = conn;
    }

    public User login(String username, String password) throws SQLException {
        String sql = "SELECT * FROM Users WHERE username=? AND password_hash=? AND is_active=1";
        System.out.println("[UserDAO] SQL: " + sql);
        System.out.println("[UserDAO] Bind username=" + username + ", password=" + password);

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password); // ⚠️ Thực tế nên hash
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setPasswordHash(rs.getString("password_hash"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setRole(rs.getString("role"));
                    user.setSupplierId((Integer) rs.getObject("supplier_id"));
                    user.setActive(rs.getBoolean("is_active"));
                    user.setFailedAttempts(rs.getInt("failed_attempts"));
                    user.setLastLogin(rs.getTimestamp("last_login"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    user.setUpdatedAt(rs.getTimestamp("updated_at"));

                    // Load permissions
                    List<Permission> perms = getPermissionsByUserId(user.getUserId());
                    user.setPermissions(perms);

                    // ==== In tất cả dữ liệu user ====
                    System.out.println("=== User Data ===");
                    System.out.println("UserID: " + user.getUserId());
                    System.out.println("Username: " + user.getUsername());
                    System.out.println("PasswordHash: " + user.getPasswordHash());
                    System.out.println("Email: " + user.getEmail());
                    System.out.println("Phone: " + user.getPhone());
                    System.out.println("Role: " + user.getRole());
                    System.out.println("SupplierID: " + user.getSupplierId());
                    System.out.println("Active: " + user.isActive());
                    System.out.println("FailedAttempts: " + user.getFailedAttempts());
                    System.out.println("LastLogin: " + user.getLastLogin());
                    System.out.println("CreatedAt: " + user.getCreatedAt());
                    System.out.println("UpdatedAt: " + user.getUpdatedAt());
                    System.out.println("Permissions:");
                    perms.forEach(p -> System.out.println("- " + p.getPermissionName() + ": " + p.getDescription()));

                    return user;
                } else {
                    System.out.println("[UserDAO] Login thất bại, username/password sai hoặc user inactive");
                }
            }
        }
        return null;
    }

    private List<Permission> getPermissionsByUserId(int userId) throws SQLException {
        List<Permission> list = new ArrayList<>();
        String sql = "SELECT p.permission_id, p.permission_name, p.description " +
                     "FROM UserPermissions up " +
                     "JOIN Permissions p ON up.permission_id = p.permission_id " +
                     "WHERE up.user_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Permission p = new Permission();
                    p.setPermissionId(rs.getInt("permission_id"));
                    p.setPermissionName(rs.getString("permission_name"));
                    p.setDescription(rs.getString("description"));
                    list.add(p);
                }
            }
        }
        return list;
    }

    // ================== Hàm test login ==================
    public void testLogin(String username, String password) {
        try {
            User user = login(username, password);
            if (user != null) {
                System.out.println("==== Test Login Thành Công ====");
                System.out.println("Role" + user.getRole());
            } else {
                System.out.println("==== Test Login Thất Bại ====");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ================== Main test nhanh ==================
    public static void main(String[] args) {
        try {
            Connection conn = DriverManager.getConnection(
                    "jdbc:sqlserver://localhost:1433;databaseName=hwms;encrypt=true;trustServerCertificate=true",
                    "sa", "123" // Thay mật khẩu thật
            );
            UserDAO dao = new UserDAO(conn);

            // Thay bằng tài khoản bạn muốn test
            dao.testLogin("admin1", "123456");

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
