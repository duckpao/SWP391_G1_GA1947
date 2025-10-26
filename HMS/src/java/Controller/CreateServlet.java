package Controller;

import DAO.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import model.User;
import util.PasswordUtils;
import util.LoggingUtil;

/**
 * Servlet for creating new users with full logging support
 */
public class CreateServlet extends HttpServlet {
    
    private final UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Log page view
        LoggingUtil.logView(request, "Create User Form");
        
        // Forward to create form
        request.getRequestDispatcher("/admin/user_form_create.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");
        
        try {
            // Validate input
            if (username == null || username.trim().isEmpty()) {
                request.setAttribute("error", "Tên đăng nhập không được để trống!");
                request.getRequestDispatcher("/admin/user_form_create.jsp").forward(request, response);
                return;
            }
            
            if (password == null || password.length() < 6) {
                request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự!");
                request.getRequestDispatcher("/admin/user_form_create.jsp").forward(request, response);
                return;
            }
            
            // Check if username already exists
            User existingUser = userDAO.findByUsername(username);
            if (existingUser != null) {
                request.setAttribute("error", "Tên đăng nhập đã tồn tại!");
                request.getRequestDispatcher("/admin/user_form_create.jsp").forward(request, response);
                return;
            }
            
            // Hash password
            String hashedPassword = PasswordUtils.hash(password);
            
            // Create new user object
            User newUser = new User(username, hashedPassword, email, phone, role);
            
            // Insert into database
            userDAO.create(newUser);
            
            // Log successful creation with details
            String details = String.format(
                "Created new user: %s | Role: %s | Email: %s | Phone: %s",
                username, role, email != null ? email : "N/A", phone != null ? phone : "N/A"
            );
            LoggingUtil.logUserCreate(request, username);
            LoggingUtil.logAction(request, "CREATE_USER_DETAIL", details);
            
            // Redirect with success message
            response.sendRedirect(request.getContextPath() + "/admin-dashboard?success=created&user=" + username);
            
        } catch (SQLException e) {
            e.printStackTrace();
            
            // Log error
            String errorDetails = String.format(
                "Failed to create user: %s | Error: %s",
                username, e.getMessage()
            );
            LoggingUtil.logAction(request, "CREATE_USER_FAILED", errorDetails);
            
            request.setAttribute("error", "Lỗi khi tạo người dùng: " + e.getMessage());
            request.getRequestDispatcher("/admin/user_form_create.jsp").forward(request, response);
        }
    }
    
    @Override
    public String getServletInfo() {
        return "Create User Servlet with Logging Support";
    }
}