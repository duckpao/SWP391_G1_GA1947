package filter;

import Model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length());
        System.out.println("[AuthFilter] Request path: " + path);

        // ❌ Chặn truy cập trực tiếp JSP (ngoại trừ login.jsp)
        if (path.endsWith(".jsp") && !path.equals("/login.jsp")) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // ✅ Bỏ qua login và static resources
        if (path.equals("/login") || path.equals("/login.jsp")
                || path.startsWith("/css/") || path.startsWith("/js/") || path.startsWith("/images/")) {
            chain.doFilter(request, response);
            return;
        }

        // ✅ Kiểm tra session
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // ✅ Kiểm tra quyền theo role
        String role = user.getRole().toLowerCase();

        boolean allowed =
        (role.equals("admin") && (path.startsWith("/admin/") || path.equals("/Dashboard")))
     || (role.equals("manager") && (path.startsWith("/manager/") || path.equals("/Dashboard")))
     || (role.equals("auditor") && (path.startsWith("/auditor/") || path.equals("/Dashboard")))
     || (role.equals("doctor") && (path.startsWith("/doctor/") || path.startsWith("/Medicine/") || path.equals("/Dashboard")))
     || (role.equals("pharmacist") 
    && (path.startsWith("/pharmacist/") 
    || path.startsWith("/Medicine")   // ✅ cho cả /Medicine và /Medicine/...
    || path.equals("/Dashboard")))

     || (role.equals("supplier") && (path.startsWith("/supplier/") || path.equals("/Dashboard")));


        if (allowed) {
            System.out.println("[AuthFilter] ✅ ALLOWED: role=" + role + " path=" + path);
            chain.doFilter(request, response);
        } else {
            System.out.println("[AuthFilter] ❌ DENIED: role=" + role + " path=" + path);
            res.sendRedirect(req.getContextPath() + "/login");
        }
    }
}
