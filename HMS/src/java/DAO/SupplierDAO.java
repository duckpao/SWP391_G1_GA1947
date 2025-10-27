package DAO;

import model.Supplier;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.time.LocalDateTime;

public class SupplierDAO extends DBContext {

    public SupplierDAO() {
        super();
        System.out.println("SupplierDAO initialized");
    }

//    // Lấy toàn bộ danh sách Supplier
//    public List<Supplier> getAllSuppliers() throws SQLException {
//        List<Supplier> suppliers = new ArrayList<>();
//        String sql = "SELECT * FROM Suppliers ORDER BY supplier_id";
//
//        try (Connection conn = getConnection();
//             PreparedStatement stmt = conn.prepareStatement(sql);
//             ResultSet rs = stmt.executeQuery()) {
//
//            while (rs.next()) {
//                suppliers.add(mapResultSetToSupplier(rs));
//            }
//        }
//        return suppliers;
//    }
    public List<Supplier> getAllSuppliers() {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT s.supplier_id, s.user_id, s.name, s.contact_email, "
                + "s.contact_phone, s.address, s.performance_rating, "
                + "s.created_at, s.updated_at "
                + "FROM Suppliers s "
                + "ORDER BY s.name";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Supplier supplier = new Supplier();
                supplier.setSupplierId(rs.getInt("supplier_id"));
                supplier.setUserId(rs.getInt("user_id"));
                supplier.setName(rs.getString("name"));
                supplier.setContactEmail(rs.getString("contact_email"));
                supplier.setContactPhone(rs.getString("contact_phone"));
                supplier.setAddress(rs.getString("address"));

                // Handle performance_rating (có thể null)
                Double rating = rs.getObject("performance_rating", Double.class);
                supplier.setPerformanceRating(rating);

                // Convert Timestamp to LocalDateTime
                Timestamp createdTimestamp = rs.getTimestamp("created_at");
                if (createdTimestamp != null) {
                    supplier.setCreatedAt(createdTimestamp.toLocalDateTime());
                }

                Timestamp updatedTimestamp = rs.getTimestamp("updated_at");
                if (updatedTimestamp != null) {
                    supplier.setUpdatedAt(updatedTimestamp.toLocalDateTime());
                }

                list.add(supplier);
            }
        } catch (SQLException e) {
            System.err.println("Error in getAllSuppliers: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public Supplier getSupplierById(int supplierId) {
        String sql = "SELECT s.supplier_id, s.user_id, s.name, s.contact_email, "
                + "s.contact_phone, s.address, s.performance_rating, "
                + "s.created_at, s.updated_at "
                + "FROM Suppliers s "
                + "WHERE s.supplier_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Supplier supplier = new Supplier();
                supplier.setSupplierId(rs.getInt("supplier_id"));
                supplier.setUserId(rs.getInt("user_id"));
                supplier.setName(rs.getString("name"));
                supplier.setContactEmail(rs.getString("contact_email"));
                supplier.setContactPhone(rs.getString("contact_phone"));
                supplier.setAddress(rs.getString("address"));

                // Handle performance_rating (có thể null)
                Double rating = rs.getObject("performance_rating", Double.class);
                supplier.setPerformanceRating(rating);

                // Convert Timestamp to LocalDateTime
                Timestamp createdTimestamp = rs.getTimestamp("created_at");
                if (createdTimestamp != null) {
                    supplier.setCreatedAt(createdTimestamp.toLocalDateTime());
                }

                Timestamp updatedTimestamp = rs.getTimestamp("updated_at");
                if (updatedTimestamp != null) {
                    supplier.setUpdatedAt(updatedTimestamp.toLocalDateTime());
                }

                return supplier;
            }
        } catch (SQLException e) {
            System.err.println("Error in getSupplierById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public Integer getSupplierIdByUserId(int userId) throws SQLException {
        String sql = "SELECT supplier_id FROM Suppliers WHERE user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("supplier_id");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return null; // Không tìm thấy supplier_id
    }

//    // Lấy Supplier theo supplier_id
//    public Optional<Supplier> getSupplierById(int supplierId) throws SQLException {
//        String sql = "SELECT * FROM Suppliers WHERE supplier_id = ?";
//
//        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
//
//            stmt.setInt(1, supplierId);
//            try (ResultSet rs = stmt.executeQuery()) {
//                if (rs.next()) {
//                    return Optional.of(mapResultSetToSupplier(rs));
//                }
//            }
//        }
//        return Optional.empty();
//    }
    // ✅ Lấy Supplier theo user_id (vì Supplier là 1 User)
    public Supplier getSupplierByUserId(int userId) {
        String sql = "SELECT * FROM supplier WHERE user_id = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Supplier s = new Supplier();
                s.setSupplierId(rs.getInt("supplier_id"));
                s.setUserId(rs.getInt("user_id"));
                s.setName(rs.getString("name"));
                s.setContactEmail(rs.getString("contact_email"));
                s.setContactPhone(rs.getString("contact_phone"));
                s.setAddress(rs.getString("address"));
                return s;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Thêm Supplier mới (đã có user_id)
    public boolean addSupplier(Supplier supplier) throws SQLException {
        String sql = "INSERT INTO Suppliers (user_id, name, contact_email, contact_phone, address, performance_rating, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, supplier.getUserId());
            stmt.setString(2, supplier.getName());
            stmt.setString(3, supplier.getContactEmail());
            stmt.setString(4, supplier.getContactPhone());
            stmt.setString(5, supplier.getAddress());

            if (supplier.getPerformanceRating() != null) {
                stmt.setDouble(6, supplier.getPerformanceRating());
            } else {
                stmt.setNull(6, Types.DOUBLE);
            }

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        supplier.setSupplierId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    // Xóa Supplier theo ID
    public boolean deleteSupplier(int supplierId) throws SQLException {
        String sql = "DELETE FROM Suppliers WHERE supplier_id = ?";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, supplierId);
            return stmt.executeUpdate() > 0;
        }
    }

    // Tìm Supplier theo tên
    public List<Supplier> findSuppliersByName(String name) throws SQLException {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT * FROM Suppliers WHERE name LIKE ? ORDER BY name";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, "%" + name + "%");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    suppliers.add(mapResultSetToSupplier(rs));
                }
            }
        }
        return suppliers;
    }

    // Mapping ResultSet → Supplier object
    private Supplier mapResultSetToSupplier(ResultSet rs) throws SQLException {
        Supplier supplier = new Supplier();

        supplier.setSupplierId(rs.getInt("supplier_id"));
        supplier.setUserId(rs.getInt("user_id"));
        supplier.setName(rs.getString("name"));
        supplier.setContactEmail(rs.getString("contact_email"));
        supplier.setContactPhone(rs.getString("contact_phone"));
        supplier.setAddress(rs.getString("address"));

        double rating = rs.getDouble("performance_rating");
        if (!rs.wasNull()) {
            supplier.setPerformanceRating(rating);
        }

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            supplier.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            supplier.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        return supplier;
    }

    public void addSupplierFromUser(int userId) throws SQLException {
        String sql = "INSERT INTO Suppliers (user_id, name, contact_email, contact_phone, created_at) "
                + "SELECT u.user_id, u.username, u.email, u.phone, GETDATE() FROM [User] u WHERE u.user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }

}
