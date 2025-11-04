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
    
    
    // ✅ Lấy danh sách các lô có thể chọn (status: Approved hoặc Received)
  public List<Map<String, Object>> getAvailableBatches() {
    List<Map<String, Object>> list = new ArrayList<>();
    String sql = """
        SELECT 
            b.batch_id AS batchId,
            b.lot_number AS lotNumber,
            m.name AS medicineName,
            b.status AS status
        FROM Batches b
        JOIN Medicines m ON b.medicine_code = m.medicine_code
        WHERE b.status IN ('Approved', 'Received')
        ORDER BY m.name ASC, b.lot_number ASC;
    """;

    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Map<String, Object> row = new HashMap<>();
            row.put("batchId", rs.getInt("batchId"));
            row.put("lotNumber", rs.getString("lotNumber"));
            row.put("medicineName", rs.getString("medicineName"));
            row.put("status", rs.getString("status"));
            list.add(row);
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return list;
}

    
 
      // ✅ UPDATE batch info
    public boolean updateBatch(Batches batch) {
        String sql = "UPDATE Batches "
                   + "SET expiry_date = ?, current_quantity = ?, status = ? "
                   + "WHERE batch_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, batch.getExpiryDate());
            ps.setInt(2, batch.getCurrentQuantity());
            ps.setString(3, batch.getStatus());
            ps.setInt(4, batch.getBatchId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ DELETE batch
    public boolean deleteBatch(int batchId) {
        String sql = "DELETE FROM Batches WHERE batch_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, batchId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}



