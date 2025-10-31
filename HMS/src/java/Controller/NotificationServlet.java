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
            case "markAsRead":
                markNotificationAsRead(request, response, currentUser);
                break;
            case "markAllAsRead":
                markAllAsRead(response, currentUser);
                break;
            case "delete":
                deleteNotification(request, response, currentUser);
                break;
            default:
                showNotifications(request, response, currentUser);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // ✅ CRITICAL: Set encoding BEFORE reading ANY parameters
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        
        System.out.println("\n==========================================================");
        System.out.println("=== doPost called at " + new java.util.Date() + " ===");
        System.out.println("==========================================================");
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            System.out.println("❌ ERROR: No user in session");
            sendJsonResponse(response, false, "Unauthorized");
            return;
        }
        
        System.out.println("✓ User authenticated: " + currentUser.getUsername() + " (Role: " + currentUser.getRole() + ")");
        
        // Get action parameter
        String action = request.getParameter("action");
        System.out.println("Action from URL: '" + action + "'");
        
        if ("send".equals(action)) {
            sendNotification(request, response, currentUser);
        } else {
            System.out.println("❌ ERROR: Invalid or missing action");
            sendJsonResponse(response, false, "Invalid action");
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
        String sinceStr = request.getParameter("since");
        java.sql.Timestamp since = new java.sql.Timestamp(Long.parseLong(sinceStr));
        
        List<Notification> notifications = notificationDAO.getLatestNotifications(user.getUserId(), since);
        
        response.setContentType("application/json; charset=UTF-8");
        
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(notifications));
        out.flush();
    }

    private void markNotificationAsRead(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        int notificationId = Integer.parseInt(request.getParameter("id"));
        boolean success = notificationDAO.markAsRead(notificationId, user.getUserId());
        
        sendJsonResponse(response, success, success ? "Marked as read" : "Failed");
    }

    private void markAllAsRead(HttpServletResponse response, User user) throws IOException {
        boolean success = notificationDAO.markAllAsRead(user.getUserId());
        sendJsonResponse(response, success, success ? "All marked as read" : "Failed");
    }

    private void deleteNotification(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        int notificationId = Integer.parseInt(request.getParameter("id"));
        boolean success = notificationDAO.deleteNotification(notificationId, user.getUserId());
        
        sendJsonResponse(response, success, success ? "Deleted successfully" : "Failed");
    }

    private void sendNotification(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        try {
            System.out.println("\n--- sendNotification Method Started ---");
            
            // Check admin role
            if (!"Admin".equals(user.getRole())) {
                System.out.println("❌ ERROR: User is not admin");
                sendJsonResponse(response, false, "Access denied");
                return;
            }
            System.out.println("✓ User has admin role");
            
            // ✅ Read and trim parameters immediately
            String title = request.getParameter("title");
            String message = request.getParameter("message");
            String notificationType = request.getParameter("notificationType");
            String priority = request.getParameter("priority");
            String linkUrl = request.getParameter("linkUrl");
            String receiverIdStr = request.getParameter("receiverId");
            
            // Debug logging
            System.out.println("\n--- Raw Parameters ---");
            System.out.println("title: " + (title != null ? "'" + title + "' (length: " + title.length() + ")" : "null"));
            System.out.println("message: " + (message != null ? "'" + message + "' (length: " + message.length() + ")" : "null"));
            System.out.println("notificationType: " + notificationType);
            System.out.println("priority: " + priority);
            System.out.println("linkUrl: " + linkUrl);
            System.out.println("receiverId: " + receiverIdStr);
            
            // Trim all string parameters
            title = (title != null) ? title.trim() : "";
            message = (message != null) ? message.trim() : "";
            notificationType = (notificationType != null) ? notificationType.trim() : "info";
            priority = (priority != null) ? priority.trim() : "normal";
            linkUrl = (linkUrl != null) ? linkUrl.trim() : "";
            receiverIdStr = (receiverIdStr != null) ? receiverIdStr.trim() : "all";
            
            System.out.println("\n--- After Trimming ---");
            System.out.println("title: '" + title + "' (length: " + title.length() + ")");
            System.out.println("message: '" + message + "' (length: " + message.length() + ")");
            
            // Validate required fields
            if (title.isEmpty()) {
                System.out.println("❌ VALIDATION FAILED: Title is empty");
                sendJsonResponse(response, false, "Title is required");
                return;
            }
            
            if (message.isEmpty()) {
                System.out.println("❌ VALIDATION FAILED: Message is empty");
                sendJsonResponse(response, false, "Message is required");
                return;
            }
            
            System.out.println("✓ Validation passed");
            
            // Set defaults for optional fields
            if (notificationType.isEmpty()) {
                notificationType = "info";
            }
            if (priority.isEmpty()) {
                priority = "normal";
            }
            
            boolean success;
            
            System.out.println("\n--- Sending Notification ---");
            if (receiverIdStr.isEmpty() || "all".equals(receiverIdStr)) {
                System.out.println("Type: BROADCAST to all users");
                success = notificationDAO.sendBroadcastNotification(
                    user.getUserId(), title, message, notificationType, priority, linkUrl
                );
            } else {
                System.out.println("Type: INDIVIDUAL to user ID " + receiverIdStr);
                try {
                    int receiverId = Integer.parseInt(receiverIdStr);
                    success = notificationDAO.sendNotificationToUser(
                        user.getUserId(), receiverId, title, message, notificationType, priority, linkUrl
                    );
                } catch (NumberFormatException e) {
                    System.out.println("❌ ERROR: Invalid receiver ID format");
                    sendJsonResponse(response, false, "Invalid receiver ID");
                    return;
                }
            }
            
            System.out.println("Result: " + (success ? "✓ SUCCESS" : "❌ FAILED"));
            sendJsonResponse(response, success, success ? "Notification sent successfully" : "Failed to send notification");
            
            System.out.println("==========================================================\n");
            
        } catch (Exception e) {
            System.err.println("❌ EXCEPTION in sendNotification:");
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
        
        PrintWriter out = response.getWriter();
        String json = gson.toJson(result);
        System.out.println("Sending JSON response: " + json);
        out.print(json);
        out.flush();
    }
}