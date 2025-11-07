<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cancelled Tasks - Hospital System</title>
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

        .page-header p {
            font-size: 14px;
            color: #6b7280;
            margin-top: 8px;
        }

        /* Card styling */
        .dashboard-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            margin-bottom: 30px;
            overflow: hidden;
            border-top: 3px solid #ef4444;
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

        .btn-danger {
            background: #ef4444;
            color: white;
        }

        .btn-danger:hover {
            background: #dc2626;
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
            border-color: #ef4444;
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
            background: #ef4444;
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

        .cancellation-reason {
            background: #fffbeb;
            border-left: 4px solid #f59e0b;
            padding: 12px;
            margin-top: 10px;
            border-radius: 8px;
        }

        .cancellation-reason strong {
            color: #92400e;
            display: block;
            margin-bottom: 6px;
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
                <a class="nav-link" href="${pageContext.request.contextPath}/manager-dashboard">
                    <i class="bi bi-speedometer2"></i> Dashboard
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/create-stock">
                    <i class="bi bi-plus-circle"></i> New Stock Request
                </a>
                <a class="nav-link active" href="${pageContext.request.contextPath}/cancelled-tasks">
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
                <div>
                    <h2><i class="bi bi-ban"></i> Cancelled Stock Requests</h2>
                    <p>View all cancelled purchase orders and their details</p>
                </div>
                <a href="${pageContext.request.contextPath}/manager-dashboard" class="btn btn-info">
                    <i class="bi bi-arrow-left"></i> Back to Dashboard
                </a>
            </div>

            <!-- Cancelled Orders Card -->
            <div class="dashboard-card">
                <div class="card-header">
                    <h5><i class="bi bi-x-circle"></i> Cancelled Orders</h5>
                </div>
                <div class="card-body">
                    <c:if test="${empty cancelledOrders}">
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle"></i> No cancelled orders found.
                        </div>
                    </c:if>

                    <c:if test="${not empty cancelledOrders}">
                        <div class="table-responsive">
                            <table>
                                <thead>
                                    <tr>
                                        <th>PO #</th>
                                        <th>Status</th>
                                        <th>Supplier</th>
                                        <th>Order Date</th>
                                        <th>Cancelled Date</th>
                                        <th>Manager</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${cancelledOrders}" var="order">
                                        <tr>
                                            <td><strong>#${order.poId}</strong></td>
                                            <td>
                                                <span class="status-badge status-cancelled">Cancelled</span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty order.supplierName}">
                                                        ${order.supplierName}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: #9ca3af;">Not assigned</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${order.orderDate}</td>
                                            <td>${order.updatedAt}</td>
                                            <td>${order.managerName}</td>
                                            <td>
                                                <button class="btn btn-info" onclick="toggleDetails(${order.poId})">
                                                    <i class="bi bi-eye"></i> Details
                                                </button>
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
                                                                    <td><span class="status-badge status-cancelled">Cancelled</span></td>
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
                                                                    <td>Cancelled Date:</td>
                                                                    <td>${order.updatedAt}</td>
                                                                </tr>
                                                                <tr>
                                                                    <td>Expected Delivery:</td>
                                                                    <td>
                                                                        <c:choose>
                                                                            <c:when test="${not empty order.expectedDeliveryDate}">
                                                                                ${order.expectedDeliveryDate}
                                                                            </c:when>
                                                                            <c:otherwise>N/A</c:otherwise>
                                                                        </c:choose>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            
                                                            <!-- Cancellation Reason -->
                                                            <c:if test="${not empty order.notes}">
                                                                <h6 style="margin-top: 16px;"><i class="bi bi-exclamation-triangle"></i> Cancellation Reason</h6>
                                                                <div class="cancellation-reason">
                                                                    <strong>Reason:</strong>
                                                                    <span style="white-space: pre-wrap;">${order.notes}</span>
                                                                </div>
                                                            </c:if>
                                                        </div>
                                                        
                                                        <div>
                                                            <h6><i class="bi bi-capsule"></i> Order Items</h6>
                                                            <c:set var="items" value="${poItemsMap[order.poId]}" />
                                                            <c:choose>
                                                                <c:when test="${not empty items}">
                                                                    <ul class="item-list">
                                                                        <c:forEach items="${items}" var="item">
                                                                            <li>
                                                                                <div style="flex: 1;">
                                                                                    <!-- Medicine Name & Code -->
                                                                                    <div class="medicine-main-info">
                                                                                        ${item.medicineName}
                                                                                        <c:if test="${not empty item.medicineStrength}">
                                                                                            <span style="color: #ef4444; font-weight: 600;">${item.medicineStrength}</span>
                                                                                        </c:if>
                                                                                        <span class="medicine-code-badge">${item.medicineCode}</span>
                                                                                    </div>
                                                                                    
                                                                                    <!-- Medicine Details -->
                                                                                    <div class="medicine-detail-row">
                                                                                        <c:if test="${not empty item.medicineDosageForm}">
                                                                                            <div class="medicine-detail-item">
                                                                                                <i class="bi bi-capsule"></i>
                                                                                                <span>${item.medicineDosageForm}</span>
                                                                                            </div>
                                                                                        </c:if>
                                                                                        <c:if test="${not empty item.medicineCategory}">
                                                                                            <div class="medicine-detail-item">
                                                                                                <i class="bi bi-tag"></i>
                                                                                                <span>${item.medicineCategory}</span>
                                                                                            </div>
                                                                                        </c:if>
                                                                                        <c:if test="${not empty item.medicineManufacturer}">
                                                                                            <div class="medicine-detail-item">
                                                                                                <i class="bi bi-building"></i>
                                                                                                <span>${item.medicineManufacturer}</span>
                                                                                            </div>
                                                                                        </c:if>
                                                                                    </div>
                                                                                    
                                                                                    <!-- Priority -->
                                                                                    <c:if test="${not empty item.priority}">
                                                                                        <div style="margin-top: 10px;">
                                                                                            <span class="status-badge" style="font-size: 11px; 
                                                                                                  background: ${item.priority == 'Critical' ? '#fee2e2' : 
                                                                                                               item.priority == 'High' ? '#fef3c7' : 
                                                                                                               item.priority == 'Medium' ? '#dbeafe' : '#f3f4f6'};
                                                                                                  color: ${item.priority == 'Critical' ? '#991b1b' : 
                                                                                                          item.priority == 'High' ? '#92400e' : 
                                                                                                          item.priority == 'Medium' ? '#1e40af' : '#374151'};">
                                                                                                <i class="bi bi-flag-fill"></i> Priority: ${item.priority}
                                                                                            </span>
                                                                                        </div>
                                                                                    </c:if>
                                                                                    
                                                                                    <!-- Item Notes -->
                                                                                    <c:if test="${not empty item.notes}">
                                                                                        <div style="margin-top: 8px;">
                                                                                            <small style="color: #6b7280;">
                                                                                                <i class="bi bi-sticky"></i> ${item.notes}
                                                                                            </small>
                                                                                        </div>
                                                                                    </c:if>
                                                                                </div>
                                                                                <div class="text-end ms-3">
                                                                                    <span class="quantity-badge">${item.quantity} units</span>
                                                                                </div>
                                                                            </li>
                                                                        </c:forEach>
                                                                    </ul>
                                                                    <div style="margin-top: 16px; padding: 12px; background: #f9fafb; border-radius: 8px; border: 1px solid #e5e7eb;">
                                                                        <div style="display: flex; justify-content: space-between; align-items: center;">
                                                                            <span style="font-weight: 600; color: #374151;">
                                                                                <i class="bi bi-box-seam"></i> Total Items: ${items.size()}
                                                                            </span>
                                                                            <c:set var="totalQuantity" value="0" />
                                                                            <c:forEach items="${items}" var="item">
                                                                                <c:set var="totalQuantity" value="${totalQuantity + item.quantity}" />
                                                                            </c:forEach>
                                                                            <span style="font-weight: 600; color: #ef4444;">
                                                                                <i class="bi bi-boxes"></i> Total: ${totalQuantity} units
                                                                            </span>
                                                                        </div>
                                                                    </div>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div class="alert alert-warning">
                                                                        <i class="bi bi-exclamation-triangle"></i> No items found
                                                                    </div>
                                                                </c:otherwise>
                                                            </c:choose>
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

    <script>
        function toggleDetails(poId) {
            const detailsRow = document.getElementById('details-' + poId);
            if (detailsRow.style.display === 'none') {
                detailsRow.style.display = 'table-row';
            } else {
                detailsRow.style.display = 'none';
            }
        }
    </script>
</body>
<%@ include file="/admin/footer.jsp" %>
</html>