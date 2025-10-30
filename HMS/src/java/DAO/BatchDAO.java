package DAO;

import java.sql.*;
import java.util.*;
import DAO.DBContext;
import model.Batches;

public class BatchDAO extends DBContext {

    public List<Map<String, Object>> getBatchList() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT 
                b.batch_id AS batchId,
                b.lot_number AS lotNumber,
                m.name AS medicineName,
                s.name AS supplierName,
                b.received_date AS receivedDate,   -- 🆕 thêm cột này
                b.expiry_date AS expiryDate,
                b.initial_quantity AS initialQuantity,
                b.current_quantity AS currentQuantity,
                poi.unit_price AS unitPrice,
                b.status AS status
            FROM Batches b
            JOIN Medicines m ON b.medicine_code = m.medicine_code
            JOIN Suppliers s ON b.supplier_id = s.supplier_id
            LEFT JOIN PurchaseOrderItems poi 
                ON b.medicine_code = poi.medicine_code
            ORDER BY b.batch_id DESC;
        """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("batchId", rs.getInt("batchId"));
                row.put("lotNumber", rs.getString("lotNumber"));
                row.put("medicineName", rs.getString("medicineName"));
                row.put("supplierName", rs.getString("supplierName"));
                row.put("receivedDate", rs.getDate("receivedDate")); // 🆕 thêm dòng này
                row.put("expiryDate", rs.getDate("expiryDate"));
                row.put("initialQuantity", rs.getInt("initialQuantity"));
                row.put("currentQuantity", rs.getInt("currentQuantity"));
                row.put("unitPrice", rs.getBigDecimal("unitPrice"));
                row.put("status", rs.getString("status"));
                list.add(row);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
    
   //--------- Add batch -------------

    public boolean addBatch(Batches batch) throws SQLException {
        // 1. Lấy unit_price từ PurchaseOrderItem
        String priceQuery = "SELECT TOP 1 unitPrice FROM PurchaseOrderItem WHERE medicineCode = ? ORDER BY poItemId DESC";
        double unitPrice = 0;
        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(priceQuery)) {
            ps.setString(1, batch.getMedicineCode());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                unitPrice = rs.getDouble("unitPrice");
            } else {
                throw new SQLException("Không tìm thấy unitPrice cho medicineCode: " + batch.getMedicineCode());
            }
        }

        // 2. Chèn lô thuốc mới vào bảng Batches
        String insertQuery = "INSERT INTO Batches (medicineCode, supplierId, lotNumber, expiryDate, receivedDate, initialQuantity, currentQuantity, status, quarantineNotes, createdAt, updatedAt) " +
                             "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
                PreparedStatement ps = conn.prepareStatement(insertQuery)) {
            ps.setString(1, batch.getMedicineCode());
            ps.setInt(2, batch.getSupplierId());
            ps.setString(3, batch.getLotNumber());
            ps.setDate(4, batch.getExpiryDate());
            ps.setDate(5, batch.getReceivedDate());
            ps.setInt(6, batch.getInitialQuantity());
            ps.setInt(7, batch.getInitialQuantity()); // currentQuantity = initialQuantity
            ps.setString(8, "Active"); // default status
            ps.setString(9, batch.getQuarantineNotes());
            Timestamp now = new Timestamp(System.currentTimeMillis());
            ps.setTimestamp(10, now); // createdAt
            ps.setTimestamp(11, now); // updatedAt

            int affected = ps.executeUpdate();
            return affected > 0;
        }
    }
}


