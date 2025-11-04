package Controller;

import DAO.ManagerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
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
        
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");
        
        System.out.println("User ID: " + userId);
        System.out.println("Role: " + role);
        
        if (!"Manager".equals(role) || userId == null) {
            System.out.println("Access denied - redirecting to login");
            response.sendRedirect("login");
            return;
        }
        
        ManagerDAO dao = new ManagerDAO();
        
        // Load manager info
        Manager manager = dao.getManagerById(userId);
        if (manager == null) {
            System.out.println("Manager not found!");
            session.setAttribute("message", "Manager not found.");
            session.setAttribute("messageType", "error");
            response.sendRedirect("login");
            return;
        }
        
        System.out.println("Manager loaded: " + manager.getUsername());
        
        // Load dashboard data
        String warehouseStatus = dao.getWarehouseStatus();
        List<StockAlert> stockAlerts = dao.getStockAlerts();
        List<PurchaseOrder> pendingRequests = dao.getPendingStockRequests();
        
        System.out.println("Warehouse Status: " + warehouseStatus);
        System.out.println("Stock Alerts: " + stockAlerts.size());
        System.out.println("Pending Requests: " + pendingRequests.size());
        
        // Load all medicines to create medicine_code -> Medicine mapping
        List<Medicine> allMedicines = dao.getAllMedicines();
        Map<String, Medicine> medicineMap = new HashMap<>();
        for (Medicine med : allMedicines) {
            medicineMap.put(med.getMedicineCode(), med);
        }
        System.out.println("Total Medicines Loaded: " + allMedicines.size());
        
        // Load items for each Purchase Order
        Map<Integer, List<PurchaseOrderItem>> poItemsMap = new HashMap<>();
        
        System.out.println("\n=== LOADING ORDER ITEMS ===");
        for (PurchaseOrder po : pendingRequests) {
            System.out.println("\n--- Processing PO #" + po.getPoId() + " ---");
            
            List<PurchaseOrderItem> items = dao.getPurchaseOrderItems(po.getPoId());
            
            System.out.println("Items loaded from DAO: " + items.size());
            
            // Set medicine details for each item
            for (PurchaseOrderItem item : items) {
                System.out.println("  Item - Code: " + item.getMedicineCode() + 
                                 ", Name: " + item.getMedicineName() + 
                                 ", Qty: " + item.getQuantity());
                
                // If name is null, try to get from medicineMap
                if (item.getMedicineName() == null || item.getMedicineName().isEmpty()) {
                    Medicine medicine = medicineMap.get(item.getMedicineCode());
                    if (medicine != null) {
                        System.out.println("  -> Setting medicine details from medicineMap");
                        item.setMedicineName(medicine.getName());
                        item.setMedicineCategory(medicine.getCategory());
                        item.setMedicineStrength(medicine.getStrength());
                        item.setMedicineDosageForm(medicine.getDosageForm());
                        item.setMedicineManufacturer(medicine.getManufacturer());
                    } else {
                        System.out.println("  -> WARNING: Medicine not found in medicineMap!");
                    }
                }
            }
            
            poItemsMap.put(po.getPoId(), items);
            System.out.println("Total items added to map for PO #" + po.getPoId() + ": " + items.size());
        }
        
        System.out.println("\n=== FINAL SUMMARY ===");
        System.out.println("poItemsMap size: " + poItemsMap.size());
        for (Map.Entry<Integer, List<PurchaseOrderItem>> entry : poItemsMap.entrySet()) {
            System.out.println("PO #" + entry.getKey() + " -> " + entry.getValue().size() + " items");
        }
        
        // Set attributes for JSP
        request.setAttribute("manager", manager);
        request.setAttribute("warehouseStatus", warehouseStatus);
        request.setAttribute("stockAlerts", stockAlerts);
        request.setAttribute("pendingRequests", pendingRequests);
        request.setAttribute("poItemsMap", poItemsMap);
        request.setAttribute("medicineMap", medicineMap);
        
        System.out.println("\n=== FORWARDING TO JSP ===");
        System.out.println("========================================\n");
        
        request.getRequestDispatcher("manager-dashboard.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}