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

/**
 *
 * @author nguye
 */
public class EditServlet extends HttpServlet {
   private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        try {
            User u = userDAO.findById(id);
            req.setAttribute("user", u);
            req.getRequestDispatcher("/admin/user_form_edit.jsp").forward(req, resp);  // Đảm bảo đường dẫn đúng
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("userId"));
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String role = req.getParameter("role");

        User u = new User(id, username, email, phone, role);
        try {
            userDAO.update(u);
            resp.sendRedirect(req.getContextPath() + "/admin-dashboard");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

}
