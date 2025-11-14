package DAO;

import java.sql.Timestamp;
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
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.ASNItem;
import model.AdvancedShippingNotice;
import model.SupplierRating;
import model.Task;

public class ManagerDAO extends DBContext {

    // Approve Stock Request - Chuyển từ Draft sang Sent
    public boolean approveStockRequest(int poId, int managerId) {
        String query = "UPDATE PurchaseOrders SET status = 'Sent', manager_id = ?, updated_at = GETDATE() " +
                      "WHERE po_id = ? AND status = 'Draft'";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, managerId);
            ps.setInt(2, poId);
            int result = ps.executeUpdate();
            System.out.println("Approve PO #" + poId + " by Manager #" + managerId + ": Affected rows = " + result);
            if (result == 0) {
                System.out.println("Approve failed: PO #" + poId + " not found or status is not 'Draft'. Current status: " +
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
                      "WHERE po_id = ? AND status = 'Draft'";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, reason);
            ps.setInt(2, poId);
            int result = ps.executeUpdate();
            System.out.println("Reject PO #" + poId + ": Affected rows = " + result);
            if (result == 0) {
                System.out.println("Reject failed: PO #" + poId + " not found or status is not 'Draft'. Current status: " +
                    getCurrentStatus(poId));
            }
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error rejecting stock request #" + poId + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Cancel Stock Request - Chỉ cancel được khi status là Sent
public boolean cancelStockRequest(int poId, String reason) {
    String query = "UPDATE PurchaseOrders SET status = 'Cancelled', " +
                  "notes = CONCAT(COALESCE(notes, ''), CHAR(13) + CHAR(10) + 'Cancellation Reason: ', ?), " +
                  "updated_at = GETDATE() " +
                  "WHERE po_id = ? AND status = 'Sent'";
    
    try (PreparedStatement ps = connection.prepareStatement(query)) {
        ps.setString(1, reason);
        ps.setInt(2, poId);
        
        System.out.println("========================================");
        System.out.println("EXECUTING CANCEL STOCK REQUEST");
        System.out.println("PO ID: " + poId);
        System.out.println("Reason: " + reason);
        System.out.println("SQL: " + query);
        System.out.println("========================================");
        
        int result = ps.executeUpdate();
        
        System.out.println("Cancel PO #" + poId + ": Affected rows = " + result);
        
        if (result == 0) {
            String currentStatus = getCurrentStatus(poId);
            System.out.println("Cancel failed!");
            System.out.println("Current status: " + currentStatus);
            System.out.println("Required status: 'Sent'");
            return false;
        }
        
        System.out.println("Cancel successful!");
        return true;
        
    } catch (SQLException e) {
        System.err.println("SQL Error cancelling stock request #" + poId);
        System.err.println("Error Code: " + e.getErrorCode());
        System.err.println("SQL State: " + e.getSQLState());
        System.err.println("Message: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}

/**
 * Helper method to get current status of a PO for debugging
 */
private String getCurrentStatus(int poId) {
    String query = "SELECT status FROM PurchaseOrders WHERE po_id = ?";
    try (PreparedStatement ps = connection.prepareStatement(query)) {
        ps.setInt(1, poId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            String status = rs.getString("status");
            System.out.println("Current status for PO #" + poId + ": '" + status + "'");
            return status;
        }
        return "NOT_FOUND";
    } catch (SQLException e) {
        System.err.println("Error checking status for PO #" + poId + ": " + e.getMessage());
        return "ERROR";
    }
}

    // === CẬP NHẬT: Lấy danh sách thuốc với đầy đủ thông tin + medicine_code ===
    public List<Medicine> getAllMedicines() {
        List<Medicine> medicines = new ArrayList<>();
        String sql = "SELECT medicine_code, name, category, description, " +
                     "active_ingredient, dosage_form, strength, unit, " +
                     "manufacturer, country_of_origin, drug_group, drug_type, " +
                     "created_at, updated_at " +
                     "FROM Medicines ORDER BY name";
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Medicine medicine = new Medicine();
                medicine.setMedicineCode(rs.getString("medicine_code"));
                medicine.setName(rs.getString("name"));
                medicine.setCategory(rs.getString("category"));
                medicine.setDescription(rs.getString("description"));
                medicine.setActiveIngredient(rs.getString("active_ingredient"));
                medicine.setDosageForm(rs.getString("dosage_form"));
                medicine.setStrength(rs.getString("strength"));
                medicine.setUnit(rs.getString("unit"));
                medicine.setManufacturer(rs.getString("manufacturer"));
                medicine.setCountryOfOrigin(rs.getString("country_of_origin"));
                medicine.setDrugGroup(rs.getString("drug_group"));
                medicine.setDrugType(rs.getString("drug_type"));
                medicine.setCreatedAt(rs.getTimestamp("created_at"));
                medicine.setUpdatedAt(rs.getTimestamp("updated_at"));
                medicines.add(medicine);
            }
            System.out.println("Loaded " + medicines.size() + " medicines (with full details).");
        } catch (SQLException e) {
            System.err.println("Error getting medicines: " + e.getMessage());
            e.printStackTrace();
        }
        return medicines;
    }

    // === MỚI: Lấy thuốc theo medicine_code ===
    public Medicine getMedicineByCode(String medicineCode) {
        String sql = "SELECT medicine_code, name, category, description, " +
                     "active_ingredient, dosage_form, strength, unit, " +
                     "manufacturer, country_of_origin, drug_group, drug_type, " +
                     "created_at, updated_at " +
                     "FROM Medicines WHERE medicine_code = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, medicineCode);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Medicine medicine = new Medicine();
                medicine.setMedicineCode(rs.getString("medicine_code"));
                medicine.setName(rs.getString("name"));
                medicine.setCategory(rs.getString("category"));
                medicine.setDescription(rs.getString("description"));
                medicine.setActiveIngredient(rs.getString("active_ingredient"));
                medicine.setDosageForm(rs.getString("dosage_form"));
                medicine.setStrength(rs.getString("strength"));
                medicine.setUnit(rs.getString("unit"));
                medicine.setManufacturer(rs.getString("manufacturer"));
                medicine.setCountryOfOrigin(rs.getString("country_of_origin"));
                medicine.setDrugGroup(rs.getString("drug_group"));
                medicine.setDrugType(rs.getString("drug_type"));
                medicine.setCreatedAt(rs.getTimestamp("created_at"));
                medicine.setUpdatedAt(rs.getTimestamp("updated_at"));
                System.out.println("Loaded medicine: " + medicineCode);
                return medicine;
            }
        } catch (SQLException e) {
            System.err.println("Error getting medicine by code '" + medicineCode + "': " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

 // === CẬP NHẬT: Tạo PO mới dùng medicine_code + unit_price ===
public int createPurchaseOrder(int managerId, Integer supplierId, Date expectedDeliveryDate, 
                              String notes, List<PurchaseOrderItem> items) {
    String poQuery = "INSERT INTO PurchaseOrders (manager_id, supplier_id, status, order_date, expected_delivery_date, notes, updated_at) " +
                    "VALUES (?, ?, 'Draft', GETDATE(), ?, ?, GETDATE())";
    String itemQuery = "INSERT INTO PurchaseOrderItems (po_id, medicine_code, quantity, unit_price, priority, notes) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
    
    try {
        connection.setAutoCommit(false);
        try (PreparedStatement ps = connection.prepareStatement(poQuery, Statement.RETURN_GENERATED_KEYS)) {
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
                        psItem.setString(2, item.getMedicineCode());
                        psItem.setInt(3, item.getQuantity());
                        psItem.setDouble(4, item.getUnitPrice()); // ✅ THÊM unit_price
                        psItem.setString(5, item.getPriority());
                        psItem.setString(6, item.getNotes());
                        psItem.addBatch();
                    }
                    psItem.executeBatch();
                }
                connection.commit();
                System.out.println("Created PO #" + poId + " with " + items.size() + " items (with unit_price).");
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

// === CẬP NHẬT: Cập nhật PO dùng medicine_code + unit_price ===
public boolean updatePurchaseOrder(int poId, Integer supplierId, Date expectedDeliveryDate, 
                                  String notes, List<PurchaseOrderItem> items) {
    String poQuery = "UPDATE PurchaseOrders SET supplier_id = ?, expected_delivery_date = ?, notes = ?, updated_at = GETDATE() " +
                    "WHERE po_id = ? AND status = 'Draft'";
    String deleteItemsQuery = "DELETE FROM PurchaseOrderItems WHERE po_id = ?";
    String itemQuery = "INSERT INTO PurchaseOrderItems (po_id, medicine_code, quantity, unit_price, priority, notes) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
    
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
                System.out.println("Update PO #" + poId + " failed: No rows affected or not in Draft.");
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
                psItem.setString(2, item.getMedicineCode());
                psItem.setInt(3, item.getQuantity());
                psItem.setDouble(4, item.getUnitPrice()); // ✅ THÊM unit_price
                psItem.setString(5, item.getPriority());
                psItem.setString(6, item.getNotes());
                psItem.addBatch();
            }
            psItem.executeBatch();
        }
        connection.commit();
        System.out.println("Updated PO #" + poId + " with " + items.size() + " items (with unit_price).");
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
    // === Các method cũ giữ nguyên ===
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

// Add this method to your ManagerDAO.java

/**
 * Get stock alerts for medicines below threshold
 */
public List<StockAlert> getStockAlerts() {
    List<StockAlert> alerts = new ArrayList<>();
    
    // Get threshold from SystemConfig
    int threshold = 10;
    String thresholdQuery = "SELECT config_value FROM SystemConfig WHERE config_key = 'low_stock_threshold'";
    try (PreparedStatement psThreshold = connection.prepareStatement(thresholdQuery);
         ResultSet rsThreshold = psThreshold.executeQuery()) {
        if (rsThreshold.next()) {
            threshold = Integer.parseInt(rsThreshold.getString("config_value"));
        }
    } catch (Exception e) {
        System.err.println("Error getting threshold: " + e.getMessage());
    }
    
    // Query to get low stock medicines
    String query = "SELECT m.medicine_code, m.name, m.category, " +
                  "COALESCE(SUM(CASE WHEN b.status = 'Approved' THEN b.current_quantity ELSE 0 END), 0) as total_quantity, " +
                  "MIN(b.expiry_date) as nearest_expiry " +
                  "FROM Medicines m " +
                  "LEFT JOIN Batches b ON m.medicine_code = b.medicine_code " +
                  "GROUP BY m.medicine_code, m.name, m.category " +
                  "HAVING COALESCE(SUM(CASE WHEN b.status = 'Approved' THEN b.current_quantity ELSE 0 END), 0) <= ? " +
                  "ORDER BY total_quantity ASC, m.name";
    
    try (PreparedStatement ps = connection.prepareStatement(query)) {
        ps.setInt(1, threshold);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            StockAlert alert = new StockAlert();
            alert.setMedicineCode(rs.getString("medicine_code"));
            alert.setMedicineName(rs.getString("name"));
            alert.setCategory(rs.getString("category"));
            alert.setCurrentQuantity(rs.getInt("total_quantity"));
            alert.setThreshold(threshold);
            alert.setNearestExpiry(rs.getDate("nearest_expiry"));
            
            // Set alert level
            int qty = rs.getInt("total_quantity");
            if (qty == 0) {
                alert.setAlertLevel("Critical");
            } else if (qty < threshold / 2) {
                alert.setAlertLevel("High");
            } else {
                alert.setAlertLevel("Medium");
            }
            
            alerts.add(alert);
        }
        
        System.out.println("Found " + alerts.size() + " stock alerts (threshold: " + threshold + ")");
    } catch (SQLException e) {
        System.err.println("Error getting stock alerts: " + e.getMessage());
        e.printStackTrace();
    }
    
    return alerts;
}

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
                po.setOrderDate(rs.getTimestamp("order_date"));
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
                po.setOrderDate(rs.getTimestamp("order_date"));
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
                Timestamp createdTs = rs.getTimestamp("created_at");
                if (createdTs != null) supplier.setCreatedAt(createdTs.toLocalDateTime());
                Timestamp updatedTs = rs.getTimestamp("updated_at");
                if (updatedTs != null) supplier.setUpdatedAt(updatedTs.toLocalDateTime());
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
                Timestamp createdTs = rs.getTimestamp("created_at");
                if (createdTs != null) supplier.setCreatedAt(createdTs.toLocalDateTime());
                Timestamp updatedTs = rs.getTimestamp("updated_at");
                if (updatedTs != null) supplier.setUpdatedAt(updatedTs.toLocalDateTime());
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

public List<PurchaseOrder> getCancelledStockRequests() {
    List<PurchaseOrder> orders = new ArrayList<>();
    String query = "SELECT po.*, u.username as manager_name, s.name as supplier_name " +
                  "FROM PurchaseOrders po " +
                  "LEFT JOIN Users u ON po.manager_id = u.user_id " +
                  "LEFT JOIN Suppliers s ON po.supplier_id = s.supplier_id " +
                  "WHERE po.status = 'Cancelled' " +
                  "ORDER BY po.updated_at DESC";
    
    try (PreparedStatement ps = connection.prepareStatement(query);
         ResultSet rs = ps.executeQuery()) {
        
        System.out.println("========================================");
        System.out.println("FETCHING CANCELLED ORDERS");
        System.out.println("Query: " + query);
        System.out.println("========================================");
        
        int count = 0;
        while (rs.next()) {
            PurchaseOrder po = new PurchaseOrder();
            po.setPoId(rs.getInt("po_id"));
            po.setManagerId(rs.getInt("manager_id"));
            po.setSupplierId(rs.getInt("supplier_id"));
            po.setStatus(rs.getString("status"));
            po.setOrderDate(rs.getTimestamp("order_date"));
            po.setExpectedDeliveryDate(rs.getDate("expected_delivery_date"));
            po.setNotes(rs.getString("notes"));
            po.setUpdatedAt(rs.getTimestamp("updated_at"));
            po.setManagerName(rs.getString("manager_name"));
            po.setSupplierName(rs.getString("supplier_name"));
            
            orders.add(po);
            count++;
            
            System.out.println("Found cancelled PO #" + po.getPoId() + 
                             ", Supplier: " + po.getSupplierName());
        }
        
        System.out.println("Total cancelled orders found: " + count);
        System.out.println("========================================");
        
    } catch (SQLException e) {
        System.err.println("Error fetching cancelled stock requests: " + e.getMessage());
        e.printStackTrace();
    }
    
    return orders;
}

/**
 * Check if a PO can be cancelled
 * @param poId The PO ID to check
 * @return true if it can be cancelled (status = 'Sent'), false otherwise
 */
public boolean canCancelPurchaseOrder(int poId) {
    String query = "SELECT status FROM PurchaseOrders WHERE po_id = ?";
    try (PreparedStatement ps = connection.prepareStatement(query)) {
        ps.setInt(1, poId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            String status = rs.getString("status");
            return "Sent".equals(status);
        }
        return false;
    } catch (SQLException e) {
        System.err.println("Error checking if PO can be cancelled: " + e.getMessage());
        return false;
    }
}
    public List<Manager> getAllAuditors() {
        List<Manager> auditors = new ArrayList<>();
        String query = "SELECT * FROM Users WHERE role = 'Auditor' AND is_active = 1 ORDER BY username";
        try (PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Manager auditor = new Manager();
                auditor.setUserId(rs.getInt("user_id"));
                auditor.setUsername(rs.getString("username"));
                auditor.setEmail(rs.getString("email"));
                auditor.setPhone(rs.getString("phone"));
                auditors.add(auditor);
            }
            System.out.println("Loaded " + auditors.size() + " auditors.");
        } catch (SQLException e) {
            System.err.println("Error getting auditors: " + e.getMessage());
            e.printStackTrace();
        }
        return auditors;
    }

    public void initializeAuditors() {
        String checkQuery = "SELECT COUNT(*) FROM Users WHERE role = 'Auditor'";
        try (PreparedStatement ps = connection.prepareStatement(checkQuery);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next() && rs.getInt(1) == 0) {
                String insertQuery = "INSERT INTO Users (username, email, phone, role, is_active, password) VALUES (?, ?, ?, 'Auditor', 1, ?)";
                try (PreparedStatement insertPs = connection.prepareStatement(insertQuery)) {
                    insertPs.setString(1, "auditor1");
                    insertPs.setString(2, "auditor1@example.com");
                    insertPs.setString(3, "0907654321");
                    insertPs.setString(4, "password123");
                    insertPs.executeUpdate();
                    System.out.println("Initialized 1 auditor member.");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error initializing auditors: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public boolean assignTask(int poId, int auditorId, String taskType, Date deadline) {
        String query = "INSERT INTO Tasks (po_id, staff_id, task_type, deadline, status) VALUES (?, ?, ?, ?, 'Pending')";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, poId);
            ps.setInt(2, auditorId);
            ps.setString(3, taskType);
            ps.setDate(4, deadline);
            int result = ps.executeUpdate();
            System.out.println("Assigned task for PO #" + poId + " to Auditor #" + auditorId + ": Affected rows = " + result);
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error assigning task for PO #" + poId + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<Task> getTasks() {
        List<Task> tasks = new ArrayList<>();
        String query = "SELECT t.task_id, t.po_id, t.staff_id, t.task_type, t.deadline, t.status, " +
                      "u.username as staff_name, po.notes as po_notes " +
                      "FROM Tasks t " +
                      "LEFT JOIN Users u ON t.staff_id = u.user_id " +
                      "LEFT JOIN PurchaseOrders po ON t.po_id = po.po_id " +
                      "ORDER BY t.deadline DESC";
        try (PreparedStatement ps = connection.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Task task = new Task();
                task.setTaskId(rs.getInt("task_id"));
                task.setPoId(rs.getInt("po_id"));
                task.setStaffId(rs.getInt("staff_id"));
                task.setTaskType(rs.getString("task_type"));
                task.setDeadline(rs.getDate("deadline"));
                task.setStatus(rs.getString("status"));
                task.setStaffName(rs.getString("staff_name"));
                task.setPoNotes(rs.getString("po_notes"));
                tasks.add(task);
            }
            System.out.println("Loaded " + tasks.size() + " tasks.");
        } catch (SQLException e) {
            System.err.println("Error getting tasks: " + e.getMessage());
            e.printStackTrace();
        }
        return tasks;
    }

    public boolean cancelTask(int taskId) {
        String query = "UPDATE Tasks SET status = 'Cancelled', updated_at = GETDATE() " +
                      "WHERE task_id = ? AND status != 'Completed'";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, taskId);
            int result = ps.executeUpdate();
            System.out.println("Cancel Task #" + taskId + ": Affected rows = " + result);
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error cancelling task #" + taskId + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public Task getTaskById(int taskId) {
        String query = "SELECT t.task_id, t.po_id, t.staff_id, t.task_type, t.deadline, t.status, " +
                      "t.created_at, t.updated_at, " +
                      "u.username as staff_name, u.email as staff_email, " +
                      "po.notes as po_notes, po.order_date, po.expected_delivery_date, po.status as po_status, " +
                      "s.name as supplier_name " +
                      "FROM Tasks t " +
                      "LEFT JOIN Users u ON t.staff_id = u.user_id " +
                      "LEFT JOIN PurchaseOrders po ON t.po_id = po.po_id " +
                      "LEFT JOIN Suppliers s ON po.supplier_id = s.supplier_id " +
                      "WHERE t.task_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, taskId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Task task = new Task();
                task.setTaskId(rs.getInt("task_id"));
                task.setPoId(rs.getInt("po_id"));
                task.setStaffId(rs.getInt("staff_id"));
                task.setTaskType(rs.getString("task_type"));
                task.setDeadline(rs.getDate("deadline"));
                task.setStatus(rs.getString("status"));
                task.setCreatedAt(rs.getDate("created_at"));
                task.setUpdatedAt(rs.getDate("updated_at"));
                task.setStaffName(rs.getString("staff_name"));
                task.setPoNotes(rs.getString("po_notes"));
                System.out.println("Loaded Task #" + taskId);
                return task;
            }
            System.out.println("Task #" + taskId + " not found.");
        } catch (SQLException e) {
            System.err.println("Error getting task #" + taskId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateTask(int taskId, int auditorId, String taskType, Date deadline) {
        String query = "UPDATE Tasks SET staff_id = ?, task_type = ?, deadline = ?, updated_at = GETDATE() " +
                      "WHERE task_id = ? AND status = 'Pending'";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, auditorId);
            ps.setString(2, taskType);
            ps.setDate(3, deadline);
            ps.setInt(4, taskId);
            int result = ps.executeUpdate();
            System.out.println("Update Task #" + taskId + ": Affected rows = " + result);
            return result > 0;
        } catch (SQLException e) {
            System.err.println("Error updating task #" + taskId + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    // === DEBUG VERSION: Thêm vào ManagerDAO.java ===
public List<PurchaseOrderItem> getPurchaseOrderItems(int poId) {
    List<PurchaseOrderItem> items = new ArrayList<>();
    
    // Get ALL medicine fields from the database
    String sql = "SELECT poi.item_id, poi.po_id, poi.medicine_code, " +
                 "poi.quantity, poi.unit_price, poi.priority, poi.notes, " +
                 "m.name, m.category, m.strength, m.dosage_form, " +
                 "m.manufacturer, m.unit, m.active_ingredient, " +
                 "m.country_of_origin, m.drug_group, m.drug_type, m.description " +
                 "FROM PurchaseOrderItems poi " +
                 "LEFT JOIN Medicines m ON poi.medicine_code = m.medicine_code " +
                 "WHERE poi.po_id = ?";
    
    System.out.println("====================================");
    System.out.println("DEBUG ManagerDAO: Getting items for PO #" + poId);
    System.out.println("====================================");
    
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, poId);
        ResultSet rs = ps.executeQuery();
        
        int count = 0;
        while (rs.next()) {
            count++;
            PurchaseOrderItem item = new PurchaseOrderItem();
            
            // Basic PO Item info
            item.setPoItemId(rs.getInt("item_id"));
            item.setPoId(rs.getInt("po_id"));
            item.setMedicineCode(rs.getString("medicine_code"));
            item.setQuantity(rs.getInt("quantity"));
            
            // Price and priority
            double unitPrice = rs.getDouble("unit_price");
            if (!rs.wasNull()) {
                item.setUnitPrice(unitPrice);
            }
            item.setPriority(rs.getString("priority"));
            item.setNotes(rs.getString("notes"));
            
            // === ALL Medicine details ===
            item.setMedicineName(rs.getString("name"));
            item.setMedicineCategory(rs.getString("category"));
            item.setMedicineStrength(rs.getString("strength"));
            item.setMedicineDosageForm(rs.getString("dosage_form"));
            item.setMedicineManufacturer(rs.getString("manufacturer"));
            item.setUnit(rs.getString("unit"));
            item.setActiveIngredient(rs.getString("active_ingredient"));
            
            // Debug log
            System.out.println("Item #" + count + ":");
            System.out.println("  - Medicine Code: " + item.getMedicineCode());
            System.out.println("  - Medicine Name: " + item.getMedicineName());
            System.out.println("  - Category: " + item.getMedicineCategory());
            System.out.println("  - Strength: " + item.getMedicineStrength());
            System.out.println("  - Dosage Form: " + item.getMedicineDosageForm());
            System.out.println("  - Manufacturer: " + item.getMedicineManufacturer());
            System.out.println("  - Active Ingredient: " + item.getActiveIngredient());
            System.out.println("  - Unit: " + item.getUnit());
            System.out.println("  - Quantity: " + item.getQuantity());
            System.out.println("  - Unit Price: " + unitPrice);
            System.out.println("  - Priority: " + item.getPriority());
            
            items.add(item);
        }
        
        System.out.println("Total items loaded: " + items.size());
        System.out.println("====================================");
        
    } catch (SQLException e) {
        System.err.println("ERROR getting purchase order items: " + e.getMessage());
        e.printStackTrace();
    }
    return items;
}
public List<PurchaseOrder> getAllPurchaseOrders() {
    List<PurchaseOrder> orders = new ArrayList<>();
    String query = "SELECT po.po_id, po.manager_id, po.supplier_id, po.status, " +
                  "po.order_date, po.expected_delivery_date, po.notes, " +
                  "s.name as supplier_name, u.username as manager_name " +
                  "FROM PurchaseOrders po " +
                  "LEFT JOIN Suppliers s ON po.supplier_id = s.supplier_id " +
                  "LEFT JOIN Users u ON po.manager_id = u.user_id " +
                  "ORDER BY po.order_date DESC";
    
    try (PreparedStatement ps = connection.prepareStatement(query);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            PurchaseOrder po = new PurchaseOrder();
            po.setPoId(rs.getInt("po_id"));
            po.setManagerId(rs.getInt("manager_id"));
            po.setSupplierId(rs.getInt("supplier_id"));
            po.setStatus(rs.getString("status"));
            po.setOrderDate(rs.getTimestamp("order_date"));
            po.setExpectedDeliveryDate(rs.getDate("expected_delivery_date"));
            po.setNotes(rs.getString("notes"));
            po.setSupplierName(rs.getString("supplier_name"));
            po.setManagerName(rs.getString("manager_name"));
            orders.add(po);
        }
        System.out.println("Loaded " + orders.size() + " purchase orders (all statuses).");
    } catch (SQLException e) {
        System.err.println("Error getting all purchase orders: " + e.getMessage());
        e.printStackTrace();
    }
    return orders;
}

/**
 * Lấy tất cả Staff (Auditor + Pharmacist) để assign tasks
 * Thay thế getAllAuditors() - bây giờ bao gồm cả Pharmacist
 */
public List<Manager> getAllStaff() {
    List<Manager> staffList = new ArrayList<>();
    String query = "SELECT * FROM Users " +
                  "WHERE role IN ('Auditor', 'Pharmacist') AND is_active = 1 " +
                  "ORDER BY role, username";
    try (PreparedStatement ps = connection.prepareStatement(query);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            Manager staff = new Manager();
            staff.setUserId(rs.getInt("user_id"));
            staff.setUsername(rs.getString("username"));
            staff.setEmail(rs.getString("email"));
            staff.setPhone(rs.getString("phone"));
            staff.setRole(rs.getString("role")); // "Auditor" hoặc "Pharmacist"
            staffList.add(staff);
        }
        System.out.println("Loaded " + staffList.size() + " staff members (Auditor + Pharmacist).");
    } catch (SQLException e) {
        System.err.println("Error getting staff list: " + e.getMessage());
        e.printStackTrace();
    }
    return staffList;
}

