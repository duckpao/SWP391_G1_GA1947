package Controller;

import DAO.ASNDAO;
import DAO.SupplierDAO;
import model.AdvancedShippingNotice;
import model.Supplier;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;

public class ViewASNServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"Supplier".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }
        
        Integer userId = (Integer) session.getAttribute("userId");
        String asnIdStr = request.getParameter("asnId");
        
        if (asnIdStr == null) {
            response.sendRedirect("supplierDashboard?error=" + 
                URLEncoder.encode("Missing ASN ID", "UTF-8"));
            return;
        }
        
        try {
            int asnId = Integer.parseInt(asnIdStr);
            
            SupplierDAO supplierDAO = new SupplierDAO();
            Supplier supplier = supplierDAO.getSupplierByUserId(userId);
            
            if (supplier == null) {
                response.sendRedirect("supplierDashboard?error=" + 
                    URLEncoder.encode("Supplier information not found", "UTF-8"));
                return;
            }
            
            ASNDAO asnDAO = new ASNDAO();
            AdvancedShippingNotice asn = asnDAO.getASNById(asnId);
            
            if (asn == null) {
                response.sendRedirect("supplierDashboard?error=" + 
                    URLEncoder.encode("Shipping notice not found", "UTF-8"));
                return;
            }
            
            // Verify this ASN belongs to the supplier
            if (asn.getSupplierId() != supplier.getSupplierId()) {
                response.sendRedirect("supplierDashboard?error=" + 
                    URLEncoder.encode("Access denied", "UTF-8"));
                return;
            }
            
            request.setAttribute("asn", asn);
            request.setAttribute("supplier", supplier);
            request.getRequestDispatcher("/jsp/viewASN.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("supplierDashboard?error=" + 
                URLEncoder.encode("Invalid ASN ID", "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("supplierDashboard?error=" + 
                URLEncoder.encode("Error loading shipping notice: " + e.getMessage(), "UTF-8"));
        }
    }
}