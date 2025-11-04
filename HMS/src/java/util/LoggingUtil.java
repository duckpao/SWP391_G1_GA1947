package util;

import DAO.SystemLogsDAO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 * Utility class for easy logging of user activities
 * Simplifies logging calls throughout the application
 */
public class LoggingUtil {
    
    private static final SystemLogsDAO logsDAO = new SystemLogsDAO();
    
    /**
     * Log user action with automatic user detection from session
     */
    public static void logAction(HttpServletRequest request, String action, String details) {
        try {
            HttpSession session = request.getSession(false);
            if (session != null) {
                User user = (User) session.getAttribute("user");
                if (user != null) {
                    String ipAddress = getClientIP(request);
                    logsDAO.log(user.getUserId(), action, details, ipAddress);
                }
            }
        } catch (Exception e) {
            System.err.println("Failed to log action: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Log action with specific user ID
     */
    public static void logAction(int userId, String action, String details, String ipAddress) {
        try {
            logsDAO.log(userId, action, details, ipAddress);
        } catch (Exception e) {
            System.err.println("Failed to log action: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Log login action
     */
    public static void logLogin(HttpServletRequest request, User user) {
        String ipAddress = getClientIP(request);
        String details = String.format("User '%s' logged in successfully", user.getUsername());
        logAction(user.getUserId(), "LOGIN", details, ipAddress);
    }
    
    /**
     * Log failed login attempt
     */
    public static void logFailedLogin(HttpServletRequest request, String username) {
        String ipAddress = getClientIP(request);
        String details = String.format("Failed login attempt for username: %s", username);
        // Use userId = 0 for failed attempts or get userId from username lookup
        logAction(0, "LOGIN_FAILED", details, ipAddress);
    }
    
    /**
     * Log logout action
     */
    public static void logLogout(HttpServletRequest request) {
        try {
            HttpSession session = request.getSession(false);
            if (session != null) {
                User user = (User) session.getAttribute("user");
                if (user != null) {
                    String ipAddress = getClientIP(request);
                    String details = String.format("User '%s' logged out", user.getUsername());
                    logAction(user.getUserId(), "LOGOUT", details, ipAddress);
                }
            }
        } catch (Exception e) {
            System.err.println("Failed to log logout: " + e.getMessage());
        }
    }
    
    /**
     * Log CREATE operation
     */
    public static void logCreate(HttpServletRequest request, String tableName, int recordId, String details) {
        logAction(request, "CREATE_" + tableName.toUpperCase(), details);
    }
    
    /**
     * Log UPDATE operation
     */
    public static void logUpdate(HttpServletRequest request, String tableName, int recordId, String details) {
        logAction(request, "UPDATE_" + tableName.toUpperCase(), details);
    }
    
    /**
     * Log DELETE operation
     */
    public static void logDelete(HttpServletRequest request, String tableName, int recordId, String details) {
        logAction(request, "DELETE_" + tableName.toUpperCase(), details);
    }
    
    /**
     * Log VIEW operation
     */
    public static void logView(HttpServletRequest request, String resourceName) {
        String details = String.format("Viewed %s", resourceName);
        logAction(request, "VIEW_" + resourceName.toUpperCase(), details);
    }
    
    /**
     * Log report generation
     */
    public static void logReportGeneration(HttpServletRequest request, String reportType) {
        String details = String.format("Generated %s report", reportType);
        logAction(request, "GENERATE_REPORT", details);
    }
    
    /**
     * Log export action
     */
    public static void logExport(HttpServletRequest request, String exportType, String format) {
        String details = String.format("Exported %s as %s", exportType, format);
        logAction(request, "EXPORT_REPORT", details);
    }
    
    /**
     * Log user management actions
     */
    public static void logUserCreate(HttpServletRequest request, String newUsername) {
        String details = String.format("Created new user: %s", newUsername);
        logAction(request, "CREATE_USER", details);
    }
    
    public static void logUserUpdate(HttpServletRequest request, String username) {
        String details = String.format("Updated user: %s", username);
        logAction(request, "UPDATE_USER", details);
    }
    
    public static void logUserDelete(HttpServletRequest request, String username) {
        String details = String.format("Deleted user: %s", username);
        logAction(request, "DELETE_USER", details);
    }
    
    public static void logUserToggleStatus(HttpServletRequest request, String username, boolean isActive) {
        String status = isActive ? "activated" : "deactivated";
        String details = String.format("User %s: %s", status, username);
        logAction(request, "TOGGLE_USER_STATUS", details);
    }
    
    /**
     * Get client IP address from request
     */
    public static String getClientIP(HttpServletRequest request) {
        String ipAddress = request.getHeader("X-Forwarded-For");
        
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getHeader("Proxy-Client-IP");
        }
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ipAddress == null || ipAddress.isEmpty() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getRemoteAddr();
        }
        
        // If multiple IPs, take the first one
        if (ipAddress != null && ipAddress.contains(",")) {
            ipAddress = ipAddress.split(",")[0].trim();
        }
        
        return ipAddress;
    }
    
    /**
     * Get user from session
     */
    public static User getUserFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (User) session.getAttribute("user");
        }
        return null;
    }
}