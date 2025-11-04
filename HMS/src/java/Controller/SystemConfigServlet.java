package Controller;

import DAO.SystemConfigDAO;
import model.SystemConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Servlet for System Configuration Management
 */
public class SystemConfigServlet extends HttpServlet {

    private SystemConfigDAO configDAO;

    @Override
    public void init() throws ServletException {
        configDAO = new SystemConfigDAO();
    }

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
        
        // Get all configurations
        List<SystemConfig> configs = configDAO.getAllConfigs();
        
        // Set attributes for JSP
        request.setAttribute("configs", configs);
        
        // Forward to JSP
        request.getRequestDispatcher("/admin/system-config.jsp").forward(request, response);
    }

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

        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        if ("update".equals(action)) {
            handleUpdate(request, response);
        } else if ("delete".equals(action)) {
            handleDelete(request, response);
        } else if ("add".equals(action)) {
            handleAdd(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin-dashboard/config");
        }
    }

    /**
     * Handle updating configuration values
     */
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        try {
            // Get all configuration keys from the form
            String[] keys = request.getParameterValues("config_key");
            String[] values = request.getParameterValues("config_value");
            
            if (keys != null && values != null && keys.length == values.length) {
                boolean allSuccess = true;
                
                for (int i = 0; i < keys.length; i++) {
                    String key = keys[i];
                    String value = values[i];
                    
                    if (key != null && !key.trim().isEmpty()) {
                        boolean success = configDAO.updateConfig(key, value);
                        if (!success) {
                            allSuccess = false;
                        }
                    }
                }
                
                if (allSuccess) {
                    response.sendRedirect(request.getContextPath() + 
                        "/admin-dashboard/config?success=updated");
                } else {
                    response.sendRedirect(request.getContextPath() + 
                        "/admin-dashboard/config?error=update_failed");
                }
            } else {
                response.sendRedirect(request.getContextPath() + 
                    "/admin-dashboard/config?error=invalid_data");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + 
                "/admin-dashboard/config?error=exception");
        }
    }

    /**
     * Handle adding new configuration
     */
    private void handleAdd(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        try {
            String newKey = request.getParameter("new_key");
            String newValue = request.getParameter("new_value");
            
            if (newKey != null && !newKey.trim().isEmpty()) {
                // Check if key already exists
                SystemConfig existing = configDAO.getConfigByKey(newKey.trim());
                
                if (existing != null) {
                    response.sendRedirect(request.getContextPath() + 
                        "/admin-dashboard/config?error=key_exists");
                    return;
                }
                
                boolean success = configDAO.upsertConfig(newKey.trim(), 
                    newValue != null ? newValue.trim() : "");
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + 
                        "/admin-dashboard/config?success=added");
                } else {
                    response.sendRedirect(request.getContextPath() + 
                        "/admin-dashboard/config?error=add_failed");
                }
            } else {
                response.sendRedirect(request.getContextPath() + 
                    "/admin-dashboard/config?error=empty_key");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + 
                "/admin-dashboard/config?error=exception");
        }
    }

    /**
     * Handle deleting configuration
     */
    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        try {
            String key = request.getParameter("key");
            
            if (key != null && !key.trim().isEmpty()) {
                // Prevent deletion of critical system configs
                if (isCriticalConfig(key)) {
                    response.sendRedirect(request.getContextPath() + 
                        "/admin-dashboard/config?error=cannot_delete_critical");
                    return;
                }
                
                boolean success = configDAO.deleteConfig(key);
                
                if (success) {
                    response.sendRedirect(request.getContextPath() + 
                        "/admin-dashboard/config?success=deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + 
                        "/admin-dashboard/config?error=delete_failed");
                }
            } else {
                response.sendRedirect(request.getContextPath() + 
                    "/admin-dashboard/config?error=invalid_key");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + 
                "/admin-dashboard/config?error=exception");
        }
    }

    /**
     * Check if a configuration is critical and shouldn't be deleted
     */
    private boolean isCriticalConfig(String key) {
        // Define critical configuration keys that should not be deleted
        String[] criticalKeys = {
            "low_stock_threshold",
            "max_failed_attempts",
            "quarantine_period_days"
        };
        
        for (String criticalKey : criticalKeys) {
            if (criticalKey.equals(key)) {
                return true;
            }
        }
        
        return false;
    }
}