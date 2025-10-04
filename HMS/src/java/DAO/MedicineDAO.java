package DAO;

import model.Medicine;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MedicineDAO {
    private DBContext dbContext;

    public MedicineDAO() {
        dbContext = new DBContext();
    }

    public List<Medicine> getMedicineDetails() {
        List<Medicine> medicines = new ArrayList<>();
        String sql = "SELECT m.medicine_id, m.name, m.category, m.description, " +
                     "b.batch_id, b.lot_number, b.expiry_date, b.current_quantity, b.status, b.received_date " +
                     "FROM Medicines m " +
                     "LEFT JOIN Batches b ON m.medicine_id = b.medicine_id " +
                     "WHERE b.status = 'Approved' AND b.expiry_date > GETDATE() " +
                     "ORDER BY m.medicine_id, b.expiry_date";
        try (Connection conn = dbContext.connection;
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            int currentMedicineId = -1;
            Medicine currentMedicine = null;
            while (rs.next()) {
                int medicineId = rs.getInt("medicine_id");
                if (medicineId != currentMedicineId) {
                    if (currentMedicine != null) {
                        medicines.add(currentMedicine);
                    }
                    currentMedicine = new Medicine();
                    currentMedicine.setMedicineId(medicineId);
                    currentMedicine.setName(rs.getString("name"));
                    currentMedicine.setCategory(rs.getString("category"));
                    currentMedicine.setDescription(rs.getString("description"));
                    currentMedicineId = medicineId;
                }
                // Thêm thông tin batch
                Medicine.BatchDetail batch = new Medicine.BatchDetail();
                batch.setBatchId(rs.getInt("batch_id"));
                batch.setLotNumber(rs.getString("lot_number"));
                batch.setExpiryDate(rs.getDate("expiry_date"));
                batch.setCurrentQuantity(rs.getInt("current_quantity"));
                batch.setStatus(rs.getString("status"));
                batch.setReceivedDate(rs.getDate("received_date"));
                currentMedicine.getBatches().add(batch);
            }
            if (currentMedicine != null) {
                medicines.add(currentMedicine);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return medicines;
    }
}