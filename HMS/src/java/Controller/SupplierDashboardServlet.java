package Controller;

import DAO.SupplierDAO;
import DAO.ASNDAO;
import model.PurchaseOrder;
import model.Supplier;
import model.AdvancedShippingNotice;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import model.SupplierTransaction;

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
        
        SupplierDAO supplierDAO = new SupplierDAO();
        ASNDAO asnDAO = new ASNDAO();
        
        // Lấy thông tin supplier
        Supplier supplier = supplierDAO.getSupplierByUserId(userId);
        if (supplier == null) {
            request.setAttribute("error", "Supplier information not found!");
            request.getRequestDispatcher("/jsp/error.jsp").forward(request, response);
            return;
        }
        
        System.out.println("Supplier ID: " + supplier.getSupplierId());
        System.out.println("Supplier Name: " + supplier.getName());
        
        // Lấy các Purchase Orders
        List<PurchaseOrder> pendingOrders = supplierDAO.getPurchaseOrdersBySupplier(
            supplier.getSupplierId(), "Sent");
        List<PurchaseOrder> approvedOrders = supplierDAO.getPurchaseOrdersBySupplier(
            supplier.getSupplierId(), "Approved");
// ✅ THAY ĐỔI NÀY: Sử dụng method mới để lấy cả Completed và BatchCreated
List<PurchaseOrder> completedOrders = supplierDAO.getCompletedOrdersBySupplier(
    supplier.getSupplierId());
        
        // Lấy tất cả ASNs của supplier
        List<AdvancedShippingNotice> allASNs = asnDAO.getASNsBySupplier(supplier.getSupplierId());
        
        // Phân loại ASNs theo status
        List<AdvancedShippingNotice> pendingASNs = asnDAO.getASNsByStatus(
            supplier.getSupplierId(), "Pending");
        List<AdvancedShippingNotice> sentASNs = asnDAO.getASNsByStatus(
            supplier.getSupplierId(), "Sent");
        List<AdvancedShippingNotice> inTransitASNs = asnDAO.getASNsByStatus(
            supplier.getSupplierId(), "InTransit");
        List<AdvancedShippingNotice> deliveredASNs = asnDAO.getASNsByStatus(
            supplier.getSupplierId(), "Delivered");
        
        // ✅ NEW: Get pending transactions
        List<SupplierTransaction> pendingTransactions = supplierDAO.getPendingTransactions(supplier.getSupplierId());

        // ✅ NEW: Get supplier balance
        double balance = supplierDAO.getSupplierBalance(supplier.getSupplierId());
        
        // Lấy thống kê
        Map<String, Object> stats = supplierDAO.getSupplierStats(supplier.getSupplierId());
        
        // Thêm thống kê ASN
        Map<String, Integer> asnStats = new HashMap<>();
        asnStats.put("pendingCount", pendingASNs.size());
        asnStats.put("sentCount", sentASNs.size());
        asnStats.put("inTransitCount", inTransitASNs.size());
        asnStats.put("deliveredCount", deliveredASNs.size());
        asnStats.put("totalASNs", allASNs.size());
        
        // Tạo Map để kiểm tra PO nào đã có ASN
        Map<Integer, Boolean> poHasASN = new HashMap<>();
        for (PurchaseOrder order : approvedOrders) {
            poHasASN.put(order.getPoId(), asnDAO.hasASNForPO(order.getPoId()));
        }
        
        System.out.println("=== STATISTICS ===");
        System.out.println("Pending Orders: " + pendingOrders.size());
        System.out.println("Approved Orders: " + approvedOrders.size());
        System.out.println("Completed Orders: " + completedOrders.size());
        System.out.println("Total ASNs: " + allASNs.size());
        System.out.println("Pending ASNs: " + pendingASNs.size());
        System.out.println("In Transit ASNs: " + inTransitASNs.size());
        System.out.println("Delivered ASNs: " + deliveredASNs.size());
        
        // Set attributes
        request.setAttribute("supplier", supplier);
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("approvedOrders", approvedOrders);
        request.setAttribute("completedOrders", completedOrders);
        request.setAttribute("stats", stats);
        request.setAttribute("poHasASN", poHasASN);
        
        // ASN data
        request.setAttribute("allASNs", allASNs);
        request.setAttribute("pendingASNs", pendingASNs);
        request.setAttribute("sentASNs", sentASNs);
        request.setAttribute("inTransitASNs", inTransitASNs);
        request.setAttribute("deliveredASNs", deliveredASNs);
        request.setAttribute("asnStats", asnStats);
        request.setAttribute("pendingTransactions", pendingTransactions);
        request.setAttribute("supplierBalance", balance);
        
        request.getRequestDispatcher("/supplierDashboard.jsp").forward(request, response);
    }
}