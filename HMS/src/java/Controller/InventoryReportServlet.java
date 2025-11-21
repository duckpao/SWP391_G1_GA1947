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

public class InventoryReportServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");
        
        // Check authorization
        if (!(role != null && (role.equals("Manager"))) || userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        ReportDAO dao = new ReportDAO();
        
        // Get report type
        String reportType = request.getParameter("type");
        if (reportType == null || reportType.isEmpty()) {
            reportType = "summary";
        }
        
        // Get date parameters
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        
        List reports = null;
        String pageTitle = "Inventory Report";
        Map statistics = null;
        
        // Generate report based on type
        if ("supplier".equals(reportType)) {
            reports = (List) dao.getInventoryBySupplier();
            pageTitle = "Inventory by Supplier";
        } 
        else if ("batch".equals(reportType)) {
            Date startDate = null;
            Date endDate = null;
            
            if (startDateStr != null && !startDateStr.isEmpty()) {
                try {
                    startDate = Date.valueOf(startDateStr);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            
            if (endDateStr != null && !endDateStr.isEmpty()) {
                try {
                    endDate = Date.valueOf(endDateStr);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            
            reports = (List) dao.getBatchInventoryDetails(startDate, endDate);
            pageTitle = "Batch-Level Inventory Details";
            
            if (startDate != null && endDate != null) {
                pageTitle += " (" + startDateStr + " to " + endDateStr + ")";
            }
        } 
        else {
            // Default: summary
            reports = (List) dao.getInventoryReport();
            pageTitle = "Inventory Summary";
            statistics = dao.getInventoryStatistics();
        }
        
        // Set attributes
        request.setAttribute("reports", reports);
        request.setAttribute("pageTitle", pageTitle);
        request.setAttribute("reportType", reportType);
        request.setAttribute("statistics", statistics);
        request.setAttribute("userRole", role);
        request.setAttribute("startDate", startDateStr);
        request.setAttribute("endDate", endDateStr);
        
        // Forward to JSP
        request.getRequestDispatcher("/inventory-report.jsp").forward(request, response);
    }
}