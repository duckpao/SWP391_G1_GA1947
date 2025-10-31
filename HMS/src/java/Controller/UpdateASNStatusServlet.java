package Controller;

import DAO.ASNDAO;
import DAO.SupplierDAO;
import model.AdvancedShippingNotice;
import model.Supplier;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;

public class UpdateASNStatusServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"Supplier".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }
        
        Integer userId = (Integer) session.getAttribute("userId");
        String asnIdStr = request.getParameter("asnId");
        String newStatus = request.getParameter("status");
        
        if (asnIdStr == null || newStatus == null) {
            response.sendRedirect("supplier-dashboard?error=" + 
                URLEncoder.encode("Missing parameters", "UTF-8"));
            return;
        }
        
        try {
            int asnId = Integer.parseInt(asnIdStr);
            
            SupplierDAO supplierDAO = new SupplierDAO();
            Supplier supplier = supplierDAO.getSupplierByUserId(userId);
            
            if (supplier == null) {
                response.sendRedirect("supplier-dashboard?error=" + 
                    URLEncoder.encode("Supplier not found", "UTF-8"));
                return;
            }
            
            ASNDAO asnDAO = new ASNDAO();
            AdvancedShippingNotice asn = asnDAO.getASNById(asnId);
            
            if (asn == null) {
                response.sendRedirect("supplier-dashboard?error=" + 
                    URLEncoder.encode("ASN not found", "UTF-8"));
                return;
            }
            
            // Verify ownership
            if (asn.getSupplierId() != supplier.getSupplierId()) {
                response.sendRedirect("supplier-dashboard?error=" + 
                    URLEncoder.encode("Access denied", "UTF-8"));
                return;
            }
            
            // Validate status transition
            if (!isValidStatusTransition(asn.getStatus(), newStatus)) {
                response.sendRedirect("supplier-dashboard?error=" + 
                    URLEncoder.encode("Invalid status transition from " + asn.getStatus() + " to " + newStatus, "UTF-8"));
                return;
            }
            
            // Update status
            boolean updated = asnDAO.updateASNStatus(asnId, newStatus);
            
            if (updated) {
                String message = "ASN #" + asnId + " status updated to " + newStatus + " successfully!";
                response.sendRedirect("supplier-dashboard?success=" + URLEncoder.encode(message, "UTF-8"));
            } else {
                response.sendRedirect("supplier-dashboard?error=" + 
                    URLEncoder.encode("Failed to update ASN status", "UTF-8"));
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("supplier-dashboard?error=" + 
                URLEncoder.encode("Invalid ASN ID", "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("supplier-dashboard?error=" + 
                URLEncoder.encode("Error: " + e.getMessage(), "UTF-8"));
        }
    }
    
    /**
     * Validate if status transition is allowed
     * Allowed transitions:
     * - Pending -> Sent
     * - Sent -> InTransit
     * - InTransit -> Delivered (typically done by hospital)
     * - Any -> Cancelled (with restrictions)
     */
    private boolean isValidStatusTransition(String currentStatus, String newStatus) {
        if (currentStatus == null || newStatus == null) {
            return false;
        }
        
        switch (currentStatus) {
            case "Pending":
                return newStatus.equals("Sent") || newStatus.equals("Cancelled");
            case "Sent":
                return newStatus.equals("InTransit") || newStatus.equals("Cancelled");
            case "InTransit":
                return newStatus.equals("Delivered"); // Usually hospital does this
            case "Delivered":
            case "Rejected":
            case "Cancelled":
                return false; // Terminal states
            default:
                return false;
        }
    }
}