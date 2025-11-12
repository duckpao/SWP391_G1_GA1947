package Controller;

import DAO.PurchaseOrderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AuditorDashboard extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // ❌ Nếu chưa đăng nhập → quay lại login
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("role");
        String path = request.getServletPath();

        PurchaseOrderDAO poDAO = new PurchaseOrderDAO();

        Object[] stats = poDAO.getPurchaseOrderStatistics();

        // ✅ Admin được vào tất cả dashboard
        if ("Admin".equals(role)) {
            request.setAttribute("totalOrders", stats[0]);
        request.setAttribute("completedOrders", stats[1]);
        request.setAttribute("pendingOrders", stats[2]);
        request.setAttribute("totalAmount", stats[3]);
            request.getRequestDispatcher("/auditor/auditor-dashboard.jsp").forward(request, response);
            return;
        }

        // ✅ Auditor chỉ được vào auditor-dashboard
        if ("Auditor".equals(role)) {
            request.setAttribute("totalOrders", stats[0]);
        request.setAttribute("completedOrders", stats[1]);
        request.setAttribute("pendingOrders", stats[2]);
        request.setAttribute("totalAmount", stats[3]);
            request.getRequestDispatcher("/auditor/auditor-dashboard.jsp").forward(request, response);
            return;
        }

        // ✅ Doctor → đá về doctor-dashboard
        if ("Doctor".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/doctor-dashboard");
            return;
        }

        // ✅ Pharmacist → đá về pharmacist-dashboard
        if ("Pharmacist".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/pharmacist-dashboard");
            return;
        }

        // ✅ Manager → đá về manager-dashboard
        if ("Manager".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/manager-dashboard");
            return;
        }

        // ✅ Supplier → đá về supplier-dashboard
        if ("Supplier".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/supplier-dashboard");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/login");

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Auditor Dashboard Servlet with Role-based Access Control";
    }
}
