package Controller;

import DAO.ManagerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ApproveStockServlet", urlPatterns = { "/approve-stock" })
public class ApproveStockServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");

        // Debug log
        System.out.println("=== APPROVE STOCK REQUEST ===");
        System.out.println("User Role: " + role);
        System.out.println("User ID: " + userId);

        // Kiểm tra quyền Manager và userId
        if (!"Manager".equals(role) || userId == null) {
            session.setAttribute("message", "Unauthorized access. Please log in as Manager.");
            session.setAttribute("messageType", "error");
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        String poIdStr = request.getParameter("poId");

        System.out.println("Action: " + action);
        System.out.println("PO ID: " + poIdStr);

        // Kiểm tra poId hợp lệ
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
                System.out.println("Attempting to approve PO #" + poId + " by Manager #" + userId);

                boolean success = dao.approveStockRequest(poId, userId);

                System.out.println("Approve result: " + success);

                if (success) {
                    session.setAttribute("message", "Stock request #" + poId + " approved successfully!");
                    session.setAttribute("messageType", "success");
                } else {
                    session.setAttribute("message",
                            "Failed to approve stock request #" + poId + ". Please check server logs for details.");
                    session.setAttribute("messageType", "error");
                }
            } else if ("reject".equals(action)) {
                String reason = request.getParameter("reason");

                System.out.println("Rejection reason: " + reason);

                if (reason == null || reason.trim().isEmpty()) {
                    session.setAttribute("message", "Rejection reason is required.");
                    session.setAttribute("messageType", "error");
                } else if (reason.length() < 5) {
                    session.setAttribute("message", "Rejection reason must be at least 5 characters.");
                    session.setAttribute("messageType", "error");
                } else {
                    System.out.println("Attempting to reject PO #" + poId);

                    boolean success = dao.rejectStockRequest(poId, reason);

                    System.out.println("Reject result: " + success);

                    if (success) {
                        session.setAttribute("message", "Stock request #" + poId + " rejected successfully!");
                        session.setAttribute("messageType", "success");
                    } else {
                        session.setAttribute("message",
                                "Failed to reject stock request #" + poId + ". Please check server logs for details.");
                        session.setAttribute("messageType", "error");
                    }
                }
            } else {
                session.setAttribute("message", "Invalid action specified.");
                session.setAttribute("messageType", "error");
            }

            System.out.println("=== END APPROVE STOCK REQUEST ===\n");
            response.sendRedirect("manager-dashboard");

        } catch (NumberFormatException e) {
            System.err.println("Invalid PO ID format: " + poIdStr);
            e.printStackTrace();
            session.setAttribute("message", "Invalid purchase order ID format.");
            session.setAttribute("messageType", "error");
            response.sendRedirect("manager-dashboard");
        } catch (Exception e) {
            System.err.println("Error processing approve/reject request:");
            e.printStackTrace();
            session.setAttribute("message", "Error processing request: " + e.getMessage());
            session.setAttribute("messageType", "error");
            response.sendRedirect("manager-dashboard");
        }
    }
}