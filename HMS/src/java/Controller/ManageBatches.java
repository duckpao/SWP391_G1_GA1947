package Controller;

import DAO.BatchDAO;
import model.Medicine;
import model.Supplier;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import model.User;

/**
 * ✅ Servlet quản lý lô thuốc
 * FIXED: Set attribute name "batches" thay vì "batchList"
 */
public class ManageBatches extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Check authentication
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Check authorization
        String role = currentUser.getRole();
        if (!"Admin".equals(role) && !"Pharmacist".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/unauthorized.jsp");
            return;
        }
        BatchDAO dao = new BatchDAO();
        
        try {
            // ✅ Lấy danh sách thuốc và NCC cho filter
            List<Medicine> medicineList = dao.getAllMedicines();
            List<Supplier> supplierList = dao.getAllSuppliers();
            String nextLotNumber = dao.generateNextLotNumber();
            
            // ✅ Lấy tham số tìm kiếm
            String lotNumber = request.getParameter("lotNumber");
            String status = request.getParameter("status");
            String medicineCodeFilter = request.getParameter("medicineCode");
            String supplierIdFilter = request.getParameter("supplierId");
            
            System.out.println("====================================");
            System.out.println("ManageBatches - Filter parameters:");
            System.out.println("Lot Number: " + lotNumber);
            System.out.println("Medicine Code: " + medicineCodeFilter);
            System.out.println("Supplier ID: " + supplierIdFilter);
            System.out.println("Status: " + status);
            System.out.println("====================================");
            
            // ✅ Lấy danh sách batch (có filter hoặc toàn bộ)
            List<Map<String, Object>> batches;
            
            if ((lotNumber != null && !lotNumber.isEmpty()) ||
                (medicineCodeFilter != null && !medicineCodeFilter.isEmpty()) ||
                (supplierIdFilter != null && !supplierIdFilter.isEmpty()) ||
                (status != null && !status.isEmpty())) {
                
                // Có filter → Gọi filterBatches()
                batches = dao.filterBatches(lotNumber, medicineCodeFilter, supplierIdFilter);
                System.out.println("Filtered batches: " + batches.size());
                
            } else {
                // Không filter → Lấy toàn bộ
                batches = dao.getBatchList();
                System.out.println("All batches: " + batches.size());
            }
            
            // ✅ Debug: In ra batch_quantity của từng lô
            for (Map<String, Object> batch : batches) {
                System.out.println("Batch #" + batch.get("batchId") + 
                                   " - " + batch.get("lotNumber") +
                                   " - batch_quantity: " + batch.get("batchQuantity") +
                                   " - current_quantity: " + batch.get("currentQuantity"));
            }
            
            // ✅ Lấy tên thuốc và NCC để giữ lại sau khi tìm kiếm
            String medicineLabel = "";
            String supplierLabel = "";
            
            if (medicineCodeFilter != null && !medicineCodeFilter.isEmpty()) {
                for (Medicine m : medicineList) {
                    if (m.getMedicineCode().equals(medicineCodeFilter)) {
                        medicineLabel = m.getName();
                        break;
                    }
                }
            }
            
            if (supplierIdFilter != null && !supplierIdFilter.isEmpty()) {
                for (Supplier s : supplierList) {
                    if (String.valueOf(s.getSupplierId()).equals(supplierIdFilter)) {
                        supplierLabel = s.getName();
                        break;
                    }
                }
            }
            
            // ✅ CRITICAL: Set attribute "batches" (không phải "batchList")
            request.setAttribute("batches", batches);
            request.setAttribute("medicineList", medicineList);
            request.setAttribute("supplierList", supplierList);
            request.setAttribute("nextLotNumber", nextLotNumber);
            request.setAttribute("medicineLabel", medicineLabel);
            request.setAttribute("supplierLabel", supplierLabel);
            
            System.out.println("Forwarding to Manage-Batches.jsp");
            System.out.println("====================================");
            
        } catch (SQLException e) {
            System.err.println("❌ Error in ManageBatches: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("nextLotNumber", "LOT2025001");
            request.setAttribute("batches", List.of()); // Empty list
            request.setAttribute("errorMessage", "Lỗi khi tải danh sách lô: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/pharmacist/Manage-Batches.jsp").forward(request, response);
    }
}