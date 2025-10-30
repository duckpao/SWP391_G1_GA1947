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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // ❌ Nếu chưa login hoặc không có role
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("role");

        // ✅ Chỉ Doctor và Admin được phép
        if (!"Doctor".equals(role) && !"Admin".equals(role)) {
            switch (role) {
                case "Pharmacist":
                    response.sendRedirect(request.getContextPath() + "/pharmacist-dashboard");
                    return;
                case "Manager":
                    response.sendRedirect(request.getContextPath() + "/manager-dashboard");
                    return;
                case "Auditor":
                    response.sendRedirect(request.getContextPath() + "/auditor-dashboard");
                    return;
                case "Supplier":
                    response.sendRedirect(request.getContextPath() + "/supplier-dashboard");
                    return;
                default:
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
            }
        }

        try {
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
        } catch (NumberFormatException e) {
            System.err.println("Invalid requestId: " + e.getMessage());
            response.sendRedirect("manage-requests?message=error_invalid_id");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // ❌ Nếu chưa login hoặc không có userId
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        System.out.println("=== START UPDATE REQUEST ===");

        try {
            int requestId = Integer.parseInt(request.getParameter("requestId"));
            String notes = request.getParameter("notes");

            System.out.println("Request ID: " + requestId);
            System.out.println("Notes: " + notes);

            MedicationRequest req = new MedicationRequest();
            req.setRequestId(requestId);
            req.setNotes(notes != null ? notes : "");
            req.setStatus("Pending");

            List<MedicationRequestItem> items = new ArrayList<>();

            String[] medicineCodes = request.getParameterValues("medicine_code");
            String[] quantities = request.getParameterValues("quantity");

            System.out.println("Medicine Codes: " + (medicineCodes != null ? String.join(",", medicineCodes) : "NULL"));
            System.out.println("Quantities: " + (quantities != null ? String.join(",", quantities) : "NULL"));

            if (medicineCodes == null || quantities == null || medicineCodes.length != quantities.length) {
                System.err.println("ERROR: Invalid medicine data");
                request.setAttribute("error", "Dữ liệu thuốc không hợp lệ!");
                doGet(request, response);
                return;
            }

            for (int i = 0; i < medicineCodes.length; i++) {
                String medicineCode = medicineCodes[i];
                int quantity = Integer.parseInt(quantities[i]);

                System.out.println("Item " + i + ": Medicine Code=" + medicineCode + ", Quantity=" + quantity);

                if (quantity <= 0) {
                    System.err.println("ERROR: Quantity <= 0");
                    request.setAttribute("error", "Số lượng thuốc phải lớn hơn 0!");
                    doGet(request, response);
                    return;
                }

                MedicationRequestItem item = new MedicationRequestItem();
                item.setMedicineCode(medicineCode);
                item.setQuantity(quantity);
                items.add(item);
            }

            req.setItems(items);
            System.out.println("Total items: " + items.size());

            MedicationRequestDAO dao = new MedicationRequestDAO();

            if (dao.updateRequest(req, items)) {
                System.out.println("✅ Update successful!");
                response.sendRedirect("manage-requests?message=update_success");
            } else {
                System.err.println("❌ Update failed!");
                request.setAttribute("error", "Không thể cập nhật yêu cầu!");
                doGet(request, response);
            }

        } catch (NumberFormatException e) {
            System.err.println("ERROR: Number format exception - " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Dữ liệu số không hợp lệ! " + e.getMessage());
            doGet(request, response);
        }

        System.out.println("=== END UPDATE REQUEST ===");
    }
}
