/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.PurchaseOrderDAO;
import DAO.SupplierDAO;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Date;
import java.util.List;
import java.util.Map;
import model.PurchaseOrder;
import model.Supplier;

/**
 *
 * @author ADMIN
 */
public class PurchaseOrderHistoryServlet extends HttpServlet {

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
            out.println("<title>Servlet PurchaseOrderHistoryServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PurchaseOrderHistoryServlet at " + request.getContextPath() + "</h1>");
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
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Check role
        String userRole = (String) session.getAttribute("role");
        if (!"Auditor".equals(userRole) && !"Admin".equals(userRole)) {
            request.setAttribute("errorMessage", "Access denied. This page is for Auditors only.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        String action = request.getParameter("action");

        if ("getTrendData".equals(action)) {
            handleGetTrendData(request, response);
        } else if ("getSupplierPerformance".equals(action)) {
            handleGetSupplierPerformance(request, response);
        } else {
            handleViewHistory(request, response);
        }
    }

    /**
     * Handle viewing historical purchase orders
     */
    private void handleViewHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PurchaseOrderDAO poDAO = new PurchaseOrderDAO();
        SupplierDAO supplierDAO = new SupplierDAO();

        try {
            // Get filter parameters
            String supplierIdParam = request.getParameter("supplierId");
            String fromDateParam = request.getParameter("fromDate");
            String toDateParam = request.getParameter("toDate");
            String searchKeyword = request.getParameter("search");

            // Parse parameters
            Integer supplierId = null;
            if (supplierIdParam != null && !supplierIdParam.isEmpty()) {
                try {
                    supplierId = Integer.parseInt(supplierIdParam);
                } catch (NumberFormatException e) {
                    System.err.println("Invalid supplier ID: " + supplierIdParam);
                }
            }

            Date fromDate = null;
            if (fromDateParam != null && !fromDateParam.isEmpty()) {
                try {
                    fromDate = Date.valueOf(fromDateParam);
                } catch (IllegalArgumentException e) {
                    System.err.println("Invalid from date: " + fromDateParam);
                }
            } else {
                // Default: 6 months ago
                java.util.Calendar cal = java.util.Calendar.getInstance();
                cal.add(java.util.Calendar.MONTH, -6);
                fromDate = new Date(cal.getTimeInMillis());
            }

            Date toDate = null;
            if (toDateParam != null && !toDateParam.isEmpty()) {
                try {
                    toDate = Date.valueOf(toDateParam);
                } catch (IllegalArgumentException e) {
                    System.err.println("Invalid to date: " + toDateParam);
                }
            } else {
                // Default: today
                toDate = new Date(System.currentTimeMillis());
            }

            // Get historical purchase orders
            List<PurchaseOrder> historicalOrders = poDAO.getHistoricalPurchaseOrders(
                    supplierId, fromDate, toDate, searchKeyword
            );

            // Get all suppliers for filter dropdown
            List<Supplier> suppliers = supplierDAO.getAllSuppliers();

            // Get trend data for charts
            List<Map<String, Object>> trendData = poDAO.getTrendDataByMonth(
                    supplierId, fromDate, toDate
            );

            // Get supplier performance
            List<Map<String, Object>> supplierPerformance = poDAO.getSupplierPerformance(
                    fromDate, toDate
            );

            // Calculate statistics
            int totalHistoricalOrders = historicalOrders.size();
            double totalHistoricalAmount = historicalOrders.stream()
                    .mapToDouble(PurchaseOrder::getTotalAmount)
                    .sum();
            double avgOrderValue = totalHistoricalOrders > 0
                    ? totalHistoricalAmount / totalHistoricalOrders
                    : 0;

            // Set attributes for JSP
            request.setAttribute("historicalOrders", historicalOrders);
            request.setAttribute("suppliers", suppliers);
            request.setAttribute("trendData", new Gson().toJson(trendData));
            request.setAttribute("supplierPerformance", supplierPerformance);
            request.setAttribute("totalHistoricalOrders", totalHistoricalOrders);
            request.setAttribute("totalHistoricalAmount", totalHistoricalAmount);
            request.setAttribute("avgOrderValue", avgOrderValue);

            // Keep filter values
            request.setAttribute("selectedSupplierId", supplierIdParam);
            request.setAttribute("fromDate", fromDateParam != null ? fromDateParam : fromDate.toString());
            request.setAttribute("toDate", toDateParam != null ? toDateParam : toDate.toString());
            request.setAttribute("searchKeyword", searchKeyword);

            // Forward to JSP
            request.getRequestDispatcher("/auditor/purchase-orders-history.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error in handleViewHistory: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading historical data: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } finally {
            if (poDAO != null) {
                poDAO.closeConnection();
            }
            if (supplierDAO != null) {
                supplierDAO.closeConnection();
            }
        }
    }

    /**
     * Handle AJAX request for trend data
     */
    private void handleGetTrendData(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PurchaseOrderDAO poDAO = new PurchaseOrderDAO();

        try {
            String supplierIdParam = request.getParameter("supplierId");
            String fromDateParam = request.getParameter("fromDate");
            String toDateParam = request.getParameter("toDate");

            Integer supplierId = null;
            if (supplierIdParam != null && !supplierIdParam.isEmpty()) {
                supplierId = Integer.parseInt(supplierIdParam);
            }

            Date fromDate = fromDateParam != null && !fromDateParam.isEmpty()
                    ? Date.valueOf(fromDateParam)
                    : null;
            Date toDate = toDateParam != null && !toDateParam.isEmpty()
                    ? Date.valueOf(toDateParam)
                    : null;

            List<Map<String, Object>> trendData = poDAO.getTrendDataByMonth(
                    supplierId, fromDate, toDate
            );

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(new Gson().toJson(trendData));

        } catch (Exception e) {
            System.err.println("Error in handleGetTrendData: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        } finally {
            if (poDAO != null) {
                poDAO.closeConnection();
            }
        }
    }

    /**
     * Handle AJAX request for supplier performance
     */
    private void handleGetSupplierPerformance(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PurchaseOrderDAO poDAO = new PurchaseOrderDAO();

        try {
            String fromDateParam = request.getParameter("fromDate");
            String toDateParam = request.getParameter("toDate");

            Date fromDate = fromDateParam != null && !fromDateParam.isEmpty()
                    ? Date.valueOf(fromDateParam)
                    : null;
            Date toDate = toDateParam != null && !toDateParam.isEmpty()
                    ? Date.valueOf(toDateParam)
                    : null;

            List<Map<String, Object>> performance = poDAO.getSupplierPerformance(fromDate, toDate);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(new Gson().toJson(performance));

        } catch (Exception e) {
            System.err.println("Error in handleGetSupplierPerformance: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        } finally {
            if (poDAO != null) {
                poDAO.closeConnection();
            }
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);

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
