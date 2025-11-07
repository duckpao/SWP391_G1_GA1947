package websocket;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import DAO.MessageDAO;
import model.Message;

import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint("/chat")
public class ChatWebSocket {
    
    private static final Map<String, Session> sessions = new ConcurrentHashMap<>();
    private static final Gson gson = new Gson();
    private static final MessageDAO messageDAO = new MessageDAO();

    @OnOpen
    public void onOpen(Session session) {
        System.out.println("WebSocket opened: " + session.getId());
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        try {
            JsonObject json = gson.fromJson(message, JsonObject.class);
            String action = json.get("action").getAsString();

            switch (action) {
                case "register":
                    registerUser(json, session);
                    break;
                case "sendMessage":
                    sendMessage(json, session);
                    break;
                case "typing":
                    sendTypingIndicator(json, session);
                    break;
                case "markAsRead":
                    handleMarkAsRead(json, session);
                    break;
                default:
                    sendError(session, "Unknown action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendError(session, "Invalid message format");
        }
    }

    @OnClose
    public void onClose(Session session) {
        sessions.values().remove(session);
        System.out.println("WebSocket closed: " + session.getId());
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        System.err.println("WebSocket error: " + throwable.getMessage());
    }

    private void registerUser(JsonObject json, Session session) {
        String userId = json.get("userId").getAsString();
        sessions.put(userId, session);
        
        JsonObject response = new JsonObject();
        response.addProperty("type", "registered");
        response.addProperty("userId", userId);
        sendToSession(session, response.toString());
        
        System.out.println("User registered: " + userId);
    }

    private void sendMessage(JsonObject json, Session session) {
        try {
            int senderId = json.get("senderId").getAsInt();
            int receiverId = json.get("receiverId").getAsInt();
            String content = json.get("content").getAsString();
            String type = json.has("type") ? json.get("type").getAsString() : "text";

            // Save to database
            Message msg = new Message(senderId, receiverId, content, type);
            boolean saved = messageDAO.insertMessage(msg);

            if (saved) {
                long timestamp = System.currentTimeMillis();
                
                // Prepare response
                JsonObject response = new JsonObject();
                response.addProperty("type", "message");
                response.addProperty("senderId", senderId);
                response.addProperty("receiverId", receiverId);
                response.addProperty("content", content);
                response.addProperty("messageType", type);
                response.addProperty("timestamp", timestamp);
                response.addProperty("isRead", false);

                // Send to receiver if online
                Session receiverSession = sessions.get(String.valueOf(receiverId));
                if (receiverSession != null && receiverSession.isOpen()) {
                    sendToSession(receiverSession, response.toString());
                    System.out.println("Message sent to receiver: " + receiverId);
                }

                // Send confirmation to sender
                JsonObject confirmation = new JsonObject();
                confirmation.addProperty("type", "sent");
                confirmation.addProperty("senderId", senderId);
                confirmation.addProperty("receiverId", receiverId);
                confirmation.addProperty("timestamp", timestamp);
                sendToSession(session, confirmation.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendError(session, "Failed to send message");
        }
    }

    private void handleMarkAsRead(JsonObject json, Session session) {
        try {
            int receiverId = json.get("receiverId").getAsInt();
            int senderId = json.get("senderId").getAsInt();
            
            System.out.println("Marking messages as read: receiver=" + receiverId + ", sender=" + senderId);
            
            // Đánh dấu tin nhắn là đã đọc trong database
            boolean success = messageDAO.markMessagesAsReadFromUser(receiverId, senderId);
            
            if (success) {
                // Gửi thông báo cho người gửi (senderId) rằng tin nhắn đã được đọc
                Session senderSession = sessions.get(String.valueOf(senderId));
                if (senderSession != null && senderSession.isOpen()) {
                    JsonObject notification = new JsonObject();
                    notification.addProperty("type", "messagesRead");
                    notification.addProperty("readBy", receiverId);
                    notification.addProperty("messagesFrom", senderId);
                    sendToSession(senderSession, notification.toString());
                    System.out.println("Sent read notification to sender: " + senderId);
                }
                
                // Gửi xác nhận cho người đọc
                JsonObject confirmation = new JsonObject();
                confirmation.addProperty("type", "markReadSuccess");
                confirmation.addProperty("senderId", senderId);
                sendToSession(session, confirmation.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendError(session, "Failed to mark messages as read");
        }
    }

    private void sendTypingIndicator(JsonObject json, Session session) {
        try {
            int senderId = json.get("senderId").getAsInt();
            int receiverId = json.get("receiverId").getAsInt();
            boolean isTyping = json.get("isTyping").getAsBoolean();

            Session receiverSession = sessions.get(String.valueOf(receiverId));
            if (receiverSession != null && receiverSession.isOpen()) {
                JsonObject response = new JsonObject();
                response.addProperty("type", "typing");
                response.addProperty("senderId", senderId);
                response.addProperty("isTyping", isTyping);
                sendToSession(receiverSession, response.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void sendToSession(Session session, String message) {
        try {
            if (session.isOpen()) {
                session.getBasicRemote().sendText(message);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void sendError(Session session, String errorMessage) {
        JsonObject error = new JsonObject();
        error.addProperty("type", "error");
        error.addProperty("message", errorMessage);
        sendToSession(session, error.toString());
    }

    // Broadcast message to all connected users
    public static void broadcastNotification(String notification) {
        JsonObject message = new JsonObject();
        message.addProperty("type", "notification");
        message.addProperty("content", notification);
        
        String messageStr = message.toString();
        sessions.values().forEach(session -> {
            try {
                if (session.isOpen()) {
                    session.getBasicRemote().sendText(messageStr);
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        });
    }
}