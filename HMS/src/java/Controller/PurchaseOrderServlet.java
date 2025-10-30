/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.PurchaseOrderDAO;
import DAO.SupplierDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Date;
import java.util.List;
import model.PurchaseOrder;
import model.PurchaseOrderItem;
import model.Supplier;

/**
 *
 * @author ADMIN
 */
public class PurchaseOrderServlet extends HttpServlet {

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
            out.println("<title>Servlet PurchaseOrderServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PurchaseOrderServlet at " + request.getContextPath() + "</h1>");
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
    private PurchaseOrderDAO poDAO = new PurchaseOrderDAO();
    private SupplierDAO supplierDAO = new SupplierDAO();

    // Fallback initialization method
    private void ensureDAOsInitialized() {
        if (poDAO == null) {
            System.out.println("⚠️ poDAO was null, initializing...");
            poDAO = new PurchaseOrderDAO();
        }
        if (supplierDAO == null) {
            System.out.println("⚠️ supplierDAO was null, initializing...");
            supplierDAO = new SupplierDAO();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String userRole = (String) session.getAttribute("role");
        if (!"Auditor".equals(userRole) && !"Admin".equals(userRole)) {
            request.setAttribute("errorMessage", "Access denied. This page is for Auditors only.");
            request.getRequestDispatcher("error.jsp").forward(request, response);
            return;
        }

        String action = request.getParameter("action");

        if (action == null || action.equals("list")) {
            handleListPurchaseOrders(request, response);
        } else if (action.equals("view")) {
            handleViewPurchaseOrder(request, response);
        } else {
            handleListPurchaseOrders(request, response);
        }
    }

    /**
     * Handle listing purchase orders with filters
     */
    private void handleListPurchaseOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Tạo DAO mới mỗi lần gọi để tránh lỗi null
        PurchaseOrderDAO poDAO = new PurchaseOrderDAO();
        SupplierDAO supplierDAO = new SupplierDAO();

        try {
            // Get filter parameters
            String statusFilter = request.getParameter("status");
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
            }

            Date toDate = null;
            if (toDateParam != null && !toDateParam.isEmpty()) {
                try {
                    toDate = Date.valueOf(toDateParam);
                } catch (IllegalArgumentException e) {
                    System.err.println("Invalid to date: " + toDateParam);
                }
            }

            // Get filtered purchase orders
            List<PurchaseOrder> purchaseOrders = poDAO.getAllPurchaseOrders(
                    statusFilter, supplierId, fromDate, toDate, searchKeyword
            );

            // Get all suppliers for filter dropdown
            List<Supplier> suppliers = supplierDAO.getAllSuppliers();

            // Get all statuses for filter dropdown
            List<String> statuses = poDAO.getAllStatuses();

            // Get statistics
            Object[] stats = poDAO.getPurchaseOrderStatistics();

            // Set attributes for JSP
            request.setAttribute("purchaseOrders", purchaseOrders);
            request.setAttribute("suppliers", suppliers);
            request.setAttribute("statuses", statuses);
            request.setAttribute("totalOrders", stats[0]);
            request.setAttribute("completedOrders", stats[1]);
            request.setAttribute("pendingOrders", stats[2]);
            request.setAttribute("totalAmount", stats[3]);

            // Keep filter values
            request.setAttribute("selectedStatus", statusFilter);
            request.setAttribute("selectedSupplierId", supplierIdParam);
            request.setAttribute("fromDate", fromDateParam);
            request.setAttribute("toDate", toDateParam);
            request.setAttribute("searchKeyword", searchKeyword);

            // Forward to JSP
            request.getRequestDispatcher("auditor/purchase-orders.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error in handleListPurchaseOrders: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading purchase orders: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } finally {
            // Close connections
            if (poDAO != null) {
                poDAO.closeConnection();
            }
            if (supplierDAO != null) {
                supplierDAO.closeConnection();
            }
        }
    }

    /**
     * Handle viewing a specific purchase order with details
     */
    private void handleViewPurchaseOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Tạo DAO mới mỗi lần gọi
        PurchaseOrderDAO poDAO = new PurchaseOrderDAO();

        try {
            String poIdParam = request.getParameter("id");

            if (poIdParam == null || poIdParam.isEmpty()) {
                response.sendRedirect("purchase-orders");
                return;
            }

            int poId = Integer.parseInt(poIdParam);

            // Get purchase order details
            PurchaseOrder purchaseOrder = poDAO.getPurchaseOrderById(poId);

            if (purchaseOrder == null) {
                request.setAttribute("errorMessage", "Purchase Order not found.");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }

            // Get purchase order items
            List<PurchaseOrderItem> items = poDAO.getItemsByPurchaseOrderId(poId);

            // Set attributes for JSP
            request.setAttribute("purchaseOrder", purchaseOrder);
            request.setAttribute("items", items);

            // Forward to detail JSP
            request.getRequestDispatcher("auditor/purchase-order-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            System.err.println("Invalid PO ID format: " + e.getMessage());
            response.sendRedirect("purchase-orders");
        } catch (Exception e) {
            System.err.println("Error in handleViewPurchaseOrder: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading purchase order details: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        } finally {
            // Close connection
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
        processRequest(request, response);
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
