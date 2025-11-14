package Controller;
import DAO.MedicineDAO;
import model.Medicine;
import model.Supplier;
import model.User;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;

public class ViewMedicineServlet extends HttpServlet {
    private MedicineDAO medicineDAO;
    
    @Override
    public void init() {
        medicineDAO = new MedicineDAO();
    }
    
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
        if (!"Admin".equals(role) && !"Pharmacist".equals(role) && !"Doctor".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/unauthorized.jsp");
            return;
        }
        
        // Lấy param từ request
        String keyword = request.getParameter("keyword");
        String category = request.getParameter("category");
        String activeIngredient = request.getParameter("activeIngredient");
        String drugGroup = request.getParameter("drugGroup");
        String drugType = request.getParameter("drugType");
        String status = request.getParameter("status");
        
        List<Medicine> medicines = new ArrayList<>();
        
        try {
            // Kiểm tra filter
            boolean hasFilter = (keyword != null && !keyword.trim().isEmpty())
                    || (category != null && !"All".equalsIgnoreCase(category))
                    || (activeIngredient != null && !"All".equalsIgnoreCase(activeIngredient))
                    || (drugGroup != null && !"All".equalsIgnoreCase(drugGroup))
                    || (drugType != null && !"All".equalsIgnoreCase(drugType))
                    || (status != null && !status.trim().isEmpty());
            
            // Lấy danh sách thuốc
            if (hasFilter) {
                medicines = medicineDAO.searchMedicines(keyword, category, activeIngredient, drugGroup, drugType, status);
            } else {
                medicines = medicineDAO.getAllMedicines();
            }
            
            // Lấy dữ liệu dropdown
            List<String> categories = medicineDAO.getAllCategories();
            List<String> activeIngredients = medicineDAO.getAllActiveIngredients();
            List<String> drugGroups = medicineDAO.getAllDrugGroups();
            List<String> drugTypes = medicineDAO.getAllDrugTypes();
            
            // Thêm "All" cho dropdown nếu chưa có
            if (!categories.contains("All")) categories.add(0, "All");
            if (!activeIngredients.contains("All")) activeIngredients.add(0, "All");
            if (!drugGroups.contains("All")) drugGroups.add(0, "All");
            if (!drugTypes.contains("All")) drugTypes.add(0, "All");
            
            // Lấy danh sách nhà cung cấp
            List<Supplier> supplierList = medicineDAO.getAllSuppliers();
            
            // Set attribute cho JSP
            request.setAttribute("medicines", medicines);
            request.setAttribute("categories", categories);
            request.setAttribute("activeIngredients", activeIngredients);
            request.setAttribute("drugGroups", drugGroups);
            request.setAttribute("drugTypes", drugTypes);
            request.setAttribute("supplierList", supplierList);
            
            // Giữ lại giá trị đã chọn trong form
            request.setAttribute("keyword", keyword != null ? keyword : "");
            request.setAttribute("selectedCategory", category != null ? category : "All");
            request.setAttribute("selectedActiveIngredient", activeIngredient != null ? activeIngredient : "All");
            request.setAttribute("selectedDrugGroup", drugGroup != null ? drugGroup : "All");
            request.setAttribute("selectedDrugType", drugType != null ? drugType : "All");
            request.setAttribute("selectedStatus", status != null ? status : "");
            
            request.getRequestDispatcher("/jsp/viewMedicine.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "❌ Lỗi khi truy xuất dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/jsp/viewMedicine.jsp").forward(request, response);
        }
    }
}