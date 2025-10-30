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

@WebServlet(name = "ProfileServlet", urlPatterns = {"/profile"})
public class ProfileServlet extends HttpServlet {
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        // Kiểm tra đăng nhập
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            User currentUser = (User) session.getAttribute("user");
            int userId = currentUser.getUserId();
            
            // Lấy thông tin user từ database để đảm bảo dữ liệu mới nhất
            User user = userDAO.findById(userId);
            
            if (user == null) {
                request.setAttribute("error", "Không tìm thấy thông tin người dùng!");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }
            
            // Nếu user là Supplier, lấy thông tin supplier
            if ("Supplier".equalsIgnoreCase(user.getRole())) {
                Supplier supplier = userDAO.getSupplierByUserId(userId);
                request.setAttribute("supplier", supplier);
            }
            
            // Kiểm tra và hiển thị thông báo thành công (nếu có)
            String successMessage = (String) session.getAttribute("successMessage");
            if (successMessage != null) {
                request.setAttribute("message", successMessage);
                session.removeAttribute("successMessage"); // Xóa sau khi hiển thị
            }
            
            // Cập nhật session với thông tin mới nhất
            session.setAttribute("user", user);
            request.setAttribute("user", user);
            
            // Chuyển đến trang profile
            request.getRequestDispatcher("userProfile.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi khi tải thông tin người dùng: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    @Override
    public String getServletInfo() {
        return "Profile Servlet - Display user profile information";
    }
}