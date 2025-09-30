package DAO;

import Model.Medicine;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MedicineDAO {
    private Connection conn;

    public MedicineDAO() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = DriverManager.getConnection(
                "jdbc:sqlserver://localhost:1433;databaseName=SWP391;encrypt=true;trustServerCertificate=true",
                "sa",
                "123"
            );
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

  // Lấy danh sách thuốc (JOIN 3 bảng)
 public List<Medicine> getMedicines() {
    List<Medicine> list = new ArrayList<>();
    String sql = """
        SELECT m.medicine_id, m.name, m.category, m.description,
               s.name AS supplierName,
               SUM(b.current_quantity) AS totalStock,
               MIN(b.expiry_date) AS nearestExpiry,   -- hạn sử dụng gần nhất
               CASE 
                   WHEN SUM(b.current_quantity) <= 0 THEN 'Hết hàng'
                   WHEN MIN(b.expiry_date) < GETDATE() THEN 'Hết hạn'
                   ELSE 'Còn hàng'
               END AS status
        FROM Medicines m
        LEFT JOIN Batches b ON m.medicine_id = b.medicine_id
        LEFT JOIN Suppliers s ON b.supplier_id = s.supplier_id
        GROUP BY m.medicine_id, m.name, m.category, m.description, s.name
        """;

    try (PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            Medicine med = new Medicine();
            med.setId(rs.getInt("medicine_id"));
            med.setName(rs.getString("name"));
            med.setCategory(rs.getString("category"));
            med.setDescription(rs.getString("description"));
            med.setSupplierName(rs.getString("supplierName"));
            med.setTotalStock(rs.getInt("totalStock"));
            med.setNearestExpiry(rs.getDate("nearestExpiry")); // hạn sử dụng gần nhất
            med.setStatus(rs.getString("status"));
            list.add(med);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}


    // Thêm thuốc + batch
    // ================= Thêm thuốc + batch =================
public boolean addMedicineWithBatch(String name, String category, String description,
                                    int supplierId, String lotNumber,
                                    Date expiryDate, int quantity) {
    String insertMedicine = "INSERT INTO Medicines(name, category, description, created_at, updated_at) " +
                            "VALUES (?, ?, ?, GETDATE(), GETDATE())";

    String insertBatch = """
        INSERT INTO Batches(medicine_id, supplier_id, lot_number, expiry_date,
                            received_date, initial_quantity, current_quantity, status, created_at, updated_at)
        VALUES (?, ?, ?, ?, GETDATE(), ?, ?, 'Received', GETDATE(), GETDATE())
        """;

    try {
        conn.setAutoCommit(false);

        // 1. Insert vào bảng Medicines
        int medicineId;
        try (PreparedStatement ps = conn.prepareStatement(insertMedicine, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, name);
            ps.setString(2, category);
            ps.setString(3, description);
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    medicineId = rs.getInt(1);
                } else {
                    conn.rollback();
                    return false;
                }
            }
        }

        // 2. Insert vào bảng Batches
        try (PreparedStatement ps = conn.prepareStatement(insertBatch)) {
            ps.setInt(1, medicineId);
            ps.setInt(2, supplierId);
            ps.setString(3, lotNumber);
            ps.setDate(4, new java.sql.Date(expiryDate.getTime()));
            ps.setInt(5, quantity);
            ps.setInt(6, quantity);
            ps.executeUpdate();
        }

        conn.commit();
        return true;
    } catch (Exception e) {
        e.printStackTrace();
        try {
            conn.rollback();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    } finally {
        try {
            conn.setAutoCommit(true);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}


// Cập nhật thuốc + batch
public boolean updateMedicine(int id, String name, String category, String description,
                              Date expiryDate, int totalStock) {
    String sqlMedicine = "UPDATE Medicines SET name=?, category=?, description=?, updated_at=GETDATE() " +
                         "WHERE medicine_id=?";
    String sqlBatch = "UPDATE Batches SET expiry_date=?, current_quantity=?, updated_at=GETDATE() " +
                      "WHERE medicine_id=?";

    try {
        conn.setAutoCommit(false);

        // Update Medicines
        try (PreparedStatement ps = conn.prepareStatement(sqlMedicine)) {
            ps.setString(1, name);
            ps.setString(2, category);
            ps.setString(3, description);
            ps.setInt(4, id);
            ps.executeUpdate();
        }

        // Update Batches
        try (PreparedStatement ps2 = conn.prepareStatement(sqlBatch)) {
            ps2.setDate(1, expiryDate);
            ps2.setInt(2, totalStock);
            ps2.setInt(3, id);
            ps2.executeUpdate();
        }

        conn.commit();
        return true;
    } catch (SQLException e) {
        e.printStackTrace();
        try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
        return false;
    } finally {
        try { conn.setAutoCommit(true); } catch (SQLException ex) { ex.printStackTrace(); }
    }
}


    // Xóa thuốc
// MedicineDAO.java
public boolean deleteMedicine(int id) {
    String sqlBatch = "DELETE FROM Batches WHERE medicine_id=?";
    String sqlMed = "DELETE FROM Medicines WHERE medicine_id=?";
    try {
        conn.setAutoCommit(false);

        // Xóa các batch liên quan trước
        try (PreparedStatement ps1 = conn.prepareStatement(sqlBatch)) {
            ps1.setInt(1, id);
            ps1.executeUpdate();
        }

        // Sau đó xóa thuốc
        try (PreparedStatement ps2 = conn.prepareStatement(sqlMed)) {
            ps2.setInt(1, id);
            ps2.executeUpdate();
        }

        conn.commit();
        return true;
    } catch (Exception e) {
        e.printStackTrace();
        try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
        return false;
    } finally {
        try { conn.setAutoCommit(true); } catch (SQLException e) { e.printStackTrace(); }
    }
}

}
