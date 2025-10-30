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
public class MedicationRequestDAO extends DBContext {

    public int createRequest(MedicationRequest request) {
        String sql = "INSERT INTO MedicationRequests (doctor_id, status, request_date, notes) VALUES (?, 'Pending', GETDATE(), ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, request.getDoctorId());
            ps.setString(2, request.getNotes());
            
            int affectedRows = ps.executeUpdate();
            System.out.println("Affected rows: " + affectedRows);
            
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int requestId = rs.getInt(1);
                        System.out.println("Generated request_id: " + requestId);
                        return requestId;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in createRequest: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    // ✅ SỬA: medicine_id → medicine_code
    public void addRequestItems(int requestId, List<MedicationRequestItem> items) {
        String sql = "INSERT INTO MedicationRequestItems (request_id, medicine_code, quantity) VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (MedicationRequestItem item : items) {
                ps.setInt(1, requestId);
                ps.setString(2, item.getMedicineCode());  // ✅ ĐỔI: setString
                ps.setInt(3, item.getQuantity());
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (SQLException e) {
            System.err.println("Error in addRequestItems: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // ✅ SỬA: Đổi SQL query để lấy đầy đủ thông tin
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

    // ✅ SỬA: medicine_id → medicine_code
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
                    item.setMedicineCode(rs.getString("medicine_code"));  // ✅ ĐỔI
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
        System.out.println("=== UPDATE REQUEST ===");
        System.out.println("Request ID: " + req.getRequestId());
        System.out.println("Notes: " + req.getNotes());
        System.out.println("Status: " + req.getStatus());
        System.out.println("Items count: " + items.size());
        
        String sql = "UPDATE MedicationRequests SET notes = ?, status = ? WHERE request_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, req.getNotes());
            ps.setString(2, req.getStatus());
            ps.setInt(3, req.getRequestId());
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);
            
            if (rowsAffected > 0) {
                deleteRequestItems(req.getRequestId());
                addRequestItems(req.getRequestId(), items);
                System.out.println("Update successful!");
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error in updateRequest: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // ✅ SỬA: Cancelled → Canceled (theo DB constraint)
    public boolean cancelRequest(int requestId) {
        System.out.println("=== CANCEL REQUEST ===");
        System.out.println("Request ID: " + requestId);
        
        String sql = "UPDATE MedicationRequests SET status = 'Canceled' WHERE request_id = ?";  // ✅ ĐỔI
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            int rowsAffected = ps.executeUpdate();
            System.out.println("SQL executed. Rows affected: " + rowsAffected);
            
            if (rowsAffected > 0) {
                System.out.println("✅ Cancel successful!");
                return true;
            } else {
                System.err.println("❌ No rows updated. Request ID might not exist.");
                return false;
            }
        } catch (SQLException e) {
            System.err.println("❌ SQL Error in cancelRequest: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private void deleteRequestItems(int requestId) {
        String sql = "DELETE FROM MedicationRequestItems WHERE request_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            int deleted = ps.executeUpdate();
            System.out.println("Deleted " + deleted + " items");
        } catch (SQLException e) {
            System.err.println("Error in deleteRequestItems: " + e.getMessage());
            e.printStackTrace();
        }
    }
    // Lấy danh sách tất cả MedicationRequests + items bằng 1 query
  public List<MedicationRequest> viewMedicationRequests() {
        List<MedicationRequest> requests = new ArrayList<>();
        Map<Integer, MedicationRequest> requestMap = new LinkedHashMap<>(); // giữ thứ tự theo request_date

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

    // Nếu request chưa có trong map thì tạo mới
    MedicationRequest request = requestMap.get(requestId);
    if (request == null) {
        request = new MedicationRequest();
        request.setRequestId(requestId);
        request.setDoctorId(rs.getInt("doctor_id"));
        request.setDoctorName(rs.getString("doctor_name")); // ✅ lấy trực tiếp từ bảng Users
        request.setStatus(rs.getString("status"));
        request.setRequestDate(rs.getTimestamp("request_date"));
        request.setNotes(rs.getString("notes"));
        request.setItems(new ArrayList<>());
        requestMap.put(requestId, request);
    }

    // Thêm thuốc (nếu có)
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

    
  // Approve request: giảm tồn kho và cập nhật trạng thái
  // approve request
  public void approveRequest(int requestId, int pharmacistId) throws SQLException {
    Connection conn = new DBContext().getConnection();
    try {
        conn.setAutoCommit(false);

        // 1️⃣ Lấy items của request
        String sqlItems = "SELECT item_id, medicine_code, quantity FROM MedicationRequestItems WHERE request_id=?";
        PreparedStatement psItems = conn.prepareStatement(sqlItems);
        psItems.setInt(1, requestId);
        ResultSet rs = psItems.executeQuery();

        // 2️⃣ Cập nhật tồn kho theo batch (FIFO: expiry_date sớm nhất trước)
        String sqlBatch = "SELECT batch_id, current_quantity FROM Batches WHERE medicine_code=? AND current_quantity > 0 ORDER BY expiry_date ASC";
        String sqlUpdateBatch = "UPDATE Batches SET current_quantity=? WHERE batch_id=?";
        String sqlTransaction = "INSERT INTO Transactions(batch_id, user_id, type, quantity, transaction_date, notes) VALUES(?,?,?,?,GETDATE(),?)";

        while (rs.next()) {
            String medicineCode = rs.getString("medicine_code");
            int qtyNeeded = rs.getInt("quantity");

            PreparedStatement psBatch = conn.prepareStatement(sqlBatch);
            psBatch.setString(1, medicineCode);
            ResultSet rsBatch = psBatch.executeQuery();

            while (qtyNeeded > 0 && rsBatch.next()) {
                int batchId = rsBatch.getInt("batch_id");
                int currentQty = rsBatch.getInt("current_quantity");

                int deduct = Math.min(currentQty, qtyNeeded);
                int newQty = currentQty - deduct;

                // 3️⃣ Update batch
                PreparedStatement psUpdate = conn.prepareStatement(sqlUpdateBatch);
                psUpdate.setInt(1, newQty);
                psUpdate.setInt(2, batchId);
                psUpdate.executeUpdate();

                // 4️⃣ Tạo transaction
                PreparedStatement psTrans = conn.prepareStatement(sqlTransaction);
                psTrans.setInt(1, batchId);
                psTrans.setInt(2, pharmacistId);
                psTrans.setString(3, "Out");
                psTrans.setInt(4, deduct);
                psTrans.setString(5, "Xuất kho cho yêu cầu " + requestId + " (MedicineCode=" + medicineCode + ")");
                psTrans.executeUpdate();

                qtyNeeded -= deduct;
            }

            if (qtyNeeded > 0) {
                throw new SQLException("Không đủ tồn kho cho thuốc Code=" + medicineCode);
            }
        }

        // 5️⃣ Cập nhật trạng thái request
        String sqlStatus = "UPDATE MedicationRequests SET status='Approved' WHERE request_id=?";
        PreparedStatement psStatus = conn.prepareStatement(sqlStatus);
        psStatus.setInt(1, requestId);
        psStatus.executeUpdate();

        conn.commit();

    } catch (SQLException ex) {
        conn.rollback();
        throw ex;
    } finally {
        conn.setAutoCommit(true);
        conn.close();
    }
}
  
 public void rejectRequest(int requestId, String reason) throws SQLException {
    Connection conn = new DBContext().getConnection();
    String sql = "UPDATE MedicationRequests SET status='Rejected', notes=? WHERE request_id=?";
    PreparedStatement ps = conn.prepareStatement(sql);
    ps.setString(1, reason);
    ps.setInt(2, requestId);
    ps.executeUpdate();
    conn.close();
}
}
