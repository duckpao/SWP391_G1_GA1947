package DAO;

import model.Notification;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO extends DBContext {

    // Gửi thông báo broadcast đến tất cả user - with debug
public boolean sendBroadcastNotification(int senderId, String title, String message, 
                                        String notificationType, String priority, String linkUrl) {
    String sql = "{call sp_SendBroadcastNotification(?, ?, ?, ?, ?, ?, ?)}";
    System.out.println("=== sendBroadcastNotification DEBUG ===");
    System.out.println("SQL: " + sql);
    System.out.println("senderId: " + senderId);
    System.out.println("title: " + title);
    System.out.println("message: " + message);
    System.out.println("notificationType: " + notificationType);
    System.out.println("priority: " + priority);
    System.out.println("linkUrl: " + linkUrl);
    
    try (CallableStatement cs = connection.prepareCall(sql)) {
        cs.setInt(1, senderId);
        cs.setString(2, title);
        cs.setString(3, message);
        cs.setString(4, notificationType);
        cs.setString(5, priority);
        cs.setString(6, linkUrl);
        cs.setNull(7, Types.TIMESTAMP);
        
        System.out.println("Executing stored procedure...");
        ResultSet rs = cs.executeQuery();
        if (rs.next()) {
            int count = rs.getInt("notifications_sent");
            System.out.println("Notifications sent: " + count);
            return count > 0;
        }
        System.out.println("No result from stored procedure");
    } catch (SQLException e) {
        System.err.println("SQLException in sendBroadcastNotification:");
        e.printStackTrace();
    }
    return false;
}

// Gửi thông báo đến một user cụ thể - with debug
public boolean sendNotificationToUser(int senderId, int receiverId, String title, 
                                     String message, String notificationType, 
                                     String priority, String linkUrl) {
    System.out.println("=== sendNotificationToUser DEBUG ===");
    System.out.println("senderId: " + senderId);
    System.out.println("receiverId: " + receiverId);
    System.out.println("title: " + title);
    
    String sql = "INSERT INTO Notifications (sender_id, receiver_id, title, message, " +
                "notification_type, priority, link_url, is_broadcast) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, 0)";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, senderId);
        ps.setInt(2, receiverId);
        ps.setString(3, title);
        ps.setString(4, message);
        ps.setString(5, notificationType);
        ps.setString(6, priority);
        ps.setString(7, linkUrl);
        
        System.out.println("Executing insert...");
        int rows = ps.executeUpdate();
        System.out.println("Rows affected: " + rows);
        return rows > 0;
    } catch (SQLException e) {
        System.err.println("SQLException in sendNotificationToUser:");
        e.printStackTrace();
    }
    return false;
}

    // Lấy tất cả thông báo của một user
    public List<Notification> getNotificationsByUserId(int userId) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT n.*, u.username as sender_username " +
                    "FROM Notifications n " +
                    "LEFT JOIN Users u ON n.sender_id = u.user_id " +
                    "WHERE n.receiver_id = ? " +
                    "AND (n.expires_at IS NULL OR n.expires_at > GETDATE()) " +
                    "ORDER BY n.created_at DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                notifications.add(extractNotificationFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return notifications;
    }

    // Lấy số lượng thông báo chưa đọc
    public int getUnreadCount(int userId) {
        String sql = "{call sp_GetUnreadNotificationCount(?)}";
        try (CallableStatement cs = connection.prepareCall(sql)) {
            cs.setInt(1, userId);
            ResultSet rs = cs.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("unread_count");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Đánh dấu một thông báo là đã đọc
    public boolean markAsRead(int notificationId, int userId) {
        String sql = "{call sp_MarkNotificationAsRead(?, ?)}";
        try (CallableStatement cs = connection.prepareCall(sql)) {
            cs.setInt(1, notificationId);
            cs.setInt(2, userId);
            ResultSet rs = cs.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("updated") > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Đánh dấu tất cả thông báo là đã đọc
    public boolean markAllAsRead(int userId) {
        String sql = "{call sp_MarkAllNotificationsAsRead(?)}";
        try (CallableStatement cs = connection.prepareCall(sql)) {
            cs.setInt(1, userId);
            ResultSet rs = cs.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("updated") > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa thông báo
    public boolean deleteNotification(int notificationId, int userId) {
        String sql = "DELETE FROM Notifications WHERE notification_id = ? AND receiver_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, notificationId);
            ps.setInt(2, userId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy thông báo mới nhất (cho real-time polling)
    public List<Notification> getLatestNotifications(int userId, Timestamp since) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT n.*, u.username as sender_username " +
                    "FROM Notifications n " +
                    "LEFT JOIN Users u ON n.sender_id = u.user_id " +
                    "WHERE n.receiver_id = ? AND n.created_at > ? " +
                    "ORDER BY n.created_at DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setTimestamp(2, since);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                notifications.add(extractNotificationFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return notifications;
    }

    // Lấy tất cả users (để admin chọn gửi thông báo)
    public List<model.User> getAllActiveUsers() {
        List<model.User> users = new ArrayList<>();
        String sql = "SELECT user_id, username, email, role FROM Users WHERE is_active = 1 ORDER BY username";
        
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                model.User user = new model.User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    // Helper method
    private Notification extractNotificationFromResultSet(ResultSet rs) throws SQLException {
        Notification n = new Notification();
        n.setNotificationId(rs.getInt("notification_id"));
        n.setSenderId(rs.getInt("sender_id"));
        
        int receiverId = rs.getInt("receiver_id");
        n.setReceiverId(rs.wasNull() ? null : receiverId);
        
        n.setTitle(rs.getString("title"));
        n.setMessage(rs.getString("message"));
        n.setNotificationType(rs.getString("notification_type"));
        n.setRead(rs.getBoolean("is_read"));
        n.setBroadcast(rs.getBoolean("is_broadcast"));
        n.setPriority(rs.getString("priority"));
        n.setCreatedAt(rs.getTimestamp("created_at"));
        n.setReadAt(rs.getTimestamp("read_at"));
        n.setExpiresAt(rs.getTimestamp("expires_at"));
        n.setLinkUrl(rs.getString("link_url"));
        n.setSenderUsername(rs.getString("sender_username"));
        
        return n;
    }
}