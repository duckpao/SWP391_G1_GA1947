package Controller;

import com.google.gson.Gson;
import DAO.MessageDAO;
import DAO.UserDAO;
import model.Message;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ChatControllerServlet extends HttpServlet {
    
    private MessageDAO messageDAO;
    private UserDAO userDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        this.messageDAO = new MessageDAO();
        this.userDAO = new UserDAO();
        this.gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        // Check session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (action == null) {
            // Show chat page
            request.getRequestDispatcher("/chat.jsp").forward(request, response);
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        switch (action) {
            case "getUserList":
                handleGetUserList(request, response);
                break;
            case "getChatHistory":
                handleGetChatHistory(request, response);
                break;
            case "getUnreadCount":
                handleGetUnreadCount(request, response);
                break;
            case "markAsRead":
                handleMarkAsRead(request, response);
                break;
            case "getConversations":
                handleGetConversations(request, response);
                break;
            default:
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Invalid action\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        // Check session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"Unauthorized\"}");
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (action == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Missing action parameter\"}");
            return;
        }

        switch (action) {
            case "sendMessage":
                handleSendMessage(request, response);
                break;
            default:
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Invalid action\"}");
        }
    }

    private void handleGetUserList(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            List<User> users = UserDAO.getAllUsers();
            response.getWriter().write(gson.toJson(users));
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Failed to load users\"}");
        }
    }

    private void handleGetChatHistory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int userId1 = Integer.parseInt(request.getParameter("userId1"));
            int userId2 = Integer.parseInt(request.getParameter("userId2"));
            int limit = request.getParameter("limit") != null ? 
                       Integer.parseInt(request.getParameter("limit")) : 50;

            List<Message> messages = messageDAO.getMessagesBetweenUsers(userId1, userId2, limit);
            response.getWriter().write(gson.toJson(messages));
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Invalid user ID or limit\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Failed to load messages\"}");
        }
    }

    private void handleGetUnreadCount(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            int count = messageDAO.getUnreadCount(userId);
            response.getWriter().write("{\"count\":" + count + "}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Failed to get unread count\"}");
        }
    }

    private void handleMarkAsRead(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int messageId = Integer.parseInt(request.getParameter("messageId"));
            boolean success = messageDAO.markAsRead(messageId);
            response.getWriter().write("{\"success\":" + success + "}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Failed to mark as read\"}");
        }
    }

    private void handleGetConversations(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            List<Message> conversations = messageDAO.getRecentConversations(userId);
            response.getWriter().write(gson.toJson(conversations));
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Failed to load conversations\"}");
        }
    }

    private void handleSendMessage(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int senderId = Integer.parseInt(request.getParameter("senderId"));
            int receiverId = Integer.parseInt(request.getParameter("receiverId"));
            String content = request.getParameter("content");
            String type = request.getParameter("type") != null ? 
                         request.getParameter("type") : "text";

            Message message = new Message(senderId, receiverId, content, type);
            boolean success = messageDAO.insertMessage(message);

            if (success) {
                response.getWriter().write("{\"success\":true,\"message\":\"Message sent\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"success\":false,\"error\":\"Failed to send message\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}