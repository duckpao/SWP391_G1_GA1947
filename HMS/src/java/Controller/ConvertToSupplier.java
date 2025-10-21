package Controller;

import DAO.UserDAO;
import DAO.SupplierDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import model.Supplier;

public class ConvertToSupplier extends HttpServlet {
    private SupplierDAO supplierDAO = new SupplierDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Lấy ID user và chuyển đến trang nhập thông tin Supplier
        String userId = req.getParameter("userId");
        req.setAttribute("userId", userId);
        req.getRequestDispatcher("/admin/convert_to_supplier.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(req.getParameter("user_id"));
            String name = req.getParameter("name");
            String contactEmail = req.getParameter("contact_email");
            String contactPhone = req.getParameter("contact_phone");
            String address = req.getParameter("address");
            double performanceRating = Double.parseDouble(req.getParameter("performance_rating"));

            Supplier s = new Supplier();
            s.setUserId(userId);
            s.setName(name);
            s.setContactEmail(contactEmail);
            s.setContactPhone(contactPhone);
            s.setAddress(address);
            s.setPerformanceRating(performanceRating);
            s.setCreatedAt(LocalDateTime.now());
            s.setUpdatedAt(LocalDateTime.now());

            supplierDAO.addSupplier(s);
            userDAO.updateRole(userId, "Supplier");

            resp.sendRedirect(req.getContextPath() + "/admin-dashboard?success=converted");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}