package DAO;

import model.ExpiryReport;
import model.InventoryReport;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import java.util.LinkedHashMap;
import java.util.Map;

public class ReportDAO extends DBContext {

    // =========================================
    // EXPIRY REPORT
    // =========================================
    
    /**
     * Get medicines expiring soon with filters
     * @param daysThreshold - số ngày từ hôm nay để check hạn sử dụng
     * @param statusFilter - filter theo status (null = all, "Approved", "Quarantined", etc.)
     * @return List of expiry records
     */
    public List<ExpiryReport> getExpiryReport(int daysThreshold, String statusFilter) {
        List<ExpiryReport> reports = new ArrayList<>();
        
        String query = "SELECT b.batch_id, m.medicine_id, m.name, m.category, " +
                      "b.lot_number, b.expiry_date, b.current_quantity, " +
                      "s.name as supplier_name, b.status, " +
                      "DATEDIFF(DAY, CAST(GETDATE() AS DATE), b.expiry_date) as days_until_expiry " +
                      "FROM Batches b " +
                      "INNER JOIN Medicines m ON b.medicine_id = m.medicine_id " +
                      "LEFT JOIN Suppliers s ON b.supplier_id = s.supplier_id " +
                      "WHERE b.status NOT IN ('Expired', 'Rejected') " +
                      "  AND DATEDIFF(DAY, CAST(GETDATE() AS DATE), b.expiry_date) <= ? " +
                      "  AND DATEDIFF(DAY, CAST(GETDATE() AS DATE), b.expiry_date) >= 0 ";
        
        if (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equals("All")) {
            query += "  AND b.status = ? ";
        }
        
        query += "ORDER BY b.expiry_date ASC";
        
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            int paramIndex = 1;
            ps.setInt(paramIndex++, daysThreshold);
            if (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equals("All")) {
                ps.setString(paramIndex++, statusFilter);
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ExpiryReport report = new ExpiryReport();
                report.setBatchId(rs.getInt("batch_id"));
                report.setMedicineId(rs.getInt("medicine_id"));
                report.setMedicineName(rs.getString("name"));
                report.setCategory(rs.getString("category"));
                report.setLotNumber(rs.getString("lot_number"));
                report.setExpiryDate(rs.getDate("expiry_date"));
                report.setCurrentQuantity(rs.getInt("current_quantity"));
                report.setSupplierName(rs.getString("supplier_name"));
                report.setStatus(rs.getString("status"));
                report.setDaysUntilExpiry(rs.getInt("days_until_expiry"));
                
                reports.add(report);
            }
            System.out.println("Loaded " + reports.size() + " expiry records (threshold: " + daysThreshold + " days, status: " + statusFilter + ")");
        } catch (SQLException e) {
            System.err.println("Error getting expiry report: " + e.getMessage());
            e.printStackTrace();
        }
        return reports;
    }

    /**
     * Get expiry report with date range
     */
    public List<ExpiryReport> getExpiryReportByDateRange(Date startDate, Date endDate, String statusFilter) {
        List<ExpiryReport> reports = new ArrayList<>();
        
        String query = "SELECT b.batch_id, m.medicine_id, m.name, m.category, " +
                      "b.lot_number, b.expiry_date, b.current_quantity, " +
                      "s.name as supplier_name, b.status, " +
                      "DATEDIFF(DAY, CAST(GETDATE() AS DATE), b.expiry_date) as days_until_expiry " +
                      "FROM Batches b " +
                      "INNER JOIN Medicines m ON b.medicine_id = m.medicine_id " +
                      "LEFT JOIN Suppliers s ON b.supplier_id = s.supplier_id " +
                      "WHERE b.status NOT IN ('Expired', 'Rejected') " +
                      "  AND b.expiry_date BETWEEN ? AND ? ";
        
        if (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equals("All")) {
            query += "  AND b.status = ? ";
        }
        
        query += "ORDER BY b.expiry_date ASC";
        
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            int paramIndex = 1;
            ps.setDate(paramIndex++, startDate);
            ps.setDate(paramIndex++, endDate);
            if (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equals("All")) {
                ps.setString(paramIndex++, statusFilter);
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ExpiryReport report = new ExpiryReport();
                report.setBatchId(rs.getInt("batch_id"));
                report.setMedicineId(rs.getInt("medicine_id"));
                report.setMedicineName(rs.getString("name"));
                report.setCategory(rs.getString("category"));
                report.setLotNumber(rs.getString("lot_number"));
                report.setExpiryDate(rs.getDate("expiry_date"));
                report.setCurrentQuantity(rs.getInt("current_quantity"));
                report.setSupplierName(rs.getString("supplier_name"));
                report.setStatus(rs.getString("status"));
                report.setDaysUntilExpiry(rs.getInt("days_until_expiry"));
                
                reports.add(report);
            }
        } catch (SQLException e) {
            System.err.println("Error getting expiry report by date range: " + e.getMessage());
            e.printStackTrace();
        }
        return reports;
    }

    /**
     * Get expiry statistics
     */
    public Map<String, Integer> getExpiryStatistics(int daysThreshold, String statusFilter) {
        Map<String, Integer> stats = new LinkedHashMap<>();
        stats.put("Critical (0-7 days)", 0);
        stats.put("High (8-14 days)", 0);
        stats.put("Medium (15-30 days)", 0);
        stats.put("Total", 0);
        
        String query = "SELECT COUNT(*) as count, " +
                      "CASE WHEN DATEDIFF(DAY, CAST(GETDATE() AS DATE), b.expiry_date) <= 7 THEN 'Critical' " +
                      "     WHEN DATEDIFF(DAY, CAST(GETDATE() AS DATE), b.expiry_date) <= 14 THEN 'High' " +
                      "     ELSE 'Medium' END as alert_level " +
                      "FROM Batches b " +
                      "WHERE b.status NOT IN ('Expired', 'Rejected') " +
                      "  AND DATEDIFF(DAY, CAST(GETDATE() AS DATE), b.expiry_date) <= ? " +
                      "  AND DATEDIFF(DAY, CAST(GETDATE() AS DATE), b.expiry_date) >= 0 ";
        
        if (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equals("All")) {
            query += "  AND b.status = ? ";
        }
        
        query += "GROUP BY CASE WHEN DATEDIFF(DAY, CAST(GETDATE() AS DATE), b.expiry_date) <= 7 THEN 'Critical' " +
                "            WHEN DATEDIFF(DAY, CAST(GETDATE() AS DATE), b.expiry_date) <= 14 THEN 'High' " +
                "            ELSE 'Medium' END";
        
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            int paramIndex = 1;
            ps.setInt(paramIndex++, daysThreshold);
            if (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equals("All")) {
                ps.setString(paramIndex++, statusFilter);
            }
            
            ResultSet rs = ps.executeQuery();
            int total = 0;
            while (rs.next()) {
                String level = rs.getString("alert_level");
                int count = rs.getInt("count");
                stats.put(level + " (" + count + ")", count);
                total += count;
            }
            stats.put("Total", total);
        } catch (SQLException e) {
            System.err.println("Error getting expiry statistics: " + e.getMessage());
            e.printStackTrace();
        }
        return stats;
    }

    /**
     * Get all expired medicines
     */
    public List<ExpiryReport> getExpiredMedicines() {
        List<ExpiryReport> reports = new ArrayList<>();
        
        String query = "SELECT b.batch_id, m.medicine_id, m.name, m.category, " +
                      "b.lot_number, b.expiry_date, b.current_quantity, " +
                      "s.name as supplier_name, b.status, " +
                      "DATEDIFF(DAY, b.expiry_date, CAST(GETDATE() AS DATE)) as days_expired " +
                      "FROM Batches b " +
                      "INNER JOIN Medicines m ON b.medicine_id = m.medicine_id " +
                      "LEFT JOIN Suppliers s ON b.supplier_id = s.supplier_id " +
                      "WHERE b.status = 'Expired' OR b.expiry_date < CAST(GETDATE() AS DATE) " +
                      "ORDER BY b.expiry_date DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                ExpiryReport report = new ExpiryReport();
                report.setBatchId(rs.getInt("batch_id"));
                report.setMedicineId(rs.getInt("medicine_id"));
                report.setMedicineName(rs.getString("name"));
                report.setCategory(rs.getString("category"));
                report.setLotNumber(rs.getString("lot_number"));
                report.setExpiryDate(rs.getDate("expiry_date"));
                report.setCurrentQuantity(rs.getInt("current_quantity"));
                report.setSupplierName(rs.getString("supplier_name"));
                report.setStatus(rs.getString("status"));
                report.setDaysUntilExpiry(rs.getInt("days_expired"));
                
                reports.add(report);
            }
        } catch (SQLException e) {
            System.err.println("Error getting expired medicines: " + e.getMessage());
            e.printStackTrace();
        }
        return reports;
    }

    // =========================================
    // INVENTORY REPORT
    // =========================================
    
    /**
     * Get comprehensive inventory report
     */
    public List<InventoryReport> getInventoryReport() {
        List<InventoryReport> reports = new ArrayList<>();
        
        String query = "SELECT m.medicine_id, m.name, m.category, " +
                      "COUNT(DISTINCT b.batch_id) as total_batches, " +
                      "SUM(CASE WHEN b.status NOT IN ('Expired', 'Rejected') " +
                      "         THEN b.current_quantity ELSE 0 END) as total_quantity, " +
                      "SUM(CASE WHEN b.status = 'Approved' " +
                      "         THEN b.current_quantity ELSE 0 END) as approved_quantity, " +
                      "SUM(CASE WHEN b.status = 'Quarantined' " +
                      "         THEN b.current_quantity ELSE 0 END) as quarantined_quantity, " +
                      "MIN(b.expiry_date) as nearest_expiry, " +
                      "MAX(b.received_date) as last_received " +
                      "FROM Medicines m " +
                      "LEFT JOIN Batches b ON m.medicine_id = b.medicine_id " +
                      "GROUP BY m.medicine_id, m.name, m.category " +
                      "ORDER BY m.category, m.name";
        
        try (PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                InventoryReport report = new InventoryReport();
                report.setMedicineId(rs.getInt("medicine_id"));
                report.setMedicineName(rs.getString("name"));
                report.setCategory(rs.getString("category"));
                report.setTotalBatches(rs.getInt("total_batches"));
                report.setTotalQuantity(rs.getInt("total_quantity"));
                report.setApprovedQuantity(rs.getInt("approved_quantity"));
                report.setQuarantinedQuantity(rs.getInt("quarantined_quantity"));
                report.setNearestExpiry(rs.getDate("nearest_expiry"));
                report.setLastReceived(rs.getDate("last_received"));
                
                reports.add(report);
            }
        } catch (SQLException e) {
            System.err.println("Error getting inventory report: " + e.getMessage());
            e.printStackTrace();
        }
        return reports;
    }

    /**
     * Get inventory statistics
     */
    public Map<String, Object> getInventoryStatistics() {
        Map<String, Object> stats = new LinkedHashMap<>();
        
        String query = "SELECT COUNT(DISTINCT m.medicine_id) as total_medicines, " +
                      "COUNT(DISTINCT b.batch_id) as total_batches, " +
                      "SUM(CASE WHEN b.status NOT IN ('Expired', 'Rejected') " +
                      "         THEN b.current_quantity ELSE 0 END) as total_quantity, " +
                      "SUM(CASE WHEN b.status = 'Approved' " +
                      "         THEN b.current_quantity ELSE 0 END) as approved_quantity, " +
                      "SUM(CASE WHEN b.status = 'Quarantined' " +
                      "         THEN b.current_quantity ELSE 0 END) as quarantined_quantity " +
                      "FROM Medicines m " +
                      "LEFT JOIN Batches b ON m.medicine_id = b.medicine_id";
        
        try (PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                stats.put("totalMedicines", rs.getInt("total_medicines"));
                stats.put("totalBatches", rs.getInt("total_batches"));
                stats.put("totalQuantity", rs.getInt("total_quantity"));
                stats.put("approvedQuantity", rs.getInt("approved_quantity"));
                stats.put("quarantinedQuantity", rs.getInt("quarantined_quantity"));
            }
        } catch (SQLException e) {
            System.err.println("Error getting inventory statistics: " + e.getMessage());
            e.printStackTrace();
        }
        return stats;
    }

    /**
     * Get inventory by supplier
     */
    public List<InventoryReport> getInventoryBySupplier() {
        List<InventoryReport> reports = new ArrayList<>();
        
        String query = "SELECT s.supplier_id, s.name as supplier_name, " +
                      "COUNT(DISTINCT b.batch_id) as total_batches, " +
                      "SUM(CASE WHEN b.status NOT IN ('Expired', 'Rejected') " +
                      "         THEN b.current_quantity ELSE 0 END) as total_quantity, " +
                      "COUNT(DISTINCT m.medicine_id) as medicine_types " +
                      "FROM Suppliers s " +
                      "LEFT JOIN Batches b ON s.supplier_id = b.supplier_id " +
                      "LEFT JOIN Medicines m ON b.medicine_id = m.medicine_id " +
                      "GROUP BY s.supplier_id, s.name " +
                      "ORDER BY total_quantity DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                InventoryReport report = new InventoryReport();
                report.setSupplierId(rs.getInt("supplier_id"));
                report.setSupplierName(rs.getString("supplier_name"));
                report.setTotalBatches(rs.getInt("total_batches"));
                report.setTotalQuantity(rs.getInt("total_quantity"));
                report.setMedicineTypes(rs.getInt("medicine_types"));
                
                reports.add(report);
            }
        } catch (SQLException e) {
            System.err.println("Error getting supplier inventory: " + e.getMessage());
            e.printStackTrace();
        }
        return reports;
    }

    /**
     * Get batch-level inventory details with date range filter
     */
    public List<InventoryReport> getBatchInventoryDetails(Date startDate, Date endDate) {
        List<InventoryReport> reports = new ArrayList<>();
        
        String query = "SELECT b.batch_id, m.medicine_id, m.name as medicine_name, " +
                      "b.lot_number, b.status, b.current_quantity, " +
                      "b.expiry_date, b.received_date, " +
                      "s.name as supplier_name " +
                      "FROM Batches b " +
                      "INNER JOIN Medicines m ON b.medicine_id = m.medicine_id " +
                      "LEFT JOIN Suppliers s ON b.supplier_id = s.supplier_id " +
                      "WHERE b.status NOT IN ('Rejected') ";
        
        if (startDate != null && endDate != null) {
            query += "AND b.received_date BETWEEN ? AND ? ";
        }
        
        query += "ORDER BY m.name, b.expiry_date ASC";
        
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            int paramIndex = 1;
            if (startDate != null && endDate != null) {
                ps.setDate(paramIndex++, startDate);
                ps.setDate(paramIndex++, endDate);
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                InventoryReport report = new InventoryReport();
                report.setBatchId(rs.getInt("batch_id"));
                report.setMedicineId(rs.getInt("medicine_id"));
                report.setMedicineName(rs.getString("medicine_name"));
                report.setLotNumber(rs.getString("lot_number"));
                report.setStatus(rs.getString("status"));
                report.setCurrentQuantity(rs.getInt("current_quantity"));
                report.setExpiryDate(rs.getDate("expiry_date"));
                report.setReceivedDate(rs.getDate("received_date"));
                report.setSupplierName(rs.getString("supplier_name"));
                
                reports.add(report);
            }
        } catch (SQLException e) {
            System.err.println("Error getting batch inventory: " + e.getMessage());
            e.printStackTrace();
        }
        return reports;
    }
}