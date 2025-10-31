package Controller;

import DAO.ASNDAO;
import model.AdvancedShippingNotice;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class UpdateTrackingServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"Supplier".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }
        
        try {
            int asnId = Integer.parseInt(request.getParameter("asnId"));
            
            ASNDAO asnDAO = new ASNDAO();
            AdvancedShippingNotice asn = asnDAO.getASNById(asnId);
            
            if (asn == null) {
                response.sendRedirect("supplier-dashboard?error=" + 
                    java.net.URLEncoder.encode("ASN not found!", "UTF-8"));
                return;
            }
            
            // Kiểm tra xem ASN có thể chỉnh sửa không (chỉ Pending hoặc Sent)
            if (!"Pending".equals(asn.getStatus()) && !"Sent".equals(asn.getStatus())) {
                response.sendRedirect("supplier-dashboard?error=" + 
                    java.net.URLEncoder.encode("This ASN cannot be edited anymore (Status: " + 
                    asn.getStatus() + ")", "UTF-8"));
                return;
            }
            
            request.setAttribute("asn", asn);
            request.getRequestDispatcher("/editTracking.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("supplier-dashboard?error=" + 
                java.net.URLEncoder.encode("Invalid ASN ID!", "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("supplier-dashboard?error=" + 
                java.net.URLEncoder.encode("Error loading ASN: " + e.getMessage(), "UTF-8"));
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
        
        try {
            int asnId = Integer.parseInt(request.getParameter("asnId"));
            String carrier = request.getParameter("carrier");
            String trackingNumber = request.getParameter("trackingNumber");
            
            // Validate inputs
            if (carrier == null || carrier.trim().isEmpty() || 
                trackingNumber == null || trackingNumber.trim().isEmpty()) {
                response.sendRedirect("update-tracking?asnId=" + asnId + "&error=" + 
                    java.net.URLEncoder.encode("All fields are required!", "UTF-8"));
                return;
            }
            
            ASNDAO asnDAO = new ASNDAO();
            
            // Kiểm tra ASN tồn tại
            AdvancedShippingNotice asn = asnDAO.getASNById(asnId);
            if (asn == null) {
                response.sendRedirect("supplier-dashboard?error=" + 
                    java.net.URLEncoder.encode("ASN not found!", "UTF-8"));
                return;
            }
            
            // Kiểm tra trạng thái có thể chỉnh sửa
            if (!"Pending".equals(asn.getStatus()) && !"Sent".equals(asn.getStatus())) {
                response.sendRedirect("supplier-dashboard?error=" + 
                    java.net.URLEncoder.encode("This ASN cannot be edited anymore!", "UTF-8"));
                return;
            }
            
            // Update tracking info
            boolean success = asnDAO.updateTrackingInfo(asnId, carrier.trim(), trackingNumber.trim());
            
            if (success) {
                System.out.println("=== TRACKING INFO UPDATED ===");
                System.out.println("ASN ID: " + asnId);
                System.out.println("New Carrier: " + carrier);
                System.out.println("New Tracking: " + trackingNumber);
                
                response.sendRedirect("supplier-dashboard?success=" + 
                    java.net.URLEncoder.encode("Tracking information updated successfully for ASN #" + 
                    asnId, "UTF-8"));
            } else {
                response.sendRedirect("update-tracking?asnId=" + asnId + "&error=" + 
                    java.net.URLEncoder.encode("Failed to update tracking information!", "UTF-8"));
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("supplier-dashboard?error=" + 
                java.net.URLEncoder.encode("Invalid ASN ID!", "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("supplier-dashboard?error=" + 
                java.net.URLEncoder.encode("Error updating tracking: " + e.getMessage(), "UTF-8"));
        }
    }
}