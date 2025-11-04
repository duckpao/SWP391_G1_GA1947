package DAO;

import model.Ticket;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TicketDAO extends DBContext {

    // Create new ticket
    public boolean createTicket(Ticket ticket) {
        String sql = "INSERT INTO Tickets (user_id, subject, message, priority, category) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, ticket.getUserId());
            ps.setString(2, ticket.getSubject());
            ps.setString(3, ticket.getMessage());
            ps.setString(4, ticket.getPriority());
            ps.setString(5, ticket.getCategory());
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all tickets for user
    public List<Ticket> getTicketsByUserId(int userId) {
        List<Ticket> tickets = new ArrayList<>();
        String sql = "SELECT t.*, u.username, u.email as user_email, a.username as admin_username " +
                     "FROM Tickets t " +
                     "LEFT JOIN Users u ON t.user_id = u.user_id " +
                     "LEFT JOIN Users a ON t.responded_by = a.user_id " +
                     "WHERE t.user_id = ? " +
                     "ORDER BY t.created_at DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                tickets.add(extractTicket(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return tickets;
    }

    // Get all tickets (for admin)
    public List<Ticket> getAllTickets() {
        List<Ticket> tickets = new ArrayList<>();
        String sql = "SELECT t.*, u.username, u.email as user_email, a.username as admin_username " +
                     "FROM Tickets t " +
                     "LEFT JOIN Users u ON t.user_id = u.user_id " +
                     "LEFT JOIN Users a ON t.responded_by = a.user_id " +
                     "ORDER BY t.created_at DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                tickets.add(extractTicket(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return tickets;
    }

    // Get tickets by status
    public List<Ticket> getTicketsByStatus(String status) {
        List<Ticket> tickets = new ArrayList<>();
        String sql = "SELECT t.*, u.username, u.email as user_email, a.username as admin_username " +
                     "FROM Tickets t " +
                     "LEFT JOIN Users u ON t.user_id = u.user_id " +
                     "LEFT JOIN Users a ON t.responded_by = a.user_id " +
                     "WHERE t.status = ? " +
                     "ORDER BY t.created_at DESC";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                tickets.add(extractTicket(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return tickets;
    }

    // Get ticket by ID
    public Ticket getTicketById(int ticketId) {
        String sql = "SELECT t.*, u.username, u.email as user_email, a.username as admin_username " +
                     "FROM Tickets t " +
                     "LEFT JOIN Users u ON t.user_id = u.user_id " +
                     "LEFT JOIN Users a ON t.responded_by = a.user_id " +
                     "WHERE t.ticket_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, ticketId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return extractTicket(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Update ticket status
    public boolean updateTicketStatus(int ticketId, String status) {
        String sql = "UPDATE Tickets SET status = ?, updated_at = GETDATE() WHERE ticket_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, ticketId);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Admin respond to ticket
    public boolean respondToTicket(int ticketId, int adminId, String response, String status) {
        String sql = "UPDATE Tickets SET admin_response = ?, responded_by = ?, " +
                     "responded_at = GETDATE(), status = ?, updated_at = GETDATE() " +
                     "WHERE ticket_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, response);
            ps.setInt(2, adminId);
            ps.setString(3, status);
            ps.setInt(4, ticketId);
            
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete ticket
    public boolean deleteTicket(int ticketId) {
        String sql = "DELETE FROM Tickets WHERE ticket_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, ticketId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Count tickets by status for user
    public int countTicketsByStatus(int userId, String status) {
        String sql = "SELECT COUNT(*) FROM Tickets WHERE user_id = ? AND status = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Count tickets without admin response for user
    public int countUnrespondedTickets(int userId) {
        String sql = "SELECT COUNT(*) FROM Tickets WHERE user_id = ? AND (admin_response IS NULL OR admin_response = '') AND status NOT IN ('Resolved', 'Closed')";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
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

    // Count all Open and InProgress tickets (for Admin)
    public int countPendingTickets() {
        String sql = "SELECT COUNT(*) FROM Tickets WHERE status IN ('Open', 'InProgress')";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Helper method to extract ticket from ResultSet
    private Ticket extractTicket(ResultSet rs) throws SQLException {
        Ticket ticket = new Ticket();
        ticket.setTicketId(rs.getInt("ticket_id"));
        ticket.setUserId(rs.getInt("user_id"));
        ticket.setSubject(rs.getString("subject"));
        ticket.setMessage(rs.getString("message"));
        ticket.setStatus(rs.getString("status"));
        ticket.setPriority(rs.getString("priority"));
        ticket.setCategory(rs.getString("category"));
        ticket.setAdminResponse(rs.getString("admin_response"));
        
        int respondedBy = rs.getInt("responded_by");
        if (!rs.wasNull()) {
            ticket.setRespondedBy(respondedBy);
        }
        
        ticket.setRespondedAt(rs.getTimestamp("responded_at"));
        ticket.setCreatedAt(rs.getTimestamp("created_at"));
        ticket.setUpdatedAt(rs.getTimestamp("updated_at"));
        ticket.setUsername(rs.getString("username"));
        ticket.setUserEmail(rs.getString("user_email"));
        ticket.setAdminUsername(rs.getString("admin_username"));
        
        return ticket;
    }
}