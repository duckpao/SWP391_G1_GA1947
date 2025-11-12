package DAO;

import model.AdvancedShippingNotice;
import model.ASNItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ASNDAO extends DBContext {

    // ==================== CREATE ASN WITH STATUS ====================
    public int createASNWithStatus(int poId, int supplierId, Date shipmentDate,
            String carrier, String trackingNumber, String notes,
            String submittedBy, String initialStatus) {
        String sql = "INSERT INTO AdvancedShippingNotices "
                + "(po_id, supplier_id, shipment_date, carrier, tracking_number, "
                + "status, notes, submitted_by, submitted_at, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE(), GETDATE())";

        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, poId);
            ps.setInt(2, supplierId);
            ps.setDate(3, shipmentDate);
            ps.setString(4, carrier);
            ps.setString(5, trackingNumber);
            ps.setString(6, initialStatus != null ? initialStatus : "Pending");
            ps.setString(7, notes);
            ps.setString(8, submittedBy);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int asnId = generatedKeys.getInt(1);

                    // Copy items from PO to ASN
                    if (copyPOItemsToASN(poId, asnId)) {
                        return asnId;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in createASNWithStatus: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    // ==================== COPY PO ITEMS TO ASN ====================
    private boolean copyPOItemsToASN(int poId, int asnId) {
        String sql = "INSERT INTO ASNItems (asn_id, medicine_code, quantity, lot_number) "
                + "SELECT ?, medicine_code, quantity, NULL "
                + "FROM PurchaseOrderItems "
                + "WHERE po_id = ?";

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

    // ==================== CHECK IF ASN EXISTS FOR PO ====================
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

    // ==================== GET ASNs BY SUPPLIER ====================
    public List<AdvancedShippingNotice> getASNsBySupplier(int supplierId) {
        List<AdvancedShippingNotice> asns = new ArrayList<>();
        String sql = "SELECT asn.asn_id, asn.po_id, asn.supplier_id, asn.shipment_date, "
                + "asn.carrier, asn.tracking_number, asn.status, asn.notes, "
                + "asn.submitted_by, asn.approved_by, asn.submitted_at, asn.approved_at, "
                + "asn.rejection_reason, asn.created_at, asn.updated_at, "
                + "po.status as po_status, s.name as supplier_name "
                + "FROM AdvancedShippingNotices asn "
                + "LEFT JOIN PurchaseOrders po ON asn.po_id = po.po_id "
                + "LEFT JOIN Suppliers s ON asn.supplier_id = s.supplier_id "
                + "WHERE asn.supplier_id = ? "
                + "ORDER BY asn.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                AdvancedShippingNotice asn = mapResultSetToASN(rs);
                asn.setItems(getASNItems(asn.getAsnId()));
                asns.add(asn);
            }
        } catch (SQLException e) {
            System.err.println("Error in getASNsBySupplier: " + e.getMessage());
            e.printStackTrace();
        }
        return asns;
    }

    // ==================== GET ASNs BY STATUS ====================
    public List<AdvancedShippingNotice> getASNsByStatus(int supplierId, String status) {
        List<AdvancedShippingNotice> asns = new ArrayList<>();
        String sql = "SELECT asn.asn_id, asn.po_id, asn.supplier_id, asn.shipment_date, "
                + "asn.carrier, asn.tracking_number, asn.status, asn.notes, "
                + "asn.submitted_by, asn.approved_by, asn.submitted_at, asn.approved_at, "
                + "asn.rejection_reason, asn.created_at, asn.updated_at, "
                + "po.status as po_status, s.name as supplier_name "
                + "FROM AdvancedShippingNotices asn "
                + "LEFT JOIN PurchaseOrders po ON asn.po_id = po.po_id "
                + "LEFT JOIN Suppliers s ON asn.supplier_id = s.supplier_id "
                + "WHERE asn.supplier_id = ? AND asn.status = ? "
                + "ORDER BY asn.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                AdvancedShippingNotice asn = mapResultSetToASN(rs);
                asn.setItems(getASNItems(asn.getAsnId()));
                asns.add(asn);
            }
        } catch (SQLException e) {
            System.err.println("Error in getASNsByStatus: " + e.getMessage());
            e.printStackTrace();
        }
        return asns;
    }

    // ==================== GET ASN BY ID ====================
    public AdvancedShippingNotice getASNById(int asnId) {
        String sql = "SELECT asn.asn_id, asn.po_id, asn.supplier_id, asn.shipment_date, "
                + "asn.carrier, asn.tracking_number, asn.status, asn.notes, "
                + "asn.submitted_by, asn.approved_by, asn.submitted_at, asn.approved_at, "
                + "asn.rejection_reason, asn.created_at, asn.updated_at, "
                + "po.status as po_status, s.name as supplier_name "
                + "FROM AdvancedShippingNotices asn "
                + "LEFT JOIN PurchaseOrders po ON asn.po_id = po.po_id "
                + "LEFT JOIN Suppliers s ON asn.supplier_id = s.supplier_id "
                + "WHERE asn.asn_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, asnId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                AdvancedShippingNotice asn = mapResultSetToASN(rs);
                asn.setItems(getASNItems(asn.getAsnId()));
                return asn;
            }
        } catch (SQLException e) {
            System.err.println("Error in getASNById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // ==================== GET ASN ITEMS ====================
    public List<ASNItem> getASNItems(int asnId) {
        List<ASNItem> items = new ArrayList<>();
        String sql = "SELECT ai.item_id, ai.asn_id, ai.medicine_code, ai.quantity, ai.lot_number, "
                + "m.name as medicine_name, m.strength, m.unit, m.category "
                + "FROM ASNItems ai "
                + "LEFT JOIN Medicines m ON ai.medicine_code = m.medicine_code "
                + "WHERE ai.asn_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, asnId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ASNItem item = new ASNItem();
                item.setItemId(rs.getInt("item_id"));
                item.setAsnId(rs.getInt("asn_id"));
                item.setMedicineCode(rs.getString("medicine_code"));
                item.setQuantity(rs.getInt("quantity"));
                item.setLotNumber(rs.getString("lot_number"));
                item.setMedicineName(rs.getString("medicine_name"));
                item.setStrength(rs.getString("strength"));
                item.setUnit(rs.getString("unit"));
                items.add(item);
            }
        } catch (SQLException e) {
            System.err.println("Error in getASNItems: " + e.getMessage());
            e.printStackTrace();
        }
        return items;
    }

    // ==================== UPDATE ASN STATUS ====================
    public boolean updateASNStatus(int asnId, String newStatus) {
        String sql = "UPDATE AdvancedShippingNotices "
                + "SET status = ?, updated_at = GETDATE() "
                + "WHERE asn_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, asnId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error in updateASNStatus: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // ==================== UPDATE TRACKING INFO ====================
    public boolean updateTrackingInfo(int asnId, String carrier, String trackingNumber) {
        String sql = "UPDATE AdvancedShippingNotices "
                + "SET carrier = ?, tracking_number = ?, updated_at = GETDATE() "
                + "WHERE asn_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, carrier);
            ps.setString(2, trackingNumber);
            ps.setInt(3, asnId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error in updateTrackingInfo: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // ==================== MARK AS SHIPPED (Pending -> Sent) ====================
    public boolean markAsShipped(int asnId) {
        return updateASNStatus(asnId, "Sent");
    }

    // ==================== MARK AS IN TRANSIT (Sent -> InTransit) ====================
    public boolean markAsInTransit(int asnId) {
        return updateASNStatus(asnId, "InTransit");
    }

    // ==================== CANCEL ASN ====================
    public boolean cancelASN(int asnId, String reason) {
        String sql = "UPDATE AdvancedShippingNotices "
                + "SET status = 'Cancelled', rejection_reason = ?, updated_at = GETDATE() "
                + "WHERE asn_id = ? AND status IN ('Pending', 'Sent')";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, reason);
            ps.setInt(2, asnId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error in cancelASN: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // ==================== GET ASN STATISTICS ====================
    public Map<String, Integer> getASNStatsBySupplier(int supplierId) {
        Map<String, Integer> stats = new HashMap<>();
        String sql = "SELECT "
                + "COUNT(CASE WHEN status = 'Pending' THEN 1 END) as pending_count, "
                + "COUNT(CASE WHEN status = 'Sent' THEN 1 END) as sent_count, "
                + "COUNT(CASE WHEN status = 'InTransit' THEN 1 END) as in_transit_count, "
                + "COUNT(CASE WHEN status = 'Delivered' THEN 1 END) as delivered_count, "
                + "COUNT(CASE WHEN status = 'Rejected' THEN 1 END) as rejected_count, "
                + "COUNT(*) as total_count "
                + "FROM AdvancedShippingNotices "
                + "WHERE supplier_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                stats.put("pendingCount", rs.getInt("pending_count"));
                stats.put("sentCount", rs.getInt("sent_count"));
                stats.put("inTransitCount", rs.getInt("in_transit_count"));
                stats.put("deliveredCount", rs.getInt("delivered_count"));
                stats.put("rejectedCount", rs.getInt("rejected_count"));
                stats.put("totalCount", rs.getInt("total_count"));
            }
        } catch (SQLException e) {
            System.err.println("Error in getASNStatsBySupplier: " + e.getMessage());
            e.printStackTrace();
        }
        return stats;
    }

    // ==================== HELPER: MAP RESULTSET TO ASN ====================
    private AdvancedShippingNotice mapResultSetToASN(ResultSet rs) throws SQLException {
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

        Timestamp submittedAt = rs.getTimestamp("submitted_at");
        if (submittedAt != null) {
            asn.setSubmittedAt(submittedAt);
        }

        Timestamp approvedAt = rs.getTimestamp("approved_at");
        if (approvedAt != null) {
            asn.setApprovedAt(approvedAt);
        }

        asn.setRejectionReason(rs.getString("rejection_reason"));
        asn.setCreatedAt(rs.getTimestamp("created_at"));
        asn.setUpdatedAt(rs.getTimestamp("updated_at"));
        asn.setPoStatus(rs.getString("po_status"));
        asn.setSupplierName(rs.getString("supplier_name"));

        return asn;
    }

    /**
     * Get all ASNs with InTransit status for Manager
     */
    public List<AdvancedShippingNotice> getInTransitASNs() {
        List<AdvancedShippingNotice> asns = new ArrayList<>();
        String sql = "SELECT asn.asn_id, asn.po_id, asn.supplier_id, asn.shipment_date, "
                + "asn.carrier, asn.tracking_number, asn.status, asn.notes, "
                + "asn.submitted_by, asn.approved_by, asn.submitted_at, asn.approved_at, "
                + "asn.rejection_reason, asn.created_at, asn.updated_at, "
                + "po.status as po_status, po.expected_delivery_date, "
                + "s.name as supplier_name, "
                + "COUNT(DISTINCT ai.item_id) AS total_items, "
                + "SUM(ai.quantity) AS total_quantity "
                + "FROM AdvancedShippingNotices asn "
                + "LEFT JOIN PurchaseOrders po ON asn.po_id = po.po_id "
                + "LEFT JOIN Suppliers s ON asn.supplier_id = s.supplier_id "
                + "LEFT JOIN ASNItems ai ON asn.asn_id = ai.asn_id "
                + "WHERE asn.status = 'InTransit' "
                + "GROUP BY asn.asn_id, asn.po_id, asn.supplier_id, asn.shipment_date, "
                + "asn.carrier, asn.tracking_number, asn.status, asn.notes, "
                + "asn.submitted_by, asn.approved_by, asn.submitted_at, asn.approved_at, "
                + "asn.rejection_reason, asn.created_at, asn.updated_at, "
                + "po.status, po.expected_delivery_date, s.name "
                + "ORDER BY asn.shipment_date DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                AdvancedShippingNotice asn = mapResultSetToASN(rs);
                asn.setTotalItems(rs.getInt("total_items"));
                asn.setTotalQuantity(rs.getInt("total_quantity"));
                asn.setExpectedDeliveryDate(rs.getDate("expected_delivery_date"));
                asns.add(asn);
            }
        } catch (SQLException e) {
            System.err.println("Error in getInTransitASNs: " + e.getMessage());
            e.printStackTrace();
        }
        return asns;
    }

    /**
     * Confirm delivery - Update ASN status to Delivered
     */
    public boolean confirmDelivery(int asnId, int managerId) {
        String sql = "UPDATE AdvancedShippingNotices "
                + "SET status = 'Delivered', "
                + "    approved_by = (SELECT username FROM Users WHERE user_id = ?), "
                + "    approved_at = GETDATE(), "
                + "    updated_at = GETDATE() "
                + "WHERE asn_id = ? AND status = 'InTransit'";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, managerId);
            ps.setInt(2, asnId);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                System.out.println("✅ ASN #" + asnId + " confirmed as Delivered by Manager #" + managerId);
                return true;
            } else {
                System.out.println("⚠️ No rows updated. ASN might not be in InTransit status.");
            }
        } catch (SQLException e) {
            System.err.println("Error in confirmDelivery: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Create Delivery Note after confirmation
     */
    public int createDeliveryNote(int asnId, int poId, int managerId, String notes) {
        String sql = "INSERT INTO DeliveryNotes (asn_id, po_id, delivery_date, received_by, status, notes) "
                + "VALUES (?, ?, GETDATE(), ?, 'Complete', ?)";

        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, asnId);
            ps.setInt(2, poId);
            ps.setInt(3, managerId);
            ps.setString(4, notes != null ? notes : "Confirmed by Manager");

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int dnId = generatedKeys.getInt(1);
                    System.out.println("✅ Delivery Note #" + dnId + " created for ASN #" + asnId);
                    return dnId;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in createDeliveryNote: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }

    /**
     * Process payment - Update PO and Invoice status to Completed/Paid
     */
    public boolean processPayment(int asnId, int poId, int managerId) {
        try {
            connection.setAutoCommit(false);

            // 1. Update PO status to Completed
            String updatePOSql = "UPDATE PurchaseOrders SET status = 'Completed', updated_at = GETDATE() "
                    + "WHERE po_id = ?";
            try (PreparedStatement ps1 = connection.prepareStatement(updatePOSql)) {
                ps1.setInt(1, poId);
                ps1.executeUpdate();
            }

            // 2. Update Invoice status to Paid (if exists)
            String updateInvoiceSql = "UPDATE Invoices SET status = 'Paid', updated_at = GETDATE() "
                    + "WHERE asn_id = ?";
            try (PreparedStatement ps2 = connection.prepareStatement(updateInvoiceSql)) {
                ps2.setInt(1, asnId);
                ps2.executeUpdate();
            }

            // 3. Log to SystemLogs
            String logSql = "INSERT INTO SystemLogs (user_id, action, table_name, record_id, details, log_date) "
                    + "VALUES (?, 'PAYMENT_COMPLETED', 'PurchaseOrders', ?, ?, GETDATE())";
            try (PreparedStatement ps3 = connection.prepareStatement(logSql)) {
                ps3.setInt(1, managerId);
                ps3.setInt(2, poId);
                ps3.setString(3, "Payment completed for PO #" + poId + ", ASN #" + asnId);
                ps3.executeUpdate();
            }

            connection.commit();
            System.out.println("✅ Payment processed successfully for PO #" + poId);
            return true;

        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            System.err.println("Error in processPayment: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    public int getPoIdByAsnId(int asnId) {
        String sql = "SELECT po_id FROM AdvancedShippingNotices WHERE asn_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, asnId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("po_id");
            }
        } catch (SQLException e) {
            System.err.println("Error in getPoIdByAsnId: " + e.getMessage());
            e.printStackTrace();
        }
        return -1;
    }
    public boolean updatePOStatus(int poId, String status) {
    String sql = "UPDATE PurchaseOrders SET status = ?, updated_at = GETDATE() WHERE po_id = ?";
    
    try (Connection conn = DBContext.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        
        pstmt.setString(1, status);
        pstmt.setInt(2, poId);
        
        int affected = pstmt.executeUpdate();
        System.out.println("✅ Updated PO #" + poId + " to status: " + status);
        
        return affected > 0;
        
    } catch (SQLException e) {
        System.err.println("Error updating PO status: " + e.getMessage());
        e.printStackTrace();
    }
    
    return false;
}


    // Thêm các methods này vào class ASNDAO của bạn
    /**
     * Get invoice amount for payment
     */
    public double getInvoiceAmount(int asnId, int poId) {
        String sql = "SELECT ISNULL(SUM(poi.quantity * poi.unit_price), 0) AS total_amount "
                + "FROM PurchaseOrderItems poi WHERE poi.po_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, poId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                double amount = rs.getDouble("total_amount");
                System.out.println("Invoice amount for PO #" + poId + ": " + amount);
                return amount;
            }

        } catch (SQLException e) {
            System.err.println("Error getting invoice amount: " + e.getMessage());
            e.printStackTrace();
        }

        return 0.0;
    }

    /**
     * Update payment status after VNPay payment
     */
    public boolean updatePaymentStatus(Integer asnId, Integer poId, String transactionNo,
            String txnRef, int userId) {
        if (asnId == null || poId == null) {
            System.err.println("ASN ID or PO ID is null!");
            return false;
        }

        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            // 1. Check if Invoice exists, if not create it
            String checkInvoiceSql = "SELECT invoice_id FROM Invoices "
                    + "WHERE asn_id = ? AND po_id = ?";
            int invoiceId = 0;

            try (PreparedStatement ps = conn.prepareStatement(checkInvoiceSql)) {
                ps.setInt(1, asnId);
                ps.setInt(2, poId);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    invoiceId = rs.getInt("invoice_id");
                    System.out.println("Found existing invoice: #" + invoiceId);
                } else {
                    // Create invoice if not exists
                    invoiceId = createInvoiceForPayment(conn, asnId, poId);
                    System.out.println("Created new invoice: #" + invoiceId);
                }
            }

            if (invoiceId == 0) {
                System.err.println("Failed to get or create invoice!");
                conn.rollback();
                return false;
            }

            // 2. Update Invoice to Paid
            String updateInvoiceSql = "UPDATE Invoices SET status = 'Paid', "
                    + "notes = CONCAT(ISNULL(notes, ''), ' | VNPay: ', ?, ' | Ref: ', ?), "
                    + "updated_at = GETDATE() WHERE invoice_id = ?";

            try (PreparedStatement ps = conn.prepareStatement(updateInvoiceSql)) {
                ps.setString(1, transactionNo);
                ps.setString(2, txnRef);
                ps.setInt(3, invoiceId);
                int rows = ps.executeUpdate();
                System.out.println("Updated Invoice: " + rows + " row(s)");
            }

            // 3. Update PurchaseOrder to Completed
            String updatePoSql = "UPDATE PurchaseOrders SET status = 'Completed', "
                    + "updated_at = GETDATE() WHERE po_id = ?";

            try (PreparedStatement ps = conn.prepareStatement(updatePoSql)) {
                ps.setInt(1, poId);
                int rows = ps.executeUpdate();
                System.out.println("Updated PurchaseOrder: " + rows + " row(s)");
            }

            // 4. Log to SystemLogs
            String logSql = "INSERT INTO SystemLogs (user_id, action, table_name, record_id, "
                    + "details, ip_address, log_date) "
                    + "VALUES (?, 'PAYMENT', 'Invoices', ?, ?, '127.0.0.1', GETDATE())";

            try (PreparedStatement ps = conn.prepareStatement(logSql)) {
                ps.setInt(1, userId);
                ps.setInt(2, invoiceId);
                ps.setString(3, String.format("VNPay payment. TxnNo: %s, Ref: %s, PO: %d",
                        transactionNo, txnRef, poId));
                ps.executeUpdate();
            }

            conn.commit();
            System.out.println("✅ Payment update committed successfully!");
            return true;

        } catch (SQLException e) {
            System.err.println("❌ Error updating payment status:");
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    /**
     * Create invoice for payment if not exists
     */
    private int createInvoiceForPayment(Connection conn, int asnId, int poId)
            throws SQLException {

        // Get supplier ID
        String getSupplierSql = "SELECT supplier_id FROM AdvancedShippingNotices WHERE asn_id = ?";
        int supplierId = 0;

        try (PreparedStatement ps = conn.prepareStatement(getSupplierSql)) {
            ps.setInt(1, asnId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                supplierId = rs.getInt("supplier_id");
            }
        }

        // Calculate total amount
        String calcSql = "SELECT ISNULL(SUM(quantity * unit_price), 0) AS total "
                + "FROM PurchaseOrderItems WHERE po_id = ?";
        double amount = 0.0;

        try (PreparedStatement ps = conn.prepareStatement(calcSql)) {
            ps.setInt(1, poId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                amount = rs.getDouble("total");
            }
        }

        // Insert invoice
        String insertSql = "INSERT INTO Invoices "
                + "(po_id, asn_id, supplier_id, invoice_number, invoice_date, "
                + "amount, status, notes) "
                + "VALUES (?, ?, ?, ?, GETDATE(), ?, 'Pending', ?)";

        String invoiceNumber = "INV" + System.currentTimeMillis();

        try (PreparedStatement ps = conn.prepareStatement(insertSql,
                PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, poId);
            ps.setInt(2, asnId);
            ps.setInt(3, supplierId);
            ps.setString(4, invoiceNumber);
            ps.setDouble(5, amount);
            ps.setString(6, "Auto-created for VNPay payment");

            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        return 0;
    }
    
    
    public boolean updatePaymentStatus(int asnId, int poId, String transactionNo, 
                                   String txnRef, int userId) {
    String updateInvoice = "UPDATE Invoices SET status = 'Paid', " +
                          "notes = CONCAT(COALESCE(notes, ''), CHAR(13) + CHAR(10), " +
                          "'Payment completed via VNPay', CHAR(13) + CHAR(10), " +
                          "'Transaction No: ', ?, CHAR(13) + CHAR(10), " +
                          "'TxnRef: ', ?), " +
                          "updated_at = GETDATE() " +
                          "WHERE asn_id = ? AND po_id = ?";
    
    try (PreparedStatement ps = connection.prepareStatement(updateInvoice)) {
        ps.setString(1, transactionNo);
        ps.setString(2, txnRef);
        ps.setInt(3, asnId);
        ps.setInt(4, poId);
        
        int rows = ps.executeUpdate();
        
        if (rows > 0) {
            System.out.println("✅ Invoice updated for ASN #" + asnId + ", PO #" + poId);
            
            // Log payment action
            logPaymentAction(userId, poId, asnId, transactionNo);
            
            return true;
        }
        
        System.err.println("⚠️ No invoice found for ASN #" + asnId + ", PO #" + poId);
        return false;
        
    } catch (SQLException e) {
        System.err.println("Error updating payment status: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}

/**
 * Log payment action to SystemLogs
 */
private void logPaymentAction(int userId, int poId, int asnId, String transactionNo) {
    String sql = "INSERT INTO SystemLogs (user_id, action, table_name, record_id, details, ip_address, log_date) " +
                 "VALUES (?, 'PAYMENT_COMPLETE', 'Invoices', ?, ?, '0.0.0.0', GETDATE())";
    
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, userId);
        ps.setInt(2, poId);
        ps.setString(3, "Payment completed for PO #" + poId + 
                        ", ASN #" + asnId + 
                        ", Transaction: " + transactionNo);
        ps.executeUpdate();
    } catch (SQLException e) {
        System.err.println("Error logging payment: " + e.getMessage());
    }
}
}
