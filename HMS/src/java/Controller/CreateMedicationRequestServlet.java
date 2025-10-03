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

public class CreateMedicationRequestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null || !"Doctor".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }

        MedicationRequestDAO dao = new MedicationRequestDAO();
        List<Medicine> medicines = dao.getAllMedicines();
        if (medicines == null) {
            request.setAttribute("error", "Không thể tải danh sách thuốc!");
        } else {
            request.setAttribute("medicines", medicines);
        }
        request.getRequestDispatcher("/jsp/createRequest.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login");
            return;
        }
        int doctorId = (Integer) session.getAttribute("userId");
        System.out.println("=== START CREATE REQUEST ===");
        System.out.println("Doctor ID: " + doctorId);

        String notes = request.getParameter("notes");
        System.out.println("Notes: " + notes);

        MedicationRequest req = new MedicationRequest();
        req.setDoctorId(doctorId);
        req.setNotes(notes != null ? notes : "");

        List<MedicationRequestItem> items = new ArrayList<>();
        String[] medicineIds = request.getParameterValues("medicine_id");
        String[] quantities = request.getParameterValues("quantity");

        System.out.println("Medicine IDs: " + (medicineIds != null ? String.join(",", medicineIds) : "NULL"));
        System.out.println("Quantities: " + (quantities != null ? String.join(",", quantities) : "NULL"));

        if (medicineIds == null || quantities == null || medicineIds.length != quantities.length) {
            System.out.println("ERROR: Invalid medicine data");
            request.setAttribute("error", "Dữ liệu thuốc không hợp lệ!");
            doGet(request, response);
            return;
        }

        try {
            for (int i = 0; i < medicineIds.length; i++) {
                int medicineId = Integer.parseInt(medicineIds[i]);
                int quantity = Integer.parseInt(quantities[i]);
                System.out.println("Item " + i + ": Medicine ID=" + medicineId + ", Quantity=" + quantity);

                if (quantity <= 0) {
                    System.out.println("ERROR: Quantity <= 0");
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
            System.out.println("ERROR: Number format exception - " + e.getMessage());
            request.setAttribute("error", "Dữ liệu số không hợp lệ! " + e.getMessage());
            doGet(request, response);
            return;
        }

        req.setItems(items);
        System.out.println("Total items: " + items.size());

        MedicationRequestDAO dao = new MedicationRequestDAO();
        System.out.println("DAO created, calling createRequest...");

        int requestId = dao.createRequest(req);
        System.out.println("Request ID returned: " + requestId);

        if (requestId != -1) {
            System.out.println("Success! Adding request items...");
            try {
                dao.addRequestItems(requestId, items);
                System.out.println("Items added successfully!");

                // ✅ thay vì redirect, forward về lại createRequest.jsp và set success
                List<Medicine> medicines = dao.getAllMedicines();
                request.setAttribute("medicines", medicines);
                request.setAttribute("success", "Đặt thuốc thành công!");
                request.getRequestDispatcher("/jsp/createRequest.jsp").forward(request, response);

            } catch (Exception e) {
                System.out.println("ERROR adding items: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("error", "Lỗi khi thêm chi tiết yêu cầu: " + e.getMessage());
                doGet(request, response);
            }
        } else {
            System.out.println("ERROR: createRequest returned -1");
            request.setAttribute("error", "Không thể tạo yêu cầu. Vui lòng thử lại.");
            doGet(request, response);
        }
        System.out.println("=== END CREATE REQUEST ===");
    }
}
