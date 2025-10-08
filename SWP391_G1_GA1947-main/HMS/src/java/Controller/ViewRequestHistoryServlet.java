package Controller;

import DAO.MedicationRequestDAO;
import model.MedicationRequest;
import model.MedicationRequestItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class ViewRequestHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null || !"Doctor".equals(session.getAttribute("role"))) {
            response.sendRedirect("login");
            return;
        }

        int doctorId = (Integer) session.getAttribute("userId");
        MedicationRequestDAO dao = new MedicationRequestDAO();
        List<MedicationRequest> requests = dao.getRequestsByDoctorId(doctorId);

        // Lấy tham số lọc
        String medicineName = request.getParameter("medicineName");
        String dateStr = request.getParameter("date");

        // Lọc danh sách
        if ((medicineName != null && !medicineName.trim().isEmpty()) || (dateStr != null && !dateStr.isEmpty())) {
            requests = filterRequests(requests, medicineName, dateStr);
        }

        // Lấy danh sách items cho mỗi request
        Map<Integer, List<MedicationRequestItem>> requestItemsMap = new HashMap<>();
        for (MedicationRequest req : requests) {
            List<MedicationRequestItem> items = dao.getRequestItems(req.getRequestId());
            requestItemsMap.put(req.getRequestId(), items);
        }

        request.setAttribute("requests", requests);
        request.setAttribute("requestItemsMap", requestItemsMap);
        request.getRequestDispatcher("/jsp/viewRequestHistory.jsp").forward(request, response);
    }

    private List<MedicationRequest> filterRequests(List<MedicationRequest> requests, String medicineName, String dateStr) {
        try {
            String searchName = (medicineName != null && !medicineName.trim().isEmpty()) ? medicineName.trim().toLowerCase() : null;
            java.util.Date date = (dateStr != null && !dateStr.isEmpty()) ? new SimpleDateFormat("yyyy-MM-dd").parse(dateStr) : null;

            return requests.stream().filter(req -> {
                boolean matchesMedicine = searchName == null || hasMedicineByName(req.getRequestId(), searchName);
                boolean matchesDate = date == null || isSameDay((Timestamp) req.getRequestDate(), date);
                return matchesMedicine && matchesDate;
            }).collect(Collectors.toList());
        } catch (ParseException e) {
            System.err.println("Error in filterRequests: " + e.getMessage());
            return requests; // Trả về danh sách gốc nếu lỗi
        }
    }

    private boolean hasMedicineByName(int requestId, String medicineName) {
        MedicationRequestDAO dao = new MedicationRequestDAO();
        List<MedicationRequestItem> items = dao.getRequestItems(requestId);
        return items.stream().anyMatch(item -> 
            item.getMedicineName() != null && 
            item.getMedicineName().toLowerCase().contains(medicineName)
        );
    }

    private boolean isSameDay(java.sql.Timestamp requestDate, java.util.Date filterDate) {
        if (requestDate == null || filterDate == null) return false;
        java.util.Calendar cal1 = java.util.Calendar.getInstance();
        java.util.Calendar cal2 = java.util.Calendar.getInstance();
        cal1.setTime(requestDate);
        cal2.setTime(filterDate);
        return cal1.get(java.util.Calendar.YEAR) == cal2.get(java.util.Calendar.YEAR) &&
               cal1.get(java.util.Calendar.MONTH) == cal2.get(java.util.Calendar.MONTH) &&
               cal1.get(java.util.Calendar.DAY_OF_MONTH) == cal2.get(java.util.Calendar.DAY_OF_MONTH);
    }
}