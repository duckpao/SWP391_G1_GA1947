package Controller;

import jakarta.servlet.RequestDispatcher;
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

        // Lấy session hiện tại (không tạo mới)
        HttpSession session = request.getSession(false);

        // Nếu chưa đăng nhập hoặc chưa có role thì quay về login.jsp
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Lấy role từ session
        String role = ((String) session.getAttribute("role")).toLowerCase();

        // Debug kiểm tra role thực tế
        System.out.println("Role in session: " + role);

        // Giữ role trong session (đề phòng có servlet khác cần dùng)
        session.setAttribute("role", role);

        // Gửi role xuống JSP (nếu cần sử dụng ở mức request)
        request.setAttribute("role", role);

        // Chuyển tiếp đến file JSP dùng chung
        RequestDispatcher rd = request.getRequestDispatcher("/jsp/doctorDashboard.jsp");
        rd.forward(request, response);
    }
}
