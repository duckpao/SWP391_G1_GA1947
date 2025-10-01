package DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.User;

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
    
    // Find all users
    public List<User> findAll() throws SQLException {
        String sql = "SELECT user_id, username, email, phone, role, is_active, " +
                     "failed_attempts, last_login, password_hash FROM Users ORDER BY user_id DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<User> list = new ArrayList<>();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
            return list;
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
    
    // Delete user by ID
    public boolean delete(int userId) throws SQLException {
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
}