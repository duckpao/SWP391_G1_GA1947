package Controller;

import DAO.ManagerDAO;
import DAO.DBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.StockAlert;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

public class StockAlertsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (!"Manager".equals(role) || userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        ManagerDAO dao = new ManagerDAO();
        List<StockAlert> alerts = dao.getStockAlerts();

        String thresholdQuery = "SELECT config_value FROM SystemConfig WHERE config_key = 'low_stock_threshold'";
        int threshold = 10; // default nếu DB không có giá trị

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(thresholdQuery);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                threshold = Integer.parseInt(rs.getString("config_value"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("alerts", alerts);
        request.setAttribute("threshold", threshold);
        request.getRequestDispatcher("/stock-alerts.jsp").forward(request, response);
    }
}
