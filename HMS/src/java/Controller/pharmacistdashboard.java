package Controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class pharmacistdashboard extends HttpServlet {

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

        // ✅ Cho phép Admin hoặc Pharmacist truy cập
        if ("Pharmacist".equals(role) || "Admin".equals(role)) {
            System.out.println("Access granted to Pharmacist Dashboard. Role: " + role);
            request.getRequestDispatcher("/pharmacist/pharmacist-dashboard.jsp").forward(request, response);
            return;
        }

        // 🚫 Các role khác thì điều hướng đúng dashboard của họ
        switch (role) {
            case "Doctor":
                response.sendRedirect(request.getContextPath() + "/doctor-dashboard");
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Pharmacist Dashboard Servlet - allows Admin & Pharmacist roles";
    }
}
