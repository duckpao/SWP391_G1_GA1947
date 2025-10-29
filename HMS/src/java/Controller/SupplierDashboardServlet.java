package Controller;

import DAO.SupplierDAO;
import model.PurchaseOrder;
import model.PurchaseOrderItem;
import model.Supplier;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

public class SupplierDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"Supplier".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        System.out.println("=== SUPPLIER DASHBOARD ===");
        System.out.println("User ID: " + userId);

        SupplierDAO dao = new SupplierDAO();
        
        // Lấy thông tin supplier
        Supplier supplier = dao.getSupplierByUserId(userId);
        if (supplier == null) {
            request.setAttribute("error", "Supplier information not found!");
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
            return;
        }

        System.out.println("Supplier ID: " + supplier.getSupplierId());
        System.out.println("Supplier Name: " + supplier.getName());

        // Lấy các Purchase Orders theo supplier
        List<PurchaseOrder> pendingOrders = dao.getPurchaseOrdersBySupplier(supplier.getSupplierId(), "Sent");
        List<PurchaseOrder> approvedOrders = dao.getPurchaseOrdersBySupplier(supplier.getSupplierId(), "Approved");
        List<PurchaseOrder> completedOrders = dao.getPurchaseOrdersBySupplier(supplier.getSupplierId(), "Completed");
        
        // Lấy thống kê
        Map<String, Object> stats = dao.getSupplierStats(supplier.getSupplierId());

        System.out.println("Pending Orders: " + pendingOrders.size());
        System.out.println("Approved Orders: " + approvedOrders.size());
        System.out.println("Completed Orders: " + completedOrders.size());

        request.setAttribute("supplier", supplier);
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("approvedOrders", approvedOrders);
        request.setAttribute("completedOrders", completedOrders);
        request.setAttribute("stats", stats);

        request.getRequestDispatcher("/supplierDashboard.jsp").forward(request, response);
    }
}