package Controller;

import DAO.BatchDAO;
import model.Batches;
import model.Medicine;
import model.Supplier;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


public class BatchAddServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            BatchDAO dao = new BatchDAO();

            // ✅ Lấy dữ liệu cần cho form
            List<Map<String, Object>> batchList = dao.getBatchList();
            List<Medicine> medicineList = dao.getAllMedicines();
            List<Supplier> supplierList = dao.getAllSuppliers();
            String nextLotNumber = dao.generateNextLotNumber(); // ⚡ dùng hàm mới

            // ✅ Đưa sang JSP
            request.setAttribute("batches", batchList);
            request.setAttribute("medicineList", medicineList);
            request.setAttribute("supplierList", supplierList);
            request.setAttribute("nextLotNumber", nextLotNumber);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/pharmacist/Manage-Batches.jsp");
            dispatcher.forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/pharmacist/manage-batch");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            BatchDAO dao = new BatchDAO();
            Batches batch = new Batches();

            // ✅ Lấy mã lô tự động
            String lotNumber = dao.generateNextLotNumber();
            batch.setLotNumber(lotNumber);

            // ✅ Lấy dữ liệu từ form
            batch.setMedicineCode(request.getParameter("medicineCode"));
            batch.setSupplierId(Integer.parseInt(request.getParameter("supplierId")));
            batch.setReceivedDate(java.sql.Date.valueOf(request.getParameter("receivedDate")));
            batch.setExpiryDate(java.sql.Date.valueOf(request.getParameter("expiryDate")));

            int initialQty = Integer.parseInt(request.getParameter("initialQuantity"));
            batch.setInitialQuantity(initialQty);
            batch.setCurrentQuantity(initialQty); // ban đầu current = initial

            batch.setStatus(request.getParameter("status"));
            batch.setQuarantineNotes(request.getParameter("quarantineNotes"));

            // ✅ Insert vào DB
            boolean success = dao.insertBatch(batch);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/pharmacist/manage-batch");
            } else {
                request.setAttribute("errorMessage", "Thêm lô thuốc thất bại.");
                doGet(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi khi thêm lô thuốc.");
            doGet(request, response);
        }
    }
}
