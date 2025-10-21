package Controller;

import DAO.BatchDAO;
import DAO.TransactionDAO;
import model.Batches;
import model.Transaction;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

public class RecordExpiredDamagedServlet extends HttpServlet {

    private final BatchDAO batchDAO = new BatchDAO();
    private final TransactionDAO transactionDAO = new TransactionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng đến form nhập liệu
        request.getRequestDispatcher("/pharmacist/recordExpiredDamaged.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 1️⃣ Lấy dữ liệu từ form
            int batchId = Integer.parseInt(request.getParameter("batchId"));
            int userId = Integer.parseInt(request.getParameter("userId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String reason = request.getParameter("reason"); // Expired / Damaged
            String notes = request.getParameter("notes");

            // 2️⃣ Lấy thông tin batch từ DB
            Batches batch = batchDAO.getBatchById(batchId);

            if (batch == null) {
                request.setAttribute("error", "Không tìm thấy lô thuốc với ID: " + batchId);
                request.getRequestDispatcher("/pharmacist/recordExpiredDamaged.jsp").forward(request, response);
                return;
            }

            // 3️⃣ Kiểm tra số lượng hợp lệ
            if (quantity <= 0 || quantity > batch.getCurrentQuantity()) {
                request.setAttribute("error", "Số lượng không hợp lệ (phải nhỏ hơn hoặc bằng số lượng hiện có).");
                request.getRequestDispatcher("/pharmacist/recordExpiredDamaged.jsp").forward(request, response);
                return;
            }

            // 4️⃣ Cập nhật lại batch
            boolean updated = batchDAO.updateBatchAfterRecord(batchId, quantity, reason);
            if (!updated) {
                request.setAttribute("error", "Không thể cập nhật lô thuốc. Vui lòng thử lại.");
                request.getRequestDispatcher("/pharmacist/recordExpiredDamaged.jsp").forward(request, response);
                return;
            }

            // 5️⃣ Ghi transaction mới
            Transaction t = new Transaction();
            t.setBatchId(batchId);
            t.setUserId(userId);
            t.setType(reason); // Expired hoặc Damaged
            t.setQuantity(quantity);
            t.setNotes(notes);

            boolean inserted = transactionDAO.insertTransaction(t);

            if (inserted) {
                request.setAttribute("message", "Ghi nhận thuốc " + reason.toLowerCase() + " thành công!");
            } else {
                request.setAttribute("error", "Lỗi khi lưu giao dịch vào hệ thống.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
        }

        // 6️⃣ Trả về giao diện form
        request.getRequestDispatcher("/pharmacist/recordExpiredDamaged.jsp").forward(request, response);
    }
}
