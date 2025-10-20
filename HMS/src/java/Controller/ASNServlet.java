package Controller;

import DAO.ASNDAO;
import model.ASN;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public class ASNServlet extends HttpServlet {

    private ASNDAO asnDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        asnDAO = new ASNDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        PrintWriter out = resp.getWriter();
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            if (action != null) {
                switch (action) {
                    case "getById":
                        int id = Integer.parseInt(req.getParameter("id"));
                        Optional<ASN> asn = asnDAO.getASNById(id);
                        if (asn.isPresent()) {
                            out.print(convertASNToJson(asn.get()));
                        } else {
                            out.print("{\"error\": \"ASN not found\"}");
                        }
                        break;
                    case "getBySupplier":
                        int supplierId = Integer.parseInt(req.getParameter("supplierId"));
                        List<ASN> asnsBySupplier = asnDAO.getASNsBySupplierId(supplierId);
                        out.print(convertASNsToJson(asnsBySupplier));
                        break;
                    case "getByStatus":
                        String status = req.getParameter("status");
                        List<ASN> asnsByStatus = asnDAO.getASNsByStatus(status);
                        out.print(convertASNsToJson(asnsByStatus));
                        break;
                    case "getPendingApproval":
                        List<ASN> pendingASNs = asnDAO.getPendingApprovalASNs();
                        out.print(convertASNsToJson(pendingASNs));
                        break;
                    case "getAll":
                    default:
                        List<ASN> asns = asnDAO.getAllASNs();
                        out.print(convertASNsToJson(asns));
                        break;
                }
            } else {
                // Default: get all ASNs
                List<ASN> asns = asnDAO.getAllASNs();
                out.print(convertASNsToJson(asns));
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        PrintWriter out = resp.getWriter();
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            if (action != null) {
                switch (action) {
                    case "create":
                        createASN(req, out);
                        break;
                    case "update":
                        updateASN(req, out);
                        break;
                    case "submitForApproval":
                        submitForApproval(req, out);
                        break;
                    case "approve":
                        approveASN(req, out);
                        break;
                    case "reject":
                        rejectASN(req, out);
                        break;
                    case "updateStatus":
                        updateASNStatus(req, out);
                        break;
                    case "delete":
                        deleteASN(req, out);
                        break;
                    case "createBySupplier":
                        createASNBySupplier(req, out);
                        break;
                    default:
                        out.print("{\"error\": \"Invalid action\"}");
                }
            } else {
                out.print("{\"error\": \"Action parameter is required\"}");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void createASN(HttpServletRequest req, PrintWriter out) throws SQLException {
        ASN asn = new ASN();

        // Required fields
        asn.setPoId(Integer.parseInt(req.getParameter("poId")));
        asn.setSupplierId(Integer.parseInt(req.getParameter("supplierId")));
        asn.setShipmentDate(LocalDate.parse(req.getParameter("shipmentDate")));
        asn.setCarrier(req.getParameter("carrier"));
        asn.setTrackingNumber(req.getParameter("trackingNumber"));

        // Optional fields
        String notes = req.getParameter("notes");
        if (notes != null) {
            asn.setNotes(notes);
        }

        // Set default status to DRAFT
        asn.setStatus("DRAFT");

        boolean success = asnDAO.addASN(asn);
        if (success) {
            out.print("{\"message\": \"ASN created successfully\", \"id\": " + asn.getAsnId()
                    + ", \"status\": \"DRAFT\"}");
        } else {
            out.print("{\"error\": \"Failed to create ASN\"}");
        }
    }

    private void updateASN(HttpServletRequest req, PrintWriter out) throws SQLException {
        int asnId = Integer.parseInt(req.getParameter("asnId"));

        Optional<ASN> optionalASN = asnDAO.getASNById(asnId);
        if (!optionalASN.isPresent()) {
            out.print("{\"error\": \"ASN not found\"}");
            return;
        }

        ASN asn = optionalASN.get();

        // Only allow updates if status is DRAFT
        if (!asn.isDraft()) {
            out.print("{\"error\": \"Can only update ASN in DRAFT status. Current status: " + asn.getStatus() + "\"}");
            return;
        }

        // Update fields if provided
        if (req.getParameter("poId") != null) {
            asn.setPoId(Integer.parseInt(req.getParameter("poId")));
        }
        if (req.getParameter("shipmentDate") != null) {
            asn.setShipmentDate(LocalDate.parse(req.getParameter("shipmentDate")));
        }
        if (req.getParameter("carrier") != null) {
            asn.setCarrier(req.getParameter("carrier"));
        }
        if (req.getParameter("trackingNumber") != null) {
            asn.setTrackingNumber(req.getParameter("trackingNumber"));
        }
        if (req.getParameter("notes") != null) {
            asn.setNotes(req.getParameter("notes"));
        }

        boolean success = asnDAO.updateASN(asn);
        if (success) {
            out.print("{\"message\": \"ASN updated successfully\"}");
        } else {
            out.print("{\"error\": \"Failed to update ASN\"}");
        }
    }

    private void submitForApproval(HttpServletRequest req, PrintWriter out) throws SQLException {
        int asnId = Integer.parseInt(req.getParameter("asnId"));
        String submittedBy = req.getParameter("submittedBy"); // Supplier username

        // Check if ASN exists and can be submitted
        Optional<ASN> optionalASN = asnDAO.getASNById(asnId);
        if (!optionalASN.isPresent()) {
            out.print("{\"error\": \"ASN not found\"}");
            return;
        }

        ASN asn = optionalASN.get();
        if (!asn.canBeSubmitted()) {
            out.print("{\"error\": \"ASN cannot be submitted for approval. Current status: " + asn.getStatus() + "\"}");
            return;
        }

        boolean success = asnDAO.submitForApproval(asnId, submittedBy);
        if (success) {
            out.print("{\"message\": \"ASN submitted for manager approval\", \"status\": \"PENDING_APPROVAL\"}");
        } else {
            out.print("{\"error\": \"Failed to submit ASN for approval\"}");
        }
    }

    private void approveASN(HttpServletRequest req, PrintWriter out) throws SQLException {
        int asnId = Integer.parseInt(req.getParameter("asnId"));
        String approvedBy = req.getParameter("approvedBy"); // Manager username

        // Check if ASN exists and can be approved
        Optional<ASN> optionalASN = asnDAO.getASNById(asnId);
        if (!optionalASN.isPresent()) {
            out.print("{\"error\": \"ASN not found\"}");
            return;
        }

        ASN asn = optionalASN.get();
        if (!asn.canBeApproved()) {
            out.print("{\"error\": \"ASN cannot be approved. Current status: " + asn.getStatus() + "\"}");
            return;
        }

        boolean success = asnDAO.approveASN(asnId, approvedBy);
        if (success) {
            out.print(
                    "{\"message\": \"ASN approved successfully. Supplier can now ship the goods.\", \"status\": \"APPROVED\"}");
        } else {
            out.print("{\"error\": \"Failed to approve ASN\"}");
        }
    }

    private void rejectASN(HttpServletRequest req, PrintWriter out) throws SQLException {
        int asnId = Integer.parseInt(req.getParameter("asnId"));
        String rejectedBy = req.getParameter("rejectedBy"); // Manager username
        String rejectionReason = req.getParameter("rejectionReason");

        if (rejectionReason == null || rejectionReason.trim().isEmpty()) {
            out.print("{\"error\": \"Rejection reason is required\"}");
            return;
        }

        // Check if ASN exists and can be rejected
        Optional<ASN> optionalASN = asnDAO.getASNById(asnId);
        if (!optionalASN.isPresent()) {
            out.print("{\"error\": \"ASN not found\"}");
            return;
        }

        ASN asn = optionalASN.get();
        if (!asn.canBeRejected()) {
            out.print("{\"error\": \"ASN cannot be rejected. Current status: " + asn.getStatus() + "\"}");
            return;
        }

        boolean success = asnDAO.rejectASN(asnId, rejectedBy, rejectionReason);
        if (success) {
            out.print("{\"message\": \"ASN rejected\", \"status\": \"REJECTED\"}");
        } else {
            out.print("{\"error\": \"Failed to reject ASN\"}");
        }
    }

    private void updateASNStatus(HttpServletRequest req, PrintWriter out) throws SQLException {
        int asnId = Integer.parseInt(req.getParameter("asnId"));
        String status = req.getParameter("status");

        if (status == null || status.trim().isEmpty()) {
            out.print("{\"error\": \"Status is required\"}");
            return;
        }

        boolean success = asnDAO.updateASNStatus(asnId, status);
        if (success) {
            out.print("{\"message\": \"ASN status updated\", \"status\": \"" + status + "\"}");
        } else {
            out.print("{\"error\": \"Failed to update ASN status\"}");
        }
    }

    private void deleteASN(HttpServletRequest req, PrintWriter out) throws SQLException {
        int asnId = Integer.parseInt(req.getParameter("asnId"));

        // Check if ASN exists and is in DRAFT status (only allow deletion of drafts)
        Optional<ASN> optionalASN = asnDAO.getASNById(asnId);
        if (!optionalASN.isPresent()) {
            out.print("{\"error\": \"ASN not found\"}");
            return;
        }

        ASN asn = optionalASN.get();
        if (!asn.isDraft()) {
            out.print("{\"error\": \"Can only delete ASN in DRAFT status. Current status: " + asn.getStatus() + "\"}");
            return;
        }

        boolean success = asnDAO.deleteASN(asnId);
        if (success) {
            out.print("{\"message\": \"ASN deleted successfully\"}");
        } else {
            out.print("{\"error\": \"Failed to delete ASN\"}");
        }
    }

    // Helper methods to convert to JSON manually
    private String convertASNToJson(ASN asn) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"asnId\":").append(asn.getAsnId()).append(",");
        json.append("\"poId\":").append(asn.getPoId()).append(",");
        json.append("\"supplierId\":").append(asn.getSupplierId()).append(",");
        json.append("\"shipmentDate\":\"").append(asn.getShipmentDate()).append("\",");
        json.append("\"carrier\":\"").append(escapeJson(asn.getCarrier())).append("\",");
        json.append("\"trackingNumber\":\"").append(escapeJson(asn.getTrackingNumber())).append("\",");
        json.append("\"status\":\"").append(escapeJson(asn.getStatus())).append("\",");
        json.append("\"notes\":\"").append(escapeJson(asn.getNotes())).append("\",");
        json.append("\"submittedBy\":\"").append(escapeJson(asn.getSubmittedBy())).append("\",");
        json.append("\"approvedBy\":\"").append(escapeJson(asn.getApprovedBy())).append("\",");
        json.append("\"submittedAt\":\"").append(asn.getSubmittedAt()).append("\",");
        json.append("\"approvedAt\":\"").append(asn.getApprovedAt()).append("\",");
        json.append("\"rejectionReason\":\"").append(escapeJson(asn.getRejectionReason())).append("\",");
        json.append("\"createdAt\":\"").append(asn.getCreatedAt()).append("\",");
        json.append("\"updatedAt\":\"").append(asn.getUpdatedAt()).append("\"");
        json.append("}");
        return json.toString();
    }

    private String convertASNsToJson(List<ASN> asns) {
        StringBuilder json = new StringBuilder();
        json.append("[");
        for (int i = 0; i < asns.size(); i++) {
            json.append(convertASNToJson(asns.get(i)));
            if (i < asns.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");
        return json.toString();
    }

    private void createASNBySupplier(HttpServletRequest req, PrintWriter out) throws SQLException {
        // Lấy supplierId từ session (sau khi đăng nhập)
        Integer supplierId = (Integer) req.getSession().getAttribute("supplierId");

        if (supplierId == null) {
            out.print("{\"error\": \"Unauthorized. Please login as supplier.\"}");
            return;
        }

        ASN asn = new ASN();
        asn.setSupplierId(supplierId); // tự động gán supplierId từ session
        asn.setPoId(Integer.parseInt(req.getParameter("poId")));
        asn.setShipmentDate(LocalDate.parse(req.getParameter("shipmentDate")));
        asn.setCarrier(req.getParameter("carrier"));
        asn.setTrackingNumber(req.getParameter("trackingNumber"));
        asn.setNotes(req.getParameter("notes"));
        asn.setStatus("DRAFT");

        boolean success = asnDAO.addASN(asn);
        if (success) {
            out.print("{\"message\": \"ASN created successfully by supplier\", \"asnId\": " + asn.getAsnId() + "}");
        } else {
            out.print("{\"error\": \"Failed to create ASN\"}");
        }
    }

    private String escapeJson(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\b", "\\b")
                .replace("\f", "\\f")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}