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
        System.out.println("Affected rows: " + affectedRows); // Debug log
        
        if (affectedRows > 0) {
            try (ResultSet rs = ps.getGeneratedKeys()) { // ← Đóng ResultSet trong try-with-resources
                if (rs.next()) {
                    int requestId = rs.getInt(1);
                    System.out.println("Generated request_id: " + requestId); // Debug log
                    return requestId;
                }
            }
        }
    } catch (SQLException e) {
        System.err.println("Error in createRequest: " + e.getMessage()); // ← Thêm message cụ thể
        e.printStackTrace();
    }
    return -1;
}

    // Insert items cho request
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
            e.printStackTrace();
        }
    }

    // Lấy list medicines để hiển thị trong form (select dropdown)
    public List<Medicine> getAllMedicines() {
        List<Medicine> medicines = new ArrayList<>();
        String sql = "SELECT medicine_id, name FROM Medicines";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Medicine med = new Medicine();
                med.setMedicineId(rs.getInt("medicine_id"));
                med.setName(rs.getString("name"));
                medicines.add(med);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return medicines;
    }
}