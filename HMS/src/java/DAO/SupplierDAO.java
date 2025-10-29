package DAO;

import model.Supplier;
import model.PurchaseOrder;
import model.PurchaseOrderItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SupplierDAO extends DBContext {

    // LẤY THÔNG TIN SUPPLIER THEO USER_ID
    public Supplier getSupplierByUserId(int userId) {
        String sql = "SELECT supplier_id, user_id, name, contact_email, contact_phone, " +
                     "address, performance_rating " +
                     "FROM Suppliers WHERE user_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Supplier supplier = new Supplier();
                supplier.setSupplierId(rs.getInt("supplier_id"));
                supplier.setUserId(rs.getInt("user_id"));
                supplier.setName(rs.getString("name"));
                supplier.setContactEmail(rs.getString("contact_email"));
                supplier.setContactPhone(rs.getString("contact_phone"));
                supplier.setAddress(rs.getString("address"));
                supplier.setPerformanceRating(rs.getDouble("performance_rating"));
                return supplier;
            }
        } catch (SQLException e) {
            System.err.println("Error in getSupplierByUserId: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // LẤY PURCHASE ORDERS THEO SUPPLIER VÀ STATUS (WITH ASN INFO)
    public List<PurchaseOrder> getPurchaseOrdersBySupplier(int supplierId, String status) {
        List<PurchaseOrder> orders = new ArrayList<>();
        String sql = "SELECT po.po_id, po.manager_id, po.supplier_id, po.status, " +
                     "po.order_date, po.expected_delivery_date, po.notes, po.updated_at, " +
                     "u.username AS manager_name, " +
                     "asn.asn_id, asn.tracking_number, asn.carrier, asn.status AS asn_status " +
                     "FROM PurchaseOrders po " +
                     "LEFT JOIN Users u ON po.manager_id = u.user_id " +
                     "LEFT JOIN AdvancedShippingNotices asn ON po.po_id = asn.po_id " +
                     "WHERE po.supplier_id = ? AND po.status = ? " +
                     "ORDER BY po.order_date DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
            ps.setString(2, status);
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
                po.setManagerName(rs.getString("manager_name"));
                
                // ASN info
                int asnId = rs.getInt("asn_id");
                if (asnId > 0) {
                    po.setAsnId(asnId);
                    po.setTrackingNumber(rs.getString("tracking_number"));
                    po.setCarrier(rs.getString("carrier"));
                    po.setAsnStatus(rs.getString("asn_status"));
                    po.setHasAsn(true);
                }

                // Lấy items và set vào PO
                List<PurchaseOrderItem> items = getPurchaseOrderItems(po.getPoId());
                po.setItems(items);
                
                // Tính tổng tiền
                double total = items.stream()
                    .mapToDouble(item -> item.getQuantity() * item.getUnitPrice())
                    .sum();
                po.setTotalAmount(total);

                orders.add(po);
            }
        } catch (SQLException e) {
            System.err.println("Error in getPurchaseOrdersBySupplier: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    // LẤY ITEMS CỦA PO
    public List<PurchaseOrderItem> getPurchaseOrderItems(int poId) {
        List<PurchaseOrderItem> items = new ArrayList<>();
        String sql = "SELECT poi.item_id, poi.po_id, poi.medicine_code, poi.quantity, " +
                     "poi.unit_price, poi.priority, poi.notes, " +
                     "m.name AS medicine_name, m.category, m.strength, m.dosage_form, " +
                     "m.unit, m.manufacturer, m.active_ingredient " +
                     "FROM PurchaseOrderItems poi " +
                     "INNER JOIN Medicines m ON poi.medicine_code = m.medicine_code " +
                     "WHERE poi.po_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, poId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                PurchaseOrderItem item = new PurchaseOrderItem();
                item.setItemId(rs.getInt("item_id"));
                item.setPoId(rs.getInt("po_id"));
                item.setMedicineCode(rs.getString("medicine_code"));
                item.setQuantity(rs.getInt("quantity"));
                
                // Handle NULL unit_price
                double unitPrice = rs.getDouble("unit_price");
                item.setUnitPrice(rs.wasNull() ? 0.0 : unitPrice);
                
                item.setPriority(rs.getString("priority"));
                item.setNotes(rs.getString("notes"));

                // Thông tin thuốc
                item.setMedicineName(rs.getString("medicine_name"));
                item.setMedicineCategory(rs.getString("category"));
                item.setMedicineStrength(rs.getString("strength"));
                item.setMedicineDosageForm(rs.getString("dosage_form"));
                item.setUnit(rs.getString("unit"));
                item.setMedicineManufacturer(rs.getString("manufacturer"));
                item.setActiveIngredient(rs.getString("active_ingredient"));

                items.add(item);
            }
        } catch (SQLException e) {
            System.err.println("Error in getPurchaseOrderItems: " + e.getMessage());
            e.printStackTrace();
        }
        return items;
    }

    // THỐNG KÊ CHO SUPPLIER (FIXED - Loại bỏ Draft)
    public Map<String, Object> getSupplierStats(int supplierId) {
        Map<String, Object> stats = new HashMap<>();

        String sql = "SELECT " +
                     "COUNT(CASE WHEN status = 'Sent' THEN 1 END) AS pending_count, " +
                     "COUNT(CASE WHEN status = 'Approved' THEN 1 END) AS approved_count, " +
                     "COUNT(CASE WHEN status = 'Completed' THEN 1 END) AS completed_count, " +
                     "COUNT(CASE WHEN status IN ('Sent', 'Approved', 'Completed') THEN 1 END) AS total_orders " +
                     "FROM PurchaseOrders " +
                     "WHERE supplier_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                stats.put("pendingCount", rs.getInt("pending_count"));
                stats.put("approvedCount", rs.getInt("approved_count"));
                stats.put("completedCount", rs.getInt("completed_count"));
                stats.put("totalOrders", rs.getInt("total_orders"));
            } else {
                // Default values if no data
                stats.put("pendingCount", 0);
                stats.put("approvedCount", 0);
                stats.put("completedCount", 0);
                stats.put("totalOrders", 0);
            }
        } catch (SQLException e) {
            System.err.println("Error in getSupplierStats: " + e.getMessage());
            e.printStackTrace();
            stats.put("pendingCount", 0);
            stats.put("approvedCount", 0);
            stats.put("completedCount", 0);
            stats.put("totalOrders", 0);
        }

        return stats;
    }

    // XÁC NHẬN ĐƠN HÀNG (Supplier approves the PO)
    public boolean confirmPurchaseOrder(int poId, int supplierId) {
        String sql = "UPDATE PurchaseOrders SET status = 'Approved', updated_at = GETDATE() " +
                     "WHERE po_id = ? AND supplier_id = ? AND status = 'Sent'";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, poId);
            ps.setInt(2, supplierId);
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                logSupplierAction(supplierId, "CONFIRM_PO", poId, "Supplier confirmed PO #" + poId);
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error in confirmPurchaseOrder: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // TỪ CHỐI ĐƠN HÀNG (Supplier rejects the PO)
    public boolean rejectPurchaseOrder(int poId, int supplierId, String reason) {
        String sql = "UPDATE PurchaseOrders SET status = 'Rejected', " +
                     "notes = CONCAT(COALESCE(notes, ''), '\n[REJECTED by Supplier]: ', ?), " +
                     "updated_at = GETDATE() " +
                     "WHERE po_id = ? AND supplier_id = ? AND status = 'Sent'";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, reason);
            ps.setInt(2, poId);
            ps.setInt(3, supplierId);
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                logSupplierAction(supplierId, "REJECT_PO", poId, "Supplier rejected PO #" + poId + ": " + reason);
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error in rejectPurchaseOrder: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

