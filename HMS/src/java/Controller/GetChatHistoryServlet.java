/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import DAO.MessageDAO;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Message;

/**
 *
 * @author ADMIN
 */
public class GetChatHistoryServlet extends HttpServlet {

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
            out.println("<title>Servlet GetChatHistoryServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet GetChatHistoryServlet at " + request.getContextPath() + "</h1>");
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
    
    MessageDAO messageDAO = new MessageDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        try {
            // Lấy parameters
            String userId1Str = request.getParameter("userId1");
            String userId2Str = request.getParameter("userId2");
            String limitStr = request.getParameter("limit");

            if (userId1Str == null || userId2Str == null) {
                sendError(response, out, "Missing required parameters: userId1 and userId2");
                return;
            }

            int userId1 = Integer.parseInt(userId1Str);
            int userId2 = Integer.parseInt(userId2Str);
            int limit = (limitStr != null) ? Integer.parseInt(limitStr) : 50;

            System.out.println("=== GetChatHistoryServlet ===");
            System.out.println("User1: " + userId1 + ", User2: " + userId2 + ", Limit: " + limit);

            // Lấy lịch sử chat từ database
            List<Message> messages = messageDAO.getMessagesBetweenUsers(userId1, userId2, limit);
            System.out.println("Total messages found: " + messages.size());

            // Chuyển đổi sang JSON
            JsonArray jsonArray = new JsonArray();

            for (Message msg : messages) {
                JsonObject msgJson = new JsonObject();
                msgJson.addProperty("messageId", msg.getMessageId());
                msgJson.addProperty("senderId", msg.getSenderId());
                msgJson.addProperty("receiverId", msg.getReceiverId());
                msgJson.addProperty("messageContent", msg.getMessageContent());
                msgJson.addProperty("messageType", msg.getMessageType());
                msgJson.addProperty("sentAt", msg.getSentAt().getTime());
                msgJson.addProperty("isRead", msg.isRead());

                jsonArray.add(msgJson);
            }

            out.print(jsonArray.toString());

        } catch (NumberFormatException e) {
            e.printStackTrace();
            sendError(response, out, "Invalid parameter format");
        } catch (Exception e) {
            e.printStackTrace();
            sendError(response, out, "Failed to load chat history: " + e.getMessage());
        } finally {
            out.flush();
        }
    }

    private void sendError(HttpServletResponse response, PrintWriter out, String errorMessage) {
        JsonObject error = new JsonObject();
        error.addProperty("error", errorMessage);

        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        out.print(error.toString());
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
        processRequest(request, response);
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
