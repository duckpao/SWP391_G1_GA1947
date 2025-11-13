package Controller;

import DAO.BatchDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;


public class BatchQualityCheckServlet extends HttpServlet {
    private BatchDAO batchDAO = new BatchDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        int batchId = Integer.parseInt(req.getParameter("batchId"));
        String status = req.getParameter("status");
        String notes = req.getParameter("quarantineNotes");

        boolean success = batchDAO.updateQualityCheck(batchId, status, notes);

        if (success) {
            req.getSession().setAttribute("message", "✅ Cập nhật kiểm chứng thành công!");
        } else {
            req.getSession().setAttribute("error", "❌ Không thể cập nhật kiểm chứng!");
        }

        resp.sendRedirect(req.getContextPath() + "/pharmacist/manage-batch");
    }
}
