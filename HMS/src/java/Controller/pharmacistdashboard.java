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

        if (session == null || !"Pharmacist".equals(session.getAttribute("role"))) {
            // Chưa login hoặc role không phải Pharmacist → về login
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Nếu đúng role, chuyển sang pharmacist-dashboard.jsp trong thư mục pharmacist
        request.getRequestDispatcher("/pharmacist/pharmacist-dashboard.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // POST cũng chạy giống GET
    }

    @Override
    public String getServletInfo() {
        return "Servlet redirect sang pharmacist dashboard";
    }
}
