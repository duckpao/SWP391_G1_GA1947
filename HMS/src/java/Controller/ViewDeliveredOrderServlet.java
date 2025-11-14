package Controller;

import DAO.PurchaseOrderDAO;
import model.PurchaseOrder;
import model.PurchaseOrderItem;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * ✅ Hiển thị danh sách đơn hàng ĐÃ GIAO (Completed status)
 * FIXED: Load items cho mỗi đơn hàng
 */
public class ViewDeliveredOrderServlet extends HttpServlet {
    
    private PurchaseOrderDAO orderDAO = new PurchaseOrderDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("====================================");
        System.out.println("ViewDeliveredOrderServlet - Loading delivered orders");
        System.out.println("====================================");
        
        try {
            // ✅ Lấy danh sách đơn hàng với status = 'Completed' 
            // (Chưa chuyển sang 'BatchCreated')
            List<PurchaseOrder> deliveredOrders = orderDAO.getDeliveredOrders();
            
            System.out.println("Total orders found: " + deliveredOrders.size());
            
            // ✅ CRITICAL FIX: Load items cho MỖI đơn hàng
            for (PurchaseOrder order : deliveredOrders) {
                List<PurchaseOrderItem> items = orderDAO.getItemsByPurchaseOrderId(order.getPoId());
                order.setItems(items);
                
                System.out.println("PO #" + order.getPoId() + 
                                   " - Status: " + order.getStatus() + 
                                   " - Supplier: " + order.getSupplierName() +
                                   " - Items: " + items.size());
                
                // Debug items
                for (PurchaseOrderItem item : items) {
                    System.out.println("  └─ " + item.getMedicineName() + 
                                     " x" + item.getQuantity() + 
                                     " (" + item.getMedicineCode() + ")");
                }
            }
            
            // ✅ Set attributes cho JSP
            request.setAttribute("deliveredOrders", deliveredOrders);
            request.setAttribute("totalOrders", deliveredOrders.size());
            
            // Hiển thị message từ session
            HttpSession session = request.getSession(false);
            if (session != null) {
                String successMsg = (String) session.getAttribute("successMessage");
                String errorMsg = (String) session.getAttribute("errorMessage");
                
                if (successMsg != null) {
                    request.setAttribute("successMessage", successMsg);
                    session.removeAttribute("successMessage");
                }
                
                if (errorMsg != null) {
                    request.setAttribute("errorMessage", errorMsg);
                    session.removeAttribute("errorMessage");
                }
            }
            
            System.out.println("Forwarding to JSP with " + deliveredOrders.size() + " orders");
            System.out.println("====================================");
            
            request.getRequestDispatcher("/pharmacist/ViewDeliveredOrder.jsp")
                   .forward(request, response);
                   
        } catch (SQLException e) {
            System.err.println("❌ SQL Error: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("errorMessage", "Lỗi database: " + e.getMessage());
            request.setAttribute("deliveredOrders", List.of());
            request.getRequestDispatcher("/pharmacist/ViewDeliveredOrder.jsp")
                   .forward(request, response);
                   
        } catch (Exception e) {
            System.err.println("❌ General Error: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            request.setAttribute("deliveredOrders", List.of());
            request.getRequestDispatcher("/pharmacist/ViewDeliveredOrder.jsp")
                   .forward(request, response);
        }
    }
}