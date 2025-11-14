<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Purchase Orders - Auditor</title>
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
                display: flex;
                flex-direction: column;
            }

            .page-wrapper {
                display: flex;
                flex: 1;
            }

            .dashboard-container {
                display: flex;
                flex: 1;
                width: 100%;
            }

            /* Sidebar styling */
            .sidebar {
                width: 280px;
                background: white;
                color: #1f2937;
                padding: 30px 20px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                border-right: 1px solid #e5e7eb;
                overflow-y: auto;
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

            /* Removed user-info styling */

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

            /* Main content area styling */
            .main-content {
                flex: 1;
                padding: 40px;
                overflow-y: auto;
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
            }

            /* Stats cards styling */
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
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                transition: all 0.3s ease;
                border-left: 5px solid #3b82f6;
            }

            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
            }

            .stat-card.success {
                border-left-color: #10b981;
            }

            .stat-card.warning {
                border-left-color: #f59e0b;
            }

            .stat-card.info {
                border-left-color: #3b82f6;
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

            /* Card styling */
            .dashboard-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                margin-bottom: 30px;
                overflow: hidden;
            }

            .card-header {
                background: white;
                padding: 24px;
                border-bottom: 1px solid #e5e7eb;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .card-header h5 {
                font-size: 18px;
                font-weight: 700;
                color: #1f2937;
                margin: 0;
            }

            .card-body {
                padding: 24px;
            }

            /* Filter section styling */
            .filter-section {
                background: white;
                border-radius: 15px;
                padding: 24px;
                margin-bottom: 30px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            }

            .filter-section label {
                font-size: 14px;
                font-weight: 600;
                color: #374151;
                margin-bottom: 8px;
                display: block;
            }

            .filter-section select,
            .filter-section input {
                width: 100%;
                padding: 10px 12px;
                border: 1px solid #e5e7eb;
                border-radius: 8px;
                font-family: inherit;
                font-size: 14px;
                transition: all 0.3s ease;
            }

            .filter-section select:focus,
            .filter-section input:focus {
                outline: none;
                border-color: #3b82f6;
                box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
            }

            .filter-buttons {
                display: flex;
                gap: 12px;
                margin-top: 20px;
            }

            .btn {
                padding: 10px 20px;
                border: none;
                border-radius: 8px;
                font-family: inherit;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

            .btn-primary {
                background: #3b82f6;
                color: white;
            }

            .btn-primary:hover {
                background: #2563eb;
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(59, 130, 246, 0.3);
            }

            .btn-secondary {
                background: #e5e7eb;
                color: #374151;
            }

            .btn-secondary:hover {
                background: #d1d5db;
            }

            .btn-success {
                background: #10b981;
                color: white;
            }

            .btn-success:hover {
                background: #059669;
            }

            /* Table styling */
            .table-responsive {
                overflow-x: auto;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                font-size: 14px;
            }

            thead {
                background: #f9fafb;
                border-bottom: 2px solid #e5e7eb;
            }

            th {
                padding: 16px;
                text-align: left;
                font-weight: 600;
                color: #374151;
            }

            td {
                padding: 16px;
                border-bottom: 1px solid #e5e7eb;
            }

            tbody tr:hover {
                background: #f9fafb;
            }

            .badge {
                display: inline-block;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
            }

            .badge-secondary {
                background: #e5e7eb;
                color: #374151;
            }

            .btn-sm {
                padding: 6px 12px;
                font-size: 12px;
                border: none;
                border-radius: 6px;
                background: #3b82f6;
                color: white;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 6px;
            }

            .btn-sm:hover {
                background: #2563eb;
                transform: translateY(-2px);
            }

            .empty-state {
                text-align: center;
                padding: 40px 20px;
            }

            .empty-state i {
                font-size: 3rem;
                color: #d1d5db;
                margin-bottom: 16px;
            }

            .empty-state p {
                color: #9ca3af;
                font-size: 14px;
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

                .filter-section {
                    padding: 16px;
                }

                .filter-buttons {
                    flex-direction: column;
                }

                .btn {
                    width: 100%;
                    justify-content: center;
                }
            }

            ::-webkit-scrollbar {
                width: 8px;
            }

            ::-webkit-scrollbar-track {
                background: rgba(0, 0, 0, 0.1);
            }

            ::-webkit-scrollbar-thumb {
                background: rgba(0, 0, 0, 0.2);
                border-radius: 4px;
            }
        </style>
    </head>
    <body>
        <!-- Include header.jsp -->
        <%@ include file="/admin/header.jsp" %>

        <div class="page-wrapper">
            <div class="dashboard-container">
                <!-- Sidebar navigation -->
                <div class="sidebar">
                    <div class="sidebar-header">
                        <h4><i class="bi bi-hospital"></i> Pharmacy</h4>
                        <hr class="sidebar-divider">
                        <!-- Removed user-info section -->
                    </div>

                    <nav>
                        <a class="nav-link" href="${pageContext.request.contextPath}/auditor-dashboard">
                            <i class="bi bi-speedometer2"></i> Dashboard
                        </a>
                        <a class="nav-link active" href="${pageContext.request.contextPath}/purchase-orders">
                            <i class="bi bi-receipt"></i> Purchase Orders
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/purchase-orders/history">
                            <i class="bi bi-clock-history"></i> PO History & Trends
                        </a>

                        <hr class="nav-divider">


                        <!-- Audit Log Section -->
                        <a class="nav-link" href="${pageContext.request.contextPath}/auditlog?action=view">
                            <i class="bi bi-clipboard-data"></i> Audit Logs
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/auditlog?action=statistics">
                            <i class="bi bi-graph-up"></i> Statistics
                        </a>


                    </nav>
                </div>

                <!-- Main Content -->
                <div class="main-content">
                    <div class="page-header">
                        <h2><i class="bi bi-receipt"></i> Purchase Orders Management</h2>
                    </div>

                    <!-- Statistics Cards -->
                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-content">
                                <div class="stat-info">
                                    <h6>Total Orders</h6>
                                    <h3>${totalOrders}</h3>
                                </div>
                                <div class="stat-icon" style="color: #3b82f6;">
                                    <i class="bi bi-cart"></i>
                                </div>
                            </div>
                        </div>
                        <div class="stat-card success">
                            <div class="stat-content">
                                <div class="stat-info">
                                    <h6>Completed</h6>
                                    <h3>${completedOrders}</h3>
                                </div>
                                <div class="stat-icon" style="color: #10b981;">
                                    <i class="bi bi-check-circle"></i>
                                </div>
                            </div>
                        </div>
                        <div class="stat-card warning">
                            <div class="stat-content">
                                <div class="stat-info">
                                    <h6>Pending</h6>
                                    <h3>${pendingOrders}</h3>
                                </div>
                                <div class="stat-icon" style="color: #f59e0b;">
                                    <i class="bi bi-clock"></i>
                                </div>
                            </div>
                        </div>
                        <div class="stat-card info">
                            <div class="stat-content">
                                <div class="stat-info">
                                    <h6>Total Amount</h6>
                                    <h3><fmt:formatNumber value="${totalAmount}" type="currency" currencySymbol="VNĐ"/></h3>
                                </div>
                                <div class="stat-icon" style="color: #3b82f6;">
                                    <i class="bi bi-cash-stack"></i>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Filter Section -->
                    <div class="filter-section">
                        <form method="get" action="purchase-orders" id="filterForm">
                            <input type="hidden" name="action" value="list">
                            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; margin-bottom: 16px;">
                                <div>
                                    <label>Status</label>
                                    <select name="status">
                                        <option value="">All Statuses</option>
                                        <c:forEach var="status" items="${statuses}">
                                            <option value="${status}" ${selectedStatus == status ? 'selected' : ''}>
                                                ${status}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div>
                                    <label>Supplier</label>
                                    <select name="supplierId">
                                        <option value="">All Suppliers</option>
                                        <c:forEach var="supplier" items="${suppliers}">
                                            <option value="${supplier.supplierId}" ${selectedSupplierId == supplier.supplierId ? 'selected' : ''}>
                                                ${supplier.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div>
                                    <label>From Date</label>
                                    <input type="date" name="fromDate" value="${fromDate}">
                                </div>
                                <div>
                                    <label>To Date</label>
                                    <input type="date" name="toDate" value="${toDate}">
                                </div>
                                <div>
                                    <label>Search</label>
                                    <input type="text" name="search" placeholder="PO ID, Supplier..." value="${searchKeyword}">
                                </div>
                            </div>
                            <div class="filter-buttons">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-search"></i> Filter
                                </button>
                                <button type="button" class="btn btn-secondary" onclick="clearFilters()">
                                    <i class="bi bi-x-circle"></i> Clear
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- Purchase Orders Table -->
                    <!-- Replace the existing table section in your JSP with this -->
<div class="dashboard-card">
    <div class="card-header">
        <h5><i class="bi bi-list-ul"></i> Purchase Orders List</h5>
    </div>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table>
                <thead>
                    <tr>
                        <th>PO ID</th>
                        <th>Order Date</th>
                        <th>Supplier</th>
                        <th>Manager</th>
                        <th>PO Status</th>
                        <th>Shipping Info</th>
                        <th>Items</th>
                        <th>Total Amount</th>
                        <th>Expected Delivery</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty purchaseOrders}">
                            <tr>
                                <td colspan="10">
                                    <div class="empty-state">
                                        <i class="bi bi-inbox"></i>
                                        <p>No purchase orders found</p>
                                    </div>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="po" items="${purchaseOrders}">
                                <tr>
                                    <td><strong>#${po.poId}</strong></td>
                                    <td><fmt:formatDate value="${po.orderDate}" pattern="dd/MM/yyyy"/></td>
                                    <td>${po.supplierName}</td>
                                    <td>${po.managerName}</td>
                                    
                                    <!-- ✅ FIXED: Show actual PO status -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${po.status == 'Completed' || po.status == 'Paid'}">
                                                <span class="badge badge-success">${po.status}</span>
                                            </c:when>
                                            <c:when test="${po.status == 'Approved' || po.status == 'Received'}">
                                                <span class="badge badge-primary">${po.status}</span>
                                            </c:when>
                                            <c:when test="${po.status == 'Sent'}">
                                                <span class="badge" style="background: #bfdbfe; color: #1e40af;">${po.status}</span>
                                            </c:when>
                                            <c:when test="${po.status == 'Draft'}">
                                                <span class="badge badge-secondary">${po.status}</span>
                                            </c:when>
                                            <c:when test="${po.status == 'Rejected' || po.status == 'Cancelled'}">
                                                <span class="badge" style="background: #fecaca; color: #991b1b;">${po.status}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-secondary">${po.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    
                                    <!-- ✅ Shipping info in separate column -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${po.hasAsn}">
                                                <c:choose>
                                                    <c:when test="${po.asnStatus == 'Delivered'}">
                                                        <span class="badge" style="background: #d1fae5; color: #065f46;">
                                                            <i class="bi bi-check-circle"></i> Delivered
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${po.asnStatus == 'InTransit'}">
                                                        <span class="badge" style="background: #dbeafe; color: #1e40af;">
                                                            <i class="bi bi-truck"></i> In Transit
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${po.asnStatus == 'Sent'}">
                                                        <span class="badge" style="background: #e0e7ff; color: #4338ca;">
                                                            <i class="bi bi-send"></i> Shipped
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-secondary">${po.asnStatus}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:if test="${not empty po.trackingNumber}">
                                                    <br>
                                                    <small style="color: #6b7280; font-size: 11px;">
                                                        ${po.trackingNumber}
                                                    </small>
                                                </c:if>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #9ca3af; font-size: 13px;">
                                                    <i class="bi bi-dash-circle"></i> No shipment
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    
                                    <td><span class="badge badge-secondary">${po.itemCount} items</span></td>
                                    <td><fmt:formatNumber value="${po.totalAmount}" type="currency" currencySymbol="$"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty po.expectedDeliveryDate}">
                                                <fmt:formatDate value="${po.expectedDeliveryDate}" pattern="dd/MM/yyyy"/>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #9ca3af;">N/A</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="purchase-orders?action=view&id=${po.poId}" class="btn-sm">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>
                </div>
            </div>
        </div>

        <!-- Include footer.jsp -->
        <%@ include file="/admin/footer.jsp" %>

        <script>
            function clearFilters() {
                window.location.href = 'purchase-orders?action=list';
            }

            function exportToExcel() {
                alert('Export functionality to be implemented');
            }
        </script>
    </body>
</html>
