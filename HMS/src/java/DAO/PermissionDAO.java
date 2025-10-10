package DAO;

import models.Permission;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PermissionDAO extends DBContext {
    
    // Map 1 row -> Permission
    private Permission mapRow(ResultSet rs) throws SQLException {
        Permission p = new Permission();
        p.setPermissionId(rs.getInt("permission_id"));
        p.setPermissionName(rs.getString("permission_name"));
        p.setDescription(rs.getString("description"));
        return p;
    }
    
    // Lấy tất cả permissions
    public List<Permission> getAllPermissions() throws SQLException {
        String sql = "SELECT permission_id, permission_name, description FROM Permissions ORDER BY permission_name";
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            List<Permission> list = new ArrayList<>();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
            return list;
        }
    }
    
    // Lấy permissions của 1 user
    public List<Permission> getPermissionsByUserId(int userId) throws SQLException {
        String sql = "SELECT p.permission_id, p.permission_name, p.description " +
                     "FROM Permissions p " +
                     "INNER JOIN UserPermissions up ON p.permission_id = up.permission_id " +
                     "WHERE up.user_id = ? " +
                     "ORDER BY p.permission_name";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                List<Permission> list = new ArrayList<>();
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
                return list;
            }
        }
    }
    
    // Lấy danh sách permission IDs của user (dùng cho checkbox)
    public List<Integer> getPermissionIdsByUserId(int userId) throws SQLException {
        String sql = "SELECT permission_id FROM UserPermissions WHERE user_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                List<Integer> list = new ArrayList<>();
                while (rs.next()) {
                    list.add(rs.getInt("permission_id"));
                }
                return list;
            }
        }
    }
    
    // Cập nhật permissions cho user (xóa hết rồi insert lại)
    public boolean updateUserPermissions(int userId, List<Integer> permissionIds) throws SQLException {
        String deleteSql = "DELETE FROM UserPermissions WHERE user_id = ?";
        String insertSql = "INSERT INTO UserPermissions (user_id, permission_id) VALUES (?, ?)";
        
        try {
            connection.setAutoCommit(false);
            
            // Bước 1: Xóa tất cả permissions cũ
            try (PreparedStatement ps = connection.prepareStatement(deleteSql)) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }
            
            // Bước 2: Insert permissions mới (nếu có)
            if (permissionIds != null && !permissionIds.isEmpty()) {
                try (PreparedStatement ps = connection.prepareStatement(insertSql)) {
                    for (Integer permId : permissionIds) {
                        ps.setInt(1, userId);
                        ps.setInt(2, permId);
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }
            
            connection.commit();
            return true;
            
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    // Kiểm tra user có permission không (để phân quyền trong app)
    public boolean hasPermission(int userId, String permissionName) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM UserPermissions up " +
                     "INNER JOIN Permissions p ON up.permission_id = p.permission_id " +
                     "WHERE up.user_id = ? AND p.permission_name = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, permissionName);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total") > 0;
                }
            }
        }
        return false;
    }
}