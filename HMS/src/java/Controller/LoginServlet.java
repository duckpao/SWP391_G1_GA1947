package Controller;

import DAO.UserDAO;
import DAO.SupplierDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import model.User;
import util.PasswordUtils;
import util.LoggingUtil;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String emailOrUsername = request.getParameter("emailOrUsername");
        String password = request.getParameter("password");

        UserDAO userDAO = new UserDAO();
        SupplierDAO supplierDAO = new SupplierDAO();

        try {
            User user = userDAO.findByEmailOrUsername(emailOrUsername);

            if (user != null && PasswordUtils.verify(password, user.getPasswordHash())) {
                // ✅ LOGIN THÀNH CÔNG
                UserDAO.updateLastLogin(user.getUserId());
                
                HttpSession session = request.getSession();
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("role", user.getRole());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("user", user); // ✅ Thêm user object vào session để LoggingUtil dùng

                // 🔹 GHI LOG LOGIN THÀNH CÔNG
                LoggingUtil.logLogin(request, user);

                String role = user.getRole();

                switch (role) {
                    case "Doctor":
                        response.sendRedirect(request.getContextPath() + "/doctor-dashboard");
                        break;
                    case "Pharmacist":
                        response.sendRedirect(request.getContextPath() + "/view-medicine");
                        break;
                    case "Manager":
                        response.sendRedirect(request.getContextPath() + "/manager-dashboard");
                        break;
                    case "Admin":
                        response.sendRedirect(request.getContextPath() + "/admin-dashboard");
                        break;
                    case "Supplier":
                        response.sendRedirect(request.getContextPath() + "/supplier-dashboard");
                        break;
                    case "Auditor":
                        response.sendRedirect(request.getContextPath() + "/auditor-dashboard");
                        break;
                    default:
                        response.sendRedirect(request.getContextPath() + "/home.jsp");
                        break;
                }

            } else {
                // ❌ LOGIN THẤT BẠI - Sai tài khoản hoặc mật khẩu

                // 🔹 GHI LOG LOGIN FAILED
                LoggingUtil.logFailedLogin(request, emailOrUsername);

                request.setAttribute("error", "Sai email/username hoặc mật khẩu!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();

            // 🔹 GHI LOG LỖI HỆ THỐNG
            String ipAddress = LoggingUtil.getClientIP(request);
            System.err.println("Login error for: " + emailOrUsername + " from IP: " + ipAddress);

            request.setAttribute("error", "Đã xảy ra lỗi khi đăng nhập!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý đăng nhập người dùng với logging";
    }
}
