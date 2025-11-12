/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller;

import DAO.SupplierDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Supplier;
import model.User;

/**
 *
 * @author ADMIN
 */
public class SupplierConfirmPaymentServlet extends HttpServlet {
   
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
            out.println("<title>Servlet SupplierConfirmPaymentServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SupplierConfirmPaymentServlet at " + request.getContextPath () + "</h1>");
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
        processRequest(request, response);
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
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Check if user is logged in and is a supplier
        if (user == null || !"Supplier".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Unauthorized access");
            return;
        }
        
        try {
            int transactionId = Integer.parseInt(request.getParameter("transactionId"));
            
            SupplierDAO supplierDao = new SupplierDAO();
            
            // Get supplier info
            Supplier supplier = supplierDao.getSupplierByUserId(user.getUserId());
            if (supplier == null) {
                response.sendRedirect(request.getContextPath() + "/supplier-dashboard?error=Supplier not found");
                return;
            }
            
            // Confirm transaction
            boolean success = supplierDao.confirmTransaction(transactionId, supplier.getSupplierId(), user.getUserId());
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/supplier-dashboard?success=Payment confirmed successfully! Your balance has been updated.");
            } else {
                response.sendRedirect(request.getContextPath() + "/supplier-dashboard?error=Failed to confirm payment. Please try again.");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/supplier-dashboard?error=Invalid transaction ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/supplier-dashboard?error=An error occurred: " + e.getMessage());
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
