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

public class CreateStockServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");

        if (!"Manager".equals(role) || userId == null) {
            response.sendRedirect("login");
            return;
        }

        ManagerDAO dao = new ManagerDAO();
        List<Supplier> suppliers = dao.getAllSuppliers();
        List<Medicine> medicines = dao.getAllMedicines();
        
        System.out.println("Number of suppliers loaded: " + suppliers.size());
        System.out.println("Number of medicines loaded: " + medicines.size());
        
        request.setAttribute("suppliers", suppliers);
        request.setAttribute("medicines", medicines);
        request.getRequestDispatcher("create-stock-request.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");

        if (!"Manager".equals(role) || userId == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            String supplierIdStr = request.getParameter("supplierId");
            String expectedDateStr = request.getParameter("expectedDeliveryDate");
            String notes = request.getParameter("notes");
            String[] medicineCodes = request.getParameterValues("medicineCode"); // Changed from medicineId
            String[] quantities = request.getParameterValues("quantity");
            String[] priorities = request.getParameterValues("priority");
            String[] itemNotes = request.getParameterValues("itemNotes");

            if (expectedDateStr == null || expectedDateStr.trim().isEmpty()) {
                session.setAttribute("message", "Expected delivery date is required!");
                session.setAttribute("messageType", "error");
                response.sendRedirect("create-stock");
                return;
            }

            if (medicineCodes == null || quantities == null || priorities == null || medicineCodes.length == 0) {
                session.setAttribute("message", "At least one medicine item is required!");
                session.setAttribute("messageType", "error");
                response.sendRedirect("create-stock");
                return;
            }

            Date expectedDeliveryDate = Date.valueOf(expectedDateStr);
            Integer supplierId = null;
            if (supplierIdStr != null && !supplierIdStr.trim().isEmpty() && !supplierIdStr.equals("0")) {
                supplierId = Integer.parseInt(supplierIdStr);
            }

            List<PurchaseOrderItem> items = new ArrayList<>();
            for (int i = 0; i < medicineCodes.length; i++) {
                PurchaseOrderItem item = new PurchaseOrderItem();
                item.setMedicineCode(medicineCodes[i]); // Changed from setMedicineId
                item.setQuantity(Integer.parseInt(quantities[i]));
                item.setPriority(priorities[i]);
                item.setNotes(itemNotes != null && i < itemNotes.length ? itemNotes[i] : "");
                items.add(item);
            }

            ManagerDAO dao = new ManagerDAO();
            int poId = dao.createPurchaseOrder(userId, supplierId, expectedDeliveryDate, notes, items);

            if (poId > 0) {
                session.setAttribute("message", "Stock request #" + poId + " created successfully!");
                session.setAttribute("messageType", "success");
            } else {
                session.setAttribute("message", "Failed to create stock request.");
                session.setAttribute("messageType", "error");
            }
            
            response.sendRedirect("manager-dashboard");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("message", "Error: " + e.getMessage());
            session.setAttribute("messageType", "error");
            response.sendRedirect("create-stock");
        }
    }
}