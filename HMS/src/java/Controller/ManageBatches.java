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
            List<Medicine> medicineList = dao.getAllMedicines();
            List<Supplier> supplierList = dao.getAllSuppliers();
            String nextLotNumber = dao.generateNextLotNumber();

            String lotNumber = request.getParameter("lotNumber");
            String status = request.getParameter("status");
            String medicineCodeFilter = request.getParameter("medicineCode");
            String supplierIdFilter = request.getParameter("supplierId");

            List<Map<String, Object>> batches;
            if ((lotNumber != null && !lotNumber.isEmpty()) ||
                (medicineCodeFilter != null && !medicineCodeFilter.isEmpty()) ||
                (supplierIdFilter != null && !supplierIdFilter.isEmpty()) ||
                (status != null && !status.isEmpty())) {

                batches = dao.filterBatches(lotNumber, medicineCodeFilter, supplierIdFilter);
            } else {
                batches = dao.getBatchList();
            }

            // ✅ Lấy tên thuốc và NCC để giữ lại sau khi tìm kiếm
            String medicineLabel = "";
            String supplierLabel = "";

            if (medicineCodeFilter != null && !medicineCodeFilter.isEmpty()) {
                for (Medicine m : medicineList) {
                    if (m.getMedicineCode().equals(medicineCodeFilter)) {
                        medicineLabel = m.getName();
                        break;
                    }
                }
            }

            if (supplierIdFilter != null && !supplierIdFilter.isEmpty()) {
                for (Supplier s : supplierList) {
                    if (String.valueOf(s.getSupplierId()).equals(supplierIdFilter)) {
                        supplierLabel = s.getName();
                        break;
                    }
                }
            }

            request.setAttribute("batches", batches);
            request.setAttribute("medicineList", medicineList);
            request.setAttribute("supplierList", supplierList);
            request.setAttribute("nextLotNumber", nextLotNumber);
            request.setAttribute("medicineLabel", medicineLabel);
            request.setAttribute("supplierLabel", supplierLabel);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("nextLotNumber", "LOT001");
        }

        request.getRequestDispatcher("/pharmacist/Manage-Batches.jsp").forward(request, response);
    }
}
