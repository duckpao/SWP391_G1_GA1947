<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sent Orders - Manager</title>
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
        .status-approved {
            background: #dcfce7;
            color: #166534;
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
            margin-right: 4px;
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
            .card-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 12px;
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
        <div class="sidebar">
            <div class="sidebar-header">
                <h4><i class="bi bi-hospital"></i> Manager</h4>
                <hr class="sidebar-divider">
            </div>
            <nav>
                <a class="nav-link" href="${pageContext.request.contextPath}/manager-dashboard">
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
<a class="nav-link active" href="${pageContext.request.contextPath}/manager/sent-orders">
    <i class="bi bi-send-check"></i> Sent Orders
</a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/manage/transit">
                    <i class="bi bi-truck"></i> Transit Orders
                </a>

<a class="nav-link" href="${pageContext.request.contextPath}/manager/completed-orders">
    <i class="bi bi-check-circle"></i> Completed
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

</li>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Message Alerts -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">
                    <i class="bi bi-exclamation-circle"></i>
                    ${errorMessage}
                </div>
            </c:if>
            
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">
                    <i class="bi bi-check-circle"></i>
                    ${successMessage}
                </div>
            </c:if>
            
            <c:if test="${not empty message}">
                <div class="alert alert-${messageType == 'success' ? 'success' : 'danger'}">
                    <i class="bi bi-${messageType == 'success' ? 'check-circle' : 'exclamation-circle'}"></i>
                    ${message}
                </div>
            </c:if>

            <!-- Stock Requests Section -->
            <div class="dashboard-card">
                <div class="card-header">
                    <h5><i class="bi bi-clipboard-list"></i> Stock Requests</h5>
                    <div style="display: flex; gap: 12px;">
                        <a href="${pageContext.request.contextPath}/create-stock" class="btn btn-success">
                            <i class="bi bi-plus"></i> New Request
                        </a>
                        <a href="${pageContext.request.contextPath}/cancelled-tasks" class="btn btn-secondary">
                            <i class="bi bi-ban"></i> Cancelled
                        </a>
                    </div>
                </div>
                <div class="card-body">
                    <c:if test="${empty sentOrders}">
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle"></i> No orders found.
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty sentOrders}">
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
                                    <c:forEach items="${sentOrders}" var="order">
                                        <tr>
                                            <td><strong>#${order.poId}</strong></td>
                                            <td>
                                                <span class="status-badge status-${order.status == 'Draft' ? 'draft' : order.status == 'Sent' ? 'sent' : order.status == 'Approved' ? 'approved' : order.status == 'Rejected' ? 'rejected' : 'cancelled'}">
                                                    ${order.status}
                                                </span>
                                            </td>
                                            <td>${not empty order.supplierName ? order.supplierName : '<span style="color: #9ca3af;">Not assigned</span>'}</td>
                                            <td>${order.orderDate}</td>
                                            <td>${not empty order.expectedDeliveryDate ? order.expectedDeliveryDate : '<span style="color: #9ca3af;">N/A</span>'}</td>
                                            <td>${order.managerName}</td>
                                            <td>
                                                <button class="btn btn-info" onclick="viewDetails(${order.poId})">
                                                    <i class="bi bi-eye"></i> Details
                                                </button>
                                                
                                                <c:if test="${order.status == 'Draft'}">
                                                    <button class="btn btn-success" onclick="sendOrder(${order.poId})">
                                                        <i class="bi bi-send"></i> Send
                                                    </button>
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
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        function viewDetails(poId) {
            window.location.href = '${pageContext.request.contextPath}/manager/order-details?id=' + poId;
        }
        
        function sendOrder(poId) {
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
            if (confirm('Are you sure you want to delete this order? This action cannot be undone.')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/manage-stock';
               
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
               
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
        
        function cancelOrder(poId) {
            const reason = prompt("Please provide cancellation reason:\n\n(This action cannot be undone)");
            
            if (reason === null || reason.trim() === '') {
                return;
            }
            
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/cancel-stock-request';
            
            const poIdInput = document.createElement('input');
            poIdInput.type = 'hidden';
            poIdInput.name = 'poId';
            poIdInput.value = poId;
            
            const reasonInput = document.createElement('input');
            reasonInput.type = 'hidden';
            reasonInput.name = 'reason';
            reasonInput.value = reason;
            
            form.appendChild(poIdInput);
            form.appendChild(reasonInput);
            
            document.body.appendChild(form);
            form.submit();
        }
    </script>
</body>
<%@ include file="/admin/footer.jsp" %>
</html>