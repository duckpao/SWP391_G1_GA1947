package controller;

import DAO.UserDAO;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import Model.User;
import jakarta.servlet.annotation.WebServlet;

public class LoginServlet extends HttpServlet {

    private Connection getConnection() throws Exception {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(
                "jdbc:sqlserver://localhost:1433;databaseName=hwms;encrypt=true;trustServerCertificate=true",
                "sa", "123"
        );
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward tới login.jsp khi GET
request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try (Connection conn = getConnection()) {
            UserDAO userDAO = new UserDAO(conn);
            User user = userDAO.login(username, password);

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);

                // Redirect dashboard theo role
                String role = user.getRole().toLowerCase();
            switch (role) {
    case "admin":
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        break;
    case "manager":
        response.sendRedirect(request.getContextPath() + "/manager/dashboard");
        break;
    case "auditor":
        response.sendRedirect(request.getContextPath() + "/auditor/dashboard");
        break;
    case "doctor":
        response.sendRedirect(request.getContextPath() + "/doctor/dashboard");
        break;
    case "pharmacist":
        response.sendRedirect(request.getContextPath() + "/pharmacist/dashboard");
        break;
    case "supplier":
        response.sendRedirect(request.getContextPath() + "/supplier/dashboard");
        break;
    default:
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Role không hợp lệ");
}

            } else {
                request.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu");
               request.getRequestDispatcher("/login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
