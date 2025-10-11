package Controller;

import DAO.ManagerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class ApproveStockServlet extends HttpServlet {

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
        int poId = Integer.parseInt(request.getParameter("poId"));

        ManagerDAO dao = new ManagerDAO();
        boolean success = false;
        String message = "";

        if ("approve".equals(action)) {
            success = dao.approveStockRequest(poId, userId);
            message = success ? "Stock request approved successfully!" : "Failed to approve stock request.";
        } else if ("reject".equals(action)) {
            String reason = request.getParameter("reason");
            if (reason == null || reason.trim().isEmpty()) {
                reason = "No reason provided";
            }
            success = dao.rejectStockRequest(poId, reason);
            message = success ? "Stock request rejected successfully!" : "Failed to reject stock request.";
        }

        session.setAttribute("message", message);
        session.setAttribute("messageType", success ? "success" : "error");
        response.sendRedirect("manager-dashboard");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("manager-dashboard");
    }
}