package Controller;

import DAO.PurchaseOrderDAO;
import DAO.BatchDAO;
import model.PurchaseOrder;
import model.Batches;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashSet;
import java.util.Set;

public class BatchAddServlet extends HttpServlet {

    /** ✅ B1: Hiển thị form thêm lô (GET) */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String poIdStr = request.getParameter("poId");
        if (poIdStr == null || poIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/pharmacist/manage-batch");
            return;
        }

        try {
            int poId = Integer.parseInt(poIdStr);
            PurchaseOrderDAO orderDAO = new PurchaseOrderDAO();
            PurchaseOrder order = orderDAO.getOrderWithItems(poId);

            if (order == null) {
                request.setAttribute("errorMessage", "Không tìm thấy đơn hàng #" + poId);
                request.getRequestDispatcher("/pharmacist/manage-batch").forward(request, response);
                return;
            }

            request.setAttribute("order", order);
            request.getRequestDispatcher("/pharmacist/add_batch_form.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/pharmacist/manage-batch");
        }
    }

    /** ✅ B2: Nhận dữ liệu form và thêm batch */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            BatchDAO batchDAO = new BatchDAO();

            // Lấy dữ liệu từ form
            String[] medicineCodes = request.getParameterValues("medicineCode");
            String[] expiryDates = request.getParameterValues("expiryDate");
            String[] receivedDates = request.getParameterValues("receivedDate");
            String[] quantities = request.getParameterValues("initialQuantity");
            String[] supplierIds = request.getParameterValues("supplierId");

            if (medicineCodes == null || medicineCodes.length == 0) {
                request.setAttribute("errorMessage", "Không có thuốc nào để thêm lô.");
                request.getRequestDispatcher("/pharmacist/add_batch_form.jsp").forward(request, response);
                return;
            }

            // ✅ Dùng Set để đảm bảo không thêm trùng cùng medicine_code
            Set<String> addedMedicines = new HashSet<>();

            for (int i = 0; i < medicineCodes.length; i++) {
                String medCode = medicineCodes[i];

                // Bỏ qua thuốc trùng
                if (addedMedicines.contains(medCode)) continue;
                addedMedicines.add(medCode);

                Batches batch = new Batches();
                batch.setMedicineCode(medCode);
                batch.setSupplierId(Integer.parseInt(supplierIds[i]));
                batch.setReceivedDate(java.sql.Date.valueOf(receivedDates[i]));
                batch.setExpiryDate(java.sql.Date.valueOf(expiryDates[i]));

                int qty = Integer.parseInt(quantities[i]);
                batch.setInitialQuantity(qty);
                batch.setCurrentQuantity(qty);

                // ✅ Trạng thái hợp lệ với CHECK constraint
                batch.setStatus("Received");
                batch.setQuarantineNotes(null);

                // ✅ Sinh mã số lô duy nhất
                batch.setLotNumber(batchDAO.generateNextLotNumber());

                boolean success = batchDAO.insertBatch(batch);
                if (!success) {
                    System.err.println("⚠️ Không thể thêm lô cho thuốc " + medCode);
                } else {
                    System.out.println("✅ Đã thêm lô " + batch.getLotNumber() +
                            " cho thuốc " + medCode + " (SL: " + qty + ")");
                }
            }

            // ✅ Sau khi thêm thành công → quay lại trang quản lý
            response.sendRedirect(request.getContextPath() + "/pharmacist/manage-batch");

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi SQL khi thêm lô thuốc.");
            request.getRequestDispatcher("/pharmacist/add_batch_form.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi thêm lô thuốc.");
            request.getRequestDispatcher("/pharmacist/add_batch_form.jsp").forward(request, response);
        }
    }
}
