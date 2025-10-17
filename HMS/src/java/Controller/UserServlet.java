package Controller;

import DAO.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.List;
import model.User;

/**
 * Servlet for managing users with filter support
 */
public class UserServlet extends HttpServlet {
    
    private final UserDAO userDAO = new UserDAO();
    
    /**
     * Handles GET requests - displays user list with filtering
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Get filter parameters
            String keyword = request.getParameter("keyword");
            String role = request.getParameter("role");
            String status = request.getParameter("status");
            
            // Debug: In ra console để kiểm tra
            System.out.println("DEBUG - Filter Parameters:");
            System.out.println("  keyword: " + keyword);
            System.out.println("  role: " + role);
            System.out.println("  status: " + status);
            
            List<User> users;
            
            // Check if any filter is applied
            boolean hasFilter = (keyword != null && !keyword.trim().isEmpty()) ||
                              (role != null && !role.trim().isEmpty()) ||
                              (status != null && !status.trim().isEmpty());
            
            System.out.println("  hasFilter: " + hasFilter);
            
            if (hasFilter) {
                // Use filter method
                users = userDAO.filterUsers(keyword, role, status);
                System.out.println("  Filtered users count: " + users.size());
            } else {
                // Get all users
                users = userDAO.findAll();
                System.out.println("  All users count: " + users.size());
            }
            
            // Get statistics
            int totalUsers = userDAO.countAll();
            int activeUsers = userDAO.countActive();
            int lockedUsers = userDAO.countInactive();
            
            // Set attributes for JSP
            request.setAttribute("users", users);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("activeUsers", activeUsers);
            request.setAttribute("lockedUsers", lockedUsers);
            
            // Forward to JSP
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách người dùng: " + e.getMessage());
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        }
    }
    
    /**
     * Handles POST requests - for toggle and delete actions
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getServletPath();
        
        try {
            if (action.endsWith("/toggle")) {
                handleToggleStatus(request, response);
            } else if (action.endsWith("/delete")) {
                handleDelete(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/users?error=" + e.getMessage());
        }
    }
    
    /**
     * Toggle user active status
     */
    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        String idParam = request.getParameter("id");
        String activeParam = request.getParameter("active");
        
        if (idParam != null && activeParam != null) {
            int userId = Integer.parseInt(idParam);
            
            // Kiểm tra xem user có phải Admin không
            User user = userDAO.findById(userId);
            if (user != null && "Admin".equals(user.getRole())) {
                // Không cho phép khóa/mở Admin
                response.sendRedirect(request.getContextPath() + 
                    "/admin/users?error=cannot_modify_admin");
                return;
            }
            
            boolean active = Boolean.parseBoolean(activeParam);
            userDAO.setActive(userId, active);
        }
        
        // Redirect back to list
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
    
    /**
     * Delete user
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (idParam != null) {
            int userId = Integer.parseInt(idParam);
            
            // Kiểm tra xem user có phải Admin không
            User user = userDAO.findById(userId);
            if (user != null && "Admin".equals(user.getRole())) {
                // Không cho phép xóa Admin
                response.sendRedirect(request.getContextPath() + 
                    "/admin/users?error=cannot_delete_admin");
                return;
            }
            
            boolean deleted = userDAO.delete(userId);
            
            if (deleted) {
                response.sendRedirect(request.getContextPath() + "/admin/users?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=delete_failed");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }
    
    @Override
    public String getServletInfo() {
        return "User Management Servlet with Filter Support";
    }
}