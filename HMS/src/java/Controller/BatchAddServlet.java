package Controller;

import DAO.PurchaseOrderDAO;
import DAO.BatchDAO;
import model.PurchaseOrder;
import model.PurchaseOrderItem;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * ✅ Servlet thêm lô thuốc từ Purchase Order
 * FIXED: Cho phép thêm nhiều lần (mỗi lần 1 lô mới)
 */
public class BatchAddServlet extends HttpServlet {
    
    private PurchaseOrderDAO orderDAO = new PurchaseOrderDAO();
    private BatchDAO batchDAO = new BatchDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String poIdStr = request.getParameter("poId");
        
        if (poIdStr == null || poIdStr.isEmpty()) {
            request.setAttribute("errorMessage", "Thiếu thông tin đơn hàng!");
            request.getRequestDispatcher("/pharmacist/ViewDeliveredOrder")
                   .forward(request, response);
            return;
        }
        
        try {
            int poId = Integer.parseInt(poIdStr);
            
            System.out.println("====================================");
            System.out.println("BatchAddServlet - Loading PO #" + poId);
            System.out.println("====================================");
            
            // ✅ Lấy thông tin đơn hàng và items
            PurchaseOrder order = orderDAO.getPurchaseOrderById(poId);
            
            if (order == null) {
                request.setAttribute("errorMessage", "Không tìm thấy đơn hàng #" + poId);
                request.getRequestDispatcher("/pharmacist/ViewDeliveredOrder")
                       .forward(request, response);
                return;
            }
            
            // ✅ Load items
            List<PurchaseOrderItem> items = orderDAO.getItemsByPurchaseOrderId(poId);
            order.setItems(items);
            
            System.out.println("Loaded PO #" + poId + " with " + items.size() + " items");
            for (PurchaseOrderItem item : items) {
                System.out.println("  └─ " + item.getMedicineName() + " x" + item.getQuantity());
            }
            
            // ✅ REMOVED: Check hasOrderCreatedBatches()
            // Cho phép tạo nhiều lô từ cùng 1 đơn
            
            request.setAttribute("order", order);
            request.setAttribute("items", items);
            
            System.out.println("Forwarding to batch-add.jsp");
            System.out.println("====================================");
            
            request.getRequestDispatcher("/pharmacist/add_batch_form.jsp")
                   .forward(request, response);
            
        } catch (NumberFormatException e) {
            System.err.println("Invalid PO ID: " + poIdStr);
            request.setAttribute("errorMessage", "Mã đơn hàng không hợp lệ!");
            request.getRequestDispatcher("/pharmacist/ViewDeliveredOrder")
                   .forward(request, response);
                   
        } catch (Exception e) {
            System.err.println("Error loading PO: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("errorMessage", "Lỗi khi tải đơn hàng: " + e.getMessage());
            request.getRequestDispatcher("/pharmacist/ViewDeliveredOrder")
                   .forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String poIdStr = request.getParameter("poId");
        String medicineCode = request.getParameter("medicineCode");
        String quantityStr = request.getParameter("quantity");
        String expiryDateStr = request.getParameter("expiryDate");
        String notes = request.getParameter("notes");
        
        System.out.println("====================================");
        System.out.println("BatchAddServlet POST - Creating batch");
        System.out.println("PO ID: " + poIdStr);
        System.out.println("Medicine: " + medicineCode);
        System.out.println("Quantity: " + quantityStr);
        System.out.println("Expiry: " + expiryDateStr);
        System.out.println("====================================");
        
        HttpSession session = request.getSession();
        
        try {
            // Validate inputs
            if (poIdStr == null || medicineCode == null || quantityStr == null || expiryDateStr == null) {
                session.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin!");
                response.sendRedirect(request.getContextPath() + "/pharmacist/Batch-Add?poId=" + poIdStr);
                return;
            }
            
            int poId = Integer.parseInt(poIdStr);
            int quantity = Integer.parseInt(quantityStr);
            java.sql.Date expiryDate = java.sql.Date.valueOf(expiryDateStr);
            java.sql.Date receivedDate = new java.sql.Date(System.currentTimeMillis());
            
            // Validate expiry date
            if (expiryDate.before(receivedDate)) {
                session.setAttribute("errorMessage", "Ngày hết hạn phải sau ngày hiện tại!");
                response.sendRedirect(request.getContextPath() + "/pharmacist/Batch-Add?poId=" + poId);
                return;
            }
            
            // Get order info
            PurchaseOrder order = orderDAO.getPurchaseOrderById(poId);
            if (order == null) {
                session.setAttribute("errorMessage", "Không tìm thấy đơn hàng!");
                response.sendRedirect(request.getContextPath() + "/pharmacist/ViewDeliveredOrder");
                return;
            }
            
            int supplierId = order.getSupplierId();
            
            // ✅ Insert batch
            boolean success = batchDAO.insertBatchFromPO(
                poId, medicineCode, supplierId, quantity, receivedDate, expiryDate
            );
            
            if (success) {
                System.out.println("✅ Batch created successfully for PO #" + poId);
                session.setAttribute("successMessage", "Đã tạo lô thuốc thành công!");
                
                // ✅ OPTIONAL: Update PO status to 'BatchCreated'
                // orderDAO.updateOrderStatusToBatchCreated(poId);
                
            } else {
                System.err.println("❌ Failed to create batch");
                session.setAttribute("errorMessage", "Không thể tạo lô thuốc!");
            }
            
            // ✅ Redirect về trang thêm lô (cho phép thêm lô tiếp)
            response.sendRedirect(request.getContextPath() + "/pharmacist/Batch-Add?poId=" + poId);
            
        } catch (NumberFormatException e) {
            System.err.println("Invalid input: " + e.getMessage());
            session.setAttribute("errorMessage", "Dữ liệu nhập không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/pharmacist/Batch-Add?poId=" + poIdStr);
            
        } catch (IllegalArgumentException e) {
            System.err.println("Invalid date format: " + e.getMessage());
            session.setAttribute("errorMessage", "Định dạng ngày không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/pharmacist/Batch-Add?poId=" + poIdStr);
            
        } catch (Exception e) {
            System.err.println("Error creating batch: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pharmacist/Batch-Add?poId=" + poIdStr);
        }
    }
}