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
     * Shows ACTUAL PO status, not ASN status
     */
    public List<PurchaseOrder> getAllPurchaseOrders(String status, Integer supplierId,
            Date fromDate, Date toDate, String searchKeyword) {
        List<PurchaseOrder> list = new ArrayList<>();

        // ✅ FIXED: Use direct query instead of view to control status display
        StringBuilder sql = new StringBuilder(
                "SELECT "
                + "po.po_id, po.manager_id, po.supplier_id, po.status AS po_status, "
                + "po.order_date, po.expected_delivery_date, po.notes, po.updated_at, "
                + "s.name AS supplier_name, "
                + "u.username AS manager_name, "
                // Get ASN info if exists
                + "asn.asn_id, asn.tracking_number, asn.carrier, asn.status AS asn_status, "
                + "CASE WHEN asn.asn_id IS NOT NULL THEN 1 ELSE 0 END AS has_asn, "
                // Calculate totals
                + "ISNULL(SUM(poi.quantity * ISNULL(poi.unit_price, 0)), 0) AS total_amount, "
                + "COUNT(DISTINCT poi.item_id) AS item_count "
                + "FROM PurchaseOrders po "
                + "LEFT JOIN Suppliers s ON po.supplier_id = s.supplier_id "
                + "LEFT JOIN Users u ON po.manager_id = u.user_id "
                + "LEFT JOIN PurchaseOrderItems poi ON po.po_id = poi.po_id "
                // Get latest ASN
                + "LEFT JOIN ( "
                + "  SELECT asn.*, "
                + "  ROW_NUMBER() OVER (PARTITION BY asn.po_id ORDER BY asn.created_at DESC) AS rn "
                + "  FROM AdvancedShippingNotices asn "
                + ") asn ON po.po_id = asn.po_id AND asn.rn = 1 "
                + "WHERE 1=1 "
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

        sql.append("GROUP BY po.po_id, po.manager_id, po.supplier_id, po.status, "
                + "po.order_date, po.expected_delivery_date, po.notes, po.updated_at, "
                + "s.name, u.username, asn.asn_id, asn.tracking_number, asn.carrier, asn.status "
                + "ORDER BY po.order_date DESC");

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
                
                // ✅ FIXED: Use actual PO status
                String poStatus = rs.getString("po_status");
                po.setStatus(poStatus);
                
                po.setOrderDate(rs.getTimestamp("order_date"));
                po.setExpectedDeliveryDate(rs.getDate("expected_delivery_date"));
                po.setNotes(rs.getString("notes"));
                po.setUpdatedAt(rs.getTimestamp("updated_at"));
                po.setSupplierName(rs.getString("supplier_name"));
                po.setManagerName(rs.getString("manager_name"));
                po.setTotalAmount(rs.getDouble("total_amount"));
                po.setItemCount(rs.getInt("item_count"));

                // ASN information (separate from PO status)
                int asnId = rs.getInt("asn_id");
                if (!rs.wasNull()) {
                    po.setAsnId(asnId);
                    po.setTrackingNumber(rs.getString("tracking_number"));
                    po.setCarrier(rs.getString("carrier"));
                    po.setAsnStatus(rs.getString("asn_status"));
                    po.setHasAsn(true);
                } else {
                    po.setHasAsn(false);
                }

                // ✅ Display status = PO status (not ASN status)
                po.setDisplayStatus(poStatus);
                
                // Status badge based on PO status
                String badgeClass = "badge-secondary";
                switch (poStatus) {
                    case "Completed":
                    case "Paid":
                        badgeClass = "badge-success";
                        break;
                    case "Approved":
                    case "Received":
                        badgeClass = "badge-primary";
                        break;
                    case "Sent":
                        badgeClass = "badge-info";
                        break;
                    case "Draft":
                        badgeClass = "badge-secondary";
                        break;
                    case "Rejected":
                    case "Cancelled":
                        badgeClass = "badge-danger";
                        break;
                }
                po.setStatusBadgeClass(badgeClass);

                list.add(po);
            }
        } catch (SQLException e) {
            System.err.println("Error in getAllPurchaseOrders: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Get purchase order by ID
     */
    public PurchaseOrder getPurchaseOrderById(int poId) {
        String sql = "SELECT "
                + "po.po_id, po.manager_id, po.supplier_id, po.status AS po_status, "
                + "po.order_date, po.expected_delivery_date, po.notes, po.updated_at, "
                + "s.name AS supplier_name, "
                + "u.username AS manager_name, "
                + "asn.asn_id, asn.tracking_number, asn.carrier, asn.status AS asn_status "
                + "FROM PurchaseOrders po "
                + "LEFT JOIN Suppliers s ON po.supplier_id = s.supplier_id "
                + "LEFT JOIN Users u ON po.manager_id = u.user_id "
                + "LEFT JOIN ( "
                + "  SELECT asn.*, "
                + "  ROW_NUMBER() OVER (PARTITION BY asn.po_id ORDER BY asn.created_at DESC) AS rn "
                + "  FROM AdvancedShippingNotices asn "
                + ") asn ON po.po_id = asn.po_id AND asn.rn = 1 "
                + "WHERE po.po_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, poId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                PurchaseOrder po = new PurchaseOrder();

                po.setPoId(rs.getInt("po_id"));
                po.setManagerId(rs.getInt("manager_id"));
                po.setSupplierId(rs.getInt("supplier_id"));
                
                String poStatus = rs.getString("po_status");
                po.setStatus(poStatus);
                
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
                    po.setHasAsn(true);
                }

                po.setDisplayStatus(poStatus);

                return po;
            }
        } catch (SQLException e) {
            System.err.println("Error in getPurchaseOrderById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Get items by PO ID
     */
    public List<PurchaseOrderItem> getItemsByPurchaseOrderId(int poId) {
        List<PurchaseOrderItem> items = new ArrayList<>();
        String sql = "SELECT poi.item_id, poi.po_id, poi.medicine_code, "
                + "poi.quantity, poi.unit_price, poi.priority, poi.notes, "
                + "m.name, m.category, m.strength, m.dosage_form, "
                + "m.manufacturer, m.unit, m.active_ingredient "
                + "FROM PurchaseOrderItems poi "
                + "LEFT JOIN Medicines m ON poi.medicine_code = m.medicine_code "
                + "WHERE poi.po_id = ?";

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

        String sql = "SELECT "
                + "COUNT(*) AS total_orders, "
                + "SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) AS completed_orders, "
                + "SUM(CASE WHEN status IN ('Draft', 'Sent', 'Approved') THEN 1 ELSE 0 END) AS pending_orders, "
                + "ISNULL(SUM(poi.quantity * poi.unit_price), 0) AS total_amount "
                + "FROM PurchaseOrders po "
                + "LEFT JOIN PurchaseOrderItems poi ON po.po_id = poi.po_id";

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
     * ✅ FIXED: Get historical purchase orders - ONLY Completed status
     */
    public List<PurchaseOrder> getHistoricalPurchaseOrders(Integer supplierId,
        Date fromDate, Date toDate, String searchKeyword) {
    List<PurchaseOrder> list = new ArrayList<>();

    StringBuilder sql = new StringBuilder(
            "SELECT "
            + "po.po_id, po.manager_id, po.supplier_id, po.status AS po_status, "
            + "po.order_date, po.expected_delivery_date, po.notes, po.updated_at, "
            + "s.name AS supplier_name, u.username AS manager_name, "
            + "asn.status AS asn_status, "
            + "asn.tracking_number, "
            + "asn.carrier, "
            + "asn.approved_at, "
            + "ISNULL(SUM(poi.quantity * poi.unit_price), 0) AS total_amount, "
            + "COUNT(DISTINCT poi.item_id) AS item_count "
            + "FROM PurchaseOrders po "
            + "LEFT JOIN Suppliers s ON po.supplier_id = s.supplier_id "
            + "LEFT JOIN Users u ON po.manager_id = u.user_id "
            + "LEFT JOIN PurchaseOrderItems poi ON po.po_id = poi.po_id "
            + "LEFT JOIN ( "
            + "  SELECT asn.*, "
            + "  ROW_NUMBER() OVER (PARTITION BY asn.po_id ORDER BY asn.created_at DESC) AS rn "
            + "  FROM AdvancedShippingNotices asn "
            + ") asn ON po.po_id = asn.po_id AND asn.rn = 1 "
            // ✅ CRITICAL: Lấy cả Completed VÀ BatchCreated
            + "WHERE po.status IN ('Completed', 'BatchCreated') "
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
    if (searchKeyword != null && !searchKeyword.isEmpty()) {
        sql.append("AND (s.name LIKE ? OR po.notes LIKE ? OR CAST(po.po_id AS NVARCHAR) LIKE ?) ");
    }

    sql.append("GROUP BY po.po_id, po.manager_id, po.supplier_id, po.status, "
            + "po.order_date, po.expected_delivery_date, po.notes, po.updated_at, "
            + "s.name, u.username, asn.status, asn.tracking_number, asn.carrier, asn.approved_at "
            + "ORDER BY po.order_date DESC");

    System.out.println("====================================");
    System.out.println("DEBUG: Historical PO Query (Completed + BatchCreated)");
    System.out.println("====================================");

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
        int count = 0;
        while (rs.next()) {
            count++;
            PurchaseOrder po = new PurchaseOrder();
            po.setPoId(rs.getInt("po_id"));
            po.setManagerId(rs.getInt("manager_id"));
            po.setSupplierId(rs.getInt("supplier_id"));

            // ✅ Lấy status thật từ DB
            String poStatus = rs.getString("po_status");
            po.setStatus(poStatus);

            po.setOrderDate(rs.getTimestamp("order_date"));
            po.setExpectedDeliveryDate(rs.getDate("expected_delivery_date"));
            po.setNotes(rs.getString("notes"));
            po.setUpdatedAt(rs.getTimestamp("updated_at"));
            po.setSupplierName(rs.getString("supplier_name"));
            po.setManagerName(rs.getString("manager_name"));
            po.setTotalAmount(rs.getDouble("total_amount"));
            po.setItemCount(rs.getInt("item_count"));

            // ASN info (optional)
            String asnStatus = rs.getString("asn_status");
            if (asnStatus != null) {
                po.setAsnStatus(asnStatus);
                po.setTrackingNumber(rs.getString("tracking_number"));
                po.setCarrier(rs.getString("carrier"));
                po.setHasAsn(true);
            } else {
                po.setHasAsn(false);
            }

            // ✅ DISPLAY STATUS: Map BatchCreated -> Completed
            String displayStatus;
            if ("BatchCreated".equals(poStatus)) {
                displayStatus = "Completed";
            } else {
                displayStatus = poStatus; // Completed
            }
            po.setDisplayStatus(displayStatus);
            
            // ✅ Badge luôn là success cho cả 2 trường hợp
            po.setStatusBadgeClass("badge-success");

            System.out.println("PO #" + po.getPoId()
                    + " - Real Status: " + poStatus
                    + " - Display: " + displayStatus
                    + " - ASN: " + asnStatus);

            list.add(po);
        }

        System.out.println("Total historical orders found: " + count);
        System.out.println("====================================");

    } catch (SQLException e) {
        System.err.println("ERROR in getHistoricalPurchaseOrders: " + e.getMessage());
        e.printStackTrace();
    }
    return list;
}

/**
 * ✅ FIXED: Get trend data - Bao gồm cả BatchCreated
 */
public List<Map<String, Object>> getTrendDataByMonth(Integer supplierId, Date fromDate, Date toDate) {
    List<Map<String, Object>> trendData = new ArrayList<>();
    StringBuilder sql = new StringBuilder(
            "SELECT "
            + "YEAR(po.order_date) AS year, "
            + "MONTH(po.order_date) AS month, "
            + "COUNT(po.po_id) AS order_count, "
            + "ISNULL(SUM(poi.quantity * poi.unit_price), 0) AS total_amount "
            + "FROM PurchaseOrders po "
            + "LEFT JOIN PurchaseOrderItems poi ON po.po_id = poi.po_id "
            // ✅ Lấy cả Completed VÀ BatchCreated
            + "WHERE po.status IN ('Completed', 'BatchCreated') "
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

    sql.append("GROUP BY YEAR(po.order_date), MONTH(po.order_date) "
            + "ORDER BY year, month");

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
 * ✅ FIXED: Get supplier performance - Bao gồm cả BatchCreated
 */
public List<Map<String, Object>> getSupplierPerformance(Date fromDate, Date toDate) {
    List<Map<String, Object>> performance = new ArrayList<>();
    StringBuilder sql = new StringBuilder(
            "SELECT "
            + "s.supplier_id, "
            + "s.name AS supplier_name, "
            + "COUNT(po.po_id) AS total_orders, "
            + "COUNT(CASE WHEN po.status IN ('Completed', 'BatchCreated') THEN 1 END) AS completed_orders, "
            + "ISNULL(SUM(poi.quantity * poi.unit_price), 0) AS total_amount, "
            + "AVG(DATEDIFF(day, po.order_date, po.updated_at)) AS avg_delivery_days "
            + "FROM Suppliers s "
            + "LEFT JOIN PurchaseOrders po ON s.supplier_id = po.supplier_id "
            + "LEFT JOIN PurchaseOrderItems poi ON po.po_id = poi.po_id "
            // ✅ Chỉ tính các đơn đã hoàn thành
            + "WHERE po.status IN ('Completed', 'BatchCreated') "
    );

    if (fromDate != null) {
        sql.append("AND po.order_date >= ? ");
    }
    if (toDate != null) {
        sql.append("AND po.order_date <= ? ");
    }

    sql.append("GROUP BY s.supplier_id, s.name "
            + "HAVING COUNT(po.po_id) > 0 "
            + "ORDER BY total_amount DESC");

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
     // 1️⃣ Lấy danh sách các đơn đã giao
public List<PurchaseOrder> getDeliveredOrders() throws SQLException {
    List<PurchaseOrder> list = new ArrayList<>();
    
    String sql = """
        SELECT 
            po.po_id,
            po.status,
            po.order_date,
            po.expected_delivery_date,
            po.supplier_id,
            po.manager_id,
            po.notes,
            s.name AS supplier_name,
            u.username AS manager_name,
            ISNULL(SUM(poi.quantity * poi.unit_price), 0) AS total_amount,
            COUNT(DISTINCT poi.item_id) AS item_count
        FROM PurchaseOrders po
        LEFT JOIN Suppliers s ON po.supplier_id = s.supplier_id
        LEFT JOIN Users u ON po.manager_id = u.user_id
        LEFT JOIN PurchaseOrderItems poi ON po.po_id = poi.po_id
        WHERE po.status = 'Completed'
        GROUP BY po.po_id, po.status, po.order_date, po.expected_delivery_date, 
                 po.supplier_id, po.manager_id, po.notes, s.name, u.username
        ORDER BY po.order_date DESC
    """;

    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        System.out.println("====================================");
        System.out.println("DEBUG: getDeliveredOrders() - Query executed");
        System.out.println("====================================");

        int count = 0;
        while (rs.next()) {
            count++;
            PurchaseOrder po = new PurchaseOrder();
            po.setPoId(rs.getInt("po_id"));
            po.setStatus(rs.getString("status"));
            po.setOrderDate(rs.getTimestamp("order_date"));
            po.setExpectedDeliveryDate(rs.getDate("expected_delivery_date"));
            po.setSupplierId(rs.getInt("supplier_id"));
            po.setManagerId(rs.getInt("manager_id"));
            po.setNotes(rs.getString("notes"));
            po.setSupplierName(rs.getString("supplier_name"));
            po.setManagerName(rs.getString("manager_name"));
            po.setTotalAmount(rs.getDouble("total_amount"));
            po.setItemCount(rs.getInt("item_count"));
            
            // ✅ KHÔNG load items ở đây - sẽ load ở Servlet
            
            System.out.println("Found PO #" + po.getPoId() + 
                             " - Status: " + po.getStatus() + 
                             " - Item count: " + po.getItemCount());
            
            list.add(po);
        }
        
        System.out.println("Total orders found: " + count);
        System.out.println("====================================");
    }
    
    return list;
}
    
   /** 🔹 Lấy thông tin đơn hàng + danh sách item chi tiết */
public PurchaseOrder getOrderWithItems(int poId) throws SQLException {
    PurchaseOrder order = null;

    String sqlOrder = """
        SELECT po.po_id, po.order_date, po.status, po.supplier_id, po.manager_id,
               s.name AS supplier_name, u.username AS manager_name
        FROM PurchaseOrders po
        JOIN Suppliers s ON po.supplier_id = s.supplier_id
        LEFT JOIN Users u ON po.manager_id = u.user_id
        WHERE po.po_id = ?
    """;

    String sqlItems = """
        SELECT poi.item_id, poi.medicine_code, poi.quantity, poi.unit_price,
               m.name AS medicine_name, m.strength, m.dosage_form, 
               m.category, m.active_ingredient
        FROM PurchaseOrderItems poi
        JOIN Medicines m ON poi.medicine_code = m.medicine_code
        WHERE poi.po_id = ?
    """;

    try (Connection conn = getConnection();
         PreparedStatement psOrder = conn.prepareStatement(sqlOrder);
         PreparedStatement psItems = conn.prepareStatement(sqlItems)) {

        // --- 1️⃣ Lấy thông tin đơn hàng ---
        psOrder.setInt(1, poId);
        ResultSet rs = psOrder.executeQuery();

        if (rs.next()) {
            order = new PurchaseOrder();
            order.setPoId(rs.getInt("po_id"));
            order.setOrderDate(rs.getTimestamp("order_date"));
            order.setStatus(rs.getString("status"));
            order.setSupplierId(rs.getInt("supplier_id"));
            order.setSupplierName(rs.getString("supplier_name"));
            order.setManagerName(rs.getString("manager_name"));
        }

        // --- 2️⃣ Lấy danh sách thuốc trong đơn ---
        if (order != null) {
            List<PurchaseOrderItem> items = new ArrayList<>();
            psItems.setInt(1, poId);
            ResultSet rs2 = psItems.executeQuery();

            while (rs2.next()) {
                PurchaseOrderItem item = new PurchaseOrderItem();
                item.setItemId(rs2.getInt("item_id"));
                item.setMedicineCode(rs2.getString("medicine_code"));
                item.setMedicineName(rs2.getString("medicine_name"));
                item.setMedicineStrength(rs2.getString("strength"));
                item.setMedicineDosageForm(rs2.getString("dosage_form"));
                item.setMedicineCategory(rs2.getString("category"));
                item.setActiveIngredient(rs2.getString("active_ingredient"));
                item.setQuantity(rs2.getInt("quantity"));
                item.setUnitPrice(rs2.getDouble("unit_price"));
                items.add(item);
            }

            order.setItems(items);
        }

    } catch (SQLException e) {
        e.printStackTrace();
        throw e;
    }

    return order;
}
    public boolean updateOrderStatusToBatchCreated(int poId) {
        String sql = """
            UPDATE PurchaseOrders 
            SET status = 'BatchCreated', 
                updated_at = GETDATE() 
            WHERE po_id = ? 
            AND status = 'Completed'
        """;
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, poId);
            int result = ps.executeUpdate();
            
            if (result > 0) {
                System.out.println("✅ Đơn hàng #" + poId + " đã chuyển sang trạng thái BatchCreated");
                return true;
            } else {
                System.out.println("⚠️ Đơn hàng #" + poId + " không được cập nhật (có thể không ở trạng thái Completed)");
                return false;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi cập nhật trạng thái đơn hàng: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * ✅ Lấy danh sách đơn hàng đã giao NHƯNG CHƯA TẠO LÔ
     * (status = 'Completed' - chưa chuyển sang 'BatchCreated')
     */
    public List<PurchaseOrder> getDeliveredOrdersNotBatched() {
        List<PurchaseOrder> list = new ArrayList<>();
        String sql = """
            SELECT 
                po.po_id, 
                po.manager_id, 
                po.supplier_id, 
                po.status, 
                po.order_date, 
                po.expected_delivery_date, 
                po.notes,
                s.name AS supplier_name
            FROM PurchaseOrders po
            LEFT JOIN Suppliers s ON po.supplier_id = s.supplier_id
            WHERE po.status = 'Completed'
            ORDER BY po.order_date DESC
        """;
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                PurchaseOrder order = new PurchaseOrder();
                order.setPoId(rs.getInt("po_id"));
                order.setManagerId(rs.getInt("manager_id"));
                order.setSupplierId(rs.getInt("supplier_id"));
                order.setStatus(rs.getString("status"));
                order.setOrderDate(rs.getTimestamp("order_date"));
                order.setExpectedDeliveryDate(rs.getDate("expected_delivery_date"));
                order.setNotes(rs.getString("notes"));
                order.setSupplierName(rs.getString("supplier_name"));
                list.add(order);
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi lấy danh sách đơn hàng chưa tạo lô: " + e.getMessage());
            e.printStackTrace();
        }
        
        return list;
    }

    /**
     * ✅ Kiểm tra xem đơn hàng đã tạo lô chưa
     */
    public boolean hasOrderCreatedBatches(int poId) {
        String sql = """
            SELECT COUNT(*) AS batch_count 
            FROM Batches 
            WHERE quarantine_notes LIKE ?
        """;
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, "%Lô từ đơn hàng #" + poId + "%");
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                int count = rs.getInt("batch_count");
                return count > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
}
