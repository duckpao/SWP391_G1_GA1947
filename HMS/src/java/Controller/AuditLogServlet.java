/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.AudtitLogDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;
import model.AuditLog;
import model.AuditStatistics;
import model.User;
import util.LoggingUtil;

/**
 *
 * @author ADMIN
 */
public class AuditLogServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AuditLogServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AuditLogServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private AudtitLogDAO auditLogDAO = new AudtitLogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = LoggingUtil.getUserFromSession(request);
        if (user == null || (!user.getRole().equals("Auditor") && !user.getRole().equals("Admin"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "view";
        }

        switch (action) {
            case "view":
                viewAuditLogs(request, response, user);
                break;
            case "statistics":
                viewStatistics(request, response, user);
                break;
            case "export":
                exportReport(request, response, user);
                break;
            case "alerts":
                viewAlerts(request, response, user);
                break;
            default:
                viewAuditLogs(request, response, user);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private void viewAuditLogs(HttpServletRequest request, HttpServletResponse response, User user)
        throws ServletException, IOException {

    // Get filter parameters
    String startDate = request.getParameter("startDate");
    String endDate = request.getParameter("endDate");
    String username = request.getParameter("username");
    String role = request.getParameter("role");
    String actionFilter = request.getParameter("actionFilter");
    String tableName = request.getParameter("tableName");
    String riskLevel = request.getParameter("riskLevel");
    String category = request.getParameter("category");

    // Pagination
    int pageNumber = 1;
    int pageSize = 20;

    try {
        if (request.getParameter("page") != null) {
            pageNumber = Integer.parseInt(request.getParameter("page"));
        }
        if (request.getParameter("pageSize") != null) {
            pageSize = Integer.parseInt(request.getParameter("pageSize"));
        }
    } catch (NumberFormatException e) {
        pageNumber = 1;
    }

    // ✅ USE NEW METHOD THAT RETURNS BOTH LOGS + TOTAL
    Map<String, Object> result = auditLogDAO.getAuditLogsWithTotal(
            user.getUserId(),
            startDate,
            endDate,
            username,
            role,
            actionFilter,
            tableName,
            riskLevel,
            category,
            pageNumber,
            pageSize
    );

    List<AuditLog> logs = (List<AuditLog>) result.get("logs");
    int totalRecords = (int) result.get("totalRecords");

    // ✅ CALCULATE TOTAL PAGES FROM FILTERED RESULTS
    int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

    // Filter options
    List<String> actions = auditLogDAO.getDistinctActions(user.getUserId(), user.getRole());
    List<String> tables = auditLogDAO.getDistinctTableNames(user.getUserId(), user.getRole());
    List<String> roles = auditLogDAO.getDistinctRoles();

    // Set attributes
    request.setAttribute("logs", logs);
    request.setAttribute("currentPage", pageNumber);
    request.setAttribute("totalPages", totalPages);
    request.setAttribute("totalRecords", totalRecords); // ✅ NOW CORRECT
    request.setAttribute("pageSize", pageSize);
    request.setAttribute("actions", actions);
    request.setAttribute("tables", tables);
    request.setAttribute("roles", roles);

    request.setAttribute("currentUser", user);
    request.setAttribute("isAuditor", user.getRole().equals("Auditor"));

    // ✅ PRESERVE ALL FILTERS FOR PAGINATION
    request.setAttribute("startDate", startDate != null ? startDate : "");
    request.setAttribute("endDate", endDate != null ? endDate : "");
    request.setAttribute("username", username != null ? username : "");
    request.setAttribute("role", role != null ? role : "");
    request.setAttribute("actionFilter", actionFilter != null ? actionFilter : "");
    request.setAttribute("tableName", tableName != null ? tableName : "");
    request.setAttribute("riskLevel", riskLevel != null ? riskLevel : "");
    request.setAttribute("category", category != null ? category : "");

    LoggingUtil.logView(request, "AUDIT_LOGS");

    request.getRequestDispatcher("auditor/auditLog.jsp").forward(request, response);
}

    private void viewStatistics(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        // UPDATED: Pass currentUserId
        AuditStatistics stats = auditLogDAO.getAuditStatistics(
                user.getUserId(), // <-- Pass current user ID
                startDate,
                endDate
        );

        request.setAttribute("statistics", stats);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("currentUser", user);
        request.setAttribute("isAuditor", user.getRole().equals("Auditor"));

        LoggingUtil.logView(request, "AUDIT_STATISTICS");

        request.getRequestDispatcher("auditor/auditStatistics.jsp").forward(request, response);
    }

    private void exportReport(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String reportType = request.getParameter("reportType");
        String format = request.getParameter("format");

        if (reportType == null) {
            reportType = "ComprehensiveAudit";
        }
        if (format == null) {
            format = "Excel";
        }

        // This method already uses auditorId correctly
        int reportId = auditLogDAO.exportAuditReport(
                user.getUserId(),
                startDate,
                endDate,
                reportType,
                format
        );

        LoggingUtil.logExport(request, "Audit Report", format);

        request.setAttribute("message", "Report generated successfully! Report ID: " + reportId);
        request.setAttribute("messageType", "success");

        viewAuditLogs(request, response, user);
    }

    private void viewAlerts(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        int hours = 24;
        try {
            if (request.getParameter("hours") != null) {
                hours = Integer.parseInt(request.getParameter("hours"));
            }
        } catch (NumberFormatException e) {
            hours = 24;
        }

        List<String> alerts = auditLogDAO.getSuspiciousActivities(hours);

        request.setAttribute("alerts", alerts);
        request.setAttribute("hours", hours);
        request.setAttribute("currentUser", user);

        LoggingUtil.logView(request, "SUSPICIOUS_ACTIVITIES");

        request.getRequestDispatcher("/auditor/auditAlerts.jsp").forward(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
