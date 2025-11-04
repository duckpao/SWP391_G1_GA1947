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
                po.setOrderDate(rs.getTimestamp("order_date"));
                po.setExpectedDeliveryDate(rs.getDate("expected_delivery_date"));
                po.setNotes(rs.getString("notes"));
                po.setUpdatedAt(rs.getTimestamp("updated_at"));
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
                po.setOrderDate(rs.getTimestamp("order_date"));
                po.setExpectedDeliveryDate(rs.getDate("expected_delivery_date"));
                po.setNotes(rs.getString("notes"));
                po.setUpdatedAt(rs.getTimestamp("updated_at"));
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
     * === FIXED: Get items with COMPLETE medicine details ===
     * Matches ManagerDAO structure for consistency
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

        System.out.println("====================================");
        System.out.println("DEBUG PurchaseOrderDAO: Getting items for PO #" + poId);
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
                
                // === COMPLETE Medicine details ===
                String medicineName = rs.getString("name");
                String category = rs.getString("category");
                String strength = rs.getString("strength");
                String dosageForm = rs.getString("dosage_form");
                String manufacturer = rs.getString("manufacturer");
                String unit = rs.getString("unit");
                String activeIngredient = rs.getString("active_ingredient");
                
                item.setMedicineName(medicineName);
                item.setMedicineCategory(category);
                item.setMedicineStrength(strength);
                item.setMedicineDosageForm(dosageForm);
                item.setMedicineManufacturer(manufacturer);
                item.setUnit(unit);
                item.setActiveIngredient(activeIngredient);
                
                // Debug log
                System.out.println("Item #" + count + ":");
                System.out.println("  - Item ID: " + item.getPoItemId());
                System.out.println("  - Medicine Code: " + item.getMedicineCode());
                System.out.println("  - Medicine Name: " + medicineName);
                System.out.println("  - Category: " + category);
                System.out.println("  - Strength: " + strength);
                System.out.println("  - Dosage Form: " + dosageForm);
                System.out.println("  - Manufacturer: " + manufacturer);
                System.out.println("  - Quantity: " + item.getQuantity());
                System.out.println("  - Unit Price: " + unitPrice);
                System.out.println("  - Priority: " + item.getPriority());
                
                items.add(item);
            }
            
            System.out.println("Total items loaded: " + items.size());
            System.out.println("====================================");
            
        } catch (SQLException e) {
            System.err.println("ERROR in getItemsByPurchaseOrderId: " + e.getMessage());
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
    
    // =========================================
    // NEW METHODS FOR HISTORY & TREND ANALYSIS
    // =========================================
    
    /**
     * Get historical purchase orders for trend analysis
     * Only completed and received orders
     */
    public List<PurchaseOrder> getHistoricalPurchaseOrders(Integer supplierId, 
                                                           Date fromDate, Date toDate, 
                                                           String searchKeyword) {
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
            "WHERE po.status IN ('Completed', 'Received') "
        );

        // Add filters
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
                po.setOrderDate(rs.getTimestamp("order_date"));
                po.setExpectedDeliveryDate(rs.getDate("expected_delivery_date"));
                po.setNotes(rs.getString("notes"));
                po.setUpdatedAt(rs.getTimestamp("updated_at"));
                po.setSupplierName(rs.getString("supplier_name"));
                po.setManagerName(rs.getString("manager_name"));
                po.setTotalAmount(rs.getDouble("total_amount"));
                po.setItemCount(rs.getInt("item_count"));
                list.add(po);
            }
        } catch (SQLException e) {
            System.err.println("Error in getHistoricalPurchaseOrders: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Get trend analysis data by month
     * Returns data for charts
     */
    public List<Map<String, Object>> getTrendDataByMonth(Integer supplierId, Date fromDate, Date toDate) {
        List<Map<String, Object>> trendData = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT " +
            "YEAR(po.order_date) AS year, " +
            "MONTH(po.order_date) AS month, " +
            "COUNT(po.po_id) AS order_count, " +
            "ISNULL(SUM(poi.quantity * poi.unit_price), 0) AS total_amount " +
            "FROM PurchaseOrders po " +
            "LEFT JOIN PurchaseOrderItems poi ON po.po_id = poi.po_id " +
            "WHERE po.status IN ('Completed', 'Received') "
        );

        if (supplierId != null) {
            sql.append("AND po.supplier_id = ? ");
        }
        if (fromDate != null) {
            sql.append("AND po.order_date >= ? ");
        }
        if (toDate != null) {
            sql.append("AND po.order_date <= ? ");
        }

        sql.append("GROUP BY YEAR(po.order_date), MONTH(po.order_date) " +
                   "ORDER BY year, month");

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

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> data = new HashMap<>();
                data.put("year", rs.getInt("year"));
                data.put("month", rs.getInt("month"));
                data.put("orderCount", rs.getInt("order_count"));
                data.put("totalAmount", rs.getDouble("total_amount"));
                trendData.add(data);
            }
        } catch (SQLException e) {
            System.err.println("Error in getTrendDataByMonth: " + e.getMessage());
            e.printStackTrace();
        }
        return trendData;
    }
    
    /**
     * Get supplier performance comparison
     */
    public List<Map<String, Object>> getSupplierPerformance(Date fromDate, Date toDate) {
        List<Map<String, Object>> performance = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT " +
            "s.supplier_id, " +
            "s.name AS supplier_name, " +
            "COUNT(po.po_id) AS total_orders, " +
            "SUM(CASE WHEN po.status = 'Completed' THEN 1 ELSE 0 END) AS completed_orders, " +
            "ISNULL(SUM(poi.quantity * poi.unit_price), 0) AS total_amount, " +
            "AVG(DATEDIFF(day, po.order_date, po.updated_at)) AS avg_delivery_days " +
            "FROM Suppliers s " +
            "LEFT JOIN PurchaseOrders po ON s.supplier_id = po.supplier_id " +
            "LEFT JOIN PurchaseOrderItems poi ON po.po_id = poi.po_id " +
            "WHERE 1=1 "
        );

        if (fromDate != null) {
            sql.append("AND po.order_date >= ? ");
        }
        if (toDate != null) {
            sql.append("AND po.order_date <= ? ");
        }

        sql.append("GROUP BY s.supplier_id, s.name " +
                   "HAVING COUNT(po.po_id) > 0 " +
                   "ORDER BY total_amount DESC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;

            if (fromDate != null) {
                ps.setDate(paramIndex++, fromDate);
            }
            if (toDate != null) {
                ps.setDate(paramIndex++, toDate);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> data = new HashMap<>();
                data.put("supplierId", rs.getInt("supplier_id"));
                data.put("supplierName", rs.getString("supplier_name"));
                data.put("totalOrders", rs.getInt("total_orders"));
                data.put("completedOrders", rs.getInt("completed_orders"));
                data.put("totalAmount", rs.getDouble("total_amount"));
                data.put("avgDeliveryDays", rs.getInt("avg_delivery_days"));
                performance.add(data);
            }
        } catch (SQLException e) {
            System.err.println("Error in getSupplierPerformance: " + e.getMessage());
            e.printStackTrace();
        }
        return performance;
    }
}