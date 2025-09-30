package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;


public class Dashboard extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
  // Lấy role từ session
        String role = ((String) session.getAttribute("role")).toLowerCase();

         // Xây dựng đường dẫn tới JSP tương ứng trong thư mục Role
        // Ví dụ: /doctor/dashboard.jsp hoặc /pharmacist/dashboard.jsp
        String viewPath = "/" + role + "/dashboard.jsp";


        RequestDispatcher rd = request.getRequestDispatcher(viewPath);
        rd.forward(request, response);
    }
}
