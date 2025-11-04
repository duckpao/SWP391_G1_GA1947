package Controller;

import DAO.ManagerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Medicine;
import model.PurchaseOrder;
import model.PurchaseOrderItem;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CancelledTasksServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");

        // Kiểm tra quyền Manager
        if (!"Manager".equals(role) || userId == null) {
            response.sendRedirect("login");
            return;
        }

        ManagerDAO dao = new ManagerDAO();

        // 1. Lấy danh sách các PO đã bị hủy
        List<PurchaseOrder> cancelledOrders = dao.getCancelledStockRequests();

        // 2. Lấy tất cả thuốc để map: medicine_code -> name (và các thông tin khác nếu cần)
        List<Medicine> allMedicines = dao.getAllMedicines();
        Map<String, String> medicineNameMap = new HashMap<>();
        Map<String, Medicine> medicineFullMap = new HashMap<>(); // Nếu cần full info

        for (Medicine med : allMedicines) {
            String code = med.getMedicineCode();
            if (code != null) {
                medicineNameMap.put(code, med.getDisplayName()); // Dùng getDisplayName() đẹp hơn
                medicineFullMap.put(code, med);
            }
        }

        // 3. Lấy chi tiết items cho từng PO (đã có thông tin thuốc từ DAO)
        Map<Integer, List<PurchaseOrderItem>> poItemsMap = new HashMap<>();
        for (PurchaseOrder po : cancelledOrders) {
            List<PurchaseOrderItem> items = dao.getPurchaseOrderItems(po.getPoId());
            if (items != null && !items.isEmpty()) {
                // Không cần set thủ công nữa vì DAO đã JOIN và set rồi
                // Nhưng để chắc chắn, vẫn có thể kiểm tra và fallback
                for (PurchaseOrderItem item : items) {
                    String code = item.getMedicineCode();
                    if (item.getMedicineName() == null && code != null) {
                        item.setMedicineName(medicineNameMap.getOrDefault(code, "Unknown Medicine"));
                    }
                    if (item.getMedicineStrength() == null && code != null) {
                        Medicine fullMed = medicineFullMap.get(code);
                        if (fullMed != null) {
                            item.setMedicineStrength(fullMed.getStrength());
                            item.setMedicineDosageForm(fullMed.getDosageForm());
                            item.setMedicineManufacturer(fullMed.getManufacturer());
                        }
                    }
                }
                poItemsMap.put(po.getPoId(), items);
            }
        }

        // 4. Gửi dữ liệu sang JSP
        request.setAttribute("cancelledOrders", cancelledOrders);
        request.setAttribute("poItemsMap", poItemsMap);
        request.setAttribute("medicineNameMap", medicineNameMap); // Nếu JSP cần lookup

        // Forward đến JSP
        request.getRequestDispatcher("/cancelled-tasks.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}