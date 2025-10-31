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
        String sql = "INSERT INTO AdvancedShippingNotices " +
                     "(po_id, supplier_id, shipment_date, carrier, tracking_number, " +
                     "status, notes, submitted_by, submitted_at, created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE(), GETDATE())";

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
        String sql = "SELECT asn.asn_id, asn.po_id, asn.supplier_id, asn.shipment_date, " +
                     "asn.carrier, asn.tracking_number, asn.status, asn.notes, " +
                     "asn.submitted_by, asn.approved_by, asn.submitted_at, asn.approved_at, " +
                     "asn.rejection_reason, asn.created_at, asn.updated_at, " +
                     "po.status as po_status, s.name as supplier_name " +
                     "FROM AdvancedShippingNotices asn " +
                     "LEFT JOIN PurchaseOrders po ON asn.po_id = po.po_id " +
                     "LEFT JOIN Suppliers s ON asn.supplier_id = s.supplier_id " +
                     "WHERE asn.supplier_id = ? " +
                     "ORDER BY asn.created_at DESC";

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
        String sql = "SELECT asn.asn_id, asn.po_id, asn.supplier_id, asn.shipment_date, " +
                     "asn.carrier, asn.tracking_number, asn.status, asn.notes, " +
                     "asn.submitted_by, asn.approved_by, asn.submitted_at, asn.approved_at, " +
                     "asn.rejection_reason, asn.created_at, asn.updated_at, " +
                     "po.status as po_status, s.name as supplier_name " +
                     "FROM AdvancedShippingNotices asn " +
                     "LEFT JOIN PurchaseOrders po ON asn.po_id = po.po_id " +
                     "LEFT JOIN Suppliers s ON asn.supplier_id = s.supplier_id " +
                     "WHERE asn.supplier_id = ? AND asn.status = ? " +
                     "ORDER BY asn.created_at DESC";

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
        String sql = "SELECT asn.asn_id, asn.po_id, asn.supplier_id, asn.shipment_date, " +
                     "asn.carrier, asn.tracking_number, asn.status, asn.notes, " +
                     "asn.submitted_by, asn.approved_by, asn.submitted_at, asn.approved_at, " +
                     "asn.rejection_reason, asn.created_at, asn.updated_at, " +
                     "po.status as po_status, s.name as supplier_name " +
                     "FROM AdvancedShippingNotices asn " +
                     "LEFT JOIN PurchaseOrders po ON asn.po_id = po.po_id " +
                     "LEFT JOIN Suppliers s ON asn.supplier_id = s.supplier_id " +
                     "WHERE asn.asn_id = ?";

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
        String sql = "SELECT ai.item_id, ai.asn_id, ai.medicine_code, ai.quantity, ai.lot_number, " +
                     "m.name as medicine_name, m.strength, m.unit, m.category " +
                     "FROM ASNItems ai " +
                     "LEFT JOIN Medicines m ON ai.medicine_code = m.medicine_code " +
                     "WHERE ai.asn_id = ?";

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
        String sql = "UPDATE AdvancedShippingNotices " +
                     "SET status = ?, updated_at = GETDATE() " +
                     "WHERE asn_id = ?";

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
        String sql = "UPDATE AdvancedShippingNotices " +
                     "SET carrier = ?, tracking_number = ?, updated_at = GETDATE() " +
                     "WHERE asn_id = ?";

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
        String sql = "UPDATE AdvancedShippingNotices " +
                     "SET status = 'Cancelled', rejection_reason = ?, updated_at = GETDATE() " +
                     "WHERE asn_id = ? AND status IN ('Pending', 'Sent')";

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
        String sql = "SELECT " +
                     "COUNT(CASE WHEN status = 'Pending' THEN 1 END) as pending_count, " +
                     "COUNT(CASE WHEN status = 'Sent' THEN 1 END) as sent_count, " +
                     "COUNT(CASE WHEN status = 'InTransit' THEN 1 END) as in_transit_count, " +
                     "COUNT(CASE WHEN status = 'Delivered' THEN 1 END) as delivered_count, " +
                     "COUNT(CASE WHEN status = 'Rejected' THEN 1 END) as rejected_count, " +
                     "COUNT(*) as total_count " +
                     "FROM AdvancedShippingNotices " +
                     "WHERE supplier_id = ?";

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
}