package Controller;

import DAO.MedicationRequestDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.MedicationRequest;

public class ViewMedicineRequest extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy danh sách yêu cầu thuốc
        MedicationRequestDAO reqDao = new MedicationRequestDAO();
        List<MedicationRequest> requestList = reqDao.viewMedicationRequests();

        // Gửi dữ liệu sang JSP
        request.setAttribute("requestList", requestList);

        // Chuyển hướng tới trang hiển thị
        RequestDispatcher dispatcher = request.getRequestDispatcher("/pharmacist/ViewMedicineRequest.jsp");
        dispatcher.forward(request, response);
    }
}
