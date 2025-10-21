package DAO;
import model.ASN;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ASNDAO extends DBContext {

    public List<ASN> getAllASNs() throws SQLException {
        String sql = "SELECT * FROM AdvancedShippingNotices ORDER BY created_at DESC";
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<ASN> list = new ArrayList<>();
            while (rs.next()) list.add(map(rs));
            return list;
        }
    }

    public Optional<ASN> getASNById(int id) throws SQLException {
        String sql = "SELECT * FROM AdvancedShippingNotices WHERE asn_id = ?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(map(rs));
            }
        }
        return Optional.empty();
    }

    public List<ASN> getASNsBySupplierId(int sid) throws SQLException {
        String sql = "SELECT * FROM AdvancedShippingNotices WHERE supplier_id = ? ORDER BY created_at DESC";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, sid);
            try (ResultSet rs = ps.executeQuery()) {
                List<ASN> list = new ArrayList<>();
                while (rs.next()) list.add(map(rs));
                return list;
            }
        }
    }

    public List<ASN> getASNsByStatus(String status) throws SQLException {
        String sql = "SELECT * FROM AdvancedShippingNotices WHERE status = ? ORDER BY created_at DESC";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                List<ASN> list = new ArrayList<>();
                while (rs.next()) list.add(map(rs));
                return list;
            }
        }
    }

    public List<ASN> getPendingApprovalASNs() throws SQLException {
        return getASNsByStatus("PENDING_APPROVAL");
    }

    public boolean addASN(ASN a) throws SQLException {
        String sql = """
            INSERT INTO AdvancedShippingNotices 
            (po_id, supplier_id, shipment_date, carrier, tracking_number, status, notes, created_at, updated_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())
            """;
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, a.getPoId());
            ps.setInt(2, a.getSupplierId());
            ps.setDate(3, Date.valueOf(a.getShipmentDate()));
            ps.setString(4, a.getCarrier());
            ps.setString(5, a.getTrackingNumber());
            ps.setString(6, a.getStatus());
            ps.setString(7, a.getNotes());
            if (ps.executeUpdate() > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) a.setAsnId(rs.getInt(1));
                }
                return true;
            }
        }
        return false;
    }

    public boolean updateASN(ASN a) throws SQLException {
        String sql = """
            UPDATE AdvancedShippingNotices SET po_id=?, shipment_date=?, carrier=?, tracking_number=?, status=?, notes=?, updated_at=GETDATE()
            WHERE asn_id=?
            """;
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, a.getPoId());
            ps.setDate(2, Date.valueOf(a.getShipmentDate()));
            ps.setString(3, a.getCarrier());
            ps.setString(4, a.getTrackingNumber());
            ps.setString(5, a.getStatus());
            ps.setString(6, a.getNotes());
            ps.setInt(7, a.getAsnId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean submitForApproval(int id, String by) throws SQLException {
        return updateStatus(id, "PENDING_APPROVAL", "submitted_by", by);
    }

    public boolean approveASN(int id, String by) throws SQLException {
        return updateStatus(id, "APPROVED", "approved_by", by);
    }

    public boolean rejectASN(int id, String by, String reason) throws SQLException {
        String sql = """
            UPDATE AdvancedShippingNotices SET status='REJECTED', approved_by=?, rejection_reason=?, updated_at=GETDATE() WHERE asn_id=?
            """;
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, by);
            ps.setString(2, reason);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateASNStatus(int id, String status) throws SQLException {
        return updateStatus(id, status, null, null);
    }

    public boolean deleteASN(int id) throws SQLException {
        String sql = "DELETE FROM AdvancedShippingNotices WHERE asn_id=?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // helper
    private boolean updateStatus(int id, String status, String field, String value) throws SQLException {
        String sql = "UPDATE AdvancedShippingNotices SET status=?, updated_at=GETDATE()"
                + (field != null ? ", " + field + "=?" : "")
                + " WHERE asn_id=?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            int i = 2;
            if (field != null) ps.setString(i++, value);
            ps.setInt(i, id);
            return ps.executeUpdate() > 0;
        }
    }

    private ASN map(ResultSet rs) throws SQLException {
        ASN a = new ASN();
        a.setAsnId(rs.getInt("asn_id"));
        a.setPoId(rs.getInt("po_id"));
        a.setSupplierId(rs.getInt("supplier_id"));
        Date sd = rs.getDate("shipment_date");
        if (sd != null) a.setShipmentDate(sd.toLocalDate());
        a.setCarrier(rs.getString("carrier"));
        a.setTrackingNumber(rs.getString("tracking_number"));
        a.setStatus(rs.getString("status"));
        a.setNotes(rs.getString("notes"));
        a.setSubmittedBy(rs.getString("submitted_by"));
        a.setApprovedBy(rs.getString("approved_by"));
        a.setRejectionReason(rs.getString("rejection_reason"));
        return a;
    }
}