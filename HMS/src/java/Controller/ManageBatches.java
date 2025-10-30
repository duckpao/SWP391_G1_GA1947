package Controller;

import DAO.BatchDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;


public class ManageBatches extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BatchDAO dao = new BatchDAO();
        List<Map<String, Object>> batches = dao.getBatchList();

        request.setAttribute("batches", batches);
        request.getRequestDispatcher("/pharmacist/Manage-Batches.jsp").forward(request, response);
    }
}
