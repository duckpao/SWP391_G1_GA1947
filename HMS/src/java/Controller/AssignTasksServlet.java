package Controller;

import DAO.ManagerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Task;
import model.PurchaseOrder;
import model.PurchaseOrderItem;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

public class AssignTasksServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (!"Manager".equals(role) || userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        ManagerDAO dao = new ManagerDAO();
        dao.initializeAuditors();
        
        // Get view task details if requested
        String viewTaskId = request.getParameter("viewId");
        if (viewTaskId != null) {
            try {
                int taskId = Integer.parseInt(viewTaskId);
                Task viewTask = dao.getTaskById(taskId);
                request.setAttribute("viewTask", viewTask);
                
                // Get PO items if available
                if (viewTask != null && viewTask.getPoId() > 0) {
                    List<PurchaseOrderItem> items = dao.getPurchaseOrderItems(viewTask.getPoId());
                    request.setAttribute("poItems", items);
                    
                    // DEBUG: Print items info
                    System.out.println("=== VIEW TASK DEBUG ===");
                    System.out.println("Task ID: " + taskId);
                    System.out.println("PO ID: " + viewTask.getPoId());
                    System.out.println("Items count: " + (items != null ? items.size() : 0));
                    if (items != null) {
                        for (PurchaseOrderItem item : items) {
                            System.out.println("  - Item: " + item.getMedicineCode() + 
                                             " | Name: " + item.getMedicineName() +
                                             " | Qty: " + item.getQuantity());
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        List<Task> tasks = dao.getTasks();
        
        // ✅ THAY ĐỔI: Lấy TẤT CẢ PO (không chỉ Pending)
        List<PurchaseOrder> allOrders = dao.getAllPurchaseOrders(); // Method mới
        
        // ✅ THAY ĐỔI: Lấy cả Auditor VÀ Pharmacist
        List<model.Manager> staffList = dao.getAllStaff(); // Method mới - trả về cả Auditor và Pharmacist
        
        request.setAttribute("tasks", tasks);
        request.setAttribute("pendingOrders", allOrders); // Giữ tên cũ để không phá vỡ JSP
        request.setAttribute("auditors", staffList); // Giữ tên cũ cho tương thích
        
        // Handle messages from session
        String message = (String) session.getAttribute("message");
        String messageType = (String) session.getAttribute("messageType");
        if (message != null) {
            request.setAttribute("message", message);
            request.setAttribute("messageType", messageType);
            session.removeAttribute("message");
            session.removeAttribute("messageType");
        }
        
        request.getRequestDispatcher("/assign-tasks.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (!"Manager".equals(role) || userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        ManagerDAO dao = new ManagerDAO();
        
        try {
            if ("cancel".equals(action)) {
                // Cancel task
                int taskId = Integer.parseInt(request.getParameter("taskId"));
                boolean success = dao.cancelTask(taskId);
                
                if (success) {
                    session.setAttribute("message", "Task cancelled successfully!");
                    session.setAttribute("messageType", "success");
                } else {
                    session.setAttribute("message", "Failed to cancel task. Task may already be completed.");
                    session.setAttribute("messageType", "error");
                }
                
            } else if ("edit".equals(action)) {
                // Edit task
                int taskId = Integer.parseInt(request.getParameter("taskId"));
                int staffId = Integer.parseInt(request.getParameter("auditorId")); // Vẫn dùng tên param cũ
                String taskType = request.getParameter("taskType");
                Date deadline = Date.valueOf(request.getParameter("deadline"));
                
                boolean success = dao.updateTask(taskId, staffId, taskType, deadline);
                
                if (success) {
                    session.setAttribute("message", "Task updated successfully!");
                    session.setAttribute("messageType", "success");
                } else {
                    session.setAttribute("message", "Failed to update task. Task may not be in Pending status.");
                    session.setAttribute("messageType", "error");
                }
                
            } else {
                // Assign new task
                int poId = Integer.parseInt(request.getParameter("poId"));
                int staffId = Integer.parseInt(request.getParameter("auditorId"));
                String taskType = request.getParameter("taskType");
                Date deadline = Date.valueOf(request.getParameter("deadline"));
                
                boolean success = dao.assignTask(poId, staffId, taskType, deadline);
                
                if (success) {
                    session.setAttribute("message", "Task assigned successfully!");
                    session.setAttribute("messageType", "success");
                } else {
                    session.setAttribute("message", "Failed to assign task. Please try again.");
                    session.setAttribute("messageType", "error");
                }
            }
        } catch (Exception e) {
            session.setAttribute("message", "Error: " + e.getMessage());
            session.setAttribute("messageType", "error");
            e.printStackTrace();
        }
        
        response.sendRedirect(request.getContextPath() + "/tasks/assign");
    }
}