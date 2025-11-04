package Controller;

import DAO.MedicationRequestDAO;
import model.MedicationRequest;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

public class ManageRequestsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null || !"Doctor".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }

        int doctorId = (Integer) session.getAttribute("userId");
        MedicationRequestDAO dao = new MedicationRequestDAO();
        List<MedicationRequest> requests = dao.getRequestsByDoctorId(doctorId)
                .stream()
                .filter(req -> "Pending".equals(req.getStatus()))
                .collect(Collectors.toList());
        request.setAttribute("requests", requests);
        request.getRequestDispatcher("/jsp/manageRequests.jsp").forward(request, response);
    }
}