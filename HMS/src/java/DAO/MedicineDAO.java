package DAO;
import model.Medicine;
import model.Batches;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Statement; 

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


       // ===================== Add Medicine + Batch =====================
    public boolean addMedicine(Medicine med, Batches batch) {
        String sqlMedicine = "INSERT INTO Medicines(name, category, description, created_at, updated_at) VALUES(?,?,?,GETDATE(),GETDATE())";
        String sqlBatch = "INSERT INTO Batches(medicine_id, supplier_id, lot_number, expiry_date, initial_quantity, current_quantity, status, created_at, updated_at) VALUES(?,?,?,?,?,?,?,GETDATE(),GETDATE())";

        try (Connection conn = dbContext.getConnection()) {
            conn.setAutoCommit(false);

            // 1. Insert medicine
            try (PreparedStatement psMed = conn.prepareStatement(sqlMedicine, Statement.RETURN_GENERATED_KEYS)) {
                psMed.setString(1, med.getName());
                psMed.setString(2, med.getCategory());
                psMed.setString(3, med.getDescription());
                psMed.executeUpdate();

                ResultSet rs = psMed.getGeneratedKeys();
                if (rs.next()) {
                    int medicineId = rs.getInt(1);
                    batch.setMedicineId(medicineId);
                }
            }

            // 2. Insert batch
            try (PreparedStatement psBatch = conn.prepareStatement(sqlBatch)) {
                psBatch.setInt(1, batch.getMedicineId());
                psBatch.setInt(2, batch.getSupplierId());
                psBatch.setString(3, batch.getLotNumber());
                psBatch.setDate(4, new java.sql.Date(batch.getExpiryDate().getTime()));
                psBatch.setInt(5, batch.getInitialQuantity());
                psBatch.setInt(6, batch.getCurrentQuantity());
                psBatch.setString(7, batch.getStatus());
                psBatch.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

// Update Medicine + Batch
public boolean updateMedicine(Medicine med, Batches batch) {
    String sqlMed = "UPDATE Medicines SET name=?, category=?, description=?, updated_at=GETDATE() WHERE medicine_id=?";
    String sqlBatch = "UPDATE Batches SET supplier_id=?, lot_number=?, expiry_date=?, current_quantity=?, status=?, updated_at=GETDATE() WHERE batch_id=?";

    try (Connection conn = dbContext.getConnection()) {
        conn.setAutoCommit(false);

        // Update medicine
        try (PreparedStatement psMed = conn.prepareStatement(sqlMed)) {
            psMed.setString(1, med.getName());
            psMed.setString(2, med.getCategory());
            psMed.setString(3, med.getDescription());
            psMed.setInt(4, med.getMedicineId());
            psMed.executeUpdate();
        }

        // Update batch
        try (PreparedStatement psBatch = conn.prepareStatement(sqlBatch)) {
            psBatch.setInt(1, batch.getSupplierId()); // lấy từ request
            psBatch.setString(2, batch.getLotNumber());
            psBatch.setDate(3, new java.sql.Date(batch.getExpiryDate().getTime()));
            psBatch.setInt(4, batch.getCurrentQuantity());
            psBatch.setString(5, batch.getStatus());
            psBatch.setInt(6, batch.getBatchId());
            psBatch.executeUpdate();
        }

        conn.commit();
        return true;

    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}


    // ===================== Delete Medicine =====================
    public boolean deleteMedicine(int medicineId) {
        String sql = "DELETE FROM Medicines WHERE medicine_id=?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, medicineId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    
     // ===================== Record Expired/Damaged Medicines =====================
    public boolean recordExpiredOrDamaged(int batchId, int userId, int quantity, String reason, String notes) {
        String insertSql = "INSERT INTO Transactions (batch_id, user_id, type, quantity, transaction_date, notes) " +
                           "VALUES (?, ?, ?, ?, GETDATE(), ?)";
        String updateSql = "UPDATE Batches SET current_quantity = current_quantity - ? WHERE batch_id = ?";

        try (Connection conn = dbContext.getConnection()) {
            conn.setAutoCommit(false);

            // 1. Insert log vào Transactions
            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setInt(1, batchId);
                ps.setInt(2, userId);
                ps.setString(3, reason);   // "Expired" hoặc "Damaged"
                ps.setInt(4, quantity);
                ps.setString(5, notes);
                ps.executeUpdate();
            }

            // 2. Update tồn kho trong Batches
            try (PreparedStatement ps2 = conn.prepareStatement(updateSql)) {
                ps2.setInt(1, quantity);
                ps2.setInt(2, batchId);
                ps2.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
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
