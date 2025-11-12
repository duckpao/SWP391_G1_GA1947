package Controller;

import DAO.IssueSlipDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.IssueSlip;
import model.IssueSlipItem;

public class ViewIssueSlipServlet extends HttpServlet {

    private IssueSlipDAO dao;

    @Override
    public void init() throws ServletException {
        super.init();
        dao = new IssueSlipDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String requestIdStr = request.getParameter("requestId");
        System.out.println("ViewIssueSlipServlet - requestId = " + requestIdStr);

        if (requestIdStr == null || requestIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/pharmacist/View_MedicineRequest");
            return;
        }

        int requestId;
        try {
            requestId = Integer.parseInt(requestIdStr);
        } catch (NumberFormatException e) {
            System.out.println("Invalid requestId: " + requestIdStr);
            response.sendRedirect(request.getContextPath() + "/pharmacist/View_MedicineRequest");
            return;
        }

        try {
            IssueSlip slip = dao.getIssueSlipByRequestId(requestId);
            if (slip == null) {
                System.out.println("No IssueSlip found for requestId: " + requestId);
                response.sendRedirect(request.getContextPath() + "/pharmacist/View_MedicineRequest");
                return;
            }

            List<IssueSlipItem> items = dao.getIssueSlipItems(slip.getSlipId());

            request.setAttribute("slip", slip);
            request.setAttribute("items", items);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/pharmacist/ViewIssueSlip.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/pharmacist/View_MedicineRequest");
        }
    }
}
