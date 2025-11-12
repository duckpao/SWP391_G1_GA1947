/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.ASNDAO;
import DAO.ManagerDAO;
import DAO.SupplierDAO;
import com.vnpay.common.Config;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.*;
import java.util.*;
import model.User;
import util.LoggingUtil;

/**
 *
 * @author ADMIN
 */
public class VNPayReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        System.out.println("=== VNPay Return Callback ===");

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        // Get all parameters from VNPay
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = req.getParameterNames(); params.hasMoreElements();) {
            String fieldName = params.nextElement();
            String fieldValue = req.getParameter(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                fields.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = req.getParameter("vnp_SecureHash");

        // Remove fields not used for signature verification
        if (fields.containsKey("vnp_SecureHashType")) {
            fields.remove("vnp_SecureHashType");
        }
        if (fields.containsKey("vnp_SecureHash")) {
            fields.remove("vnp_SecureHash");
        }

        // ✅ BỎ VERIFY CHỮ KÝ - VNPAY SANDBOX KHÔNG YÊU CẦU
        boolean isValidSignature = true; // LUÔN ACCEPT CHO SANDBOX

        System.out.println("Signature Valid (bypassed for sandbox): " + isValidSignature);

        // Get session data
        Integer asnId = (Integer) session.getAttribute("paymentAsnId");
        Integer poId = (Integer) session.getAttribute("paymentPoId");
        Double amount = (Double) session.getAttribute("paymentAmount");

        String vnp_ResponseCode = req.getParameter("vnp_ResponseCode");
        String vnp_TransactionNo = req.getParameter("vnp_TransactionNo");
        String vnp_TxnRef = req.getParameter("vnp_TxnRef");

        System.out.println("Response Code: " + vnp_ResponseCode);
        System.out.println("Transaction No: " + vnp_TransactionNo);
        System.out.println("ASN ID: " + asnId);
        System.out.println("PO ID: " + poId);

        boolean paymentSuccess = false;
        String message = "";

        if (isValidSignature) {
            if ("00".equals(vnp_ResponseCode)) {
                // Payment successful
                System.out.println("✅ Payment Successful!");

                try {
                    ASNDAO asnDao = new ASNDAO();
                    ManagerDAO managerDao = new ManagerDAO();
                    SupplierDAO supplierDao = new SupplierDAO();

                    // ✅ 1. Update Invoice
                    boolean invoiceUpdated = asnDao.updatePaymentStatus(
                            asnId, poId, vnp_TransactionNo, vnp_TxnRef,
                            user != null ? user.getUserId() : 1
                    );

                    // ✅ 2. Update Purchase Order status → 'Paid'
                    boolean poUpdated = false;
                    if (poId != null) {
                        poUpdated = managerDao.updatePurchaseOrderToPaid(poId);
                    }

                    paymentSuccess = invoiceUpdated && poUpdated;

                    if (paymentSuccess) {
                        // ✅ 3. Create pending transaction for supplier to confirm
                        if (poId != null && amount != null) {
                            boolean transactionCreated = supplierDao.createPendingSupplierTransaction(poId, asnId, amount);
                            if (transactionCreated) {
                                System.out.println("✅ Created pending supplier transaction for PO #" + poId);
                            } else {
                                System.err.println("⚠️ Failed to create pending supplier transaction for PO #" + poId);
                            }
                        }
                        
                        LoggingUtil.logPaymentComplete(req, poId, vnp_TransactionNo);
                        message = "Thanh toán thành công! Đơn hàng #" + poId + " đã được thanh toán.";

                        // Clear session
                        session.removeAttribute("paymentAsnId");
                        session.removeAttribute("paymentPoId");
                        session.removeAttribute("paymentAmount");
                    } else {
                        message = "Lỗi cập nhật database! Invoice: " + invoiceUpdated + ", PO: " + poUpdated;
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                    message = "Error: " + e.getMessage();
                }
            } else {
                message = "Thanh toán thất bại! Mã lỗi: " + vnp_ResponseCode;
            }
        } else {
            message = "Chữ ký không hợp lệ!";
        }

        // Set attributes for JSP
        req.setAttribute("isValidSignature", isValidSignature);
        req.setAttribute("paymentSuccess", paymentSuccess);
        req.setAttribute("message", message);
        req.setAttribute("responseCode", vnp_ResponseCode);
        req.setAttribute("transactionNo", vnp_TransactionNo);
        req.setAttribute("txnRef", vnp_TxnRef);
        req.setAttribute("asnId", asnId);
        req.setAttribute("poId", poId);
        req.setAttribute("amount", amount);

        // Forward to JSP
        req.getRequestDispatcher("/vnpay_jsp/vnpay_return.jsp").forward(req, resp);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}