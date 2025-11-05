package Controller;

import DAO.ASNDAO;
import DAO.InvoiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import model.Invoice;

public class PaymentCallbackServlet extends HttpServlet {
    private InvoiceDAO invoiceDAO;
    
    @Override
    public void init() {
        invoiceDAO = new InvoiceDAO();
    }
    
    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
    // Lấy thông tin từ MoMo callback
    String orderId = request.getParameter("orderId");
    String message = request.getParameter("message");
    String resultCode = request.getParameter("resultCode");
    String transId = request.getParameter("transId");
    String amount = request.getParameter("amount");
    
    System.out.println("=== MoMo Callback ===");
    System.out.println("OrderId: " + orderId);
    System.out.println("ResultCode: " + resultCode);
    System.out.println("Message: " + message);
    System.out.println("TransId: " + transId);
    
    try {
        int invoiceId = extractInvoiceId(orderId);
        
        if ("0".equals(resultCode)) {
            // ✅ Thanh toán thành công
            boolean updated = invoiceDAO.updatePaymentStatus(invoiceId, "Paid", transId);
            
            if (updated) {
                // ✅ LẤY THÔNG TIN INVOICE ĐỂ CẬP NHẬT PO
                Invoice invoice = invoiceDAO.getInvoiceById(invoiceId);
                
                if (invoice != null && invoice.getPoId() > 0) {
                    // ✅ CẬP NHẬT PO THÀNH COMPLETED
                    ASNDAO asnDAO = new ASNDAO();
                    asnDAO.updatePOStatus(invoice.getPoId(), "Completed");
                    
                    System.out.println("✅ PO #" + invoice.getPoId() + " updated to Completed");
                }
                
                request.setAttribute("success", true);
                request.setAttribute("message", "Thanh toán thành công!");
                request.setAttribute("invoiceId", invoiceId);
                request.setAttribute("transactionId", transId);
                request.setAttribute("amount", amount);
                request.getRequestDispatcher("/payment-success.jsp").forward(request, response);
            } else {
                throw new Exception("Không thể cập nhật trạng thái hóa đơn");
            }
        } else {
            // ❌ Thanh toán thất bại
            request.setAttribute("success", false);
            request.setAttribute("error", message);
            request.setAttribute("resultCode", resultCode);
            request.getRequestDispatcher("/payment-failed.jsp").forward(request, response);
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        request.getRequestDispatcher("/payment-failed.jsp").forward(request, response);
    }
}

private int extractInvoiceId(String orderId) throws NumberFormatException {
    // Format: INV_123_1234567890 -> Extract 123
    String[] parts = orderId.split("_");
    if (parts.length >= 2) {
        return Integer.parseInt(parts[1]);
    }
    throw new NumberFormatException("Invalid orderId format: " + orderId);
}
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // IPN endpoint (webhook from MoMo server)
        doGet(request, response);
    }
}