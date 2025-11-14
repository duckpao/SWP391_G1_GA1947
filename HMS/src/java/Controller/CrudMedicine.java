package Controller;

import DAO.MedicineDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.UUID;
import model.Batches;
import model.Medicine;


public class CrudMedicine extends HttpServlet {
    private MedicineDAO dao;

    @Override
    public void init() {
        dao = new MedicineDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String action = request.getPathInfo();
        if (action == null) action = "";

        switch (action) {
            case "/add":
                addMedicine(request, response);
                break;
            case "/update":
                updateMedicine(request, response);
                break;
            case "/delete":
                deleteMedicine(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/view-medicine");
        }
    }

private void addMedicine(HttpServletRequest request, HttpServletResponse response)
        throws IOException {
    try {
        MedicineDAO dao = new MedicineDAO();

        // --- Sinh mã thuốc & mã lô tự động ---
        String medicineCode = dao.generateNextMedicineCode();
        String lotNumber = dao.generateNextLotNumber();

        Medicine med = new Medicine();
        med.setMedicineCode(medicineCode);
        med.setName(request.getParameter("name"));
        med.setCategory(request.getParameter("category"));
        med.setDescription(request.getParameter("description"));
        med.setActiveIngredient(request.getParameter("activeIngredient"));
        med.setDosageForm(request.getParameter("dosageForm"));
        med.setStrength(request.getParameter("strength"));
        med.setUnit(request.getParameter("unit"));
        med.setManufacturer(request.getParameter("manufacturer"));
        med.setCountryOfOrigin(request.getParameter("origin"));
        med.setDrugGroup(request.getParameter("drugGroup"));
        med.setDrugType(request.getParameter("drugType"));

        Batches batch = new Batches();
        batch.setMedicineCode(medicineCode);
        batch.setLotNumber(lotNumber);

        String supplierIdStr = request.getParameter("supplierId"); // chọn từ Supplier
        int supplierId = Integer.parseInt(supplierIdStr);
        batch.setSupplierId(supplierId);

        String expiryParam = request.getParameter("expiryDate");
        if (expiryParam != null && !expiryParam.isEmpty()) {
            batch.setExpiryDate(Date.valueOf(expiryParam));
        }

        int stock = Integer.parseInt(request.getParameter("stock"));
        batch.setInitialQuantity(stock);
        batch.setCurrentQuantity(stock);
        batch.setStatus("Received");

        boolean success = dao.addMedicine(med, batch);

        if (success) {
            request.getSession().setAttribute("success",
                    "✅ Thêm thuốc thành công! (" + medicineCode + " / " + lotNumber + ")");
        } else {
            request.getSession().setAttribute("error", "❌ Thêm thuốc thất bại!");
            response.sendRedirect(request.getContextPath() + "/view-medicine");
        }

    } catch (Exception e) {
        e.printStackTrace();
        request.getSession().setAttribute("error", "❌ Lỗi khi thêm thuốc: " + e.getMessage());
    }

    response.sendRedirect(request.getContextPath() + "/view-medicine");
}


   // ===================== UPDATE =====================
 private void updateMedicine(HttpServletRequest request, HttpServletResponse response)
        throws IOException {
    try {
        String medicineCode = request.getParameter("medicineCode");
        String batchIdStr = request.getParameter("batchId");

        System.out.println("=== UpdateMedicine Servlet ===");
        System.out.println("Received batchId=" + batchIdStr + ", medicineCode=" + medicineCode);

        if (medicineCode == null || medicineCode.trim().isEmpty()) {
            request.getSession().setAttribute("error", "? Mã thuốc không được để trống!");
            response.sendRedirect(request.getContextPath() + "/view-medicine");
            return;
        }

        // --- Medicine object ---
        Medicine med = new Medicine();
        med.setMedicineCode(medicineCode);
        med.setName(request.getParameter("name"));
        med.setCategory(request.getParameter("category"));
        med.setDescription(request.getParameter("description"));
        med.setActiveIngredient(request.getParameter("activeIngredient"));
        med.setDosageForm(request.getParameter("dosageForm"));
        med.setStrength(request.getParameter("strength"));
        med.setUnit(request.getParameter("unit"));
        med.setManufacturer(request.getParameter("manufacturer"));
        med.setCountryOfOrigin(request.getParameter("origin"));
        med.setDrugGroup(request.getParameter("drugGroup"));
        med.setDrugType(request.getParameter("drugType"));

        // --- Batch object (optional, nhưng FE đã gửi batchId) ---
        Batches batch = null;
        if (batchIdStr != null && !batchIdStr.trim().isEmpty()) {
            batch = new Batches();
            batch.setBatchId(Integer.parseInt(batchIdStr));
            batch.setMedicineCode(medicineCode);

            String supplierIdStr = request.getParameter("supplierId");
            if (supplierIdStr != null && !supplierIdStr.trim().isEmpty()) {
                batch.setSupplierId(Integer.parseInt(supplierIdStr));
            }

            String expiryParam = request.getParameter("expiryDate");
            if (expiryParam != null && !expiryParam.isEmpty()) {
                batch.setExpiryDate(Date.valueOf(expiryParam));
            }

            String stockStr = request.getParameter("stock");
            if (stockStr != null && !stockStr.trim().isEmpty()) {
                int stock = Integer.parseInt(stockStr);
                batch.setCurrentQuantity(stock);
                batch.setInitialQuantity(stock); // nếu muốn đồng bộ luôn
            }
        }

        // --- DAO update ---
        boolean success = dao.updateMedicine(med, batch);
        if (success) {
            request.getSession().setAttribute("success", "? Cập nhật thuốc thành công!");
        } else {
            request.getSession().setAttribute("error", "? Cập nhật thuốc thất bại!");
        }

    } catch (Exception e) {
        e.printStackTrace();
        request.getSession().setAttribute("error", "? Lỗi: " + e.getMessage());
    }

    response.sendRedirect(request.getContextPath() + "/view-medicine");
}
 
 
    // ===================== DELETE =====================
    private void deleteMedicine(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String code = request.getParameter("medicineCode");
            boolean success = dao.deleteMedicine(code);

            if (success) {
                request.getSession().setAttribute("success", "Xóa thuốc thành công!");
            } else {
                request.getSession().setAttribute("error", "Xóa thuốc thất bại!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi khi xóa thuốc!");
        }

        response.sendRedirect(request.getContextPath() + "/view-medicine");
    }
    
   

}
