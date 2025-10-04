package DAO;

import model.MedicationRequest;
import model.MedicationRequestItem;
import model.Medicine;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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

    public void addRequestItems(int requestId, List<MedicationRequestItem> items) {
        String sql = "INSERT INTO MedicationRequestItems (request_id, medicine_id, quantity) VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (MedicationRequestItem item : items) {
                ps.setInt(1, requestId);
                ps.setInt(2, item.getMedicineId());
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
        String sql = "SELECT medicine_id, name FROM Medicines";
        try (PreparedStatement ps = connection.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Medicine med = new Medicine();
                med.setMedicineId(rs.getInt("medicine_id"));
                med.setName(rs.getString("name"));
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

    // ✅ FIXED: Thêm JOIN với bảng Medicines để lấy tên thuốc
    public List<MedicationRequestItem> getRequestItems(int requestId) {
        List<MedicationRequestItem> items = new ArrayList<>();
        String sql = "SELECT mri.request_id, mri.medicine_id, mri.quantity, m.name AS medicine_name " +
                     "FROM MedicationRequestItems mri " +
                     "INNER JOIN Medicines m ON mri.medicine_id = m.medicine_id " +
                     "WHERE mri.request_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MedicationRequestItem item = new MedicationRequestItem();
                    item.setRequestId(rs.getInt("request_id"));
                    item.setMedicineId(rs.getInt("medicine_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setMedicineName(rs.getString("medicine_name")); // ✅ THÊM DÒNG NÀY
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

    public boolean cancelRequest(int requestId) {
        System.out.println("=== CANCEL REQUEST (SIMPLE) ===");
        System.out.println("Request ID: " + requestId);
        
        String sql = "UPDATE MedicationRequests SET status = 'Cancelled' WHERE request_id = ?";
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
}