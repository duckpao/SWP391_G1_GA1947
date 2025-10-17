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

/**
 *
 * @author nguye
 */
public class DeleteUserServlet extends HttpServlet {
   @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userIdParam = request.getParameter("id");

        if (userIdParam != null && !userIdParam.isEmpty()) {
            try {
                int userId = Integer.parseInt(userIdParam);

                // Tạo một đối tượng UserDAO để thao tác với cơ sở dữ liệu
                UserDAO userDAO = new UserDAO();

                // Xóa người dùng
                boolean isDeleted = userDAO.delete(userId);

                // Chuyển hướng đến trang quản lý người dùng với thông báo thành công hoặc thất bại
                if (isDeleted) {
                    response.sendRedirect(request.getContextPath() + "/admin-dashboard?message=deleteSuccess");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin-dashboard?message=deleteFail");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/admin/users?message=error");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/users?message=invalidId");
        }
    }

}
