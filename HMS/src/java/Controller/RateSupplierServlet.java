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
import java.util.List;
import model.PurchaseOrder;
import model.User; // Add this import for User class
/**
 *
 * @author ADMIN
 */
public class RateSupplierServlet extends HttpServlet {
  
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
            out.println("<title>Servlet RateSupplierServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RateSupplierServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }
     @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
       
        if (user == null || !"Manager".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
       
        ManagerDAO dao = new ManagerDAO();
       
        // Get list of completed POs that haven't been rated yet
        List<PurchaseOrder> unratedPOs = dao.getUnratedCompletedPOs(user.getUserId());
       
        request.setAttribute("unratedPOs", unratedPOs);
        request.getRequestDispatcher("/rateSupplier.jsp").forward(request, response);
    }
   
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
       
        if (user == null || !"Manager".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
       
        try {
            int poId = Integer.parseInt(request.getParameter("poId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            
            // Get optional parameters with defaults
            String reviewText = request.getParameter("comments");
            
            // Get detailed ratings (optional - with defaults if not provided)
            int qualityRating = 0;
            int deliveryRating = 0;
            int communicationRating = 0;
            
            try {
                qualityRating = Integer.parseInt(request.getParameter("qualityRating"));
            } catch (Exception e) {
                qualityRating = rating; // Use overall rating as fallback
            }
            
            try {
                deliveryRating = Integer.parseInt(request.getParameter("deliveryRating"));
            } catch (Exception e) {
                deliveryRating = rating; // Use overall rating as fallback
            }
            
            try {
                communicationRating = Integer.parseInt(request.getParameter("communicationRating"));
            } catch (Exception e) {
                communicationRating = rating; // Use overall rating as fallback
            }
            
            // Check where the request came from
            String referer = request.getHeader("referer");
            boolean fromCompletedOrders = (referer != null && referer.contains("completed-orders"));
            
            // Validate rating
            if (rating < 1 || rating > 5) {
                if (fromCompletedOrders) {
                    response.sendRedirect(request.getContextPath() +
                        "/manager/completed-orders?error=Invalid rating. Must be 1-5 stars.");
                } else {
                    response.sendRedirect(request.getContextPath() +
                        "/manager/rate-supplier?error=Invalid rating. Must be 1-5 stars.");
                }
                return;
            }
            
            ManagerDAO dao = new ManagerDAO();
            
            // Get supplier ID from PO
            PurchaseOrder po = dao.getPurchaseOrderById(poId);
            if (po == null) {
                if (fromCompletedOrders) {
                    response.sendRedirect(request.getContextPath() +
                        "/manager/completed-orders?error=Purchase order not found.");
                } else {
                    response.sendRedirect(request.getContextPath() +
                        "/manager/rate-supplier?error=Purchase order not found.");
                }
                return;
            }
            
            int supplierId = po.getSupplierId();
            
            // Check if already rated
            if (dao.hasRatedPO(poId, user.getUserId())) {
                if (fromCompletedOrders) {
                    response.sendRedirect(request.getContextPath() +
                        "/manager/completed-orders?error=You have already rated this order.");
                } else {
                    response.sendRedirect(request.getContextPath() +
                        "/manager/rate-supplier?error=You have already rated this order.");
                }
                return;
            }
            
            // Build detailed review text
            StringBuilder fullReview = new StringBuilder();
            if (reviewText != null && !reviewText.trim().isEmpty()) {
                fullReview.append(reviewText.trim()).append("\n\n");
            }
            fullReview.append("=== Detailed Ratings ===\n");
            fullReview.append("Quality: ").append(qualityRating).append("/5\n");
            fullReview.append("Delivery: ").append(deliveryRating).append("/5\n");
            fullReview.append("Communication: ").append(communicationRating).append("/5");
            
            // Submit rating
            boolean success = dao.rateSupplier(supplierId, user.getUserId(), poId, rating, fullReview.toString());
           
            if (success) {
                if (fromCompletedOrders) {
                    response.sendRedirect(request.getContextPath() +
                        "/manager/completed-orders?success=Rating submitted successfully!");
                } else {
                    response.sendRedirect(request.getContextPath() +
                        "/manager/rate-supplier?success=Rating submitted successfully!");
                }
            } else {
                if (fromCompletedOrders) {
                    response.sendRedirect(request.getContextPath() +
                        "/manager/completed-orders?error=Failed to submit rating. Please try again.");
                } else {
                    response.sendRedirect(request.getContextPath() +
                        "/manager/rate-supplier?error=Failed to submit rating. Please try again.");
                }
            }
           
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() +
                "/manager/completed-orders?error=Invalid input data.");
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