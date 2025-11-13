package Controller;

import DAO.MedicationRequestDAO;
import DAO.NotificationDAO;
import DAO.UserDAO;
import model.MedicationRequest;
import model.User;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class PharmacistUpdateRequest extends HttpServlet {
    
    private MedicationRequestDAO dao = new MedicationRequestDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        int pharmacistId;
        String pharmacistName;
        try {
            pharmacistId = (Integer) session.getAttribute("userId");
            pharmacistName = (String) session.getAttribute("username");
            if (pharmacistName == null) {
                pharmacistName = "Pharmacist";
            }
        } catch (ClassCastException e) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        String idStr = request.getParameter("requestId");
        
        System.out.println("========================================");
        System.out.println("=== PHARMACIST UPDATE REQUEST ===");
        System.out.println("========================================");
        System.out.println("Pharmacist ID: " + pharmacistId);
        System.out.println("Pharmacist Name: " + pharmacistName);
        System.out.println("Action: " + action);
        System.out.println("Request ID: " + idStr);
        
        if (action == null || idStr == null) {
            System.out.println("❌ ERROR: Missing action or requestId");
            response.sendRedirect(request.getContextPath() + "/pharmacist/View_MedicineRequest");
            return;
        }
        
        int requestId;
        try {
            requestId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            System.out.println("❌ ERROR: Invalid request ID format");
            response.sendRedirect(request.getContextPath() + "/pharmacist/View_MedicineRequest");
            return;
        }
        
        try {
            if (action.equals("approve")) {
                System.out.println("→ Processing APPROVE action...");
                
                // ✅ Lấy thông tin request TRƯỚC KHI approve
                MedicationRequest medRequest = dao.getMedicationRequestById(requestId);
                
                if (medRequest == null) {
                    System.out.println("❌ ERROR: Request not found");
                    session.setAttribute("error", "Không tìm thấy yêu cầu!");
                    response.sendRedirect(request.getContextPath() + "/pharmacist/View_MedicineRequest");
                    return;
                }
                
                System.out.println("→ Request details:");
                System.out.println("  - Doctor ID: " + medRequest.getDoctorId());
                System.out.println("  - Doctor Name: " + medRequest.getDoctorName());
                System.out.println("  - Status: " + medRequest.getStatus());
                System.out.println("  - Item count: " + (medRequest.getItems() != null ? medRequest.getItems().size() : 0));
                
                // ✅ Approve request với xử lý kho đầy đủ
                dao.approveRequestWithInventory(requestId, pharmacistId);
                System.out.println("✓ Request approved successfully with inventory processing!");
                
                // ✅ GỬI NOTIFICATION
                System.out.println("========================================");
                System.out.println("→ Sending notifications...");
                sendApprovalNotifications(pharmacistId, pharmacistName, medRequest);
                System.out.println("========================================");
                
                session.setAttribute("success", "Đã chấp nhận yêu cầu, xuất kho và gửi thông báo thành công!");
                
            } else if (action.equals("reject")) {
                System.out.println("→ Processing REJECT action...");
                
                String reason = request.getParameter("reason");
                
                if (reason == null || reason.trim().isEmpty()) {
                    System.out.println("❌ ERROR: Missing rejection reason");
                    session.setAttribute("error", "Vui lòng nhập lý do từ chối!");
                    response.sendRedirect(request.getContextPath() + "/pharmacist/View_MedicineRequest");
                    return;
                }
                
                System.out.println("  - Reason: " + reason);
                
                // ✅ Lấy thông tin request TRƯỚC KHI reject
                MedicationRequest medRequest = dao.getMedicationRequestById(requestId);
                
                // ✅ Reject request
                boolean success = dao.rejectRequest(requestId, reason);
                
                if (success && medRequest != null) {
                    System.out.println("✓ Request rejected successfully!");
                    
                    // ✅ GỬI NOTIFICATION CHO DOCTOR KHI TỪ CHỐI
                    System.out.println("→ Sending rejection notification to Doctor...");
                    sendRejectionNotification(pharmacistId, pharmacistName, medRequest, reason);
                    
                    session.setAttribute("success", "Đã từ chối yêu cầu và gửi thông báo cho bác sĩ.");
                } else {
                    System.out.println("❌ Failed to reject request");
                    session.setAttribute("error", "Không thể từ chối yêu cầu. Vui lòng thử lại.");
                }
                
            } else {
                System.out.println("❌ ERROR: Invalid action");
                session.setAttribute("error", "Hành động không hợp lệ!");
            }
            
        } catch (SQLException e) {
            System.err.println("❌ SQL EXCEPTION: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("❌ GENERAL EXCEPTION: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("error", "Lỗi không xác định: " + e.getMessage());
        }
        
        System.out.println("========================================");
        System.out.println("=== END PHARMACIST UPDATE REQUEST ===");
        System.out.println("========================================\n");
        
        // Quay lại trang danh sách
        response.sendRedirect(request.getContextPath() + "/pharmacist/View_MedicineRequest");
    }
    
    /**
     * ✅ GỬI NOTIFICATION KHI APPROVE (XUẤT THUỐC)
     * Gửi đến:
     * 1. Doctor (người tạo request)
     * 2. Tất cả Manager (để theo dõi kho)
     */
    private void sendApprovalNotifications(int pharmacistId, String pharmacistName, 
                                          MedicationRequest medRequest) {
        try {
            NotificationDAO notificationDAO = new NotificationDAO();
            UserDAO userDAO = new UserDAO();
            
            int requestId = medRequest.getRequestId();
            int doctorId = medRequest.getDoctorId();
            String doctorName = medRequest.getDoctorName();
            int itemCount = (medRequest.getItems() != null) ? medRequest.getItems().size() : 0;
            
            // ========================================
            // 1️⃣ GỬI CHO DOCTOR (người tạo request)
            // ========================================
            System.out.println("→ Sending notification to Doctor (ID: " + doctorId + ")...");
            
            String doctorTitle = "Medication Request #" + requestId + " Approved";
            String doctorMessage = "Your medication request #" + requestId + 
                                 " has been APPROVED by pharmacist " + pharmacistName + 
                                 ". The medicines (" + itemCount + " items) have been dispensed and are ready for pickup.";
            
            boolean doctorNotifSent = notificationDAO.sendNotificationToUser(
                pharmacistId,           // sender: pharmacist
                doctorId,              // receiver: doctor
                doctorTitle,
                doctorMessage,
                "success",             // type: success (màu xanh lá)
                "high",                // priority: high
                "/view-request-history" // link đến lịch sử request của doctor
            );
            
            if (doctorNotifSent) {
                System.out.println("  ✓ Notification sent to Doctor successfully");
            } else {
                System.out.println("  ✗ Failed to send notification to Doctor");
            }
            
            // ========================================
            // 2️⃣ GỬI CHO TẤT CẢ MANAGER
            // ========================================
            System.out.println("→ Getting list of all Managers...");
            
            List<User> managers = userDAO.getUsersByRole("Manager");
            
            if (managers == null || managers.isEmpty()) {
                System.out.println("⚠️ No Managers found in system!");
                return;
            }
            
            System.out.println("✓ Found " + managers.size() + " Manager(s)");
            
            String managerTitle = "Medicine Dispensed: Request #" + requestId;
            String managerMessage = "Pharmacist " + pharmacistName + 
                                  " has dispensed medicines for medication request #" + requestId + 
                                  " (Doctor: " + doctorName + "). " +
                                  itemCount + " item(s) have been removed from inventory. " +
                                  "Please monitor stock levels.";
            
            int managerSuccessCount = 0;
            int managerFailCount = 0;
            
            for (User manager : managers) {
                System.out.println("  → Sending to Manager: " + manager.getUsername() + 
                                 " (ID: " + manager.getUserId() + ")");
                
                boolean sent = notificationDAO.sendNotificationToUser(
                    pharmacistId,              // sender: pharmacist
                    manager.getUserId(),       // receiver: manager
                    managerTitle,
                    managerMessage,
                    "info",                    // type: info (màu xanh dương)
                    "normal",                  // priority: normal
                    "/manager-dashboard"       // link đến manager dashboard
                );
                
                if (sent) {
                    managerSuccessCount++;
                    System.out.println("    ✓ Sent successfully");
                } else {
                    managerFailCount++;
                    System.out.println("    ✗ Failed to send");
                }
            }
            
            // ========================================
            // 📊 SUMMARY
            // ========================================
            System.out.println("========================================");
            System.out.println("📊 NOTIFICATION SUMMARY:");
            System.out.println("  ✓ Doctor notification: " + (doctorNotifSent ? "SUCCESS" : "FAILED"));
            System.out.println("  - Total Managers: " + managers.size());
            System.out.println("  - Sent successfully: " + managerSuccessCount);
            System.out.println("  - Failed: " + managerFailCount);
            System.out.println("========================================");
            
        } catch (Exception e) {
            System.err.println("❌ Error sending approval notifications:");
            e.printStackTrace();
            // Don't throw - notification failure shouldn't stop main operation
        }
    }
    
    /**
     * ✅ GỬI NOTIFICATION KHI REJECT
     * Chỉ gửi cho Doctor (người tạo request)
     */
    private void sendRejectionNotification(int pharmacistId, String pharmacistName,
                                          MedicationRequest medRequest, String reason) {
        try {
            NotificationDAO notificationDAO = new NotificationDAO();
            
            int requestId = medRequest.getRequestId();
            int doctorId = medRequest.getDoctorId();
            
            System.out.println("→ Sending rejection notification to Doctor (ID: " + doctorId + ")...");
            
            String title = "Medication Request #" + requestId + " Rejected";
            String message = "Your medication request #" + requestId + 
                           " has been REJECTED by pharmacist " + pharmacistName + 
                           ". Reason: " + reason;
            
            boolean sent = notificationDAO.sendNotificationToUser(
                pharmacistId,           // sender: pharmacist
                doctorId,              // receiver: doctor
                title,
                message,
                "warning",             // type: warning (màu vàng/cam)
                "high",                // priority: high
                "/view-request-history" // link
            );
            
            if (sent) {
                System.out.println("  ✓ Rejection notification sent to Doctor");
            } else {
                System.out.println("  ✗ Failed to send rejection notification");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error sending rejection notification:");
            e.printStackTrace();
        }
    }
}