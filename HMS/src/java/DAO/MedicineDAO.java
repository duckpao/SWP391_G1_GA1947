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

    /*public List<Medicine> getMedicineDetails() {
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
    }*

    /**
     * Lấy toàn bộ danh sách thuốc, kèm:
     * - Tổng số lượng tồn (SUM(current_quantity))
     * - Ngày hết hạn gần nhất (MIN(expiry_date))
     */
    // ✅ Lấy danh sách thuốc có tổng tồn và hạn gần nhất
    public List<Medicine> getAllMedicines() {
        List<Medicine> medicines = new ArrayList<>();

        String sql = """
            SELECT 
                m.medicine_code,m.name, m.category, m.description, m.active_ingredient, m.dosage_form, m.strength, m.unit, m.manufacturer, m.country_of_origin, m.drug_group,
                m.drug_type,
                m.created_at,
                m.updated_at,
                ISNULL(SUM(b.current_quantity), 0) AS total_quantity,
                MIN(b.expiry_date) AS nearest_expiry
            FROM Medicines m
            LEFT JOIN Batches b ON m.medicine_code = b.medicine_code
            GROUP BY 
                m.medicine_code, m.name, m.category, m.description,
                m.active_ingredient, m.dosage_form, m.strength, m.unit,
                m.manufacturer, m.country_of_origin, m.drug_group, m.drug_type,
                m.created_at, m.updated_at
            ORDER BY m.name
        """;

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

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

                Batches summary = new Batches();
                summary.setCurrentQuantity(rs.getInt("total_quantity"));
                summary.setExpiryDate(rs.getDate("nearest_expiry"));

                med.getBatches().add(summary);
                medicines.add(med);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return medicines;
    }

