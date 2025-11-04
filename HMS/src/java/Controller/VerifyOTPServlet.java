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
import model.User;
import util.PasswordUtils;

/**
 *
 * @author ADMIN
 */
public class VerifyOTPServlet extends HttpServlet {

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
            out.println("<title>Servlet VerifyOTPServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet VerifyOTPServlet at " + request.getContextPath() + "</h1>");
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
        HttpSession session = request.getSession();
        String enteredOtp = request.getParameter("otp");
        Object otpObj = session.getAttribute("otp");

        if (otpObj == null) {
            request.setAttribute("error", "Phiên xác nhận đã hết hạn. Vui lòng đăng ký lại.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        int realOtp = (int) otpObj;

        if (String.valueOf(realOtp).equals(enteredOtp)) {
            String username = (String) session.getAttribute("username");
            String email = (String) session.getAttribute("email");
            String phone = (String) session.getAttribute("phone");
            String password = (String) session.getAttribute("password");

            String hashedPassword = PasswordUtils.hash(password);
            User newUser = new User(0, username, email, phone, hashedPassword, "Pharmacist");

            UserDAO dao = new UserDAO();
            boolean ok = dao.register(newUser);

            if (ok) {
                request.setAttribute("message", "Đăng ký thành công! Bây giờ bạn có thể đăng nhập.");
            } else {
                request.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại.");
            }

            // Xóa session sau khi xác nhận
            session.invalidate();
            request.getRequestDispatcher("register.jsp").forward(request, response);

        } else {
            request.setAttribute("error", "Mã OTP không chính xác!");
            request.getRequestDispatcher("verify_otp.jsp").forward(request, response);
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
