package Controller;

import DAO.BatchDAO;
import DAO.TransactionDAO;
import DAO.DBContext;
import model.Transaction;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import java.util.Map;


public class RecordExpiredDamagedServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try (Connection conn = new DBContext().getConnection()) {

            if (conn == null) {
                throw new ServletException("Không thể kết nối tới database");
            }
            System.out.println("✅ DB Connection OK");

            // Khởi tạo DAO với connection
            BatchDAO batchDAO = new BatchDAO();
            TransactionDAO transactionDAO = new TransactionDAO(conn);

            // Lấy danh sách các lô thuốc còn hàng
            List<Map<String, Object>> batches = batchDAO.getAvailableBatches();
            request.setAttribute("batches", batches);
            System.out.println("✅ Batches size: " + batches.size());

            // Lấy danh sách giao dịch hết hạn / hư hỏng
            List<Transaction> transactions = transactionDAO.getExpiredOrDamaged();
            request.setAttribute("transactions", transactions);
            System.out.println("✅ Transactions size: " + transactions.size());

            // Forward sang JSP
            request.getRequestDispatcher("/pharmacist/recordExpiredDamaged.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace(); // in đầy đủ stacktrace
            throw new ServletException("Lỗi khi tải danh sách lô thuốc và giao dịch", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try (Connection conn = new DBContext().getConnection()) {

            if (conn == null) {
                throw new ServletException("Không thể kết nối database");
            }

            // Lấy user đăng nhập
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            // Lấy dữ liệu từ form
            int userId = currentUser.getUserId();
            int batchId = Integer.parseInt(request.getParameter("batchId"));
            String type = request.getParameter("type"); // "Expired" hoặc "Damaged"
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String notes = request.getParameter("notes");

            // Tạo Transaction
            Transaction t = new Transaction();
            t.setBatchId(batchId);
            t.setUserId(userId);
            t.setType(type);
            t.setQuantity(quantity);
            t.setNotes(notes);

            // Ghi vào DB
            TransactionDAO transactionDAO = new TransactionDAO(conn);
            transactionDAO.addTransaction(t);

            // Redirect về lại trang hiển thị
            response.sendRedirect(request.getContextPath() + "/pharmacist/recordExpiredDamaged");

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Lỗi khi ghi nhận giao dịch thuốc hết hạn/hư hỏng", e);
        }
    }
}
