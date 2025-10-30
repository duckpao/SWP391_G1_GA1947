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
import java.util.Random;
import util.EmailSender;

/**
 *
 * @author ADMIN
 */
public class ForgotPasswordServlet extends HttpServlet {

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
            out.println("<title>Servlet ForgotPasswordServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ForgotPasswordServlet at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("forgot-password.jsp").forward(request, response);

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
        String emailOrPhone = request.getParameter("emailOrPhone");
        UserDAO dao = new UserDAO();

        // Kiểm tra có tồn tại user không
        if (!dao.checkUserExists(emailOrPhone)) {
            request.setAttribute("error", "Tài khoản không tồn tại trong hệ thống!");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }

        // Sinh mã OTP ngẫu nhiên 6 chữ số
        String otp = String.format("%06d", new Random().nextInt(999999));

        try {
            // Send OTP via email
            String subject = "Password Reset Verification Code - Hospital Inventory Management System";
            String plainMessage = "Your Verification Code\n\n"
                    + "Hello,\n\n"
                    + "You have requested to reset your password. Your OTP code is:\n\n"
                    + otp + "\n\n"
                    + "This code is valid for only 5 minutes. If you did not request this, please ignore this email.\n\n"
                    + "---\n"
                    + "© 2025 Hospital Inventory Management System";

            // Gửi OTP qua email
            EmailSender.sendEmail(emailOrPhone, subject, plainMessage);

            // Lưu OTP & email vào session (thời hạn 5 phút)
            HttpSession session = request.getSession();
            session.setAttribute("resetOTP", otp);
            session.setAttribute("emailOrPhone", emailOrPhone);
            session.setMaxInactiveInterval(300);

            // Chuyển tới trang xác nhận OTP
            response.sendRedirect("verifyReset.jsp");  // Chuyển hướng đúng tới trang verify-reset.jsp
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể gửi OTP. Vui lòng thử lại sau!");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
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
