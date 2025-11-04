package Controller;

import DAO.MedicationRequestDAO;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class PharmacistUpdateRequest extends HttpServlet {

    private MedicationRequestDAO dao = new MedicationRequestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false); // không tạo mới nếu chưa có
        if (session == null || session.getAttribute("userId") == null) {
            // Chưa đăng nhập → redirect về trang login
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int pharmacistId;
        try {
            pharmacistId = (Integer) session.getAttribute("userId");
        } catch (ClassCastException e) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String idStr = request.getParameter("requestId");
        if (action == null || idStr == null) {
            response.sendRedirect(request.getContextPath() + "/pharmacist/View_MedicineRequest");
            return;
        }

        int requestId;
        try {
            requestId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/pharmacist/View_MedicineRequest");
            return;
        }

        try {
            if (action.equals("approve")) {
                dao.approveRequest(requestId, pharmacistId);
            } else if (action.equals("reject")) {
                String reason = request.getParameter("reason");
                dao.rejectRequest(requestId, reason);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", e.getMessage());
        }

        // Quay lại trang danh sách
        response.sendRedirect(request.getContextPath() + "/pharmacist/View_MedicineRequest");
    }
}
