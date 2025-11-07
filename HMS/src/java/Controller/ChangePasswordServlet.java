package Controller;

import DAO.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiểm tra đăng nhập
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Hiển thị trang đổi mật khẩu
        request.getRequestDispatcher("change-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User loggedUser = (User) session.getAttribute("user");

        // Kiểm tra đăng nhập
        if (loggedUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate input
        if (currentPassword == null || currentPassword.trim().isEmpty() ||
            newPassword == null || newPassword.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }

        // Kiểm tra độ dài mật khẩu mới
        if (newPassword.length() < 6) {
            request.setAttribute("error", "Mật khẩu mới phải có ít nhất 6 ký tự!");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }

        // Kiểm tra mật khẩu mới và xác nhận có khớp không
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu mới và xác nhận không khớp!");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }

        // Kiểm tra mật khẩu hiện tại có đúng không (dùng BCrypt.checkpw)
        if (!BCrypt.checkpw(currentPassword, loggedUser.getPasswordHash())) {
            request.setAttribute("error", "Mật khẩu hiện tại không đúng!");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }

        // Kiểm tra mật khẩu mới có giống mật khẩu cũ không
        if (currentPassword.equals(newPassword)) {
            request.setAttribute("error", "Mật khẩu mới phải khác mật khẩu hiện tại!");
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
            return;
        }

        try {
            UserDAO dao = new UserDAO();
            
            // Hash mật khẩu mới
            String hashedNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));
            
            // Cập nhật vào database
            boolean success = dao.updatePassword(loggedUser.getEmail(), hashedNewPassword);
            
            if (success) {
                // Cập nhật session với mật khẩu đã hash
                loggedUser.setPasswordHash(hashedNewPassword);
                session.setAttribute("user", loggedUser);
                
                // Set success message trong session
                session.setAttribute("successMessage", "Đổi mật khẩu thành công!");
                
                // Redirect về trang profile
                response.sendRedirect("profile");
                return;
            } else {
                request.setAttribute("error", "Đổi mật khẩu thất bại! Vui lòng thử lại.");
                request.getRequestDispatcher("change-password.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("change-password.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Change Password Servlet with BCrypt hashing";
    }
}