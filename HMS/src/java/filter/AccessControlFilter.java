package filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")  // Lọc tất cả request
public class AccessControlFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Không cần khởi tạo gì đặc biệt
    }

    @Override
    public void doFilter(jakarta.servlet.ServletRequest req,
                         jakarta.servlet.ServletResponse res,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String path = request.getServletPath();
        HttpSession session = request.getSession(false);

        // 1️⃣ Nếu chưa đăng nhập, chặn tất cả trừ login, register, forgot-password
        if (session == null || session.getAttribute("role") == null) {
            if (!path.equals("/login")
                    && !path.equals("/register")
                    && !path.equals("/forgot-password")
                    && !path.equals("/reset-password")) {
                response.sendRedirect("login");
                return;
            }
            chain.doFilter(req, res);
            return;
        }

        String role = (String) session.getAttribute("role");

        // 2️⃣ ADMIN – được vào mọi chỗ trừ phần supplier
        if ("Admin".equals(role)) {
            if (path.contains("supplier")) {
                response.sendRedirect("home");
                return;
            }

            // Gán tạm role để vượt qua servlet check riêng của từng role
            if (path.contains("doctor")) session.setAttribute("role", "Doctor");
            else if (path.contains("pharmacist")) session.setAttribute("role", "Pharmacist");
            else if (path.contains("manager")) session.setAttribute("role", "Manager");
            else if (path.contains("auditor")) session.setAttribute("role", "Auditor");

            chain.doFilter(req, res);
            return;
        }

        // 3️⃣ SUPPLIER – chỉ được ở khu supplier
        if ("Supplier".equals(role)) {
            if (!path.contains("supplier")) {
                response.sendRedirect("supplierDashboard");
                return;
            }
        }

        // 4️⃣ Các role khác đi bình thường
        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {
        // Không cần cleanup gì
    }
}