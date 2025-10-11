package DAO;

import model.Manager;
import model.PurchaseOrder;
import model.StockAlert;
import model.Supplier;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class ManagerDAO extends DBContext {

    public Manager getManagerById(int userId) {
        Manager manager = null;
        String query = "SELECT * FROM Users WHERE user_id = ? AND role = 'Manager'";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                manager = new Manager();
                manager.setUserId(rs.getInt("user_id"));
                manager.setUsername(rs.getString("username"));
                manager.setPasswordHash(rs.getString("password_hash"));
                manager.setEmail(rs.getString("email"));
                manager.setPhone(rs.getString("phone"));
                manager.setRole(rs.getString("role"));
                manager.setActive(rs.getBoolean("is_active"));
                manager.setFailedAttempts(rs.getInt("failed_attempts"));
                manager.setLastLogin(rs.getTimestamp("last_login"));
                manager.setCreatedAt(rs.getTimestamp("created_at"));
                manager.setUpdatedAt(rs.getTimestamp("updated_at"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return manager;
    }

    public String getWarehouseStatus() {
        String query = "SELECT SUM(current_quantity) AS total_stock FROM Batches";
        try (PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                int totalStock = rs.getInt("total_stock");
                String capacityQuery = "SELECT config_value FROM SystemConfig WHERE config_key = 'warehouse_capacity'";
                PreparedStatement psCapacity = connection.prepareStatement(capacityQuery);
                ResultSet rsCapacity = psCapacity.executeQuery();
                int capacity = rsCapacity.next() ? Integer.parseInt(rsCapacity.getString("config_value")) : 10000;
                return "Total Stock: " + totalStock + " / Capacity: " + capacity + " (Usage: " + (totalStock * 100 / capacity) + "%)";
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "Error fetching status";
    }

    // Lấy danh sách Stock Alerts với thông tin chi tiết
    public List<StockAlert> getStockAlerts() {
        List<StockAlert> alerts = new ArrayList<>();
        String thresholdQuery = "SELECT config_value FROM SystemConfig WHERE config_key = 'low_stock_threshold'";
        int threshold = 10;
        
        try {
            PreparedStatement psThreshold = connection.prepareStatement(thresholdQuery);
            ResultSet rsThreshold = psThreshold.executeQuery();
            if (rsThreshold.next()) {
                threshold = Integer.parseInt(rsThreshold.getString("config_value"));
            }

            String query = "SELECT m.medicine_id, m.name, m.category, " +
                          "SUM(b.current_quantity) as total_quantity, " +
                          "MIN(b.expiry_date) as nearest_expiry " +
                          "FROM Batches b " +
                          "JOIN Medicines m ON b.medicine_id = m.medicine_id " +
                          "WHERE b.status != 'Expired' " +
                          "GROUP BY m.medicine_id, m.name, m.category " +
                          "HAVING SUM(b.current_quantity) < ?";
            
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setInt(1, threshold);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                StockAlert alert = new StockAlert();
                alert.setMedicineId(rs.getInt("medicine_id"));
                alert.setMedicineName(rs.getString("name"));
                alert.setCategory(rs.getString("category"));
                alert.setCurrentQuantity(rs.getInt("total_quantity"));
                alert.setThreshold(threshold);
                alert.setNearestExpiry(rs.getDate("nearest_expiry"));
                alert.setAlertLevel(calculateAlertLevel(rs.getInt("total_quantity"), threshold));
                alerts.add(alert);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return alerts;
    }

    private String calculateAlertLevel(int quantity, int threshold) {
        if (quantity == 0) return "Critical";
        if (quantity < threshold / 2) return "High";
        return "Medium";
    }

    // Lấy danh sách Purchase Orders đang chờ
    public List<PurchaseOrder> getPendingStockRequests() {
        List<PurchaseOrder> requests = new ArrayList<>();
        String query = "SELECT po.po_id, po.manager_id, po.supplier_id, po.status, " +
                      "po.order_date, po.expected_delivery_date, po.notes, " +
                      "s.name as supplier_name, u.username as manager_name " +
                      "FROM PurchaseOrders po " +
                      "LEFT JOIN Suppliers s ON po.supplier_id = s.supplier_id " +
                      "LEFT JOIN Users u ON po.manager_id = u.user_id " +
                      "WHERE po.status IN ('Draft', 'Sent') " +
                      "ORDER BY po.order_date DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                PurchaseOrder po = new PurchaseOrder();
                po.setPoId(rs.getInt("po_id"));
                po.setManagerId(rs.getInt("manager_id"));
                po.setSupplierId(rs.getInt("supplier_id"));
                po.setStatus(rs.getString("status"));
                po.setOrderDate(rs.getDate("order_date"));
                po.setExpectedDeliveryDate(rs.getDate("expected_delivery_date"));
                po.setNotes(rs.getString("notes"));
                po.setSupplierName(rs.getString("supplier_name"));
                po.setManagerName(rs.getString("manager_name"));
                requests.add(po);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return requests;
    }

    // Lấy chi tiết Purchase Order
    public PurchaseOrder getPurchaseOrderById(int poId) {
        String query = "SELECT po.*, s.name as supplier_name, u.username as manager_name " +
                      "FROM PurchaseOrders po " +
                      "LEFT JOIN Suppliers s ON po.supplier_id = s.supplier_id " +
                      "LEFT JOIN Users u ON po.manager_id = u.user_id " +
                      "WHERE po.po_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, poId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                PurchaseOrder po = new PurchaseOrder();
                po.setPoId(rs.getInt("po_id"));
                po.setManagerId(rs.getInt("manager_id"));
                po.setSupplierId(rs.getInt("supplier_id"));
                po.setStatus(rs.getString("status"));
                po.setOrderDate(rs.getDate("order_date"));
                po.setExpectedDeliveryDate(rs.getDate("expected_delivery_date"));
                po.setNotes(rs.getString("notes"));
                po.setSupplierName(rs.getString("supplier_name"));
                po.setManagerName(rs.getString("manager_name"));
                return po;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Approve Stock Request
    public boolean approveStockRequest(int poId, int managerId) {
        String query = "UPDATE PurchaseOrders SET status = 'Approved', manager_id = ? WHERE po_id = ? AND status = 'Sent'";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, managerId);
            ps.setInt(2, poId);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Reject Stock Request
    public boolean rejectStockRequest(int poId, String reason) {
        String query = "UPDATE PurchaseOrders SET status = 'Cancelled', notes = CONCAT(IFNULL(notes, ''), '\nRejection Reason: ', ?) WHERE po_id = ? AND status = 'Sent'";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, reason);
            ps.setInt(2, poId);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Tạo mới Purchase Order (supplier optional)
    public int createPurchaseOrder(int managerId, Integer supplierId, Date expectedDeliveryDate, String notes) {
        String query = "INSERT INTO PurchaseOrders (manager_id, supplier_id, status, order_date, expected_delivery_date, notes) " +
                      "VALUES (?, ?, 'Draft', GETDATE(), ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(query, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, managerId);
            
            // Supplier can be NULL
            if (supplierId != null) {
                ps.setInt(2, supplierId);
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            
            ps.setDate(3, expectedDeliveryDate);
            ps.setString(4, notes);
            
            int result = ps.executeUpdate();
            
            if (result > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1); // Return the generated PO ID
                }
            }
        } catch (SQLException e) {
            System.err.println("Error creating purchase order: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    // Lấy danh sách Suppliers
    public List<Supplier> getAllSuppliers() {
        List<Supplier> suppliers = new ArrayList<>();
        String query = "SELECT * FROM Suppliers ORDER BY name";
        try (PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Supplier supplier = new Supplier();
                supplier.setSupplierId(rs.getInt("supplier_id"));
                supplier.setName(rs.getString("name"));
                
                // Handle NULL values
                supplier.setContactEmail(rs.getString("contact_email"));
                supplier.setContactPhone(rs.getString("contact_phone"));
                supplier.setAddress(rs.getString("address"));
                
                // Handle performance_rating - might be NULL
                Double rating = rs.getDouble("performance_rating");
                if (!rs.wasNull()) {
                    supplier.setPerformanceRating(rating);
                }
                
                supplier.setCreatedAt(rs.getTimestamp("created_at"));
                supplier.setUpdatedAt(rs.getTimestamp("updated_at"));
                suppliers.add(supplier);
            }
        } catch (SQLException e) {
            System.err.println("Error getting suppliers: " + e.getMessage());
            e.printStackTrace();
        }
        return suppliers;
    }

    // Lấy Supplier theo ID
    public Supplier getSupplierById(int supplierId) {
        String query = "SELECT * FROM Suppliers WHERE supplier_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, supplierId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Supplier supplier = new Supplier();
                supplier.setSupplierId(rs.getInt("supplier_id"));
                supplier.setName(rs.getString("name"));
                supplier.setContactEmail(rs.getString("contact_email"));
                supplier.setContactPhone(rs.getString("contact_phone"));
                supplier.setAddress(rs.getString("address"));
                supplier.setPerformanceRating(rs.getDouble("performance_rating"));
                supplier.setCreatedAt(rs.getTimestamp("created_at"));
                supplier.setUpdatedAt(rs.getTimestamp("updated_at"));
                return supplier;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}