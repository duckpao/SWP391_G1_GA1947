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

    // ===================== ADD =====================
    private void addMedicine(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            // --- Prepare Medicine ---
            Medicine med = new Medicine();
            String medicineCode = "MED-" + UUID.randomUUID().toString().substring(0, 8);
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

            // --- Prepare Batch ---
            Batches batch = new Batches();
            batch.setMedicineCode(medicineCode);

            // Supplier ID
            String supplierIdStr = request.getParameter("supplierId");
            int supplierId = 1; // default
            if (supplierIdStr != null && !supplierIdStr.isEmpty()) {
                supplierId = Integer.parseInt(supplierIdStr);
            }
            batch.setSupplierId(supplierId);

            batch.setLotNumber("LOT-" + UUID.randomUUID().toString().substring(0, 6));

            // Expiry date
            String expiryParam = request.getParameter("expiryDate");
            if (expiryParam != null && !expiryParam.isEmpty()) {
                batch.setExpiryDate(Date.valueOf(expiryParam));
            } else {
                batch.setExpiryDate(null);
            }

            // Stock
            int stock = Integer.parseInt(request.getParameter("stock"));
            batch.setInitialQuantity(stock);
            batch.setCurrentQuantity(stock);

            // Status phải hợp lệ với DB
            batch.setStatus("Received"); // mặc định hợp lệ

            // --- Debug log ---
            System.out.println("Add medicine: " + med.getMedicineCode() + ", Name=" + med.getName());
            System.out.println("Batch lot=" + batch.getLotNumber() + ", Expiry=" + batch.getExpiryDate() + ", Supplier=" + batch.getSupplierId() + ", Stock=" + stock);

            // --- Call DAO ---
            boolean success = dao.addMedicine(med, batch);

            if (success) {
                request.getSession().setAttribute("success", "Thêm thuốc thành công!");
            } else {
                request.getSession().setAttribute("error", "Thêm thuốc thất bại!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Lỗi khi thêm thuốc!");
        }

        response.sendRedirect(request.getContextPath() + "/view-medicine");
    }

    // ===================== UPDATE =====================
 private void updateMedicine(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try{
            Medicine med = new Medicine();
            med.setMedicineCode(request.getParameter("medicineCode"));
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
            String batchIdStr = request.getParameter("batchId");
            if(batchIdStr==null || batchIdStr.isEmpty()){
                request.getSession().setAttribute("error","Không xác định batch để update!");
                response.sendRedirect(request.getContextPath()+"/view-medicine");
                return;
            }
            batch.setBatchId(Integer.parseInt(batchIdStr));
            batch.setMedicineCode(med.getMedicineCode());
            String expiry = request.getParameter("expiryDate");
            if(expiry!=null && !expiry.isEmpty()) batch.setExpiryDate(Date.valueOf(expiry));
            batch.setCurrentQuantity(Integer.parseInt(request.getParameter("stock")));
            batch.setStatus("Received");
            String sup = request.getParameter("supplierId");
            batch.setSupplierId(sup!=null&&!sup.isEmpty()?Integer.parseInt(sup):1);

            boolean ok = dao.updateMedicine(med,batch);
            if(ok) request.getSession().setAttribute("success","Cập nhật thuốc thành công!");
            else request.getSession().setAttribute("error","Cập nhật thất bại!");
        } catch(Exception e){ e.printStackTrace(); request.getSession().setAttribute("error","Lỗi khi cập nhật thuốc!"); }

        response.sendRedirect(request.getContextPath()+"/view-medicine");
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
