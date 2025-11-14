package Controller;

import DAO.ManagerDAO;
import DAO.NotificationDAO;
import DAO.SupplierDAO;
import model.PurchaseOrder;
import model.Supplier;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class ApproveStockServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("========================================");
        System.out.println("APPROVE STOCK - POST");
        System.out.println("========================================");
        
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");

        if (!"Manager".equals(role) || userId == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        String poIdStr = request.getParameter("poId");

        System.out.println("Action: " + action);
        System.out.println("PO ID: " + poIdStr);

        if (poIdStr == null || poIdStr.trim().isEmpty()) {
            session.setAttribute("message", "Invalid purchase order ID.");
            session.setAttribute("messageType", "error");
            response.sendRedirect("manager-dashboard");
            return;
        }

        try {
            int poId = Integer.parseInt(poIdStr);
            ManagerDAO managerDAO = new ManagerDAO();
            
            // Get PO details before processing
            PurchaseOrder po = managerDAO.getPurchaseOrderById(poId);
            if (po == null) {
                session.setAttribute("message", "Purchase order not found.");
                session.setAttribute("messageType", "error");
                response.sendRedirect("manager-dashboard");
                return;
            }

            // ✅ DEBUG: Check supplier_id
            System.out.println("→ PO #" + poId + " Details:");
            System.out.println("  - Supplier ID: " + po.getSupplierId());
            System.out.println("  - Status: " + po.getStatus());

            if ("approve".equals(action)) {
                // ✅ CRITICAL: Check if supplier is assigned BEFORE approving
                Integer supplierId = po.getSupplierId();
                if (supplierId == null || supplierId.intValue() == 0) {
                    System.out.println("❌ Cannot approve: No supplier assigned to PO #" + poId);
                    session.setAttribute("message", "Cannot approve: Please assign a supplier to this purchase order first.");
                    session.setAttribute("messageType", "error");
                    response.sendRedirect("manager-dashboard");
                    return;
                }
                
                // Approve and send to supplier
                boolean success = managerDAO.approveStockRequest(poId, userId);
                
                if (success) {
                    // Send notification to supplier
                    sendNotificationToSupplier(userId, po);
                    
                    session.setAttribute("message", "Stock request #" + poId + " has been sent to supplier successfully!");
                    session.setAttribute("messageType", "success");
                    System.out.println("✅ Approval successful and notification sent to supplier!");
                } else {
                    session.setAttribute("message", "Failed to send stock request. Make sure it's in Draft status.");
                    session.setAttribute("messageType", "error");
                    System.out.println("❌ Approval failed!");
                }
                
            } else if ("reject".equals(action)) {
                String reason = request.getParameter("reason");
                if (reason == null || reason.trim().length() < 5) {
                    session.setAttribute("message", "Rejection reason must be at least 5 characters.");
                    session.setAttribute("messageType", "error");
                    response.sendRedirect("manager-dashboard");
                    return;
                }
                
                boolean success = managerDAO.rejectStockRequest(poId, reason);
                if (success) {
                    session.setAttribute("message", "Stock request #" + poId + " has been rejected.");
                    session.setAttribute("messageType", "success");
                    System.out.println("✅ Rejection successful!");
                } else {
                    session.setAttribute("message", "Failed to reject stock request. Make sure it's in Draft status.");
                    session.setAttribute("messageType", "error");
                    System.out.println("❌ Rejection failed!");
                }
                
            } else if ("cancel".equals(action)) {
                String reason = request.getParameter("reason");
                if (reason == null || reason.trim().length() < 10) {
                    session.setAttribute("message", "Cancellation reason must be at least 10 characters.");
                    session.setAttribute("messageType", "error");
                    response.sendRedirect("manager-dashboard");
                    return;
                }
                
                boolean success = managerDAO.cancelStockRequest(poId, reason);
                
                if (success) {
                    // ✅ Check supplier before sending cancellation notification
                    Integer supplierId = po.getSupplierId();
                    if (supplierId != null && supplierId.intValue() > 0) {
                        sendCancellationNotificationToSupplier(userId, po, reason);
                    } else {
                        System.out.println("⚠️ No supplier assigned, skipping cancellation notification");
                    }
                    
                    session.setAttribute("message", "Stock request #" + poId + " has been cancelled.");
                    session.setAttribute("messageType", "success");
                    System.out.println("✅ Cancellation successful!");
                } else {
                    session.setAttribute("message", "Failed to cancel stock request. Make sure it's in Sent status.");
                    session.setAttribute("messageType", "error");
                    System.out.println("❌ Cancellation failed!");
                }
                
            } else {
                session.setAttribute("message", "Invalid action.");
                session.setAttribute("messageType", "error");
            }
            
            System.out.println("========================================\n");
            response.sendRedirect("manager-dashboard");
            
        } catch (NumberFormatException e) {
            System.err.println("Invalid PO ID format: " + e.getMessage());
            session.setAttribute("message", "Invalid purchase order ID format.");
            session.setAttribute("messageType", "error");
            response.sendRedirect("manager-dashboard");
        } catch (Exception e) {
            System.err.println("EXCEPTION in ApproveStockServlet: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("message", "Error: " + e.getMessage());
            session.setAttribute("messageType", "error");
            response.sendRedirect("manager-dashboard");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("manager-dashboard");
    }
    
    /**
     * Send notification to supplier when PO is approved and sent
     */
    private void sendNotificationToSupplier(int managerId, PurchaseOrder po) {
        try {
            // ✅ CRITICAL CHECK: Verify supplier_id is valid
            Integer supplierId = po.getSupplierId();
            if (supplierId == null || supplierId.intValue() == 0) {
                System.out.println("⚠️ No supplier assigned to PO #" + po.getPoId() + ", skipping notification");
                return;
            }
            
            System.out.println("→ Attempting to send notification for PO #" + po.getPoId());
            System.out.println("  - Supplier ID: " + supplierId);
            
            NotificationDAO notificationDAO = new NotificationDAO();
            SupplierDAO supplierDAO = new SupplierDAO();
            
            // Get supplier details using supplier_id (NOT user_id)
            Supplier supplier = supplierDAO.getSupplierById(supplierId);
            
            if (supplier == null) {
                System.out.println("⚠️ Supplier not found for ID: " + po.getSupplierId());
                return;
            }
            
            System.out.println("→ Found supplier: " + supplier.getName());
            System.out.println("  - Supplier ID: " + supplier.getSupplierId());
            System.out.println("  - User ID: " + supplier.getUserId());
            
            // ✅ Check if supplier has a user account
            if (supplier.getUserId() == 0) {
                System.out.println("⚠️ Supplier '" + supplier.getName() + "' has no user account (userId = 0)");
                System.out.println("⚠️ This supplier cannot receive notifications");
                return;
            }
            
            System.out.println("→ Sending notification to user ID: " + supplier.getUserId());
            
            // Prepare notification details
            String notificationTitle = "New Purchase Order #" + po.getPoId() + " Received";
            String notificationMessage = "You have received a new purchase order #" + po.getPoId() + 
                                       " from the pharmacy. Expected delivery date: " + po.getExpectedDeliveryDate() + 
                                       ". Please review and confirm this order.";
            String notificationType = "info";
            String priority = "high";
            String linkUrl = "/supplier-dashboard";
            
            // Send notification to supplier's user account
            boolean notifSent = notificationDAO.sendNotificationToUser(
                managerId,                    // sender: manager
                supplier.getUserId(),         // receiver: supplier's user account
                notificationTitle,
                notificationMessage,
                notificationType,
                priority,
                linkUrl
            );
            
            if (notifSent) {
                System.out.println("✅ Notification sent successfully to " + supplier.getName());
            } else {
                System.out.println("❌ Failed to send notification to " + supplier.getName());
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error sending notification to supplier: " + e.getMessage());
            e.printStackTrace();
            // Don't throw exception - notification failure shouldn't stop the main operation
        }
    }
    
    /**
     * Send notification to supplier when PO is cancelled
     */
    private void sendCancellationNotificationToSupplier(int managerId, PurchaseOrder po, String reason) {
        try {
            // ✅ CRITICAL CHECK
            Integer supplierId = po.getSupplierId();
            if (supplierId == null || supplierId.intValue() == 0) {
                System.out.println("⚠️ No supplier assigned to PO #" + po.getPoId() + ", skipping cancellation notification");
                return;
            }
            
            NotificationDAO notificationDAO = new NotificationDAO();
            SupplierDAO supplierDAO = new SupplierDAO();
            
            // Get supplier details using supplier_id
            Supplier supplier = supplierDAO.getSupplierById(supplierId);
            
            if (supplier == null) {
                System.out.println("⚠️ Supplier not found for ID: " + po.getSupplierId());
                return;
            }
            
            // Check if supplier has user account
            if (supplier.getUserId() == 0) {
                System.out.println("⚠️ Supplier '" + supplier.getName() + "' has no user account");
                return;
            }
            
            System.out.println("→ Sending cancellation notification to supplier: " + supplier.getName());
            
            // Prepare notification details
            String notificationTitle = "Purchase Order #" + po.getPoId() + " Cancelled";
            String notificationMessage = "Purchase order #" + po.getPoId() + 
                                       " has been CANCELLED by the pharmacy manager. " +
                                       "Reason: " + reason;
            String notificationType = "warning";
            String priority = "urgent";
            String linkUrl = "/supplier-dashboard";
            
            // Send notification to supplier
            boolean notifSent = notificationDAO.sendNotificationToUser(
                managerId,
                supplier.getUserId(),
                notificationTitle,
                notificationMessage,
                notificationType,
                priority,
                linkUrl
            );
            
            if (notifSent) {
                System.out.println("✅ Cancellation notification sent to " + supplier.getName());
            } else {
                System.out.println("❌ Failed to send cancellation notification");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error sending cancellation notification to supplier: " + e.getMessage());
            e.printStackTrace();
        }
    }
}