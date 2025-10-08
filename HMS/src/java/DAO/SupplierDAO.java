package DAO;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Supplier;

public class SupplierDAO extends DBContext{
    private DBContext dbcontext;
    
    // Constructor
    public SupplierDAO(Connection connection) {
        this.connection = connection;
    }
    
    
    public int addSupplier(Supplier supplier) {
        String sql = "INSERT INTO [SWP391].[dbo].[Suppliers] " +
                     "(name, contact_email, contact_phone, address, performance_rating, created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, supplier.getName());
            stmt.setString(2, supplier.getContactEmail());
            stmt.setString(3, supplier.getContactPhone());
            stmt.setString(4, supplier.getAddress());
            
            if (supplier.getPerformanceRating() != null) {
                stmt.setDouble(5, supplier.getPerformanceRating());
            } else {
                stmt.setNull(5, Types.DOUBLE);
            }
            
            stmt.setTimestamp(6, Timestamp.valueOf(supplier.getCreatedAt()));
            stmt.setTimestamp(7, Timestamp.valueOf(supplier.getUpdatedAt()));
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int generatedId = generatedKeys.getInt(1);
                        supplier.setSupplierId(generatedId);
                        return generatedId;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return -1;
    }
    
    /**
     * Get supplier by ID
     * @param supplierId The supplier ID
     * @return Supplier object or null if not found
     */
    public Supplier getSupplierById(int supplierId) {
        String sql = "SELECT TOP (1) [supplier_id], [name], [contact_email], [contact_phone], " +
                     "[address], [performance_rating], [created_at], [updated_at] " +
                     "FROM [SWP391].[dbo].[Suppliers] " +
                     "WHERE [supplier_id] = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, supplierId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSupplier(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get all suppliers
     * @return List of all suppliers
     */
    public List<Supplier> getAllSuppliers() {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT [supplier_id], [name], [contact_email], [contact_phone], " +
                     "[address], [performance_rating], [created_at], [updated_at] " +
                     "FROM [SWP391].[dbo].[Suppliers]";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                suppliers.add(mapResultSetToSupplier(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return suppliers;
    }
    
    /**
     * Update an existing supplier
     * @param supplier The supplier object with updated information
     * @return true if update was successful, false otherwise
     */
    public boolean updateSupplier(Supplier supplier) {
        String sql = "UPDATE [SWP391].[dbo].[Suppliers] " +
                     "SET [name] = ?, [contact_email] = ?, [contact_phone] = ?, " +
                     "[address] = ?, [performance_rating] = ?, [updated_at] = ? " +
                     "WHERE [supplier_id] = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, supplier.getName());
            stmt.setString(2, supplier.getContactEmail());
            stmt.setString(3, supplier.getContactPhone());
            stmt.setString(4, supplier.getAddress());
            
            if (supplier.getPerformanceRating() != null) {
                stmt.setDouble(5, supplier.getPerformanceRating());
            } else {
                stmt.setNull(5, Types.DOUBLE);
            }
            
            stmt.setTimestamp(6, Timestamp.valueOf(LocalDateTime.now()));
            stmt.setInt(7, supplier.getSupplierId());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Delete a supplier by ID
     * @param supplierId The supplier ID to delete
     * @return true if deletion was successful, false otherwise
     */
    public boolean deleteSupplier(int supplierId) {
        String sql = "DELETE FROM [SWP391].[dbo].[Suppliers] WHERE [supplier_id] = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, supplierId);
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
 
    private Supplier mapResultSetToSupplier(ResultSet rs) throws SQLException {
        Supplier supplier = new Supplier();
        supplier.setSupplierId(rs.getInt("supplier_id"));
        supplier.setName(rs.getString("name"));
        supplier.setContactEmail(rs.getString("contact_email"));
        supplier.setContactPhone(rs.getString("contact_phone"));
        supplier.setAddress(rs.getString("address"));
        
        Double rating = rs.getDouble("performance_rating");
        supplier.setPerformanceRating(rs.wasNull() ? null : rating);
        
        Timestamp createdAt = rs.getTimestamp("created_at");
        supplier.setCreatedAt(createdAt != null ? createdAt.toLocalDateTime() : null);
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        supplier.setUpdatedAt(updatedAt != null ? updatedAt.toLocalDateTime() : null);
        
        return supplier;
    }
    
}