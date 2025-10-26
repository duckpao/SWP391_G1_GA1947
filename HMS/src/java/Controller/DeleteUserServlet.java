package Controller;

import DAO.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import model.User;
import util.LoggingUtil;

/**
 * Servlet for deleting users with comprehensive logging
 */
public class DeleteUserServlet extends HttpServlet {
    
    private final UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String userIdParam = request.getParameter("id");
        
        if (userIdParam == null || userIdParam.isEmpty()) {
            // Log invalid request
            LoggingUtil.logAction(request, "DELETE_USER_FAILED", 
                "Delete attempt with invalid or missing user ID");
            
            response.sendRedirect(request.getContextPath() + 
                "/admin-dashboard?error=invalid_id");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdParam);
            
            // Get user info before deleting (for logging purposes)
            User userToDelete = userDAO.findById(userId);
            
            if (userToDelete == null) {
                // Log attempt to delete non-existent user
                LoggingUtil.logAction(request, "DELETE_USER_FAILED", 
                    String.format("Attempted to delete non-existent user (ID: %d)", userId));
                
                response.sendRedirect(request.getContextPath() + 
                    "/admin-dashboard?error=user_not_found");
                return;
            }
            
            // Check if trying to delete Admin
            if ("Admin".equals(userToDelete.getRole())) {
                // Log unauthorized attempt to delete Admin
                LoggingUtil.logAction(request, "DELETE_USER_BLOCKED", 
                    String.format("Blocked attempt to delete Admin user: %s (ID: %d)", 
                    userToDelete.getUsername(), userId));
                
                response.sendRedirect(request.getContextPath() + 
                    "/admin-dashboard?error=cannot_delete_admin");
                return;
            }
            
            // Store user details for logging
            String username = userToDelete.getUsername();
            String email = userToDelete.getEmail();
            String role = userToDelete.getRole();
            
            // Perform deletion
            boolean isDeleted = userDAO.delete(userId);
            
            if (isDeleted) {
                // Log successful deletion with full details
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
                    String.format("Failed to delete user: %s (ID: %d) - Database operation returned false", 
                    username, userId));
                
                response.sendRedirect(request.getContextPath() + 
                    "/admin-dashboard?error=delete_failed");
            }
            
        } catch (NumberFormatException e) {
            // Log invalid ID format
            LoggingUtil.logAction(request, "DELETE_USER_FAILED", 
                String.format("Invalid user ID format: %s", userIdParam));
            
            response.sendRedirect(request.getContextPath() + 
                "/admin-dashboard?error=invalid_id_format");
            
        } catch (SQLException e) {
            e.printStackTrace();
            
            // Log database error
            LoggingUtil.logAction(request, "DELETE_USER_ERROR", 
                String.format("Database error during deletion | User ID: %s | Error: %s", 
                userIdParam, e.getMessage()));
            
            response.sendRedirect(request.getContextPath() + 
                "/admin-dashboard?error=database_error");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Log unauthorized GET request
        LoggingUtil.logAction(request, "DELETE_USER_BLOCKED", 
            "Blocked DELETE request via GET method - only POST allowed");
        
        response.sendRedirect(request.getContextPath() + 
            "/admin-dashboard?error=invalid_method");
    }
    
    @Override
    public String getServletInfo() {
        return "Delete User Servlet with Comprehensive Logging and Security Checks";
    }
}