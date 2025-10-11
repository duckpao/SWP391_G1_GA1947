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
        String emailOrUsername = request.getParameter("emailOrUsername");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        User user = dao.loginByEmailOrUsername(emailOrUsername, password);

        if (user != null && PasswordUtils.verify(password, user.getPasswordHash())) {
            HttpSession session = request.getSession();
            session.setAttribute("userId", user.getUserId()); // Lưu userId
            session.setAttribute("role", user.getRole());     // Lưu role
            session.setAttribute("username", user.getUsername()); // Lưu username để hiển thị "Xin chào"

            String role = user.getRole();
            switch (role) {
                case "Doctor":
                    response.sendRedirect("doctor-dashboard");
                    break;
                case "Staff":
                    response.sendRedirect("staff-dashboard");
                    break;
                case "Admin":
                    response.sendRedirect("admin/dashboard.jsp");
                    break;
                case "Supplier":
                    response.sendRedirect("supplier-dashboard");
                    break;
                case "Auditor":
                    response.sendRedirect("auditor-dashboard");
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
