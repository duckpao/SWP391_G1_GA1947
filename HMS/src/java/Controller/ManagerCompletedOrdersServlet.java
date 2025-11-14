/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller;

import DAO.ManagerDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Manager;
import model.PurchaseOrder;
import model.PurchaseOrderItem;
import model.SupplierRating;
import model.User;

/**
 *
 * @author ADMIN
 */
public class ManagerCompletedOrdersServlet extends HttpServlet {
   
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
            out.println("<title>Servlet ManagerCompletedOrdersServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ManagerCompletedOrdersServlet at " + request.getContextPath () + "</h1>");
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
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"Manager".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/unauthorized.jsp");
            return;
        }
        
        ManagerDAO dao = new ManagerDAO();
        
        try {
            // Lấy danh sách đơn hoàn thành
            List<PurchaseOrder> completedOrders = dao.getCompletedOrders(user.getUserId());
            
            // Lấy items cho từng PO
            Map<Integer, List<PurchaseOrderItem>> poItemsMap = new HashMap<>();
            
            // Lấy thông tin rating cho từng PO
            Map<Integer, Boolean> ratedMap = new HashMap<>();
            Map<Integer, Integer> ratingValueMap = new HashMap<>();
            
            for (PurchaseOrder po : completedOrders) {
                List<PurchaseOrderItem> items = dao.getPurchaseOrderItems(po.getPoId());
                poItemsMap.put(po.getPoId(), items);
                
                // Check if rated
                boolean isRated = dao.hasRatedPO(po.getPoId(), user.getUserId());
                ratedMap.put(po.getPoId(), isRated);
                
                // Get rating value if rated
                if (isRated) {
                    List<SupplierRating> ratings = dao.getSupplierRatings(po.getSupplierId());
                    for (SupplierRating rating : ratings) {
                        if (rating.getPoId() == po.getPoId() && 
                            rating.getManagerId() == user.getUserId()) {
                            ratingValueMap.put(po.getPoId(), rating.getRating());
                            break;
                        }
                    }
                }
            }
            
            request.setAttribute("completedOrders", completedOrders);
            request.setAttribute("poItemsMap", poItemsMap);
            request.setAttribute("ratedMap", ratedMap);
            request.setAttribute("ratingValueMap", ratingValueMap);
            
            request.getRequestDispatcher("/completed-orders.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading completed orders: " + e.getMessage());
            request.getRequestDispatcher("/completed-orders.jsp").forward(request, response);
        }
    }

    /** 
     * Handles the HTTP <code>POST</code> method.
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
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
