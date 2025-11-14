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
    
    // Normalize empty strings to null
    if (category != null && category.trim().isEmpty()) category = null;
    if (activeIngredient != null && activeIngredient.trim().isEmpty()) activeIngredient = null;
    if (drugGroup != null && drugGroup.trim().isEmpty()) drugGroup = null;
    if (drugType != null && drugType.trim().isEmpty()) drugType = null;
    if (status != null && status.trim().isEmpty()) status = null;
    
    List<Medicine> medicines = new ArrayList<>();
    
    try {
        // Kiểm tra filter
        boolean hasFilter = (keyword != null && !keyword.trim().isEmpty())
                || category != null
                || activeIngredient != null
                || drugGroup != null
                || drugType != null
                || status != null;
        
        // Lấy danh sách thuốc
        if (hasFilter) {
            medicines = medicineDAO.searchMedicines(keyword, category, activeIngredient, drugGroup, drugType, status);
        } else {
            medicines = medicineDAO.getAllMedicines();
        }
        
        // Lấy dữ liệu dropdown (không cần thêm "All" nữa)
        List<String> categories = medicineDAO.getAllCategories();
        List<String> activeIngredients = medicineDAO.getAllActiveIngredients();
        List<String> drugGroups = medicineDAO.getAllDrugGroups();
        List<String> drugTypes = medicineDAO.getAllDrugTypes();
        
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
        request.setAttribute("selectedCategory", category != null ? category : "");
        request.setAttribute("selectedActiveIngredient", activeIngredient != null ? activeIngredient : "");
        request.setAttribute("selectedDrugGroup", drugGroup != null ? drugGroup : "");
        request.setAttribute("selectedDrugType", drugType != null ? drugType : "");
        request.setAttribute("selectedStatus", status != null ? status : "");
        
        request.getRequestDispatcher("/jsp/viewMedicine.jsp").forward(request, response);
        
    } catch (SQLException e) {
        e.printStackTrace();
        request.setAttribute("error", "❌ Lỗi khi truy xuất dữ liệu: " + e.getMessage());
        request.getRequestDispatcher("/jsp/viewMedicine.jsp").forward(request, response);
    }
}
}