package DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.PurchaseOrder;
import model.PurchaseOrderItem;

public class PurchaseOrderDAO extends DBContext {

    /**
     * Get all purchase orders with optional filters
     */
    public List<PurchaseOrder> getAllPurchaseOrders(String status, Integer supplierId, 
                                                     Date fromDate, Date toDate, String searchKeyword) {
        List<PurchaseOrder> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT po.po_id, po.manager_id, po.supplier_id, po.status, " +
            "po.order_date, po.expected_delivery_date, po.notes, po.updated_at, " +
            "s.name AS supplier_name, u.username AS manager_name, " +
            "ISNULL(SUM(poi.quantity * poi.unit_price), 0) AS total_amount, " +
            "COUNT(poi.item_id) AS item_count " +
            "FROM PurchaseOrders po " +
            "LEFT JOIN Suppliers s ON po.supplier_id = s.supplier_id " +
            "LEFT JOIN Users u ON po.manager_id = u.user_id " +
            "LEFT JOIN PurchaseOrderItems poi ON po.po_id = poi.po_id " +
            "WHERE 1=1 "
        );

        // Add filters
        if (status != null && !status.isEmpty()) {
            sql.append("AND po.status = ? ");
        }
        if (supplierId != null) {
            sql.append("AND po.supplier_id = ? ");
        }
        if (fromDate != null) {
            sql.append("AND po.order_date >= ? ");
        }
        if (toDate != null) {
            sql.append("AND po.order_date <= ? ");
        }
        if (searchKeyword != null && !searchKeyword.isEmpty()) {
            sql.append("AND (s.name LIKE ? OR po.notes LIKE ? OR CAST(po.po_id AS NVARCHAR) LIKE ?) ");
        }

        sql.append("GROUP BY po.po_id, po.manager_id, po.supplier_id, po.status, " +
                   "po.order_date, po.expected_delivery_date, po.notes, po.updated_at, " +
                   "s.name, u.username " +
                   "ORDER BY po.order_date DESC");

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
                po.setPoId(rs.getInt("po_id"));
                po.setManagerId(rs.getInt("manager_id"));
                po.setSupplierId(rs.getInt("supplier_id"));
                po.setStatus(rs.getString("status"));
                po.setOrderDate(rs.getDate("order_date"));
                po.setExpectedDeliveryDate(rs.getDate("expected_delivery_date"));
                po.setNotes(rs.getString("notes"));
                po.setUpdatedAt(rs.getDate("updated_at"));
                po.setSupplierName(rs.getString("supplier_name"));
                po.setManagerName(rs.getString("manager_name"));
                po.setTotalAmount(rs.getDouble("total_amount"));
                po.setItemCount(rs.getInt("item_count"));
                list.add(po);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get purchase order by ID
     */
    public PurchaseOrder getPurchaseOrderById(int poId) {
        String sql = "SELECT po.po_id, po.manager_id, po.supplier_id, po.status, " +
                     "po.order_date, po.expected_delivery_date, po.notes, po.updated_at, " +
                     "s.name AS supplier_name, s.contact_email, s.contact_phone, s.address, " +
                     "u.username AS manager_name, u.email AS manager_email " +
                     "FROM PurchaseOrders po " +
                     "LEFT JOIN Suppliers s ON po.supplier_id = s.supplier_id " +
                     "LEFT JOIN Users u ON po.manager_id = u.user_id " +
                     "WHERE po.po_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
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
                po.setUpdatedAt(rs.getDate("updated_at"));
                po.setSupplierName(rs.getString("supplier_name"));
                po.setManagerName(rs.getString("manager_name"));
                return po;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get items for a purchase order
     */
    public List<PurchaseOrderItem> getItemsByPurchaseOrderId(int poId) {
        List<PurchaseOrderItem> items = new ArrayList<>();
        String sql = "SELECT poi.item_id, poi.po_id, poi.medicine_code, poi.quantity, " +
                     "poi.unit_price, poi.priority, poi.notes, " +
                     "m.name AS medicine_name, m.unit, m.manufacturer " +
                     "FROM PurchaseOrderItems poi " +
                     "JOIN Medicines m ON poi.medicine_code = m.medicine_code " +
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
                item.setUnitPrice(rs.getDouble("unit_price"));
                item.setPriority(rs.getString("priority"));
                item.setNotes(rs.getString("notes"));
                item.setMedicineName(rs.getString("medicine_name"));
                item.setUnit(rs.getString("unit"));
                item.setMedicineManufacturer(rs.getString("manufacturer"));
                items.add(item);
            }
        } catch (SQLException e) {
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
     * Returns: [totalOrders, completedOrders, pendingOrders, totalAmount]
     */
    public Object[] getPurchaseOrderStatistics() {
        Object[] stats = new Object[4];
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
}