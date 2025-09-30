package controller;

import DAO.MedicineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

public class UpdateMedicine extends HttpServlet {
    private MedicineDAO dao;

    @Override
    public void init() {
        dao = new MedicineDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String category = request.getParameter("category");
            String description = request.getParameter("description");
            Date expiryDate = Date.valueOf(request.getParameter("expiryDate"));
            int totalStock = Integer.parseInt(request.getParameter("totalStock"));

            boolean success = dao.updateMedicine(id, name, category, description, expiryDate, totalStock);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/Medicine/MedicineList");
            } else {
                request.setAttribute("error", "❌ Cập nhật thất bại!");
                request.getRequestDispatcher("/Medicine/MedicineList.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Dữ liệu không hợp lệ!");
        }
    }
}
