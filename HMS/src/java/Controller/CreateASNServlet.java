package Controller;

import DAO.SupplierDAO;
import DAO.ASNDAO;
import model.Supplier;
import model.PurchaseOrder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Date;
import util.LoggingUtil;


public class CreateASNServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"Supplier".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }
        
        Integer userId = (Integer) session.getAttribute("userId");
        String poIdStr = request.getParameter("poId");
        
        if (poIdStr == null) {
            response.sendRedirect("supplier-dashboard?error=" + 
                URLEncoder.encode("Missing purchase order ID", "UTF-8"));
            return;
        }
        
        try {
            int poId = Integer.parseInt(poIdStr);
            SupplierDAO supplierDAO = new SupplierDAO();
            ASNDAO asnDAO = new ASNDAO();
            
            Supplier supplier = supplierDAO.getSupplierByUserId(userId);
            if (supplier == null) {
                response.sendRedirect("supplier-dashboard?error=" + 
                    URLEncoder.encode("Supplier information not found", "UTF-8"));
                return;
            }
            
            // Get PO details
            PurchaseOrder po = supplierDAO.getPurchaseOrderById(poId, supplier.getSupplierId());
            if (po == null) {
                response.sendRedirect("supplier-dashboard?error=" + 
                    URLEncoder.encode("Purchase order not found or access denied", "UTF-8"));
                return;
            }
            
            // Check if PO is approved
            if (!"Approved".equals(po.getStatus())) {
                response.sendRedirect("supplier-dashboard?error=" + 
                    URLEncoder.encode("Only approved orders can have shipping notices", "UTF-8"));
                return;
            }
            
            // Check if ASN already exists
            if (asnDAO.hasASNForPO(poId)) {
                response.sendRedirect("supplier-dashboard?error=" + 
                    URLEncoder.encode("A shipping notice already exists for this order", "UTF-8"));
                return;
            }
            
            // Forward to form
            request.setAttribute("po", po);
            request.setAttribute("supplier", supplier);
            request.getRequestDispatcher("/createASN.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("supplier-dashboard?error=" + 
                URLEncoder.encode("Invalid purchase order ID", "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("supplier-dashboard?error=" + 
                URLEncoder.encode("Error: " + e.getMessage(), "UTF-8"));
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !"Supplier".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }
        
        Integer userId = (Integer) session.getAttribute("userId");
        
        try {
            // Parse form data
            int poId = Integer.parseInt(request.getParameter("poId"));
            String shipmentDateStr = request.getParameter("shipmentDate");
            String carrier = request.getParameter("carrier");
            String trackingNumber = request.getParameter("trackingNumber");
            String notes = request.getParameter("notes");
            String submitAction = request.getParameter("submitAction"); // "draft" or "submit"
            
            // Validate
            if (shipmentDateStr == null || carrier == null || trackingNumber == null) {
                response.sendRedirect("create-asn?poId=" + poId + "&error=" + 
                    URLEncoder.encode("All required fields must be filled", "UTF-8"));
                return;
            }
            
            Date shipmentDate = Date.valueOf(shipmentDateStr);
            
            SupplierDAO supplierDAO = new SupplierDAO();
            Supplier supplier = supplierDAO.getSupplierByUserId(userId);
            
            if (supplier == null) {
                response.sendRedirect("supplier-dashboard?error=" + 
                    URLEncoder.encode("Supplier not found", "UTF-8"));
                return;
            }
            
            // Xác định trạng thái ban đầu
            String initialStatus = "Sent"; // Mặc định là Sent (ready to ship)
            if ("draft".equals(submitAction)) {
                initialStatus = "Pending"; // Lưu nháp
            }
            
            // Create ASN with status
            ASNDAO asnDAO = new ASNDAO();
            int asnId = asnDAO.createASNWithStatus(
                poId, 
                supplier.getSupplierId(), 
                shipmentDate,
                carrier, 
                trackingNumber, 
                notes != null ? notes : "",
                supplier.getName(),
                initialStatus
            );
            
            if (asnId > 0) {
                util.LoggingUtil.logASNCreate(request, asnId, poId);
                String message = "Shipping notice created successfully! ASN #" + asnId + 
                                " (Status: " + initialStatus + ")";
                response.sendRedirect("supplier-dashboard?success=" + 
                    URLEncoder.encode(message, "UTF-8"));
            } else {
                response.sendRedirect("supplier-dashboard?error=" + 
                    URLEncoder.encode("Failed to create shipping notice", "UTF-8"));
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("supplier-dashboard?error=" + 
                URLEncoder.encode("Invalid order ID", "UTF-8"));
        } catch (IllegalArgumentException e) {
            response.sendRedirect("supplier-dashboard?error=" + 
                URLEncoder.encode("Invalid date format", "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("supplier-dashboard?error=" + 
                URLEncoder.encode("Error: " + e.getMessage(), "UTF-8"));
        }
    }
}