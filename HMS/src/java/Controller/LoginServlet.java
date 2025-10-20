package Controller;

import DAO.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import util.PasswordUtils;

/**
 *
 * @author ADMIN
 */
public class LoginServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet LoginServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String emailOrUsername = request.getParameter("emailOrUsername"); // Email hoặc Username
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        // Tìm kiếm người dùng theo email hoặc username
        User user = dao.findByEmailOrUsername(emailOrUsername);

        if (user != null && PasswordUtils.verify(password, user.getPasswordHash())) {
            HttpSession session = request.getSession();
            session.setAttribute("userId", user.getUserId()); // Lưu userId
            session.setAttribute("role", user.getRole());     // Lưu role
            session.setAttribute("username", user.getUsername()); // Lưu username để hiển thị "Xin chào"

            // Redirect dựa trên role
            String role = user.getRole();
            switch (role) {
                case "Doctor":
                    response.sendRedirect("doctor-dashboard"); // Điều hướng đến dashboard của bác sĩ
                    break;
                case "Pharmacist":
                    response.sendRedirect("pharmacist-dashboard"); // Điều hướng đến dashboard của dược sĩ
                    break;
                case "Staff":
                    response.sendRedirect("jsp/staff-dashboard.jsp"); // Điều hướng đến dashboard của nhân viên
                    break;
                case "Admin":
                    response.sendRedirect("admin-dashboard"); // Điều hướng đến dashboard của quản trị viên
                    break;
                case "Supplier":
                    response.sendRedirect("supplier/supplier-dashboard.jsp"); // Điều hướng đến dashboard của nhà cung cấp
                    break;
                case "Auditor":
                    response.sendRedirect("jsp/auditor-dashboard.jsp"); // Điều hướng đến dashboard của kiểm toán viên
                    break;
                default:
                    response.sendRedirect("home.jsp"); // Mặc định điều hướng về trang chủ
                    break;
            }
        } else {
            request.setAttribute("error", "Sai email/username hoặc mật khẩu!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet for user login";
    }
}
