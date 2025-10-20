package DAO;

import model.Supplier;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class SupplierDAO extends DBContext{

    public List<Supplier> getAllSuppliers() throws SQLException {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT * FROM Suppliers ORDER BY supplier_id";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                suppliers.add(mapResultSetToSupplier(rs));
            }
        }
        return suppliers;
    }

    public Optional<Supplier> getSupplierById(int supplierId) throws SQLException {
        String sql = "SELECT * FROM Suppliers WHERE supplier_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, supplierId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToSupplier(rs));
                }
            }
        }
        return Optional.empty();
    }

    public boolean addSupplier(Supplier supplier) throws SQLException {
        String sql = "INSERT INTO Suppliers (name, contact_email, contact_phone, address, performance_rating, created_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, supplier.getName());
            stmt.setString(2, supplier.getContactEmail());
            stmt.setString(3, supplier.getContactPhone());
            stmt.setString(4, supplier.getAddress());
            
            if (supplier.getPerformanceRating() != null) {
                stmt.setDouble(5, supplier.getPerformanceRating());
            } else {
                stmt.setNull(5, Types.DOUBLE);
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

    public boolean deleteSupplier(int supplierId) throws SQLException {
        String sql = "DELETE FROM Suppliers WHERE supplier_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, supplierId);
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }

    public List<Supplier> findSuppliersByName(String name) throws SQLException {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT * FROM Suppliers WHERE name LIKE ? ORDER BY name";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, "%" + name + "%");
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    suppliers.add(mapResultSetToSupplier(rs));
                }
            }
        }
        return suppliers;
    }

    private Supplier mapResultSetToSupplier(ResultSet rs) throws SQLException {
        Supplier supplier = new Supplier();
        supplier.setSupplierId(rs.getInt("supplier_id"));
        supplier.setName(rs.getString("name"));
        supplier.setContactEmail(rs.getString("contact_email"));
        supplier.setContactPhone(rs.getString("contact_phone"));
        supplier.setAddress(rs.getString("address"));
        
        double rating = rs.getDouble("performance_rating");
        if (!rs.wasNull()) {
            supplier.setPerformanceRating(rating);
        }
        
        supplier.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            supplier.setUpdatedAt(updatedAt.toLocalDateTime());
        }
        
        return supplier;
    }
}