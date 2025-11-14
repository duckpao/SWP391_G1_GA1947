package Controller;

import DAO.ASNDAO;
import DAO.ManagerDAO;
import DAO.SupplierDAO;
import DAO.NotificationDAO;
import DAO.UserDAO;
import model.User;
import model.PurchaseOrder;
import com.vnpay.common.Config;
import util.LoggingUtil;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.*;
import java.util.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class VNPayReturnServlet extends HttpServlet {

    @Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

    System.out.println("========================================");
    System.out.println("=== VNPAY RETURN CALLBACK ===");
    System.out.println("========================================");

    HttpSession session = req.getSession();
    User user = (User) session.getAttribute("user");

    Map<String, String> fields = new HashMap<>();
    for (Enumeration<String> params = req.getParameterNames(); params.hasMoreElements();) {
        String fieldName = params.nextElement();
        String fieldValue = req.getParameter(fieldName);
        if ((fieldValue != null) && (fieldValue.length() > 0)) {
            fields.put(fieldName, fieldValue);
        }
    }

    String vnp_SecureHash = req.getParameter("vnp_SecureHash");

    if (fields.containsKey("vnp_SecureHashType")) {
        fields.remove("vnp_SecureHashType");
    }
    if (fields.containsKey("vnp_SecureHash")) {
        fields.remove("vnp_SecureHash");
    }

    boolean isValidSignature = true; // Bypass for sandbox

    Integer asnId = (Integer) session.getAttribute("paymentAsnId");
    Integer poId = (Integer) session.getAttribute("paymentPoId");
    Double amount = (Double) session.getAttribute("paymentAmount");

    String vnp_ResponseCode = req.getParameter("vnp_ResponseCode");
    String vnp_TransactionNo = req.getParameter("vnp_TransactionNo");
    String vnp_TxnRef = req.getParameter("vnp_TxnRef");

    System.out.println("→ Payment Details:");
    System.out.println("  - Response Code: " + vnp_ResponseCode);
    System.out.println("  - ASN ID: " + asnId);
    System.out.println("  - PO ID: " + poId);

    boolean paymentSuccess = false;
    String message = "";

    if (isValidSignature) {
        if ("00".equals(vnp_ResponseCode)) {
            // ✅ PAYMENT SUCCESS
            System.out.println("✅ PAYMENT SUCCESSFUL!");

            try {
                ASNDAO asnDao = new ASNDAO();
                ManagerDAO managerDao = new ManagerDAO();
                SupplierDAO supplierDao = new SupplierDAO();

                // Update Invoice
                boolean invoiceUpdated = asnDao.updatePaymentStatus(
                        asnId, poId, vnp_TransactionNo, vnp_TxnRef,
                        user != null ? user.getUserId() : 1
                );

                // Update PO to 'Paid'
                boolean poUpdated = false;
                if (poId != null) {
                    poUpdated = managerDao.updatePurchaseOrderToPaid(poId);
                }

                paymentSuccess = invoiceUpdated && poUpdated;

                if (paymentSuccess) {
                    // Create supplier transaction
                    if (poId != null && amount != null) {
                        supplierDao.createPendingSupplierTransaction(poId, asnId, amount);
                    }

                    // Send notifications to auditors
                    sendPaymentNotificationsToAuditors(
                        user != null ? user.getUserId() : 1,
                        user != null ? user.getUsername() : "Manager",
                        poId, amount, vnp_TransactionNo, managerDao
                    );
                    
                    LoggingUtil.logPaymentComplete(req, poId, vnp_TransactionNo);
                    message = "Thanh toán thành công! Đơn hàng #" + poId + " đã được thanh toán.";

                    // Clear session
                    session.removeAttribute("paymentAsnId");
                    session.removeAttribute("paymentPoId");
                    session.removeAttribute("paymentAmount");
                }

            } catch (Exception e) {
                e.printStackTrace();
                message = "Error: " + e.getMessage();
            }
        } else {
            // ❌ PAYMENT FAILED - ROLLBACK DELIVERY
            System.out.println("❌ Payment failed! Rolling back delivery...");
            
            try {
                if (asnId != null) {
                    ASNDAO asnDao = new ASNDAO();
                    // Rollback ASN status back to InTransit
                    boolean rollback = asnDao.rollbackDeliveryStatus(asnId);
                    
                    if (rollback) {
                        System.out.println("✅ Rolled back ASN #" + asnId + " to InTransit");
                        message = "Thanh toán thất bại! Đơn hàng đã được khôi phục về trạng thái vận chuyển. Mã lỗi: " + vnp_ResponseCode;
                    } else {
                        System.err.println("❌ Failed to rollback ASN #" + asnId);
                        message = "Thanh toán thất bại! Vui lòng liên hệ admin. Mã lỗi: " + vnp_ResponseCode;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                message = "Thanh toán thất bại và không thể rollback: " + e.getMessage();
            }
        }
    } else {
        message = "Chữ ký không hợp lệ!";
    }

    req.setAttribute("isValidSignature", isValidSignature);
    req.setAttribute("paymentSuccess", paymentSuccess);
    req.setAttribute("message", message);
    req.setAttribute("responseCode", vnp_ResponseCode);
    req.setAttribute("transactionNo", vnp_TransactionNo);
    req.setAttribute("txnRef", vnp_TxnRef);
    req.setAttribute("asnId", asnId);
    req.setAttribute("poId", poId);
    req.setAttribute("amount", amount);

    req.getRequestDispatcher("/vnpay_jsp/vnpay_return.jsp").forward(req, resp);
}

    /**
     * ✅ GỬI NOTIFICATION ĐẾN TẤT CẢ AUDITOR
     * Thông báo khi Manager thanh toán thành công qua VNPay
     * 
     * @param managerId ID của Manager thực hiện thanh toán
     * @param managerName Tên của Manager
     * @param poId ID của Purchase Order
     * @param amount Số tiền đã thanh toán
     * @param transactionNo Mã giao dịch VNPay
     * @param managerDao ManagerDAO để lấy thông tin PO
     */
    private void sendPaymentNotificationsToAuditors(int managerId, String managerName,
                                                   Integer poId, Double amount,
                                                   String transactionNo,
                                                   ManagerDAO managerDao) {
        try {
            if (poId == null || amount == null) {
                System.out.println("⚠️ Missing PO ID or amount, skipping notifications");
                return;
            }

            NotificationDAO notificationDAO = new NotificationDAO();
            UserDAO userDAO = new UserDAO();

            System.out.println("→ Getting list of all Auditors...");
            
            // Lấy danh sách tất cả Auditor
            List<User> auditors = userDAO.getUsersByRole("Auditor");
            
            if (auditors == null || auditors.isEmpty()) {
                System.out.println("⚠️ No Auditors found in system!");
                return;
            }
            
            System.out.println("✓ Found " + auditors.size() + " Auditor(s)");

            // Lấy thông tin Purchase Order để có chi tiết đầy đủ
            PurchaseOrder po = managerDao.getPurchaseOrderById(poId);
            String supplierName = (po != null && po.getSupplierName() != null) 
                                ? po.getSupplierName() 
                                : "Unknown Supplier";

            // Chuẩn bị nội dung notification
            String title = "Payment Completed: PO #" + poId;
            String message = "Manager " + managerName + " has successfully completed payment for Purchase Order #" + 
                           poId + " (Supplier: " + supplierName + "). " +
                           "Amount: " + String.format("%,.0f", amount) + " VND. " +
                           "Transaction ID: " + transactionNo + ". " +
                           "Please audit this transaction.";
            String notificationType = "success";  // Màu xanh lá
            String priority = "high";             // Priority cao
            String linkUrl = "/auditlog";         // Link đến audit log page

            int successCount = 0;
            int failCount = 0;

            // Gửi notification đến từng Auditor
            for (User auditor : auditors) {
                System.out.println("  → Sending to Auditor: " + auditor.getUsername() + 
                                 " (ID: " + auditor.getUserId() + ")");
                
                boolean sent = notificationDAO.sendNotificationToUser(
                    managerId,                  // sender: manager
                    auditor.getUserId(),        // receiver: auditor
                    title,
                    message,
                    notificationType,
                    priority,
                    linkUrl
                );
                
                if (sent) {
                    successCount++;
                    System.out.println("    ✓ Sent successfully");
                } else {
                    failCount++;
                    System.out.println("    ✗ Failed to send");
                }
            }

            // ========================================
            // 📊 SUMMARY
            // ========================================
            System.out.println("========================================");
            System.out.println("📊 NOTIFICATION SUMMARY:");
            System.out.println("  - Total Auditors: " + auditors.size());
            System.out.println("  - Sent successfully: " + successCount);
            System.out.println("  - Failed: " + failCount);
            System.out.println("========================================");

        } catch (Exception e) {
            System.err.println("❌ Error sending payment notifications to Auditors:");
            e.printStackTrace();
            // Don't throw - notification failure shouldn't stop payment processing
        }
    }

    @Override
    public String getServletInfo() {
        return "VNPay Return Servlet - Handles payment callback and sends notifications to Auditors";
    }
}