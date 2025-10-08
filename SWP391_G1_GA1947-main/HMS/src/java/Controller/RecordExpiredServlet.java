package Controller;

import DAO.MedicineDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;


public class RecordExpiredServlet extends HttpServlet {

    private MedicineDAO medicineDAO;

    @Override
    public void init() throws ServletException {
        medicineDAO = new MedicineDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int batchId = Integer.parseInt(request.getParameter("batchId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String reason = request.getParameter("reason"); // Expired/Damaged
            String notes = request.getParameter("notes");
            
            // Lấy userId từ session (nếu có login), tạm hardcode = 1
            int userId = 1;

            boolean success = medicineDAO.recordExpiredOrDamaged(batchId, userId, quantity, reason, notes);

            if (success) {
                request.setAttribute("message", "Record saved successfully!");
            } else {
                request.setAttribute("message", "Failed to save record!");
            }

            // Sau khi xử lý xong → quay lại list medicine
            request.getRequestDispatcher("listmedicine.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error: " + e.getMessage());
            request.getRequestDispatcher("listmedicine.jsp").forward(request, response);
        }
    }
}
