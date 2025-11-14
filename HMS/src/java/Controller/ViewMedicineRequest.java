package Controller;
import DAO.MedicationRequestDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.MedicationRequest;
import model.User;

public class ViewMedicineRequest extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Check authentication
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Check authorization
        String role = currentUser.getRole();
        if (!"Admin".equals(role) && !"Pharmacist".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/unauthorized.jsp");
            return;
        }
        
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