package websocket;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import DAO.NotificationDAO;

import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArraySet;

@ServerEndpoint("/notifications")
public class NotificationWebSocket {
    
    // Map userId -> Session
    private static final Map<Integer, Session> userSessions = new ConcurrentHashMap<>();
    
    // Set of all active sessions
    private static final Set<Session> allSessions = new CopyOnWriteArraySet<>();
    
    private static final Gson gson = new Gson();
    private static final NotificationDAO notificationDAO = new NotificationDAO();

    @OnOpen
    public void onOpen(Session session) {
        allSessions.add(session);
        System.out.println("✓ Notification WebSocket opened: " + session.getId());
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        try {
            System.out.println("Received message: " + message);
            JsonObject json = gson.fromJson(message, JsonObject.class);
            String action = json.get("action").getAsString();

            switch (action) {
                case "register":
                    registerUser(json, session);
                    break;
                case "getUnreadCount":
                    sendUnreadCount(json, session);
                    break;
                default:
                    sendError(session, "Unknown action: " + action);
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendError(session, "Invalid message format: " + e.getMessage());
        }
    }

    @OnClose
    public void onClose(Session session) {
        allSessions.remove(session);
        
        // Remove from user sessions
        userSessions.entrySet().removeIf(entry -> entry.getValue().equals(session));
        
        System.out.println("✓ Notification WebSocket closed: " + session.getId());
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        System.err.println("❌ Notification WebSocket error: " + throwable.getMessage());
        throwable.printStackTrace();
    }

    /**
     * Register user with their session
     */
    private void registerUser(JsonObject json, Session session) {
        try {
            int userId = json.get("userId").getAsInt();
            userSessions.put(userId, session);
            
            System.out.println("✓ User " + userId + " registered for notifications");
            
            // Send confirmation
            JsonObject response = new JsonObject();
            response.addProperty("type", "registered");
            response.addProperty("userId", userId);
            sendToSession(session, response.toString());
            
            // Send current unread count
            int unreadCount = notificationDAO.getUnreadCount(userId);
            JsonObject countUpdate = new JsonObject();
            countUpdate.addProperty("type", "unreadCount");
            countUpdate.addProperty("count", unreadCount);
            sendToSession(session, countUpdate.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            sendError(session, "Failed to register user");
        }
    }

    /**
     * Send unread count to specific user
     */
    private void sendUnreadCount(JsonObject json, Session session) {
        try {
            int userId = json.get("userId").getAsInt();
            int unreadCount = notificationDAO.getUnreadCount(userId);
            
            JsonObject response = new JsonObject();
            response.addProperty("type", "unreadCount");
            response.addProperty("count", unreadCount);
            sendToSession(session, response.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            sendError(session, "Failed to get unread count");
        }
    }

    /**
     * Send a message to a specific session
     */
    private void sendToSession(Session session, String message) {
        try {
            if (session != null && session.isOpen()) {
                session.getBasicRemote().sendText(message);
            }
        } catch (IOException e) {
            System.err.println("Failed to send message to session: " + e.getMessage());
        }
    }

    /**
     * Send error message to session
     */
    private void sendError(Session session, String errorMessage) {
        JsonObject error = new JsonObject();
        error.addProperty("type", "error");
        error.addProperty("message", errorMessage);
        sendToSession(session, error.toString());
    }

    // ============================================
    // PUBLIC STATIC METHODS FOR NOTIFICATION UPDATES
    // ============================================

    /**
     * Notify a specific user about a new notification
     * Call this from NotificationDAO after creating a notification
     */
    public static void notifyUser(int userId, String title, String message, String type) {
        Session session = userSessions.get(userId);
        
        if (session != null && session.isOpen()) {
            try {
                JsonObject notification = new JsonObject();
                notification.addProperty("type", "newNotification");
                notification.addProperty("title", title);
                notification.addProperty("message", message);
                notification.addProperty("notificationType", type);
                notification.addProperty("timestamp", System.currentTimeMillis());
                
                session.getBasicRemote().sendText(notification.toString());
                System.out.println("✓ Sent notification to user " + userId);
                
                // Also send updated unread count
                int unreadCount = notificationDAO.getUnreadCount(userId);
                JsonObject countUpdate = new JsonObject();
                countUpdate.addProperty("type", "unreadCount");
                countUpdate.addProperty("count", unreadCount);
                session.getBasicRemote().sendText(countUpdate.toString());
                
            } catch (IOException e) {
                System.err.println("❌ Failed to send notification to user " + userId);
                e.printStackTrace();
            }
        } else {
            System.out.println("⚠ User " + userId + " is not connected to WebSocket");
        }
    }

    /**
     * Update unread count for a specific user
     * Call this after marking notifications as read
     */
    public static void updateUnreadCount(int userId) {
        Session session = userSessions.get(userId);
        
        if (session != null && session.isOpen()) {
            try {
                int unreadCount = notificationDAO.getUnreadCount(userId);
                
                JsonObject response = new JsonObject();
                response.addProperty("type", "unreadCount");
                response.addProperty("count", unreadCount);
                
                session.getBasicRemote().sendText(response.toString());
                System.out.println("✓ Updated unread count for user " + userId + ": " + unreadCount);
                
            } catch (IOException e) {
                System.err.println("❌ Failed to update count for user " + userId);
                e.printStackTrace();
            }
        }
    }

    /**
     * Broadcast notification to all connected users
     * Use this for system-wide announcements
     */
    public static void broadcastToAll(String title, String message, String type) {
        JsonObject notification = new JsonObject();
        notification.addProperty("type", "newNotification");
        notification.addProperty("title", title);
        notification.addProperty("message", message);
        notification.addProperty("notificationType", type);
        notification.addProperty("timestamp", System.currentTimeMillis());
        
        String messageStr = notification.toString();
        int successCount = 0;
        
        for (Session session : allSessions) {
            try {
                if (session.isOpen()) {
                    session.getBasicRemote().sendText(messageStr);
                    successCount++;
                }
            } catch (IOException e) {
                System.err.println("Failed to broadcast to session: " + e.getMessage());
            }
        }
        
        System.out.println("✓ Broadcast notification to " + successCount + " users");
    }

    /**
     * Get count of connected users
     */
    public static int getConnectedUsersCount() {
        return userSessions.size();
    }

    /**
     * Check if a user is connected
     */
    public static boolean isUserConnected(int userId) {
        Session session = userSessions.get(userId);
        return session != null && session.isOpen();
    }
}