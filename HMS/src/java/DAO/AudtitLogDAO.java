package DAO;

import model.AuditLog;
import model.AuditStatistics;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AudtitLogDAO extends DBContext {

    /**
     * ✅ FIXED: Get audit logs with filters and pagination
     * Returns Map with logs + totalRecords
     */
    public Map<String, Object> getAuditLogsWithTotal(int currentUserId, String startDate, String endDate,
            String username, String role, String action,
            String tableName, String riskLevel, String category,
            int pageNumber, int pageSize) {
        
        Map<String, Object> result = new HashMap<>();
        List<AuditLog> logs = new ArrayList<>();
        int totalRecords = 0;

        try {
            String sql = "{CALL sp_GetAuditLogs(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";
            CallableStatement cs = connection.prepareCall(sql);

            // Parameter 1: @CurrentUserId
            cs.setInt(1, currentUserId);

            // Parameter 2-3: Date range
            if (startDate != null && !startDate.isEmpty()) {
                cs.setString(2, startDate);
            } else {
                cs.setNull(2, Types.VARCHAR);
            }

            if (endDate != null && !endDate.isEmpty()) {
                cs.setString(3, endDate);
            } else {
                cs.setNull(3, Types.VARCHAR);
            }

            // Parameter 4: @TargetUserId
            cs.setNull(4, Types.INTEGER);

            // Parameter 5-10: Filters
            if (username != null && !username.isEmpty()) {
                cs.setString(5, username);
            } else {
                cs.setNull(5, Types.VARCHAR);
            }

            if (role != null && !role.isEmpty()) {
                cs.setString(6, role);
            } else {
                cs.setNull(6, Types.VARCHAR);
            }

            if (action != null && !action.isEmpty()) {
                cs.setString(7, action);
            } else {
                cs.setNull(7, Types.VARCHAR);
            }

            if (tableName != null && !tableName.isEmpty()) {
                cs.setString(8, tableName);
            } else {
                cs.setNull(8, Types.VARCHAR);
            }

            if (riskLevel != null && !riskLevel.isEmpty()) {
                cs.setString(9, riskLevel);
            } else {
                cs.setNull(9, Types.VARCHAR);
            }

            if (category != null && !category.isEmpty()) {
                cs.setString(10, category);
            } else {
                cs.setNull(10, Types.VARCHAR);
            }

            // Parameter 11-12: Pagination
            cs.setInt(11, pageNumber);
            cs.setInt(12, pageSize);

            ResultSet rs = cs.executeQuery();

            // Check for error
            if (rs.next()) {
                try {
                    String status = rs.getString("status");
                    if ("ERROR".equals(status)) {
                        System.err.println("Access denied: " + rs.getString("message"));
                        rs.close();
                        cs.close();
                        result.put("logs", logs);
                        result.put("totalRecords", 0);
                        return result;
                    }
                } catch (SQLException e) {
                    // Not error, process data
                }

                // ✅ GET TOTAL_RECORDS FROM FIRST ROW
                do {
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
                    
                    // ✅ GET TOTAL FROM EVERY ROW (same value)
                    if (totalRecords == 0) {
                        totalRecords = rs.getInt("total_records");
                    }
                    
                    logs.add(log);
                } while (rs.next());
            }

            rs.close();
            cs.close();
        } catch (SQLException e) {
            System.err.println("Error getting audit logs: " + e.getMessage());
            e.printStackTrace();
        }

        result.put("logs", logs);
        result.put("totalRecords", totalRecords);
        return result;
    }

    // ✅ DEPRECATED: Keep for backward compatibility
    @Deprecated
    public List<AuditLog> getAuditLogs(int currentUserId, String startDate, String endDate,
            String username, String role, String action,
            String tableName, String riskLevel, String category,
            int pageNumber, int pageSize) {
        Map<String, Object> result = getAuditLogsWithTotal(currentUserId, startDate, endDate,
                username, role, action, tableName, riskLevel, category, pageNumber, pageSize);
        return (List<AuditLog>) result.get("logs");
    }

    /**
     * Get total count for pagination UPDATED: Added currentUserId and
     * role-based filtering
     */
    public int getTotalLogsCount(int currentUserId, String currentUserRole,
            String startDate, String endDate, String username,
            String role, String action, String tableName,
            String riskLevel, String category) {
        int count = 0;
        try {
            StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM vw_AuditLogDetails WHERE 1=1");

            // If Auditor, only count their own logs
            if ("Auditor".equals(currentUserRole)) {
                sql.append(" AND user_id = ?");
            }

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

            // Add currentUserId if Auditor
            if ("Auditor".equals(currentUserRole)) {
                ps.setInt(paramIndex++, currentUserId);
            }

            if (startDate != null && !startDate.isEmpty()) {
                ps.setString(paramIndex++, startDate);
            }
            if (endDate != null && !endDate.isEmpty()) {
                ps.setString(paramIndex++, endDate);
            }
            if (username != null && !username.isEmpty()) {
                ps.setString(paramIndex++, "%" + username + "%");
            }
            if (role != null && !role.isEmpty()) {
                ps.setString(paramIndex++, role);
            }
            if (action != null && !action.isEmpty()) {
                ps.setString(paramIndex++, action);
            }
            if (tableName != null && !tableName.isEmpty()) {
                ps.setString(paramIndex++, tableName);
            }
            if (riskLevel != null && !riskLevel.isEmpty()) {
                ps.setString(paramIndex++, riskLevel);
            }
            if (category != null && !category.isEmpty()) {
                ps.setString(paramIndex++, category);
            }

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
     * Get audit statistics UPDATED: Added currentUserId parameter
     */
    public AuditStatistics getAuditStatistics(int currentUserId, String startDate, String endDate) {
        AuditStatistics stats = new AuditStatistics();

        try {
            String sql = "{CALL sp_GetAuditStatistics(?, ?, ?)}";
            CallableStatement cs = connection.prepareCall(sql);

            // Parameter 1: @CurrentUserId
            cs.setInt(1, currentUserId);

            // Parameter 2-3: Date range
            if (startDate != null && !startDate.isEmpty()) {
                cs.setString(2, startDate);
            } else {
                cs.setNull(2, Types.VARCHAR);
            }

            if (endDate != null && !endDate.isEmpty()) {
                cs.setString(3, endDate);
            } else {
                cs.setNull(3, Types.VARCHAR);
            }

            // First result set: overall statistics
            ResultSet rs = cs.executeQuery();
            if (rs.next()) {
                // Check for error
                try {
                    String status = rs.getString("status");
                    if ("ERROR".equals(status)) {
                        String message = rs.getString("message");
                        System.err.println("Access denied: " + message);
                        rs.close();
                        cs.close();
                        return stats;
                    }
                } catch (SQLException e) {
                    // Not an error, continue
                }

                stats.setTotalActions(rs.getInt("total_actions"));
                stats.setActiveUsers(rs.getInt("active_users"));
                stats.setAffectedTables(rs.getInt("affected_tables"));
                stats.setActiveDays(rs.getInt("active_days"));
                stats.setPurchaseOrderActions(rs.getInt("purchase_order_actions"));
stats.setInvoiceActions(rs.getInt("invoice_actions"));
stats.setShippingActions(rs.getInt("shipping_actions"));
stats.setDeliveryActions(rs.getInt("delivery_actions"));
stats.setInventoryActions(rs.getInt("inventory_actions"));
stats.setTotalRejections(rs.getInt("total_rejections"));
stats.setManagerActions(rs.getInt("manager_actions"));
stats.setSupplierActions(rs.getInt("supplier_actions"));
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
     * Export audit report (No changes needed - auditor_id already included)
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
     * Get suspicious activities (No changes needed)
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
                        rs.getInt(4));
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
     * Get distinct values for filters UPDATED: Filter based on user role
     */
    public List<String> getDistinctActions(int currentUserId, String currentUserRole) {
        List<String> actions = new ArrayList<>();
        try {
            String sql = "SELECT DISTINCT action FROM SystemLogs WHERE 1=1";

            // If Auditor, only show actions from their own logs
            if ("Auditor".equals(currentUserRole)) {
                sql += " AND user_id = ?";
            }
            sql += " ORDER BY action";

            PreparedStatement ps = connection.prepareStatement(sql);

            if ("Auditor".equals(currentUserRole)) {
                ps.setInt(1, currentUserId);
            }

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

    public List<String> getDistinctTableNames(int currentUserId, String currentUserRole) {
        List<String> tables = new ArrayList<>();
        try {
            String sql = "SELECT DISTINCT table_name FROM SystemLogs WHERE table_name IS NOT NULL";

            // If Auditor, only show tables from their own logs
            if ("Auditor".equals(currentUserRole)) {
                sql += " AND user_id = ?";
            }
            sql += " ORDER BY table_name";

            PreparedStatement ps = connection.prepareStatement(sql);

            if ("Auditor".equals(currentUserRole)) {
                ps.setInt(1, currentUserId);
            }

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
