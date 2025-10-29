package Controller;

import DAO.SupplierDAO;
import model.Supplier;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;

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
            response.sendRedirect("supplierDashboard?error=" + 
                URLEncoder.encode("Missing parameters", "UTF-8"));
            return;
        }
        
        try {
            int poId = Integer.parseInt(poIdStr);
            SupplierDAO dao = new SupplierDAO();
            
            // Get supplier info
            Supplier supplier = dao.getSupplierByUserId(userId);
            if (supplier == null) {
                response.sendRedirect("supplierDashboard?error=" + 
                    URLEncoder.encode("Supplier information not found", "UTF-8"));
                return;
            }
            
            boolean success = false;
            String message = "";
            
            if ("approve".equalsIgnoreCase(action)) {
                success = dao.confirmPurchaseOrder(poId, supplier.getSupplierId());
                
                if (success) {
                    message = "Order #" + poId + " has been approved successfully! You can now create a shipping notice.";
                    response.sendRedirect("supplierDashboard?success=" + URLEncoder.encode(message, "UTF-8"));
                } else {
                    message = "Failed to approve order #" + poId + ". Please make sure the order is in 'Sent' status.";
                    response.sendRedirect("supplierDashboard?error=" + URLEncoder.encode(message, "UTF-8"));
                }
                
            } else if ("reject".equalsIgnoreCase(action)) {
                String reason = request.getParameter("reason");
                if (reason == null || reason.trim().isEmpty()) {
                    reason = "No reason provided";
                }
                
                success = dao.rejectPurchaseOrder(poId, supplier.getSupplierId(), reason);
                
                if (success) {
                    message = "Order #" + poId + " has been rejected.";
                    response.sendRedirect("supplierDashboard?success=" + URLEncoder.encode(message, "UTF-8"));
                } else {
                    message = "Failed to reject order #" + poId + ". Please make sure the order is in 'Sent' status.";
                    response.sendRedirect("supplierDashboard?error=" + URLEncoder.encode(message, "UTF-8"));
                }
                
            } else {
                response.sendRedirect("supplierDashboard?error=" + 
                    URLEncoder.encode("Invalid action", "UTF-8"));
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("supplierDashboard?error=" + 
                URLEncoder.encode("Invalid order ID", "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("supplierDashboard?error=" + 
                URLEncoder.encode("An error occurred: " + e.getMessage(), "UTF-8"));
        }
    }
}