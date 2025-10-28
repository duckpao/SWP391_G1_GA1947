package Controller;

import DAO.SystemLogsDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.SystemLog;
import model.User;
import model.UserActivityReport;
import util.LoggingUtil;

import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Servlet for User Activity Reports
 * Handles report generation and filtering
 * Maps to: /user-reports/generate
 */
@WebServlet(name = "UserReportServlet", urlPatterns = {"/user-reports/generate"})
public class UserReportServlet extends HttpServlet {
    
    private final SystemLogsDAO logsDAO = new SystemLogsDAO();
    
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
            // Get parameters
            String reportType = request.getParameter("type");
            
            // Generate report based on type
            if ("summary".equals(reportType)) {
                generateSummaryReport(request, response);
            } else if ("detailed".equals(reportType)) {
                generateDetailedReport(request, response);
            } else {
                // Default: load report page with empty data
                loadReportPage(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error generating report: " + e.getMessage());
            request.getRequestDispatcher("/admin/user-activity-reports.jsp").forward(request, response);
        }
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
        
        doGet(request, response);
    }
    
    /**
     * Load report page without data
     */
    private void loadReportPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Log page view
        LoggingUtil.logView(request, "User Activity Reports");
        
        // Set default date range (last 30 days)
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date endDate = new Date();
        Date startDate = new Date(endDate.getTime() - (30L * 24 * 60 * 60 * 1000));
        
        request.setAttribute("defaultStartDate", sdf.format(startDate));
        request.setAttribute("defaultEndDate", sdf.format(endDate));
        
        // Get available roles for filter
        String[] roles = {"Doctor", "Pharmacist", "Manager", "Auditor", "Admin", "ProcurementOfficer", "Supplier"};
        request.setAttribute("roles", roles);
        
        request.getRequestDispatcher("/admin/user-activity-reports.jsp").forward(request, response);
    }
    
    /**
     * Generate summary report
     */
    private void generateSummaryReport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        // Get filter parameters
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String role = request.getParameter("role");
        
        // Debug
        System.out.println("Generating summary report:");
        System.out.println("  Start Date: " + startDate);
        System.out.println("  End Date: " + endDate);
        System.out.println("  Role: " + role);
        
        // Get report data
        List<UserActivityReport> reports = logsDAO.getUserActivitySummary(startDate, endDate, role);
        
        // Calculate totals
        int totalUsers = reports.size();
        int totalActions = reports.stream().mapToInt(UserActivityReport::getTotalActions).sum();
        int totalLogins = reports.stream().mapToInt(UserActivityReport::getLoginCount).sum();
        
        // Set attributes
        request.setAttribute("reportType", "summary");
        request.setAttribute("summaryReports", reports);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("selectedRole", role);
        
        // Set statistics
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalActions", totalActions);
        request.setAttribute("totalLogins", totalLogins);
        
        // Get available roles for filter
        String[] roles = {"Doctor", "Pharmacist", "Manager", "Auditor", "Admin", "ProcurementOfficer", "Supplier"};
        request.setAttribute("roles", roles);
        
        // Log report generation
        LoggingUtil.logReportGeneration(request, "User Activity Summary");
        
        // Forward to JSP
        request.getRequestDispatcher("/admin/user-activity-reports.jsp").forward(request, response);
    }
    
    /**
     * Generate detailed activity report
     */
    private void generateDetailedReport(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException, SQLException {
        
        // Get filter parameters
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String role = request.getParameter("role");
        String username = request.getParameter("username");
        String action = request.getParameter("actionFilter");
        
        // Debug
        System.out.println("Generating detailed report:");
        System.out.println("  Start Date: " + startDate);
        System.out.println("  End Date: " + endDate);
        System.out.println("  Role: " + role);
        System.out.println("  Username: " + username);
        System.out.println("  Action: " + action);
        
        // Get report data
        List<SystemLog> logs = logsDAO.getDetailedActivityReport(startDate, endDate, role, username, action);
        
        // Set attributes
        request.setAttribute("reportType", "detailed");
        request.setAttribute("detailedLogs", logs);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("selectedRole", role);
        request.setAttribute("username", username);
        request.setAttribute("selectedAction", action);
        
        // Get available roles and actions for filters
        String[] roles = {"Doctor", "Pharmacist", "Manager", "Auditor", "Admin", "ProcurementOfficer", "Supplier"};
        String[] actions = {"LOGIN", "LOGOUT", "CREATE_USER", "UPDATE_USER", "DELETE_USER", 
                          "VIEW_DASHBOARD", "GENERATE_REPORT", "EXPORT_REPORT"};
        request.setAttribute("roles", roles);
        request.setAttribute("actions", actions);
        
        // Log report generation
        LoggingUtil.logReportGeneration(request, "User Activity Details");
        
        // Forward to JSP
        request.getRequestDispatcher("/admin/user-activity-reports.jsp").forward(request, response);
    }
    
    @Override
    public String getServletInfo() {
        return "User Activity Reports Servlet - Generate user activity reports";
    }
}