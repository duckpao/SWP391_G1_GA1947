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
import java.util.List;
import model.Supplier;

@WebServlet(name = "CreateStockServlet", urlPatterns = {"/create-stock"})
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

        // Load suppliers
        ManagerDAO dao = new ManagerDAO();
        List<Supplier> suppliers = dao.getAllSuppliers();
        
        // Debug
        System.out.println("Number of suppliers loaded: " + suppliers.size());
        
        request.setAttribute("suppliers", suppliers);
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

            if (expectedDateStr == null || expectedDateStr.trim().isEmpty()) {
                session.setAttribute("message", "Expected delivery date is required!");
                session.setAttribute("messageType", "error");
                response.sendRedirect("create-stock");
                return;
            }

            Date expectedDeliveryDate = Date.valueOf(expectedDateStr);
            
            // Supplier is optional - can be NULL
            Integer supplierId = null;
            if (supplierIdStr != null && !supplierIdStr.trim().isEmpty() && !supplierIdStr.equals("0")) {
                supplierId = Integer.parseInt(supplierIdStr);
            }

            ManagerDAO dao = new ManagerDAO();
            int poId = dao.createPurchaseOrder(userId, supplierId, expectedDeliveryDate, notes);

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