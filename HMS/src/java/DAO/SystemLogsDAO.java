package DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.SystemLog;
import model.UserActivityReport;

/**
 * DAO for SystemLogs table - handles all database operations for activity logging
 */
public class SystemLogsDAO extends DBContext {
    
    /**
     * Map ResultSet to SystemLog object
     */
    private SystemLog mapRow(ResultSet rs) throws SQLException {
        SystemLog log = new SystemLog();
        log.setLogId(rs.getInt("log_id"));
        log.setUserId(rs.getInt("user_id"));
        log.setAction(rs.getString("action"));
        log.setTableName(rs.getString("table_name"));
        
        // Handle nullable integer
        int recordId = rs.getInt("record_id");
        if (!rs.wasNull()) {
            log.setRecordId(recordId);
        }
        
        log.setOldValue(rs.getString("old_value"));
        log.setNewValue(rs.getString("new_value"));
        log.setDetails(rs.getString("details"));
        log.setIpAddress(rs.getString("ip_address"));
        log.setLogDate(rs.getTimestamp("log_date"));
        
        // Extended fields if available
        try {
            log.setUsername(rs.getString("username"));
            log.setEmail(rs.getString("email"));
            log.setRole(rs.getString("role"));
        } catch (SQLException e) {
            // These fields might not exist in query, ignore
        }
        
        return log;
    }
    
