package Controller;

import DAO.BatchDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import model.Batches;


public class BatchUpdateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BatchDAO batchDAO;

    @Override
    public void init() {
        batchDAO = new BatchDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            
            System.out.println("===== DEBUG UPDATE BATCH =====");
System.out.println("batchId: " + request.getParameter("batchId"));
System.out.println("expiryDate: " + request.getParameter("expiryDate"));
System.out.println("currentQuantity: " + request.getParameter("currentQuantity"));
System.out.println("status: " + request.getParameter("status"));


            int batchId = Integer.parseInt(request.getParameter("batchId"));
            String expiryDate = request.getParameter("expiryDate");
            int currentQuantity = Integer.parseInt(request.getParameter("currentQuantity"));
            String status = request.getParameter("status");

            Batches batch = new Batches();
            batch.setBatchId(batchId);
            batch.setExpiryDate(Date.valueOf(expiryDate));
            batch.setCurrentQuantity(currentQuantity);
            batch.setStatus(status);

            boolean success = batchDAO.updateBatch(batch);

            if (success) {
                request.getSession().setAttribute("message", "✅ Cập nhật lô thuốc thành công!");
            } else {
                request.getSession().setAttribute("error", "❌ Không thể cập nhật lô thuốc!");
            }

            // ✅ redirect về trang đúng context'
            
   response.sendRedirect(request.getContextPath() + "/pharmacist/manage-batch");


        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "❌ Lỗi khi cập nhật: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/pharmacist/Manage-Batches.jsp");
        }
    }
}
