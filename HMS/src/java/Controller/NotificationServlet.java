package Controller;

import DAO.NotificationDAO;
import model.Notification;
import model.User;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class NotificationServlet extends HttpServlet {

    private NotificationDAO notificationDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        notificationDAO = new NotificationDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        System.out.println("doGet - action: " + action);
        
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list":
                showNotifications(request, response, currentUser);
                break;
            case "getUnreadCount":
                getUnreadCount(response, currentUser);
                break;
            case "getLatest":
                getLatestNotifications(request, response, currentUser);
                break;
            default:
                showNotifications(request, response, currentUser);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // CRITICAL: Set encoding BEFORE reading ANY parameters
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        System.out.println("\n========================================");
        System.out.println("=== doPost called ===");
        System.out.println("========================================");

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            System.out.println("❌ ERROR: No user in session");
            sendJsonResponse(response, false, "Unauthorized");
            return;
        }

        System.out.println("✓ User: " + currentUser.getUsername() + " (Role: " + currentUser.getRole() + ")");

        // Get action parameter
        String action = request.getParameter("action");
        System.out.println("✓ Action: '" + action + "'");

        if (action == null || action.trim().isEmpty()) {
            System.out.println("❌ ERROR: Action is null or empty");
            sendJsonResponse(response, false, "Missing action parameter");
            return;
        }

        // Handle different actions
        switch (action) {
            case "send":
                System.out.println("→ Calling sendNotification()");
                sendNotification(request, response, currentUser);
                break;
                
            case "markAsRead":
                System.out.println("→ Calling markNotificationAsRead()");
                markNotificationAsRead(request, response, currentUser);
                break;
                
            case "markAllAsRead":
                System.out.println("→ Calling markAllAsRead()");
                markAllAsRead(response, currentUser);
                break;
                
            case "delete":
                System.out.println("→ Calling deleteNotification()");
                deleteNotification(request, response, currentUser);
                break;
                
            default:
                System.out.println("❌ ERROR: Unknown action: " + action);
                sendJsonResponse(response, false, "Invalid action: " + action);
        }
    }

    private void showNotifications(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        List<Notification> notifications = notificationDAO.getNotificationsByUserId(user.getUserId());
        int unreadCount = notificationDAO.getUnreadCount(user.getUserId());

        request.setAttribute("notifications", notifications);
        request.setAttribute("unreadCount", unreadCount);
        request.getRequestDispatcher("/notif/notifications.jsp").forward(request, response);
    }

    private void getUnreadCount(HttpServletResponse response, User user) throws IOException {
        int count = notificationDAO.getUnreadCount(user.getUserId());

        response.setContentType("application/json; charset=UTF-8");

        Map<String, Object> result = new HashMap<>();
        result.put("unreadCount", count);

        PrintWriter out = response.getWriter();
        out.print(gson.toJson(result));
        out.flush();
    }

    private void getLatestNotifications(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        response.setContentType("application/json; charset=UTF-8");

        try {
            String limitStr = request.getParameter("limit");
            String sinceStr = request.getParameter("since");

            List<Notification> notifications;

            if (limitStr != null && !limitStr.isEmpty()) {
                int limit = Integer.parseInt(limitStr);
                notifications = notificationDAO.getLatestNotificationsByLimit(user.getUserId(), limit);
            } else if (sinceStr != null && !sinceStr.isEmpty()) {
                java.sql.Timestamp since = new java.sql.Timestamp(Long.parseLong(sinceStr));
                notifications = notificationDAO.getLatestNotifications(user.getUserId(), since);
            } else {
                notifications = notificationDAO.getLatestNotificationsByLimit(user.getUserId(), 5);
            }

            String json = gson.toJson(notifications);
            PrintWriter out = response.getWriter();
            out.print(json);
            out.flush();

        } catch (Exception e) {
            System.err.println("Error in getLatestNotifications: " + e.getMessage());
            e.printStackTrace();
            response.getWriter().print("[]");
        }
    }

    private void markNotificationAsRead(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        try {
            System.out.println("  → markNotificationAsRead START");
            
            String idStr = request.getParameter("id");
            System.out.println("  → ID parameter: '" + idStr + "'");
            
            if (idStr == null || idStr.trim().isEmpty()) {
                System.out.println("  ❌ ID is null or empty");
                sendJsonResponse(response, false, "Missing notification ID");
                return;
            }
            
            int notificationId = Integer.parseInt(idStr.trim());
            int userId = user.getUserId();
            
            System.out.println("  → Marking notification " + notificationId + " as read for user " + userId);
            
            boolean success = notificationDAO.markAsRead(notificationId, userId);
            
            System.out.println("  → DAO returned: " + success);
            System.out.println("  → markNotificationAsRead END");
            
            sendJsonResponse(response, success, success ? "Marked as read" : "Failed to mark as read");
            
        } catch (NumberFormatException e) {
            System.err.println("  ❌ Invalid ID format: " + e.getMessage());
            sendJsonResponse(response, false, "Invalid notification ID format");
        } catch (Exception e) {
            System.err.println("  ❌ Exception in markNotificationAsRead:");
            e.printStackTrace();
            sendJsonResponse(response, false, "Error: " + e.getMessage());
        }
    }

    private void markAllAsRead(HttpServletResponse response, User user) throws IOException {
        try {
            System.out.println("  → markAllAsRead START");
            System.out.println("  → User ID: " + user.getUserId());
            
            boolean success = notificationDAO.markAllAsRead(user.getUserId());
            
            System.out.println("  → DAO returned: " + success);
            System.out.println("  → markAllAsRead END");
            
            sendJsonResponse(response, success, success ? "All marked as read" : "Failed to mark all as read");
            
        } catch (Exception e) {
            System.err.println("  ❌ Exception in markAllAsRead:");
            e.printStackTrace();
            sendJsonResponse(response, false, "Error: " + e.getMessage());
        }
    }

    private void deleteNotification(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        try {
            System.out.println("  → deleteNotification START");
            
            String idStr = request.getParameter("id");
            System.out.println("  → ID parameter: '" + idStr + "'");
            
            if (idStr == null || idStr.trim().isEmpty()) {
                System.out.println("  ❌ ID is null or empty");
                sendJsonResponse(response, false, "Missing notification ID");
                return;
            }
            
            int notificationId = Integer.parseInt(idStr.trim());
            int userId = user.getUserId();
            
            System.out.println("  → Deleting notification " + notificationId + " for user " + userId);
            
            boolean success = notificationDAO.deleteNotification(notificationId, userId);
            
            System.out.println("  → DAO returned: " + success);
            System.out.println("  → deleteNotification END");
            
            sendJsonResponse(response, success, success ? "Deleted successfully" : "Failed to delete");
            
        } catch (NumberFormatException e) {
            System.err.println("  ❌ Invalid ID format: " + e.getMessage());
            sendJsonResponse(response, false, "Invalid notification ID format");
        } catch (Exception e) {
            System.err.println("  ❌ Exception in deleteNotification:");
            e.printStackTrace();
            sendJsonResponse(response, false, "Error: " + e.getMessage());
        }
    }

    private void sendNotification(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        try {
            System.out.println("  → sendNotification START");

            // Check admin role
            if (!"Admin".equals(user.getRole())) {
                System.out.println("  ❌ User is not admin");
                sendJsonResponse(response, false, "Access denied");
                return;
            }

            // Read and trim parameters
            String title = request.getParameter("title");
            String message = request.getParameter("message");
            String notificationType = request.getParameter("notificationType");
            String priority = request.getParameter("priority");
            String linkUrl = request.getParameter("linkUrl");
            String receiverIdStr = request.getParameter("receiverId");

            // Trim all parameters
            title = (title != null) ? title.trim() : "";
            message = (message != null) ? message.trim() : "";
            notificationType = (notificationType != null) ? notificationType.trim() : "info";
            priority = (priority != null) ? priority.trim() : "normal";
            linkUrl = (linkUrl != null) ? linkUrl.trim() : "";
            receiverIdStr = (receiverIdStr != null) ? receiverIdStr.trim() : "all";

            // Validate required fields
            if (title.isEmpty()) {
                System.out.println("  ❌ Title is empty");
                sendJsonResponse(response, false, "Title is required");
                return;
            }

            if (message.isEmpty()) {
                System.out.println("  ❌ Message is empty");
                sendJsonResponse(response, false, "Message is required");
                return;
            }

            boolean success;

            if (receiverIdStr.isEmpty() || "all".equals(receiverIdStr)) {
                System.out.println("  → Sending BROADCAST");
                success = notificationDAO.sendBroadcastNotification(
                        user.getUserId(), title, message, notificationType, priority, linkUrl
                );
            } else {
                System.out.println("  → Sending to user ID " + receiverIdStr);
                int receiverId = Integer.parseInt(receiverIdStr);
                success = notificationDAO.sendNotificationToUser(
                        user.getUserId(), receiverId, title, message, notificationType, priority, linkUrl
                );
            }

            System.out.println("  → Result: " + (success ? "SUCCESS" : "FAILED"));
            sendJsonResponse(response, success, success ? "Notification sent successfully" : "Failed to send notification");

        } catch (Exception e) {
            System.err.println("  ❌ Exception in sendNotification:");
            e.printStackTrace();
            sendJsonResponse(response, false, "Server error: " + e.getMessage());
        }
    }
    
    
    
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message)
            throws IOException {
        response.setContentType("application/json; charset=UTF-8");

        Map<String, Object> result = new HashMap<>();
        result.put("success", success);
        result.put("message", message);

        String json = gson.toJson(result);
        System.out.println("  ← Response: " + json);
        
        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
    }
}