public boolean updatePurchaseOrderToPaid(int poId) {
    String sql = "UPDATE PurchaseOrders SET status = 'Paid', updated_at = GETDATE() " +
                 "WHERE po_id = ?";
    
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, poId);
        int rows = ps.executeUpdate();
        
        System.out.println("Updated PO #" + poId + " to Paid status. Rows affected: " + rows);
        return rows > 0;
        
    } catch (SQLException e) {
        System.err.println("Error updating PO to Paid: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}
// Thêm vào class ManagerDAO

/**
 * Rate a supplier after completing a purchase order
 * @param supplierId Supplier ID
 * @param managerId Manager ID who is rating
 * @param poId Purchase Order ID
 * @param rating Rating value (1-5)
 * @param reviewText Optional review text
 * @return true if successful, false otherwise
 */
public boolean rateSupplier(int supplierId, int managerId, int poId, int rating, String reviewText) {
    // Validate rating
    if (rating < 1 || rating > 5) {
        System.err.println("Invalid rating: " + rating + ". Must be between 1-5.");
        return false;
    }
    
    String insertQuery = "INSERT INTO SupplierRatings " +
                        "(supplier_id, manager_id, po_id, rating, review_text) " +
                        "VALUES (?, ?, ?, ?, ?)";
    
    String updateQuery = "{CALL sp_UpdateSupplierRating(?)}";
    
    try {
        connection.setAutoCommit(false);
        
        // 1. Insert rating
        try (PreparedStatement ps = connection.prepareStatement(insertQuery)) {
            ps.setInt(1, supplierId);
            ps.setInt(2, managerId);
            ps.setInt(3, poId);
            ps.setInt(4, rating);
            ps.setString(5, reviewText);
            
            int result = ps.executeUpdate();
            if (result == 0) {
                connection.rollback();
                return false;
            }
            
            System.out.println("✅ Inserted rating for Supplier #" + supplierId);
        }
        
        // 2. Update average rating
        try (PreparedStatement ps = connection.prepareStatement(updateQuery)) {
            ps.setInt(1, supplierId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                double newRating = rs.getDouble("new_rating");
                System.out.println("✅ Updated average rating to " + newRating + " for Supplier #" + supplierId);
            }
        }
        
        connection.commit();
        
        // 3. Log action
        logManagerAction(managerId, "RATE_SUPPLIER", supplierId, 
                        "Rated supplier " + supplierId + " with " + rating + " stars for PO #" + poId);
        
        return true;
        
    } catch (SQLException e) {
        try {
            connection.rollback();
        } catch (SQLException rollbackEx) {
            rollbackEx.printStackTrace();
        }
        System.err.println("Error rating supplier: " + e.getMessage());
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

/**
 * Check if a PO has already been rated by the manager
 */
public boolean hasRatedPO(int poId, int managerId) {
    String query = "SELECT COUNT(*) FROM SupplierRatings " +
                  "WHERE po_id = ? AND manager_id = ?";
    
    try (PreparedStatement ps = connection.prepareStatement(query)) {
        ps.setInt(1, poId);
        ps.setInt(2, managerId);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            return rs.getInt(1) > 0;
        }
    } catch (SQLException e) {
        System.err.println("Error checking if PO is rated: " + e.getMessage());
    }
    return false;
}

/**
 * Get all ratings for a supplier
 */
public List<SupplierRating> getSupplierRatings(int supplierId) {
    List<SupplierRating> ratings = new ArrayList<>();
    String query = "SELECT sr.rating_id, sr.supplier_id, sr.manager_id, sr.po_id, " +
                  "sr.rating, sr.review_text, sr.created_at, " +
                  "u.username as manager_name, s.name as supplier_name " +
                  "FROM SupplierRatings sr " +
                  "LEFT JOIN Users u ON sr.manager_id = u.user_id " +
                  "LEFT JOIN Suppliers s ON sr.supplier_id = s.supplier_id " +
                  "WHERE sr.supplier_id = ? " +
                  "ORDER BY sr.created_at DESC";
    
    try (PreparedStatement ps = connection.prepareStatement(query)) {
        ps.setInt(1, supplierId);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            SupplierRating rating = new SupplierRating();
            rating.setRatingId(rs.getInt("rating_id"));
            rating.setSupplierId(rs.getInt("supplier_id"));
            rating.setManagerId(rs.getInt("manager_id"));
            rating.setPoId(rs.getInt("po_id"));
            rating.setRating(rs.getInt("rating"));
            rating.setReviewText(rs.getString("review_text"));
            rating.setCreatedAt(rs.getTimestamp("created_at"));
            rating.setManagerName(rs.getString("manager_name"));
            rating.setSupplierName(rs.getString("supplier_name"));
            ratings.add(rating);
        }
        
        System.out.println("Loaded " + ratings.size() + " ratings for Supplier #" + supplierId);
    } catch (SQLException e) {
        System.err.println("Error getting supplier ratings: " + e.getMessage());
        e.printStackTrace();
    }
    
    return ratings;
}

/**
 * Get POs that are completed but not yet rated by manager
 */
public List<PurchaseOrder> getUnratedCompletedPOs(int managerId) {
    List<PurchaseOrder> orders = new ArrayList<>();
    String query = "SELECT po.po_id, po.manager_id, po.supplier_id, po.status, " +
                  "po.order_date, po.expected_delivery_date, po.notes, po.updated_at, " +
                  "s.name as supplier_name, s.performance_rating " +
                  "FROM PurchaseOrders po " +
                  "INNER JOIN Suppliers s ON po.supplier_id = s.supplier_id " +
                  "WHERE po.manager_id = ? " +
                  "AND po.status = 'Completed' " +
                  "AND NOT EXISTS ( " +
                  "    SELECT 1 FROM SupplierRatings sr " +
                  "    WHERE sr.po_id = po.po_id AND sr.manager_id = ? " +
                  ") " +
                  "ORDER BY po.updated_at DESC";
    
    try (PreparedStatement ps = connection.prepareStatement(query)) {
        ps.setInt(1, managerId);
        ps.setInt(2, managerId);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            PurchaseOrder po = new PurchaseOrder();
            po.setPoId(rs.getInt("po_id"));
            po.setManagerId(rs.getInt("manager_id"));
            po.setSupplierId(rs.getInt("supplier_id"));
            po.setStatus(rs.getString("status"));
            po.setOrderDate(rs.getTimestamp("order_date"));
            po.setExpectedDeliveryDate(rs.getDate("expected_delivery_date"));
            po.setNotes(rs.getString("notes"));
            po.setUpdatedAt(rs.getTimestamp("updated_at"));
            po.setSupplierName(rs.getString("supplier_name"));
            orders.add(po);
        }
        
        System.out.println("Found " + orders.size() + " unrated completed POs for Manager #" + managerId);
    } catch (SQLException e) {
        System.err.println("Error getting unrated POs: " + e.getMessage());
        e.printStackTrace();
    }
    
    return orders;
}

/**
 * Log manager actions (if not exists)
 */
private void logManagerAction(int managerId, String action, int recordId, String details) {
    String sql = "INSERT INTO SystemLogs (user_id, action, table_name, record_id, details, log_date) " +
                 "VALUES (?, ?, 'Suppliers', ?, ?, GETDATE())";
    
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, managerId);
        ps.setString(2, action);
        ps.setInt(3, recordId);
        ps.setString(4, details);
        ps.executeUpdate();
    } catch (SQLException e) {
        System.err.println("Error logging action: " + e.getMessage());
    }
}


