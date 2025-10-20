package Controller;

import DAO.ReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.Map;

public class ExpiryReportServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");
        
        // Check authorization
        if (!(role != null && (role.equals("Manager") || role.equals("Auditor"))) || userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        ReportDAO dao = new ReportDAO();
        
        // Get parameters from request
        String daysParam = request.getParameter("days");
        int daysThreshold = 30;
        if (daysParam != null && !daysParam.isEmpty()) {
            try {
                daysThreshold = Integer.parseInt(daysParam);
            } catch (NumberFormatException e) {
                daysThreshold = 30;
            }
        }
        
        String statusFilter = request.getParameter("status");
        if (statusFilter == null || statusFilter.isEmpty()) {
            statusFilter = "All";
        }
        
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String useRange = request.getParameter("useRange");
        
        List reports = null;
        String pageTitle = "Medicines Expiring Soon (" + daysThreshold + " days)";
        Map statistics = null;
        
        // Check if using date range
        if ("true".equals(useRange) && startDateStr != null && !startDateStr.isEmpty() 
                && endDateStr != null && !endDateStr.isEmpty()) {
            try {
                Date startDate = Date.valueOf(startDateStr);
                Date endDate = Date.valueOf(endDateStr);
                reports = (List) dao.getExpiryReportByDateRange(startDate, endDate, statusFilter);
                pageTitle = "Medicines Expiring Between " + startDateStr + " and " + endDateStr;
            } catch (Exception e) {
                e.printStackTrace();
                reports = (List) dao.getExpiryReport(daysThreshold, statusFilter);
            }
        } else {
            reports = (List) dao.getExpiryReport(daysThreshold, statusFilter);
        }
        
        // Get statistics
        statistics = dao.getExpiryStatistics(daysThreshold, statusFilter);
        
        // Set attributes
        request.setAttribute("reports", reports);
        request.setAttribute("pageTitle", pageTitle);
        request.setAttribute("daysThreshold", daysThreshold);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("statistics", statistics);
        request.setAttribute("userRole", role);
        request.setAttribute("startDate", startDateStr);
        request.setAttribute("endDate", endDateStr);
        request.setAttribute("useRange", useRange);
        
        // Forward to JSP
        request.getRequestDispatcher("/expiry-report.jsp").forward(request, response);
    }
}