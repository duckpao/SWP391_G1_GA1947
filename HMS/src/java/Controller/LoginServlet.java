package Controller;

import DAO.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import util.PasswordUtils;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String emailOrUsername = request.getParameter("emailOrUsername");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        User user = dao.findByEmailOrUsername(emailOrUsername);

        if (user != null && PasswordUtils.verify(password, user.getPasswordHash())) {
            HttpSession session = request.getSession();
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("role", user.getRole());
            session.setAttribute("username", user.getUsername());

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
                    response.sendRedirect("admin/dashboard.jsp");
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
}