package Controller;

import DAO.BatchDAO;
import model.Medicine;
import model.Supplier;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public class ManageBatches extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BatchDAO dao = new BatchDAO();
        try {
            // ✅ Lấy danh sách thuốc và nhà cung cấp
            List<Medicine> medicineList = dao.getAllMedicines();
            List<Supplier> supplierList = dao.getAllSuppliers();
            String nextLotNumber = dao.generateNextLotNumber();

            // ✅ Lấy các tham số filter từ request
            String lotNumber = request.getParameter("lotNumber");
            String filterType = request.getParameter("filterType"); // medicineCode / supplierId
            String filterValue = request.getParameter("filterValue");
            String status = request.getParameter("status");

            String medicineCodeFilter = null;
            String supplierIdFilter = null;

            if ("medicineCode".equals(filterType)) medicineCodeFilter = filterValue;
            if ("supplierId".equals(filterType)) supplierIdFilter = filterValue;

            // ✅ Lấy danh sách lô thuốc có filter
            List<Map<String, Object>> batches;
            if ((lotNumber != null && !lotNumber.isEmpty()) || 
                (medicineCodeFilter != null) || 
                (supplierIdFilter != null) || 
                (status != null && !status.isEmpty())) {

                batches = dao.filterBatches(lotNumber, medicineCodeFilter, supplierIdFilter);
            } else {
                batches = dao.getBatchList();
            }

            // ✅ Chuyển filterValue thành tên hiển thị
            String filterDisplay = null;
            if ("medicineCode".equals(filterType) && filterValue != null) {
                for (Medicine m : medicineList) {
                    if (m.getMedicineCode().equals(filterValue)) {
                        filterDisplay = m.getName(); // hiển thị tên thuốc
                        break;
                    }
                }
            } else if ("supplierId".equals(filterType) && filterValue != null) {
                for (Supplier s : supplierList) {
                    if (String.valueOf(s.getSupplierId()).equals(filterValue)) {
                        filterDisplay = s.getName(); // hiển thị tên nhà cung cấp
                        break;
                    }
                }
            }

            // ✅ Đưa dữ liệu sang JSP
            request.setAttribute("batches", batches);
            request.setAttribute("medicineList", medicineList);
            request.setAttribute("supplierList", supplierList);
            request.setAttribute("nextLotNumber", nextLotNumber);
            request.setAttribute("filterDisplay", filterDisplay); // dùng để hiển thị nút dropdown

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("nextLotNumber", "LOT001");
        }

        request.getRequestDispatcher("/pharmacist/Manage-Batches.jsp").forward(request, response);
    }
}
