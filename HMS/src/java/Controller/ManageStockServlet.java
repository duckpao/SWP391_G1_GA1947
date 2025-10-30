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
import model.PurchaseOrder;
import model.PurchaseOrderItem;
import model.Supplier;
import model.Medicine;

public class ManageStockServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("========================================");
        System.out.println("MANAGE STOCK - GET (Edit Mode)");
        System.out.println("========================================");
        
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");

        if (!"Manager".equals(role) || userId == null) {
            response.sendRedirect("login");
            return;
        }

        String poIdStr = request.getParameter("poId");
        if (poIdStr == null || poIdStr.trim().isEmpty()) {
            session.setAttribute("message", "Invalid purchase order ID.");
            session.setAttribute("messageType", "error");
            response.sendRedirect("manager-dashboard");
            return;
        }

        try {
            int poId = Integer.parseInt(poIdStr);
            ManagerDAO dao = new ManagerDAO();
            PurchaseOrder po = dao.getPurchaseOrderById(poId);
            List<PurchaseOrderItem> items = dao.getPurchaseOrderItems(poId);
            List<Supplier> suppliers = dao.getAllSuppliers();
            List<Medicine> medicines = dao.getAllMedicines();

            System.out.println("Loaded PO #" + poId);
            System.out.println("Status: " + (po != null ? po.getStatus() : "NULL"));
            System.out.println("Items count: " + items.size());
            
            // Debug: Print item details
            for (int i = 0; i < items.size(); i++) {
                PurchaseOrderItem item = items.get(i);
                System.out.println("Item " + (i+1) + ": " + item.getMedicineCode() + 
                                 ", Qty=" + item.getQuantity() + 
                                 ", Price=" + item.getUnitPrice());
            }

            if (po == null || !"Draft".equals(po.getStatus())) {
                session.setAttribute("message", "Only Draft requests can be edited.");
                session.setAttribute("messageType", "error");
                response.sendRedirect("manager-dashboard");
                return;
            }

            request.setAttribute("purchaseOrder", po);
            request.setAttribute("items", items);
            request.setAttribute("suppliers", suppliers);
            request.setAttribute("medicines", medicines);
            request.getRequestDispatcher("edit-stock-request.jsp").forward(request, response);
            
            System.out.println("========================================");
        } catch (NumberFormatException e) {
            System.err.println("Invalid PO ID format: " + e.getMessage());
            session.setAttribute("message", "Invalid purchase order ID.");
            session.setAttribute("messageType", "error");
            response.sendRedirect("manager-dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.out.println("========================================");
        System.out.println("MANAGE STOCK - POST");
        System.out.println("========================================");
        
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");

        if (!"Manager".equals(role) || userId == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        String poIdStr = request.getParameter("poId");

        System.out.println("Action: " + action);
        System.out.println("PO ID: " + poIdStr);

        if (poIdStr == null || poIdStr.trim().isEmpty()) {
            session.setAttribute("message", "Invalid purchase order ID.");
            session.setAttribute("messageType", "error");
            response.sendRedirect("manager-dashboard");
            return;
        }

        try {
            int poId = Integer.parseInt(poIdStr);
            ManagerDAO dao = new ManagerDAO();

            if ("edit".equals(action)) {
                String supplierIdStr = request.getParameter("supplierId");
                String expectedDateStr = request.getParameter("expectedDeliveryDate");
                String notes = request.getParameter("notes");
                
                // ✅ ĐỔI: Đọc medicine_code, unitPrice
                String[] medicineCodes = request.getParameterValues("medicineCode");
                String[] quantities = request.getParameterValues("quantity");
                String[] unitPrices = request.getParameterValues("unitPrice");
                String[] priorities = request.getParameterValues("priority");
                String[] itemNotes = request.getParameterValues("itemNotes");

                System.out.println("\n=== FORM DATA ===");
                System.out.println("Medicine codes: " + (medicineCodes != null ? medicineCodes.length : 0));
                System.out.println("Quantities: " + (quantities != null ? quantities.length : 0));
                System.out.println("Unit prices: " + (unitPrices != null ? unitPrices.length : 0));
                System.out.println("Priorities: " + (priorities != null ? priorities.length : 0));

                if (expectedDateStr == null || expectedDateStr.trim().isEmpty()) {
                    session.setAttribute("message", "Expected delivery date is required!");
                    session.setAttribute("messageType", "error");
                    response.sendRedirect("edit-stock?poId=" + poId);
                    return;
                }

                if (medicineCodes == null || quantities == null || unitPrices == null || 
                    priorities == null || medicineCodes.length == 0) {
                    session.setAttribute("message", "At least one medicine item is required!");
                    session.setAttribute("messageType", "error");
                    response.sendRedirect("edit-stock?poId=" + poId);
                    return;
                }

                Date expectedDeliveryDate = Date.valueOf(expectedDateStr);
                Integer supplierId = null;
                if (supplierIdStr != null && !supplierIdStr.trim().isEmpty() && !supplierIdStr.equals("0")) {
                    supplierId = Integer.parseInt(supplierIdStr);
                }

                List<PurchaseOrderItem> items = new ArrayList<>();
                
                System.out.println("\n=== BUILDING ITEMS ===");
                for (int i = 0; i < medicineCodes.length; i++) {
                    PurchaseOrderItem item = new PurchaseOrderItem();
                    item.setMedicineCode(medicineCodes[i]);
                    item.setQuantity(Integer.parseInt(quantities[i]));
                    item.setUnitPrice(Double.parseDouble(unitPrices[i])); // ✅ THÊM
                    item.setPriority(priorities[i]);
                    item.setNotes(itemNotes != null && i < itemNotes.length ? itemNotes[i] : "");
                    
                    System.out.println("Item " + (i+1) + ":");
                    System.out.println("  - Medicine Code: " + item.getMedicineCode());
                    System.out.println("  - Quantity: " + item.getQuantity());
                    System.out.println("  - Unit Price: " + item.getUnitPrice());
                    System.out.println("  - Priority: " + item.getPriority());
                    
                    items.add(item);
                }

                boolean success = dao.updatePurchaseOrder(poId, supplierId, expectedDeliveryDate, notes, items);
                if (success) {
                    session.setAttribute("message", "Stock request #" + poId + " updated successfully!");
                    session.setAttribute("messageType", "success");
                    System.out.println("✅ Update successful!");
                } else {
                    session.setAttribute("message", "Failed to update stock request.");
                    session.setAttribute("messageType", "error");
                    System.out.println("❌ Update failed!");
                }
                
            } else if ("delete".equals(action)) {
                boolean success = dao.deletePurchaseOrder(poId);
                if (success) {
                    session.setAttribute("message", "Stock request #" + poId + " deleted successfully!");
                    session.setAttribute("messageType", "success");
                    System.out.println("✅ Delete successful!");
                } else {
                    session.setAttribute("message", "Failed to delete stock request.");
                    session.setAttribute("messageType", "error");
                    System.out.println("❌ Delete failed!");
                }
            } else {
                session.setAttribute("message", "Invalid action.");
                session.setAttribute("messageType", "error");
            }
            
            System.out.println("========================================\n");
            response.sendRedirect("manager-dashboard");
            
        } catch (Exception e) {
            System.err.println("EXCEPTION in ManageStockServlet: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("message", "Error: " + e.getMessage());
            session.setAttribute("messageType", "error");
            response.sendRedirect("manager-dashboard");
        }
    }
}