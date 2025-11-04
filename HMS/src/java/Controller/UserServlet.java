package Controller;

import DAO.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.List;
import model.User;
import util.LoggingUtil;

/**
 * Servlet for managing users with filter support and comprehensive logging
 */
public class UserServlet extends HttpServlet {
    
    private final UserDAO userDAO = new UserDAO();
    
    /**
     * Handles GET requests - displays user list with filtering
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String userRole = (String) session.getAttribute("role");
        if (!"Admin".equals(userRole)) {
            request.setAttribute("errorMessage", "Access denied. This page is for Admins only.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }
        
        try {
            // Get filter parameters
            String keyword = request.getParameter("keyword");
            String role = request.getParameter("role");
            String status = request.getParameter("status");
            
            // Debug logging
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
                
                // Log filter usage
                String filterDetails = String.format(
                    "Applied user filters | Keyword: %s | Role: %s | Status: %s | Results: %d",
                    keyword != null ? keyword : "none",
                    role != null ? role : "none",
                    status != null ? status : "none",
                    users.size()
                );
                LoggingUtil.logAction(request, "FILTER_USERS", filterDetails);
            } else {
                // Get all users
                users = userDAO.findAll();
                System.out.println("  All users count: " + users.size());
                
                // Log view all
                LoggingUtil.logView(request, "User Management Dashboard");
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
            
            // Log error
            LoggingUtil.logAction(request, "VIEW_USERS_ERROR", 
                "Error loading user list: " + e.getMessage());
            
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
        
        // Check session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String userRole = (String) session.getAttribute("role");
        if (!"Admin".equals(userRole)) {
            request.setAttribute("errorMessage", "Access denied. This page is for Admins only.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }
        
        String action = request.getServletPath();
        
        try {
            if (action.endsWith("/toggle")) {
                handleToggleStatus(request, response);
            } else if (action.endsWith("/delete")) {
                handleDelete(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            
            // Log error
            LoggingUtil.logAction(request, "USER_ACTION_ERROR", 
                String.format("Error in %s action: %s", action, e.getMessage()));
            
            response.sendRedirect(request.getContextPath() + 
                "/admin-dashboard?error=" + e.getMessage());
        }
    }
    
    /**
     * Toggle user active status with logging
     */
    private void handleToggleStatus(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        String idParam = request.getParameter("id");
        String activeParam = request.getParameter("active");
        
        if (idParam != null && activeParam != null) {
            int userId = Integer.parseInt(idParam);
            boolean newStatus = Boolean.parseBoolean(activeParam);
            
            // Get user info for logging
            User user = userDAO.findById(userId);
            
            if (user == null) {
                LoggingUtil.logAction(request, "TOGGLE_STATUS_FAILED", 
                    String.format("User not found (ID: %d)", userId));
                
                response.sendRedirect(request.getContextPath() + 
                    "/admin-dashboard?error=user_not_found");
                return;
            }
            
            // Check if user is Admin
            if ("Admin".equals(user.getRole())) {
                // Log blocked attempt to modify Admin
                LoggingUtil.logAction(request, "TOGGLE_STATUS_BLOCKED", 
                    String.format("Blocked attempt to toggle Admin status: %s (ID: %d)", 
                    user.getUsername(), userId));
                
                response.sendRedirect(request.getContextPath() + 
                    "/admin-dashboard?error=cannot_modify_admin");
                return;
            }
            
            // Get old status
            boolean oldStatus = user.getIsActive();
            
            // Perform toggle
            userDAO.setActive(userId, newStatus);
            
            // Log status change with details
            String statusAction = newStatus ? "activated" : "deactivated";
            String details = String.format(
                "User %s: %s (ID: %d) | Status changed from %s to %s",
                statusAction, user.getUsername(), userId,
                oldStatus ? "Active" : "Inactive",
                newStatus ? "Active" : "Inactive"
            );
            
            LoggingUtil.logUserToggleStatus(request, user.getUsername(), newStatus);
            LoggingUtil.logAction(request, "TOGGLE_USER_STATUS_DETAIL", details);
        }
        
        // Redirect back to list
        response.sendRedirect(request.getContextPath() + "/admin-dashboard");
    }
    
    /**
     * Delete user with comprehensive logging
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (idParam != null) {
            int userId = Integer.parseInt(idParam);
            
            // Get user info before deletion
            User user = userDAO.findById(userId);
            
            if (user == null) {
                LoggingUtil.logAction(request, "DELETE_USER_FAILED", 
                    String.format("User not found (ID: %d)", userId));
                
                response.sendRedirect(request.getContextPath() + 
                    "/admin-dashboard?error=user_not_found");
                return;
            }
            
            // Check if user is Admin
            if ("Admin".equals(user.getRole())) {
                // Log blocked deletion attempt
                LoggingUtil.logAction(request, "DELETE_USER_BLOCKED", 
                    String.format("Blocked attempt to delete Admin: %s (ID: %d)", 
                    user.getUsername(), userId));
                
                response.sendRedirect(request.getContextPath() + 
                    "/admin-dashboard?error=cannot_delete_admin");
                return;
            }
            
            // Store user details for logging
            String username = user.getUsername();
            String role = user.getRole();
            String email = user.getEmail();
            
            // Perform deletion
            boolean deleted = userDAO.delete(userId);
            
            if (deleted) {
                // Log successful deletion
                String details = String.format(
                    "Deleted user: %s (ID: %d) | Role: %s | Email: %s",
                    username, userId, role, email != null ? email : "N/A"
                );
                
                LoggingUtil.logUserDelete(request, username);
                LoggingUtil.logAction(request, "DELETE_USER_DETAIL", details);
                
                response.sendRedirect(request.getContextPath() + 
                    "/admin-dashboard?success=deleted&user=" + username);
            } else {
                // Log failed deletion
                LoggingUtil.logAction(request, "DELETE_USER_FAILED", 
                    String.format("Failed to delete user: %s (ID: %d)", username, userId));
                
                response.sendRedirect(request.getContextPath() + 
                    "/admin-dashboard?error=delete_failed");
            }
        } else {
            // Log invalid request
            LoggingUtil.logAction(request, "DELETE_USER_FAILED", 
                "Delete request with missing user ID");
            
            response.sendRedirect(request.getContextPath() + "/admin-dashboard");
        }
    }
    
    @Override
    public String getServletInfo() {
        return "User Management Servlet with Filter Support and Comprehensive Logging";
    }
}