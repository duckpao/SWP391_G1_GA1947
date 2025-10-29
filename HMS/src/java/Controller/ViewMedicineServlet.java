package Controller;
import DAO.MedicineDAO;
import model.Medicine;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ViewMedicineServlet extends HttpServlet {
    private MedicineDAO medicineDAO;
    
    @Override
    public void init() {
        medicineDAO = new MedicineDAO();
    }
    
@Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String keyword = request.getParameter("keyword");
    String category = request.getParameter("category");
    String status = request.getParameter("status");

    // Nếu chưa có DAO thì khởi tạo
    if (medicineDAO == null) {
        medicineDAO = new MedicineDAO();
    }

    List<Medicine> medicines;
    boolean hasFilter = (keyword != null && !keyword.trim().isEmpty())
            || (category != null && !"All".equals(category))
            || (status != null && !status.isEmpty());

    if (hasFilter) {
        medicines = medicineDAO.searchMedicines(keyword, category, status);
    } else {
        medicines = medicineDAO.getAllMedicines();
    }

    List<String> categories = medicineDAO.getAllCategories();

    request.setAttribute("medicines", medicines);
    request.setAttribute("categories", categories);
    request.setAttribute("keyword", keyword != null ? keyword : "");
    request.setAttribute("selectedCategory", category != null ? category : "All");
    request.setAttribute("selectedStatus", status != null ? status : "");

    request.getRequestDispatcher("/jsp/viewMedicine.jsp").forward(request, response);
}

}
