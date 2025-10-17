package Controller;

import DAO.MedicineDAO;
import model.Medicine;
import model.Batches;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;

@WebServlet(name = "CrudMedicine", urlPatterns = {"/Medicine/*"})
public class CrudMedicine extends HttpServlet {
    private MedicineDAO dao = new MedicineDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();

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

    private void addMedicine(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            Medicine med = new Medicine();
            med.setName(request.getParameter("name"));
            med.setCategory(request.getParameter("category"));
            med.setDescription(request.getParameter("description"));

            Batches batch = new Batches();
            batch.setSupplierId(Integer.parseInt(request.getParameter("supplierId")));
            batch.setLotNumber(request.getParameter("lotNumber"));
            batch.setExpiryDate(new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("expiryDate")));
            int qty = Integer.parseInt(request.getParameter("quantity"));
            batch.setInitialQuantity(qty);
            batch.setCurrentQuantity(qty);
            batch.setStatus("Approved");

            dao.addMedicine(med, batch);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/view-medicine");
    }

    private void updateMedicine(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            Medicine med = new Medicine();
            med.setMedicineId(Integer.parseInt(request.getParameter("id")));
            med.setName(request.getParameter("name"));
            med.setCategory(request.getParameter("category"));
            med.setDescription(request.getParameter("description"));

            Batches batch = new Batches();
            batch.setBatchId(Integer.parseInt(request.getParameter("batchId")));
            batch.setSupplierId(Integer.parseInt(request.getParameter("supplierId"))); // quan trọng
            batch.setLotNumber(request.getParameter("lotNumber"));
            batch.setExpiryDate(new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("expiryDate")));
            batch.setCurrentQuantity(Integer.parseInt(request.getParameter("quantity")));
            batch.setStatus("Approved");

            dao.updateMedicine(med, batch);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/view-medicine");
    }

    private void deleteMedicine(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.deleteMedicine(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/view-medicine");
    }
}
