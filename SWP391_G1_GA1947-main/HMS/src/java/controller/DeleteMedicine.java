package controller;

import DAO.MedicineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class DeleteMedicine extends HttpServlet {
    private MedicineDAO dao;

    @Override
    public void init() {
        dao = new MedicineDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        boolean success = dao.deleteMedicine(id);

        if (success) {
            // ✅ Xóa thành công → quay lại danh sách
            response.sendRedirect(request.getContextPath() + "/Medicine/MedicineList");
        } else {
            // ❌ Xóa thất bại → báo lỗi
            request.setAttribute("error", "Không thể xóa thuốc ID=" + id);
            request.getRequestDispatcher("/Medicine/MedicineList.jsp").forward(request, response);
        }
    }
}
