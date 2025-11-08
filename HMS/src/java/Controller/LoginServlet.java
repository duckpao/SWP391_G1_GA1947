package Controller;

import DAO.UserDAO;
import DAO.SupplierDAO;
import DAO.SystemConfigDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import model.User;
import util.PasswordUtils;
import util.LoggingUtil;
import util.CaptchaUtil;

public class LoginServlet extends HttpServlet {

    private static final long CAPTCHA_TIMEOUT = 5 * 60 * 1000; // 5 phút
    
    /**
     * Lấy số lần đăng nhập tối đa từ database
     */
    private int getMaxFailedAttempts() {
        SystemConfigDAO configDAO = new SystemConfigDAO();
        return configDAO.getConfigValueAsInt("max_failed_attempts", 5); // Default = 5
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Lấy số lần đăng nhập sai từ session
        Integer failedAttempts = (Integer) session.getAttribute("loginFailedAttempts");
        if (failedAttempts == null) {
            failedAttempts = 0;
            session.setAttribute("loginFailedAttempts", 0);
        }
        
        // ✅ Đọc max_failed_attempts từ database
        int maxAttempts = getMaxFailedAttempts();
        
        // Kiểm tra xem có cần CAPTCHA không
        boolean needCaptcha = failedAttempts >= maxAttempts;
        request.setAttribute("needCaptcha", needCaptcha);
        
        // Generate CAPTCHA nếu cần
        if (needCaptcha) {
            String[] captcha = CaptchaUtil.generateMathCaptcha();
            String question = captcha[0];
            String answer = captcha[1];
            
            session.setAttribute("captchaAnswer", answer);
            session.setAttribute("captchaGenTime", System.currentTimeMillis());
            
            String base64Image = CaptchaUtil.generateCaptchaImage(question);
            request.setAttribute("captchaImage", "data:image/png;base64," + base64Image);
        }
        
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String emailOrUsername = request.getParameter("emailOrUsername");
        String password = request.getParameter("password");
        
        HttpSession session = request.getSession();
        
        // Lấy số lần thất bại từ session
        Integer failedAttempts = (Integer) session.getAttribute("loginFailedAttempts");
        if (failedAttempts == null) {
            failedAttempts = 0;
        }
        
        // ✅ Đọc max_failed_attempts từ database
        int maxAttempts = getMaxFailedAttempts();
        boolean needCaptcha = failedAttempts >= maxAttempts;
        
        // ✅ KIỂM TRA CAPTCHA (nếu cần)
        if (needCaptcha) {
            String userCaptcha = request.getParameter("captcha");
            String correctAnswer = (String) session.getAttribute("captchaAnswer");
            Long captchaGenTime = (Long) session.getAttribute("captchaGenTime");
            
            // Kiểm tra CAPTCHA timeout
            if (captchaGenTime == null || (System.currentTimeMillis() - captchaGenTime) > CAPTCHA_TIMEOUT) {
                request.setAttribute("error", "CAPTCHA đã hết hạn. Vui lòng thử lại!");
                request.setAttribute("needCaptcha", true);
                
                // Generate CAPTCHA mới
                String[] newCaptcha = CaptchaUtil.generateMathCaptcha();
                session.setAttribute("captchaAnswer", newCaptcha[1]);
                session.setAttribute("captchaGenTime", System.currentTimeMillis());
                String base64Image = CaptchaUtil.generateCaptchaImage(newCaptcha[0]);
                request.setAttribute("captchaImage", "data:image/png;base64," + base64Image);
                
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
            
            // Verify CAPTCHA
            if (!CaptchaUtil.verifyCaptcha(userCaptcha, correctAnswer)) {
                request.setAttribute("error", "CAPTCHA sai! Vui lòng thử lại.");
                request.setAttribute("needCaptcha", true);
                
                // Generate CAPTCHA mới
                String[] newCaptcha = CaptchaUtil.generateMathCaptcha();
                session.setAttribute("captchaAnswer", newCaptcha[1]);
                session.setAttribute("captchaGenTime", System.currentTimeMillis());
                String base64Image = CaptchaUtil.generateCaptchaImage(newCaptcha[0]);
                request.setAttribute("captchaImage", "data:image/png;base64," + base64Image);
                
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
        }

        UserDAO userDAO = new UserDAO();

        try {
            User user = userDAO.findByEmailOrUsername(emailOrUsername);

            if (user == null) {
                // ❌ LOGIN THẤT BẠI - Không tìm thấy user
                failedAttempts++;
                session.setAttribute("loginFailedAttempts", failedAttempts);
                
                LoggingUtil.logFailedLogin(request, emailOrUsername);
                
                request.setAttribute("error", "Sai email/username hoặc mật khẩu!");
                request.setAttribute("needCaptcha", failedAttempts >= maxAttempts);
                
                // Generate CAPTCHA nếu cần
                if (failedAttempts >= maxAttempts) {
                    String[] newCaptcha = CaptchaUtil.generateMathCaptcha();
                    session.setAttribute("captchaAnswer", newCaptcha[1]);
                    session.setAttribute("captchaGenTime", System.currentTimeMillis());
                    String base64Image = CaptchaUtil.generateCaptchaImage(newCaptcha[0]);
                    request.setAttribute("captchaImage", "data:image/png;base64," + base64Image);
                }
                
                request.getRequestDispatcher("login.jsp").forward(request, response);
                
            } else if (!user.isActive()) {
                // ❌ TÀI KHOẢN BỊ KHÓA
                LoggingUtil.logFailedLogin(request, emailOrUsername);
                request.setAttribute("error", "Tài khoản của bạn đã bị khóa do vi phạm chính sách.");
                request.setAttribute("needCaptcha", failedAttempts >= maxAttempts);
                
                if (failedAttempts >= maxAttempts) {
                    String[] newCaptcha = CaptchaUtil.generateMathCaptcha();
                    session.setAttribute("captchaAnswer", newCaptcha[1]);
                    session.setAttribute("captchaGenTime", System.currentTimeMillis());
                    String base64Image = CaptchaUtil.generateCaptchaImage(newCaptcha[0]);
                    request.setAttribute("captchaImage", "data:image/png;base64," + base64Image);
                }
                
                request.getRequestDispatcher("login.jsp").forward(request, response);
                
            } else if (!PasswordUtils.verify(password, user.getPasswordHash())) {
                // ❌ LOGIN THẤT BẠI - Sai mật khẩu
                failedAttempts++;
                session.setAttribute("loginFailedAttempts", failedAttempts);
                
                LoggingUtil.logFailedLogin(request, emailOrUsername);
                
                request.setAttribute("error", "Sai email/username hoặc mật khẩu!");
                request.setAttribute("needCaptcha", failedAttempts >= maxAttempts);
                
                // Generate CAPTCHA nếu cần
                if (failedAttempts >= maxAttempts) {
                    String[] newCaptcha = CaptchaUtil.generateMathCaptcha();
                    session.setAttribute("captchaAnswer", newCaptcha[1]);
                    session.setAttribute("captchaGenTime", System.currentTimeMillis());
                    String base64Image = CaptchaUtil.generateCaptchaImage(newCaptcha[0]);
                    request.setAttribute("captchaImage", "data:image/png;base64," + base64Image);
                }
                
                request.getRequestDispatcher("login.jsp").forward(request, response);
                
            } else {
                // ✅ LOGIN THÀNH CÔNG
                
                // Reset failed attempts
                session.setAttribute("loginFailedAttempts", 0);
                session.removeAttribute("captchaAnswer");
                session.removeAttribute("captchaGenTime");
                
                UserDAO.updateLastLogin(user.getUserId());
                
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("role", user.getRole());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("user", user);

                // 🔹 GHI LOG LOGIN THÀNH CÔNG
                LoggingUtil.logLogin(request, user);

                String role = user.getRole();

                switch (role) {
                    case "Doctor":
                        response.sendRedirect(request.getContextPath() + "/doctor-dashboard");
                        break;
                    case "Pharmacist":
                        response.sendRedirect(request.getContextPath() + "/view-medicine");
                        break;
                    case "Manager":
                        response.sendRedirect(request.getContextPath() + "/manager-dashboard");
                        break;
                    case "Admin":
                        response.sendRedirect(request.getContextPath() + "/admin-dashboard");
                        break;
                    case "Supplier":
                        response.sendRedirect(request.getContextPath() + "/supplier-dashboard");
                        break;
                    case "Auditor":
                        response.sendRedirect(request.getContextPath() + "/auditor-dashboard");
                        break;
                    default:
                        response.sendRedirect(request.getContextPath() + "/home.jsp");
                        break;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();

            // 🔹 GHI LOG LỖI HỆ THỐNG
            String ipAddress = LoggingUtil.getClientIP(request);
            System.err.println("Login error for: " + emailOrUsername + " from IP: " + ipAddress);

            request.setAttribute("error", "Đã xảy ra lỗi khi đăng nhập!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý đăng nhập với CAPTCHA protection";
    }
}