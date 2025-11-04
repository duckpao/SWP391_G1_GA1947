package Controller;

import DAO.TicketDAO;
import model.Ticket;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "TicketController", urlPatterns = {"/ticket"})
public class TicketController extends HttpServlet {
    
    private TicketDAO ticketDAO;
    
    @Override
    public void init() throws ServletException {
        ticketDAO = new TicketDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) action = "list";
        
        switch (action) {
            case "list":
                listTickets(request, response, session);
                break;
            case "view":
                viewTicket(request, response, session);
                break;
            case "create":
                request.getRequestDispatcher("createTicket.jsp").forward(request, response);
                break;
            case "delete":
                deleteTicket(request, response, session);
                break;
            default:
                listTickets(request, response, session);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        
        switch (action) {
            case "create":
                createTicket(request, response, session);
                break;
            case "respond":
                respondToTicket(request, response, session);
                break;
            case "updateStatus":
                updateStatus(request, response, session);
                break;
            default:
                response.sendRedirect("ticket?action=list");
        }
    }

    // List tickets (user sees own, admin sees all)
    private void listTickets(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        
        List<Ticket> tickets;
        
        if ("Admin".equals(role)) {
            String filter = request.getParameter("filter");
            if (filter != null && !filter.isEmpty()) {
                tickets = ticketDAO.getTicketsByStatus(filter);
            } else {
                tickets = ticketDAO.getAllTickets();
            }
        } else {
            tickets = ticketDAO.getTicketsByUserId(userId);
        }
        
        request.setAttribute("tickets", tickets);
        request.setAttribute("role", role);
        request.getRequestDispatcher("ticketList.jsp").forward(request, response);
    }

    // View single ticket
    private void viewTicket(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        
        int ticketId = Integer.parseInt(request.getParameter("id"));
        Integer userId = (Integer) session.getAttribute("userId");
        String role = (String) session.getAttribute("role");
        
        Ticket ticket = ticketDAO.getTicketById(ticketId);
        
        if (ticket == null) {
            request.setAttribute("error", "Ticket not found");
            response.sendRedirect("ticket?action=list");
            return;
        }
        
        // Check permission (user can only view own tickets, admin can view all)
        if (!"Admin".equals(role) && ticket.getUserId() != userId) {
            request.setAttribute("error", "Access denied");
            response.sendRedirect("ticket?action=list");
            return;
        }
        
        request.setAttribute("ticket", ticket);
        request.setAttribute("role", role);
        request.getRequestDispatcher("ticketDetail.jsp").forward(request, response);
    }

    // Create new ticket
    private void createTicket(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        
        Integer userId = (Integer) session.getAttribute("userId");
        
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");
        String priority = request.getParameter("priority");
        String category = request.getParameter("category");
        
        if (subject == null || subject.trim().isEmpty() || 
            message == null || message.trim().isEmpty()) {
            request.setAttribute("error", "Subject and message are required");
            request.getRequestDispatcher("createTicket.jsp").forward(request, response);
            return;
        }
        
        Ticket ticket = new Ticket(userId, subject, message, priority, category);
        
        if (ticketDAO.createTicket(ticket)) {
            request.setAttribute("success", "Ticket created successfully");
            response.sendRedirect("ticket?action=list");
        } else {
            request.setAttribute("error", "Failed to create ticket");
            request.getRequestDispatcher("createTicket.jsp").forward(request, response);
        }
    }

    // Admin respond to ticket
    private void respondToTicket(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        
        String role = (String) session.getAttribute("role");
        if (!"Admin".equals(role)) {
            response.sendRedirect("ticket?action=list");
            return;
        }
        
        int ticketId = Integer.parseInt(request.getParameter("ticketId"));
        Integer adminId = (Integer) session.getAttribute("userId");
        String adminResponse = request.getParameter("adminResponse");
        String status = request.getParameter("status");
        
        if (adminResponse == null || adminResponse.trim().isEmpty()) {
            request.setAttribute("error", "Response cannot be empty");
            request.setAttribute("ticket", ticketDAO.getTicketById(ticketId));
            request.getRequestDispatcher("ticketDetail.jsp").forward(request, response);
            return;
        }
        
        if (ticketDAO.respondToTicket(ticketId, adminId, adminResponse, status)) {
            request.setAttribute("success", "Response sent successfully");
            response.sendRedirect("ticket?action=view&id=" + ticketId);
        } else {
            request.setAttribute("error", "Failed to send response");
            request.setAttribute("ticket", ticketDAO.getTicketById(ticketId));
            request.getRequestDispatcher("ticketDetail.jsp").forward(request, response);
        }
    }

    // Update ticket status
    private void updateStatus(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        
        String role = (String) session.getAttribute("role");
        if (!"Admin".equals(role)) {
            response.sendRedirect("ticket?action=list");
            return;
        }
        
        int ticketId = Integer.parseInt(request.getParameter("ticketId"));
        String status = request.getParameter("status");
        
        if (ticketDAO.updateTicketStatus(ticketId, status)) {
            request.setAttribute("success", "Status updated successfully");
        } else {
            request.setAttribute("error", "Failed to update status");
        }
        
        response.sendRedirect("ticket?action=view&id=" + ticketId);
    }

    // Delete ticket (Admin only)
    private void deleteTicket(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {
        
        String role = (String) session.getAttribute("role");
        if (!"Admin".equals(role)) {
            response.sendRedirect("ticket?action=list");
            return;
        }
        
        int ticketId = Integer.parseInt(request.getParameter("id"));
        
        if (ticketDAO.deleteTicket(ticketId)) {
            request.setAttribute("success", "Ticket deleted successfully");
        } else {
            request.setAttribute("error", "Failed to delete ticket");
        }
        
        response.sendRedirect("ticket?action=list");
    }
}