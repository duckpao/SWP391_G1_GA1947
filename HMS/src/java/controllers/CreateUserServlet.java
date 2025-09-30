package controllers;


import DAO.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import models.User;
import util.PasswordUtils;

@WebServlet(name = "CreateUserServlet", urlPatterns = {"/admin/users/create"})
public class CreateUserServlet extends HttpServlet {
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
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    public String getServletInfo() {
        return "Create User Servlet";
    }
}
