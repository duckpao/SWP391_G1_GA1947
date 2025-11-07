/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.ASNDAO;
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

        // Verify signature
        String signValue = Config.hashAllFields(fields);
        boolean isValidSignature = signValue.equals(vnp_SecureHash);

        System.out.println("Signature Valid: " + isValidSignature);

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
                    ASNDAO dao = new ASNDAO();

                    // Update Invoice and PO
                    paymentSuccess = dao.updatePaymentStatus(
                            asnId, poId, vnp_TransactionNo, vnp_TxnRef,
                            user != null ? user.getUserId() : 1
                    );

                    if (paymentSuccess) {
                        message = "Thanh toán thành công!";

                        // Clear session
                        session.removeAttribute("paymentAsnId");
                        session.removeAttribute("paymentPoId");
                        session.removeAttribute("paymentAmount");
                    } else {
                        message = "Lỗi cập nhật database!";
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
