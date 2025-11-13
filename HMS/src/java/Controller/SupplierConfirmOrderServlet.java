package Controller;

import DAO.SupplierDAO;
import DAO.NotificationDAO;
import DAO.UserDAO;
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

public class SupplierConfirmOrderServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"Supplier".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }
        
        Integer userId = (Integer) session.getAttribute("userId");
        String action = request.getParameter("action");
        String poIdStr = request.getParameter("poId");
        
        if (poIdStr == null || action == null) {
            response.sendRedirect("supplier-dashboard?error=" + 
                URLEncoder.encode("Missing parameters", "UTF-8"));
            return;
        }
        
        try {
            int poId = Integer.parseInt(poIdStr);
            SupplierDAO supplierDAO = new SupplierDAO();
            NotificationDAO notificationDAO = new NotificationDAO();
            UserDAO userDAO = new UserDAO();
            
            // Get supplier info
            Supplier supplier = supplierDAO.getSupplierByUserId(userId);
            if (supplier == null) {
                response.sendRedirect("supplier-dashboard?error=" + 
                    URLEncoder.encode("Supplier information not found", "UTF-8"));
                return;
            }
            
            // Get all managers
            List<User> managers = userDAO.getUsersByRole("Manager");
            System.out.println("Found " + managers.size() + " managers to notify");
            
            boolean success = false;
            String message = "";
            String notificationTitle = "";
            String notificationMessage = "";
            String notificationType = "";
            String priority = "high";
            
            if ("approve".equalsIgnoreCase(action)) {
                success = supplierDAO.confirmPurchaseOrder(poId, supplier.getSupplierId());
                
                if (success) {
                    message = "Order #" + poId + " has been approved successfully! You can now create a shipping notice.";
                    
                    // Prepare notification for managers
                    notificationTitle = "Purchase Order #" + poId + " Approved";
                    notificationMessage = "Supplier '" + supplier.getName() + "' has approved Purchase Order #" + poId + ". The order is now ready for shipment.";
                    notificationType = "success";
                    
                    // Send notification to all managers
                    for (User manager : managers) {
                        boolean notifSent = notificationDAO.sendNotificationToUser(
                            userId, // sender is the supplier user
                            manager.getUserId(),
                            notificationTitle,
                            notificationMessage,
                            notificationType,
                            priority,
                            "/purchase-order?poId=" + poId
                        );
                        
                        System.out.println("Notification sent to manager " + manager.getUsername() + ": " + notifSent);
                    }
                    
                    response.sendRedirect("supplier-dashboard?success=" + URLEncoder.encode(message, "UTF-8"));
                } else {
                    message = "Failed to approve order #" + poId + ". Please make sure the order is in 'Sent' status.";
                    response.sendRedirect("supplier-dashboard?error=" + URLEncoder.encode(message, "UTF-8"));
                }
                
            } else if ("reject".equalsIgnoreCase(action)) {
                String reason = request.getParameter("reason");
                if (reason == null || reason.trim().isEmpty()) {
                    reason = "No reason provided";
                }
                
                success = supplierDAO.rejectPurchaseOrder(poId, supplier.getSupplierId(), reason);
                
                if (success) {
                    message = "Order #" + poId + " has been rejected.";
                    
                    // Prepare notification for managers
                    notificationTitle = "Purchase Order #" + poId + " Rejected";
                    notificationMessage = "Supplier '" + supplier.getName() + "' has rejected Purchase Order #" + poId + ". Reason: " + reason;
                    notificationType = "warning";
                    priority = "urgent";
                    
                    // Send notification to all managers
                    for (User manager : managers) {
                        boolean notifSent = notificationDAO.sendNotificationToUser(
                            userId, // sender is the supplier user
                            manager.getUserId(),
                            notificationTitle,
                            notificationMessage,
                            notificationType,
                            priority,
                            "/purchase-order?poId=" + poId
                        );
                        
                        System.out.println("Notification sent to manager " + manager.getUsername() + ": " + notifSent);
                    }
                    
                    response.sendRedirect("supplier-dashboard?success=" + URLEncoder.encode(message, "UTF-8"));
                } else {
                    message = "Failed to reject order #" + poId + ". Please make sure the order is in 'Sent' status.";
                    response.sendRedirect("supplier-dashboard?error=" + URLEncoder.encode(message, "UTF-8"));
                }
                
            } else {
                response.sendRedirect("supplier-dashboard?error=" + 
                    URLEncoder.encode("Invalid action", "UTF-8"));
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("supplier-dashboard?error=" + 
                URLEncoder.encode("Invalid order ID", "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("supplier-dashboard?error=" + 
                URLEncoder.encode("An error occurred: " + e.getMessage(), "UTF-8"));
        }
    }
}