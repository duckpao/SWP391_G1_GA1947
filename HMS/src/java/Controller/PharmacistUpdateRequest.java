package Controller;

import DAO.MedicationRequestDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class PharmacistUpdateRequest extends HttpServlet {

@Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    String action = request.getParameter("action");
    String requestIdStr = request.getParameter("requestId");
    
    if (requestIdStr == null || requestIdStr.isEmpty()) {
        request.getSession().setAttribute("error", "Request ID không hợp lệ!");
        response.sendRedirect(request.getContextPath() + "/pharmacist/View_MedicineRequest");
        return;
    }
    
    int requestId = Integer.parseInt(requestIdStr);
    MedicationRequestDAO dao = new MedicationRequestDAO();
    
    try {
        if ("approve".equals(action)) {
            HttpSession session = request.getSession();
            Integer pharmacistId = (Integer) session.getAttribute("userId");
            
            if (pharmacistId == null) {
                session.setAttribute("error", "Không tìm thấy thông tin Pharmacist!");
                response.sendRedirect(request.getContextPath() + "/pharmacist/View_MedicineRequest");
                return;
            }
            
            // ✅ THÊM TIMEOUT HANDLER
            System.out.println("🔄 Starting approval process for request #" + requestId);
            long startTime = System.currentTimeMillis();
            
            dao.approveRequestWithInventory(requestId, pharmacistId);
            
            long duration = System.currentTimeMillis() - startTime;
            System.out.println("✅ Approval completed in " + duration + "ms");
            
            session.setAttribute("success", "✅ Đã CHẤP NHẬN yêu cầu #" + requestId + " thành công! Phiếu xuất đã được tạo.");
            
        } else if ("reject".equals(action)) {
            String reason = request.getParameter("reason");
            
            if (reason == null || reason.trim().isEmpty()) {
                request.getSession().setAttribute("error", "Phải nhập lý do từ chối!");
            } else {
                boolean success = dao.rejectRequest(requestId, reason);
                if (success) {
                    request.getSession().setAttribute("success", "✅ Đã TỪ CHỐI yêu cầu #" + requestId);
                } else {
                    request.getSession().setAttribute("error", "Không thể từ chối yêu cầu!");
                }
            }
        }
    } catch (java.sql.SQLTimeoutException e) {
        System.err.println("⏱️ Timeout: " + e.getMessage());
        request.getSession().setAttribute("error", "❌ Xử lý quá lâu! Vui lòng thử lại.");
    } catch (Exception e) {
        System.err.println("❌ Unexpected error: " + e.getMessage());
        e.printStackTrace();
        request.getSession().setAttribute("error", "❌ Lỗi không xác định: " + e.getMessage());
    }
    
    response.sendRedirect(request.getContextPath() + "/pharmacist/View_MedicineRequest");
}

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}