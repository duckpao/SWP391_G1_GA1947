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
            int supplierId = Integer.parseInt(request.getParameter("supplierId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String reviewText = request.getParameter("reviewText");
           
            // Validate rating
            if (rating < 1 || rating > 5) {
                response.sendRedirect(request.getContextPath() +
                    "/manager/rate-supplier?error=Invalid rating. Must be 1-5 stars.");
                return;
            }
           
            ManagerDAO dao = new ManagerDAO();
           
            // Check if already rated
            if (dao.hasRatedPO(poId, user.getUserId())) {
                response.sendRedirect(request.getContextPath() +
                    "/manager/rate-supplier?error=You have already rated this order.");
                return;
            }
           
            // Submit rating
            boolean success = dao.rateSupplier(supplierId, user.getUserId(), poId, rating, reviewText);
           
            if (success) {
                response.sendRedirect(request.getContextPath() +
                    "/manager/rate-supplier?success=Rating submitted successfully!");
            } else {
                response.sendRedirect(request.getContextPath() +
                    "/manager/rate-supplier?error=Failed to submit rating. Please try again.");
            }
           
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() +
                "/manager/rate-supplier?error=Invalid input data.");
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