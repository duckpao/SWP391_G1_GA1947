package Controller;

import DAO.ManagerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import model.Supplier;
import model.PurchaseOrderItem;
import model.Medicine;
import util.LoggingUtil;

public class CreateStockServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("========================================");
        System.out.println("CREATE STOCK - GET");
        System.out.println("========================================");
        
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");
        
        // ✅ FIXED: Chỉ cho phép Manager hoặc Admin truy cập
        if ((!"Manager".equals(role) && !"Admin".equals(role)) || userId == null) {
            System.out.println("Access denied - Role: " + role + ", UserId: " + userId);
            response.sendRedirect("login");
            return;
        }
        
        ManagerDAO dao = new ManagerDAO();
        List<Supplier> suppliers = dao.getAllSuppliers();
        List<Medicine> medicines = dao.getAllMedicines();
        
        System.out.println("Suppliers loaded: " + suppliers.size());
        System.out.println("Medicines loaded: " + medicines.size());
        
        // Debug: Print first few medicines
        for (int i = 0; i < Math.min(3, medicines.size()); i++) {
            Medicine m = medicines.get(i);
            System.out.println(" Medicine " + (i+1) + ": " + m.getMedicineCode() + " - " + m.getName());
        }
        
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("medicines", medicines);
        request.getRequestDispatcher("create-stock-request.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("========================================");
        System.out.println("CREATE STOCK - POST");
        System.out.println("========================================");
        
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");
        
        // ✅ FIXED: Chỉ cho phép Manager hoặc Admin truy cập
        if ((!"Manager".equals(role) && !"Admin".equals(role)) || userId == null) {
            System.out.println("Access denied - Role: " + role + ", UserId: " + userId);
            response.sendRedirect("login");
            return;
        }
        
        try {
            // Get form parameters
            String supplierIdStr = request.getParameter("supplierId");
            String expectedDateStr = request.getParameter("expectedDeliveryDate");
            String notes = request.getParameter("notes");
            
            System.out.println("Supplier ID: " + supplierIdStr);
            System.out.println("Expected Date: " + expectedDateStr);
            System.out.println("Notes: " + notes);
            
            // Get arrays
            String[] medicineCodes = request.getParameterValues("medicineCode");
            String[] quantities = request.getParameterValues("quantity");
            String[] unitPrices = request.getParameterValues("unitPrice");
            String[] priorities = request.getParameterValues("priority");
            String[] itemNotes = request.getParameterValues("itemNotes");
            
            System.out.println("\n=== FORM DATA ===");
            System.out.println("Medicine codes array: " + (medicineCodes != null ? medicineCodes.length : 0));
            System.out.println("Quantities array: " + (quantities != null ? quantities.length : 0));
            System.out.println("Unit prices array: " + (unitPrices != null ? unitPrices.length : 0));
            System.out.println("Priorities array: " + (priorities != null ? priorities.length : 0));
            
            // Validate required fields
            if (expectedDateStr == null || expectedDateStr.trim().isEmpty()) {
                System.out.println("ERROR: Expected delivery date is required!");
                session.setAttribute("message", "Expected delivery date is required!");
                session.setAttribute("messageType", "error");
                response.sendRedirect("create-stock");
                return;
            }
            
            if (medicineCodes == null || quantities == null || unitPrices == null || 
                priorities == null || medicineCodes.length == 0) {
                System.out.println("ERROR: At least one medicine item is required!");
                session.setAttribute("message", "At least one medicine item is required!");
                session.setAttribute("messageType", "error");
                response.sendRedirect("create-stock");
                return;
            }
            
            // Parse dates and supplier
            Date expectedDeliveryDate = Date.valueOf(expectedDateStr);
            Integer supplierId = null;
            if (supplierIdStr != null && !supplierIdStr.trim().isEmpty() && !supplierIdStr.equals("0")) {
                supplierId = Integer.parseInt(supplierIdStr);
            }
            
            // Build items list
            List<PurchaseOrderItem> items = new ArrayList<>();
            System.out.println("\n=== BUILDING ITEMS ===");
            
            for (int i = 0; i < medicineCodes.length; i++) {
                PurchaseOrderItem item = new PurchaseOrderItem();
                item.setMedicineCode(medicineCodes[i]);
                item.setQuantity(Integer.parseInt(quantities[i]));
                item.setUnitPrice(Double.parseDouble(unitPrices[i]));
                item.setPriority(priorities[i]);
                item.setNotes(itemNotes != null && i < itemNotes.length ? itemNotes[i] : "");
                
                System.out.println("Item " + (i+1) + ":");
                System.out.println(" - Medicine Code: " + item.getMedicineCode());
                System.out.println(" - Quantity: " + item.getQuantity());
                System.out.println(" - Unit Price: " + item.getUnitPrice());
                System.out.println(" - Priority: " + item.getPriority());
                System.out.println(" - Notes: " + item.getNotes());
                
                items.add(item);
            }
            
            System.out.println("\nTotal items: " + items.size());
            
            // Create purchase order
            ManagerDAO dao = new ManagerDAO();
            int poId = dao.createPurchaseOrder(userId, supplierId, expectedDeliveryDate, notes, items);
            
            System.out.println("\nCreated PO ID: " + poId);
            
            if (poId > 0) {
                // ✅ LOGGING - PO Created
                String supplierName = "Unknown";
                if (supplierId != null) {
                    ManagerDAO tempDao = new ManagerDAO();
                    Supplier supplier = tempDao.getSupplierById(supplierId);
                    if (supplier != null) {
                        supplierName = supplier.getName();
                    }
                }
                
                LoggingUtil.logPOCreate(request, poId, supplierName);
                
                session.setAttribute("message", "Stock request #" + poId + " created successfully!");
                session.setAttribute("messageType", "success");
                System.out.println("SUCCESS: Stock request created!");
            } else {
                session.setAttribute("message", "Failed to create stock request.");
                session.setAttribute("messageType", "error");
                System.out.println("ERROR: Failed to create stock request!");
            }
            
            System.out.println("========================================\n");
            response.sendRedirect("manager-dashboard");
            
        } catch (Exception e) {
            System.err.println("EXCEPTION in CreateStockServlet: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("message", "Error: " + e.getMessage());
            session.setAttribute("messageType", "error");
            response.sendRedirect("create-stock");
        }
    }
}