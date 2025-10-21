package DAO;

import model.Batches;
import java.sql.*;
import java.util.*;

public class BatchDAO {
    private DBContext dbContext = new DBContext();

    public List<Map<String, Object>> getAllBatches() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT b.batch_id, b.medicine_id, b.supplier_id, b.lot_number,
                   b.expiry_date, b.initial_quantity, b.current_quantity, b.status,
                   m.name AS medicine_name, s.name AS supplier_name
            FROM Batches b
            LEFT JOIN Medicines m ON b.medicine_id = m.medicine_id
            LEFT JOIN Suppliers s ON b.supplier_id = s.supplier_id
            ORDER BY b.created_at DESC
        """;

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("batchId", rs.getInt("batch_id"));
                row.put("medicineName", rs.getString("medicine_name"));
                row.put("supplierName", rs.getString("supplier_name"));
                row.put("lotNumber", rs.getString("lot_number"));
                row.put("expiryDate", rs.getDate("expiry_date"));
                row.put("initialQuantity", rs.getInt("initial_quantity"));
                row.put("currentQuantity", rs.getInt("current_quantity"));
                row.put("status", rs.getString("status"));
                list.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
     // ✅ Lấy thông tin một batch theo ID
    public Batches getBatchById(int batchId) {
        String sql = "SELECT * FROM Batches WHERE batch_id = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, batchId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Batches b = new Batches();
                    b.setBatchId(rs.getInt("batch_id"));
                    b.setMedicineId(rs.getInt("medicine_id"));
                    b.setSupplierId(rs.getInt("supplier_id"));
                    b.setLotNumber(rs.getString("lot_number"));
                    b.setExpiryDate(rs.getDate("expiry_date"));
                    b.setInitialQuantity(rs.getInt("initial_quantity"));
                    b.setCurrentQuantity(rs.getInt("current_quantity"));
                    b.setStatus(rs.getString("status"));
                    return b;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ✅ Cập nhật số lượng & trạng thái sau khi ghi nhận thuốc hư/hết hạn
    public boolean updateBatchAfterRecord(int batchId, int quantity, String reason) {
        String newStatus = (reason.equalsIgnoreCase("Expired")) ? "Expired" : "Damaged";

        String sql = """
            UPDATE Batches
            SET current_quantity = CASE
                    WHEN current_quantity - ? < 0 THEN 0
                    ELSE current_quantity - ?
                END,
                status = CASE
                    WHEN current_quantity - ? <= 0 THEN ?
                    ELSE status
                END,
                updated_at = GETDATE()
            WHERE batch_id = ?
        """;

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quantity);
            ps.setInt(2, quantity);
            ps.setInt(3, quantity);
            ps.setString(4, newStatus);
            ps.setInt(5, batchId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ✅ Cập nhật trực tiếp trạng thái batch (nếu cần)
    public boolean updateBatchStatus(int batchId, String status) {
        String sql = "UPDATE Batches SET status = ?, updated_at = GETDATE() WHERE batch_id = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, batchId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}

