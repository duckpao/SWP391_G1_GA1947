package Controller;

import DAO.MedicationRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class CancelMedicationRequestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null || !"Doctor".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }

        int requestId = Integer.parseInt(request.getParameter("requestId"));
        System.out.println("Attempting to cancel requestId: " + requestId); 
        MedicationRequestDAO dao = new MedicationRequestDAO();
        if (dao.cancelRequest(requestId)) {
            System.out.println("Cancel successful for requestId: " + requestId);
            response.sendRedirect("manage-requests?message=cancel_success");
        } else {
            System.out.println("Cancel failed for requestId: " + requestId);
            response.sendRedirect("manage-requests?message=error_cancel");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}