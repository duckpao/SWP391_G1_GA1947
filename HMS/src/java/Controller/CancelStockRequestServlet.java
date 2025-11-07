package Controller;

import DAO.ManagerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class CancelStockRequestServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // ✅ Kiểm tra đăng nhập
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login");
            return;
        }
        
        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");
        
        // ✅ Kiểm tra quyền: Chỉ Manager và Admin
        if (!"Manager".equals(role) && !"Admin".equals(role)) {
            session.setAttribute("message", "You don't have permission to cancel stock requests.");
            session.setAttribute("messageType", "error");
            response.sendRedirect("manager-dashboard");
            return;
        }
        
        try {
            // ✅ Lấy tham số
            String poIdStr = request.getParameter("poId");
            String reason = request.getParameter("reason");
            
            System.out.println("========================================");
            System.out.println("CANCEL STOCK REQUEST - SERVLET");
            System.out.println("User ID: " + userId);
            System.out.println("User Role: " + role);
            System.out.println("PO ID (raw): " + poIdStr);
            System.out.println("Reason: " + reason);
            System.out.println("========================================");
            
            // ✅ Validate PO ID
            if (poIdStr == null || poIdStr.trim().isEmpty()) {
                session.setAttribute("message", "Invalid PO ID.");
                session.setAttribute("messageType", "error");
                response.sendRedirect("manager-dashboard");
                return;
            }
            
            int poId = Integer.parseInt(poIdStr.trim());
            
            // ✅ Validate reason
            if (reason == null || reason.trim().isEmpty()) {
                reason = "No reason provided by " + session.getAttribute("username");
            } else {
                reason = reason.trim() + " (by " + session.getAttribute("username") + ")";
            }
            
            // ✅ Kiểm tra xem PO có thể cancel không
            ManagerDAO dao = new ManagerDAO();
            
            if (!dao.canCancelPurchaseOrder(poId)) {
                session.setAttribute("message", 
                    "Cannot cancel PO #" + poId + ". It must be in 'Sent' status.");
                session.setAttribute("messageType", "warning");
                response.sendRedirect("manager-dashboard");
                return;
            }
            
            // ✅ Thực hiện cancel
            boolean success = dao.cancelStockRequest(poId, reason);
            
            System.out.println("========================================");
            System.out.println("CANCEL RESULT");
            System.out.println("PO ID: " + poId);
            System.out.println("Success: " + success);
            System.out.println("========================================");
            
            // ✅ Thông báo kết quả
            if (success) {
                session.setAttribute("message", 
                    "Stock request #" + poId + " has been cancelled successfully.");
                session.setAttribute("messageType", "success");
            } else {
                session.setAttribute("message", 
                    "Failed to cancel stock request #" + poId + 
                    ". Please check the console for details.");
                session.setAttribute("messageType", "error");
            }
            
        } catch (NumberFormatException e) {
            System.err.println("Invalid PO ID format: " + e.getMessage());
            session.setAttribute("message", "Invalid PO ID format.");
            session.setAttribute("messageType", "error");
        } catch (Exception e) {
            System.err.println("Error cancelling stock request: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("message", 
                "An error occurred while cancelling the request: " + e.getMessage());
            session.setAttribute("messageType", "error");
        }
        
        // ✅ Redirect về dashboard
        response.sendRedirect("manager-dashboard");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, 
            "GET method is not supported. Use POST to cancel orders.");
    }
}