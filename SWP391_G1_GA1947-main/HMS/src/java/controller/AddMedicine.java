package controller;

import DAO.MedicineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;

public class AddMedicine extends HttpServlet {
    private MedicineDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new MedicineDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String name = request.getParameter("name");
            String category = request.getParameter("category");
            String description = request.getParameter("description");
            int supplierId = Integer.parseInt(request.getParameter("supplierId"));
            String lotNumber = request.getParameter("lotNumber");
            Date expiryDate = Date.valueOf(request.getParameter("expiryDate"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            boolean success = dao.addMedicineWithBatch(
                    name, category, description, supplierId, lotNumber, expiryDate, quantity
            );

            if (success) {
                // ✅ Redirect về list
                response.sendRedirect(request.getContextPath() + "/Medicine/MedicineList");
            } else {
                request.setAttribute("error", "Thêm thuốc thất bại!");
                request.getRequestDispatcher("/Medicine/AddMedicine.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Medicine/MedicineList?error=true");
        }
    }
}
