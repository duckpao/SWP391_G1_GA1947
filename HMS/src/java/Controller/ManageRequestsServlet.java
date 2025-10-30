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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // ❌ Nếu chưa đăng nhập hoặc không có role
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("role");

        // ✅ Cho phép Doctor và Admin vào
        if ("Doctor".equals(role) || "Admin".equals(role)) {
            int doctorId = (Integer) session.getAttribute("userId");
            MedicationRequestDAO dao = new MedicationRequestDAO();

            List<MedicationRequest> requests = dao.getRequestsByDoctorId(doctorId)
                    .stream()
                    .filter(req -> "Pending".equals(req.getStatus()))
                    .collect(Collectors.toList());

            request.setAttribute("requests", requests);
            request.getRequestDispatcher("/jsp/manageRequests.jsp").forward(request, response);
            return;
        }

        // 🚫 Các role khác chuyển về dashboard tương ứng
        switch (role) {
            case "Pharmacist":
                response.sendRedirect(request.getContextPath() + "/pharmacist-dashboard");
                break;
            case "Manager":
                response.sendRedirect(request.getContextPath() + "/manager-dashboard");
                break;
            case "Auditor":
                response.sendRedirect(request.getContextPath() + "/auditor-dashboard");
                break;
            case "Supplier":
                response.sendRedirect(request.getContextPath() + "/supplier-dashboard");
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/login");
                break;
        }
    }
}
