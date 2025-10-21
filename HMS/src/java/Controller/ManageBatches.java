package Controller;

import DAO.BatchDAO;
import model.Batches;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

public class ManageBatches extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
          BatchDAO dao = new BatchDAO();
        List<Map<String, Object>> list = dao.getAllBatches();

        request.setAttribute("batchList", list);
        request.getRequestDispatcher("/pharmacist/Manage-Batches.jsp").forward(request, response);
    }
}