/**
 * Get all SENT orders (status = 'Sent' or 'Approved' or 'Rejected')
 * Shows orders waiting for supplier action
 */
public List<PurchaseOrder> getSentOrders(int managerId) {
    List<PurchaseOrder> orders = new ArrayList<>();
    String query = "SELECT po.po_id, po.manager_id, po.supplier_id, po.status, " +
                  "po.order_date, po.expected_delivery_date, po.notes, po.updated_at, " +
                  "s.name as supplier_name, u.username as manager_name " +
                  "FROM PurchaseOrders po " +
                  "LEFT JOIN Suppliers s ON po.supplier_id = s.supplier_id " +
                  "LEFT JOIN Users u ON po.manager_id = u.user_id " +
                  "WHERE po.manager_id = ? AND po.status IN ('Sent', 'Approved', 'Rejected') " +
                  "ORDER BY po.order_date DESC";
    
    try (PreparedStatement ps = connection.prepareStatement(query)) {
        ps.setInt(1, managerId);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            PurchaseOrder po = new PurchaseOrder();
            po.setPoId(rs.getInt("po_id"));
            po.setManagerId(rs.getInt("manager_id"));
            po.setSupplierId(rs.getInt("supplier_id"));
            po.setStatus(rs.getString("status"));
            po.setOrderDate(rs.getTimestamp("order_date"));
            po.setExpectedDeliveryDate(rs.getDate("expected_delivery_date"));
            po.setNotes(rs.getString("notes"));
            po.setUpdatedAt(rs.getTimestamp("updated_at"));
            po.setSupplierName(rs.getString("supplier_name"));
            po.setManagerName(rs.getString("manager_name"));
            orders.add(po);
        }
        
        System.out.println("Loaded " + orders.size() + " sent orders for Manager #" + managerId);
    } catch (SQLException e) {
        System.err.println("Error getting sent orders: " + e.getMessage());
        e.printStackTrace();
    }
    
    return orders;
}

