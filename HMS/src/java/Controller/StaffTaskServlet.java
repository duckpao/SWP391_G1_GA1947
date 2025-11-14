package Controller;

import DAO.ManagerDAO;
import DAO.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Task;
import model.PurchaseOrder;
import model.PurchaseOrderItem;
import model.Medicine;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class StaffTaskServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");
        
        // Check if user is Pharmacist or Auditor
        if (userId == null || (!("Pharmacist".equals(role) || "Auditor".equals(role)))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String taskIdStr = request.getParameter("taskId");
        
        if (taskIdStr == null || taskIdStr.isEmpty()) {
            // No taskId - show list of all tasks for this staff
            showMyTasks(request, response, userId);
            return;
        }
     
        try {
            int taskId = Integer.parseInt(taskIdStr);
            viewTaskDetail(request, response, userId, taskId);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid task ID");
            showMyTasks(request, response, userId);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");
        String username = (String) session.getAttribute("username");
        
        if (userId == null || (!("Pharmacist".equals(role) || "Auditor".equals(role)))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("updateStatus".equals(action)) {
            updateTaskStatus(request, response, userId, username);
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/tasks");
        }
    }
    
    /**
     * Show list of all tasks assigned to this staff member
     */
    private void showMyTasks(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {
        ManagerDAO dao = new ManagerDAO();
        
        // Get all tasks for this staff
        List<Task> myTasks = dao.getTasksByStaffId(userId);
        
        request.setAttribute("myTasks", myTasks);
        request.setAttribute("pageTitle", "My Tasks");
        
        request.getRequestDispatcher("/staff/my-tasks.jsp").forward(request, response);
    }
    
    /**
     * View detailed information of a specific task
     */
    private void viewTaskDetail(HttpServletRequest request, HttpServletResponse response, 
                                int userId, int taskId)
            throws ServletException, IOException {
        ManagerDAO dao = new ManagerDAO();
        
        // Get task details
        Task task = dao.getTaskById(taskId);
        
        if (task == null) {
            request.setAttribute("error", "Task not found");
            showMyTasks(request, response, userId);
            return;
        }
        
        // Verify this task belongs to current user
        if (task.getStaffId() != userId) {
            request.setAttribute("error", "Access denied - This task is not assigned to you");
            showMyTasks(request, response, userId);
            return;
        }
        
        // Get PO details
        PurchaseOrder po = null;
        List<PurchaseOrderItem> poItems = null;
        Map<String, Medicine> medicineMap = new HashMap<>();
        
        if (task.getPoId() > 0) {
            po = dao.getPurchaseOrderById(task.getPoId());
            poItems = dao.getPurchaseOrderItems(task.getPoId());
            
            // Load medicine details
            if (poItems != null && !poItems.isEmpty()) {
                for (PurchaseOrderItem item : poItems) {
                    Medicine med = dao.getMedicineByCode(item.getMedicineCode());
                    if (med != null) {
                        medicineMap.put(item.getMedicineCode(), med);
                    }
                }
            }
        }
        
        request.setAttribute("task", task);
        request.setAttribute("purchaseOrder", po);
        request.setAttribute("poItems", poItems);
        request.setAttribute("medicineMap", medicineMap);
        
        request.getRequestDispatcher("/staff/task-detail.jsp").forward(request, response);
    }
    
    /**
     * Update task status (Pending -> In Progress -> Completed)
     */
    private void updateTaskStatus(HttpServletRequest request, HttpServletResponse response,
                                  int userId, String username)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        try {
            int taskId = Integer.parseInt(request.getParameter("taskId"));
            String newStatus = request.getParameter("newStatus");
            
            // Validate status
            if (!isValidStatus(newStatus)) {
                session.setAttribute("error", "Invalid status");
                response.sendRedirect(request.getContextPath() + "/staff/tasks?taskId=" + taskId);
                return;
            }
            
            ManagerDAO dao = new ManagerDAO();
            Task task = dao.getTaskById(taskId);
            
            if (task == null) {
                session.setAttribute("error", "Task not found");
                response.sendRedirect(request.getContextPath() + "/staff/tasks");
                return;
            }
            
            // Verify ownership
            if (task.getStaffId() != userId) {
                session.setAttribute("error", "Access denied");
                response.sendRedirect(request.getContextPath() + "/staff/tasks");
                return;
            }
            
            // Validate status transition
            if (!isValidStatusTransition(task.getStatus(), newStatus)) {
                session.setAttribute("error", "Invalid status transition from " + task.getStatus() + " to " + newStatus);
                response.sendRedirect(request.getContextPath() + "/staff/tasks?taskId=" + taskId);
                return;
            }
            
            // Update status
            boolean success = dao.updateTaskStatus(taskId, newStatus);
            
            if (success) {
                // Send notification to manager
                NotificationDAO notifDAO = new NotificationDAO();
                
                String notifTitle = getStatusNotificationTitle(newStatus);
                String notifMessage = String.format(
                    "Task #%d (Type: %s, PO #%d) has been updated to '%s' by %s",
                    taskId, task.getTaskType(), task.getPoId(), newStatus, username
                );
                
                // Get manager ID from task
                PurchaseOrder po = dao.getPurchaseOrderById(task.getPoId());
                if (po != null && po.getManagerId() > 0) {
                    notifDAO.sendNotificationToUser(
                        userId,              // sender (staff)
                        po.getManagerId(),   // receiver (manager)
                        notifTitle,
                        notifMessage,
                        getStatusNotificationType(newStatus),
                        "normal",
                        request.getContextPath() + "/tasks/assign"
                    );
                }
                
                session.setAttribute("success", "Task status updated to: " + newStatus);
            } else {
                session.setAttribute("error", "Failed to update task status");
            }
            
            response.sendRedirect(request.getContextPath() + "/staff/tasks?taskId=" + taskId);
            
        } catch (Exception e) {
            session.setAttribute("error", "Error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/staff/tasks");
        }
    }
    
    /**
     * Check if status is valid
     */
    private boolean isValidStatus(String status) {
        return status != null && 
               (status.equals("Pending") || 
                status.equals("In Progress") || 
                status.equals("Completed"));
    }
    
    /**
     * Check if status transition is valid
     */
    private boolean isValidStatusTransition(String currentStatus, String newStatus) {
        if (currentStatus.equals("Completed") || currentStatus.equals("Cancelled")) {
            return false; // Cannot change from Completed or Cancelled
        }
        
        if (currentStatus.equals("Pending")) {
            return newStatus.equals("In Progress") || newStatus.equals("Completed");
        }
        
        if (currentStatus.equals("In Progress")) {
            return newStatus.equals("Completed");
        }
        
        return false;
    }
    
    /**
     * Get notification title based on status
     */
    private String getStatusNotificationTitle(String status) {
        switch (status) {
            case "In Progress":
                return "🔄 Task Started";
            case "Completed":
                return "✅ Task Completed";
            default:
                return "📝 Task Updated";
        }
    }
    
    /**
     * Get notification type based on status
     */
    private String getStatusNotificationType(String status) {
        switch (status) {
            case "In Progress":
                return "info";
            case "Completed":
                return "success";
            default:
                return "info";
        }
    }
}