package Controller;
import DAO.UserDAO;
import model.User;
import model.Supplier;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@WebServlet(name = "EditProfileServlet", urlPatterns = {"/edit-profile"})
public class EditProfileServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
       
        // Kiểm tra đăng nhập
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
       
        User loggedUser = (User) session.getAttribute("user");
        if ("Supplier".equalsIgnoreCase(loggedUser.getRole())) {
            UserDAO dao = new UserDAO();
            try {
                Supplier supplier = dao.getSupplierByUserId(loggedUser.getUserId());
                request.setAttribute("supplier", supplier);
            } catch (Exception e) {
                e.printStackTrace();
                // Xử lý lỗi nếu cần
            }
        }
       
        // Hiển thị trang chỉnh sửa
        request.getRequestDispatcher("editProfile.jsp").forward(request, response);
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
        String newUsername = request.getParameter("username");
        String newPhone = request.getParameter("phone");
        String companyName = null;
        String address = null;
        if ("Supplier".equalsIgnoreCase(loggedUser.getRole())) {
            companyName = request.getParameter("companyName");
            address = request.getParameter("address");
        }
        // Validate input
        if (newUsername == null || newUsername.trim().isEmpty()) {
            request.setAttribute("error", "Tên đăng nhập không được để trống!");
            request.getRequestDispatcher("editProfile.jsp").forward(request, response);
            return;
        }
        if (newPhone == null || newPhone.trim().isEmpty()) {
            request.setAttribute("error", "Số điện thoại không được để trống!");
            request.getRequestDispatcher("editProfile.jsp").forward(request, response);
            return;
        }
        // Validate phone number format (10-11 digits)
        if (!newPhone.matches("^[0-9]{10,11}$")) {
            request.setAttribute("error", "Số điện thoại phải có 10-11 chữ số!");
            request.getRequestDispatcher("editProfile.jsp").forward(request, response);
            return;
        }
        if ("Supplier".equalsIgnoreCase(loggedUser.getRole())) {
            if (companyName == null || companyName.trim().isEmpty()) {
                request.setAttribute("error", "Tên công ty không được để trống!");
                request.getRequestDispatcher("editProfile.jsp").forward(request, response);
                return;
            }
        }
        try {
            UserDAO dao = new UserDAO();
           
            // Kiểm tra xem số điện thoại mới đã được sử dụng bởi user khác chưa
            User existingUser = dao.findByPhone(newPhone);
            if (existingUser != null && existingUser.getUserId() != loggedUser.getUserId()) {
                request.setAttribute("error", "Số điện thoại này đã được sử dụng!");
                request.getRequestDispatcher("editProfile.jsp").forward(request, response);
                return;
            }
           
            // Kiểm tra xem username mới đã được sử dụng bởi user khác chưa
            User existingUsername = dao.findByUsername(newUsername);
            if (existingUsername != null && existingUsername.getUserId() != loggedUser.getUserId()) {
                request.setAttribute("error", "Tên đăng nhập này đã được sử dụng!");
                request.getRequestDispatcher("editProfile.jsp").forward(request, response);
                return;
            }
           
            // Cập nhật thông tin Users
            loggedUser.setUsername(newUsername);
            loggedUser.setPhone(newPhone);
           
            boolean success = dao.updateProfile(loggedUser.getUserId(), newUsername, newPhone);
           
            if (success && "Supplier".equalsIgnoreCase(loggedUser.getRole())) {
                // Cập nhật thông tin Suppliers (bao gồm sync contact_phone)
                success = dao.updateSupplierProfile(loggedUser.getUserId(), companyName, address, newPhone);
            }
           
            if (success) {
                // Cập nhật session
                session.setAttribute("user", loggedUser);
               
                // Set success message và redirect về profile
                session.setAttribute("successMessage", "Cập nhật thông tin thành công!");
                response.sendRedirect("profile");
            } else {
                request.setAttribute("error", "Cập nhật thông tin thất bại! Vui lòng thử lại.");
                request.getRequestDispatcher("editProfile.jsp").forward(request, response);
            }
           
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("editProfile.jsp").forward(request, response);
        }
    }
    @Override
    public String getServletInfo() {
        return "Edit Profile Servlet";
    }
}