/**
 * Get all IN TRANSIT orders
 * Orders with ASN status = 'Sent' or 'InTransit'
 */
public List<PurchaseOrder> getInTransitOrders(int managerId) {
    List<PurchaseOrder> orders = new ArrayList<>();
    String query = "SELECT DISTINCT po.po_id, po.manager_id, po.supplier_id, po.status, " +
                  "po.order_date, po.expected_delivery_date, po.notes, po.updated_at, " +
                  "s.name as supplier_name, u.username as manager_name, " +
                  "asn.asn_id, asn.tracking_number, asn.carrier, asn.status as asn_status, " +
                  "asn.shipment_date, asn.submitted_by " +
                  "FROM PurchaseOrders po " +
                  "INNER JOIN AdvancedShippingNotices asn ON po.po_id = asn.po_id " +
                  "LEFT JOIN Suppliers s ON po.supplier_id = s.supplier_id " +
                  "LEFT JOIN Users u ON po.manager_id = u.user_id " +
                  "WHERE po.manager_id = ? AND asn.status IN ('Sent', 'InTransit') " +
                  "ORDER BY asn.shipment_date DESC";
    
    try (PreparedStatement ps = connection.prepareStatement(query)) {
        ps.setInt(1, managerId);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            PurchaseOrder po = new PurchaseOrder();
            po.setPoId(rs.getInt("po_id"));
            po.setManagerId(rs.getInt("manager_id"));
            po.setSupplierId(rs.getInt("supplier_id"));
            po.setStatus(rs.getString("status"));
            po.setOrderDate(rs.getTimestamp("order_date"));
            po.setExpectedDeliveryDate(rs.getDate("expected_delivery_date"));
            po.setNotes(rs.getString("notes"));
            po.setUpdatedAt(rs.getTimestamp("updated_at"));
            po.setSupplierName(rs.getString("supplier_name"));
            po.setManagerName(rs.getString("manager_name"));
            
            // ASN info
            po.setAsnId(rs.getInt("asn_id"));
            po.setTrackingNumber(rs.getString("tracking_number"));
            po.setCarrier(rs.getString("carrier"));
            po.setAsnStatus(rs.getString("asn_status"));
            po.setHasAsn(true);
            
            orders.add(po);
        }
        
        System.out.println("Loaded " + orders.size() + " in-transit orders for Manager #" + managerId);
    } catch (SQLException e) {
        System.err.println("Error getting in-transit orders: " + e.getMessage());
        e.printStackTrace();
    }
    
    return orders;
}

