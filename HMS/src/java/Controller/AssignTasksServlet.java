package Controller;

import DAO.ManagerDAO;
import DAO.NotificationDAO;
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
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        List<Task> tasks = dao.getTasks();
        List<PurchaseOrder> allOrders = dao.getAllPurchaseOrders();
        List<model.Manager> staffList = dao.getAllStaff();
        
        request.setAttribute("tasks", tasks);
        request.setAttribute("pendingOrders", allOrders);
        request.setAttribute("auditors", staffList);
        
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
        String managerUsername = (String) session.getAttribute("username");
        
        if (!"Manager".equals(role) || userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        ManagerDAO dao = new ManagerDAO();
        NotificationDAO notifDAO = new NotificationDAO();
        
        try {
            if ("cancel".equals(action)) {
                // Cancel task
                int taskId = Integer.parseInt(request.getParameter("taskId"));
                
                // Lấy thông tin task trước khi cancel
                Task task = dao.getTaskById(taskId);
                
                boolean success = dao.cancelTask(taskId);
                
                if (success) {
                    // ✅ GỬI THÔNG BÁO khi cancel task
                    if (task != null) {
                        String notifTitle = "🚫 Task Cancelled";
                        String notifMessage = String.format(
                            "Your task #%d for PO #%d (%s) has been cancelled by Manager %s.",
                            taskId, task.getPoId(), task.getTaskType(), managerUsername
                        );
                        
                        notifDAO.sendNotificationToUser(
                            userId,                    // sender (Manager)
                            task.getStaffId(),        // receiver (Staff được assign)
                            notifTitle,
                            notifMessage,
                            "warning",                // type
                            "high",                   // priority
                            request.getContextPath() + "/tasks/assign" // link
                        );
                        
                        System.out.println("✓ Sent cancellation notification to user #" + task.getStaffId());
                    }
                    
                    session.setAttribute("message", "Task cancelled successfully!");
                    session.setAttribute("messageType", "success");
                } else {
                    session.setAttribute("message", "Failed to cancel task. Task may already be completed.");
                    session.setAttribute("messageType", "error");
                }
                
            } else if ("edit".equals(action)) {
                // Edit task
                int taskId = Integer.parseInt(request.getParameter("taskId"));
                int staffId = Integer.parseInt(request.getParameter("auditorId"));
                String taskType = request.getParameter("taskType");
                Date deadline = Date.valueOf(request.getParameter("deadline"));
                
                // Lấy thông tin task cũ
                Task oldTask = dao.getTaskById(taskId);
                
                boolean success = dao.updateTask(taskId, staffId, taskType, deadline);
                
                if (success) {
                    // ✅ GỬI THÔNG BÁO khi update task
                    if (oldTask != null) {
                        // Nếu đổi người assign
                        if (oldTask.getStaffId() != staffId) {
                            // Thông báo cho người CŨ
                            String oldStaffMsg = String.format(
                                "Task #%d has been reassigned to another staff member by Manager %s.",
                                taskId, managerUsername
                            );
                            notifDAO.sendNotificationToUser(
                                userId, oldTask.getStaffId(),
                                "⚠️ Task Reassigned", oldStaffMsg,
                                "info", "normal",
                                request.getContextPath() + "/tasks/assign"
                            );
                            
                            // Thông báo cho người MỚI
                            String newStaffMsg = String.format(
                                "You have been assigned to Task #%d for PO #%d (%s). Deadline: %s",
                                taskId, oldTask.getPoId(), taskType, deadline.toString()
                            );
                            notifDAO.sendNotificationToUser(
                                userId, staffId,
                                "✅ New Task Assigned", newStaffMsg,
                                "success", "high",
                                request.getContextPath() + "/tasks/assign"
                            );
                        } else {
                            // Chỉ update thông tin task
                            String updateMsg = String.format(
                                "Your task #%d has been updated by Manager %s. New deadline: %s",
                                taskId, managerUsername, deadline.toString()
                            );
                            notifDAO.sendNotificationToUser(
                                userId, staffId,
                                "📝 Task Updated", updateMsg,
                                "info", "normal",
                                request.getContextPath() + "/tasks/assign"
                            );
                        }
                        
                        System.out.println("✓ Sent update notification(s)");
                    }
                    
                    session.setAttribute("message", "Task updated successfully!");
                    session.setAttribute("messageType", "success");
                } else {
                    session.setAttribute("message", "Failed to update task. Task may not be in Pending status.");
                    session.setAttribute("messageType", "error");
                }
                
            } else {
                // ✅ ASSIGN NEW TASK - GỬI THÔNG BÁO
                int poId = Integer.parseInt(request.getParameter("poId"));
                int staffId = Integer.parseInt(request.getParameter("auditorId"));
                String taskType = request.getParameter("taskType");
                Date deadline = Date.valueOf(request.getParameter("deadline"));
                
                boolean success = dao.assignTask(poId, staffId, taskType, deadline);
                
                if (success) {
                    // ✅ GỬI THÔNG BÁO đến staff được assign
                    PurchaseOrder po = dao.getPurchaseOrderById(poId);
                    
                    String taskTypeDisplay = getTaskTypeDisplay(taskType);
                    
                    String notifTitle = "✅ New Task Assigned";
                    String notifMessage = String.format(
                        "You have been assigned a new task by Manager %s.\n" +
                        "Task Type: %s\n" +
                        "Purchase Order: #%d%s\n" +
                        "Deadline: %s\n\n" +
                        "Please check the task details and complete it before the deadline.",
                        managerUsername,
                        taskTypeDisplay,
                        poId,
                        (po != null && po.getSupplierName() != null ? " - " + po.getSupplierName() : ""),
                        deadline.toString()
                    );
                    
                    boolean notifSent = notifDAO.sendNotificationToUser(
                        userId,                              // sender (Manager)
                        staffId,                            // receiver (Staff)
                        notifTitle,
                        notifMessage,
                        "success",                          // type
                        "high",                             // priority
                        request.getContextPath() + "/tasks/assign" // link URL
                    );
                    
                    if (notifSent) {
                        System.out.println("✓ Notification sent to staff #" + staffId + " for new task assignment");
                    } else {
                        System.err.println("✗ Failed to send notification to staff #" + staffId);
                    }
                    
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
    
    /**
     * Helper method để format task type display
     */
    private String getTaskTypeDisplay(String taskType) {
        switch (taskType) {
            case "stock_in":
                return "📦 Stock In Verification";
            case "stock_out":
                return "📤 Stock Out Verification";
            case "counting":
                return "🔢 Inventory Counting";
            case "quality_check":
                return "✅ Quality Check";
            case "expiry_audit":
                return "⏰ Expiry Date Audit";
            default:
                return taskType;
        }
    }
}