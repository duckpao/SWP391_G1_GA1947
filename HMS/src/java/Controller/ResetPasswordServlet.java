/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import util.PasswordUtils;

/**
 *
 * @author ADMIN
 */
public class ResetPasswordServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ResetPasswordServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ResetPasswordServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy dữ liệu từ form
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Kiểm tra nhập lại mật khẩu
        if (newPassword == null || confirmPassword == null || !newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu nhập lại không khớp!");
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            return;
        }

        // Lấy email hoặc phone từ session (được lưu sau khi xác minh OTP)
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("emailOrPhone") == null) {
            response.sendRedirect("forgot-password.jsp");
            return;
        }

        String emailOrPhone = (String) session.getAttribute("emailOrPhone");

        // Hash mật khẩu mới trước khi lưu
        String hashedPassword = PasswordUtils.hash(newPassword);

        // Cập nhật mật khẩu trong DB
        UserDAO dao = new UserDAO();
        boolean ok = dao.updatePasswordByEmailOrPhone(hashedPassword, emailOrPhone);

        if (ok) {
            // Xóa session để tránh reuse OTP
            session.removeAttribute("resetOTP");
            session.removeAttribute("emailOrPhone");

            // Chuyển hướng đến trang login với thông báo thành công
            request.setAttribute("message", "Đặt lại mật khẩu thành công! Vui lòng đăng nhập lại.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Không thể cập nhật mật khẩu. Vui lòng thử lại.");
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