/**
 * Get all COMPLETED orders
 * Orders with status = 'Completed' or 'Paid'
 */
public List<PurchaseOrder> getCompletedOrders(int managerId) {
    List<PurchaseOrder> orders = new ArrayList<>();
    String query = "SELECT po.po_id, po.manager_id, po.supplier_id, po.status, " +
                  "po.order_date, po.expected_delivery_date, po.notes, po.updated_at, " +
                  "s.name as supplier_name, s.performance_rating, u.username as manager_name, " +
                  "asn.asn_id, asn.tracking_number, asn.carrier, asn.status as asn_status, " +
                  "asn.shipment_date, " +
                  "(SELECT COUNT(*) FROM SupplierRatings sr " +
                  " WHERE sr.po_id = po.po_id AND sr.manager_id = ?) as is_rated, " +
                  "(SELECT rating FROM SupplierRatings sr " +
                  " WHERE sr.po_id = po.po_id AND sr.manager_id = ?) as rating_value " +
                  "FROM PurchaseOrders po " +
                  "LEFT JOIN AdvancedShippingNotices asn ON po.po_id = asn.po_id " +
                  "LEFT JOIN Suppliers s ON po.supplier_id = s.supplier_id " +
                  "LEFT JOIN Users u ON po.manager_id = u.user_id " +
                  "WHERE po.manager_id = ? AND po.status IN ('Completed', 'Paid') " +
                  "ORDER BY po.updated_at DESC";
    
    try (PreparedStatement ps = connection.prepareStatement(query)) {
        ps.setInt(1, managerId);
        ps.setInt(2, managerId);
        ps.setInt(3, managerId);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            PurchaseOrder po = new PurchaseOrder();
            po.setPoId(rs.getInt("po_id"));
            po.setManagerId(rs.getInt("manager_id"));
            po.setSupplierId(rs.getInt("supplier_id"));
            po.setStatus(rs.getString("status"));
            po.setOrderDate(rs.getTimestamp("order_date"));
            po.setExpectedDeliveryDate(rs.getDate("expected_delivery_date"));
            po.setNotes(rs.getString("notes"));
            po.setUpdatedAt(rs.getTimestamp("updated_at"));
            po.setSupplierName(rs.getString("supplier_name"));
            po.setManagerName(rs.getString("manager_name"));
            
            // ASN info (nếu có)
            int asnId = rs.getInt("asn_id");
            if (!rs.wasNull()) {
                po.setAsnId(asnId);
                po.setTrackingNumber(rs.getString("tracking_number"));
                po.setCarrier(rs.getString("carrier"));
                po.setAsnStatus(rs.getString("asn_status"));
                po.setHasAsn(true);
            }
            
            orders.add(po);
        }
        
        System.out.println("Loaded " + orders.size() + " completed orders for Manager #" + managerId);
    } catch (SQLException e) {
        System.err.println("Error getting completed orders: " + e.getMessage());
        e.printStackTrace();
    }
    
    return orders;
}

