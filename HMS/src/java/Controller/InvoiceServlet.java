package Controller;

import DAO.InvoiceDAO;
import model.Invoice;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class InvoiceServlet extends HttpServlet {
    private InvoiceDAO invoiceDAO;
    
    @Override
    public void init() {
        invoiceDAO = new InvoiceDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                listInvoices(request, response);
                break;
            case "pending":
                listPendingInvoices(request, response);
                break;
            case "view":
                viewInvoice(request, response);
                break;
            default:
                listInvoices(request, response);
        }
    }
    
    private void listInvoices(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Invoice> invoices = invoiceDAO.getAllInvoices();
        request.setAttribute("invoices", invoices);
        request.getRequestDispatcher("/invoices.jsp").forward(request, response);
    }
    
    private void listPendingInvoices(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Invoice> invoices = invoiceDAO.getPendingInvoices();
        request.setAttribute("invoices", invoices);
        request.setAttribute("filterType", "pending");
        request.getRequestDispatcher("/invoices.jsp").forward(request, response);
    }
    
    private void viewInvoice(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int invoiceId = Integer.parseInt(request.getParameter("id"));
        Invoice invoice = invoiceDAO.getInvoiceById(invoiceId);
        request.setAttribute("invoice", invoice);
        request.getRequestDispatcher("/invoice-detail.jsp").forward(request, response);
    }
}