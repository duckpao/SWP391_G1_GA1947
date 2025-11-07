<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stock Alerts - Hospital System</title>
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

        .nav-link:hover {
            background: #f3f4f6;
            color: #3b82f6;
            transform: translateX(4px);
        }

        .nav-link.active {
            background: #f3f4f6;
            color: #3b82f6;
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
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
            gap: 20px;
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

        .header-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 10px 16px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 14px;
        }

        .btn-success {
            background: #10b981;
            color: white;
        }

        .btn-success:hover {
            background: #059669;
        }

        .btn-secondary {
            background: #6b7280;
            color: white;
        }

        .btn-secondary:hover {
            background: #4b5563;
        }

        .btn-danger {
            background: #ef4444;
            color: white;
        }

        .btn-danger:hover {
            background: #dc2626;
        }

        .btn-sm {
            padding: 6px 12px;
            font-size: 12px;
        }

        /* Statistics Cards */
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

        .stat-card.stat-critical {
            border-left-color: #ef4444;
        }

        .stat-card.stat-high {
            border-left-color: #f59e0b;
        }

        .stat-card.stat-medium {
            border-left-color: #fbbf24;
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

        .stat-card.stat-critical .stat-icon {
            color: #ef4444;
        }

        .stat-card.stat-high .stat-icon {
            color: #f59e0b;
        }

        .stat-card.stat-medium .stat-icon {
            color: #fbbf24;
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

        .badge {
            background: #e5e7eb;
            color: #374151;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
        }

        .card-body {
            padding: 24px;
        }

        /* Alert Info Box */
        .alert-info-box {
            background: #dbeafe;
            border-left: 5px solid #3b82f6;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 2px 8px rgba(59, 130, 246, 0.1);
            color: #1e40af;
        }

        .alert-info-box strong {
            color: #1f2937;
        }

        .alert-info-box small {
            color: #1e40af;
            display: block;
            margin-top: 8px;
        }

        /* Success Alert */
        .alert-success {
            background: #dcfce7;
            border-left: 4px solid #10b981;
            color: #166534;
            padding: 16px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .alert-success i {
            color: #10b981;
            font-size: 20px;
        }

        /* Table Styling */
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
            color: #374151;
        }

        table tbody tr:hover {
            background: #f9fafb;
        }

        table tbody tr.critical-row {
            background: #fee2e2;
        }

        table tbody tr.highlight-row {
            background: #fef3c7;
        }

        .quantity-critical {
            color: #ef4444;
            font-weight: 700;
        }

        .quantity-low {
            color: #f59e0b;
            font-weight: 700;
        }

        .quantity-warning {
            color: #92400e;
            font-weight: 700;
        }

        /* Alert Badges */
        .alert-badge {
            padding: 6px 12px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 12px;
            display: inline-block;
        }

        .alert-critical {
            background: #ef4444;
            color: white;
        }

        .alert-high {
            background: #f59e0b;
            color: white;
        }

        .alert-medium {
            background: #fbbf24;
            color: #000;
        }

        .badge-secondary {
            background: #6b7280;
            color: white;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
        }

        /* Quick Actions */
        .quick-actions {
            display: flex;
            gap: 12px;
            justify-content: center;
            margin-top: 24px;
            flex-wrap: wrap;
        }

        /* Recommendations */
        .recommendations-list {
            list-style: none;
            padding: 0;
        }

        .recommendations-list li {
            padding: 12px 0;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            gap: 12px;
        }

        .recommendations-list li:last-child {
            border-bottom: none;
        }

        .recommendations-list li strong {
            color: #1f2937;
        }

        .text-danger {
            color: #ef4444;
        }

        .text-warning {
            color: #f59e0b;
        }

        .text-success {
            color: #10b981;
        }

        .text-muted {
            color: #9ca3af;
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

            .page-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .page-header h2 {
                font-size: 24px;
            }

            .header-actions {
                width: 100%;
            }

            .btn {
                flex: 1;
                justify-content: center;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            table {
                font-size: 12px;
            }

            table th, table td {
                padding: 12px 8px;
            }

            .quick-actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <%@ include file="/admin/header.jsp" %>
    
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
                <a class="nav-link active" href="${pageContext.request.contextPath}/stock-alerts">
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
            <!-- Page Header -->
            <div class="page-header">
                <h2>
                    <i class="bi bi-exclamation-triangle"></i> 
                    Stock Alerts & Inventory Status
                </h2>
                <div class="header-actions">
                    <a href="${pageContext.request.contextPath}/create-stock" class="btn btn-success">
                        <i class="bi bi-plus-circle"></i> Create Stock Request
                    </a>
                </div>
            </div>

            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card stat-critical">
                    <div class="stat-content">
                        <div class="stat-info">
                            <h6>Critical (Out of Stock)</h6>
                            <h3>
                                <c:set var="criticalCount" value="0"/>
                                <c:forEach items="${alerts}" var="alert">
                                    <c:if test="${alert.alertLevel == 'Critical'}">
                                        <c:set var="criticalCount" value="${criticalCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${criticalCount}
                            </h3>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-x-circle"></i>
                        </div>
                    </div>
                </div>
                
                <div class="stat-card stat-high">
                    <div class="stat-content">
                        <div class="stat-info">
                            <h6>High Alert</h6>
                            <h3>
                                <c:set var="highCount" value="0"/>
                                <c:forEach items="${alerts}" var="alert">
                                    <c:if test="${alert.alertLevel == 'High'}">
                                        <c:set var="highCount" value="${highCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${highCount}
                            </h3>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-exclamation-circle"></i>
                        </div>
                    </div>
                </div>
                
                <div class="stat-card stat-medium">
                    <div class="stat-content">
                        <div class="stat-info">
                            <h6>Medium Alert</h6>
                            <h3>
                                <c:set var="mediumCount" value="0"/>
                                <c:forEach items="${alerts}" var="alert">
                                    <c:if test="${alert.alertLevel == 'Medium'}">
                                        <c:set var="mediumCount" value="${mediumCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${mediumCount}
                            </h3>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-info-circle"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Alert Threshold Info -->
            <div class="alert-info-box">
                <i class="bi bi-info-circle"></i>
                <strong>Alert Threshold:</strong> Medicines with quantity ≤ <strong>${threshold}</strong> units
                <br>
                <small>
                    <i class="bi bi-circle-fill text-danger"></i> <strong>Critical:</strong> Out of stock (0 units) | 
                    <i class="bi bi-circle-fill text-warning"></i> <strong>High:</strong> Below ${threshold / 2} units | 
                    <i class="bi bi-circle-fill" style="color: #fbbf24;"></i> <strong>Medium:</strong> Below ${threshold} units
                </small>
            </div>

            <!-- Stock Alerts Table -->
            <div class="dashboard-card">
                <div class="card-header">
                    <h5>
                        <i class="bi bi-list"></i> Low Stock Medicines 
                        <span class="badge">${alerts.size()}</span>
                    </h5>
                </div>
                <div class="card-body">
                    <c:if test="${empty alerts}">
                        <div class="alert-success">
                            <i class="bi bi-check-circle"></i> 
                            <div>
                                <strong>All Good!</strong> No stock alerts at this time. All medicines are above the threshold.
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${not empty alerts}">
                        <div class="table-responsive">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Medicine Code</th>
                                        <th>Medicine Name</th>
                                        <th>Category</th>
                                        <th>Current Quantity</th>
                                        <th>Threshold</th>
                                        <th>Alert Level</th>
                                        <th>Nearest Expiry</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${alerts}" var="alert">
                                        <tr class="${alert.alertLevel == 'Critical' ? 'critical-row' : 
                                                     alert.alertLevel == 'High' ? 'highlight-row' : ''}">
                                            <td><strong>${alert.medicineCode}</strong></td>
                                            <td>
                                                <strong>${alert.medicineName}</strong>
                                                <c:if test="${alert.currentQuantity == 0}">
                                                    <br><small class="text-danger">⚠️ OUT OF STOCK</small>
                                                </c:if>
                                            </td>
                                            <td>
                                                <span class="badge-secondary">${alert.category}</span>
                                            </td>
                                            <td>
                                                <span class="${alert.currentQuantity == 0 ? 'quantity-critical' : 
                                                               alert.currentQuantity < threshold / 2 ? 'quantity-low' : 'quantity-warning'}">
                                                    ${alert.currentQuantity} units
                                                </span>
                                            </td>
                                            <td>${alert.threshold} units</td>
                                            <td>
                                                <span class="alert-badge ${
                                                      alert.alertLevel == 'Critical' ? 'alert-critical' : 
                                                      alert.alertLevel == 'High' ? 'alert-high' : 'alert-medium'}">
                                                    ${alert.alertLevel}
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty alert.nearestExpiry}">
                                                        <i class="bi bi-calendar"></i> ${alert.nearestExpiry}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">No batches</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/create-stock?medicineCode=${alert.medicineCode}" 
                                                   class="btn btn-success btn-sm">
                                                    <i class="bi bi-plus"></i> Order Now
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Quick Actions -->
                        <div class="quick-actions">
                            <a href="${pageContext.request.contextPath}/create-stock" class="btn btn-success">
                                <i class="bi bi-cart-plus"></i> Create Bulk Stock Request
                            </a>
                            <a href="${pageContext.request.contextPath}/manager-dashboard" class="btn btn-secondary">
                                <i class="bi bi-boxes"></i> View All Purchase Orders
                            </a>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Recommendations Card -->
            <div class="dashboard-card">
                <div class="card-header">
                    <h5><i class="bi bi-lightbulb"></i> Recommendations & Actions</h5>
                </div>
                <div class="card-body">
                    <ul class="recommendations-list">
                        <c:if test="${criticalCount > 0}">
                            <li class="text-danger">
                                <i class="bi bi-exclamation-triangle-fill"></i>
                                <div>
                                    <strong>Urgent:</strong> ${criticalCount} medicine(s) are completely out of stock. 
                                    Create purchase orders immediately to prevent service disruption.
                                </div>
                            </li>
                        </c:if>
                        <c:if test="${highCount > 0}">
                            <li class="text-warning">
                                <i class="bi bi-exclamation-circle-fill"></i>
                                <div>
                                    <strong>High Priority:</strong> ${highCount} medicine(s) are critically low. 
                                    Consider expedited ordering.
                                </div>
                            </li>
                        </c:if>
                        <c:if test="${mediumCount > 0}">
                            <li style="color: #92400e;">
                                <i class="bi bi-info-circle-fill"></i>
                                <div>
                                    <strong>Monitor:</strong> ${mediumCount} medicine(s) are below threshold. 
                                    Plan restocking in the near future.
                                </div>
                            </li>
                        </c:if>
                        <c:if test="${empty alerts}">
                            <li class="text-success">
                                <i class="bi bi-check-circle-fill"></i>
                                <div>
                                    <strong>Status:</strong> All medicines are adequately stocked. 
                                    Continue regular monitoring.
                                </div>
                            </li>
                        </c:if>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="/admin/footer.jsp" %>
</body>
</html>