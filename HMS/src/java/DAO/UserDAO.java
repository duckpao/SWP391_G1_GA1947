package DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.User;

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
        String sql = "INSERT INTO Users(username, password_hash, email, phone, role, is_active) VALUES(?,?,?,?,?,1)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, u.getUsername());
            ps.setString(2, u.getPasswordHash());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getPhone());
            ps.setString(5, u.getRole());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
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

    // Login a user
    public User login(String email, String password) {
        String sql = "SELECT * FROM Users WHERE email=? AND password_hash=? AND is_active=1";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = mapRow(rs);
                return u;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Find all users
    public List<User> findAll() throws SQLException {
        String sql = "SELECT user_id, username, email, phone, role, is_active, failed_attempts, last_login, password_hash FROM Users ORDER BY user_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
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
    public void update(User u) throws SQLException {
        String sql = "UPDATE Users SET username=?, email=?, phone=?, role=? WHERE user_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, u.getUsername());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPhone());
            ps.setString(4, u.getRole());
            ps.setInt(5, u.getUserId());
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
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
            return 0;
        }
    }

    // Count active users
    public int countActive() throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM Users WHERE is_active=1";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
            return 0;
        }
    }

    // Count inactive users
    public int countInactive() throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM Users WHERE is_active=0";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
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
}
