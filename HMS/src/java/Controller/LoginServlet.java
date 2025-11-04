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

            if (user == null) {
                // ❌ LOGIN THẤT BẠI - Không tìm thấy user
                LoggingUtil.logFailedLogin(request, emailOrUsername);
                request.setAttribute("error", "Sai email/username hoặc mật khẩu!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else if (!user.getIsActive()) {
                // ❌ TÀI KHOẢN BỊ KHÓA
                LoggingUtil.logFailedLogin(request, emailOrUsername); // Có thể log với lý do locked nếu cần tùy chỉnh LoggingUtil
                request.setAttribute("error", "Tài khoản của bạn đã bị khóa do vi phạm chính sách, vui lòng liên hệ admin nếu bạn tin rằng đây là sai xót.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else if (!PasswordUtils.verify(password, user.getPasswordHash())) {
                // ❌ LOGIN THẤT BẠI - Sai mật khẩu
                LoggingUtil.logFailedLogin(request, emailOrUsername);
                request.setAttribute("error", "Sai email/username hoặc mật khẩu!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
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