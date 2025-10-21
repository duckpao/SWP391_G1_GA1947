package Controller;

import DAO.ASNDAO;
import model.ASN;
import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.*;

public class ASNServlet extends HttpServlet {
    private ASNDAO asnDAO;

    @Override
    public void init() throws ServletException {
        asnDAO = new ASNDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        resp.setContentType("application/json;charset=UTF-8");
        String action = req.getParameter("action");
        try (PrintWriter out = resp.getWriter()) {
            if (action == null) action = "getAll";

            switch (action) {
                case "getById" -> {
                    int id = Integer.parseInt(req.getParameter("id"));
                    asnDAO.getASNById(id)
                            .ifPresentOrElse(
                                    asn -> out.print(convertASNToJson(asn)),
                                    () -> out.print("{\"error\":\"ASN not found\"}")
                            );
                }
                case "getBySupplier" -> {
                    int supplierId = Integer.parseInt(req.getParameter("supplierId"));
                    out.print(convertASNsToJson(asnDAO.getASNsBySupplierId(supplierId)));
                }
                case "getByStatus" -> {
                    String status = req.getParameter("status");
                    out.print(convertASNsToJson(asnDAO.getASNsByStatus(status)));
                }
                case "getPendingApproval" -> out.print(convertASNsToJson(asnDAO.getPendingApprovalASNs()));
                default -> out.print(convertASNsToJson(asnDAO.getAllASNs()));
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        resp.setContentType("application/json;charset=UTF-8");
        String action = req.getParameter("action");
        try (PrintWriter out = resp.getWriter()) {
            if (action == null) {
                out.print("{\"error\":\"Missing action parameter\"}");
                return;
            }
            switch (action) {
                case "create" -> createASN(req, out);
                case "update" -> updateASN(req, out);
                case "submitForApproval" -> submitForApproval(req, out);
                case "approve" -> approveASN(req, out);
                case "reject" -> rejectASN(req, out);
                case "updateStatus" -> updateASNStatus(req, out);
                case "delete" -> deleteASN(req, out);
                case "createBySupplier" -> createASNBySupplier(req, out);
                default -> out.print("{\"error\":\"Invalid action\"}");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void createASN(HttpServletRequest req, PrintWriter out) throws SQLException {
        ASN asn = new ASN();
      
        asn.setSupplierId(Integer.parseInt(req.getParameter("supplierId")));
        asn.setShipmentDate(LocalDate.parse(req.getParameter("shipmentDate")));
        asn.setCarrier(req.getParameter("carrier"));
        asn.setTrackingNumber(req.getParameter("trackingNumber"));
        asn.setNotes(Optional.ofNullable(req.getParameter("notes")).orElse(""));
        asn.setStatus("DRAFT");

        if (asnDAO.addASN(asn))
            out.print("{\"message\":\"ASN created successfully\",\"id\":" + asn.getAsnId() + "}");
        else
            out.print("{\"error\":\"Failed to create ASN\"}");
    }

    private void updateASN(HttpServletRequest req, PrintWriter out) throws SQLException {
        int asnId = Integer.parseInt(req.getParameter("asnId"));
        Optional<ASN> opt = asnDAO.getASNById(asnId);
        if (opt.isEmpty()) {
            out.print("{\"error\":\"ASN not found\"}");
            return;
        }
        ASN asn = opt.get();
        if (!asn.isDraft()) {
            out.print("{\"error\":\"Only DRAFT ASNs can be updated\"}");
            return;
        }

        if (req.getParameter("shipmentDate") != null)
            asn.setShipmentDate(LocalDate.parse(req.getParameter("shipmentDate")));
        asn.setCarrier(Optional.ofNullable(req.getParameter("carrier")).orElse(asn.getCarrier()));
        asn.setTrackingNumber(Optional.ofNullable(req.getParameter("trackingNumber")).orElse(asn.getTrackingNumber()));
        asn.setNotes(Optional.ofNullable(req.getParameter("notes")).orElse(asn.getNotes()));

        out.print(asnDAO.updateASN(asn)
                ? "{\"message\":\"ASN updated successfully\"}"
                : "{\"error\":\"Update failed\"}");
    }

    private void submitForApproval(HttpServletRequest req, PrintWriter out) throws SQLException {
        int id = Integer.parseInt(req.getParameter("asnId"));
        String submittedBy = req.getParameter("submittedBy");
        Optional<ASN> opt = asnDAO.getASNById(id);
        if (opt.isEmpty()) {
            out.print("{\"error\":\"ASN not found\"}");
            return;
        }
        ASN asn = opt.get();
        if (!asn.canBeSubmitted()) {
            out.print("{\"error\":\"ASN not in DRAFT status\"}");
            return;
        }
        out.print(asnDAO.submitForApproval(id, submittedBy)
                ? "{\"message\":\"ASN submitted for approval\"}"
                : "{\"error\":\"Submit failed\"}");
    }

    private void approveASN(HttpServletRequest req, PrintWriter out) throws SQLException {
        int id = Integer.parseInt(req.getParameter("asnId"));
        String approvedBy = req.getParameter("approvedBy");
        out.print(asnDAO.approveASN(id, approvedBy)
                ? "{\"message\":\"ASN approved\"}"
                : "{\"error\":\"Approval failed\"}");
    }

    private void rejectASN(HttpServletRequest req, PrintWriter out) throws SQLException {
        int id = Integer.parseInt(req.getParameter("asnId"));
        String reason = req.getParameter("rejectionReason");
        String by = req.getParameter("rejectedBy");
        if (reason == null || reason.isBlank()) {
            out.print("{\"error\":\"Rejection reason required\"}");
            return;
        }
        out.print(asnDAO.rejectASN(id, by, reason)
                ? "{\"message\":\"ASN rejected\"}"
                : "{\"error\":\"Rejection failed\"}");
    }

    private void updateASNStatus(HttpServletRequest req, PrintWriter out) throws SQLException {
        int id = Integer.parseInt(req.getParameter("asnId"));
        String status = req.getParameter("status");
        out.print(asnDAO.updateASNStatus(id, status)
                ? "{\"message\":\"Status updated\"}"
                : "{\"error\":\"Failed to update status\"}");
    }

    private void deleteASN(HttpServletRequest req, PrintWriter out) throws SQLException {
        int id = Integer.parseInt(req.getParameter("asnId"));
        Optional<ASN> opt = asnDAO.getASNById(id);
        if (opt.isEmpty() || !opt.get().isDraft()) {
            out.print("{\"error\":\"Only DRAFT ASN can be deleted\"}");
            return;
        }
        out.print(asnDAO.deleteASN(id)
                ? "{\"message\":\"ASN deleted\"}"
                : "{\"error\":\"Delete failed\"}");
    }

    private void createASNBySupplier(HttpServletRequest req, PrintWriter out) throws SQLException {
        Integer supplierId = (Integer) req.getSession().getAttribute("supplierId");
        if (supplierId == null) {
            out.print("{\"error\":\"Unauthorized supplier\"}");
            return;
        }
        ASN asn = new ASN();
        asn.setSupplierId(supplierId);
        asn.setPoId(Integer.parseInt(req.getParameter("poId")));
        asn.setShipmentDate(LocalDate.parse(req.getParameter("shipmentDate")));
        asn.setCarrier(req.getParameter("carrier"));
        asn.setTrackingNumber(req.getParameter("trackingNumber"));
        asn.setNotes(req.getParameter("notes"));
        asn.setStatus("DRAFT");

        out.print(asnDAO.addASN(asn)
                ? "{\"message\":\"ASN created by supplier\",\"asnId\":" + asn.getAsnId() + "}"
                : "{\"error\":\"Failed to create ASN\"}");
    }

    private String convertASNToJson(ASN a) {
        return String.format(Locale.US,
                "{\"asnId\":%d,\"poId\":%d,\"supplierId\":%d,\"shipmentDate\":\"%s\",\"carrier\":\"%s\",\"trackingNumber\":\"%s\",\"status\":\"%s\",\"notes\":\"%s\"}",
                a.getAsnId(), a.getPoId(), a.getSupplierId(),
                a.getShipmentDate(), escape(a.getCarrier()), escape(a.getTrackingNumber()),
                escape(a.getStatus()), escape(a.getNotes()));
    }

    private String convertASNsToJson(List<ASN> list) {
        return "[" + list.stream().map(this::convertASNToJson).reduce((a, b) -> a + "," + b).orElse("") + "]";
    }

    private String escape(String s) {
        return s == null ? "" : s.replace("\"", "\\\"");
    }
}