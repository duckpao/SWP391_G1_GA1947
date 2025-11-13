package Controller;

import DAO.MedicationRequestDAO;
import DAO.NotificationDAO;
import DAO.UserDAO;
import model.MedicationRequest;
import model.MedicationRequestItem;
import model.Medicine;
import model.User;
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
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect("login");
            return;
        }
        
        // ✅ Cho phép cả Doctor và Admin
        String role = (String) session.getAttribute("role");
        if (!"Doctor".equals(role) && !"Admin".equals(role)) {
            response.sendRedirect("login");
            return;
        }

        MedicationRequestDAO dao = new MedicationRequestDAO();
        List<Medicine> medicines = dao.getAllMedicines();
        if (medicines == null || medicines.isEmpty()) {
            request.setAttribute("error", "Không thể tải danh sách thuốc!");
        } else {
            request.setAttribute("medicines", medicines);
        }
        
        request.getRequestDispatcher("/jsp/createRequest.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || session.getAttribute("role") == null) {
            response.sendRedirect("login");
            return;
        }
        
        // ✅ Kiểm tra role trước khi tạo request
        String role = (String) session.getAttribute("role");
        if (!"Doctor".equals(role) && !"Admin".equals(role)) {
            response.sendRedirect("login");
            return;
        }
        
        int doctorId = (Integer) session.getAttribute("userId");
        String username = (String) session.getAttribute("username"); // Lấy tên user
        
        System.out.println("========================================");
        System.out.println("=== CREATE MEDICATION REQUEST ===");
        System.out.println("========================================");
        System.out.println("User ID: " + doctorId);
        System.out.println("Username: " + username);
        System.out.println("Role: " + role);

        String notes = request.getParameter("notes");
        System.out.println("Notes: " + notes);

        MedicationRequest req = new MedicationRequest();
        req.setDoctorId(doctorId);
        req.setNotes(notes != null ? notes : "");

        List<MedicationRequestItem> items = new ArrayList<>();
        String[] medicineCodes = request.getParameterValues("medicine_code");
        String[] quantities = request.getParameterValues("quantity");

        System.out.println("Medicine Codes: " + (medicineCodes != null ? String.join(",", medicineCodes) : "NULL"));
        System.out.println("Quantities: " + (quantities != null ? String.join(",", quantities) : "NULL"));

        if (medicineCodes == null || quantities == null || medicineCodes.length != quantities.length) {
            System.out.println("❌ ERROR: Invalid medicine data");
            request.setAttribute("error", "Dữ liệu thuốc không hợp lệ!");
            doGet(request, response);
            return;
        }

        try {
            for (int i = 0; i < medicineCodes.length; i++) {
                String medicineCode = medicineCodes[i];
                int quantity = Integer.parseInt(quantities[i]);
                System.out.println("  Item " + (i+1) + ": " + medicineCode + " x " + quantity);

                if (quantity <= 0) {
                    System.out.println("❌ ERROR: Quantity <= 0");
                    request.setAttribute("error", "Số lượng thuốc phải lớn hơn 0!");
                    doGet(request, response);
                    return;
                }
                MedicationRequestItem item = new MedicationRequestItem();
                item.setMedicineCode(medicineCode);
                item.setQuantity(quantity);
                items.add(item);
            }
        } catch (NumberFormatException e) {
            System.out.println("❌ ERROR: Number format exception - " + e.getMessage());
            request.setAttribute("error", "Dữ liệu số không hợp lệ! " + e.getMessage());
            doGet(request, response);
            return;
        }

        req.setItems(items);
        System.out.println("Total items to create: " + items.size());

        MedicationRequestDAO dao = new MedicationRequestDAO();
        System.out.println("→ Calling createRequest()...");

        int requestId = dao.createRequest(req);
        System.out.println("→ Request ID returned: " + requestId);

        if (requestId != -1) {
            System.out.println("✓ Request created successfully! Now adding items...");
            try {
                dao.addRequestItems(requestId, items);
                System.out.println("✓ Items added successfully!");

                // ✅ GỬI NOTIFICATION ĐẾN TẤT CẢ PHARMACIST
                System.out.println("========================================");
                System.out.println("→ Sending notifications to Pharmacists...");
                sendNotificationToPharmacists(doctorId, username, requestId, items.size());
                System.out.println("========================================");

                // Reload danh sách thuốc và set success
                List<Medicine> medicines = dao.getAllMedicines();
                request.setAttribute("medicines", medicines);
                request.setAttribute("success", "Đặt thuốc thành công! Đã gửi thông báo đến dược sĩ.");
                request.getRequestDispatcher("/jsp/createRequest.jsp").forward(request, response);

            } catch (Exception e) {
                System.out.println("❌ ERROR adding items: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("error", "Lỗi khi thêm chi tiết yêu cầu: " + e.getMessage());
                doGet(request, response);
            }
        } else {
            System.out.println("❌ ERROR: createRequest returned -1");
            request.setAttribute("error", "Không thể tạo yêu cầu. Vui lòng thử lại.");
            doGet(request, response);
        }
        System.out.println("========================================");
        System.out.println("=== END CREATE MEDICATION REQUEST ===");
        System.out.println("========================================\n");
    }

    /**
     * ✅ GỬI NOTIFICATION ĐẾN TẤT CẢ PHARMACIST
     * Tương tự như cách Manager gửi notification cho Supplier
     */
    private void sendNotificationToPharmacists(int doctorId, String doctorName, int requestId, int itemCount) {
        try {
            System.out.println("→ Getting list of all Pharmacists...");
            
            UserDAO userDAO = new UserDAO();
            List<User> pharmacists = userDAO.getUsersByRole("Pharmacist");
            
            if (pharmacists == null || pharmacists.isEmpty()) {
                System.out.println("⚠️ No Pharmacists found in system!");
                return;
            }
            
            System.out.println("✓ Found " + pharmacists.size() + " Pharmacist(s)");
            
            NotificationDAO notificationDAO = new NotificationDAO();
            
            // Chuẩn bị nội dung notification
            String title = "New Medication Request #" + requestId;
            String message = "Dr. " + doctorName + " has created a new medication request #" + requestId + 
                           " with " + itemCount + " item(s). Please review and process this request.";
            String notificationType = "info";
            String priority = "high";
            String linkUrl = "/pharmacist/View_MedicineRequest"; // Link đến trang pharmacist xử lý request
            
            int successCount = 0;
            int failCount = 0;
            
            // Gửi notification đến từng Pharmacist
            for (User pharmacist : pharmacists) {
                System.out.println("  → Sending to: " + pharmacist.getUsername() + " (ID: " + pharmacist.getUserId() + ")");
                
                boolean sent = notificationDAO.sendNotificationToUser(
                    doctorId,                    // sender: doctor/admin
                    pharmacist.getUserId(),      // receiver: pharmacist
                    title,
                    message,
                    notificationType,
                    priority,
                    linkUrl
                );
                
                if (sent) {
                    successCount++;
                    System.out.println("    ✓ Sent successfully");
                } else {
                    failCount++;
                    System.out.println("    ✗ Failed to send");
                }
            }
            
            System.out.println("========================================");
            System.out.println("📊 NOTIFICATION SUMMARY:");
            System.out.println("  - Total Pharmacists: " + pharmacists.size());
            System.out.println("  - Sent successfully: " + successCount);
            System.out.println("  - Failed: " + failCount);
            System.out.println("========================================");
            
        } catch (Exception e) {
            System.err.println("❌ Error sending notifications to Pharmacists:");
            e.printStackTrace();
            // Không throw exception - notification failure không nên làm fail main operation
        }
    }
}