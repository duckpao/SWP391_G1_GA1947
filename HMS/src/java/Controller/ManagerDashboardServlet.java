package Controller;

import DAO.ManagerDAO;
import model.Manager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class ManagerDashboardServlet extends HttpServlet {
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (!"Manager".equals(role) || userId == null) {
            response.sendRedirect("login");
            return;
        }
        
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
    }
}