// ✅ Tìm kiếm thuốc theo tên, loại và trạng thái tồn kho
    public List<Medicine> searchMedicines(String keyword, String category, String status) {
        List<Medicine> medicines = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT m.medicine_code, m.name, m.category, m.description, "
                + "m.active_ingredient, m.dosage_form, m.strength, m.unit, "
                + "m.manufacturer, m.country_of_origin, m.drug_group, m.drug_type, "
                + "m.created_at, m.updated_at, "
                + "ISNULL(SUM(b.current_quantity), 0) AS total_quantity, MIN(b.expiry_date) AS nearest_expiry "
                + "FROM Medicines m LEFT JOIN Batches b ON m.medicine_code = b.medicine_code WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        // 🔍 Tìm theo tên hoặc mô tả
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (m.name LIKE ? OR m.description LIKE ?) ");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
        }

        // 🏷 Lọc theo loại
        if (category != null && !category.equals("All") && !category.trim().isEmpty()) {
            sql.append("AND m.category = ? ");
            params.add(category);
        }

        // 📦 Lọc theo trạng thái tồn kho
        if (status != null && !status.trim().isEmpty()) {
            switch (status) {
                case "In Stock" ->
                    sql.append("AND m.medicine_code IN (SELECT medicine_code FROM Batches GROUP BY medicine_code HAVING SUM(current_quantity) > 50) ");
                case "Low Stock" ->
                    sql.append("AND m.medicine_code IN (SELECT medicine_code FROM Batches GROUP BY medicine_code HAVING SUM(current_quantity) BETWEEN 1 AND 50) ");
                case "Out of Stock" ->
                    sql.append("AND m.medicine_code IN (SELECT medicine_code FROM Batches GROUP BY medicine_code HAVING SUM(current_quantity) = 0 OR SUM(current_quantity) IS NULL) ");
            }
        }

        sql.append("GROUP BY m.medicine_code, m.name, m.category, m.description, m.active_ingredient, m.dosage_form, m.strength, m.unit, m.manufacturer, m.country_of_origin, m.drug_group, m.drug_type, m.created_at, m.updated_at ORDER BY m.name");

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
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

                Batches batch = new Batches();
                batch.setCurrentQuantity(rs.getInt("total_quantity"));
                batch.setExpiryDate(rs.getDate("nearest_expiry"));
                med.getBatches().add(batch);

                medicines.add(med);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return medicines;
    }

    // Method lấy danh sách categories
    public List<String> getAllCategories() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT category FROM Medicines ORDER BY category";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                categories.add(rs.getString("category"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return categories;
    }

    // ===================== ADD =====================
    public boolean addMedicine(Medicine med, Batches batch) {
        String sqlMed = """
        INSERT INTO Medicines
        (medicine_code, name, category, description, active_ingredient, dosage_form,
         strength, unit, manufacturer, country_of_origin, drug_group, drug_type)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    """;

        String sqlBatch = """
        INSERT INTO Batches
        (medicine_code, supplier_id, lot_number, expiry_date, initial_quantity,
         current_quantity, status)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    """;

        try (Connection conn = dbContext.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement psMed = conn.prepareStatement(sqlMed)) {
                psMed.setString(1, med.getMedicineCode());
                psMed.setString(2, med.getName());
                psMed.setString(3, med.getCategory());
                psMed.setString(4, med.getDescription());
                psMed.setString(5, med.getActiveIngredient());
                psMed.setString(6, med.getDosageForm());
                psMed.setString(7, med.getStrength());
                psMed.setString(8, med.getUnit());
                psMed.setString(9, med.getManufacturer());
                psMed.setString(10, med.getCountryOfOrigin());
                psMed.setString(11, med.getDrugGroup());
                psMed.setString(12, med.getDrugType());
                psMed.executeUpdate();
            }

            try (PreparedStatement psBatch = conn.prepareStatement(sqlBatch)) {
                psBatch.setString(1, med.getMedicineCode());
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

    // ===================== UPDATE =====================
   
    // Update medicine + batch
    public boolean updateMedicine(Medicine med, Batches batch) {
        String sqlMed = """
            UPDATE Medicines
            SET name=?, category=?, description=?, active_ingredient=?, dosage_form=?, strength=?,
                unit=?, manufacturer=?, country_of_origin=?, drug_group=?, drug_type=?
            WHERE medicine_code=?
        """;

        String sqlBatch = """
            UPDATE Batches
            SET lot_number=?, expiry_date=?, current_quantity=?, status=?, supplier_id=?
            WHERE batch_id=?
        """;

        try (Connection conn = dbContext.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement psMed = conn.prepareStatement(sqlMed)) {
                psMed.setString(1, med.getName());
                psMed.setString(2, med.getCategory());
                psMed.setString(3, med.getDescription());
                psMed.setString(4, med.getActiveIngredient());
                psMed.setString(5, med.getDosageForm());
                psMed.setString(6, med.getStrength());
                psMed.setString(7, med.getUnit());
                psMed.setString(8, med.getManufacturer());
                psMed.setString(9, med.getCountryOfOrigin());
                psMed.setString(10, med.getDrugGroup());
                psMed.setString(11, med.getDrugType());
                psMed.setString(12, med.getMedicineCode());
                int rows = psMed.executeUpdate();
                if(rows==0){
                    conn.rollback(); return false;
                }
            }

            try (PreparedStatement psBatch = conn.prepareStatement(sqlBatch)) {
                psBatch.setString(1, batch.getLotNumber());
                if(batch.getExpiryDate()!=null){
                    psBatch.setDate(2, new java.sql.Date(batch.getExpiryDate().getTime()));
                } else psBatch.setNull(2, java.sql.Types.DATE);
                psBatch.setInt(3, batch.getCurrentQuantity());
                psBatch.setString(4, batch.getStatus());
                psBatch.setInt(5, batch.getSupplierId());
                psBatch.setInt(6, batch.getBatchId());
                int rows = psBatch.executeUpdate();
                if(rows==0){
                    conn.rollback(); return false;
                }
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    // ===================== DELETE =====================
    public boolean deleteMedicine(String medicineCode) {
        String sqlBatch = "DELETE FROM Batches WHERE medicine_code=?";
        String sqlMed = "DELETE FROM Medicines WHERE medicine_code=?";

        try (Connection conn = dbContext.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement ps1 = conn.prepareStatement(sqlBatch)) {
                ps1.setString(1, medicineCode);
                ps1.executeUpdate();
            }

            try (PreparedStatement ps2 = conn.prepareStatement(sqlMed)) {
                ps2.setString(1, medicineCode);
                ps2.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ===================== Record Expired/Damaged Medicines =====================
    public boolean recordExpiredOrDamaged(int batchId, int userId, int quantity, String reason, String notes) {
        String insertSql = "INSERT INTO Transactions (batch_id, user_id, type, quantity, transaction_date, notes) "
                + "VALUES (?, ?, ?, ?, GETDATE(), ?)";
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
            int medicineId = rs.getInt("medicine_code");
            if (medicineId != currentMedicineId) {
                if (currentMedicine != null) {
                    medicines.add(currentMedicine);
                }
                currentMedicine = new Medicine();
                currentMedicine.setMedicineCode(rs.getString("medicine_code"));
                currentMedicine.setName(rs.getString("name"));
                currentMedicine.setCategory(rs.getString("category"));
                currentMedicine.setDescription(rs.getString("description"));
                currentMedicineId = medicineId;
            }

            // Thêm thông tin batch
            Batches batch = new Batches();
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
