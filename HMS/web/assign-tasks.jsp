<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assign Staff Tasks - Hospital System</title>
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
        /* Sidebar styling */
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
            display: flex;
            justify-content: space-between;
            align-items: center;
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
        /* Updated stat cards */
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
            border-left: 5px solid #3b82f6;
            border-top: 1px solid #e5e7eb;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.12);
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
            color: #3b82f6;
        }
        /* Card styling */
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
        table tbody tr:hover {
            background: #f9fafb;
        }
        .status-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-draft {
            background: #e5e7eb;
            color: #374151;
        }
        .status-sent {
            background: #dbeafe;
            color: #1e40af;
        }
        .status-rejected {
            background: #fee2e2;
            color: #991b1b;
        }
        .status-cancelled {
            background: #f3f4f6;
            color: #374151;
        }
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
        .btn-info {
            background: #3b82f6;
            color: white;
        }
        .btn-info:hover {
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
        .btn-danger {
            background: #ef4444;
            color: white;
        }
        .btn-danger:hover {
            background: #dc2626;
        }
        .btn-secondary {
            background: #6b7280;
            color: white;
        }
        .btn-secondary:hover {
            background: #4b5563;
        }
        .details-row {
            background: #f9fafb;
        }
        .details-content {
            padding: 24px;
        }
        .details-content h6 {
            font-size: 14px;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .details-table {
            width: 100%;
            margin-bottom: 20px;
        }
        .details-table tr {
            border-bottom: 1px solid #e5e7eb;
        }
        .details-table td {
            padding: 12px 0;
            font-size: 14px;
        }
        .details-table td:first-child {
            font-weight: 600;
            color: #374151;
            width: 150px;
        }
        .item-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .item-list li {
            padding: 20px;
            border: 1px solid #e5e7eb;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            background: white;
            margin-bottom: 16px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }
        .item-list li:hover {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            border-color: #3b82f6;
        }
        .medicine-main-info {
            font-size: 15px;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 8px;
        }
        .medicine-detail-row {
            display: flex;
            flex-wrap: wrap;
            gap: 16px;
            margin-top: 8px;
        }
        .medicine-detail-item {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            color: #6b7280;
        }
        .medicine-code-badge {
            background: #f3f4f6;
            padding: 4px 8px;
            border-radius: 4px;
            font-family: monospace;
            font-size: 12px;
            color: #374151;
        }
        .quantity-badge {
            background: #3b82f6;
            color: white;
            padding: 8px 16px;
            border-radius: 6px;
            font-weight: 600;
        }
        .alert {
            padding: 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .alert-info {
            background: #dbeafe;
            color: #1e40af;
            border: 1px solid #93c5fd;
        }
        .alert-warning {
            background: #fef3c7;
            color: #92400e;
            border: 1px solid #fcd34d;
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
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
        }
        .modal.show {
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .modal-content {
            background: white;
            border-radius: 12px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            max-width: 500px;
            width: 90%;
        }
        .modal-header {
            padding: 24px;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .modal-header h5 {
            font-size: 18px;
            font-weight: 700;
            color: #1f2937;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .modal-body {
            padding: 24px;
        }
        .modal-footer {
            padding: 24px;
            border-top: 1px solid #e5e7eb;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }
        .close-btn {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: #6b7280;
        }
        /* Scrollbar styling */
        ::-webkit-scrollbar {
            width: 8px;
        }
        ::-webkit-scrollbar-track {
            background: rgba(0, 0, 0, 0.05);
        }
        ::-webkit-scrollbar-thumb {
            background: rgba(0, 0, 0, 0.2);
            border-radius: 4px;
        }
        ::-webkit-scrollbar-thumb:hover {
            background: rgba(0, 0, 0, 0.3);
        }
        /* Responsive design */
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
            .card-header {
                flex-direction: column;
                align-items: flex-start;
            }
            table {
                font-size: 12px;
            }
            table th,
            table td {
                padding: 12px 8px;
            }
        }
        /* Additional styles from original page */
        .status-pending { background-color: #6c757d; color: white; }
        .status-in-progress { background-color: #0dcaf0; color: white; }
        .status-completed { background-color: #28a745; color: white; }
        .status-cancelled { background-color: #dc3545; color: white; }
        .info-row {
            padding: 8px 0;
            border-bottom: 1px solid #e5e7eb;
        }
        .info-row:last-child { border-bottom: none; }
        .info-label {
            font-weight: 600;
            color: #495057;
            display: inline-block;
            width: 180px;
        }
        .role-badge {
            padding: 2px 8px;
            border-radius: 3px;
            font-size: 0.75rem;
            margin-left: 5px;
            font-weight: 600;
        }
        .role-auditor { background-color: #0dcaf0; color: white; }
        .role-pharmacist { background-color: #198754; color: white; }
    </style>
</head>
<%@ include file="/admin/header.jsp" %>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <h4><i class="bi bi-hospital"></i> Manager</h4>
                <hr class="sidebar-divider">
            </div>
            <nav>
                    <a class="nav-link " href="${pageContext.request.contextPath}/manager-dashboard">
                        <i class="bi bi-speedometer2"></i> Dashboard
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/create-stock">
                        <i class="bi bi-plus-circle"></i> New Stock Request
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/cancelled-tasks">
                        <i class="bi bi-ban"></i> Cancelled Orders
                    </a>
                    <hr class="nav-divider">

                    <!-- Order History Section -->
                    <h6 style="font-size: 11px; font-weight: 600; color: #9ca3af; margin-bottom: 8px; text-transform: uppercase; letter-spacing: 0.5px;">
                        ORDER HISTORY
                    </h6>
                    <a class="nav-link" href="${pageContext.request.contextPath}/manager/sent-orders">
                        <i class="bi bi-send-check"></i> Sent Orders
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/manager/intransit-orders">
                        <i class="bi bi-truck"></i> In Transit
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/manager/completed-orders">
                        <i class="bi bi-check-circle"></i> Completed
                    </a>

                    <hr class="nav-divider">

                    <!-- Reports Section -->
                    <a class="nav-link" href="${pageContext.request.contextPath}/inventory-report">
                        <i class="bi bi-boxes"></i> Inventory Report
                    </a>
                    <a class="nav-link " href="${pageContext.request.contextPath}/expiry-report?days=30">
                        <i class="bi bi-calendar-times"></i> Expiry Report
                    </a>
                    <a class="nav-link " href="${pageContext.request.contextPath}/stock-alerts">
                        <i class="bi bi-exclamation-triangle"></i> Stock Alerts
                    </a>

                    <hr class="nav-divider">

                    <!-- Management Section -->
                    <a class="nav-link active" href="${pageContext.request.contextPath}/tasks/assign">
                        <i class="bi bi-pencil"></i> Assign Tasks
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/manage/transit">
                        <i class="bi bi-truck"></i> Transit Orders
                    </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/manager/rate-supplier">
                            <i class="bi bi-star-fill"></i>
                            Rate Suppliers
                            <c:if test="${unratedCount > 0}">
                                <span class="badge bg-warning">${unratedCount}</span>
                            </c:if>
                        </a>
                </nav>
        </div>
        <!-- Main Content -->
        <div class="main-content">
            <div class="page-header">
                <h2><i class="bi bi-pencil-square"></i> Assign Staff Tasks</h2>
            </div>
            <!-- Message Alert -->
            <c:if test="${not empty message}">
                <div class="alert alert-${messageType == 'success' ? 'success' : 'danger'}">
                    <i class="bi bi-${messageType == 'success' ? 'check-circle' : 'exclamation-circle'}"></i>
                    ${message}
                </div>
            </c:if>
            <!-- Task Assignment Form -->
            <div class="dashboard-card">
                <div class="card-header">
                    <h5><i class="bi bi-plus-circle"></i> New Task Assignment</h5>
                </div>
                <div class="card-body">
                    <form method="post">
                        <div style="display: grid; grid-template-columns: 1fr; gap: 20px;">
                            <div>
                                <label style="font-weight: 600; margin-bottom: 8px; display: block;">
                                    <i class="bi bi-file-earmark-text"></i> Purchase Order *
                                </label>
                                <select name="poId" required id="poSelect" style="width: 100%; padding: 12px; border: 1px solid #e5e7eb; border-radius: 8px;">
                                    <option value="">-- Select Purchase Order --</option>
                                    <c:forEach items="${pendingOrders}" var="po">
                                        <option value="${po.poId}"
                                                data-supplier="${po.supplierName}"
                                                data-date="${po.orderDate}"
                                                data-delivery="${po.expectedDeliveryDate}"
                                                data-status="${po.status}"
                                                data-notes="${po.notes}">
                                            PO #${po.poId} - ${po.supplierName} | Order: ${po.orderDate} | Status: ${po.status}<c:if test="${not empty po.notes}"> | ${po.notes}</c:if>
                                        </option>
                                    </c:forEach>
                                </select>
                                <small style="color: #6b7280; font-size: 12px;">
                                    <i class="bi bi-info-circle"></i> Hiển thị tất cả Purchase Orders (mọi trạng thái)
                                </small>
                            </div>
                        </div>
                        <!-- Selected PO Details -->
                        <div id="poDetails" style="margin-top: 20px; padding: 16px; background: #dbeafe; border-radius: 8px; display: none;">
                            <h6 style="font-weight: 700; margin-bottom: 12px;"><i class="bi bi-info-circle"></i> Selected PO Details</h6>
                            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 12px;">
                                <div>
                                    <strong>Supplier:</strong>
                                    <p id="poSupplier" style="margin: 0;">-</p>
                                </div>
                                <div>
                                    <strong>Order Date:</strong>
                                    <p id="poDate" style="margin: 0;">-</p>
                                </div>
                                <div>
                                    <strong>Expected Delivery:</strong>
                                    <p id="poDelivery" style="margin: 0;">-</p>
                                </div>
                                <div>
                                    <strong>Status:</strong>
                                    <p id="poStatus" style="margin: 0;">-</p>
                                </div>
                            </div>
                            <div id="poNotesRow" style="margin-top: 12px; display: none;">
                                <strong>Notes:</strong>
                                <p id="poNotes" style="margin: 0; color: #6b7280;">-</p>
                            </div>
                        </div>
                        <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-top: 20px;">
                            <div>
                                <label style="font-weight: 600; margin-bottom: 8px; display: block;">
                                    <i class="bi bi-people"></i> Assign to Staff *
                                </label>
                                <select name="auditorId" required style="width: 100%; padding: 12px; border: 1px solid #e5e7eb; border-radius: 8px;">
                                    <option value="">-- Select Staff Member --</option>
                                    <c:forEach items="${auditors}" var="staff">
                                        <option value="${staff.userId}">
                                            ${staff.username} - ${staff.email}
                                            <c:choose>
                                                <c:when test="${staff.role == 'Auditor'}">
                                                    [Auditor]
                                                </c:when>
                                                <c:when test="${staff.role == 'Pharmacist'}">
                                                    [Pharmacist]
                                                </c:when>
                                            </c:choose>
                                        </option>
                                    </c:forEach>
                                </select>
                                <small style="color: #6b7280; font-size: 12px;">
                                    <i class="bi bi-shield-lock"></i> Auditor | <i class="bi bi-capsule-pill"></i> Pharmacist
                                </small>
                            </div>
                            <div>
                                <label style="font-weight: 600; margin-bottom: 8px; display: block;">
                                    <i class="bi bi-list-task"></i> Task Type *
                                </label>
                                <select name="taskType" required style="width: 100%; padding: 12px; border: 1px solid #e5e7eb; border-radius: 8px;">
                                    <option value="">-- Select Type --</option>
                                    <option value="stock_in">📦 Stock In Verification</option>
                                    <option value="stock_out">📤 Stock Out Verification</option>
                                    <option value="counting">🔢 Inventory Counting</option>
                                    <option value="quality_check">✅ Quality Check</option>
                                    <option value="expiry_audit">⏰ Expiry Date Audit</option>
                                </select>
                            </div>
                            <div>
                                <label style="font-weight: 600; margin-bottom: 8px; display: block;">
                                    <i class="bi bi-calendar-event"></i> Deadline *
                                </label>
                                <input type="date" name="deadline" required min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" style="width: 100%; padding: 12px; border: 1px solid #e5e7eb; border-radius: 8px;">
                            </div>
                        </div>
                        <div style="margin-top: 24px; display: flex; gap: 12px;">
                            <button type="submit" class="btn btn-success"><i class="bi bi-save"></i> Assign Task</button>
                            <button type="reset" class="btn btn-secondary"><i class="bi bi-arrow-counterclockwise"></i> Reset</button>
                        </div>
                    </form>
                </div>
            </div>
            <!-- Assigned Tasks Section -->
            <div class="dashboard-card">
                <div class="card-header">
                    <h5><i class="bi bi-list-check"></i> Assigned Tasks</h5>
                </div>
                <div class="card-body">
                    <c:if test="${empty tasks}">
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle"></i> No tasks have been assigned yet.
                        </div>
                    </c:if>
                    <c:if test="${not empty tasks}">
                        <table>
                            <thead>
                                <tr>
                                    <th>Task ID</th>
                                    <th>Purchase Order</th>
                                    <th>Staff Member</th>
                                    <th>Task Type</th>
                                    <th>Deadline</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${tasks}" var="task">
                                    <tr>
                                        <td><strong>#${task.taskId}</strong></td>
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
                                        <td><i class="bi bi-person"></i> ${task.staffName}</td>
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
                                        <td><i class="bi bi-calendar"></i> ${task.deadline}</td>
                                        <td>
                                            <span class="status-badge status-${task.status == 'Pending' ? 'pending' : task.status == 'In Progress' ? 'in-progress' : task.status == 'Completed' ? 'completed' : 'cancelled'}">
                                                ${task.status}
                                            </span>
                                        </td>
                                        <td>
                                            <button class="btn btn-info" onclick="viewTask(${task.taskId})">
                                                <i class="bi bi-eye"></i> View
                                            </button>
                                            <c:if test="${task.status == 'Pending'}">
                                                <button class="btn btn-warning" onclick="editTask(${task.taskId})">
                                                    <i class="bi bi-pencil"></i> Edit
                                                </button>
                                                <button class="btn btn-danger" onclick="cancelTask(${task.taskId})">
                                                    <i class="bi bi-x-circle"></i> Cancel
                                                </button>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
    <!-- View Task Modal -->
    <div id="viewModal" class="modal">
        <div class="modal-content" style="max-width: 800px;">
            <div class="modal-header" style="background: #dbeafe; border-bottom: 1px solid #93c5fd;">
                <h5 style="color: #1e40af;"><i class="bi bi-eye"></i> Task Details</h5>
                <button class="close-btn" onclick="closeModal('viewModal')">&times;</button>
            </div>
            <div class="modal-body" id="viewModalBody">
                <!-- Content loaded via JS -->
            </div>
        </div>
    </div>
    <!-- Edit Task Modal -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <div class="modal-header" style="background: #fef3c7; border-bottom: 1px solid #fcd34d;">
                <h5 style="color: #92400e;"><i class="bi bi-pencil"></i> Edit Task</h5>
                <button class="close-btn" onclick="closeModal('editModal')">&times;</button>
            </div>
            <form method="post" id="editForm">
                <div class="modal-body" id="editModalBody">
                    <!-- Content loaded via JS -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('editModal')">Cancel</button>
                    <button type="submit" class="btn btn-warning"><i class="bi bi-save"></i> Update Task</button>
                </div>
            </form>
        </div>
    </div>
    <!-- Cancel Task Modal -->
    <div id="cancelModal" class="modal">
        <div class="modal-content">
            <div class="modal-header" style="background: #fee2e2; border-bottom: 1px solid #fca5a5;">
                <h5 style="color: #991b1b;"><i class="bi bi-x-circle"></i> Cancel Task</h5>
                <button class="close-btn" onclick="closeModal('cancelModal')">&times;</button>
            </div>
            <form method="post">
                <div class="modal-body">
                    <input type="hidden" name="action" value="cancel">
                    <input type="hidden" name="taskId" id="cancelTaskId">
                    <p>Are you sure you want to cancel this task?</p>
                    <p style="color: #dc2626;"><strong>This action cannot be undone.</strong></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('cancelModal')">No, Keep It</button>
                    <button type="submit" class="btn btn-danger"><i class="bi bi-x-circle"></i> Yes, Cancel Task</button>
                </div>
            </form>
        </div>
    </div>
    <script>
        // PO Select Change
        document.getElementById('poSelect').addEventListener('change', function() {
            const selected = this.options[this.selectedIndex];
            const details = document.getElementById('poDetails');
            const notesRow = document.getElementById('poNotesRow');
            if (this.value) {
                document.getElementById('poSupplier').textContent = selected.dataset.supplier || '-';
                document.getElementById('poDate').textContent = selected.dataset.date || '-';
                document.getElementById('poDelivery').textContent = selected.dataset.delivery || '-';
                document.getElementById('poStatus').textContent = selected.dataset.status || '-';
                const notes = selected.dataset.notes;
                if (notes && notes.trim() !== '' && notes !== 'null') {
                    document.getElementById('poNotes').textContent = notes;
                    notesRow.style.display = 'block';
                } else {
                    notesRow.style.display = 'none';
                }
                details.style.display = 'block';
            } else {
                details.style.display = 'none';
                notesRow.style.display = 'none';
            }
        });
        function viewTask(taskId) {
            document.getElementById('viewModal').classList.add('show');
            fetch(`${pageContext.request.contextPath}/tasks/assign?viewId=` + taskId)
                .then(res => res.text())
                .then(html => {
                    const parser = new DOMParser();
                    const doc = parser.parseFromString(html, 'text/html');
                    const viewContent = doc.querySelector('[data-task-view]');
                    if (viewContent) {
                        document.getElementById('viewModalBody').innerHTML = viewContent.innerHTML;
                    } else {
                        document.getElementById('viewModalBody').innerHTML = '<div class="alert alert-danger">Error loading details.</div>';
                    }
                })
                .catch(() => {
                    document.getElementById('viewModalBody').innerHTML = '<div class="alert alert-danger">Network error.</div>';
                });
        }
        function editTask(taskId) {
            document.getElementById('editModal').classList.add('show');
            fetch(`${pageContext.request.contextPath}/tasks/assign?viewId=` + taskId)
                .then(res => res.text())
                .then(html => {
                    const parser = new DOMParser();
                    const doc = parser.parseFromString(html, 'text/html');
                    const editContent = doc.querySelector('[data-task-edit]');
                    if (editContent) {
                        document.getElementById('editModalBody').innerHTML = editContent.innerHTML;
                    } else {
                        document.getElementById('editModalBody').innerHTML = '<div class="alert alert-danger">Error loading form.</div>';
                    }
                })
                .catch(() => {
                    document.getElementById('editModalBody').innerHTML = '<div class="alert alert-danger">Network error.</div>';
                });
        }
        function cancelTask(taskId) {
            document.getElementById('cancelTaskId').value = taskId;
            document.getElementById('cancelModal').classList.add('show');
        }
        function closeModal(id) {
            document.getElementById(id).classList.remove('show');
        }
        window.onclick = function(event) {
            ['viewModal', 'editModal', 'cancelModal'].forEach(id => {
                const modal = document.getElementById(id);
                if (event.target === modal) modal.classList.remove('show');
            });
        }
        setTimeout(() => {
            document.querySelectorAll('.alert').forEach(alert => alert.style.display = 'none');
        }, 5000);
    </script>
    <!-- Hidden AJAX content -->
    <c:if test="${not empty viewTask}">
        <div style="display: none;" data-task-view>
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px;">
                <div>
                    <h6><i class="bi bi-info-circle"></i> Task Information</h6>
                    <table class="details-table">
                        <tr><td>Task ID:</td><td>#${viewTask.taskId}</td></tr>
                        <tr><td>Task Type:</td><td>
                            <c:choose>
                                <c:when test="${viewTask.taskType == 'stock_in'}">📦 Stock In Verification</c:when>
                                <c:when test="${viewTask.taskType == 'stock_out'}">📤 Stock Out Verification</c:when>
                                <c:when test="${viewTask.taskType == 'counting'}">🔢 Inventory Counting</c:when>
                                <c:when test="${viewTask.taskType == 'quality_check'}">✅ Quality Check</c:when>
                                <c:when test="${viewTask.taskType == 'expiry_audit'}">⏰ Expiry Date Audit</c:when>
                                <c:otherwise>${viewTask.taskType}</c:otherwise>
                            </c:choose>
                        </td></tr>
                        <tr><td>Status:</td><td>${viewTask.status}</td></tr>
                        <tr><td>Assigned Staff:</td><td>${viewTask.staffName}</td></tr>
                        <tr><td>Deadline:</td><td>${viewTask.deadline}</td></tr>
                        <tr><td>Created At:</td><td>${viewTask.createdAt}</td></tr>
                    </table>
                </div>
                <c:if test="${viewTask.poId > 0}">
                    <div>
                        <h6><i class="bi bi-file-earmark-text"></i> Purchase Order Information</h6>
                        <table class="details-table">
                            <tr><td>PO ID:</td><td>#${viewTask.poId}</td></tr>
                            <c:if test="${not empty viewTask.poNotes}">
                                <tr><td>PO Notes:</td><td>${viewTask.poNotes}</td></tr>
                            </c:if>
                        </table>
                    </div>
                </c:if>
            </div>
            <c:if test="${viewTask.poId > 0 && not empty poItems}">
                <div style="margin-top: 24px;">
                    <h6><i class="bi bi-capsule"></i> Order Items</h6>
                    <c:if test="${empty poItems}">
                        <div class="alert alert-warning">
                            <i class="bi bi-exclamation-triangle"></i> No items found
                        </div>
                    </c:if>
                    <c:if test="${not empty poItems}">
                        <ul class="item-list">
                            <c:forEach items="${poItems}" var="item">
                                <li>
                                    <div style="flex: 1;">
                                        <div class="medicine-main-info">
                                            ${not empty item.medicineName ? item.medicineName : 'Unknown Medicine'}
                                            <c:if test="${not empty item.medicineStrength}">
                                                <span style="color: #3b82f6; font-weight: 600;">${item.medicineStrength}</span>
                                            </c:if>
                                            <span class="medicine-code-badge">${item.medicineCode}</span>
                                        </div>
                                        <div class="medicine-detail-row">
                                            <c:if test="${not empty item.medicineDosageForm}">
                                                <div class="medicine-detail-item">
                                                    <i class="bi bi-capsule"></i> ${item.medicineDosageForm}
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty item.medicineCategory}">
                                                <div class="medicine-detail-item">
                                                    <i class="bi bi-tag"></i> ${item.medicineCategory}
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty item.medicineManufacturer}">
                                                <div class="medicine-detail-item">
                                                    <i class="bi bi-building"></i> ${item.medicineManufacturer}
                                                </div>
                                            </c:if>
                                        </div>
                                        <div class="medicine-detail-row" style="margin-top: 6px;">
                                            <c:if test="${not empty item.activeIngredient}">
                                                <div class="medicine-detail-item" style="color: #059669;">
                                                    <i class="bi bi-droplet"></i> <strong>Active:</strong> ${item.activeIngredient}
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty item.unit}">
                                                <div class="medicine-detail-item">
                                                    <i class="bi bi-box"></i> <strong>Unit:</strong> ${item.unit}
                                                </div>
                                            </c:if>
                                        </div>
                                        <c:set var="medicine" value="${medicineMap[item.medicineCode]}" />
                                        <c:if test="${not empty medicine}">
                                            <div class="medicine-detail-row" style="margin-top: 6px;">
                                                <c:if test="${not empty medicine.countryOfOrigin}">
                                                    <div class="medicine-detail-item">
                                                        <i class="bi bi-globe"></i> ${medicine.countryOfOrigin}
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty medicine.drugGroup}">
                                                    <div class="medicine-detail-item">
                                                        <i class="bi bi-collection"></i> ${medicine.drugGroup}
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty medicine.drugType}">
                                                    <div class="medicine-detail-item">
                                                        <span style="padding: 2px 8px; background: #dbeafe; color: #1e40af; border-radius: 4px; font-size: 11px;">
                                                            ${medicine.drugType}
                                                        </span>
                                                    </div>
                                                </c:if>
                                            </div>
                                            <c:if test="${not empty medicine.description}">
                                                <div style="margin-top: 8px; padding: 8px; background: #f9fafb; border-radius: 6px; border-left: 3px solid #3b82f6;">
                                                    <div style="font-size: 11px; font-weight: 600; color: #6b7280; margin-bottom: 4px;">
                                                        <i class="bi bi-info-circle"></i> DESCRIPTION
                                                    </div>
                                                    <div style="font-size: 12px; color: #374151; line-height: 1.4;">
                                                        ${medicine.description}
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:if>
                                        <div style="margin-top: 10px; display: flex; align-items: center; gap: 8px; flex-wrap: wrap;">
                                            <c:if test="${not empty item.priority}">
                                                <span class="status-badge" style="font-size: 11px;
                                                      background: ${item.priority == 'Critical' ? '#fee2e2' :
                                                                   item.priority == 'High' ? '#fef3c7' :
                                                                   item.priority == 'Medium' ? '#dbeafe' : '#f3f4f6'};
                                                      color: ${item.priority == 'Critical' ? '#991b1b' :
                                                              item.priority == 'High' ? '#92400e' :
                                                              item.priority == 'Medium' ? '#1e40af' : '#374151'};">
                                                    <i class="bi bi-flag-fill"></i> Priority: ${item.priority}
                                                </span>
                                            </c:if>
                                            <c:if test="${not empty item.unitPrice && item.unitPrice > 0}">
                                                <span style="font-size: 11px; padding: 4px 8px; background: #dcfce7; color: #166534; border-radius: 4px; font-weight: 600;">
                                                    <i class="bi bi-currency-dollar"></i> ${item.unitPrice} VNĐ/unit
                                                </span>
                                            </c:if>
                                        </div>
                                        <c:if test="${not empty item.notes}">
                                            <div style="margin-top: 8px; padding: 8px; background: #fffbeb; border-left: 3px solid #f59e0b; border-radius: 4px;">
                                                <div style="font-size: 11px; font-weight: 600; color: #92400e; margin-bottom: 4px;">
                                                    <i class="bi bi-sticky"></i> NOTES
                                                </div>
                                                <div style="font-size: 12px; color: #78350f;">
                                                    ${item.notes}
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>
                                    <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 8px;">
                                        <span class="quantity-badge" style="font-size: 16px; padding: 10px 18px;">
                                            ${item.quantity} units
                                        </span>
                                        <c:if test="${not empty item.unitPrice && item.unitPrice > 0}">
                                            <span style="font-size: 13px; font-weight: 600; color: #059669;">
                                                Total: ${item.quantity * item.unitPrice} VNĐ
                                            </span>
                                        </c:if>
                                    </div>
                                </li>
                            </c:forEach>
                        </ul>
                        <div style="margin-top: 16px; padding: 12px; background: #f9fafb; border-radius: 8px; border: 1px solid #e5e7eb;">
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <span style="font-weight: 600; color: #374151;">
                                    <i class="bi bi-box-seam"></i> Total Items: ${poItems.size()}
                                </span>
                                <c:set var="totalQuantity" value="0" />
                                <c:forEach items="${poItems}" var="item">
                                    <c:set var="totalQuantity" value="${totalQuantity + item.quantity}" />
                                </c:forEach>
                                <span style="font-weight: 600; color: #3b82f6;">
                                    <i class="bi bi-boxes"></i> Total Quantity: ${totalQuantity} units
                                </span>
                            </div>
                        </div>
                    </c:if>
                </div>
            </c:if>
        </div>
        <div style="display: none;" data-task-edit>
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="taskId" value="${viewTask.taskId}">
            <div style="margin-bottom: 16px;">
                <label style="font-weight: 600; margin-bottom: 8px; display: block;">Staff Member</label>
                <select name="auditorId" required style="width: 100%; padding: 12px; border: 1px solid #e5e7eb; border-radius: 8px;">
                    <c:forEach items="${auditors}" var="staff">
                        <option value="${staff.userId}" ${staff.userId == viewTask.staffId ? 'selected' : ''}>
                            ${staff.username} - ${staff.email} <c:choose><c:when test="${staff.role == 'Auditor'}">[Auditor]</c:when><c:when test="${staff.role == 'Pharmacist'}">[Pharmacist]</c:when></c:choose>
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div style="margin-bottom: 16px;">
                <label style="font-weight: 600; margin-bottom: 8px; display: block;">Task Type</label>
                <select name="taskType" required style="width: 100%; padding: 12px; border: 1px solid #e5e7eb; border-radius: 8px;">
                    <option value="stock_in" ${viewTask.taskType == 'stock_in' ? 'selected' : ''}>📦 Stock In Verification</option>
                    <option value="stock_out" ${viewTask.taskType == 'stock_out' ? 'selected' : ''}>📤 Stock Out Verification</option>
                    <option value="counting" ${viewTask.taskType == 'counting' ? 'selected' : ''}>🔢 Inventory Counting</option>
                    <option value="quality_check" ${viewTask.taskType == 'quality_check' ? 'selected' : ''}>✅ Quality Check</option>
                    <option value="expiry_audit" ${viewTask.taskType == 'expiry_audit' ? 'selected' : ''}>⏰ Expiry Date Audit</option>
                </select>
            </div>
            <div style="margin-bottom: 16px;">
                <label style="font-weight: 600; margin-bottom: 8px; display: block;">Deadline</label>
                <input type="date" name="deadline" value="${viewTask.deadline}" required min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" style="width: 100%; padding: 12px; border: 1px solid #e5e7eb; border-radius: 8px;">
            </div>
        </div>
    </c:if>
</body>
<%@ include file="/admin/footer.jsp" %>
</html>