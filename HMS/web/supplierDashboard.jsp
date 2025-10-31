<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="/admin/header.jsp" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Supplier Dashboard</title>
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
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #ffffff;
            color: #2c3e50;
            min-height: 100vh;
        }
        .main-wrapper {
            display: block;
        }
        /* Sidebar */
        .sidebar {
            width: 0;
            background: #f8f9fa;
            border-right: 1px solid #dee2e6;
            padding: 30px 0;
            min-height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            overflow-y: auto;
        }
        .sidebar-brand {
            padding: 0 20px 30px;
            border-bottom: 1px solid #dee2e6;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 18px;
            font-weight: 700;
            color: #2c3e50;
        }
        .sidebar-menu {
            display: flex;
            flex-direction: column;
            gap: 8px;
            padding: 0 12px;
        }
        .sidebar-item {
            padding: 12px 16px;
            border-radius: 8px;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
            font-weight: 500;
            color: #495057;
            transition: all 0.3s ease;
            cursor: pointer;
            display: none;
        }
        .sidebar-item:hover {
            background: #e9ecef;
            color: #2c3e50;
        }
        .sidebar-item.active {
            background: #495057;
            color: white;
            font-weight: 600;
        }
        .sidebar-item-logout {
            background: #dc3545;
            color: white;
            font-weight: 600;
            margin-top: 20px;
            border-top: 1px solid #dee2e6;
            padding-top: 20px;
        }
        .sidebar-item-logout:hover {
            background: #c82333;
        }
        /* Main Content */
        .main-content {
            margin-left: 0;
            flex: 1;
            padding: 30px;
            background: #ffffff;
        }
        .container {
            max-width: 1400px;
            margin: 0 auto;
        }
        /* Header */
        .dashboard-header {
            background: white;
            border-radius: 12px;
            padding: 30px 40px;
            margin-bottom: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            border: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header-left h1 {
            font-size: 28px;
            color: #2c3e50;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 700;
        }
        .header-icon {
            width: 40px;
            height: 40px;
            background: #f8f9fa;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            border: 1px solid #dee2e6;
        }
        .header-left p {
            color: #6b7280;
            font-size: 14px;
        }
        .supplier-badge {
            background: #f8f9fa;
            color: #495057;
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
            border: 1px solid #dee2e6;
        }
        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 20px;
            border: 1px solid #dee2e6;
            border-left: 4px solid #495057;
            transition: all 0.3s ease;
        }
        .stat-card:hover {
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }
        .stat-card h3 {
            font-size: 14px;
            font-weight: 500;
            color: #6c757d;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .stat-card p {
            font-size: 32px;
            font-weight: 700;
            color: #495057;
        }
        /* Tabs */
        .tabs {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 8px;
            display: flex;
            gap: 8px;
            margin-bottom: 24px;
            border: 1px solid #dee2e6;
        }
        .tab-button {
            flex: 1;
            padding: 12px 20px;
            border: none;
            background: transparent;
            color: #495057;
            font-weight: 600;
            font-size: 14px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        .tab-button:hover {
            background: #e9ecef;
        }
        .tab-button.active {
            background: #495057;
            color: white;
        }
        .tab-badge {
            background: rgba(255,255,255,0.3);
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 700;
        }
        /* Tab Content */
        .tab-content {
            display: none;
        }
        .tab-content.active {
            display: block;
            animation: fadeIn 0.3s ease;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        /* Order Card */
        .order-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            border: 1px solid #e9ecef;
            transition: all 0.3s ease;
        }
        .order-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f3f4f6;
        }
        .order-title {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .order-id {
            font-size: 20px;
            font-weight: 700;
            color: #2c3e50;
        }
        .status-badge {
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-badge.sent {
            background: #fff3cd;
            color: #664d03;
            border: 1px solid #ffecb5;
        }
        .status-badge.approved {
            background: #cfe2ff;
            color: #084298;
            border: 1px solid #9ec5fe;
        }
        .status-badge.completed {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .order-meta {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-bottom: 20px;
        }
        .meta-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px;
            background: #f9fafb;
            border-radius: 8px;
            border: 1px solid #e5e7eb;
        }
        .meta-icon {
            font-size: 20px;
            color: #495057;
        }
        .meta-content {
            flex: 1;
        }
        .meta-label {
            font-size: 12px;
            color: #6b7280;
            font-weight: 500;
            margin-bottom: 2px;
        }
        .meta-value {
            font-size: 14px;
            color: #2c3e50;
            font-weight: 600;
        }
        /* Items Table */
        .items-section {
            margin-top: 20px;
        }
        .section-title {
            font-size: 16px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        .items-table th {
            background: #f9fafb;
            padding: 12px;
            text-align: left;
            font-size: 13px;
            font-weight: 600;
            color: #495057;
            border-bottom: 2px solid #e5e7eb;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .items-table td {
            padding: 14px 12px;
            border-bottom: 1px solid #f3f4f6;
            font-size: 14px;
            color: #2c3e50;
        }
        .items-table tbody tr:hover {
            background: #f9fafb;
        }
        .priority-badge {
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
        }
        .priority-badge.critical {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .priority-badge.high {
            background: #fff3cd;
            color: #664d03;
            border: 1px solid #ffecb5;
        }
        .priority-badge.medium {
            background: #cfe2ff;
            color: #084298;
            border: 1px solid #9ec5fe;
        }
        .priority-badge.low {
            background: #d1e7dd;
            color: #0f5132;
            border: 1px solid #badbcc;
        }
        /* Buttons */
        .order-actions {
            display: flex;
            gap: 12px;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 2px solid #f3f4f6;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }
        .btn-approve {
            background: #28a745;
            color: white;
            flex: 1;
            border: 1px solid #218838;
        }
        .btn-approve:hover {
            background: #218838;
        }
        .btn-reject {
            background: #dc3545;
            color: white;
            border: 1px solid #c82333;
        }
        .btn-reject:hover {
            background: #c82333;
        }
        .btn-create-asn {
            background: #495057;
            color: white;
            flex: 1;
            border: 1px solid #343a40;
        }
        .btn-create-asn:hover {
            background: #343a40;
        }
        .btn-view {
            background: #e9ecef;
            color: #495057;
            border: 1px solid #dee2e6;
        }
        .btn-view:hover {
            background: #dee2e6;
        }
        /* Details Section */
        .order-details {
            display: none;
            margin-top: 24px;
            padding: 24px;
            background: #f9fafb;
            border-radius: 12px;
            border: 1px solid #e5e7eb;
        }
        .order-details.show {
            display: block;
            animation: slideDown 0.3s ease;
        }
        @keyframes slideDown {
            from {
                opacity: 0;
                max-height: 0;
            }
            to {
                opacity: 1;
                max-height: 2000px;
            }
        }
        .details-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
        }
        .details-section h6 {
            font-size: 14px;
            font-weight: 700;
            color: #2c3e50;
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
            color: #495057;
            width: 180px;
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
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        .item-list li:hover {
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            border-color: #495057;
        }
        .medicine-main-info {
            font-size: 15px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 8px;
        }
        .medicine-detail-row {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 8px;
        }
        .medicine-detail-item {
            display: flex;
            align-items: center;
            gap: 4px;
            font-size: 12px;
            color: #6b7280;
        }
        .medicine-code-badge {
            background: #f3f4f6;
            padding: 4px 8px;
            border-radius: 4px;
            font-family: monospace;
            font-size: 12px;
            color: #495057;
            border: 1px solid #e5e7eb;
        }
        .quantity-badge {
            background: #495057;
            color: white;
            padding: 10px 18px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 16px;
        }
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 12px;
            border: 1px solid #e9ecef;
        }
        .empty-icon {
            font-size: 64px;
            opacity: 0.3;
            margin-bottom: 16px;
        }
        .empty-title {
            font-size: 20px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 8px;
        }
        .empty-text {
            color: #6b7280;
            font-size: 14px;
        }
        /* Notes Box */
        .notes-box {
            background: #e7f1ff;
            border-left: 4px solid #084298;
            border: 1px solid #b6d4fe;
            padding: 14px;
            border-radius: 8px;
            margin-top: 16px;
        }
        .notes-label {
            font-size: 12px;
            font-weight: 600;
            color: #084298;
            margin-bottom: 6px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .notes-text {
            font-size: 14px;
            color: #495057;
            line-height: 1.6;
        }
        /* Notification */
        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 16px 24px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            z-index: 9999;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 600;
            animation: slideIn 0.3s ease;
            max-width: 500px;
        }
        @keyframes slideIn {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        @keyframes slideOut {
            from {
                transform: translateX(0);
                opacity: 1;
            }
            to {
                transform: translateX(100%);
                opacity: 0;
            }
        }
        .notification.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .notification.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .notification .icon {
            font-size: 24px;
        }
        .notification .close-btn {
            margin-left: auto;
            background: none;
            border: none;
            font-size: 20px;
            cursor: pointer;
            color: inherit;
            opacity: 0.7;
            transition: opacity 0.2s;
        }
        .notification .close-btn:hover {
            opacity: 1;
        }
        @media (max-width: 1200px) {
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
           
            .details-grid {
                grid-template-columns: 1fr;
            }
        }
        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                min-height: auto;
                border-right: none;
                border-bottom: 1px solid #dee2e6;
                padding: 15px 0;
                position: static;
            }
            .main-content {
                margin-left: 0;
                padding: 15px;
            }
            .stats-grid,
            .order-meta {
                grid-template-columns: 1fr;
            }
            .tabs {
                flex-direction: column;
            }
            .dashboard-header {
                flex-direction: column;
                gap: 20px;
                padding: 20px;
            }
            .order-actions {
                flex-direction: column;
            }
            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<div class="main-wrapper">
    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-brand">
            <i class="bi bi-building"></i>
            Supplier Portal
        </div>
        <div class="sidebar-menu">
            <div class="sidebar-item active">
                <i class="bi bi-speedometer2"></i>
                Dashboard
            </div>
            <div class="sidebar-item">
                <i class="bi bi-box-seam"></i>
                My Orders
            </div>
            <div class="sidebar-item">
                <i class="bi bi-file-earmark-text"></i>
                ASN History
            </div>
            <div class="sidebar-item">
                <i class="bi bi-graph-up"></i>
                Performance
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="sidebar-item sidebar-item-logout">
                <i class="bi bi-box-arrow-right"></i>
                Logout
            </a>
        </div>
    </div>
    <!-- Main Content -->
    <div class="main-content">
        <div class="container">
            <!-- Notifications -->
            <c:if test="${not empty param.success}">
                <div class="notification success" id="notification">
                    <i class="bi bi-check-circle-fill icon"></i>
                    <span>${param.success}</span>
                    <button class="close-btn" onclick="closeNotification()">
                        <i class="bi bi-x"></i>
                    </button>
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="notification error" id="notification">
                    <i class="bi bi-exclamation-triangle-fill icon"></i>
                    <span>${param.error}</span>
                    <button class="close-btn" onclick="closeNotification()">
                        <i class="bi bi-x"></i>
                    </button>
                </div>
            </c:if>
            <!-- Header -->
            <div class="dashboard-header">
                <div class="header-left">
                    <h1>
                        <span class="header-icon">
                            <i class="bi bi-building"></i>
                        </span>
                        Supplier Dashboard
                    </h1>
                    <p>Welcome back, <strong>${supplier.name}</strong></p>
                </div>
                <div class="supplier-badge">
                    <i class="bi bi-star-fill"></i>
                    Rating: ${supplier.performanceRating}/5.0
                </div>
            </div>
            <!-- Stats Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <h3>Pending Orders</h3>
                    <p>${stats.pendingCount}</p>
                </div>
                <div class="stat-card">
                    <h3>Approved Orders</h3>
                    <p>${stats.approvedCount}</p>
                </div>
                <div class="stat-card">
                    <h3>Completed Orders</h3>
                    <p>${stats.completedCount}</p>
                </div>
                <div class="stat-card">
                    <h3>Total Orders</h3>
                    <p>${stats.totalOrders}</p>
                </div>
            </div>
            <!-- Tabs -->
            <div class="tabs">
                <button class="tab-button active" onclick="showTab('pending')">
                    <i class="bi bi-clock-history"></i>
                    Pending Orders
                    <span class="tab-badge">${stats.pendingCount}</span>
                </button>
                <button class="tab-button" onclick="showTab('approved')">
                    <i class="bi bi-check-circle"></i>
                    Approved Orders
                    <span class="tab-badge">${stats.approvedCount}</span>
                </button>
                <button class="tab-button" onclick="showTab('completed')">
                    <i class="bi bi-box-seam"></i>
                    Completed Orders
                    <span class="tab-badge">${stats.completedCount}</span>
                </button>
            </div>
            <!-- Pending Orders Tab -->
            <div id="pending-tab" class="tab-content active">
                <c:choose>
                    <c:when test="${empty pendingOrders}">
                        <div class="empty-state">
                            <div class="empty-icon">📦</div>
                            <div class="empty-title">No Pending Orders</div>
                            <div class="empty-text">You don't have any pending orders at the moment.</div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="order" items="${pendingOrders}">
                            <div class="order-card">
                                <div class="order-header">
                                    <div class="order-title">
                                        <div class="order-id">PO #${order.poId}</div>
                                        <span class="status-badge sent">
                                            <i class="bi bi-send"></i> ${order.status}
                                        </span>
                                    </div>
                                </div>
                                <div class="order-meta">
                                    <div class="meta-item">
                                        <i class="bi bi-calendar3 meta-icon"></i>
                                        <div class="meta-content">
                                            <div class="meta-label">Order Date</div>
                                            <div class="meta-value">
                                                <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy"/>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="meta-item">
                                        <i class="bi bi-truck meta-icon"></i>
                                        <div class="meta-content">
                                            <div class="meta-label">Expected Delivery</div>
                                            <div class="meta-value">
                                                <fmt:formatDate value="${order.expectedDeliveryDate}" pattern="dd MMM yyyy"/>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="meta-item">
                                        <i class="bi bi-box meta-icon"></i>
                                        <div class="meta-content">
                                            <div class="meta-label">Total Items</div>
                                            <div class="meta-value">${order.items.size()} items</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="items-section">
                                    <div class="section-title">
                                        <i class="bi bi-list-check"></i>
                                        Order Items Summary
                                    </div>
                                    <table class="items-table">
                                        <thead>
                                            <tr>
                                                <th>Medicine Code</th>
                                                <th>Medicine Name</th>
                                                <th>Quantity</th>
                                                <th>Priority</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${order.items}" end="2">
                                                <tr>
                                                    <td><strong>${item.medicineCode}</strong></td>
                                                    <td>${item.medicineName}</td>
                                                    <td><strong>${item.quantity}</strong> ${item.unit != null ? item.unit : ''}</td>
                                                    <td>
                                                        <span class="priority-badge ${item.priority.toLowerCase()}">
                                                            ${item.priority}
                                                        </span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${order.items.size() > 3}">
                                                <tr>
                                                    <td colspan="4" style="text-align: center; color: #6b7280; font-style: italic;">
                                                        + ${order.items.size() - 3} more items
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                                <c:if test="${not empty order.notes}">
                                    <div class="notes-box">
                                        <div class="notes-label">Order Notes</div>
                                        <div class="notes-text">${order.notes}</div>
                                    </div>
                                </c:if>
                                <div class="order-actions">
                                    <button class="btn btn-view" onclick="toggleDetails('pending-${order.poId}')">
                                        <i class="bi bi-eye"></i>
                                        <span id="btn-text-pending-${order.poId}">View Details</span>
                                    </button>
                                    <button class="btn btn-approve" onclick="confirmOrder(${order.poId})">
                                        <i class="bi bi-check-circle"></i>
                                        Approve Order
                                    </button>
                                    <button class="btn btn-reject" onclick="rejectOrder(${order.poId})">
                                        <i class="bi bi-x-circle"></i>
                                        Reject
                                    </button>
                                </div>
                                <!-- Details Section -->
                                <div id="details-pending-${order.poId}" class="order-details">
                                    <div class="details-grid">
                                        <div class="details-section">
                                            <h6><i class="bi bi-info-circle"></i> Complete Order Information</h6>
                                            <table class="details-table">
                                                <tr>
                                                    <td>PO ID:</td>
                                                    <td>#${order.poId}</td>
                                                </tr>
                                                <tr>
                                                    <td>Status:</td>
                                                    <td><span class="status-badge sent">${order.status}</span></td>
                                                </tr>
                                                <tr>
                                                    <td>Order Date:</td>
                                                    <td><fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy"/></td>
                                                </tr>
                                                <tr>
                                                    <td>Expected Delivery:</td>
                                                    <td><fmt:formatDate value="${order.expectedDeliveryDate}" pattern="dd MMM yyyy"/></td>
                                                </tr>
                                                <tr>
                                                    <td>Total Items:</td>
                                                    <td><strong>${order.items.size()}</strong> items</td>
                                                </tr>
                                            </table>
                                        </div>
                                        <div class="details-section">
                                            <h6><i class="bi bi-capsule"></i> All Order Items</h6>
                                            <ul class="item-list">
                                                <c:forEach var="item" items="${order.items}">
                                                    <li>
                                                        <div style="flex: 1;">
                                                            <div class="medicine-main-info">
                                                                ${item.medicineName}
                                                                <span class="medicine-code-badge">${item.medicineCode}</span>
                                                            </div>
                                                            <div class="medicine-detail-row">
                                                                <div class="medicine-detail-item">
                                                                    <i class="bi bi-tag"></i> Priority: ${item.priority}
                                                                </div>
                                                                <c:if test="${not empty item.unit}">
                                                                    <div class="medicine-detail-item">
                                                                        <i class="bi bi-box"></i> Unit: ${item.unit}
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                            <c:if test="${not empty item.notes}">
                                                                <div style="margin-top: 8px; padding: 8px; background: #fff3cd; border-left: 3px solid #ffc107; border-radius: 4px; border: 1px solid #ffecb5;">
                                                                    <div style="font-size: 11px; font-weight: 600; color: #664d03; margin-bottom: 4px;">
                                                                        <i class="bi bi-sticky"></i> NOTES
                                                                    </div>
                                                                    <div style="font-size: 12px; color: #495057;">
                                                                        ${item.notes}
                                                                    </div>
                                                                </div>
                                                            </c:if>
                                                        </div>
                                                        <div>
                                                            <span class="quantity-badge">
                                                                ${item.quantity} units
                                                            </span>
                                                        </div>
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
            <!-- Approved Orders Tab -->
            <div id="approved-tab" class="tab-content">
                <c:choose>
                    <c:when test="${empty approvedOrders}">
                        <div class="empty-state">
                            <div class="empty-icon">✅</div>
                            <div class="empty-title">No Approved Orders</div>
                            <div class="empty-text">You don't have any approved orders ready for shipment.</div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="order" items="${approvedOrders}">
                            <div class="order-card">
                                <div class="order-header">
                                    <div class="order-title">
                                        <div class="order-id">PO #${order.poId}</div>
                                        <span class="status-badge approved">
                                            <i class="bi bi-check-circle"></i> ${order.status}
                                        </span>
                                    </div>
                                </div>
                                <div class="order-meta">
                                    <div class="meta-item">
                                        <i class="bi bi-calendar3 meta-icon"></i>
                                        <div class="meta-content">
                                            <div class="meta-label">Order Date</div>
                                            <div class="meta-value">
                                                <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy"/>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="meta-item">
                                        <i class="bi bi-truck meta-icon"></i>
                                        <div class="meta-content">
                                            <div class="meta-label">Expected Delivery</div>
                                            <div class="meta-value">
                                                <fmt:formatDate value="${order.expectedDeliveryDate}" pattern="dd MMM yyyy"/>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="meta-item">
                                        <i class="bi bi-box meta-icon"></i>
                                        <div class="meta-content">
                                            <div class="meta-label">Total Items</div>
                                            <div class="meta-value">${order.items.size()} items</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="items-section">
                                    <div class="section-title">
                                        <i class="bi bi-list-check"></i>
                                        Order Items Summary
                                    </div>
                                    <table class="items-table">
                                        <thead>
                                            <tr>
                                                <th>Medicine Code</th>
                                                <th>Medicine Name</th>
                                                <th>Quantity</th>
                                                <th>Priority</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${order.items}" end="2">
                                                <tr>
                                                    <td><strong>${item.medicineCode}</strong></td>
                                                    <td>${item.medicineName}</td>
                                                    <td><strong>${item.quantity}</strong></td>
                                                    <td>
                                                        <span class="priority-badge ${item.priority.toLowerCase()}">
                                                            ${item.priority}
                                                        </span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${order.items.size() > 3}">
                                                <tr>
                                                    <td colspan="4" style="text-align: center; color: #6b7280; font-style: italic;">
                                                        + ${order.items.size() - 3} more items
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="order-actions">
                                    <button class="btn btn-view" onclick="toggleDetails('approved-${order.poId}')">
                                        <i class="bi bi-eye"></i>
                                        <span id="btn-text-approved-${order.poId}">View Details</span>
                                    </button>
                                    <a href="${pageContext.request.contextPath}/create-asn?poId=${order.poId}" class="btn btn-create-asn">
                                        <i class="bi bi-file-earmark-plus"></i>
                                        Create Shipping Notice (ASN)
                                    </a>
                                </div>
                                <!-- Details Section -->
                                <div id="details-approved-${order.poId}" class="order-details">
                                    <div class="details-grid">
                                        <div class="details-section">
                                            <h6><i class="bi bi-info-circle"></i> Complete Order Information</h6>
                                            <table class="details-table">
                                                <tr>
                                                    <td>PO ID:</td>
                                                    <td>#${order.poId}</td>
                                                </tr>
                                                <tr>
                                                    <td>Status:</td>
                                                    <td><span class="status-badge approved">${order.status}</span></td>
                                                </tr>
                                                <tr>
                                                    <td>Order Date:</td>
                                                    <td><fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy"/></td>
                                                </tr>
                                                <tr>
                                                    <td>Expected Delivery:</td>
                                                    <td><fmt:formatDate value="${order.expectedDeliveryDate}" pattern="dd MMM yyyy"/></td>
                                                </tr>
                                                <tr>
                                                    <td>Total Items:</td>
                                                    <td><strong>${order.items.size()}</strong> items</td>
                                                </tr>
                                            </table>
                                            <c:if test="${not empty order.notes}">
                                                <div class="notes-box">
                                                    <div class="notes-label">Order Notes</div>
                                                    <div class="notes-text">${order.notes}</div>
                                                </div>
                                            </c:if>
                                        </div>
                                        <div class="details-section">
                                            <h6><i class="bi bi-capsule"></i> All Order Items</h6>
                                            <ul class="item-list">
                                                <c:forEach var="item" items="${order.items}">
                                                    <li>
                                                        <div style="flex: 1;">
                                                            <div class="medicine-main-info">
                                                                ${item.medicineName}
                                                                <span class="medicine-code-badge">${item.medicineCode}</span>
                                                            </div>
                                                            <div class="medicine-detail-row">
                                                                <div class="medicine-detail-item">
                                                                    <i class="bi bi-tag"></i> Priority: ${item.priority}
                                                                </div>
                                                                <c:if test="${not empty item.unit}">
                                                                    <div class="medicine-detail-item">
                                                                        <i class="bi bi-box"></i> Unit: ${item.unit}
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                            <c:if test="${not empty item.notes}">
                                                                <div style="margin-top: 8px; padding: 8px; background: #fff3cd; border-left: 3px solid #ffc107; border-radius: 4px; border: 1px solid #ffecb5;">
                                                                    <div style="font-size: 11px; font-weight: 600; color: #664d03; margin-bottom: 4px;">
                                                                        <i class="bi bi-sticky"></i> NOTES
                                                                    </div>
                                                                    <div style="font-size: 12px; color: #495057;">
                                                                        ${item.notes}
                                                                    </div>
                                                                </div>
                                                            </c:if>
                                                        </div>
                                                        <div>
                                                            <span class="quantity-badge">
                                                                ${item.quantity} units
                                                            </span>
                                                        </div>
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
            <!-- Completed Orders Tab -->
            <div id="completed-tab" class="tab-content">
                <c:choose>
                    <c:when test="${empty completedOrders}">
                        <div class="empty-state">
                            <div class="empty-icon">📋</div>
                            <div class="empty-title">No Completed Orders</div>
                            <div class="empty-text">You don't have any completed orders yet.</div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="order" items="${completedOrders}">
                            <div class="order-card">
                                <div class="order-header">
                                    <div class="order-title">
                                        <div class="order-id">PO #${order.poId}</div>
                                        <span class="status-badge completed">
                                            <i class="bi bi-check-all"></i> ${order.status}
                                        </span>
                                    </div>
                                </div>
                                <div class="order-meta">
                                    <div class="meta-item">
                                        <i class="bi bi-calendar3 meta-icon"></i>
                                        <div class="meta-content">
                                            <div class="meta-label">Order Date</div>
                                            <div class="meta-value">
                                                <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy"/>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="meta-item">
                                        <i class="bi bi-check-circle meta-icon"></i>
                                        <div class="meta-content">
                                            <div class="meta-label">Completed</div>
                                            <div class="meta-value">
                                                <fmt:formatDate value="${order.updatedAt}" pattern="dd MMM yyyy"/>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="meta-item">
                                        <i class="bi bi-box meta-icon"></i>
                                        <div class="meta-content">
                                            <div class="meta-label">Total Items</div>
                                            <div class="meta-value">${order.items.size()} items</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="items-section">
                                    <div class="section-title">
                                        <i class="bi bi-list-check"></i>
                                        Order Items Summary
                                    </div>
                                    <table class="items-table">
                                        <thead>
                                            <tr>
                                                <th>Medicine Code</th>
                                                <th>Medicine Name</th>
                                                <th>Quantity</th>
                                                <th>Priority</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${order.items}" end="2">
                                                <tr>
                                                    <td><strong>${item.medicineCode}</strong></td>
                                                    <td>${item.medicineName}</td>
                                                    <td><strong>${item.quantity}</strong></td>
                                                    <td>
                                                        <span class="priority-badge ${item.priority.toLowerCase()}">
                                                            ${item.priority}
                                                        </span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${order.items.size() > 3}">
                                                <tr>
                                                    <td colspan="4" style="text-align: center; color: #6b7280; font-style: italic;">
                                                        + ${order.items.size() - 3} more items
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="order-actions">
                                    <button class="btn btn-view" onclick="toggleDetails('completed-${order.poId}')" style="flex: 1;">
                                        <i class="bi bi-eye"></i>
                                        <span id="btn-text-completed-${order.poId}">View Details</span>
                                    </button>
                                </div>
                                <!-- Details Section -->
                                <div id="details-completed-${order.poId}" class="order-details">
                                    <div class="details-grid">
                                        <div class="details-section">
                                            <h6><i class="bi bi-info-circle"></i> Complete Order Information</h6>
                                            <table class="details-table">
                                                <tr>
                                                    <td>PO ID:</td>
                                                    <td>#${order.poId}</td>
                                                </tr>
                                                <tr>
                                                    <td>Status:</td>
                                                    <td><span class="status-badge completed">${order.status}</span></td>
                                                </tr>
                                                <tr>
                                                    <td>Order Date:</td>
                                                    <td><fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy"/></td>
                                                </tr>
                                                <tr>
                                                    <td>Completed Date:</td>
                                                    <td><fmt:formatDate value="${order.updatedAt}" pattern="dd MMM yyyy"/></td>
                                                </tr>
                                                <tr>
                                                    <td>Total Items:</td>
                                                    <td><strong>${order.items.size()}</strong> items</td>
                                                </tr>
                                            </table>
                                            <c:if test="${not empty order.notes}">
                                                <div class="notes-box">
                                                    <div class="notes-label">Order Notes</div>
                                                    <div class="notes-text">${order.notes}</div>
                                                </div>
                                            </c:if>
                                        </div>
                                        <div class="details-section">
                                            <h6><i class="bi bi-capsule"></i> All Order Items</h6>
                                            <ul class="item-list">
                                                <c:forEach var="item" items="${order.items}">
                                                    <li>
                                                        <div style="flex: 1;">
                                                            <div class="medicine-main-info">
                                                                ${item.medicineName}
                                                                <span class="medicine-code-badge">${item.medicineCode}</span>
                                                            </div>
                                                            <div class="medicine-detail-row">
                                                                <div class="medicine-detail-item">
                                                                    <i class="bi bi-tag"></i> Priority: ${item.priority}
                                                                </div>
                                                                <c:if test="${not empty item.unit}">
                                                                    <div class="medicine-detail-item">
                                                                        <i class="bi bi-box"></i> Unit: ${item.unit}
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                        <div>
                                                            <span class="quantity-badge">
                                                                ${item.quantity} units
                                                            </span>
                                                        </div>
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>
<script>
    // Tab switching
    function showTab(tabName) {
        var tabs = document.querySelectorAll('.tab-content');
        for (var i = 0; i < tabs.length; i++) {
            tabs[i].classList.remove('active');
        }
       
        var buttons = document.querySelectorAll('.tab-button');
        for (var i = 0; i < buttons.length; i++) {
            buttons[i].classList.remove('active');
        }
       
        document.getElementById(tabName + '-tab').classList.add('active');
        event.target.closest('.tab-button').classList.add('active');
    }
    // Toggle order details
    function toggleDetails(detailsId) {
        const detailsDiv = document.getElementById('details-' + detailsId);
        const btnText = document.getElementById('btn-text-' + detailsId);
       
        if (detailsDiv.classList.contains('show')) {
            detailsDiv.classList.remove('show');
            btnText.textContent = 'View Details';
        } else {
            detailsDiv.classList.add('show');
            btnText.textContent = 'Hide Details';
        }
    }
    // Confirm order
    function confirmOrder(poId) {
        if (confirm('Are you sure you want to approve this purchase order?')) {
            window.location.href = '${pageContext.request.contextPath}/supplier-confirm-order?poId=' + poId + '&action=approve';
        }
    }
    // Reject order
    function rejectOrder(poId) {
        var reason = prompt('Please enter the reason for rejection:');
        if (reason && reason.trim() !== '') {
            window.location.href = '${pageContext.request.contextPath}/supplier-confirm-order?poId=' + poId + '&action=reject&reason=' + encodeURIComponent(reason);
        }
    }
    // Auto hide notification after 5 seconds
    if (document.getElementById('notification')) {
        setTimeout(function() {
            closeNotification();
        }, 5000);
    }
    // Close notification
    function closeNotification() {
        const notification = document.getElementById('notification');
        if (notification) {
            notification.style.animation = 'slideOut 0.3s ease';
            setTimeout(function() {
                notification.remove();
                const url = new URL(window.location);
                url.searchParams.delete('success');
                url.searchParams.delete('error');
                window.history.replaceState({}, '', url);
            }, 300);
        }
    }
</script>

<jsp:include page="/admin/footer.jsp" />

</body>
</html>