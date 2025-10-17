package Controller;

import DAO.PermissionDAO;
import DAO.UserDAO;
import model.Permission;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ManagePermissionsServlet extends HttpServlet {
    
    private UserDAO userDAO;
    private PermissionDAO permissionDAO;
    
    @Override
    public void init() {
        userDAO = new UserDAO();
        permissionDAO = new PermissionDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Lấy tất cả users và permissions
            List<User> users = userDAO.findAll();
            List<Permission> allPermissions = permissionDAO.getAllPermissions();
            
            // Nếu có chọn user, load permissions của user đó
            String userIdParam = request.getParameter("userId");
            if (userIdParam != null && !userIdParam.isEmpty()) {
                try {
                    int userId = Integer.parseInt(userIdParam);
                    User selectedUser = userDAO.findById(userId);
                    List<Integer> userPermissionIds = permissionDAO.getPermissionIdsByUserId(userId);
                    
                    request.setAttribute("selectedUser", selectedUser);
                    request.setAttribute("userPermissionIds", userPermissionIds);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
            
            request.setAttribute("users", users);
            request.setAttribute("allPermissions", allPermissions);
            
            // SỬA ĐƯỜNG DẪN NÀY
            request.getRequestDispatcher("/admin/manage-permissions.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/users?error=database_error");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String[] permissionIdsArray = request.getParameterValues("permissionIds");
            
            List<Integer> permissionIds = new ArrayList<>();
            if (permissionIdsArray != null) {
                for (String id : permissionIdsArray) {
                    permissionIds.add(Integer.parseInt(id));
                }
            }
            
            boolean success = permissionDAO.updateUserPermissions(userId, permissionIds);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/permissions?userId=" + userId + "&success=updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/permissions?userId=" + userId + "&error=update_failed");
            }
            
        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/permissions?error=invalid_input");
        }
    }
}