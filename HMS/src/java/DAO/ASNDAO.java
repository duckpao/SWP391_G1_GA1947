package DAO;

import model.ASN;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ASNDAO extends DBContext{
    
    public ASNDAO() {
        
    }
    
  
    // Get all ASNs
    public List<ASN> getAllASNs() throws SQLException {
        List<ASN> asns = new ArrayList<>();
        String sql = "SELECT * FROM AdvancedShippingNotices ORDER BY created_at DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                asns.add(mapResultSetToASN(rs));
            }
        }
        return asns;
    }

    // Get ASN by ID
    public Optional<ASN> getASNById(int asnId) throws SQLException {
        String sql = "SELECT * FROM AdvancedShippingNotices WHERE asn_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, asnId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToASN(rs));
                }
            }
        }
        return Optional.empty();
    }

    // Get ASNs by Supplier ID
    public List<ASN> getASNsBySupplierId(int supplierId) throws SQLException {
        List<ASN> asns = new ArrayList<>();
        String sql = "SELECT * FROM AdvancedShippingNotices WHERE supplier_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, supplierId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    asns.add(mapResultSetToASN(rs));
                }
            }
        }
        return asns;
    }

    // Get ASNs by Status
    public List<ASN> getASNsByStatus(String status) throws SQLException {
        List<ASN> asns = new ArrayList<>();
        String sql = "SELECT * FROM AdvancedShippingNotices WHERE status = ? ORDER BY created_at DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    asns.add(mapResultSetToASN(rs));
                }
            }
        }
        return asns;
    }

    // Get ASNs pending approval
    public List<ASN> getPendingApprovalASNs() throws SQLException {
        return getASNsByStatus("PENDING_APPROVAL");
    }

    // Add new ASN
    public boolean addASN(ASN asn) throws SQLException {
        String sql = "INSERT INTO AdvancedShippingNotices (po_id, supplier_id, shipment_date, carrier, tracking_number, status, notes, created_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, asn.getPoId());
            stmt.setInt(2, asn.getSupplierId());
            stmt.setDate(3, Date.valueOf(asn.getShipmentDate()));
            stmt.setString(4, asn.getCarrier());
            stmt.setString(5, asn.getTrackingNumber());
            stmt.setString(6, asn.getStatus());
            stmt.setString(7, asn.getNotes());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        asn.setAsnId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
        }
        return false;
    }

    // Update ASN
    public boolean updateASN(ASN asn) throws SQLException {
        String sql = "UPDATE AdvancedShippingNotices SET po_id = ?, supplier_id = ?, shipment_date = ?, carrier = ?, tracking_number = ?, status = ?, notes = ?, updated_at = GETDATE() " +
                    "WHERE asn_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, asn.getPoId());
            stmt.setInt(2, asn.getSupplierId());
            stmt.setDate(3, Date.valueOf(asn.getShipmentDate()));
            stmt.setString(4, asn.getCarrier());
            stmt.setString(5, asn.getTrackingNumber());
            stmt.setString(6, asn.getStatus());
            stmt.setString(7, asn.getNotes());
            stmt.setInt(8, asn.getAsnId());
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }

    // Submit ASN for approval
    public boolean submitForApproval(int asnId, String submittedBy) throws SQLException {
        String sql = "UPDATE AdvancedShippingNotices SET status = 'PENDING_APPROVAL', submitted_by = ?, submitted_at = GETDATE(), updated_at = GETDATE() WHERE asn_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, submittedBy);
            stmt.setInt(2, asnId);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }

    // Approve ASN
    public boolean approveASN(int asnId, String approvedBy) throws SQLException {
        String sql = "UPDATE AdvancedShippingNotices SET status = 'APPROVED', approved_by = ?, approved_at = GETDATE(), updated_at = GETDATE() WHERE asn_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, approvedBy);
            stmt.setInt(2, asnId);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }

    // Reject ASN
    public boolean rejectASN(int asnId, String rejectedBy, String rejectionReason) throws SQLException {
        String sql = "UPDATE AdvancedShippingNotices SET status = 'REJECTED', approved_by = ?, rejection_reason = ?, updated_at = GETDATE() WHERE asn_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, rejectedBy);
            stmt.setString(2, rejectionReason);
            stmt.setInt(3, asnId);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }

    // Update ASN status
    public boolean updateASNStatus(int asnId, String status) throws SQLException {
        String sql = "UPDATE AdvancedShippingNotices SET status = ?, updated_at = GETDATE() WHERE asn_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, asnId);
            
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }

    // Delete ASN
    public boolean deleteASN(int asnId) throws SQLException {
        String sql = "DELETE FROM AdvancedShippingNotices WHERE asn_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, asnId);
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }

    // Helper method to map ResultSet to ASN object
    private ASN mapResultSetToASN(ResultSet rs) throws SQLException {
        ASN asn = new ASN();
        asn.setAsnId(rs.getInt("asn_id"));
        asn.setPoId(rs.getInt("po_id"));
        asn.setSupplierId(rs.getInt("supplier_id"));
        
        Date shipmentDate = rs.getDate("shipment_date");
        if (shipmentDate != null) {
            asn.setShipmentDate(shipmentDate.toLocalDate());
        }
        
        asn.setCarrier(rs.getString("carrier"));
        asn.setTrackingNumber(rs.getString("tracking_number"));
        asn.setStatus(rs.getString("status"));
        asn.setNotes(rs.getString("notes"));
        asn.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
        
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            asn.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        // Các trường workflow
        asn.setSubmittedBy(rs.getString("submitted_by"));
        asn.setApprovedBy(rs.getString("approved_by"));
        
        Timestamp submittedAt = rs.getTimestamp("submitted_at");
        if (submittedAt != null) {
            asn.setSubmittedAt(submittedAt.toLocalDateTime());
        }
        
        Timestamp approvedAt = rs.getTimestamp("approved_at");
        if (approvedAt != null) {
            asn.setApprovedAt(approvedAt.toLocalDateTime());
        }
        
        asn.setRejectionReason(rs.getString("rejection_reason"));
        
        return asn;
    }
}