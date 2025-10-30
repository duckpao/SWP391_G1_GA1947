package Controller;

import DAO.ManagerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Manager;
import model.PurchaseOrder;
import model.PurchaseOrderItem;
import model.StockAlert;
import model.Medicine;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ManagerDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("========================================");
        System.out.println("MANAGER DASHBOARD - START");
        System.out.println("========================================");

        HttpSession session = request.getSession(false);

        // ❌ Nếu chưa đăng nhập hoặc không có role
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");
        String path = request.getServletPath();

        System.out.println("User ID: " + userId);
        System.out.println("Role: " + role);

        // ✅ Role access control
        if ("Admin".equals(role)) {
            System.out.println("Access granted: Admin role (full access).");
        } else if ("Manager".equals(role)) {
            System.out.println("Access granted: Manager role.");
        } else if ("Doctor".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/doctor-dashboard");
            return;
        } else if ("Pharmacist".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/pharmacist-dashboard");
            return;
        } else if ("Auditor".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/auditor-dashboard");
            return;
        } else if ("Supplier".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/supplier-dashboard");
            return;
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // ===============================
        // ✅ Logic xử lý gốc bên dưới
        // ===============================
        ManagerDAO dao = new ManagerDAO();

        // ⚙️ Lấy thông tin Manager theo userId
        Manager manager = dao.getManagerById(userId);

        // ✅ Nếu không tìm thấy manager, nhưng role là Admin → tạo giả lập
        if (manager == null && "Admin".equals(role)) {
            manager = new Manager();
            manager.setUsername("System Administrator");
            System.out.println("No manager record found for Admin; using placeholder manager.");
        }

        // ❌ Nếu không tìm thấy manager và KHÔNG PHẢI admin → quay về login
        if (manager == null && !"Admin".equals(role)) {
            System.out.println("Manager not found for userId: " + userId);
            session.setAttribute("message", "Manager not found.");
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        System.out.println("✅ Manager loaded: " + manager.getUsername());

        // Load dữ liệu dashboard
        String warehouseStatus = dao.getWarehouseStatus();
        List<StockAlert> stockAlerts = dao.getStockAlerts();
        List<PurchaseOrder> pendingRequests = dao.getPendingStockRequests();

        List<Medicine> allMedicines = dao.getAllMedicines();
        Map<String, Medicine> medicineMap = new HashMap<>();
        for (Medicine med : allMedicines) {
            medicineMap.put(med.getMedicineCode(), med);
        }

        Map<Integer, List<PurchaseOrderItem>> poItemsMap = new HashMap<>();
        for (PurchaseOrder po : pendingRequests) {
            List<PurchaseOrderItem> items = dao.getPurchaseOrderItems(po.getPoId());
            poItemsMap.put(po.getPoId(), items);
        }

        // Set attributes cho JSP
        request.setAttribute("manager", manager);
        request.setAttribute("warehouseStatus", warehouseStatus);
        request.setAttribute("stockAlerts", stockAlerts);
        request.setAttribute("pendingRequests", pendingRequests);
        request.setAttribute("poItemsMap", poItemsMap);
        request.setAttribute("medicineMap", medicineMap);

        System.out.println("=== FORWARDING TO manager-dashboard.jsp ===");
        request.getRequestDispatcher("manager-dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
