package Controller;

import DAO.BatchDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;


public class BatchDeleteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BatchDAO batchDAO;

    @Override
    public void init() {
        batchDAO = new BatchDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int batchId = Integer.parseInt(request.getParameter("id"));
            boolean success = batchDAO.deleteBatch(batchId);

            if (success) {
                request.getSession().setAttribute("message", "🗑️ Xóa lô thuốc thành công!");
            } else {
                request.getSession().setAttribute("error", "❌ Không thể xóa lô thuốc!");
            }
          response.sendRedirect(request.getContextPath() + "/pharmacist/manage-batch");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "❌ Lỗi khi xóa: " + e.getMessage());
       response.sendRedirect(request.getContextPath() + "/pharmacist/Manage-Batch.jsp");

        }
    }
}
