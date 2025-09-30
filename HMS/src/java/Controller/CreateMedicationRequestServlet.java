
package Controller;

import DAO.MedicationRequestDAO;
import Model.MedicationRequest;
import Model.MedicationRequestItem;
import Model.Medicine;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class CreateMedicationRequestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Không tạo session mới
        if (session == null || session.getAttribute("role") == null || !"Doctor".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }

        MedicationRequestDAO dao = new MedicationRequestDAO();
        List<Medicine> medicines = dao.getAllMedicines();
        request.setAttribute("medicines", medicines);
        request.getRequestDispatcher("/WEB-INF/jsp/createRequest.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login");
            return;
        }
        int doctorId = (Integer) session.getAttribute("userId");

        String notes = request.getParameter("notes");
        MedicationRequest req = new MedicationRequest(); // Đã có default constructor
        req.setDoctorId(doctorId);
        req.setNotes(notes != null ? notes : ""); // Tránh null

        // Parse items từ form
        List<MedicationRequestItem> items = new ArrayList<>();
        String[] medicineIds = request.getParameterValues("medicine_id");
        String[] quantities = request.getParameterValues("quantity");

        // Kiểm tra null và length khớp
        if (medicineIds == null || quantities == null || medicineIds.length != quantities.length) {
            request.setAttribute("error", "Dữ liệu thuốc không hợp lệ!");
            doGet(request, response);
            return;
        }

        try {
            for (int i = 0; i < medicineIds.length; i++) {
                int medicineId = Integer.parseInt(medicineIds[i]);
                int quantity = Integer.parseInt(quantities[i]);
                if (quantity <= 0) {
                    request.setAttribute("error", "Số lượng thuốc phải lớn hơn 0!");
                    doGet(request, response);
                    return;
                }
                MedicationRequestItem item = new MedicationRequestItem();
                item.setMedicineId(medicineId);
                item.setQuantity(quantity);
                items.add(item);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu số không hợp lệ!");
            doGet(request, response);
            return;
        }

        req.setItems(items);

        MedicationRequestDAO dao = new MedicationRequestDAO();
        int requestId = dao.createRequest(req);
        if (requestId != -1) {
            dao.addRequestItems(requestId, items);
            response.sendRedirect("doctor-dashboard?message=request_success"); // Redirect về dashboard
        } else {
            request.setAttribute("error", "Không thể tạo yêu cầu. Vui lòng thử lại.");
            doGet(request, response);
        }
    }
}
