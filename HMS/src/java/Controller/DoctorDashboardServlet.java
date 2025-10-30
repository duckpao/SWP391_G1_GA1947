package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class DoctorDashboardServlet extends HttpServlet {

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

        // ✅ Cho phép Admin hoặc Doctor
        if ("Doctor".equals(role) || "Admin".equals(role)) {
            System.out.println("Access granted to Doctor Dashboard. Role: " + role);
            request.getRequestDispatcher("/jsp/doctorDashboard.jsp").forward(request, response);
        } 
        // ❌ Các role khác không được phép
        else if ("Manager".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/manager-dashboard");
        } else if ("Pharmacist".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/pharmacist-dashboard");
        } else if ("Auditor".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/auditor-dashboard");
        } else if ("Supplier".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/supplier-dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
}
