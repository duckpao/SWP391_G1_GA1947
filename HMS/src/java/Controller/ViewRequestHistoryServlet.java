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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // ❌ Nếu chưa đăng nhập hoặc không có role
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("role");

        // ✅ Chỉ cho phép Doctor và Admin truy cập
        if (!"Doctor".equals(role) && !"Admin".equals(role)) {
            switch (role) {
                case "Pharmacist":
                    response.sendRedirect(request.getContextPath() + "/pharmacist-dashboard");
                    return;
                case "Manager":
                    response.sendRedirect(request.getContextPath() + "/manager-dashboard");
                    return;
                case "Auditor":
                    response.sendRedirect(request.getContextPath() + "/auditor-dashboard");
                    return;
                case "Supplier":
                    response.sendRedirect(request.getContextPath() + "/supplier-dashboard");
                    return;
                default:
                    response.sendRedirect(request.getContextPath() + "/login");
                    return;
            }
        }

        // ✅ Nếu Doctor hoặc Admin được phép → xử lý dữ liệu
        int doctorId = (Integer) session.getAttribute("userId");
        MedicationRequestDAO dao = new MedicationRequestDAO();

        List<MedicationRequest> requests = dao.getRequestsByDoctorId(doctorId);

        // --- Bộ lọc ---
        String medicineName = request.getParameter("medicineName");
        String dateStr = request.getParameter("date");
        String status = request.getParameter("status");

        // Áp dụng bộ lọc nếu có
        if ((medicineName != null && !medicineName.trim().isEmpty())
                || (dateStr != null && !dateStr.isEmpty())
                || (status != null && !status.isEmpty() && !"all".equals(status))) {
            requests = filterRequests(requests, medicineName, dateStr, status, dao);
        }

        // --- Lấy items cho mỗi request ---
        Map<Integer, List<MedicationRequestItem>> requestItemsMap = new HashMap<>();
        for (MedicationRequest req : requests) {
            List<MedicationRequestItem> items = dao.getRequestItems(req.getRequestId());
            requestItemsMap.put(req.getRequestId(), items);
        }

        // --- Gửi dữ liệu sang JSP ---
        request.setAttribute("requests", requests);
        request.setAttribute("requestItemsMap", requestItemsMap);
        request.getRequestDispatcher("/jsp/viewRequestHistory.jsp").forward(request, response);
    }

    private List<MedicationRequest> filterRequests(List<MedicationRequest> requests, 
                                                    String medicineName, 
                                                    String dateStr, 
                                                    String status,
                                                    MedicationRequestDAO dao) {
        try {
            String searchName = (medicineName != null && !medicineName.trim().isEmpty())
                    ? medicineName.trim().toLowerCase() : null;
            
            java.util.Date date = (dateStr != null && !dateStr.isEmpty())
                    ? new SimpleDateFormat("yyyy-MM-dd").parse(dateStr) : null;
            
            String searchStatus = (status != null && !status.isEmpty() && !"all".equals(status))
                    ? status : null;

            return requests.stream()
                    .filter(req -> {
                        // Lọc theo tên thuốc
                        boolean matchesMedicine = searchName == null || 
                                hasMedicineByName(req.getRequestId(), searchName, dao);
                        
                        // Lọc theo ngày
                        boolean matchesDate = date == null || 
                                isSameDay((Timestamp) req.getRequestDate(), date);
                        
                        // Lọc theo trạng thái
                        boolean matchesStatus = searchStatus == null || 
                                (req.getStatus() != null && req.getStatus().equalsIgnoreCase(searchStatus));
                        
                        return matchesMedicine && matchesDate && matchesStatus;
                    })
                    .collect(Collectors.toList());
        } catch (ParseException e) {
            System.err.println("Error in filterRequests: " + e.getMessage());
            return requests;
        }
    }

    private boolean hasMedicineByName(int requestId, String medicineName, MedicationRequestDAO dao) {
        try {
            List<MedicationRequestItem> items = dao.getRequestItems(requestId);
            if (items == null || items.isEmpty()) {
                return false;
            }
            
            // Tìm kiếm trong tất cả các thuộc tính của medicine
            return items.stream().anyMatch(item -> {
                if (item.getMedicineName() != null && 
                    item.getMedicineName().toLowerCase().contains(medicineName)) {
                    return true;
                }
                // Có thể thêm tìm kiếm theo các trường khác nếu cần
                return false;
            });
        } catch (Exception e) {
            System.err.println("Error in hasMedicineByName: " + e.getMessage());
            return false;
        }
    }

    private boolean isSameDay(java.sql.Timestamp requestDate, java.util.Date filterDate) {
        if (requestDate == null || filterDate == null) {
            return false;
        }
        java.util.Calendar cal1 = java.util.Calendar.getInstance();
        java.util.Calendar cal2 = java.util.Calendar.getInstance();
        cal1.setTime(requestDate);
        cal2.setTime(filterDate);
        return cal1.get(java.util.Calendar.YEAR) == cal2.get(java.util.Calendar.YEAR)
                && cal1.get(java.util.Calendar.MONTH) == cal2.get(java.util.Calendar.MONTH)
                && cal1.get(java.util.Calendar.DAY_OF_MONTH) == cal2.get(java.util.Calendar.DAY_OF_MONTH);
    }
}