package Controller;

import DAO.ManagerDAO;
<<<<<<< HEAD
=======
import model.Manager;
>>>>>>> 4645b2a (tam)
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
<<<<<<< HEAD
import model.Manager;
import model.PurchaseOrder;
import model.PurchaseOrderItem;
import model.StockAlert;
import model.Medicine;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ManagerDashboardServlet", urlPatterns = {"/manager-dashboard"})
public class ManagerDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
=======
import java.io.IOException;

public class ManagerDashboardServlet extends HttpServlet {
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
>>>>>>> 4645b2a (tam)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");
<<<<<<< HEAD

=======
        
>>>>>>> 4645b2a (tam)
        if (!"Manager".equals(role) || userId == null) {
            response.sendRedirect("login");
            return;
        }
<<<<<<< HEAD

        ManagerDAO dao = new ManagerDAO();
        
        // Load manager info
        Manager manager = dao.getManagerById(userId);
        if (manager == null) {
            session.setAttribute("message", "Manager not found.");
            session.setAttribute("messageType", "error");
            response.sendRedirect("login");
            return;
        }

        // Load dashboard data
        String warehouseStatus = dao.getWarehouseStatus();
        List<StockAlert> stockAlerts = dao.getStockAlerts();
        List<PurchaseOrder> pendingRequests = dao.getPendingStockRequests();
        
        // Load all medicines để map medicine_id -> name
        List<Medicine> allMedicines = dao.getAllMedicines();
        Map<Integer, String> medicineMap = new HashMap<>();
        for (Medicine med : allMedicines) {
            medicineMap.put(med.getMedicineId(), med.getName());
        }
        
        // Load items cho mỗi PO
        Map<Integer, List<PurchaseOrderItem>> poItemsMap = new HashMap<>();
        for (PurchaseOrder po : pendingRequests) {
            List<PurchaseOrderItem> items = dao.getPurchaseOrderItems(po.getPoId());
            
            // Set medicine name cho từng item
            for (PurchaseOrderItem item : items) {
                String medicineName = medicineMap.get(item.getMedicineId());
                if (medicineName != null) {
                    item.setMedicineName(medicineName);
                }
            }
            
            poItemsMap.put(po.getPoId(), items);
        }

        // Set attributes
        request.setAttribute("manager", manager);
        request.setAttribute("warehouseStatus", warehouseStatus);
        request.setAttribute("stockAlerts", stockAlerts);
        request.setAttribute("pendingRequests", pendingRequests);
        request.setAttribute("poItemsMap", poItemsMap);
        request.setAttribute("medicineMap", medicineMap);

        request.getRequestDispatcher("manager-dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
=======
        
        ManagerDAO dao = new ManagerDAO();
        Manager manager = dao.getManagerById(userId);
        
        if (manager == null) {
            response.sendRedirect("login");
            return;
        }
        
        // Set attributes for JSP
        request.setAttribute("manager", manager);
        request.setAttribute("warehouseStatus", dao.getWarehouseStatus());
        request.setAttribute("stockAlerts", dao.getStockAlerts());
        request.setAttribute("pendingRequests", dao.getPendingStockRequests());
        
        // Get and clear messages
        String message = (String) session.getAttribute("message");
        String messageType = (String) session.getAttribute("messageType");
        if (message != null) {
            request.setAttribute("message", message);
            request.setAttribute("messageType", messageType);
            session.removeAttribute("message");
            session.removeAttribute("messageType");
        }
        
        request.getRequestDispatcher("manager-dashboard.jsp").forward(request, response);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
>>>>>>> 4645b2a (tam)
    }
}