/**
 * Get ASN details by PO ID
 */
public AdvancedShippingNotice getASNByPoId(int poId) {
    String query = "SELECT asn.*, s.name as supplier_name, po.status as po_status, " +
                  "po.expected_delivery_date, " +
                  "(SELECT COUNT(*) FROM ASNItems WHERE asn_id = asn.asn_id) as total_items, " +
                  "(SELECT SUM(quantity) FROM ASNItems WHERE asn_id = asn.asn_id) as total_quantity " +
                  "FROM AdvancedShippingNotices asn " +
                  "LEFT JOIN Suppliers s ON asn.supplier_id = s.supplier_id " +
                  "LEFT JOIN PurchaseOrders po ON asn.po_id = po.po_id " +
                  "WHERE asn.po_id = ? " +
                  "ORDER BY asn.created_at DESC";
    
    try (PreparedStatement ps = connection.prepareStatement(query)) {
        ps.setInt(1, poId);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            AdvancedShippingNotice asn = new AdvancedShippingNotice();
            asn.setAsnId(rs.getInt("asn_id"));
            asn.setPoId(rs.getInt("po_id"));
            asn.setSupplierId(rs.getInt("supplier_id"));
            asn.setShipmentDate(rs.getDate("shipment_date"));
            asn.setCarrier(rs.getString("carrier"));
            asn.setTrackingNumber(rs.getString("tracking_number"));
            asn.setStatus(rs.getString("status"));
            asn.setNotes(rs.getString("notes"));
            asn.setSubmittedBy(rs.getString("submitted_by"));
            asn.setApprovedBy(rs.getString("approved_by"));
            asn.setSubmittedAt(rs.getTimestamp("submitted_at"));
            asn.setApprovedAt(rs.getTimestamp("approved_at"));
            asn.setRejectionReason(rs.getString("rejection_reason"));
            asn.setCreatedAt(rs.getTimestamp("created_at"));
            asn.setUpdatedAt(rs.getTimestamp("updated_at"));
            
            // Additional info
            asn.setSupplierName(rs.getString("supplier_name"));
            asn.setPoStatus(rs.getString("po_status"));
            asn.setExpectedDeliveryDate(rs.getDate("expected_delivery_date"));
            asn.setTotalItems(rs.getInt("total_items"));
            asn.setTotalQuantity(rs.getInt("total_quantity"));
            
            System.out.println("Loaded ASN #" + asn.getAsnId() + " for PO #" + poId);
            return asn;
        }
    } catch (SQLException e) {
        System.err.println("Error getting ASN for PO #" + poId + ": " + e.getMessage());
        e.printStackTrace();
    }
    
    return null;
}

