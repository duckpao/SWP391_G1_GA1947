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

public class CancelASNServlet extends HttpServlet {
    
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
        String reason = request.getParameter("reason");
        
        if (asnIdStr == null || reason == null || reason.trim().isEmpty()) {
            response.sendRedirect("supplier-dashboard?error=" + 
                URLEncoder.encode("Cancellation reason is required", "UTF-8"));
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
            
            // Check if ASN can be cancelled
            if (!asn.canBeCancelled()) {
                response.sendRedirect("supplier-dashboard?error=" + 
                    URLEncoder.encode("ASN cannot be cancelled in current status: " + asn.getStatus(), "UTF-8"));
                return;
            }
            
            // Cancel ASN
            boolean cancelled = asnDAO.cancelASN(asnId, reason);
            
            if (cancelled) {
                String message = "ASN #" + asnId + " has been cancelled successfully";
                response.sendRedirect("supplier-dashboard?success=" + URLEncoder.encode(message, "UTF-8"));
            } else {
                response.sendRedirect("supplier-dashboard?error=" + 
                    URLEncoder.encode("Failed to cancel ASN", "UTF-8"));
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
}