/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.UserDAO;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.User;

/**
 *
 * @author ADMIN
 */
public class GetUserListServlet extends HttpServlet {

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
            out.println("<title>Servlet GetUserListServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet GetUserListServlet at " + request.getContextPath() + "</h1>");
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
        // Prevent caching
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        try {
            // Lấy current user từ session
            User currentUser = (User) request.getSession().getAttribute("user");
            int currentUserId = (currentUser != null) ? currentUser.getUserId() : -1;

            System.out.println("=== GetUserListServlet ===");
            System.out.println("Current User ID: " + currentUserId);

            // Lấy danh sách tất cả users
            List<User> users = UserDAO.getAllUsers();
            System.out.println("Total users from DB: " + users.size());

            // Chuyển đổi sang JSON
            JsonArray jsonArray = new JsonArray();

            for (User user : users) {
                // Bỏ qua current user
                if (user.getUserId() == currentUserId) {
                    System.out.println("Skipping current user: " + user.getUsername());
                    continue;
                }

                System.out.println("Adding user: " + user.getUserId() + " - " + user.getUsername());

                JsonObject userJson = new JsonObject();
                userJson.addProperty("user_id", user.getUserId());
                userJson.addProperty("username", user.getUsername());
                userJson.addProperty("email", user.getEmail());
                userJson.addProperty("phone", user.getPhone());
                userJson.addProperty("role", user.getRole());
                userJson.addProperty("is_active", user.getIsActive());

                jsonArray.add(userJson);
            }

            System.out.println("Total users in JSON: " + jsonArray.size());
            System.out.println("JSON Response: " + jsonArray.toString());

            out.print(jsonArray.toString());

        } catch (Exception e) {
            e.printStackTrace();

            JsonObject error = new JsonObject();
            error.addProperty("error", "Failed to load users");
            error.addProperty("message", e.getMessage());

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(error.toString());
        } finally {
            out.flush();
        }
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
        doGet(request, response);
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
