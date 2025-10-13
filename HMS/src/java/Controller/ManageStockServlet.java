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

@WebServlet(name = "ManageStockServlet", urlPatterns = {"/edit-stock", "/manage-stock"})
public class ManageStockServlet extends HttpServlet {

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
        } catch (NumberFormatException e) {
            session.setAttribute("message", "Invalid purchase order ID.");
            session.setAttribute("messageType", "error");
            response.sendRedirect("manager-dashboard");
        }
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

        String action = request.getParameter("action");
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

            if ("edit".equals(action)) {
                String supplierIdStr = request.getParameter("supplierId");
                String expectedDateStr = request.getParameter("expectedDeliveryDate");
                String notes = request.getParameter("notes");
                String[] medicineIds = request.getParameterValues("medicineId");
                String[] quantities = request.getParameterValues("quantity");
                String[] priorities = request.getParameterValues("priority");
                String[] itemNotes = request.getParameterValues("itemNotes");

                if (expectedDateStr == null || expectedDateStr.trim().isEmpty()) {
                    session.setAttribute("message", "Expected delivery date is required!");
                    session.setAttribute("messageType", "error");
                    response.sendRedirect("edit-stock?poId=" + poId);
                    return;
                }

                if (medicineIds == null || quantities == null || priorities == null || medicineIds.length == 0) {
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
                for (int i = 0; i < medicineIds.length; i++) {
                    PurchaseOrderItem item = new PurchaseOrderItem();
                    item.setMedicineId(Integer.parseInt(medicineIds[i]));
                    item.setQuantity(Integer.parseInt(quantities[i]));
                    item.setPriority(priorities[i]);
                    item.setNotes(itemNotes != null && i < itemNotes.length ? itemNotes[i] : "");
                    items.add(item);
                }

                boolean success = dao.updatePurchaseOrder(poId, supplierId, expectedDeliveryDate, notes, items);
                if (success) {
                    session.setAttribute("message", "Stock request #" + poId + " updated successfully!");
                    session.setAttribute("messageType", "success");
                } else {
                    session.setAttribute("message", "Failed to update stock request.");
                    session.setAttribute("messageType", "error");
                }
            } else if ("delete".equals(action)) {
                boolean success = dao.deletePurchaseOrder(poId);
                if (success) {
                    session.setAttribute("message", "Stock request #" + poId + " deleted successfully!");
                    session.setAttribute("messageType", "success");
                } else {
                    session.setAttribute("message", "Failed to delete stock request.");
                    session.setAttribute("messageType", "error");
                }
            } else {
                session.setAttribute("message", "Invalid action.");
                session.setAttribute("messageType", "error");
            }
            response.sendRedirect("manager-dashboard");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("message", "Error: " + e.getMessage());
            session.setAttribute("messageType", "error");
            response.sendRedirect("manager-dashboard");
        }
    }
}