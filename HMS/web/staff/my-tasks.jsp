<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Tasks - Hospital System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: #f9fafb;
            min-height: 100vh;
            color: #374151;
        }
        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }
        /* Sidebar */
        .sidebar {
            width: 280px;
            background: white;
            color: #1f2937;
            padding: 30px 20px;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.08);
            overflow-y: auto;
            border-right: 1px solid #e5e7eb;
        }
        .sidebar-header {
            margin-bottom: 30px;
        }
        .sidebar-header h4 {
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
            color: #1f2937;
        }
        .sidebar-header hr {
            border: none;
            border-top: 1px solid #e5e7eb;
            margin: 15px 0;
        }
        .nav-link {
            color: #6b7280;
            text-decoration: none;
            padding: 12px 16px;
            border-radius: 10px;
            margin: 6px 0;
            display: flex;
            align-items: center;
            gap: 12px;
            transition: all 0.3s ease;
            font-size: 14px;
            font-weight: 500;
        }
        .nav-link:hover,
        .nav-link.active {
            background: #f3f4f6;
            color: #3b82f6;
            transform: translateX(4px);
        }
        .nav-divider {
            border: none;
            border-top: 1px solid #e5e7eb;
            margin: 15px 0;
        }
        .main-content {
            flex: 1;
            padding: 40px;
            overflow-y: auto;
            background: #f9fafb;
            min-height: 100vh;
        }
        .page-header {
            margin-bottom: 30px;
        }
        .page-header h2 {
            font-size: 32px;
            font-weight: 700;
            color: #1f2937;
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 0;
        }
        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 24px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            border-left: 5px solid;
            border-top: 1px solid #e5e7eb;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.12);
        }
        .stat-card.pending {
            border-left-color: #6b7280;
        }
        .stat-card.in-progress {
            border-left-color: #3b82f6;
        }
        .stat-card.completed {
            border-left-color: #10b981;
        }
        .stat-card.overdue {
            border-left-color: #ef4444;
        }
        .stat-content {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
        }
        .stat-info h6 {
            font-size: 13px;
            font-weight: 600;
            color: #9ca3af;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .stat-info h3 {
            font-size: 28px;
            font-weight: 700;
            color: #1f2937;
            margin: 0;
        }
        .stat-icon {
            font-size: 32px;
            opacity: 0.8;
        }
        .stat-card.pending .stat-icon {
            color: #6b7280;
        }
        .stat-card.in-progress .stat-icon {
            color: #3b82f6;
        }
        .stat-card.completed .stat-icon {
            color: #10b981;
        }
        .stat-card.overdue .stat-icon {
            color: #ef4444;
        }
        /* Dashboard Card */
        .dashboard-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            margin-bottom: 30px;
            overflow: hidden;
            border-top: 3px solid #3b82f6;
        }
        .card-header {
            background: #f9fafb;
            padding: 24px;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .card-header h5 {
            font-size: 18px;
            font-weight: 700;
            color: #1f2937;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .card-body {
            padding: 24px;
        }
        /* Filter Buttons */
        .filter-group {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }
        .filter-btn {
            padding: 8px 16px;
            border-radius: 8px;
            border: 2px solid #e5e7eb;
            background: white;
            color: #6b7280;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .filter-btn:hover {
            border-color: #3b82f6;
            color: #3b82f6;
        }
        .filter-btn.active {
            background: #3b82f6;
            color: white;
            border-color: #3b82f6;
        }
        /* Task Table */
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }
        table thead {
            background: #f9fafb;
            border-bottom: 2px solid #e5e7eb;
        }
        table th {
            padding: 16px;
            text-align: left;
            font-weight: 600;
            color: #374151;
        }
        table td {
            padding: 16px;
            border-bottom: 1px solid #e5e7eb;
        }
        table tbody tr {
            transition: background 0.2s ease;
        }
        table tbody tr:hover {
            background: #f9fafb;
        }
        /* Status Badges */
        .status-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-pending {
            background: #f3f4f6;
            color: #374151;
        }
        .status-in-progress {
            background: #dbeafe;
            color: #1e40af;
        }
        .status-completed {
            background: #d1fae5;
            color: #065f46;
        }
        .status-cancelled {
            background: #fee2e2;
            color: #991b1b;
        }
        /* Priority Badge */
        .priority-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
        }
        .priority-critical {
            background: #fee2e2;
            color: #991b1b;
        }
        .priority-high {
            background: #fef3c7;
            color: #92400e;
        }
        .priority-medium {
            background: #dbeafe;
            color: #1e40af;
        }
        .priority-low {
            background: #f3f4f6;
            color: #374151;
        }
        /* Buttons */
        .btn {
            padding: 8px 16px;
            border-radius: 8px;
            border: none;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .btn-primary {
            background: #3b82f6;
            color: white;
        }
        .btn-primary:hover {
            background: #2563eb;
        }
        .btn-success {
            background: #10b981;
            color: white;
        }
        .btn-success:hover {
            background: #059669;
        }
        .btn-warning {
            background: #f59e0b;
            color: white;
        }
        .btn-warning:hover {
            background: #d97706;
        }
        /* Alert */
        .alert {
            padding: 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .alert-success {
            background: #dcfce7;
            color: #166534;
            border: 1px solid #86efac;
        }
        .alert-danger {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fca5a5;
        }
        .alert-warning {
            background: #fef3c7;
            color: #92400e;
            border: 1px solid #fcd34d;
        }
        .alert-info {
            background: #dbeafe;
            color: #1e40af;
            border: 1px solid #93c5fd;
        }
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }
        .empty-state i {
            font-size: 64px;
            color: #d1d5db;
            margin-bottom: 20px;
        }
        .empty-state h4 {
            color: #6b7280;
            margin-bottom: 8px;
        }
        .empty-state p {
            color: #9ca3af;
        }
        /* Deadline Warning */
        .deadline-warning {
            color: #dc2626;
            font-weight: 600;
        }
        .deadline-soon {
            color: #f59e0b;
            font-weight: 600;
        }
        /* Responsive */
        @media (max-width: 768px) {
            .dashboard-container {
                flex-direction: column;
            }
            .sidebar {
                width: 100%;
                padding: 20px;
            }
            .main-content {
                padding: 20px;
            }
            .page-header h2 {
                font-size: 24px;
            }
            .stats-grid {
                grid-template-columns: 1fr;
            }
            table {
                font-size: 12px;
            }
            table th,
            table td {
                padding: 12px 8px;
            }
        }
    </style>
</head>
<%@ include file="/admin/header.jsp" %>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <nav>
                <c:choose>
                    <c:when test="${sessionScope.role == 'Auditor'}">
                        <a class="nav-link" href="${pageContext.request.contextPath}/auditor-dashboard">
                            <i class="bi bi-speedometer2"></i> Back to Dashboard
                        </a>
                    </c:when>
                    <c:when test="${sessionScope.role == 'Pharmacist'}">
                        <a class="nav-link" href="${pageContext.request.contextPath}/view-medicine">
                            <i class="bi bi-speedometer2"></i> Back to Dashboard
                        </a>
                    </c:when>
                </c:choose>
                
                <a class="nav-link active" href="${pageContext.request.contextPath}/staff/tasks">
                    <i class="bi bi-list-check"></i> My Tasks
                </a>
                
            </nav>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="page-header">
                <h2><i class="bi bi-list-check"></i> My Assigned Tasks</h2>
            </div>

            <!-- Messages -->
            <c:if test="${not empty sessionScope.success}">
                <div class="alert alert-success">
                    <i class="bi bi-check-circle"></i>
                    ${sessionScope.success}
                </div>
                <c:remove var="success" scope="session"/>
            </c:if>
            
            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-danger">
                    <i class="bi bi-exclamation-circle"></i>
                    ${sessionScope.error}
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>

            <!-- Statistics -->
            <div class="stats-grid">
                <c:set var="pendingCount" value="0"/>
                <c:set var="inProgressCount" value="0"/>
                <c:set var="completedCount" value="0"/>
                <c:set var="overdueCount" value="0"/>
                
                <c:forEach items="${myTasks}" var="task">
                    <c:if test="${task.status == 'Pending'}">
                        <c:set var="pendingCount" value="${pendingCount + 1}"/>
                    </c:if>
                    <c:if test="${task.status == 'In Progress'}">
                        <c:set var="inProgressCount" value="${inProgressCount + 1}"/>
                    </c:if>
                    <c:if test="${task.status == 'Completed'}">
                        <c:set var="completedCount" value="${completedCount + 1}"/>
                    </c:if>
                    <%-- Check if overdue --%>
                    <jsp:useBean id="now" class="java.util.Date"/>
                    <c:if test="${task.deadline < now && task.status != 'Completed'}">
                        <c:set var="overdueCount" value="${overdueCount + 1}"/>
                    </c:if>
                </c:forEach>

                <div class="stat-card pending">
                    <div class="stat-content">
                        <div class="stat-info">
                            <h6>Pending Tasks</h6>
                            <h3>${pendingCount}</h3>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-clock-history"></i>
                        </div>
                    </div>
                </div>

                <div class="stat-card in-progress">
                    <div class="stat-content">
                        <div class="stat-info">
                            <h6>In Progress</h6>
                            <h3>${inProgressCount}</h3>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-arrow-repeat"></i>
                        </div>
                    </div>
                </div>

                <div class="stat-card completed">
                    <div class="stat-content">
                        <div class="stat-info">
                            <h6>Completed</h6>
                            <h3>${completedCount}</h3>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-check-circle"></i>
                        </div>
                    </div>
                </div>

                <div class="stat-card overdue">
                    <div class="stat-content">
                        <div class="stat-info">
                            <h6>Overdue</h6>
                            <h3>${overdueCount}</h3>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-exclamation-triangle"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tasks List -->
            <div class="dashboard-card">
                <div class="card-header">
                    <h5><i class="bi bi-list-ul"></i> All Tasks</h5>
                    <div class="filter-group">
                        <button class="filter-btn active" onclick="filterTasks('all')">
                            <i class="bi bi-list"></i> All
                        </button>
                        <button class="filter-btn" onclick="filterTasks('Pending')">
                            <i class="bi bi-clock"></i> Pending
                        </button>
                        <button class="filter-btn" onclick="filterTasks('In Progress')">
                            <i class="bi bi-arrow-repeat"></i> In Progress
                        </button>
                        <button class="filter-btn" onclick="filterTasks('Completed')">
                            <i class="bi bi-check"></i> Completed
                        </button>
                    </div>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${empty myTasks}">
                            <div class="empty-state">
                                <i class="bi bi-inbox"></i>
                                <h4>No Tasks Assigned</h4>
                                <p>You don't have any tasks assigned yet.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table id="tasksTable">
                                <thead>
                                    <tr>
                                        <th>Task ID</th>
                                        <th>Type</th>
                                        <th>Purchase Order</th>
                                        <th>Deadline</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${myTasks}" var="task">
                                        <tr class="task-row" data-status="${task.status}">
                                            <td><strong>#${task.taskId}</strong></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${task.taskType == 'stock_in'}">📦 Stock In</c:when>
                                                    <c:when test="${task.taskType == 'stock_out'}">📤 Stock Out</c:when>
                                                    <c:when test="${task.taskType == 'counting'}">🔢 Counting</c:when>
                                                    <c:when test="${task.taskType == 'quality_check'}">✅ Quality</c:when>
                                                    <c:when test="${task.taskType == 'expiry_audit'}">⏰ Expiry</c:when>
                                                    <c:otherwise>${task.taskType}</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty task.poId && task.poId > 0}">
                                                        <strong>PO #${task.poId}</strong>
                                                        <c:if test="${not empty task.poNotes}">
                                                            <br><small style="color: #6b7280;">${task.poNotes}</small>
                                                        </c:if>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: #9ca3af;">N/A</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <i class="bi bi-calendar"></i> ${task.deadline}
                                                <jsp:useBean id="currentDate" class="java.util.Date"/>
                                                <c:if test="${task.deadline < currentDate && task.status != 'Completed'}">
                                                    <br><span class="deadline-warning">
                                                        <i class="bi bi-exclamation-triangle"></i> Overdue
                                                    </span>
                                                </c:if>
                                            </td>
                                            <td>
                                                <span class="status-badge status-${task.status == 'Pending' ? 'pending' : task.status == 'In Progress' ? 'in-progress' : task.status == 'Completed' ? 'completed' : 'cancelled'}">
                                                    ${task.status}
                                                </span>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/staff/tasks?taskId=${task.taskId}" 
                                                   class="btn btn-primary">
                                                    <i class="bi bi-eye"></i> View Details
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Filter tasks by status
        function filterTasks(status) {
            const rows = document.querySelectorAll('.task-row');
            const buttons = document.querySelectorAll('.filter-btn');
            
            // Update active button
            buttons.forEach(btn => btn.classList.remove('active'));
            event.target.closest('.filter-btn').classList.add('active');
            
            // Filter rows
            rows.forEach(row => {
                if (status === 'all') {
                    row.style.display = '';
                } else {
                    if (row.dataset.status === status) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                }
            });
        }

        // Auto-hide alerts after 5 seconds
        setTimeout(() => {
            document.querySelectorAll('.alert').forEach(alert => {
                alert.style.transition = 'opacity 0.5s';
                alert.style.opacity = '0';
                setTimeout(() => alert.remove(), 500);
            });
        }, 5000);
    </script>
</body>
<%@ include file="/admin/footer.jsp" %>
</html>