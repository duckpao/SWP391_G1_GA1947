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
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            medicines = processMedicineResultSet(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return medicines;
    }
    
    // Method tìm kiếm với filter
    public List<Medicine> searchMedicines(String keyword, String category, String status) {
        List<Medicine> medicines = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT m.medicine_id, m.name, m.category, m.description, " +
            "b.batch_id, b.lot_number, b.expiry_date, b.current_quantity, b.status, b.received_date " +
            "FROM Medicines m " +
            "LEFT JOIN Batches b ON m.medicine_id = b.medicine_id " +
            "WHERE b.status = 'Approved' AND b.expiry_date > GETDATE() "
        );
        
        List<Object> params = new ArrayList<>();
        
        // Filter theo keyword (tên thuốc hoặc mô tả)
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (m.name LIKE ? OR m.description LIKE ?) ");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        // Filter theo category
        if (category != null && !category.trim().isEmpty() && !category.equals("All")) {
            sql.append("AND m.category = ? ");
            params.add(category);
        }
        
        // Filter theo số lượng tồn kho
        if (status != null && !status.trim().isEmpty()) {
            switch (status) {
                case "In Stock":
                    sql.append("AND b.current_quantity > 50 ");
                    break;
                case "Low Stock":
                    sql.append("AND b.current_quantity > 0 AND b.current_quantity <= 50 ");
                    break;
                case "Out of Stock":
                    sql.append("AND b.current_quantity = 0 ");
                    break;
            }
        }
        
        sql.append("ORDER BY m.medicine_id, b.expiry_date");
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            medicines = processMedicineResultSet(rs);
            rs.close();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return medicines;
    }
    
    // Method lấy danh sách categories
    public List<String> getAllCategories() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT category FROM Medicines ORDER BY category";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                categories.add(rs.getString("category"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return categories;
    }
    
    // Helper method để xử lý ResultSet
    private List<Medicine> processMedicineResultSet(ResultSet rs) throws SQLException {
        List<Medicine> medicines = new ArrayList<>();
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
        
        return medicines;
    }
}