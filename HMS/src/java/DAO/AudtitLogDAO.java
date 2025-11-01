package DAO;

import model.AuditLog;
import model.AuditStatistics;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AudtitLogDAO extends DBContext {
    
    /**
     * Get audit logs with filters and pagination
     */
    public List<AuditLog> getAuditLogs(String startDate, String endDate, String username,
                                       String role, String action, String tableName,
                                       String riskLevel, String category,
                                       int pageNumber, int pageSize) {
        List<AuditLog> logs = new ArrayList<>();
        
        try {
            String sql = "{CALL sp_GetAuditLogs(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";

            CallableStatement cs = connection.prepareCall(sql);
            
            cs.setString(1, startDate != null && !startDate.isEmpty() ? startDate : null);
            cs.setString(2, endDate != null && !endDate.isEmpty() ? endDate : null);
            cs.setNull(3, Types.INTEGER); // userId
            cs.setString(4, username != null && !username.isEmpty() ? username : null);
            cs.setString(5, role != null && !role.isEmpty() ? role : null);
            cs.setString(6, action != null && !action.isEmpty() ? action : null);
            cs.setString(7, tableName != null && !tableName.isEmpty() ? tableName : null);
            cs.setString(8, riskLevel != null && !riskLevel.isEmpty() ? riskLevel : null);
            cs.setString(9, category != null && !category.isEmpty() ? category : null);
            cs.setInt(10, pageNumber);
            cs.setInt(11, pageSize);
            
            ResultSet rs = cs.executeQuery();
            
            while (rs.next()) {
                AuditLog log = new AuditLog();
                log.setLogId(rs.getInt("log_id"));
                log.setUserId(rs.getInt("user_id"));
                log.setUsername(rs.getString("username"));
                log.setEmail(rs.getString("email"));
                log.setRole(rs.getString("role"));
                log.setAction(rs.getString("action"));
                log.setTableName(rs.getString("table_name"));
                log.setRecordId(rs.getInt("record_id"));
                log.setOldValue(rs.getString("old_value"));
                log.setNewValue(rs.getString("new_value"));
                log.setDetails(rs.getString("details"));
                log.setIpAddress(rs.getString("ip_address"));
                log.setLogDate(rs.getTimestamp("log_date"));
                log.setRiskLevel(rs.getString("risk_level"));
                log.setCategory(rs.getString("category"));
                logs.add(log);
            }
            
            rs.close();
            cs.close();
        } catch (SQLException e) {
            System.err.println("Error getting audit logs: " + e.getMessage());
            e.printStackTrace();
        }
        
        return logs;
    }
    
    /**
     * Get total count for pagination
     */
    public int getTotalLogsCount(String startDate, String endDate, String username,
                                 String role, String action, String tableName,
                                 String riskLevel, String category) {
        int count = 0;
        try {
            StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM vw_AuditLogDetails WHERE 1=1");
            
            if (startDate != null && !startDate.isEmpty()) {
                sql.append(" AND log_date >= ?");
            }
            if (endDate != null && !endDate.isEmpty()) {
                sql.append(" AND log_date <= ?");
            }
            if (username != null && !username.isEmpty()) {
                sql.append(" AND username LIKE ?");
            }
            if (role != null && !role.isEmpty()) {
                sql.append(" AND role = ?");
            }
            if (action != null && !action.isEmpty()) {
                sql.append(" AND action = ?");
            }
            if (tableName != null && !tableName.isEmpty()) {
                sql.append(" AND table_name = ?");
            }
            if (riskLevel != null && !riskLevel.isEmpty()) {
                sql.append(" AND risk_level = ?");
            }
            if (category != null && !category.isEmpty()) {
                sql.append(" AND category = ?");
            }
            
            PreparedStatement ps = connection.prepareStatement(sql.toString());
            int paramIndex = 1;
            
            if (startDate != null && !startDate.isEmpty()) ps.setString(paramIndex++, startDate);
            if (endDate != null && !endDate.isEmpty()) ps.setString(paramIndex++, endDate);
            if (username != null && !username.isEmpty()) ps.setString(paramIndex++, "%" + username + "%");
            if (role != null && !role.isEmpty()) ps.setString(paramIndex++, role);
            if (action != null && !action.isEmpty()) ps.setString(paramIndex++, action);
            if (tableName != null && !tableName.isEmpty()) ps.setString(paramIndex++, tableName);
            if (riskLevel != null && !riskLevel.isEmpty()) ps.setString(paramIndex++, riskLevel);
            if (category != null && !category.isEmpty()) ps.setString(paramIndex++, category);
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
            
            rs.close();
            ps.close();
        } catch (SQLException e) {
            System.err.println("Error getting logs count: " + e.getMessage());
        }
        return count;
    }
    
    /**
     * Get audit statistics
     */
    public AuditStatistics getAuditStatistics(String startDate, String endDate) {
        AuditStatistics stats = new AuditStatistics();
        
        try {
            String sql = "{CALL sp_GetAuditStatistics(?, ?)}";
            CallableStatement cs = connection.prepareCall(sql);
            
            cs.setString(1, startDate);
            cs.setString(2, endDate);
            
            // First result set: overall statistics
            ResultSet rs = cs.executeQuery();
            if (rs.next()) {
                stats.setTotalActions(rs.getInt("total_actions"));
                stats.setActiveUsers(rs.getInt("active_users"));
                stats.setAffectedTables(rs.getInt("affected_tables"));
                stats.setActiveDays(rs.getInt("active_days"));
                stats.setTotalLogins(rs.getInt("total_logins"));
                stats.setTotalCreates(rs.getInt("total_creates"));
                stats.setTotalUpdates(rs.getInt("total_updates"));
                stats.setTotalDeletes(rs.getInt("total_deletes"));
                stats.setTotalApprovals(rs.getInt("total_approvals"));
            }
            
            rs.close();
            cs.close();
        } catch (SQLException e) {
            System.err.println("Error getting audit statistics: " + e.getMessage());
            e.printStackTrace();
        }
        
        return stats;
    }
    
    /**
     * Export audit report
     */
    public int exportAuditReport(int auditorId, String startDate, String endDate, 
                                 String reportType, String exportFormat) {
        int reportId = 0;
        
        try {
            String sql = "{CALL sp_ExportAuditReport(?, ?, ?, ?, ?)}";
            CallableStatement cs = connection.prepareCall(sql);
            
            cs.setInt(1, auditorId);
            cs.setString(2, startDate);
            cs.setString(3, endDate);
            cs.setString(4, reportType);
            cs.setString(5, exportFormat);
            
            ResultSet rs = cs.executeQuery();
            if (rs.next()) {
                reportId = rs.getInt("report_id");
            }
            
            rs.close();
            cs.close();
        } catch (SQLException e) {
            System.err.println("Error exporting audit report: " + e.getMessage());
            e.printStackTrace();
        }
        
        return reportId;
    }
    
    /**
     * Get suspicious activities
     */
    public List<String> getSuspiciousActivities(int hours) {
        List<String> alerts = new ArrayList<>();
        
        try {
            String sql = "{CALL sp_DetectSuspiciousActivities(?)}";
            CallableStatement cs = connection.prepareCall(sql);
            cs.setInt(1, hours);
            
            ResultSet rs = cs.executeQuery();
            
            while (rs.next()) {
                String alert = String.format("[%s] User: %s (%s) - Count: %d",
                    rs.getString("alert_type"),
                    rs.getString("username"),
                    rs.getString("role"),
                    rs.getInt(4)); // Count column (varies by query)
                alerts.add(alert);
            }
            
            rs.close();
            cs.close();
        } catch (SQLException e) {
            System.err.println("Error getting suspicious activities: " + e.getMessage());
            e.printStackTrace();
        }
        
        return alerts;
    }
    
    /**
     * Get distinct values for filters
     */
    public List<String> getDistinctActions() {
        List<String> actions = new ArrayList<>();
        try {
            String sql = "SELECT DISTINCT action FROM SystemLogs ORDER BY action";
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                actions.add(rs.getString("action"));
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return actions;
    }
    
    public List<String> getDistinctTableNames() {
        List<String> tables = new ArrayList<>();
        try {
            String sql = "SELECT DISTINCT table_name FROM SystemLogs WHERE table_name IS NOT NULL ORDER BY table_name";
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                tables.add(rs.getString("table_name"));
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tables;
    }
    
    public List<String> getDistinctRoles() {
        List<String> roles = new ArrayList<>();
        try {
            String sql = "SELECT DISTINCT role FROM Users ORDER BY role";
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                roles.add(rs.getString("role"));
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return roles;
    }
}