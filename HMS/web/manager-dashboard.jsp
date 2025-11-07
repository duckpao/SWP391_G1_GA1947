<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manager Dashboard - Hospital System</title>
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
                <a class="nav-link active" href="${pageContext.request.contextPath}/manager-dashboard">
                    <i class="bi bi-speedometer2"></i> Dashboard
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/create-stock">
                    <i class="bi bi-plus-circle"></i> New Stock Request
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/cancelled-tasks">
                    <i class="bi bi-ban"></i> Cancelled Orders
                </a>
                
                <hr class="nav-divider">
                
                <!-- Reports Section -->
                <a class="nav-link" href="${pageContext.request.contextPath}/inventory-report">
                    <i class="bi bi-boxes"></i> Inventory Report
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/expiry-report?days=30">
                    <i class="bi bi-calendar-times"></i> Expiry Report
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/stock-alerts">
                    <i class="bi bi-exclamation-triangle"></i> Stock Alerts
                </a>
                
                <hr class="nav-divider">
                
                <!-- Management Section -->
                <a class="nav-link" href="${pageContext.request.contextPath}/tasks/assign">
                    <i class="bi bi-pencil"></i> Assign Tasks
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/manage/transit">
                    <i class="bi bi-truck"></i> Transit Orders
                </a>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="page-header">
                <h2><i class="bi bi-speedometer2"></i> Manager Dashboard</h2>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">
                    <i class="bi bi-box-arrow-right"></i> Logout
                </a>
            </div>

            <!-- Message Alert -->
            <c:if test="${not empty message}">
                <div class="alert alert-${messageType == 'success' ? 'success' : 'danger'}">
                    <i class="bi bi-${messageType == 'success' ? 'check-circle' : 'exclamation-circle'}"></i>
                    ${message}
                </div>
            </c:if>

            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-content">
                        <div class="stat-info">
                            <h6>Warehouse Status</h6>
                            <h3>${warehouseStatus}</h3>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-warehouse"></i>
                        </div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-content">
                        <div class="stat-info">
                            <h6>Stock Alerts</h6>
                            <h3>${stockAlerts.size()} Items</h3>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-exclamation-triangle"></i>
                        </div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-content">
                        <div class="stat-info">
                            <h6>Stock Requests</h6>
                            <h3>${pendingRequests.size()} Orders</h3>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-clipboard-list"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Stock Requests Section -->
            <div class="dashboard-card">
                <div class="card-header">
                    <h5><i class="bi bi-clipboard-list"></i> Stock Requests</h5>
                    <div style="display: flex; gap: 12px;">
                        <a href="${pageContext.request.contextPath}/create-stock" class="btn btn-success"><i class="bi bi-plus"></i> New Request</a>
                        <a href="${pageContext.request.contextPath}/cancelled-tasks" class="btn btn-secondary"><i class="bi bi-ban"></i> Cancelled</a>
                    </div>
                </div>
                <div class="card-body">
                    <c:if test="${empty pendingRequests}">
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle"></i> No stock requests at the moment.
                        </div>
                    </c:if>

                    <c:if test="${not empty pendingRequests}">
                        <div class="table-responsive">
                            <table>
                                <thead>
                                    <tr>
                                        <th>PO #</th>
                                        <th>Status</th>
                                        <th>Supplier</th>
                                        <th>Order Date</th>
                                        <th>Expected Delivery</th>
                                        <th>Manager</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${pendingRequests}" var="order">
                                        <tr>
                                            <td><strong>#${order.poId}</strong></td>
                                            <td>
                                                <span class="status-badge status-${order.status == 'Draft' ? 'draft' : order.status == 'Sent' ? 'sent' : order.status == 'Cancelled' ? 'cancelled' : 'rejected'}">
                                                    ${order.status}
                                                </span>
                                            </td>
                                            <td>${not empty order.supplierName ? order.supplierName : '<span style="color: #9ca3af;">Not assigned</span>'}</td>
                                            <td>${order.orderDate}</td>
                                            <td>${not empty order.expectedDeliveryDate ? order.expectedDeliveryDate : '<span style="color: #9ca3af;">N/A</span>'}</td>
                                            <td>${order.managerName}</td>
                                            <td>
                                                <button class="btn btn-info" onclick="toggleDetails(${order.poId})">
                                                    <i class="bi bi-eye"></i> Details
                                                </button>
                                                <c:if test="${order.status == 'Draft'}">
                                                    <button class="btn btn-success" onclick="approveOrder(${order.poId})">
                                                        <i class="bi bi-send"></i> Send
                                                    </button>
                                                                                                                    <c:if test="${order.status == 'Sent'}">
                                                                <button class="btn btn-danger btn-sm" 
                                                                        onclick="confirmCancel(${order.poId})" 
                                                                        title="Cancel Order">
                                                                    <i class="fas fa-times"></i> Cancel
                                                                </button>
                                                            </c:if>
                                                    <a href="${pageContext.request.contextPath}/edit-stock?poId=${order.poId}" class="btn btn-warning">
                                                        <i class="bi bi-pencil"></i> Edit
                                                    </a>
                                                    <button class="btn btn-danger" onclick="deleteOrder(${order.poId})">
                                                        <i class="bi bi-trash"></i> Delete
                                                    </button>
                                                </c:if>
                                                <c:if test="${order.status == 'Sent'}">
                                                    <button class="btn btn-warning" onclick="cancelOrder(${order.poId})">
                                                        <i class="bi bi-x-circle"></i> Cancel
                                                    </button>
                                                </c:if>
                                            </td>
                                        </tr>
                                        <!-- Details Row -->
                                        <tr id="details-${order.poId}" class="details-row" style="display: none;">
                                            <td colspan="7">
                                                <div class="details-content">
                                                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px;">
                                                        <div>
                                                            <h6><i class="bi bi-info-circle"></i> General Information</h6>
                                                            <table class="details-table">
                                                                <tr>
                                                                    <td>PO ID:</td>
                                                                    <td>#${order.poId}</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>Status:</td>
                                                                    <td>${order.status}</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>Manager:</td>
                                                                    <td>${order.managerName}</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>Order Date:</td>
                                                                    <td>${order.orderDate}</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>Expected Delivery:</td>
                                                                    <td>${not empty order.expectedDeliveryDate ? order.expectedDeliveryDate : 'N/A'}</td>
                                                                </tr>
                                                            </table>
                                                            <c:if test="${not empty order.notes}">
                                                                <h6 style="margin-top: 16px;"><i class="bi bi-sticky"></i> Notes</h6>
                                                                <div class="alert alert-info" style="margin: 0;">
                                                                    <small style="white-space: pre-wrap;">${order.notes}</small>
                                                                </div>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div id="deleteModal" class="modal">
        <div class="modal-content">
            <div class="modal-header" style="background: #fee2e2; border-bottom: 1px solid #fca5a5;">
                <h5 style="color: #991b1b;"><i class="bi bi-trash"></i> Delete Stock Request</h5>
                <button class="close-btn" onclick="closeModal('deleteModal')">&times;</button>
            </div>
            <form action="${pageContext.request.contextPath}/manage-stock" method="post">
                <div class="modal-body">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="poId" id="deletePoId">
                    <p>Are you sure you want to delete this stock request? This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('deleteModal')">Cancel</button>
                    <button type="submit" class="btn btn-danger"><i class="bi bi-trash"></i> Delete</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Cancel Order Modal -->
    <div id="cancelModal" class="modal">
        <div class="modal-content">
            <div class="modal-header" style="background: #fef3c7; border-bottom: 1px solid #fcd34d;">
                <h5 style="color: #92400e;"><i class="bi bi-x-circle"></i> Cancel Stock Request</h5>
                <button class="close-btn" onclick="closeModal('cancelModal')">&times;</button>
            </div>
            <form action="${pageContext.request.contextPath}/approve-stock" method="post">
                <div class="modal-body">
                    <input type="hidden" name="action" value="cancel">
                    <input type="hidden" name="poId" id="cancelPoId">
                    <div class="alert alert-warning">
                        <i class="bi bi-exclamation-triangle"></i> 
                        <strong>Warning:</strong> This will cancel the purchase order sent to the supplier.
                    </div>
                    <div style="margin-bottom: 16px;">
                        <label style="display: block; font-weight: 600; margin-bottom: 8px;">Cancellation Reason <span style="color: #ef4444;">*</span></label>
                        <textarea name="reason" rows="3" style="width: 100%; padding: 12px; border: 1px solid #e5e7eb; border-radius: 8px; font-family: inherit; font-size: 14px;" 
                                  placeholder="Enter reason for cancellation (minimum 10 characters)..." 
                                  required minlength="10"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeModal('cancelModal')">Close</button>
                    <button type="submit" class="btn btn-warning"><i class="bi bi-x-circle"></i> Cancel Order</button>
                </div>
            </form>
        </div>
    </div>

    <script>
                function confirmCancel(poId) {
    // Hiển thị modal hoặc prompt để nhập lý do
    const reason = prompt("Please provide cancellation reason:\n\n(This action cannot be undone)");
    
    // Nếu user nhấn Cancel hoặc không nhập gì
    if (reason === null || reason.trim() === '') {
        return; // Hủy operation
    }
    
    // ✅ Tạo form động và submit
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = 'cancel-stock-request';
    
    // Hidden input cho PO ID
    const poIdInput = document.createElement('input');
    poIdInput.type = 'hidden';
    poIdInput.name = 'poId';
    poIdInput.value = poId;
    
    // Hidden input cho reason
    const reasonInput = document.createElement('input');
    reasonInput.type = 'hidden';
    reasonInput.name = 'reason';
    reasonInput.value = reason;
    
    form.appendChild(poIdInput);
    form.appendChild(reasonInput);
    
    document.body.appendChild(form);
    form.submit();
}
        function toggleDetails(poId) {
            const detailsRow = document.getElementById('details-' + poId);
            if (detailsRow.style.display === 'none') {
                detailsRow.style.display = 'table-row';
            } else {
                detailsRow.style.display = 'none';
            }
        }

        function approveOrder(poId) {
            if (confirm('Send this purchase order to supplier?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/approve-stock';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'approve';
                
                const poIdInput = document.createElement('input');
                poIdInput.type = 'hidden';
                poIdInput.name = 'poId';
                poIdInput.value = poId;
                
                form.appendChild(actionInput);
                form.appendChild(poIdInput);
                document.body.appendChild(form);
                form.submit();
            }
        }

        function deleteOrder(poId) {
            document.getElementById('deletePoId').value = poId;
            document.getElementById('deleteModal').classList.add('show');
        }

        function cancelOrder(poId) {
            document.getElementById('cancelPoId').value = poId;
            document.getElementById('cancelModal').classList.add('show');
        }

        function closeModal(modalId) {
            document.getElementById(modalId).classList.remove('show');
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const deleteModal = document.getElementById('deleteModal');
            const cancelModal = document.getElementById('cancelModal');
            if (event.target === deleteModal) {
                deleteModal.classList.remove('show');
            }
            if (event.target === cancelModal) {
                cancelModal.classList.remove('show');
            }
        }
    </script>
</body>
<%@ include file="/admin/footer.jsp" %>
</html>