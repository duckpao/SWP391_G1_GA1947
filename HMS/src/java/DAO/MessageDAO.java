package DAO;

import model.Message;
import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class MessageDAO extends DBContext {

    public boolean insertMessage(Message message) {
        String sql = "INSERT INTO Messages (sender_id, receiver_id, message_content, message_type, sent_at) VALUES (?, ?, ?, ?, GETDATE())";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, message.getSenderId());
            ps.setInt(2, message.getReceiverId());
            ps.setString(3, message.getMessageContent());
            ps.setString(4, message.getMessageType());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Message> getMessagesBetweenUsers(int userId1, int userId2, int limit) {
        List<Message> messages = new ArrayList<>();

        String sql = "SELECT TOP (?) message_id, sender_id, receiver_id, message_content, "
                + "message_type, sent_at, is_read "
                + "FROM Messages "
                + "WHERE (sender_id = ? AND receiver_id = ?) "
                + "   OR (sender_id = ? AND receiver_id = ?) "
                + "ORDER BY sent_at DESC"; // DESC để lấy tin mới nhất, sau đó reverse trong servlet

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            ps.setInt(2, userId1);
            ps.setInt(3, userId2);
            ps.setInt(4, userId2);
            ps.setInt(5, userId1);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Message message = new Message();
                message.setMessageId(rs.getInt("message_id"));
                message.setSenderId(rs.getInt("sender_id"));
                message.setReceiverId(rs.getInt("receiver_id"));
                message.setMessageContent(rs.getString("message_content"));
                message.setMessageType(rs.getString("message_type"));
                message.setSentAt(rs.getTimestamp("sent_at"));
                message.setRead(rs.getBoolean("is_read"));

                messages.add(message);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Reverse list để tin cũ nhất ở đầu
        Collections.reverse(messages);
        return messages;
    }

    public boolean markMessageAsRead(int messageId) {
        String sql = "UPDATE Messages SET is_read = 1 WHERE message_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, messageId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean markAllMessagesAsRead(int receiverId, int senderId) {
        String sql = "UPDATE Messages SET is_read = 1 "
                + "WHERE receiver_id = ? AND sender_id = ? AND is_read = 0";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, receiverId);
            ps.setInt(2, senderId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getUnreadCount(int userId) {
        String sql = "SELECT COUNT(*) FROM Messages WHERE receiver_id = ? AND is_read = 0";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Message> getRecentConversations(int userId) {
        List<Message> conversations = new ArrayList<>();
        String sql = "WITH RankedMessages AS ( "
                + "    SELECT m.*, u1.username as sender_name, u2.username as receiver_name, "
                + "    ROW_NUMBER() OVER (PARTITION BY "
                + "        CASE WHEN m.sender_id = ? THEN m.receiver_id ELSE m.sender_id END "
                + "        ORDER BY m.sent_at DESC) as rn "
                + "    FROM Messages m "
                + "    LEFT JOIN Users u1 ON m.sender_id = u1.user_id "
                + "    LEFT JOIN Users u2 ON m.receiver_id = u2.user_id "
                + "    WHERE m.sender_id = ? OR m.receiver_id = ? "
                + ") "
                + "SELECT * FROM RankedMessages WHERE rn = 1 ORDER BY sent_at DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.setInt(3, userId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Message msg = new Message();
                msg.setMessageId(rs.getInt("message_id"));
                msg.setSenderId(rs.getInt("sender_id"));
                msg.setReceiverId(rs.getInt("receiver_id"));
                msg.setMessageContent(rs.getString("message_content"));
                msg.setRead(rs.getBoolean("is_read"));
                msg.setSentAt(rs.getTimestamp("sent_at"));
                msg.setMessageType(rs.getString("message_type"));
                msg.setSenderUsername(rs.getString("sender_name"));
                msg.setReceiverUsername(rs.getString("receiver_name"));
                conversations.add(msg);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conversations;
    }
}