/**
 * Get ASN items by ASN ID
 */
public List<ASNItem> getASNItems(int asnId) {
    List<ASNItem> items = new ArrayList<>();
    String query = "SELECT ai.*, m.name as medicine_name, m.category, m.strength, " +
                  "m.dosage_form, m.manufacturer, m.unit, m.active_ingredient " +
                  "FROM ASNItems ai " +
                  "LEFT JOIN Medicines m ON ai.medicine_code = m.medicine_code " +
                  "WHERE ai.asn_id = ?";
    
    try (PreparedStatement ps = connection.prepareStatement(query)) {
        ps.setInt(1, asnId);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            ASNItem item = new ASNItem();
            item.setItemId(rs.getInt("item_id"));
            item.setAsnId(rs.getInt("asn_id"));
            item.setMedicineCode(rs.getString("medicine_code"));
            item.setQuantity(rs.getInt("quantity"));
            item.setLotNumber(rs.getString("lot_number"));
            
            // Medicine details (match với ASNItem model của bạn)
            item.setMedicineName(rs.getString("medicine_name"));
            item.setMedicineCategory(rs.getString("category")); // ✅ medicineCategory
            item.setStrength(rs.getString("strength"));
            item.setDosageForm(rs.getString("dosage_form"));
            item.setManufacturer(rs.getString("manufacturer"));
            item.setUnit(rs.getString("unit"));
            item.setActiveIngredient(rs.getString("active_ingredient"));
            
            items.add(item);
        }
        
        System.out.println("Loaded " + items.size() + " items for ASN #" + asnId);
    } catch (SQLException e) {
        System.err.println("Error getting ASN items: " + e.getMessage());
        e.printStackTrace();
    }
    
    return items;
}

