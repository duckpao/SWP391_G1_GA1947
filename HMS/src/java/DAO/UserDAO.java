package DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.User;
import model.Supplier;

public class UserDAO extends DBContext {

    // Map 1 row -> User
    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setUsername(rs.getString("username"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setEmail(rs.getString("email"));
        u.setPhone(rs.getString("phone"));
        u.setRole(rs.getString("role"));
        u.setIsActive(rs.getBoolean("is_active"));
        u.setFailedAttempts(rs.getInt("failed_attempts"));
        u.setLastLogin(rs.getTimestamp("last_login"));
        return u;
    }

    // Check if user exists by email or phone
    public boolean checkUserExists(String emailOrPhone) {
        String sql = "SELECT user_id FROM Users WHERE email = ? OR phone = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, emailOrPhone); // Check email
            ps.setString(2, emailOrPhone); // Check phone
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Register new user
    public boolean register(User u) {
        String sqlUser = "INSERT INTO Users(username, password_hash, email, phone, role, is_active) VALUES(?,?,?,?,?,1)";
        String sqlSupplier = """
        INSERT INTO Suppliers (user_id, name, contact_email, contact_phone, address, performance_rating, created_at, updated_at)
        VALUES (?, ?, ?, ?, '', NULL, GETDATE(), GETDATE())
    """;

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);

            int userId = -1;
            try (PreparedStatement psUser = conn.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS)) {
                psUser.setString(1, u.getUsername());
                psUser.setString(2, u.getPasswordHash());
                psUser.setString(3, u.getEmail());
                psUser.setString(4, u.getPhone());
                psUser.setString(5, u.getRole());
                psUser.executeUpdate();

                try (ResultSet rs = psUser.getGeneratedKeys()) {
                    if (rs.next()) {
                        userId = rs.getInt(1);
                    }
                }
            }

            // Nếu role là Supplier thì thêm vào bảng Suppliers
            if ("Supplier".equalsIgnoreCase(u.getRole()) && userId > 0) {
                try (PreparedStatement psSupp = conn.prepareStatement(sqlSupplier)) {
                    psSupp.setInt(1, userId);
                    psSupp.setString(2, u.getUsername());
                    psSupp.setString(3, u.getEmail());
                    psSupp.setString(4, u.getPhone());
                    psSupp.executeUpdate();
                }
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getSupplierIdByUserId(int userId) {
        String sql = "SELECT supplier_id FROM Suppliers WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("supplier_id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
        return -1; // Trả về -1 nếu không tìm thấy supplier
    }

    public Supplier getSupplierByUserId(int userId) throws SQLException {
        Supplier supplier = null;
        String sql = "SELECT * FROM Suppliers WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    supplier = new Supplier();
                    supplier.setSupplierId(rs.getInt("supplier_id"));
                    supplier.setUserId(rs.getInt("user_id"));
                    supplier.setName(rs.getString("name"));
                    supplier.setContactEmail(rs.getString("contact_email"));
                    supplier.setContactPhone(rs.getString("contact_phone"));
                    supplier.setAddress(rs.getString("address"));
                    supplier.setPerformanceRating(rs.getDouble("performance_rating"));
                    Timestamp createdTs = rs.getTimestamp("created_at");
                    if (createdTs != null) {
                        supplier.setCreatedAt(createdTs.toLocalDateTime());
                    }
                    Timestamp updatedTs = rs.getTimestamp("updated_at");
                    if (updatedTs != null) {
                        supplier.setUpdatedAt(updatedTs.toLocalDateTime());
                    }

                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return supplier;
    }

    // Update user password
    public boolean updatePassword(String email, String newPassword) {
        String sql = "UPDATE Users SET password_hash=? WHERE email=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, newPassword);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Update password by email or phone
    public boolean updatePasswordByEmailOrPhone(String newPassword, String emailOrPhone) {
        String sql = "UPDATE Users SET password_hash=? WHERE email=? OR phone=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, newPassword); // New password
            ps.setString(2, emailOrPhone); // Email or phone (depending on user input)
            ps.setString(3, emailOrPhone); // Email or phone (depending on user input)
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Login user by email or username
    public User findByEmailOrUsername(String emailOrUsername) {
        String sql = "SELECT * FROM Users WHERE (email = ? OR username = ?) AND is_active = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, emailOrUsername);
            ps.setString(2, emailOrUsername);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs); // mapRow cần set cả passwordHash vào User
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Find all users
    public List<User> findAll() throws SQLException {
        String sql = "SELECT user_id, username, email, phone, role, is_active, failed_attempts, last_login, password_hash FROM Users ORDER BY user_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            List<User> list = new ArrayList<>();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
            return list;
        }
    }

    // Filter users with multiple criteria
    public List<User> filterUsers(String keyword, String role, String status) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT user_id, username, email, phone, role, is_active, failed_attempts, last_login, password_hash FROM Users WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Filter by keyword (username, email, phone)
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (username LIKE ? OR email LIKE ? OR phone LIKE ?) ");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }

        // Filter by role
        if (role != null && !role.trim().isEmpty()) {
            sql.append("AND role = ? ");
            params.add(role.trim());
        }

        // Filter by status (active/locked)
        if (status != null && !status.trim().isEmpty()) {
            if ("active".equalsIgnoreCase(status.trim())) {
                sql.append("AND is_active = 1 ");
            } else if ("locked".equalsIgnoreCase(status.trim())) {
                sql.append("AND is_active = 0 ");
            }
        }

        sql.append("ORDER BY user_id DESC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                List<User> list = new ArrayList<>();
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
                return list;
            }
        }
    }

    // Find user by ID
    public User findById(int id) throws SQLException {
        String sql = "SELECT * FROM Users WHERE user_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    // Find user by username
    public User findByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM Users WHERE username=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        }
    }

