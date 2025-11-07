package DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.PurchaseOrder;
import model.PurchaseOrderItem;

public class PurchaseOrderDAO extends DBContext {

    /**
     * Get all purchase orders with optional filters
     * NOW INCLUDES ASN STATUS (In Transit, Delivered, etc.)
     */
    public List<PurchaseOrder> getAllPurchaseOrders(String status, Integer supplierId, 
                                                     Date fromDate, Date toDate, String searchKeyword) {
        List<PurchaseOrder> list = new ArrayList<>();
        
        // Use the view created in database for complete status information
        StringBuilder sql = new StringBuilder(
            "SELECT po_id, manager_id, supplier_id, po_status, " +
            "order_date, expected_delivery_date, notes, updated_at, " +
            "supplier_name, manager_name, total_amount, item_count, " +
            "asn_id, tracking_number, carrier, asn_status, has_asn, " +
            "display_status, status_badge_class " +
            "FROM vw_PurchaseOrdersWithShipping " +
            "WHERE 1=1 "
        );

        // Add filters
        if (status != null && !status.isEmpty()) {
            sql.append("AND po_status = ? ");
        }
        if (supplierId != null) {
            sql.append("AND supplier_id = ? ");
        }
        if (fromDate != null) {
            sql.append("AND order_date >= ? ");
        }
        if (toDate != null) {
            sql.append("AND order_date <= ? ");
        }
        if (searchKeyword != null && !searchKeyword.isEmpty()) {
            sql.append("AND (supplier_name LIKE ? OR notes LIKE ? OR CAST(po_id AS NVARCHAR) LIKE ?) ");
        }

        sql.append("ORDER BY order_date DESC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;

            if (status != null && !status.isEmpty()) {
                ps.setString(paramIndex++, status);
            }
            if (supplierId != null) {
                ps.setInt(paramIndex++, supplierId);
            }
            if (fromDate != null) {
                ps.setDate(paramIndex++, fromDate);
            }
            if (toDate != null) {
                ps.setDate(paramIndex++, toDate);
            }
            if (searchKeyword != null && !searchKeyword.isEmpty()) {
                String keyword = "%" + searchKeyword + "%";
                ps.setString(paramIndex++, keyword);
                ps.setString(paramIndex++, keyword);
                ps.setString(paramIndex++, keyword);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PurchaseOrder po = new PurchaseOrder();
                
                // Basic PO info
                po.setPoId(rs.getInt("po_id"));
                po.setManagerId(rs.getInt("manager_id"));
                po.setSupplierId(rs.getInt("supplier_id"));
                po.setStatus(rs.getString("po_status"));
                po.setOrderDate(rs.getTimestamp("order_date"));
                po.setExpectedDeliveryDate(rs.getDate("expected_delivery_date"));
                po.setNotes(rs.getString("notes"));
                po.setUpdatedAt(rs.getTimestamp("updated_at"));
                po.setSupplierName(rs.getString("supplier_name"));
                po.setManagerName(rs.getString("manager_name"));
                po.setTotalAmount(rs.getDouble("total_amount"));
                po.setItemCount(rs.getInt("item_count"));
                
                // ASN information
                int asnId = rs.getInt("asn_id");
                if (!rs.wasNull()) {
                    po.setAsnId(asnId);
                    po.setTrackingNumber(rs.getString("tracking_number"));
                    po.setCarrier(rs.getString("carrier"));
                    po.setAsnStatus(rs.getString("asn_status"));
                    po.setHasAsn(rs.getBoolean("has_asn"));
                }
                
                // Display status (combined PO + ASN status)
                po.setDisplayStatus(rs.getString("display_status"));
                po.setStatusBadgeClass(rs.getString("status_badge_class"));
                
                list.add(po);
            }
        } catch (SQLException e) {
            System.err.println("Error in getAllPurchaseOrders: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get purchase order by ID with ASN details
     */
    public PurchaseOrder getPurchaseOrderById(int poId) {
        String sql = "SELECT po_id, manager_id, supplier_id, po_status, " +
                     "order_date, expected_delivery_date, notes, updated_at, " +
                     "supplier_name, manager_name, total_amount, item_count, " +
                     "asn_id, tracking_number, carrier, asn_status, has_asn, " +
                     "display_status, status_badge_class " +
                     "FROM vw_PurchaseOrdersWithShipping " +
                     "WHERE po_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, poId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                PurchaseOrder po = new PurchaseOrder();
                
                po.setPoId(rs.getInt("po_id"));
                po.setManagerId(rs.getInt("manager_id"));
                po.setSupplierId(rs.getInt("supplier_id"));
                po.setStatus(rs.getString("po_status"));
                po.setOrderDate(rs.getTimestamp("order_date"));
                po.setExpectedDeliveryDate(rs.getDate("expected_delivery_date"));
                po.setNotes(rs.getString("notes"));
                po.setUpdatedAt(rs.getTimestamp("updated_at"));
                po.setSupplierName(rs.getString("supplier_name"));
                po.setManagerName(rs.getString("manager_name"));
                
                // ASN information
                int asnId = rs.getInt("asn_id");
                if (!rs.wasNull()) {
                    po.setAsnId(asnId);
                    po.setTrackingNumber(rs.getString("tracking_number"));
                    po.setCarrier(rs.getString("carrier"));
                    po.setAsnStatus(rs.getString("asn_status"));
                    po.setHasAsn(rs.getBoolean("has_asn"));
                }
                
                po.setDisplayStatus(rs.getString("display_status"));
                po.setStatusBadgeClass(rs.getString("status_badge_class"));
                
                return po;
            }
        } catch (SQLException e) {
            System.err.println("Error in getPurchaseOrderById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get items with COMPLETE medicine details
     */
    public List<PurchaseOrderItem> getItemsByPurchaseOrderId(int poId) {
        List<PurchaseOrderItem> items = new ArrayList<>();
        String sql = "SELECT poi.item_id, poi.po_id, poi.medicine_code, " +
                     "poi.quantity, poi.unit_price, poi.priority, poi.notes, " +
                     "m.name, m.category, m.strength, m.dosage_form, " +
                     "m.manufacturer, m.unit, m.active_ingredient " +
                     "FROM PurchaseOrderItems poi " +
                     "LEFT JOIN Medicines m ON poi.medicine_code = m.medicine_code " +
                     "WHERE poi.po_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, poId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                PurchaseOrderItem item = new PurchaseOrderItem();
                
                item.setPoItemId(rs.getInt("item_id"));
                item.setPoId(rs.getInt("po_id"));
                item.setMedicineCode(rs.getString("medicine_code"));
                item.setQuantity(rs.getInt("quantity"));
                
                double unitPrice = rs.getDouble("unit_price");
                if (!rs.wasNull()) {
                    item.setUnitPrice(unitPrice);
                }
                item.setPriority(rs.getString("priority"));
                item.setNotes(rs.getString("notes"));
                
                // Medicine details
                item.setMedicineName(rs.getString("name"));
                item.setMedicineCategory(rs.getString("category"));
                item.setMedicineStrength(rs.getString("strength"));
                item.setMedicineDosageForm(rs.getString("dosage_form"));
                item.setMedicineManufacturer(rs.getString("manufacturer"));
                item.setUnit(rs.getString("unit"));
                item.setActiveIngredient(rs.getString("active_ingredient"));
                
                items.add(item);
            }
        } catch (SQLException e) {
            System.err.println("Error in getItemsByPurchaseOrderId: " + e.getMessage());
            e.printStackTrace();
        }
        return items;
    }

    /**
     * Get all distinct statuses
     */
    public List<String> getAllStatuses() {
        List<String> statuses = new ArrayList<>();
        String sql = "SELECT DISTINCT status FROM PurchaseOrders ORDER BY status";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                statuses.add(rs.getString("status"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return statuses;
    }

    /**
     * Get purchase order statistics
     */
    public Object[] getPurchaseOrderStatistics() {
        Object[] stats = new Object[4];
        stats[0] = 0;
        stats[1] = 0;
        stats[2] = 0;
        stats[3] = 0.0;
        
        String sql = "SELECT " +
                     "COUNT(*) AS total_orders, " +
                     "SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) AS completed_orders, " +
                     "SUM(CASE WHEN status IN ('Draft', 'Sent', 'Approved') THEN 1 ELSE 0 END) AS pending_orders, " +
                     "ISNULL(SUM(poi.quantity * poi.unit_price), 0) AS total_amount " +
                     "FROM PurchaseOrders po " +
                     "LEFT JOIN PurchaseOrderItems poi ON po.po_id = poi.po_id";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                stats[0] = rs.getInt("total_orders");
                stats[1] = rs.getInt("completed_orders");
                stats[2] = rs.getInt("pending_orders");
                stats[3] = rs.getDouble("total_amount");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }
    
    /**
     * Get historical purchase orders for trend analysis
     */
    public List<PurchaseOrder> getHistoricalPurchaseOrders(Integer supplierId, 
                                                           Date fromDate, Date toDate, 
                                                           String searchKeyword) {
        List<PurchaseOrder> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT po_id, manager_id, supplier_id, po_status, " +
            "order_date, expected_delivery_date, notes, updated_at, " +
            "supplier_name, manager_name, total_amount, item_count, " +
            "display_status, status_badge_class " +
            "FROM vw_PurchaseOrdersWithShipping " +
            "WHERE po_status IN ('Completed', 'Received') "
        );

        if (supplierId != null) {
            sql.append("AND supplier_id = ? ");
        }
        if (fromDate != null) {
            sql.append("AND order_date >= ? ");
        }
        if (toDate != null) {
            sql.append("AND order_date <= ? ");
        }
        if (searchKeyword != null && !searchKeyword.isEmpty()) {
            sql.append("AND (supplier_name LIKE ? OR notes LIKE ? OR CAST(po_id AS NVARCHAR) LIKE ?) ");
        }

        sql.append("ORDER BY order_date DESC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;

            if (supplierId != null) {
                ps.setInt(paramIndex++, supplierId);
            }
            if (fromDate != null) {
                ps.setDate(paramIndex++, fromDate);
            }
            if (toDate != null) {
                ps.setDate(paramIndex++, toDate);
            }
            if (searchKeyword != null && !searchKeyword.isEmpty()) {
                String keyword = "%" + searchKeyword + "%";
                ps.setString(paramIndex++, keyword);
                ps.setString(paramIndex++, keyword);
                ps.setString(paramIndex++, keyword);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PurchaseOrder po = new PurchaseOrder();
                po.setPoId(rs.getInt("po_id"));
                po.setManagerId(rs.getInt("manager_id"));
                po.setSupplierId(rs.getInt("supplier_id"));
                po.setStatus(rs.getString("po_status"));
                po.setOrderDate(rs.getTimestamp("order_date"));
                po.setExpectedDeliveryDate(rs.getDate("expected_delivery_date"));
                po.setNotes(rs.getString("notes"));
                po.setUpdatedAt(rs.getTimestamp("updated_at"));
                po.setSupplierName(rs.getString("supplier_name"));
                po.setManagerName(rs.getString("manager_name"));
                po.setTotalAmount(rs.getDouble("total_amount"));
                po.setItemCount(rs.getInt("item_count"));
                po.setDisplayStatus(rs.getString("display_status"));
                po.setStatusBadgeClass(rs.getString("status_badge_class"));
                list.add(po);
            }
        } catch (SQLException e) {
            System.err.println("Error in getHistoricalPurchaseOrders: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }
}