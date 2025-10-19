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
        // Chấp nhận cả email và username
        String emailOrUsername = request.getParameter("emailOrUsername");
        if (emailOrUsername == null || emailOrUsername.isEmpty()) {
            // Fallback nếu form gửi "email" thay vì "emailOrUsername"
            emailOrUsername = request.getParameter("email");
        }
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        // Tìm kiếm người dùng theo email hoặc username
        User user = dao.findByEmailOrUsername(emailOrUsername);

        // Xác thực mật khẩu với password hashing
        if (user != null && PasswordUtils.verify(password, user.getPasswordHash())) {
            HttpSession session = request.getSession();
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("role", user.getRole());
            session.setAttribute("username", user.getUsername());

            // Redirect dựa trên role
            String role = user.getRole();
            switch (role) {
                case "Doctor":
                    response.sendRedirect("doctor-dashboard");
                    break;
                case "Manager":
                    response.sendRedirect("manager-dashboard");
                    break;
                case "Pharmacist":
                    response.sendRedirect("pharmacist-dashboard");
                    break;
                case "Staff":
                    response.sendRedirect("jsp/staff-dashboard.jsp");
                    break;
                case "Admin":
                    response.sendRedirect("admin-dashboard");
                    break;
                case "Supplier":
                    response.sendRedirect("jsp/supplier-dashboard.jsp");
                    break;
                case "Auditor":
                    response.sendRedirect("jsp/auditor-dashboard.jsp");
                    break;
                case "ProcurementOfficer":
                    response.sendRedirect("procurement-dashboard");
                    break;
                case "Patient":
                    response.sendRedirect("patient-dashboard");
                    break;
                default:
                    response.sendRedirect("home.jsp");
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