    // Create new user
    public void create(User u) throws SQLException {
        String sql = "INSERT INTO Users(username, password_hash, email, phone, role) VALUES(?,?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, u.getUsername());
            ps.setString(2, u.getPasswordHash());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getPhone());
            ps.setString(5, u.getRole());
            ps.executeUpdate();
        }
    }

    // Update user information
    // Method update không đổi password (giữ nguyên method cũ)
    public void update(User u) throws SQLException {
        String sql = "UPDATE Users SET email=?, phone=?, role=?, updated_at=GETDATE() WHERE user_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, u.getEmail());
            ps.setString(2, u.getPhone());
            ps.setString(3, u.getRole());
            ps.setInt(4, u.getUserId());
            ps.executeUpdate();
        }
    }

// Method mới: update kèm password
    public void updateWithPassword(User u) throws SQLException {
        String sql = "UPDATE Users SET email=?, phone=?, role=?, password_hash=?, updated_at=GETDATE() WHERE user_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, u.getEmail());
            ps.setString(2, u.getPhone());
            ps.setString(3, u.getRole());
            ps.setString(4, u.getPasswordHash());
            ps.setInt(5, u.getUserId());
            ps.executeUpdate();
        }
    }

// Hoặc method update chỉ password
    public void updatePassword(int userId, String newPasswordHash) throws SQLException {
        String sql = "UPDATE Users SET password_hash=?, updated_at=GETDATE() WHERE user_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newPasswordHash);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    // Set user status active/inactive
    public void setActive(int userId, boolean active) throws SQLException {
        String sql = "UPDATE Users SET is_active=? WHERE user_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setBoolean(1, active);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    // Delete user by ID (ensure no deletion of Admin)
    public boolean delete(int userId) throws SQLException {
        // Check if user is Admin
        User user = findById(userId);
        if (user != null && "Admin".equals(user.getRole())) {
            throw new SQLException("Cannot delete Admin account!");
        }

        String sql = "DELETE FROM Users WHERE user_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    // Count total users
    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM Users";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
            return 0;
        }
    }

    // Count active users
    public int countActive() throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM Users WHERE is_active=1";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
            return 0;
        }
    }

    // Count inactive users
    public int countInactive() throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM Users WHERE is_active=0";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
            return 0;
        }
    }

    // Search users by keyword (username, email, phone)
    public List<User> search(String keyword) throws SQLException {
        String sql = "SELECT * FROM Users WHERE username LIKE ? OR email LIKE ? OR phone LIKE ? ORDER BY user_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            try (ResultSet rs = ps.executeQuery()) {
                List<User> list = new ArrayList<>();
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
                return list;
            }
        }
    }

    // Find users by role
    public List<User> findByRole(String role) throws SQLException {
        String sql = "SELECT * FROM Users WHERE role = ? ORDER BY user_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, role);
            try (ResultSet rs = ps.executeQuery()) {
                List<User> list = new ArrayList<>();
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
                return list;
            }
        }
    }

    // Find users by status
    public List<User> findByStatus(boolean isActive) throws SQLException {
        String sql = "SELECT * FROM Users WHERE is_active = ? ORDER BY user_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            try (ResultSet rs = ps.executeQuery()) {
                List<User> list = new ArrayList<>();
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
                return list;
            }
        }
    }

    public boolean promoteUserToSupplier(int userId) throws SQLException {
        String updateRoleSql = "UPDATE Users SET role = 'Supplier' WHERE user_id = ?";
        String insertSupplierSql = """
        INSERT INTO Suppliers (user_id, name, contact_email, contact_phone, address, performance_rating, created_at, updated_at)
        SELECT user_id, username, email, phone, '', 0.0, GETDATE(), GETDATE()
        FROM Users WHERE user_id = ? AND role = 'Supplier'
    """;

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement psUpdate = conn.prepareStatement(updateRoleSql)) {
                psUpdate.setInt(1, userId);
                int updated = psUpdate.executeUpdate();

                if (updated == 0) {
                    conn.rollback();
                    return false; // user không tồn tại
                }
            }

            try (PreparedStatement psInsert = conn.prepareStatement(insertSupplierSql)) {
                psInsert.setInt(1, userId);
                psInsert.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }

    public boolean updateRole(int userId, String newRole) throws SQLException {
        String sql = "UPDATE Users SET role = ? WHERE user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newRole);
            ps.setInt(2, userId);
            int affected = ps.executeUpdate();
            return affected > 0;
        }
    }

    // Add to UserDAO.java
    public static List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT user_id, username, email, phone, role, is_active, last_login "
                + "FROM Users WHERE is_active = 1 ORDER BY username";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setRole(rs.getString("role"));
                user.setIsActive(rs.getBoolean("is_active"));
                user.setLastLogin(rs.getTimestamp("last_login"));
                users.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }
}
