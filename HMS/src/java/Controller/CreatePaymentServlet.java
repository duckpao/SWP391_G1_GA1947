package Controller;

import DAO.InvoiceDAO;
import model.Invoice;
import util.MoMoUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class CreatePaymentServlet extends HttpServlet {
    private InvoiceDAO invoiceDAO;
    
    @Override
    public void init() {
        invoiceDAO = new InvoiceDAO();
    }
    
    // ✅ HỖ TRỢ GET REQUEST (từ redirect)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processPayment(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processPayment(request, response);
    }
    
    private void processPayment(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String invoiceIdStr = request.getParameter("invoiceId");
            
            if (invoiceIdStr == null || invoiceIdStr.trim().isEmpty()) {
                request.setAttribute("error", "Invoice ID is required!");
                request.getRequestDispatcher("/payment-failed.jsp").forward(request, response);
                return;
            }
            
            int invoiceId = Integer.parseInt(invoiceIdStr);
            
            // Lấy thông tin hóa đơn
            Invoice invoice = invoiceDAO.getInvoiceById(invoiceId);
            
            if (invoice == null) {
                request.setAttribute("error", "Không tìm thấy hóa đơn #" + invoiceId);
                request.getRequestDispatcher("/payment-failed.jsp").forward(request, response);
                return;
            }
            
            if (!"Pending".equals(invoice.getStatus())) {
                request.setAttribute("error", "Hóa đơn #" + invoiceId + " đã được thanh toán hoặc không hợp lệ!");
                request.getRequestDispatcher("/payment-failed.jsp").forward(request, response);
                return;
            }
            
            // Chuyển đổi amount sang long (VNĐ)
            long amount = invoice.getAmount().longValue();
            
            System.out.println("====================================");
            System.out.println("Creating payment for Invoice #" + invoiceId);
            System.out.println("Amount: " + amount + " VND");
            System.out.println("Status: " + invoice.getStatus());
            System.out.println("====================================");
            
            // Tạo link thanh toán MoMo
            String payUrl = MoMoUtil.createPaymentLink(invoiceId, amount);
            
            // Lưu payment URL vào database
            invoiceDAO.updatePaymentUrl(invoiceId, payUrl);
            
            // Redirect đến trang thanh toán MoMo
            response.sendRedirect(payUrl);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invoice ID không hợp lệ!");
            request.getRequestDispatcher("/payment-failed.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/payment-failed.jsp").forward(request, response);
        }
    }
}