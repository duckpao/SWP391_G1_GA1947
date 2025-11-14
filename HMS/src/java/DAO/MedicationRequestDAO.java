package DAO;

import model.MedicationRequest;
import model.MedicationRequestItem;
import model.Medicine;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.sql.Connection;
import java.util.HashMap;

public class MedicationRequestDAO extends DBContext {

    public int createRequest(MedicationRequest request) {
        String sql = "INSERT INTO MedicationRequests (doctor_id, status, request_date, notes) VALUES (?, 'Pending', GETDATE(), ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, request.getDoctorId());
            ps.setString(2, request.getNotes());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in createRequest: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    public void addRequestItems(int requestId, List<MedicationRequestItem> items) {
        String sql = "INSERT INTO MedicationRequestItems (request_id, medicine_code, quantity) VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (MedicationRequestItem item : items) {
                ps.setInt(1, requestId);
                ps.setString(2, item.getMedicineCode());
                ps.setInt(3, item.getQuantity());
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (SQLException e) {
            System.err.println("Error in addRequestItems: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public List<Medicine> getAllMedicines() {
        List<Medicine> medicines = new ArrayList<>();
        String sql = "SELECT DISTINCT m.medicine_code, m.name, m.category, m.description, " +
                     "m.active_ingredient, m.dosage_form, m.strength, m.unit, " +
                     "m.manufacturer, m.country_of_origin, m.drug_group, m.drug_type, " +
                     "m.created_at, m.updated_at " +
                     "FROM Medicines m " +
                     "INNER JOIN Batches b ON m.medicine_code = b.medicine_code " +
                     "WHERE b.status = 'Approved' AND b.expiry_date > GETDATE() " +
                     "ORDER BY m.name";
        
        try (PreparedStatement ps = connection.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Medicine med = new Medicine(
                    rs.getString("medicine_code"),
                    rs.getString("name"),
                    rs.getString("category"),
                    rs.getString("description"),
                    rs.getString("active_ingredient"),
                    rs.getString("dosage_form"),
                    rs.getString("strength"),
                    rs.getString("unit"),
                    rs.getString("manufacturer"),
                    rs.getString("country_of_origin"),
                    rs.getString("drug_group"),
                    rs.getString("drug_type"),
                    rs.getTimestamp("created_at"),
                    rs.getTimestamp("updated_at")
                );
                medicines.add(med);
            }
        } catch (SQLException e) {
            System.err.println("Error in getAllMedicines: " + e.getMessage());
            e.printStackTrace();
        }
        return medicines;
    }

    public MedicationRequest getRequestById(int requestId) {
        String sql = "SELECT request_id, doctor_id, status, request_date, notes FROM MedicationRequests WHERE request_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    MedicationRequest req = new MedicationRequest();
                    req.setRequestId(rs.getInt("request_id"));
                    req.setDoctorId(rs.getInt("doctor_id"));
                    req.setStatus(rs.getString("status"));
                    req.setRequestDate(rs.getTimestamp("request_date"));
                    req.setNotes(rs.getString("notes"));
                    return req;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getRequestById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public List<MedicationRequestItem> getRequestItems(int requestId) {
        List<MedicationRequestItem> items = new ArrayList<>();
        String sql = "SELECT mri.item_id, mri.request_id, mri.medicine_code, mri.quantity, m.name AS medicine_name " +
                     "FROM MedicationRequestItems mri " +
                     "INNER JOIN Medicines m ON mri.medicine_code = m.medicine_code " +
                     "WHERE mri.request_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MedicationRequestItem item = new MedicationRequestItem();
                    item.setItemId(rs.getInt("item_id"));
                    item.setRequestId(rs.getInt("request_id"));
                    item.setMedicineCode(rs.getString("medicine_code"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setMedicineName(rs.getString("medicine_name"));
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getRequestItems: " + e.getMessage());
            e.printStackTrace();
        }
        return items;
    }

    public List<MedicationRequest> getRequestsByDoctorId(int doctorId) {
        List<MedicationRequest> requests = new ArrayList<>();
        String sql = "SELECT request_id, doctor_id, status, request_date, notes FROM MedicationRequests WHERE doctor_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MedicationRequest req = new MedicationRequest();
                    req.setRequestId(rs.getInt("request_id"));
                    req.setDoctorId(rs.getInt("doctor_id"));
                    req.setStatus(rs.getString("status"));
                    req.setRequestDate(rs.getTimestamp("request_date"));
                    req.setNotes(rs.getString("notes"));
                    requests.add(req);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getRequestsByDoctorId: " + e.getMessage());
            e.printStackTrace();
        }
        return requests;
    }

    public boolean updateRequest(MedicationRequest req, List<MedicationRequestItem> items) {
        String sql = "UPDATE MedicationRequests SET notes = ?, status = ? WHERE request_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, req.getNotes());
            ps.setString(2, req.getStatus());
            ps.setInt(3, req.getRequestId());
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                deleteRequestItems(req.getRequestId());
                addRequestItems(req.getRequestId(), items);
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error in updateRequest: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean cancelRequest(int requestId) {
        String sql = "UPDATE MedicationRequests SET status = 'Canceled' WHERE request_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error in cancelRequest: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private void deleteRequestItems(int requestId) {
        String sql = "DELETE FROM MedicationRequestItems WHERE request_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error in deleteRequestItems: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public List<MedicationRequest> viewMedicationRequests() {
        List<MedicationRequest> requests = new ArrayList<>();
        Map<Integer, MedicationRequest> requestMap = new LinkedHashMap<>();

        String sql = "SELECT mr.request_id, mr.doctor_id, u.username AS doctor_name, "
                   + "mr.status, mr.request_date, mr.notes, "
                   + "mri.item_id, mri.medicine_code, mri.quantity, m.name AS medicine_name "
                   + "FROM MedicationRequests mr "
                   + "LEFT JOIN Users u ON mr.doctor_id = u.user_id "
                   + "LEFT JOIN MedicationRequestItems mri ON mr.request_id = mri.request_id "
                   + "LEFT JOIN Medicines m ON mri.medicine_code = m.medicine_code "
                   + "ORDER BY mr.request_date DESC";

        try (PreparedStatement pst = connection.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {

            while (rs.next()) {
                int requestId = rs.getInt("request_id");

                MedicationRequest request = requestMap.get(requestId);
                if (request == null) {
                    request = new MedicationRequest();
                    request.setRequestId(requestId);
                    request.setDoctorId(rs.getInt("doctor_id"));
                    request.setDoctorName(rs.getString("doctor_name"));
                    request.setStatus(rs.getString("status"));
                    request.setRequestDate(rs.getTimestamp("request_date"));
                    request.setNotes(rs.getString("notes"));
                    request.setItems(new ArrayList<>());
                    requestMap.put(requestId, request);
                }

                String medicineCode = rs.getString("medicine_code");
                if (medicineCode != null) {
                    MedicationRequestItem item = new MedicationRequestItem();
                    item.setItemId(rs.getInt("item_id"));
                    item.setRequestId(requestId);
                    item.setMedicineCode(medicineCode);
                    item.setMedicineName(rs.getString("medicine_name"));
                    item.setQuantity(rs.getInt("quantity"));
                    request.getItems().add(item);
                }
            }

            requests.addAll(requestMap.values());

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return requests;
    }

    /**
     * ✅ APPROVE REQUEST - FIFO + TRỪ BATCH_QUANTITY VÀ CURRENT_QUANTITY
     * - Lấy lô có hạn sử dụng gần nhất (FIFO)
     * - Trừ batch_quantity
     * - Trigger tự động cập nhật current_quantity
     * - Lưu batch_id vào IssueSlipItem
     */
public void approveRequestWithInventory(int requestId, int pharmacistId) throws SQLException {
    Connection conn = null;
    PreparedStatement psItems = null;
    PreparedStatement psBatch = null;
    PreparedStatement psUpdate = null;
    PreparedStatement psTrans = null;
    PreparedStatement psStatus = null;
    PreparedStatement psSlip = null;
    PreparedStatement psSlipItem = null;
    ResultSet rs = null;
    ResultSet rsBatch = null;
    ResultSet rsSlip = null;
    
    try {
        // ✅ SỬ DỤNG CONNECTION CÓ SẴN thay vì tạo mới
        conn = this.connection;
        conn.setAutoCommit(false);
        
        System.out.println("========================================");
        System.out.println("→ Starting approveRequestWithInventory");
        System.out.println("  Request ID: " + requestId);
        System.out.println("  Pharmacist ID: " + pharmacistId);

        // 1️⃣ Lấy items của request
        String sqlItems = "SELECT item_id, medicine_code, quantity FROM MedicationRequestItems WHERE request_id=?";
        List<IssuedBatchInfo> issuedBatches = new ArrayList<>();

        psItems = conn.prepareStatement(sqlItems);
        psItems.setInt(1, requestId);
        rs = psItems.executeQuery();
        
        while (rs.next()) {
            String medicineCode = rs.getString("medicine_code");
            int qtyNeeded = rs.getInt("quantity");
            
            System.out.println("  → Processing medicine: " + medicineCode + " (qty: " + qtyNeeded + ")");

            // 2️⃣ ✅ CHECK STOCK TRƯỚC KHI TRỪ
            String sqlCheckStock = "SELECT ISNULL(SUM(batch_quantity), 0) as total_stock " +
                                  "FROM Batches " +
                                  "WHERE medicine_code=? AND status='Approved' AND batch_quantity>0";
            
            try (PreparedStatement psCheck = conn.prepareStatement(sqlCheckStock)) {
                psCheck.setString(1, medicineCode);
                try (ResultSet rsCheck = psCheck.executeQuery()) {
                    if (rsCheck.next()) {
                        int totalStock = rsCheck.getInt("total_stock");
                        if (totalStock < qtyNeeded) {
                            throw new SQLException("❌ Không đủ tồn kho cho thuốc: " + medicineCode + 
                                                 " (cần: " + qtyNeeded + ", có: " + totalStock + ")");
                        }
                    }
                }
            }

            // 3️⃣ Trừ kho FIFO (WITH ROWLOCK để tránh deadlock)
            String sqlBatch = "SELECT TOP 100 batch_id, batch_quantity, expiry_date " +
                            "FROM Batches WITH (ROWLOCK, UPDLOCK) " + // ✅ THÊM LOCK HINT
                            "WHERE medicine_code=? AND batch_quantity>0 AND status='Approved' " +
                            "ORDER BY expiry_date ASC";

            psBatch = conn.prepareStatement(sqlBatch);
            psBatch.setString(1, medicineCode);
            rsBatch = psBatch.executeQuery();
            
            int totalIssued = 0;

            while (qtyNeeded > 0 && rsBatch.next()) {
                int batchId = rsBatch.getInt("batch_id");
                int batchQty = rsBatch.getInt("batch_quantity");
                int deduct = Math.min(batchQty, qtyNeeded);

                System.out.println("    → Deducting from batch " + batchId + ": " + deduct + " units");

                // ✅ TRỪ BATCH_QUANTITY
                String sqlUpdate = "UPDATE Batches SET batch_quantity=batch_quantity-?, updated_at=GETDATE() WHERE batch_id=?";
                psUpdate = conn.prepareStatement(sqlUpdate);
                psUpdate.setInt(1, deduct);
                psUpdate.setInt(2, batchId);
                int updated = psUpdate.executeUpdate();
                
                if (updated == 0) {
                    throw new SQLException("❌ Không thể cập nhật batch " + batchId);
                }
                psUpdate.close();

                // ✅ LƯU THÔNG TIN BATCH
                IssuedBatchInfo info = new IssuedBatchInfo();
                info.medicineCode = medicineCode;
                info.batchId = batchId;
                info.quantity = deduct;
                issuedBatches.add(info);

                // ✅ GHI TRANSACTION
                String sqlTrans = "INSERT INTO Transactions(batch_id, user_id, type, quantity, transaction_date, notes) " +
                                "VALUES(?,?,'Out',?,GETDATE(),?)";
                psTrans = conn.prepareStatement(sqlTrans);
                psTrans.setInt(1, batchId);
                psTrans.setInt(2, pharmacistId);
                psTrans.setInt(3, deduct);
                psTrans.setString(4, "Xuất kho cho yêu cầu " + requestId);
                psTrans.executeUpdate();
                psTrans.close();

                qtyNeeded -= deduct;
                totalIssued += deduct;
            }
            
            rsBatch.close();
            psBatch.close();

            if (qtyNeeded > 0) {
                throw new SQLException("❌ Không đủ tồn kho cho thuốc: " + medicineCode + " (còn thiếu: " + qtyNeeded + ")");
            }

            System.out.println("    ✓ Total issued for " + medicineCode + ": " + totalIssued);
        }
        
        rs.close();
        psItems.close();

        // 4️⃣ Update status request
        String sqlStatus = "UPDATE MedicationRequests SET status='Approved' WHERE request_id=?";
        psStatus = conn.prepareStatement(sqlStatus);
        psStatus.setInt(1, requestId);
        psStatus.executeUpdate();
        psStatus.close();
        System.out.println("  ✓ Updated request status to Approved");

        // 5️⃣ Tạo IssueSlip
        String slipCode = generateSlipCode(conn);
        int slipId;
        String sqlInsertSlip = "INSERT INTO IssueSlip(slip_code, request_id, pharmacist_id, notes, created_date) " +
                             "VALUES(?,?,?,'Xuất kho tự động theo FIFO',GETDATE())";

        psSlip = conn.prepareStatement(sqlInsertSlip, java.sql.Statement.RETURN_GENERATED_KEYS);
        psSlip.setString(1, slipCode);
        psSlip.setInt(2, requestId);
        psSlip.setInt(3, pharmacistId);
        psSlip.executeUpdate();

        rsSlip = psSlip.getGeneratedKeys();
        if (rsSlip.next()) {
            slipId = rsSlip.getInt(1);
            System.out.println("  ✓ Created IssueSlip: " + slipCode + " (ID: " + slipId + ")");
        } else {
            throw new SQLException("Không tạo được IssueSlip");
        }
        rsSlip.close();
        psSlip.close();

        // 6️⃣ LƯU CHI TIẾT PHIẾU XUẤT
        String sqlInsertItem = "INSERT INTO IssueSlipItem(slip_id, medicine_code, batch_id, quantity) VALUES(?,?,?,?)";
        psSlipItem = conn.prepareStatement(sqlInsertItem);
        
        for (IssuedBatchInfo info : issuedBatches) {
            psSlipItem.setInt(1, slipId);
            psSlipItem.setString(2, info.medicineCode);
            psSlipItem.setInt(3, info.batchId);
            psSlipItem.setInt(4, info.quantity);
            psSlipItem.addBatch();
            System.out.println("    → Added to slip: " + info.medicineCode + " (batch " + info.batchId + ") x " + info.quantity);
        }
        psSlipItem.executeBatch();
        psSlipItem.close();

        conn.commit();
        System.out.println("✅ Transaction committed successfully!");
        System.out.println("========================================");

    } catch (SQLException ex) {
        System.err.println("❌ Error in approveRequestWithInventory: " + ex.getMessage());
        ex.printStackTrace();
        if (conn != null) {
            try {
                conn.rollback();
                System.out.println("🔄 Transaction rolled back");
            } catch (SQLException e) {
                System.err.println("❌ Rollback failed: " + e.getMessage());
            }
        }
        throw ex;
    } finally {
        // ✅ ĐÓNG TẤT CẢ RESOURCES
        try {
            if (rsSlip != null) rsSlip.close();
            if (rsBatch != null) rsBatch.close();
            if (rs != null) rs.close();
            if (psSlipItem != null) psSlipItem.close();
            if (psSlip != null) psSlip.close();
            if (psStatus != null) psStatus.close();
            if (psTrans != null) psTrans.close();
            if (psUpdate != null) psUpdate.close();
            if (psBatch != null) psBatch.close();
            if (psItems != null) psItems.close();
            if (conn != null) {
                conn.setAutoCommit(true); // ✅ RESET AUTO COMMIT
            }
        } catch (SQLException e) {
            System.err.println("Error closing resources: " + e.getMessage());
        }
    }
}
    // ✅ INNER CLASS LƯU THÔNG TIN LÔ ĐÃ XUẤT
    private static class IssuedBatchInfo {
        String medicineCode;
        int batchId;
        int quantity;
    }

    public boolean rejectRequest(int requestId, String reason) {
        Connection conn = null;
        try {
            conn = new DBContext().getConnection();
            
            String sql = "UPDATE MedicationRequests SET status='Rejected', " +
                        "notes=CONCAT(COALESCE(notes, ''), '\nRejected: ', ?) " +
                        "WHERE request_id=?";
            
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, reason);
                ps.setInt(2, requestId);
                int rows = ps.executeUpdate();
                return rows > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error in rejectRequest: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public MedicationRequest getMedicationRequestById(int requestId) {
        String sql = "SELECT mr.request_id, mr.doctor_id, mr.status, mr.request_date, " +
                     "mr.notes, u.username as doctor_name " +
                     "FROM MedicationRequests mr " +
                     "INNER JOIN Users u ON mr.doctor_id = u.user_id " +
                     "WHERE mr.request_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                MedicationRequest req = new MedicationRequest();
                req.setRequestId(rs.getInt("request_id"));
                req.setDoctorId(rs.getInt("doctor_id"));
                req.setStatus(rs.getString("status"));
                req.setRequestDate(rs.getTimestamp("request_date"));
                req.setNotes(rs.getString("notes"));
                req.setDoctorName(rs.getString("doctor_name"));
                
                List<MedicationRequestItem> items = getRequestItems(requestId);
                req.setItems(items);
                
                return req;
            }
        } catch (SQLException e) {
            System.err.println("Error getting medication request: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    private String generateSlipCode(Connection conn) throws SQLException {
        java.util.Date now = new java.util.Date();
        java.text.SimpleDateFormat sdfDate = new java.text.SimpleDateFormat("yyyyMMdd");
        String datePart = sdfDate.format(now);

        java.text.SimpleDateFormat sdfFull = new java.text.SimpleDateFormat("yyyy-MM-dd");
        String today = sdfFull.format(now);

        String sql = "SELECT COUNT(*) AS cnt FROM IssueSlip " +
                    "WHERE created_date >= ? AND created_date < DATEADD(DAY, 1, ?)";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, today);
            ps.setString(2, today);
            try (ResultSet rs = ps.executeQuery()) {
                int seq = 1;
                if (rs.next()) {
                    seq = rs.getInt("cnt") + 1;
                }
                return String.format("PX-%s-%03d", datePart, seq);
            }
        }
    }
}