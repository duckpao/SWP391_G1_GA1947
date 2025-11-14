package DAO;

import java.sql.*;
import java.util.*;
import java.sql.Date;
import model.Batches;
import model.Medicine;
import model.Supplier;

public class BatchDAO extends DBContext {

    /**
     * ✅ Lấy danh sách tất cả các lô thuốc
     */
    public List<Map<String, Object>> getBatchList() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT 
                b.batch_id AS batchId,
                b.lot_number AS lotNumber,
                m.medicine_code AS medicineCode,
                m.name AS medicineName,
                s.name AS supplierName,
                b.received_date AS receivedDate,
                b.expiry_date AS expiryDate,
                b.batch_quantity AS batchQuantity,
                b.current_quantity AS currentQuantity,
                b.status AS status,
                b.quarantine_notes AS quarantineNotes
            FROM Batches b
            JOIN Medicines m ON b.medicine_code = m.medicine_code
            JOIN Suppliers s ON b.supplier_id = s.supplier_id
            ORDER BY b.batch_id DESC;
        """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("batchId", rs.getInt("batchId"));
                row.put("lotNumber", rs.getString("lotNumber"));
                row.put("medicineCode", rs.getString("medicineCode"));
                row.put("medicineName", rs.getString("medicineName"));
                row.put("supplierName", rs.getString("supplierName"));
                row.put("receivedDate", rs.getDate("receivedDate"));
                row.put("expiryDate", rs.getDate("expiryDate"));
                row.put("batchQuantity", rs.getInt("batchQuantity"));
                row.put("currentQuantity", rs.getInt("currentQuantity"));
                row.put("status", rs.getString("status"));
                row.put("quarantineNotes", rs.getString("quarantineNotes"));
                list.add(row);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    /**
     * ✅ Lấy chi tiết một lô thuốc
     */
    public Batches getBatchById(int batchId) {
        String sql = """
            SELECT 
                b.batch_id, b.medicine_code, b.supplier_id, b.lot_number,
                b.expiry_date, b.received_date, b.initial_quantity,
                b.batch_quantity, b.current_quantity, b.status, b.quarantine_notes,
                m.name AS medicine_name,
                s.name AS supplier_name
            FROM Batches b
            JOIN Medicines m ON b.medicine_code = m.medicine_code
            JOIN Suppliers s ON b.supplier_id = s.supplier_id
            WHERE b.batch_id = ?
        """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, batchId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Batches batch = new Batches();
                batch.setBatchId(rs.getInt("batch_id"));
                batch.setMedicineCode(rs.getString("medicine_code"));
                batch.setSupplierId(rs.getInt("supplier_id"));
                batch.setLotNumber(rs.getString("lot_number"));
                batch.setExpiryDate(rs.getDate("expiry_date"));
                batch.setReceivedDate(rs.getDate("received_date"));
                batch.setInitialQuantity(rs.getInt("initial_quantity"));
                batch.setBatchQuantity(rs.getInt("batch_quantity"));
                batch.setCurrentQuantity(rs.getInt("current_quantity"));
                batch.setStatus(rs.getString("status"));
                batch.setQuarantineNotes(rs.getString("quarantine_notes"));
                return batch;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * ✅ Thêm lô thuốc mới từ Purchase Order
     * - batch_quantity lấy từ PO quantity
     * - Status mặc định: "Quarantined" (chờ kiểm định)
     * - current_quantity sẽ tự động cập nhật sau khi approve
     */
    public boolean insertBatchFromPO(int poId, String medicineCode, 
                                      int supplierId, int quantity,
                                      Date receivedDate, Date expiryDate) {
        String sql = """
            INSERT INTO Batches 
            (medicine_code, supplier_id, lot_number, expiry_date, received_date, 
             initial_quantity, batch_quantity, current_quantity, status, quarantine_notes)
            VALUES (?, ?, ?, ?, ?, ?, ?, 0, 'Quarantined', ?)
        """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Generate lot number
            String lotNumber = generateNextLotNumber();

            ps.setString(1, medicineCode);
            ps.setInt(2, supplierId);
            ps.setString(3, lotNumber);
            ps.setDate(4, expiryDate);
            ps.setDate(5, receivedDate);
            ps.setInt(6, quantity);  // initial_quantity
            ps.setInt(7, quantity);  // batch_quantity
            ps.setString(8, "Lô từ đơn hàng #" + poId);

            int result = ps.executeUpdate();

            if (result > 0) {
                System.out.println("✅ Đã tạo lô " + lotNumber + 
                                   " cho thuốc " + medicineCode + 
                                   " (SL: " + quantity + ")");
                return true;
            }

        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi thêm lô: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * ✅ Sinh mã số lô tự động
     */
    public String generateNextLotNumber() throws SQLException {
        int year = java.time.LocalDate.now().getYear();
        String prefix = "LOT" + year;

        String sql = "SELECT TOP 1 lot_number FROM Batches " +
                     "WHERE lot_number LIKE ? ORDER BY lot_number DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, prefix + "%");
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String lastLot = rs.getString(1);
                if (lastLot != null && lastLot.startsWith(prefix)) {
                    String numberPart = lastLot.substring(prefix.length());
                    int num = Integer.parseInt(numberPart);
                    return prefix + String.format("%03d", num + 1);
                }
            }
        }
        return prefix + "001";
    }

    /**
     * ✅ Phê duyệt lô thuốc (gọi stored procedure)
     */
    public boolean approveBatch(int batchId, int approvedBy, String notes) {
        String sql = "{CALL sp_ApproveBatch(?, ?, ?)}";

        try (Connection conn = getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {

            cs.setInt(1, batchId);
            cs.setInt(2, approvedBy);
            cs.setString(3, notes);

            ResultSet rs = cs.executeQuery();
            if (rs.next()) {
                String status = rs.getString("status");
                String message = rs.getString("message");
                
                if ("SUCCESS".equals(status)) {
                    System.out.println("✅ " + message);
                    return true;
                } else {
                    System.err.println("❌ " + message);
                }
            }

        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi approve lô: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * ✅ Cập nhật thông tin lô (HSD, ghi chú, v.v.)
     */
    public boolean updateBatch(Batches batch) {
        String sql = """
            UPDATE Batches 
            SET expiry_date = ?, 
                batch_quantity = ?,
                status = ?, 
                quarantine_notes = ?,
                updated_at = GETDATE()
            WHERE batch_id = ?
        """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDate(1, batch.getExpiryDate());
            ps.setInt(2, batch.getBatchQuantity());
            ps.setString(3, batch.getStatus());
            
            if (batch.getQuarantineNotes() != null && !batch.getQuarantineNotes().isEmpty()) {
                ps.setString(4, batch.getQuarantineNotes());
            } else {
                ps.setNull(4, java.sql.Types.VARCHAR);
            }
            
            ps.setInt(5, batch.getBatchId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * ✅ Cập nhật kiểm định chất lượng lô thuốc
     */
    public boolean updateQualityCheck(int batchId, String status, String quarantineNotes) {
        String sql = """
            UPDATE Batches 
            SET status = ?, 
                quarantine_notes = ?, 
                updated_at = GETDATE() 
            WHERE batch_id = ?
        """;
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setString(2, quarantineNotes);
            ps.setInt(3, batchId);
            
            int result = ps.executeUpdate();
            
            if (result > 0) {
                System.out.println("✅ Cập nhật kiểm định lô #" + batchId + 
                                   " - Status: " + status);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi cập nhật kiểm định: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * ✅ Lấy danh sách lô thuốc khả dụng (Approved hoặc Received)
     */
    public List<Map<String, Object>> getAvailableBatches() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT 
                b.batch_id AS batchId, 
                b.lot_number AS lotNumber, 
                m.name AS medicineName, 
                b.status AS status,
                b.batch_quantity AS batchQuantity,
                b.expiry_date AS expiryDate
            FROM Batches b
            JOIN Medicines m ON b.medicine_code = m.medicine_code
            WHERE b.status IN ('Approved', 'Received')
            ORDER BY m.name ASC, b.lot_number ASC
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
                row.put("batchQuantity", rs.getInt("batchQuantity"));
                row.put("expiryDate", rs.getDate("expiryDate"));
                list.add(row);
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi lấy danh sách lô khả dụng: " + e.getMessage());
            e.printStackTrace();
        }
        
        return list;
    }

    /**
     * ✅ Xóa lô thuốc
     */
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

    /**
     * ✅ Lấy tổng số lượng thuốc theo medicine_code
     * (chỉ tính các lô Approved)
     */
    public int getTotalQuantityByMedicineCode(String medicineCode) {
        String sql = """
            SELECT ISNULL(SUM(batch_quantity), 0) AS total
            FROM Batches
            WHERE medicine_code = ? AND status = 'Approved'
        """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, medicineCode);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * ✅ Lấy danh sách thuốc
     */
    public List<Medicine> getAllMedicines() {
        List<Medicine> list = new ArrayList<>();
        String sql = "SELECT medicine_code, name FROM Medicines ORDER BY name";

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

    /**
     * ✅ Lấy danh sách nhà cung cấp
     */
    public List<Supplier> getAllSuppliers() {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT supplier_id, name FROM Suppliers ORDER BY name";

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

    /**
     * ✅ Lọc lô thuốc theo tiêu chí
     */
    public List<Map<String, Object>> filterBatches(String lotNumber, 
                                                     String medicineCode, 
                                                     String supplierId) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT 
                b.batch_id, b.lot_number, b.medicine_code, 
                m.name AS medicine_name, m.strength, m.dosage_form,
                b.supplier_id, s.name AS supplier_name, 
                b.received_date, b.expiry_date, 
                b.initial_quantity, b.batch_quantity, b.current_quantity,
                b.status, b.quarantine_notes
            FROM Batches b
            JOIN Medicines m ON b.medicine_code = m.medicine_code
            JOIN Suppliers s ON b.supplier_id = s.supplier_id
            WHERE 1=1
        """);

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
                    row.put("batchId", rs.getInt("batch_id"));
                    row.put("lotNumber", rs.getString("lot_number"));
                    row.put("medicineCode", rs.getString("medicine_code"));
                    row.put("medicineName", rs.getString("medicine_name"));
                    row.put("medicineStrength", rs.getString("strength"));
                    row.put("medicineDosageForm", rs.getString("dosage_form"));
                    row.put("supplierId", rs.getInt("supplier_id"));
                    row.put("supplierName", rs.getString("supplier_name"));
                    row.put("receivedDate", rs.getDate("received_date"));
                    row.put("expiryDate", rs.getDate("expiry_date"));
                    row.put("initialQuantity", rs.getInt("initial_quantity"));
                    row.put("batchQuantity", rs.getInt("batch_quantity"));
                    row.put("currentQuantity", rs.getInt("current_quantity"));
                    row.put("status", rs.getString("status"));
                    row.put("quarantineNotes", rs.getString("quarantine_notes"));
                    list.add(row);
                }
            }
        }
        return list;
    }
}