package DAO;

import model.Manager;
import model.PurchaseOrder;
import model.StockAlert;
import model.Supplier;
import model.Medicine;
import model.PurchaseOrderItem;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class ManagerDAO extends DBContext {

    // Approve Stock Request
    public boolean approveStockRequest(int poId, int managerId) {
        String query = "UPDATE PurchaseOrders SET status = 'Approved', manager_id = ?, updated_at = GETDATE() " +
                      "WHERE po_id = ? AND TRIM(status) = 'Sent'";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, managerId);
            ps.setInt(2, poId);
            int result = ps.executeUpdate();
            System.out.println("Approve PO #" + poId + " by Manager #" + managerId + ": Affected rows = " + result);
            if (result == 0) {
                System.out.println("Approve failed: PO #" + poId + " not found or status is not 'Sent'. Current status: " +
                    getCurrentStatus(poId));
            }
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error approving stock request #" + poId + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Reject Stock Request
    public boolean rejectStockRequest(int poId, String reason) {
        String query = "UPDATE PurchaseOrders SET status = 'Rejected', " +
                      "notes = CONCAT(COALESCE(notes, ''), '\nRejection Reason: ', ?), updated_at = GETDATE() " +
                      "WHERE po_id = ? AND TRIM(status) IN ('Draft', 'Sent')";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, reason);
            ps.setInt(2, poId);
            int result = ps.executeUpdate();
            System.out.println("Reject PO #" + poId + ": Affected rows = " + result);
            if (result == 0) {
                System.out.println("Reject failed: PO #" + poId + " not found or status is not 'Draft' or 'Sent'. Current status: " +
                    getCurrentStatus(poId));
            }
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error rejecting stock request #" + poId + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Helper method to get current status for debugging
    private String getCurrentStatus(int poId) {
        String query = "SELECT status FROM PurchaseOrders WHERE po_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, poId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String status = rs.getString("status");
                System.out.println("Current status for PO #" + poId + ": '" + status + "', Length: " + status.length() + 
                                   ", Bytes: " + status.getBytes().length);
                return status;
            }
            return "Not found";
        } catch (SQLException e) {
            System.err.println("Error checking status for PO #" + poId + ": " + e.getMessage());
            return "Error";
        }
    }

    // Các phương thức khác giữ nguyên
    public List<Medicine> getAllMedicines() {
        List<Medicine> medicines = new ArrayList<>();
        String query = "SELECT medicine_id, name, category, description FROM Medicines ORDER BY name";
        try (PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Medicine medicine = new Medicine();
                medicine.setMedicineId(rs.getInt("medicine_id"));
                medicine.setName(rs.getString("name"));
                medicine.setCategory(rs.getString("category"));
                medicine.setDescription(rs.getString("description"));
                medicines.add(medicine);
            }
            System.out.println("Loaded " + medicines.size() + " medicines.");
        } catch (SQLException e) {
            System.err.println("Error getting medicines: " + e.getMessage());
            e.printStackTrace();
        }
        return medicines;
    }

    public List<PurchaseOrderItem> getPurchaseOrderItems(int poId) {
        List<PurchaseOrderItem> items = new ArrayList<>();
        String query = "SELECT po_id, medicine_id, quantity, priority, notes FROM PurchaseOrderItems WHERE po_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, poId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PurchaseOrderItem item = new PurchaseOrderItem();
                item.setPoId(rs.getInt("po_id"));
                item.setMedicineId(rs.getInt("medicine_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPriority(rs.getString("priority"));
                item.setNotes(rs.getString("notes"));
                items.add(item);
            }
            System.out.println("Loaded " + items.size() + " items for PO #" + poId);
        } catch (SQLException e) {
            System.err.println("Error getting purchase order items: " + e.getMessage());
            e.printStackTrace();
        }
        return items;
    }

    public int createPurchaseOrder(int managerId, Integer supplierId, Date expectedDeliveryDate, String notes, 
                                  List<PurchaseOrderItem> items) {
        String poQuery = "INSERT INTO PurchaseOrders (manager_id, supplier_id, status, order_date, expected_delivery_date, notes) " +
                        "VALUES (?, ?, 'Draft', GETDATE(), ?, ?)";
        String itemQuery = "INSERT INTO PurchaseOrderItems (po_id, medicine_id, quantity, priority, notes) " +
                         "VALUES (?, ?, ?, ?, ?)";
        
        try {
            connection.setAutoCommit(false);
            try (PreparedStatement ps = connection.prepareStatement(poQuery, PreparedStatement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, managerId);
                if (supplierId != null) {
                    ps.setInt(2, supplierId);
                } else {
                    ps.setNull(2, java.sql.Types.INTEGER);
                }
                ps.setDate(3, expectedDeliveryDate);
                ps.setString(4, notes);
                
                int result = ps.executeUpdate();
                if (result == 0) {
                    connection.rollback();
                    return -1;
                }
                
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int poId = rs.getInt(1);
                    try (PreparedStatement psItem = connection.prepareStatement(itemQuery)) {
                        for (PurchaseOrderItem item : items) {
                            psItem.setInt(1, poId);
                            psItem.setInt(2, item.getMedicineId());
                            psItem.setInt(3, item.getQuantity());
                            psItem.setString(4, item.getPriority());
                            psItem.setString(5, item.getNotes());
                            psItem.addBatch();
                        }
                        psItem.executeBatch();
                    }
                    connection.commit();
                    System.out.println("Created PO #" + poId + " with " + items.size() + " items.");
                    return poId;
                }
            }
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            System.err.println("Error creating purchase order: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return -1;
    }

    public boolean updatePurchaseOrder(int poId, Integer supplierId, Date expectedDeliveryDate, String notes, 
                                      List<PurchaseOrderItem> items) {
        String poQuery = "UPDATE PurchaseOrders SET supplier_id = ?, expected_delivery_date = ?, notes = ? WHERE po_id = ? AND status = 'Draft'";
        String deleteItemsQuery = "DELETE FROM PurchaseOrderItems WHERE po_id = ?";
        String itemQuery = "INSERT INTO PurchaseOrderItems (po_id, medicine_id, quantity, priority, notes) " +
                         "VALUES (?, ?, ?, ?, ?)";
        
        try {
            connection.setAutoCommit(false);
            try (PreparedStatement ps = connection.prepareStatement(poQuery)) {
                if (supplierId != null) {
                    ps.setInt(1, supplierId);
                } else {
                    ps.setNull(1, java.sql.Types.INTEGER);
                }
                ps.setDate(2, expectedDeliveryDate);
                ps.setString(3, notes);
                ps.setInt(4, poId);
                int result = ps.executeUpdate();
                if (result == 0) {
                    connection.rollback();
                    System.out.println("Update PO #" + poId + " failed: No rows affected.");
                    return false;
                }
            }
            try (PreparedStatement psDelete = connection.prepareStatement(deleteItemsQuery)) {
                psDelete.setInt(1, poId);
                psDelete.executeUpdate();
            }
            try (PreparedStatement psItem = connection.prepareStatement(itemQuery)) {
                for (PurchaseOrderItem item : items) {
                    psItem.setInt(1, poId);
                    psItem.setInt(2, item.getMedicineId());
                    psItem.setInt(3, item.getQuantity());
                    psItem.setString(4, item.getPriority());
                    psItem.setString(5, item.getNotes());
                    psItem.addBatch();
                }
                psItem.executeBatch();
            }
            connection.commit();
            System.out.println("Updated PO #" + poId + " with " + items.size() + " items.");
            return true;
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            System.err.println("Error updating purchase order #" + poId + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean deletePurchaseOrder(int poId) {
        String deleteItemsQuery = "DELETE FROM PurchaseOrderItems WHERE po_id = ?";
        String deletePOQuery = "DELETE FROM PurchaseOrders WHERE po_id = ? AND status = 'Draft'";
        
        try {
            connection.setAutoCommit(false);
            try (PreparedStatement psItems = connection.prepareStatement(deleteItemsQuery)) {
                psItems.setInt(1, poId);
                psItems.executeUpdate();
            }
            try (PreparedStatement psPO = connection.prepareStatement(deletePOQuery)) {
                psPO.setInt(1, poId);
                int result = psPO.executeUpdate();
                if (result == 0) {
                    connection.rollback();
                    System.out.println("Delete PO #" + poId + " failed: No rows affected.");
                    return false;
                }
            }
            connection.commit();
            System.out.println("Deleted PO #" + poId + " successfully.");
            return true;
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            System.err.println("Error deleting purchase order #" + poId + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

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
            System.out.println("Loaded Manager #" + userId + ": " + (manager != null ? manager.getUsername() : "Not found"));
        } catch (SQLException e) {
            System.err.println("Error getting manager #" + userId + ": " + e.getMessage());
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
                try (PreparedStatement psCapacity = connection.prepareStatement(capacityQuery);
                     ResultSet rsCapacity = psCapacity.executeQuery()) {
                    int capacity = rsCapacity.next() ? Integer.parseInt(rsCapacity.getString("config_value")) : 10000;
                    return "Total Stock: " + totalStock + " / Capacity: " + capacity + " (Usage: " + (totalStock * 100 / capacity) + "%)";
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getting warehouse status: " + e.getMessage());
            e.printStackTrace();
        }
        return "Error fetching status";
    }

    public List<StockAlert> getStockAlerts() {
        List<StockAlert> alerts = new ArrayList<>();
        String thresholdQuery = "SELECT config_value FROM SystemConfig WHERE config_key = 'low_stock_threshold'";
        int threshold = 10;
        
        try {
            try (PreparedStatement psThreshold = connection.prepareStatement(thresholdQuery);
                 ResultSet rsThreshold = psThreshold.executeQuery()) {
                if (rsThreshold.next()) {
                    threshold = Integer.parseInt(rsThreshold.getString("config_value"));
                }
            }

            String query = "SELECT m.medicine_id, m.name, m.category, " +
                          "SUM(b.current_quantity) as total_quantity, " +
                          "MIN(b.expiry_date) as nearest_expiry " +
                          "FROM Batches b " +
                          "JOIN Medicines m ON b.medicine_id = m.medicine_id " +
                          "WHERE b.status != 'Expired' " +
                          "GROUP BY m.medicine_id, m.name, m.category " +
                          "HAVING SUM(b.current_quantity) < ?";
            
            try (PreparedStatement ps = connection.prepareStatement(query)) {
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
                System.out.println("Loaded " + alerts.size() + " stock alerts.");
            }
        } catch (SQLException e) {
            System.err.println("Error getting stock alerts: " + e.getMessage());
            e.printStackTrace();
        }
        return alerts;
    }

    private String calculateAlertLevel(int quantity, int threshold) {
        if (quantity == 0) return "Critical";
        if (quantity < threshold / 2) return "High";
        return "Medium";
    }

    public List<PurchaseOrder> getPendingStockRequests() {
        List<PurchaseOrder> requests = new ArrayList<>();
        String query = "SELECT po.po_id, po.manager_id, po.supplier_id, po.status, " +
                      "po.order_date, po.expected_delivery_date, po.notes, " +
                      "s.name as supplier_name, u.username as manager_name " +
                      "FROM PurchaseOrders po " +
                      "LEFT JOIN Suppliers s ON po.supplier_id = s.supplier_id " +
                      "LEFT JOIN Users u ON po.manager_id = u.user_id " +
                      "WHERE TRIM(po.status) IN ('Draft', 'Sent') " +
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
            System.out.println("Loaded " + requests.size() + " pending stock requests.");
        } catch (SQLException e) {
            System.err.println("Error getting pending stock requests: " + e.getMessage());
            e.printStackTrace();
        }
        return requests;
    }

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
                System.out.println("Loaded PO #" + poId);
                return po;
            }
            System.out.println("PO #" + poId + " not found.");
        } catch (SQLException e) {
            System.err.println("Error getting purchase order #" + poId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public List<Supplier> getAllSuppliers() {
        List<Supplier> suppliers = new ArrayList<>();
        String query = "SELECT * FROM Suppliers ORDER BY name";
        try (PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Supplier supplier = new Supplier();
                supplier.setSupplierId(rs.getInt("supplier_id"));
                supplier.setName(rs.getString("name"));
                supplier.setContactEmail(rs.getString("contact_email"));
                supplier.setContactPhone(rs.getString("contact_phone"));
                supplier.setAddress(rs.getString("address"));
                Double rating = rs.getDouble("performance_rating");
                if (!rs.wasNull()) {
                    supplier.setPerformanceRating(rating);
                }
                supplier.setCreatedAt(rs.getTimestamp("created_at"));
                supplier.setUpdatedAt(rs.getTimestamp("updated_at"));
                suppliers.add(supplier);
            }
            System.out.println("Loaded " + suppliers.size() + " suppliers.");
        } catch (SQLException e) {
            System.err.println("Error getting suppliers: " + e.getMessage());
            e.printStackTrace();
        }
        return suppliers;
    }

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
                System.out.println("Loaded Supplier #" + supplierId);
                return supplier;
            }
            System.out.println("Supplier #" + supplierId + " not found.");
        } catch (SQLException e) {
            System.err.println("Error getting supplier #" + supplierId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}