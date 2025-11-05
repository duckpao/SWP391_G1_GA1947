/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller;

import DAO.ASNDAO;
import com.google.gson.Gson;
import DAO.InvoiceDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.ASNItem;
import model.AdvancedShippingNotice;
import model.User;

/**
 *
 * @author ADMIN
 */
@MultipartConfig
public class ManageTransitServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet ManageTransitServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ManageTransitServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user"); // ✅ ĐỔI TỪ "account" SANG "user"
        
        // Debug logs
        System.out.println("====================================");
        System.out.println("ManageTransitServlet - doGet");
        System.out.println("Session ID: " + (session != null ? session.getId() : "NULL"));
        System.out.println("User: " + (user != null ? user.getUsername() : "NULL"));
        System.out.println("Role: " + (user != null ? user.getRole() : "NULL"));
        System.out.println("====================================");
        
        // Check authentication
        if (user == null) {
            System.out.println("❌ User is null - redirecting to login");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Check authorization (Manager only)
        if (!"Manager".equals(user.getRole())) {
            System.out.println("❌ User role is not Manager - Access Denied");
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Manager role required.");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                showTransitOrders(request, response, user);
                break;
            case "details":
                getASNDetails(request, response, user);
                break;
            default:
                showTransitOrders(request, response, user);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user"); // ✅ ĐỔI TỪ "account" SANG "user"
        
        // Check authentication
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Please login first");
            return;
        }
        
        // Check authorization
        if (!"Manager".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action is required");
            return;
        }
        
        switch (action) {
            case "confirmDelivery":
                confirmDelivery(request, response, user);
                break;
            case "processPayment":
                processPayment(request, response, user);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    /**
     * Show list of InTransit orders
     */
    private void showTransitOrders(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        try {
            ASNDAO asnDao = new ASNDAO();
            List<AdvancedShippingNotice> inTransitOrders = asnDao.getInTransitASNs();
            
            request.setAttribute("orders", inTransitOrders);
            request.setAttribute("orderCount", inTransitOrders.size());
            
            System.out.println("====================================");
            System.out.println("Manager Transit Orders Page");
            System.out.println("User: " + user.getUsername() + " (ID: " + user.getUserId() + ")");
            System.out.println("Total InTransit Orders: " + inTransitOrders.size());
            System.out.println("====================================");
            
            request.getRequestDispatcher("/manager-transit-orders.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in showTransitOrders: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error loading transit orders: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    /**
     * Get ASN details (AJAX)
     */
    private void getASNDetails(HttpServletRequest request, HttpServletResponse response, User user)
        throws ServletException, IOException {
    
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    PrintWriter out = response.getWriter();
    
    String asnIdStr = request.getParameter("asnId");
    
    if (asnIdStr == null) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        out.print("{\"success\": false, \"message\": \"ASN ID is required\"}");
        return;
    }
    
    try {
        int asnId = Integer.parseInt(asnIdStr);
        ASNDAO asnDao = new ASNDAO();
        
        AdvancedShippingNotice asn = asnDao.getASNById(asnId);
        
        if (asn == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            out.print("{\"success\": false, \"message\": \"ASN not found\"}");
            return;
        }
        
        List<ASNItem> items = asnDao.getASNItems(asnId);
        asn.setItems(items);
        
        // Use Gson
        Gson gson = new Gson();
        Map<String, Object> responseMap = new HashMap<>();
        responseMap.put("success", true);
        responseMap.put("asn", asn);  // Gson will serialize the object (assumes getters)
        responseMap.put("items", items);  // Serializes list of ASNItem
        
        out.print(gson.toJson(responseMap));
        
    } catch (NumberFormatException e) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        out.print("{\"success\": false, \"message\": \"Invalid ASN ID\"}");
    } catch (Exception e) {
        System.err.println("Error in getASNDetails: " + e.getMessage());
        e.printStackTrace();
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        out.print("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
    }
}

    /**
     * Confirm delivery
     */
private void confirmDelivery(HttpServletRequest request, HttpServletResponse response, User user)
        throws ServletException, IOException {
    
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    PrintWriter out = response.getWriter();
    
    String asnIdStr = request.getParameter("asnId");
    
    if (asnIdStr == null) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        out.print("{\"success\": false, \"message\": \"ASN ID is required\"}");
        return;
    }
    
    try {
        int asnId = Integer.parseInt(asnIdStr);
        ASNDAO asnDao = new ASNDAO();
        
        // 1. Get ASN info
        AdvancedShippingNotice asn = asnDao.getASNById(asnId);
        
        if (asn == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            out.print("{\"success\": false, \"message\": \"ASN not found\"}");
            return;
        }
        
        // 2. Confirm delivery
        boolean confirmed = asnDao.confirmDelivery(asnId, user.getUserId());
        
        if (!confirmed) {
            out.print("{\"success\": false, \"message\": \"Failed to confirm delivery\"}");
            return;
        }
        
        // 3. Create Delivery Note
        int dnId = asnDao.createDeliveryNote(asnId, asn.getPoId(), user.getUserId(), "Confirmed by Manager");
        
        if (dnId <= 0) {
            out.print("{\"success\": false, \"message\": \"Failed to create delivery note\"}");
            return;
        }
        
        // 4. ✅ TẠO INVOICE TỰ ĐỘNG
        InvoiceDAO invoiceDAO = new InvoiceDAO();
        int invoiceId = invoiceDAO.createInvoiceForASN(asn, asnId, user.getUserId());
        
        if (invoiceId <= 0) {
            out.print("{\"success\": false, \"message\": \"Delivery confirmed but failed to create invoice\"}");
            return;
        }
        
        System.out.println("✅ Created Invoice #" + invoiceId + " for ASN #" + asnId);
        
        // 5. ✅ TRẢ VỀ INVOICE ID ĐỂ REDIRECT ĐẾN TRANG THANH TOÁN
        out.print("{\"success\": true, \"message\": \"Delivery confirmed\", \"dnId\": " + dnId + 
                  ", \"invoiceId\": " + invoiceId + ", \"poId\": " + asn.getPoId() + "}");
        
    } catch (NumberFormatException e) {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        out.print("{\"success\": false, \"message\": \"Invalid ASN ID\"}");
    } catch (Exception e) {
        System.err.println("Error in confirmDelivery: " + e.getMessage());
        e.printStackTrace();
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        out.print("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
    }
}

    /**
     * Process payment
     */
    private void processPayment(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String asnIdStr = request.getParameter("asnId");
        String poIdStr = request.getParameter("poId");
        
        if (asnIdStr == null || poIdStr == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"message\": \"ASN ID and PO ID are required\"}");
            return;
        }
        
        try {
            int asnId = Integer.parseInt(asnIdStr);
            int poId = Integer.parseInt(poIdStr);
            
            ASNDAO asnDao = new ASNDAO();
            boolean paid = asnDao.processPayment(asnId, poId, user.getUserId());
            
            if (paid) {
                out.print("{\"success\": true, \"message\": \"Payment processed successfully\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Failed to process payment\"}");
            }
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"success\": false, \"message\": \"Invalid ASN ID or PO ID\"}");
        } catch (Exception e) {
            System.err.println("Error in processPayment: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
