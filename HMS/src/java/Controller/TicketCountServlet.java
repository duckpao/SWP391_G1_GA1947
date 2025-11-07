package Controller;

import DAO.TicketDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

public class TicketCountServlet extends HttpServlet {
    
    private TicketDAO ticketDAO;
    
    @Override
    public void init() throws ServletException {
        ticketDAO = new TicketDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        int count = 0;
        
        if (session != null && session.getAttribute("user") != null) {
            Integer userId = (Integer) session.getAttribute("userId");
            String role = (String) session.getAttribute("role");
            
            if ("Admin".equals(role)) {
                count = ticketDAO.countPendingTickets();
            } else if (userId != null) {
                count = ticketDAO.countUnrespondedTickets(userId);
            }
        }
        
        PrintWriter out = response.getWriter();
        out.print("{\"count\":" + count + "}");
        out.flush();
    }
}