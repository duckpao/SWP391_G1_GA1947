package Controller;

import DAO.UserDAO;
import DAO.SupplierDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import model.User;
import util.PasswordUtils;

public class LoginServlet extends HttpServlet {

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
                HttpSession session = request.getSession();
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("role", user.getRole());
                session.setAttribute("username", user.getUsername());

                String role = user.getRole();

                switch (role) {
                    case "Doctor":
                        response.sendRedirect(request.getContextPath() + "/doctor-dashboard");
                        break;

                    case "Pharmacist":
                        response.sendRedirect(request.getContextPath() + "/pharmacist-dashboard");
                        break;

                    case "Manager":
                        response.sendRedirect(request.getContextPath() + "/manager-dashboard");
                        break;

                    case "Admin":
                        response.sendRedirect(request.getContextPath() + "/admin-dashboard");
                        break;

                    case "Supplier":
//                        // 🔹 Lấy supplierId tương ứng userId
//                        Integer supplierId = supplierDAO.getSupplierIdByUserId(user.getUserId());
//                        if (supplierId == null) {
//                            // Nếu user chưa có supplier record → tự thêm
//                            supplierDAO.addSupplierFromUser(user.getUserId());
//                            supplierId = supplierDAO.getSupplierIdByUserId(user.getUserId());
//                        }
//                        session.setAttribute("supplierId", supplierId);
                        response.sendRedirect(request.getContextPath() + "/supplier/supplier-dashboard.jsp");
                        
                        break;

                    case "Auditor":
                        response.sendRedirect(request.getContextPath() + "/jsp/auditor-dashboard.jsp");
                        break;

                    default:
                        response.sendRedirect(request.getContextPath() + "/home.jsp");
                        break;
                }

            } else {
                // Sai tài khoản hoặc mật khẩu
                request.setAttribute("error", "Sai email/username hoặc mật khẩu!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi đăng nhập!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý đăng nhập người dùng";
    }
}