/**
 * Get rejection reason for a PO (if rejected)
 */
public String getRejectionReason(int poId) {
    String query = "SELECT notes FROM PurchaseOrders WHERE po_id = ? AND status = 'Rejected'";
    try (PreparedStatement ps = connection.prepareStatement(query)) {
        ps.setInt(1, poId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            String notes = rs.getString("notes");
            if (notes != null && notes.contains("Rejection Reason:")) {
                return notes.substring(notes.indexOf("Rejection Reason:") + 17).trim();
            }
            return notes;
        }
    } catch (SQLException e) {
        System.err.println("Error getting rejection reason: " + e.getMessage());
    }
    return null;
}

/**
 * Get all tasks assigned to a specific staff member
 */
public List<Task> getTasksByStaffId(int staffId) {
    List<Task> tasks = new ArrayList<>();
    String query = "SELECT t.task_id, t.po_id, t.staff_id, t.task_type, t.deadline, t.status, " +
                  "t.created_at, t.updated_at, " +
                  "u.username as staff_name, po.notes as po_notes " +
                  "FROM Tasks t " +
                  "LEFT JOIN Users u ON t.staff_id = u.user_id " +
                  "LEFT JOIN PurchaseOrders po ON t.po_id = po.po_id " +
                  "WHERE t.staff_id = ? " +
                  "ORDER BY t.deadline ASC, t.created_at DESC";
    
    try (PreparedStatement ps = connection.prepareStatement(query)) {
        ps.setInt(1, staffId);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            Task task = new Task();
            task.setTaskId(rs.getInt("task_id"));
            task.setPoId(rs.getInt("po_id"));
            task.setStaffId(rs.getInt("staff_id"));
            task.setTaskType(rs.getString("task_type"));
            task.setDeadline(rs.getDate("deadline"));
            task.setStatus(rs.getString("status"));
            task.setCreatedAt(rs.getDate("created_at"));
            task.setUpdatedAt(rs.getDate("updated_at"));
            task.setStaffName(rs.getString("staff_name"));
            task.setPoNotes(rs.getString("po_notes"));
            tasks.add(task);
        }
        
        System.out.println("Loaded " + tasks.size() + " tasks for Staff #" + staffId);
    } catch (SQLException e) {
        System.err.println("Error getting tasks for staff #" + staffId + ": " + e.getMessage());
        e.printStackTrace();
    }
    
    return tasks;
}

/**
 * Update task status (Pending -> In Progress -> Completed)
 */
public boolean updateTaskStatus(int taskId, String newStatus) {
    String query = "UPDATE Tasks SET status = ?, updated_at = GETDATE() " +
                  "WHERE task_id = ?";
    
    try (PreparedStatement ps = connection.prepareStatement(query)) {
        ps.setString(1, newStatus);
        ps.setInt(2, taskId);
        
        int result = ps.executeUpdate();
        
        System.out.println("Update Task #" + taskId + " status to '" + newStatus + "': Affected rows = " + result);
        
        return result > 0;
    } catch (SQLException e) {
        System.err.println("Error updating task status #" + taskId + ": " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}
}