package Controller;

import DAO.MedicationRequestDAO;
import model.MedicationRequest;
import model.MedicationRequestItem;
import model.Medicine;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class UpdateMedicationRequestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null || !"Doctor".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }

        int requestId = Integer.parseInt(request.getParameter("requestId"));
        MedicationRequestDAO dao = new MedicationRequestDAO();
        MedicationRequest req = dao.getRequestById(requestId);
        List<MedicationRequestItem> items = dao.getRequestItems(requestId);
        List<Medicine> medicines = dao.getAllMedicines();

        if (req != null) {
            request.setAttribute("request", req);
            request.setAttribute("items", items);
            request.setAttribute("medicines", medicines);
            request.getRequestDispatcher("/jsp/updateRequest.jsp").forward(request, response);
        } else {
            response.sendRedirect("manage-requests?message=error_not_found");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login");
            return;
        }

        int requestId = Integer.parseInt(request.getParameter("requestId"));
        String notes = request.getParameter("notes");

        MedicationRequest req = new MedicationRequest();
        req.setRequestId(requestId);
        req.setNotes(notes != null ? notes : "");
        req.setStatus("Pending");

        List<MedicationRequestItem> items = new ArrayList<>();
        String[] medicineIds = request.getParameterValues("medicine_id");
        String[] quantities = request.getParameterValues("quantity");

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
        if (dao.updateRequest(req, items)) {
            response.sendRedirect("manage-requests?message=update_success");
        } else {
            request.setAttribute("error", "Không thể cập nhật yêu cầu!");
            doGet(request, response);
        }
    }
}
