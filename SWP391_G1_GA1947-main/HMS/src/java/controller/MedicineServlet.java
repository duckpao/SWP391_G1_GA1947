package controller;

import DAO.MedicineDAO;
import Model.Medicine;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class MedicineServlet extends HttpServlet {
    private MedicineDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new MedicineDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Medicine> medicines = dao.getMedicines();
        request.setAttribute("medicines", medicines);
        request.getRequestDispatcher("/Medicine/MedicineList.jsp").forward(request, response);
    }
}
