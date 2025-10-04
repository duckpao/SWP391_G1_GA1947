package Controller;

import DAO.DBContext;
import DAO.MedicineDAO;
import model.Medicine;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ViewMedicineServlet extends HttpServlet {
    private MedicineDAO medicineDAO;

    @Override
    public void init() {
        medicineDAO = new MedicineDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Medicine> medicines = medicineDAO.getMedicineDetails();
        request.setAttribute("medicines", medicines);
        request.getRequestDispatcher("/jsp/viewMedicine.jsp").forward(request, response);
    }
}