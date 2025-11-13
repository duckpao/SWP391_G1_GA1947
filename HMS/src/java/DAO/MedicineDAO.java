package DAO;

import static DAO.DBContext.getConnection;
import model.Medicine;
import model.Batches;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Statement;
import java.util.LinkedHashMap;
import java.util.Map;
import model.Supplier;

public class MedicineDAO {

    private DBContext dbContext;

    public MedicineDAO() {
        dbContext = new DBContext();
    }

    // ✅ Lấy danh sách thuốc có tổng tồn và hạn gần nhất
public List<Medicine> getAllMedicines() {
    List<Medicine> medicines = new ArrayList<>();
    Map<String, Medicine> medicineMap = new LinkedHashMap<>();

    String sql = """
        SELECT 
            m.medicine_code,
            m.name AS medicine_name,
            m.category,
            m.description,
            m.active_ingredient,
            m.dosage_form,
            m.strength,
            m.unit,
            m.manufacturer,
            m.country_of_origin,
            m.drug_group,
            m.drug_type,
            m.created_at,
            m.updated_at,
            b.batch_id,
            b.supplier_id,
            b.lot_number,
            b.current_quantity,
            b.initial_quantity,
            b.expiry_date,
            b.received_date,
            b.status,
            s.name AS supplier_name
        FROM Medicines m
        LEFT JOIN Batches b ON m.medicine_code = b.medicine_code
        LEFT JOIN Suppliers s ON b.supplier_id = s.supplier_id
        ORDER BY m.name, b.expiry_date ASC;
    """;

    try (Connection conn = dbContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            String medicineCode = rs.getString("medicine_code");
            
            // Nếu medicine chưa có trong map, tạo mới
            Medicine med = medicineMap.get(medicineCode);
            if (med == null) {
                med = new Medicine(
                    medicineCode,
                    rs.getString("medicine_name"),
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
                med.setSupplierName(rs.getString("supplier_name"));
                medicineMap.put(medicineCode, med);
            }

            // Thêm batch vào medicine (nếu có)
            if (rs.getInt("batch_id") > 0) {
                Batches batch = new Batches();
                batch.setBatchId(rs.getInt("batch_id"));
                batch.setMedicineCode(medicineCode);
                batch.setSupplierId(rs.getInt("supplier_id"));
                batch.setLotNumber(rs.getString("lot_number"));
                batch.setCurrentQuantity(rs.getInt("current_quantity"));
                batch.setInitialQuantity(rs.getInt("initial_quantity"));
                batch.setExpiryDate(rs.getDate("expiry_date"));
                batch.setReceivedDate(rs.getDate("received_date"));
                batch.setStatus(rs.getString("status"));
                
                med.getBatches().add(batch);
            }
        }
        
        medicines.addAll(medicineMap.values());

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return medicines;
}

// ✅ Tìm kiếm thuốc theo tên, loại và trạng thái tồn kho
public List<Medicine> searchMedicines(String keyword, String category, String activeIngredient,
                                      String drugGroup, String drugType, String status) {
    Map<String, Medicine> medicineMap = new LinkedHashMap<>();
    
    StringBuilder sql = new StringBuilder(
        "SELECT m.medicine_code, m.name, m.category, m.description, " +
        "m.active_ingredient, m.dosage_form, m.strength, m.unit, " +
        "m.manufacturer, m.country_of_origin, m.drug_group, m.drug_type, " +
        "m.created_at, m.updated_at, " +
        "b.batch_id, b.supplier_id, b.lot_number, b.current_quantity, b.initial_quantity, " +
        "b.expiry_date, b.received_date, b.status, " +
        "s.name AS supplier_name " +
        "FROM Medicines m " +
        "LEFT JOIN Batches b ON m.medicine_code = b.medicine_code " +
        "LEFT JOIN Suppliers s ON b.supplier_id = s.supplier_id " +
        "WHERE 1=1 "
    );

    List<Object> params = new ArrayList<>();

    // Tìm theo keyword
    if (keyword != null && !keyword.trim().isEmpty()) {
        sql.append("AND (m.name LIKE ? OR m.description LIKE ?) ");
        String kw = "%" + keyword.trim() + "%";
        params.add(kw);
        params.add(kw);
    }

    // Lọc theo category
    if (category != null && !category.equals("All") && !category.trim().isEmpty()) {
        sql.append("AND m.category = ? ");
        params.add(category);
    }

    // Lọc theo active ingredient
    if (activeIngredient != null && !activeIngredient.equals("All") && !activeIngredient.trim().isEmpty()) {
        sql.append("AND m.active_ingredient = ? ");
        params.add(activeIngredient);
    }

    // Lọc theo drug group
    if (drugGroup != null && !drugGroup.equals("All") && !drugGroup.trim().isEmpty()) {
        sql.append("AND m.drug_group = ? ");
        params.add(drugGroup);
    }

    // Lọc theo drug type
    if (drugType != null && !drugType.equals("All") && !drugType.trim().isEmpty()) {
        sql.append("AND m.drug_type = ? ");
        params.add(drugType);
    }

    // Lọc theo status tồn kho
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

    sql.append("ORDER BY m.name, b.expiry_date ASC");

    try (Connection conn = dbContext.getConnection(); 
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {

        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            String medicineCode = rs.getString("medicine_code");
            
            Medicine med = medicineMap.get(medicineCode);
            if (med == null) {
                med = new Medicine(
                    medicineCode,
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
                med.setSupplierName(rs.getString("supplier_name"));
                medicineMap.put(medicineCode, med);
            }

            // Thêm batch
            if (rs.getInt("batch_id") > 0) {
                Batches batch = new Batches();
                batch.setBatchId(rs.getInt("batch_id"));
                batch.setMedicineCode(medicineCode);
                batch.setSupplierId(rs.getInt("supplier_id"));
                batch.setLotNumber(rs.getString("lot_number"));
                batch.setCurrentQuantity(rs.getInt("current_quantity"));
                batch.setInitialQuantity(rs.getInt("initial_quantity"));
                batch.setExpiryDate(rs.getDate("expiry_date"));
                batch.setReceivedDate(rs.getDate("received_date"));
                batch.setStatus(rs.getString("status"));
                
                med.getBatches().add(batch);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return new ArrayList<>(medicineMap.values());
}

    public List<String> getAllCategories() throws SQLException {
    List<String> list = new ArrayList<>();
    String sql = "SELECT DISTINCT category FROM Medicines WHERE category IS NOT NULL AND category <> '' ORDER BY category";
    try (Connection conn = dbContext.getConnection(); 
            PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            list.add(rs.getString("category"));
        }
    }
    return list;
}

public List<String> getAllActiveIngredients() throws SQLException {
    List<String> list = new ArrayList<>();
    String sql = "SELECT DISTINCT active_ingredient FROM Medicines WHERE active_ingredient IS NOT NULL AND active_ingredient <> '' ORDER BY active_ingredient";
    try (Connection conn = dbContext.getConnection(); 
            PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            list.add(rs.getString("active_ingredient"));
        }
    }
    return list;
}

public List<String> getAllDrugGroups() throws SQLException {
    List<String> list = new ArrayList<>();
    String sql = "SELECT DISTINCT drug_group FROM Medicines WHERE drug_group IS NOT NULL AND drug_group <> '' ORDER BY drug_group";
    try (Connection conn = dbContext.getConnection(); 
            PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            list.add(rs.getString("drug_group"));
        }
    }
    return list;
}

public List<String> getAllDrugTypes() throws SQLException {
    List<String> list = new ArrayList<>();
    String sql = "SELECT DISTINCT drug_type FROM Medicines WHERE drug_type IS NOT NULL AND drug_type <> '' ORDER BY drug_type";
    try (Connection conn = dbContext.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            list.add(rs.getString("drug_type"));
        }
    }
    return list;
}


    public String generateNextMedicineCode() {
    String nextCode = "MED001"; // Giá trị mặc định nếu chưa có thuốc nào
    String sql = "SELECT TOP 1 medicine_code FROM Medicines ORDER BY medicine_code DESC";

    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        if (rs.next()) {
            String lastCode = rs.getString("medicine_code"); // Ví dụ: MED012
            if (lastCode != null && lastCode.startsWith("MED")) {
                int num = Integer.parseInt(lastCode.substring(3)); // lấy phần số: 12
                nextCode = String.format("MED%03d", num + 1); // MED013
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return nextCode;
}
public String generateNextLotNumber() throws SQLException {
    int year = java.time.LocalDate.now().getYear();
    String prefix = "LOT" + year;

    String sql = "SELECT TOP 1 lot_number FROM Batches WHERE lot_number LIKE ? ORDER BY lot_number DESC";

    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, prefix + "%");
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            String lastLot = rs.getString(1);
            if (lastLot != null && lastLot.startsWith(prefix)) {
                // Cắt phần số sau năm
                String numberPart = lastLot.substring(prefix.length());
                int num = Integer.parseInt(numberPart);
                return prefix + String.format("%03d", num + 1);
            }
        }
    }
    // Nếu chưa có lô nào trong năm nay → bắt đầu từ 001
    return prefix + "001";
}