    /**
     * Insert a new log entry
     */
    public boolean insertLog(SystemLog log) {
        String sql = "INSERT INTO SystemLogs (user_id, action, table_name, record_id, " +
                    "old_value, new_value, details, ip_address, log_date) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, log.getUserId());
            ps.setString(2, log.getAction());
            ps.setString(3, log.getTableName());
            
            if (log.getRecordId() != null) {
                ps.setInt(4, log.getRecordId());
            } else {
                ps.setNull(4, Types.INTEGER);
            }
            
            ps.setString(5, log.getOldValue());
            ps.setString(6, log.getNewValue());
            ps.setString(7, log.getDetails());
            ps.setString(8, log.getIpAddress());
            ps.setTimestamp(9, log.getLogDate());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Simple log method - most common use case
     */
    public boolean log(int userId, String action, String details, String ipAddress) {
        SystemLog log = new SystemLog(userId, action, details);
        log.setIpAddress(ipAddress);
        return insertLog(log);
    }
    
    /**
     * Get activity logs with filters using View
     */
    public List<SystemLog> getActivityLogs(String startDate, String endDate, 
                                           String role, String username, String action) 
            throws SQLException {
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT * FROM vw_UserActivityDetails WHERE 1=1 ");
        
        List<Object> params = new ArrayList<>();
        
        // Date range filter
        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append("AND activity_date >= ? ");
            params.add(startDate);
        }
        if (endDate != null && !endDate.trim().isEmpty()) {
            sql.append("AND activity_date <= ? ");
            params.add(endDate);
        }
        
        // Role filter
        if (role != null && !role.trim().isEmpty()) {
            sql.append("AND role = ? ");
            params.add(role);
        }
        
        // Username filter
        if (username != null && !username.trim().isEmpty()) {
            sql.append("AND username LIKE ? ");
            params.add("%" + username + "%");
        }
        
        // Action filter
        if (action != null && !action.trim().isEmpty()) {
            sql.append("AND action = ? ");
            params.add(action);
        }
        
        sql.append("ORDER BY log_date DESC");
        
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                List<SystemLog> logs = new ArrayList<>();
                while (rs.next()) {
                    logs.add(mapRow(rs));
                }
                return logs;
            }
        }
    }
    
    /**
     * Get User Activity Summary Report using Stored Procedure
     */
    public List<UserActivityReport> getUserActivitySummary(String startDate, String endDate, String role) 
            throws SQLException {
        
        String sql = "{CALL sp_GetUserActivitySummary(?, ?, ?)}";
        
        try (CallableStatement cs = connection.prepareCall(sql)) {
            // Set parameters
            if (startDate != null && !startDate.isEmpty()) {
                cs.setDate(1, Date.valueOf(startDate));
            } else {
                cs.setNull(1, Types.DATE);
            }
            
            if (endDate != null && !endDate.isEmpty()) {
                cs.setDate(2, Date.valueOf(endDate));
            } else {
                cs.setNull(2, Types.DATE);
            }
            
            if (role != null && !role.isEmpty()) {
                cs.setString(3, role);
            } else {
                cs.setNull(3, Types.NVARCHAR);
            }
            
            try (ResultSet rs = cs.executeQuery()) {
                List<UserActivityReport> reports = new ArrayList<>();
                
                while (rs.next()) {
                    UserActivityReport report = new UserActivityReport();
                    report.setUserId(rs.getInt("user_id"));
                    report.setUsername(rs.getString("username"));
                    report.setEmail(rs.getString("email"));
                    report.setRole(rs.getString("role"));
                    report.setTotalActions(rs.getInt("total_actions"));
                    report.setActiveDays(rs.getInt("active_days"));
                    report.setLoginCount(rs.getInt("login_count"));
                    report.setFirstActivity(rs.getTimestamp("first_activity"));
                    report.setLastActivity(rs.getTimestamp("last_activity"));
                    report.setMostCommonAction(rs.getString("most_common_action"));
                    
                    reports.add(report);
                }
                
                return reports;
            }
        }
    }
    
    /**
     * Get detailed activity report using Stored Procedure
     */
    public List<SystemLog> getDetailedActivityReport(String startDate, String endDate, 
                                                     String role, String username, String action) 
            throws SQLException {
        
        String sql = "{CALL sp_GetUserActivityReport(?, ?, ?, ?, ?)}";
        
        try (CallableStatement cs = connection.prepareCall(sql)) {
            // Set parameters
            if (startDate != null && !startDate.isEmpty()) {
                cs.setDate(1, Date.valueOf(startDate));
            } else {
                cs.setNull(1, Types.DATE);
            }
            
            if (endDate != null && !endDate.isEmpty()) {
                cs.setDate(2, Date.valueOf(endDate));
            } else {
                cs.setNull(2, Types.DATE);
            }
            
            if (role != null && !role.isEmpty()) {
                cs.setString(3, role);
            } else {
                cs.setNull(3, Types.NVARCHAR);
            }
            
            if (username != null && !username.isEmpty()) {
                cs.setString(4, username);
            } else {
                cs.setNull(4, Types.NVARCHAR);
            }
            
            if (action != null && !action.isEmpty()) {
                cs.setString(5, action);
            } else {
                cs.setNull(5, Types.NVARCHAR);
            }
            
            try (ResultSet rs = cs.executeQuery()) {
                List<SystemLog> logs = new ArrayList<>();
                while (rs.next()) {
                    logs.add(mapRow(rs));
                }
                return logs;
            }
        }
    }
    
    /**
     * Get logs by user ID
     */
    public List<SystemLog> getLogsByUserId(int userId, int limit) throws SQLException {
        String sql = "SELECT TOP (?) sl.*, u.username, u.email, u.role " +
                    "FROM SystemLogs sl " +
                    "INNER JOIN Users u ON sl.user_id = u.user_id " +
                    "WHERE sl.user_id = ? " +
                    "ORDER BY sl.log_date DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                List<SystemLog> logs = new ArrayList<>();
                while (rs.next()) {
                    logs.add(mapRow(rs));
                }
                return logs;
            }
        }
    }
    
    /**
     * Get recent logs (for dashboard)
     */
    public List<SystemLog> getRecentLogs(int limit) throws SQLException {
        String sql = "SELECT TOP (?) sl.*, u.username, u.email, u.role " +
                    "FROM SystemLogs sl " +
                    "INNER JOIN Users u ON sl.user_id = u.user_id " +
                    "ORDER BY sl.log_date DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, limit);
            
            try (ResultSet rs = ps.executeQuery()) {
                List<SystemLog> logs = new ArrayList<>();
                while (rs.next()) {
                    logs.add(mapRow(rs));
                }
                return logs;
            }
        }
    }
    
    /**
     * Get total log count
     */
    public int getTotalLogCount() throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM SystemLogs";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
            return 0;
        }
    }
    
    /**
     * Get log count by date range
     */
    public int getLogCountByDateRange(String startDate, String endDate) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM SystemLogs " +
                    "WHERE CAST(log_date AS DATE) BETWEEN ? AND ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(startDate));
            ps.setDate(2, Date.valueOf(endDate));
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
                return 0;
            }
        }
    }
    
    /**
     * Delete old logs (maintenance)
     */
    public int deleteOldLogs(int daysToKeep) throws SQLException {
        String sql = "DELETE FROM SystemLogs WHERE log_date < DATEADD(DAY, ?, GETDATE())";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, -daysToKeep);
            return ps.executeUpdate();
        }
    }
}