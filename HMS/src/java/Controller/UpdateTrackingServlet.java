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

public class UpdateTrackingServlet extends HttpServlet {
    
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
        
        if (asnIdStr == null) {
            response.sendRedirect("supplierDashboard?error=" + 
                URLEncoder.encode("Missing ASN ID", "UTF-8"));
            return;
        }
        
        try {
            int asnId = Integer.parseInt(asnIdStr);
            
            SupplierDAO supplierDAO = new SupplierDAO();
            Supplier supplier = supplierDAO.getSupplierByUserId(userId);
            
            if (supplier == null) {
                response.sendRedirect("supplierDashboard?error=" + 
                    URLEncoder.encode("Supplier information not found", "UTF-8"));
                return;
            }
            
            ASNDAO asnDAO = new ASNDAO();
            AdvancedShippingNotice asn = asnDAO.getASNById(asnId);
            
            if (asn == null) {
                response.sendRedirect("supplierDashboard?error=" + 
                    URLEncoder.encode("Shipping notice not found", "UTF-8"));
                return;
            }
            
            // Verify ownership
            if (asn.getSupplierId() != supplier.getSupplierId()) {
                response.sendRedirect("supplierDashboard?error=" + 
                    URLEncoder.encode("Access denied", "UTF-8"));
                return;
            }
            
            // Only allow updates if status is "Sent"
            if (!"Sent".equals(asn.getStatus())) {
                response.sendRedirect("supplierDashboard?error=" + 
                    URLEncoder.encode("Cannot update tracking for shipped items", "UTF-8"));
                return;
            }
            
            request.setAttribute("asn", asn);
            request.setAttribute("supplier", supplier);
            request.getRequestDispatcher("/jsp/updateTracking.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("supplierDashboard?error=" + 
                URLEncoder.encode("Invalid ASN ID", "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("supplierDashboard?error=" + 
                URLEncoder.encode("Error: " + e.getMessage(), "UTF-8"));
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"Supplier".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }
        
        Integer userId = (Integer) session.getAttribute("userId");
        
        try {
            int asnId = Integer.parseInt(request.getParameter("asnId"));
            String carrier = request.getParameter("carrier");
            String trackingNumber = request.getParameter("trackingNumber");
            String newStatus = request.getParameter("status");
            
            if (carrier == null || trackingNumber == null) {
                response.sendRedirect("update-tracking?asnId=" + asnId + "&error=" + 
                    URLEncoder.encode("All fields are required", "UTF-8"));
                return;
            }
            
            SupplierDAO supplierDAO = new SupplierDAO();
            Supplier supplier = supplierDAO.getSupplierByUserId(userId);
            
            if (supplier == null) {
                response.sendRedirect("supplierDashboard?error=" + 
                    URLEncoder.encode("Supplier not found", "UTF-8"));
                return;
            }
            
            ASNDAO asnDAO = new ASNDAO();
            AdvancedShippingNotice asn = asnDAO.getASNById(asnId);
            
            if (asn == null || asn.getSupplierId() != supplier.getSupplierId()) {
                response.sendRedirect("supplierDashboard?error=" + 
                    URLEncoder.encode("Access denied", "UTF-8"));
                return;
            }
            
            // Update tracking info
            boolean updated = asnDAO.updateTrackingInfo(asnId, carrier, trackingNumber);
            
            // Update status if provided
            if (newStatus != null && !newStatus.isEmpty() && !newStatus.equals(asn.getStatus())) {
                asnDAO.updateASNStatus(asnId, newStatus);
            }
            
            if (updated) {
                String message = "Tracking information updated successfully! ASN #" + asnId;
                response.sendRedirect("supplierDashboard?success=" + URLEncoder.encode(message, "UTF-8"));
            } else {
                response.sendRedirect("supplierDashboard?error=" + 
                    URLEncoder.encode("Failed to update tracking information", "UTF-8"));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("supplierDashboard?error=" + 
                URLEncoder.encode("Error updating tracking: " + e.getMessage(), "UTF-8"));
        }
    }
}