    // 🔹 Lấy danh sách nhà cung cấp (supplier)
    public List<Supplier> getAllSuppliers() throws SQLException {
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
        }
        return list;
    }

    // ===================== THÊM THUỐC MỚI =====================
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
   
    public boolean updateMedicine(Medicine m, Batches b) {
    String sqlMedicine = "UPDATE Medicines SET name=?, category=?, description=?, " +
                         "active_ingredient=?, dosage_form=?, strength=?, unit=?, " +
                         "manufacturer=?, country_of_origin=?, drug_group=?, drug_type=?, " +
                         "updated_at=GETDATE() WHERE medicine_code=?";

    String sqlBatchUpdate = "UPDATE Batches SET supplier_id=?, expiry_date=?, current_quantity=?, updated_at=GETDATE() " +
                            "WHERE batch_id=? AND medicine_code=?";

    try (Connection conn = dbContext.getConnection()) {
        conn.setAutoCommit(false);

        // 1️⃣ Update Medicine
        try (PreparedStatement psMed = conn.prepareStatement(sqlMedicine)) {
            psMed.setString(1, m.getName());
            psMed.setString(2, m.getCategory());
            psMed.setString(3, m.getDescription());
            psMed.setString(4, m.getActiveIngredient());
            psMed.setString(5, m.getDosageForm());
            psMed.setString(6, m.getStrength());
            psMed.setString(7, m.getUnit());
            psMed.setString(8, m.getManufacturer());
            psMed.setString(9, m.getCountryOfOrigin());
            psMed.setString(10, m.getDrugGroup());
            psMed.setString(11, m.getDrugType());
            psMed.setString(12, m.getMedicineCode());
            psMed.executeUpdate();
        }

        // 2️⃣ Update Batch
        if (b != null && b.getBatchId() > 0) {
            try (PreparedStatement psBatch = conn.prepareStatement(sqlBatchUpdate)) {
                psBatch.setInt(1, b.getSupplierId());
                if (b.getExpiryDate() != null) psBatch.setDate(2, new java.sql.Date(b.getExpiryDate().getTime()));
                else psBatch.setNull(2, java.sql.Types.DATE);
                psBatch.setInt(3, b.getCurrentQuantity());
                psBatch.setInt(4, b.getBatchId());
                psBatch.setString(5, b.getMedicineCode());

                int rows = psBatch.executeUpdate();
                System.out.println("Batch rows updated: " + rows);

                if (rows == 0) {
                    System.out.println("⚠️ Không tìm thấy batch để update! Kiểm tra batchId và medicineCode");
                }
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
    
    
    public static void main(String[] args) {
    MedicineDAO dao = new MedicineDAO();

    // 1️⃣ Tạo đối tượng Medicine cần update (có thể chỉ cập nhật tên hoặc thông tin khác nếu muốn)
    Medicine m = new Medicine();
    m.setMedicineCode("MED010"); // medicine_code batch 5
    m.setName("Updated MED010"); // đổi tên để test
    m.setCategory("Thuốc kháng sinh");
    m.setDescription("Mô tả cập nhật cho MED010");
    m.setActiveIngredient("Amoxicillin");
    m.setDosageForm("Viên nang");
    m.setStrength("500mg");
    m.setUnit("Viên");
    m.setManufacturer("Công ty XYZ");
    m.setCountryOfOrigin("Việt Nam");
    m.setDrugGroup("OTC");
    m.setDrugType("Khác");

    // 2️⃣ Tạo đối tượng Batch cần update
    Batches b = new Batches();
    b.setBatchId(5); // batch_id cần update
    b.setMedicineCode("MED010");
    b.setSupplierId(3); // thay đổi nhà cung cấp
    b.setExpiryDate(new java.sql.Date(java.util.Date.from(java.time.LocalDate.of(2028, 12, 31)
                                                .atStartOfDay(java.time.ZoneId.systemDefault()).toInstant()).getTime())); // cập nhật HSD
    b.setCurrentQuantity(1111); // cập nhật số lượng

    // 3️⃣ Gọi hàm update
    boolean result = dao.updateMedicine(m, b);

    // 4️⃣ In kết quả
    if (result) {
        System.out.println("✅ Cập nhật batch_id 5 thành công!");
    } else {
        System.out.println("❌ Cập nhật batch_id 5 thất bại!");
    }

    // 5️⃣ Kiểm tra lại dữ liệu batch
    List<Medicine> medicines = dao.getAllMedicines();
    for (Medicine med : medicines) {
        if (med.getMedicineCode().equals("MED010")) {
            System.out.println("Tên thuốc: " + med.getName());
            for (Batches batch : med.getBatches()) {
                if (batch.getBatchId() == 5) {
                    System.out.println("BatchId: " + batch.getBatchId() +
                                       ", SupplierId: " + batch.getSupplierId() +
                                       ", Số lượng: " + batch.getCurrentQuantity() +
                                       ", HSD: " + batch.getExpiryDate());
                }
            }
        }
    }
}

}
