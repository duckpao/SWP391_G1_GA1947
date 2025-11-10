package DAO;

import java.sql.*;
import java.util.*;
import DAO.DBContext;
import model.Batches;
import model.Medicine;
import model.Supplier;

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
  
// Lọc lô thuốc theo tiêu chí
    public List<Map<String, Object>> filterBatches(String lotNumber, String medicineCode, String supplierId) throws SQLException {
        StringBuilder sql = new StringBuilder(
            "SELECT b.lot_number, b.medicine_code, m.name AS medicine_name, " +
            "b.supplier_id, s.name AS supplier_name, b.received_date, b.expiry_date, " +
            "b.initial_quantity, b.current_quantity, b.status, b.quarantine_notes " +
            "FROM Batches b " +
            "JOIN Medicines m ON b.medicine_code = m.medicine_code " +
            "JOIN Suppliers s ON b.supplier_id = s.supplier_id WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();
        if (lotNumber != null && !lotNumber.isEmpty()) {
            sql.append(" AND b.lot_number LIKE ? ");
            params.add("%" + lotNumber + "%");
        }
        if (medicineCode != null && !medicineCode.isEmpty()) {
            sql.append(" AND b.medicine_code = ? ");
            params.add(medicineCode);
        }
        if (supplierId != null && !supplierId.isEmpty()) {
            sql.append(" AND b.supplier_id = ? ");
            params.add(Integer.parseInt(supplierId));
        }

        sql.append(" ORDER BY b.received_date DESC");

        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("lotNumber", rs.getString("lot_number"));
                    row.put("medicineCode", rs.getString("medicine_code"));
                    row.put("medicineName", rs.getString("medicine_name"));
                    row.put("supplierId", rs.getInt("supplier_id"));
                    row.put("supplierName", rs.getString("supplier_name"));
                    row.put("receivedDate", rs.getDate("received_date"));
                    row.put("expiryDate", rs.getDate("expiry_date"));
                    row.put("initialQuantity", rs.getInt("initial_quantity"));
                    row.put("currentQuantity", rs.getInt("current_quantity"));
                    row.put("status", rs.getString("status"));
                    row.put("quarantineNotes", rs.getString("quarantine_notes"));
                    list.add(row);
                }
            }
        }
        return list;
    }
  
// ✅ ADD batch info
 public boolean insertBatch(Batches batch) {
        String sql = """
            INSERT INTO Batches 
            (medicine_code, supplier_id, lot_number, expiry_date, received_date, initial_quantity, current_quantity, status, quarantine_notes)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;

        try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setString(1, batch.getMedicineCode());
            ps.setInt(2, batch.getSupplierId());
            ps.setString(3, batch.getLotNumber());
            ps.setDate(4, batch.getExpiryDate());
            ps.setDate(5, batch.getReceivedDate());
            ps.setInt(6, batch.getInitialQuantity());
            ps.setInt(7, batch.getCurrentQuantity());
            ps.setString(8, batch.getStatus());
            ps.setString(9, batch.getQuarantineNotes());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

 
 public String generateNextLotNumber() throws SQLException {
    int year = java.time.LocalDate.now().getYear();
    String prefix = "LOT" + year;

    String sql = "SELECT TOP 1 lot_number FROM Batches WHERE lot_number LIKE ? ORDER BY lot_number DESC";

    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, prefix + "%");
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            String lastLot = rs.getString(1);
            if (lastLot != null && lastLot.startsWith(prefix)) {
                // Cắt phần số sau năm
                String numberPart = lastLot.substring(prefix.length());
                int num = Integer.parseInt(numberPart);
                return prefix + String.format("%03d", num + 1);
            }
        }
    }
    // Nếu chưa có lô nào trong năm nay → bắt đầu từ 001
    return prefix + "001";
}
 // Hàm lấy tất cả thuốc
    public List<Medicine> getAllMedicines() {
        List<Medicine> list = new ArrayList<>();
        String sql = "SELECT medicine_code, name FROM Medicines"; // Chỉnh theo bảng của bạn

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Medicine m = new Medicine();
                m.setMedicineCode(rs.getString("medicine_code"));
                m.setName(rs.getString("name"));
                list.add(m);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
 
     // Hàm lấy tất cả nhà cung cấp
    public List<Supplier> getAllSuppliers() {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT supplier_id, name FROM Suppliers"; // Chỉnh theo bảng của bạn

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Supplier s = new Supplier();
                s.setSupplierId(rs.getInt("supplier_id"));
                s.setName(rs.getString("name"));
                list.add(s);
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




