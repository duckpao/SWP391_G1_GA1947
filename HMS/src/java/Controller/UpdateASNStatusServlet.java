package Controller;

import DAO.ASNDAO;
import DAO.SupplierDAO;
import DAO.NotificationDAO;
import DAO.UserDAO;
import model.AdvancedShippingNotice;
import model.Supplier;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;

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
                // Send notifications to managers based on status
                sendStatusNotificationToManagers(userId, supplier, asn, newStatus);
                
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
     * Send notification to all managers when ASN status changes
     */
    private void sendStatusNotificationToManagers(int senderId, Supplier supplier, 
                                                  AdvancedShippingNotice asn, String newStatus) {
        try {
            NotificationDAO notificationDAO = new NotificationDAO();
            UserDAO userDAO = new UserDAO();
            
            // Get all managers
            List<User> managers = userDAO.getUsersByRole("Manager");
            System.out.println("Found " + managers.size() + " managers to notify about ASN status change");
            
            String notificationTitle = "";
            String notificationMessage = "";
            String notificationType = "";
            String priority = "normal";
            String linkUrl = "/asn-details?asnId=" + asn.getAsnId();
            
            // Customize notification based on status
            switch (newStatus) {
                case "Sent":
                    notificationTitle = "ASN #" + asn.getAsnId() + " - Shipment Ready";
                    notificationMessage = "Supplier '" + supplier.getName() + "' has marked ASN #" + asn.getAsnId() + 
                                        " (PO #" + asn.getPoId() + ") as SENT. The shipment is ready for pickup.";
                    notificationType = "info";
                    priority = "normal";
                    break;
                    
                case "InTransit":
                    notificationTitle = "ASN #" + asn.getAsnId() + " - In Transit";
                    notificationMessage = "Shipment ASN #" + asn.getAsnId() + " (PO #" + asn.getPoId() + 
                                        ") from '" + supplier.getName() + "' has been handed over to the carrier " +
                                        "(" + asn.getCarrier() + "). Tracking: " + asn.getTrackingNumber();
                    notificationType = "success";
                    priority = "high";
                    break;
                    
                case "Delivered":
                    notificationTitle = "ASN #" + asn.getAsnId() + " - Delivered";
                    notificationMessage = "Shipment ASN #" + asn.getAsnId() + " (PO #" + asn.getPoId() + 
                                        ") has been marked as DELIVERED. Please verify and update receiving status.";
                    notificationType = "success";
                    priority = "high";
                    break;
                    
                case "Cancelled":
                    notificationTitle = "ASN #" + asn.getAsnId() + " - Cancelled";
                    notificationMessage = "Supplier '" + supplier.getName() + "' has CANCELLED shipment ASN #" + 
                                        asn.getAsnId() + " (PO #" + asn.getPoId() + ").";
                    notificationType = "warning";
                    priority = "urgent";
                    break;
                    
                default:
                    // For other statuses, send a generic notification
                    notificationTitle = "ASN #" + asn.getAsnId() + " - Status Updated";
                    notificationMessage = "ASN #" + asn.getAsnId() + " (PO #" + asn.getPoId() + 
                                        ") status has been updated to " + newStatus + ".";
                    notificationType = "info";
                    priority = "normal";
            }
            
            // Send notification to all managers
            for (User manager : managers) {
                boolean notifSent = notificationDAO.sendNotificationToUser(
                    senderId,
                    manager.getUserId(),
                    notificationTitle,
                    notificationMessage,
                    notificationType,
                    priority,
                    linkUrl
                );
                
                System.out.println("Notification sent to manager " + manager.getUsername() + 
                                 " for ASN #" + asn.getAsnId() + " (" + newStatus + "): " + notifSent);
            }
            
        } catch (Exception e) {
            System.err.println("Error sending notifications to managers: " + e.getMessage());
            e.printStackTrace();
            // Don't throw exception - notification failure shouldn't stop the main operation
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