// LẤY CHI TIẾT MỘT PO (for detail page & ASN creation) - FIXED TO INCLUDE ASN INFO
public PurchaseOrder getPurchaseOrderById(int poId, int supplierId) {
    String sql = "SELECT po.po_id, po.manager_id, po.supplier_id, po.status, " +
                 "po.order_date, po.expected_delivery_date, po.notes, po.updated_at, " +
                 "u.username AS manager_name, s.name AS supplier_name, " +
                 "asn.asn_id, asn.tracking_number, asn.carrier, asn.status AS asn_status " +
                 "FROM PurchaseOrders po " +
                 "LEFT JOIN Users u ON po.manager_id = u.user_id " +
                 "LEFT JOIN Suppliers s ON po.supplier_id = s.supplier_id " +
                 "LEFT JOIN AdvancedShippingNotices asn ON po.po_id = asn.po_id " +
                 "WHERE po.po_id = ? AND po.supplier_id = ?";

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, poId);
        ps.setInt(2, supplierId);
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
            po.setUpdatedAt(rs.getTimestamp("updated_at"));
            po.setManagerName(rs.getString("manager_name"));
            po.setSupplierName(rs.getString("supplier_name"));

            // ASN INFO - SAME AS getPurchaseOrdersBySupplier()
            int asnId = rs.getInt("asn_id");
            if (asnId > 0) {
                po.setAsnId(asnId);
                po.setTrackingNumber(rs.getString("tracking_number"));
                po.setCarrier(rs.getString("carrier"));
                po.setAsnStatus(rs.getString("asn_status"));
                po.setHasAsn(true);
            }

            // Get items
            List<PurchaseOrderItem> items = getPurchaseOrderItems(po.getPoId());
            po.setItems(items);
            
            // Calculate total
            double total = items.stream()
                .mapToDouble(item -> item.getQuantity() * item.getUnitPrice())
                .sum();
            po.setTotalAmount(total);

            return po;
        }
    } catch (SQLException e) {
        System.err.println("Error in getPurchaseOrderById: " + e.getMessage());
        e.printStackTrace();
    }
    return null;
}

    // CHECK IF ASN EXISTS FOR PO
    public boolean hasASNForPO(int poId) {
        String sql = "SELECT COUNT(*) FROM AdvancedShippingNotices WHERE po_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, poId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error in hasASNForPO: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // CREATE ASN (COMPLETE VERSION)
    public boolean createASN(int poId, int supplierId, Date shipmentDate, 
                            String carrier, String trackingNumber, String notes, 
                            String submittedBy) {
        String sql = "INSERT INTO AdvancedShippingNotices " +
                     "(po_id, supplier_id, shipment_date, carrier, tracking_number, " +
                     "status, notes, submitted_by, submitted_at, created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, 'Sent', ?, ?, GETDATE(), GETDATE(), GETDATE())";

        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, poId);
            ps.setInt(2, supplierId);
            ps.setDate(3, shipmentDate);
            ps.setString(4, carrier);
            ps.setString(5, trackingNumber);
            ps.setString(6, notes);
            ps.setString(7, submittedBy);
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int asnId = generatedKeys.getInt(1);
                    
                    // Copy items from PO to ASN
                    boolean itemsCopied = copyPOItemsToASN(poId, asnId);
                    
                    if (itemsCopied) {
                        logSupplierAction(supplierId, "CREATE_ASN", poId, "Created ASN #" + asnId + " for PO #" + poId);
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in createASN: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // COPY PO ITEMS TO ASN ITEMS
    private boolean copyPOItemsToASN(int poId, int asnId) {
        String sql = "INSERT INTO ASNItems (asn_id, medicine_code, quantity, lot_number) " +
                     "SELECT ?, medicine_code, quantity, NULL " +
                     "FROM PurchaseOrderItems " +
                     "WHERE po_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, asnId);
            ps.setInt(2, poId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error copying PO items to ASN: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // LOG SUPPLIER ACTIONS
    private void logSupplierAction(int supplierId, String action, int poId, String details) {
        String sql = "INSERT INTO SystemLogs (user_id, action, table_name, record_id, details, ip_address, log_date) " +
                     "SELECT u.user_id, ?, 'PurchaseOrders', ?, ?, '0.0.0.0', GETDATE() " +
                     "FROM Suppliers s " +
                     "INNER JOIN Users u ON s.user_id = u.user_id " +
                     "WHERE s.supplier_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, action);
            ps.setInt(2, poId);
            ps.setString(3, details);
            ps.setInt(4, supplierId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error logging supplier action: " + e.getMessage());
        }
    }

    // GET ALL POs FOR SUPPLIER (all valid statuses, excluding Draft)
    public List<PurchaseOrder> getAllPurchaseOrdersBySupplier(int supplierId) {
        List<PurchaseOrder> orders = new ArrayList<>();
        String sql = "SELECT po.po_id, po.manager_id, po.supplier_id, po.status, " +
                     "po.order_date, po.expected_delivery_date, po.notes, po.updated_at, " +
                     "u.username AS manager_name " +
                     "FROM PurchaseOrders po " +
                     "LEFT JOIN Users u ON po.manager_id = u.user_id " +
                     "WHERE po.supplier_id = ? AND po.status IN ('Sent', 'Approved', 'Received', 'Completed') " +
                     "ORDER BY po.order_date DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
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
                po.setManagerName(rs.getString("manager_name"));

                List<PurchaseOrderItem> items = getPurchaseOrderItems(po.getPoId());
                po.setItems(items);
                
                double total = items.stream()
                    .mapToDouble(item -> item.getQuantity() * item.getUnitPrice())
                    .sum();
                po.setTotalAmount(total);

                orders.add(po);
            }
        } catch (SQLException e) {
            System.err.println("Error in getAllPurchaseOrdersBySupplier: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }
}