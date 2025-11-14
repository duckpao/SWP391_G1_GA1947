package DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.IssueSlip;
import model.IssueSlipItem;

public class IssueSlipDAO {
    
    public IssueSlip getIssueSlipByRequestId(int requestId) throws SQLException {
        String sql = "SELECT i.slip_id, i.slip_code, i.request_id, i.pharmacist_id, i.created_date, i.notes, " +
                     "m.doctor_id, " +
                     "p.username AS pharmacist_name, " +
                     "d.username AS doctor_name " +
                     "FROM IssueSlip i " +
                     "JOIN MedicationRequests m ON i.request_id = m.request_id " +
                     "LEFT JOIN Users p ON i.pharmacist_id = p.user_id " +
                     "LEFT JOIN Users d ON m.doctor_id = d.user_id " +
                     "WHERE i.request_id=?";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    IssueSlip slip = new IssueSlip();
                    slip.setSlipId(rs.getInt("slip_id"));
                    slip.setSlipCode(rs.getString("slip_code"));
                    slip.setRequestId(rs.getInt("request_id"));
                    slip.setPharmacistId(rs.getInt("pharmacist_id"));
                    slip.setDoctorId(rs.getInt("doctor_id"));
                    slip.setCreatedDate(rs.getTimestamp("created_date"));
                    slip.setNotes(rs.getString("notes"));
                    slip.setPharmacistName(rs.getString("pharmacist_name"));
                    slip.setDoctorName(rs.getString("doctor_name"));
                    return slip;
                }
            }
        }
        return null;
    }
    
    public List<IssueSlipItem> getIssueSlipItems(int slipId) throws SQLException {
        // ✅ JOIN với Batches để lấy expiry_date từ batch_id đã lưu
        String sql = "SELECT isi.slip_id, isi.medicine_code, isi.batch_id, isi.quantity, " +
                     "m.name AS medicine_name, m.unit, b.expiry_date " +
                     "FROM IssueSlipItem isi " +
                     "JOIN Medicines m ON isi.medicine_code = m.medicine_code " +
                     "LEFT JOIN Batches b ON isi.batch_id = b.batch_id " +
                     "WHERE isi.slip_id=?";
        
        List<IssueSlipItem> list = new ArrayList<>();
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, slipId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    IssueSlipItem item = new IssueSlipItem();
                    item.setSlipId(rs.getInt("slip_id"));
                    item.setMedicineCode(rs.getString("medicine_code"));
                    item.setMedicineName(rs.getString("medicine_name"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setUnit(rs.getString("unit"));
                    
                    // ✅ Lấy batch_id từ IssueSlipItem
                    Object batchObj = rs.getObject("batch_id");
                    if (batchObj != null) {
                        item.setBatchId(rs.getInt("batch_id"));
                    }
                    
                    item.setExpiryDate(rs.getDate("expiry_date"));
                    list.add(item);
                }
            }
        }
        return list;
    }
}