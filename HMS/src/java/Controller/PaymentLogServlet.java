package Controller;

import util.PaymentLogger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class PaymentLogServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("clear".equals(action)) {
            PaymentLogger.clearLogs();
            response.sendRedirect("payment-logs");
            return;
        }
        
        // Lấy tất cả logs
        request.setAttribute("logs", PaymentLogger.getAllLogs());
        request.getRequestDispatcher("/payment-logs.jsp").forward(request, response);
    }
}