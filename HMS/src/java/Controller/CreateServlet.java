/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller;

import DAO.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import model.User;
import util.PasswordUtils;

/**
 *
 * @author nguye
 */
public class CreateServlet extends HttpServlet {
   private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Chuyển hướng tới user_form_create.jsp trong thư mục admin
        request.getRequestDispatcher("/admin/user_form_create.jsp").forward(request, response);  // Đảm bảo đường dẫn chính xác
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");

        // Hash mật khẩu trước khi lưu
        String hashedPassword = PasswordUtils.hash(password);

        User newUser = new User(username, hashedPassword, email, phone, role);

        try {
            userDAO.create(newUser);
            response.sendRedirect(request.getContextPath() + "/admin-dashboard");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    public String getServletInfo() {
        return "Create User Servlet";
    }
}
