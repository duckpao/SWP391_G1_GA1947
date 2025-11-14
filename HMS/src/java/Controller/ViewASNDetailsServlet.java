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
import model.ASNItem;
import model.AdvancedShippingNotice;
import model.Manager;
import model.PurchaseOrder;
import model.PurchaseOrderItem;
import model.User;

/**
 *
 * @author ADMIN
 */
public class ViewASNDetailsServlet extends HttpServlet {

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
            out.println("<title>Servlet ViewASNDetailsServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ViewASNDetailsServlet at " + request.getContextPath() + "</h1>");
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

        String poIdStr = request.getParameter("poId");
        if (poIdStr == null || poIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/manager-dashboard");
            return;
        }

        ManagerDAO dao = new ManagerDAO();

        try {
            int poId = Integer.parseInt(poIdStr);

            // Lấy thông tin PO
            PurchaseOrder po = dao.getPurchaseOrderById(poId);
            if (po == null || po.getManagerId() != user.getUserId()) {
                request.setAttribute("errorMessage", "Purchase Order not found or access denied");
                response.sendRedirect(request.getContextPath() + "/manager-dashboard");
                return;
            }

            // Lấy thông tin ASN
            AdvancedShippingNotice asn = dao.getASNByPoId(poId);
            if (asn == null) {
                request.setAttribute("errorMessage", "ASN not found for this Purchase Order");
                response.sendRedirect(request.getContextPath() + "/manager-dashboard");
                return;
            }

            // Lấy ASN items
            List<ASNItem> asnItems = dao.getASNItems(asn.getAsnId());
            asn.setItems(asnItems);

            // Lấy PO items để so sánh
            List<PurchaseOrderItem> poItems = dao.getPurchaseOrderItems(poId);

            request.setAttribute("asn", asn);
            request.setAttribute("po", po);
            request.setAttribute("asnItems", asnItems);
            request.setAttribute("poItems", poItems);

            request.getRequestDispatcher("/view-asn-details.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/manager-dashboard");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading ASN details: " + e.getMessage());
            request.getRequestDispatcher("/view-asn-details.jsp").forward(request, response);
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
