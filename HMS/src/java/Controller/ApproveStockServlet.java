package Controller;

import DAO.ManagerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ApproveStockServlet", urlPatterns = {"/approve-stock"})
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

            if ("approve".equals(action)) {
                boolean success = dao.approveStockRequest(poId, userId);
                if (success) {
                    session.setAttribute("message", "Stock request #" + poId + " has been sent to supplier successfully!");
                    session.setAttribute("messageType", "success");
                } else {
                    session.setAttribute("message", "Failed to send stock request. Make sure it's in Draft status.");
                    session.setAttribute("messageType", "error");
                }
            } else if ("reject".equals(action)) {
                String reason = request.getParameter("reason");
                if (reason == null || reason.trim().length() < 5) {
                    session.setAttribute("message", "Rejection reason must be at least 5 characters.");
                    session.setAttribute("messageType", "error");
                    response.sendRedirect("manager-dashboard");
                    return;
                }
                
                boolean success = dao.rejectStockRequest(poId, reason);
                if (success) {
                    session.setAttribute("message", "Stock request #" + poId + " has been rejected.");
                    session.setAttribute("messageType", "success");
                } else {
                    session.setAttribute("message", "Failed to reject stock request. Make sure it's in Draft status.");
                    session.setAttribute("messageType", "error");
                }
            } else if ("cancel".equals(action)) {
                String reason = request.getParameter("reason");
                if (reason == null || reason.trim().length() < 10) {
                    session.setAttribute("message", "Cancellation reason must be at least 10 characters.");
                    session.setAttribute("messageType", "error");
                    response.sendRedirect("manager-dashboard");
                    return;
                }
                
                boolean success = dao.cancelStockRequest(poId, reason);
                if (success) {
                    session.setAttribute("message", "Stock request #" + poId + " has been cancelled.");
                    session.setAttribute("messageType", "success");
                } else {
                    session.setAttribute("message", "Failed to cancel stock request. Make sure it's in Sent status.");
                    session.setAttribute("messageType", "error");
                }
            } else {
                session.setAttribute("message", "Invalid action.");
                session.setAttribute("messageType", "error");
            }
            
            response.sendRedirect("manager-dashboard");
        } catch (NumberFormatException e) {
            session.setAttribute("message", "Invalid purchase order ID format.");
            session.setAttribute("messageType", "error");
            response.sendRedirect("manager-dashboard");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("message", "Error: " + e.getMessage());
            session.setAttribute("messageType", "error");
            response.sendRedirect("manager-dashboard");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("manager-dashboard");
    }
}