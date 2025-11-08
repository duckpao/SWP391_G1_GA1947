<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PO History & Trends - PWMS</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: #f5f7fa;
            color: #2d3748;
            overflow-x: hidden;
        }

        /* Header */
        .top-header {
            background: white;
            padding: 1rem 2rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.04);
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .logo-section h4 {
            font-weight: 700;
            color: #2d3748;
            margin: 0;
        }

        .logo-section small {
            color: #718096;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .header-actions {
            display: flex;
            gap: 0.75rem;
            align-items: center;
        }

        .header-actions .btn {
            border-radius: 8px;
            padding: 0.5rem 1rem;
            font-size: 0.875rem;
            font-weight: 500;
        }

        /* Sidebar */
        .sidebar {
            position: fixed;
            left: 0;
            top: 70px;
            width: 240px;
            height: calc(100vh - 70px);
            background: white;
            border-right: 1px solid #e2e8f0;
            padding: 1.5rem 0;
            overflow-y: auto;
        }

        .sidebar-section {
            margin-bottom: 1.5rem;
        }

        .sidebar-title {
            padding: 0 1.5rem;
            font-size: 0.75rem;
            font-weight: 700;
            color: #a0aec0;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 0.5rem;
        }

        .nav-item {
            padding: 0.75rem 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            color: #4a5568;
            text-decoration: none;
            transition: all 0.2s;
            cursor: pointer;
            font-size: 0.875rem;
        }

        .nav-item:hover {
            background: #f7fafc;
            color: #2b6cb0;
        }

        .nav-item.active {
            background: #ebf8ff;
            color: #2b6cb0;
            border-right: 3px solid #3182ce;
            font-weight: 600;
        }

        .nav-item i {
            font-size: 1.125rem;
            width: 20px;
        }

        /* Main Content */
        .main-content {
            margin-left: 240px;
            padding: 2rem;
            min-height: calc(100vh - 70px);
        }

        .page-header {
            margin-bottom: 1.5rem;
        }

        .page-header h2 {
            font-size: 1.75rem;
            font-weight: 700;
            color: #2d3748;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 0.25rem;
        }

        .page-header .subtitle {
            color: #718096;
            font-size: 0.875rem;
        }

        /* Statistics Cards */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1.25rem;
            margin-bottom: 1.5rem;
        }

        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            border: 1px solid #e2e8f0;
            position: relative;
            transition: all 0.3s;
        }

        .stat-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            transform: translateY(-2px);
        }

        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 0.75rem;
        }

        .stat-label {
            font-size: 0.8125rem;
            color: #718096;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stat-icon {
            width: 42px;
            height: 42px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
        }

        .stat-icon.blue {
            background: #ebf8ff;
            color: #3182ce;
        }

        .stat-icon.green {
            background: #f0fff4;
            color: #38a169;
        }

        .stat-icon.orange {
            background: #fffaf0;
            color: #dd6b20;
        }

        .stat-icon.purple {
            background: #faf5ff;
            color: #805ad5;
        }

        .stat-value {
            font-size: 1.875rem;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 0.25rem;
        }

        .stat-subtitle {
            font-size: 0.75rem;
            color: #a0aec0;
        }

        /* Charts Section */
        .charts-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 1.25rem;
            margin-bottom: 1.5rem;
        }

        .card {
            background: white;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            overflow: hidden;
        }

        .card-header {
            background: white;
            border-bottom: 1px solid #e2e8f0;
            padding: 1.25rem 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.625rem;
        }

        .card-header h5 {
            font-size: 1rem;
            font-weight: 600;
            color: #2d3748;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .card-body {
            padding: 1.5rem;
        }

        .chart-container {
            position: relative;
            height: 320px;
        }

        /* Supplier List */
        .supplier-list {
            max-height: 380px;
            overflow-y: auto;
        }

        .supplier-item {
            padding: 1rem;
            border-bottom: 1px solid #f7fafc;
            transition: background 0.2s;
        }

        .supplier-item:last-child {
            border-bottom: none;
        }

        .supplier-item:hover {
            background: #f7fafc;
        }

        .supplier-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.5rem;
        }

        .supplier-name {
            font-weight: 600;
            color: #2d3748;
            font-size: 0.875rem;
        }

        .rank-badge {
            background: #edf2f7;
            color: #4a5568;
            padding: 0.25rem 0.625rem;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .rank-badge.rank-1 {
            background: #fef3c7;
            color: #92400e;
        }

        .rank-badge.rank-2 {
            background: #e5e7eb;
            color: #374151;
        }

        .rank-badge.rank-3 {
            background: #fed7aa;
            color: #7c2d12;
        }

        .supplier-meta {
            font-size: 0.75rem;
            color: #718096;
            margin-bottom: 0.5rem;
        }

        .progress-bar-wrapper {
            height: 6px;
            background: #edf2f7;
            border-radius: 3px;
            overflow: hidden;
            margin-bottom: 0.375rem;
        }

        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #3182ce, #38a169);
            transition: width 0.6s ease;
        }

        .completion-text {
            font-size: 0.6875rem;
            color: #a0aec0;
        }

        /* Filter Section */
        .filter-section {
            background: white;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .filter-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .form-group label {
            font-size: 0.8125rem;
            font-weight: 600;
            color: #4a5568;
            margin-bottom: 0.5rem;
            display: block;
        }

        .form-control, .form-select {
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 0.625rem 0.875rem;
            font-size: 0.875rem;
            transition: all 0.2s;
        }

        .form-control:focus, .form-select:focus {
            border-color: #3182ce;
            box-shadow: 0 0 0 3px rgba(49, 130, 206, 0.1);
            outline: none;
        }

        .btn-group {
            display: flex;
            gap: 0.75rem;
        }

        .btn {
            padding: 0.625rem 1.25rem;
            border-radius: 8px;
            font-size: 0.875rem;
            font-weight: 500;
            border: none;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background: #3182ce;
            color: white;
        }

        .btn-primary:hover {
            background: #2c5282;
        }

        .btn-secondary {
            background: #edf2f7;
            color: #4a5568;
        }

        .btn-secondary:hover {
            background: #e2e8f0;
        }

        .btn-success {
            background: #38a169;
            color: white;
        }

        .btn-success:hover {
            background: #2f855a;
        }

        /* Table */
        .table-container {
            background: white;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            overflow: hidden;
        }

        .table-header {
            background: white;
            border-bottom: 1px solid #e2e8f0;
            padding: 1.25rem 1.5rem;
        }

        .table-header h5 {
            font-size: 1rem;
            font-weight: 600;
            color: #2d3748;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .table-responsive {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background: #f7fafc;
        }

        th {
            padding: 1rem 1.25rem;
            text-align: left;
            font-size: 0.75rem;
            font-weight: 700;
            color: #4a5568;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 1px solid #e2e8f0;
        }

        td {
            padding: 1rem 1.25rem;
            font-size: 0.875rem;
            color: #4a5568;
            border-bottom: 1px solid #f7fafc;
        }

        tbody tr:hover {
            background: #f7fafc;
        }

        /* Status Badges */
        .badge {
            padding: 0.375rem 0.75rem;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 600;
            display: inline-block;
        }

        .badge-success {
            background: #d1fae5;
            color: #065f46;
        }

        .badge-primary {
            background: #dbeafe;
            color: #1e40af;
        }

        .badge-warning {
            background: #fef3c7;
            color: #92400e;
        }

        .badge-info {
            background: #e0e7ff;
            color: #3730a3;
        }

        /* Action Button */
        .action-btn {
            background: #3182ce;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            text-decoration: none;
            font-size: 0.8125rem;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 0.375rem;
            transition: all 0.2s;
        }

        .action-btn:hover {
            background: #2c5282;
            color: white;
            transform: translateY(-1px);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
        }

        .empty-state-icon {
            font-size: 3rem;
            color: #cbd5e0;
            margin-bottom: 1rem;
        }

        .empty-state h5 {
            font-weight: 600;
            color: #4a5568;
            margin-bottom: 0.5rem;
        }

        .empty-state p {
            color: #a0aec0;
            font-size: 0.875rem;
        }

        /* Responsive */
        @media (max-width: 1200px) {
            .stats-row {
                grid-template-columns: repeat(2, 1fr);
            }

            .charts-grid {
                grid-template-columns: 1fr;
            }

            .filter-grid {
                grid-template-columns: repeat(3, 1fr);
            }
        }

        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
            }

            .main-content {
                margin-left: 0;
            }

            .stats-row {
                grid-template-columns: 1fr;
            }

            .filter-grid {
                grid-template-columns: 1fr;
            }
        }

        /* Scrollbar */
        ::-webkit-scrollbar {
            width: 8px;
            height: 8px;
        }

        ::-webkit-scrollbar-track {
            background: #f7fafc;
        }

        ::-webkit-scrollbar-thumb {
            background: #cbd5e0;
            border-radius: 4px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: #a0aec0;
        }
    </style>
</head>
<body>
    <!-- Top Header -->
    <div class="top-header">
        <div class="logo-section">
            <h4>PWMS</h4>
            <small>Pharmacy Warehouse Management</small>
        </div>
        <div class="header-actions">
            <button class="btn btn-secondary">
                <i class="bi bi-chat-dots"></i> Chat
            </button>
            <button class="btn btn-primary">
                <i class="bi bi-headset"></i> Support
            </button>
            <button class="btn btn-danger">
                <i class="bi bi-box-arrow-right"></i> Logout
            </button>
            <div class="d-flex align-items-center gap-2">
                <div class="bg-secondary text-white rounded-circle d-flex align-items-center justify-content-center" 
                     style="width: 36px; height: 36px;">
                    <strong>A</strong>
                </div>
                <div>
                    <div style="font-size: 0.875rem; font-weight: 600;">auditor2</div>
                    <div style="font-size: 0.75rem; color: #718096;">Auditor</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-section">
            <div class="sidebar-title"><i class="bi bi-hospital"></i> Auditor</div>
            <a href="${pageContext.request.contextPath}/auditor/auditor-dashboard.jsp" class="nav-item">
                <i class="bi bi-speedometer2"></i>
                <span>Dashboard</span>
            </a>
            <a href="${pageContext.request.contextPath}/purchase-orders" class="nav-item">
                <i class="bi bi-receipt"></i>
                <span>Purchase Orders</span>
            </a>
            <a href="${pageContext.request.contextPath}/purchase-orders/history" class="nav-item active">
                <i class="bi bi-clock-history"></i>
                <span>PO History & Trends</span>
            </a>
        </div>

        <div class="sidebar-section">
            <div class="sidebar-title">Audit Tools</div>
            <a href="${pageContext.request.contextPath}/auditlog?action=view" class="nav-item">
                <i class="bi bi-clipboard-data"></i>
                <span>Audit Logs</span>
            </a>
            <a href="${pageContext.request.contextPath}/auditlog?action=statistics" class="nav-item">
                <i class="bi bi-graph-up"></i>
                <span>Statistics</span>
            </a>
            <a href="${pageContext.request.contextPath}/auditlog?action=alerts" class="nav-item">
                <i class="bi bi-exclamation-triangle"></i>
                <span>Security Alerts</span>
            </a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <h2>
                <i class="bi bi-clock-history"></i>
                Purchase Orders History & Trends
            </h2>
            <div class="subtitle">Historical analysis and performance metrics</div>
        </div>

        <!-- Statistics Cards -->
        <div class="stats-row">
            <div class="stat-card">
                <div class="stat-header">
                    <div>
                        <div class="stat-label">Total Orders</div>
                        <div class="stat-value">${totalHistoricalOrders}</div>
                        <div class="stat-subtitle">Historical records</div>
                    </div>
                    <div class="stat-icon blue">
                        <i class="bi bi-cart-check"></i>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div>
                        <div class="stat-label">Total Amount</div>
                        <div class="stat-value">
                            <fmt:formatNumber value="${totalHistoricalAmount}" pattern="#,###" /> đ
                        </div>
                        <div class="stat-subtitle">All transactions</div>
                    </div>
                    <div class="stat-icon green">
                        <i class="bi bi-cash-stack"></i>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div>
                        <div class="stat-label">Avg Order Value</div>
                        <div class="stat-value">
                            <fmt:formatNumber value="${avgOrderValue}" pattern="#,###" /> đ
                        </div>
                        <div class="stat-subtitle">Per order</div>
                    </div>
                    <div class="stat-icon purple">
                        <i class="bi bi-calculator"></i>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div>
                        <div class="stat-label">Suppliers</div>
                        <div class="stat-value">${supplierPerformance.size()}</div>
                        <div class="stat-subtitle">Active suppliers</div>
                    </div>
                    <div class="stat-icon orange">
                        <i class="bi bi-building"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Charts Section -->
        <div class="charts-grid">
            <!-- Trend Chart -->
            <div class="card">
                <div class="card-header">
                    <h5>
                        <i class="bi bi-graph-up-arrow"></i>
                        Order Trends Over Time
                    </h5>
                </div>
                <div class="card-body">
                    <div class="chart-container">
                        <canvas id="trendChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- Top Suppliers -->
            <div class="card">
                <div class="card-header">
                    <h5>
                        <i class="bi bi-trophy"></i>
                        Top Suppliers
                    </h5>
                </div>
                <div class="card-body p-0">
                    <div class="supplier-list">
                        <c:choose>
                            <c:when test="${empty supplierPerformance}">
                                <div class="empty-state" style="padding: 2rem;">
                                    <div class="empty-state-icon">
                                        <i class="bi bi-inbox"></i>
                                    </div>
                                    <p>No supplier data</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="perf" items="${supplierPerformance}" varStatus="status">
                                    <c:if test="${status.index < 5}">
                                        <div class="supplier-item">
                                            <div class="supplier-header">
                                                <span class="supplier-name">${perf.supplierName}</span>
                                                <span class="rank-badge rank-${status.index + 1}">
                                                    #${status.index + 1}
                                                </span>
                                            </div>
                                            <div class="supplier-meta">
                                                ${perf.totalOrders} orders • 
                                                <fmt:formatNumber value="${perf.totalAmount}" pattern="#,###"/> đ
                                            </div>
                                            <div class="progress-bar-wrapper">
                                                <div class="progress-bar-fill" 
                                                     style="width: ${(perf.completedOrders * 100.0 / perf.totalOrders)}%">
                                                </div>
                                            </div>
                                            <div class="completion-text">
                                                ${perf.completedOrders}/${perf.totalOrders} completed 
                                                (${String.format("%.0f", (perf.completedOrders * 100.0 / perf.totalOrders))}%)
                                            </div>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filter Section -->
        <div class="filter-section">
            <form method="get" action="${pageContext.request.contextPath}/purchase-orders/history">
                <div class="filter-grid">
                    <div class="form-group">
                        <label>Supplier</label>
                        <select name="supplierId" class="form-select">
                            <option value="">All Suppliers</option>
                            <c:forEach var="supplier" items="${suppliers}">
                                <option value="${supplier.supplierId}" 
                                        ${selectedSupplierId == supplier.supplierId ? 'selected' : ''}>
                                    ${supplier.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>From Date</label>
                        <input type="date" name="fromDate" class="form-control" value="${fromDate}">
                    </div>
                    <div class="form-group">
                        <label>To Date</label>
                        <input type="date" name="toDate" class="form-control" value="${toDate}">
                    </div>
                    <div class="form-group">
                        <label>Search</label>
                        <input type="text" name="search" class="form-control" 
                               placeholder="PO ID, Supplier..." value="${searchKeyword}">
                    </div>
                    <div class="form-group" style="display: flex; align-items: flex-end;">
                        <div class="btn-group" style="width: 100%;">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-funnel"></i> Filter
                            </button>
                            <button type="button" class="btn btn-secondary" onclick="clearFilters()">
                                <i class="bi bi-x-circle"></i> Clear
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </div>

        <!-- Table -->
        <div class="table-container">
            <div class="table-header">
                <h5>
                    <i class="bi bi-list-ul"></i>
                    Purchase Orders List
                </h5>
            </div>
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>PO ID</th>
                            <th>Order Date</th>
                            <th>Supplier</th>
                            <th>Manager</th>
                            <th>Status</th>
                            <th>Items</th>
                            <th>Total Amount</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty historicalOrders}">
                                <tr>
                                    <td colspan="8">
                                        <div class="empty-state">
                                            <div class="empty-state-icon">
                                                <i class="bi bi-inbox"></i>
                                            </div>
                                            <h5>No Historical Orders Found</h5>
                                            <p>Try adjusting your filters or check back later</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="po" items="${historicalOrders}">
                                    <tr>
                                        <td><strong>#${po.poId}</strong></td>
                                        <td>
                                            <fmt:formatDate value="${po.orderDate}" pattern="dd/MM/yyyy"/>
                                        </td>
                                        <td>${po.supplierName}</td>
                                        <td>${po.managerName}</td>
                                        <td>
                                            <span class="badge badge-success">${po.status}</span>
                                        </td>
                                        <td>
                                            <span class="badge badge-primary">${po.itemCount} items</span>
                                        </td>
                                        <td>
                                            <strong>
                                                <fmt:formatNumber value="${po.totalAmount}" pattern="#,###"/> đ
                                            </strong>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/purchase-orders?action=view&id=${po.poId}" 
                                               class="action-btn">
                                                <i class="bi bi-eye"></i> View
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Trend Chart
        const trendData = ${trendData};
        
        if (trendData && trendData.length > 0) {
            const labels = trendData.map(d => d.month + '/' + d.year);
            const orderCounts = trendData.map(d => d.orderCount);
            const amounts = trendData.map(d => d.totalAmount);

            const ctx = document.getElementById('trendChart');
            if (ctx) {
                new Chart(ctx.getContext('2d'), {
                    type: 'line',
                    data: {
                        labels: labels,
                        datasets: [
                            {
                                label: 'Number of Orders',
                                data: orderCounts,
                                borderColor: '#3182ce',
                                backgroundColor: 'rgba(49, 130, 206, 0.1)',
                                borderWidth: 2,
                                fill: true,
                                yAxisID: 'y',
                                tension: 0.4,
                                pointRadius: 4,
                                pointHoverRadius: 6,
                                pointBackgroundColor: '#3182ce',
                                pointBorderColor: '#fff',
                                pointBorderWidth: 2
                            },
                            {
                                label: 'Total Amount (đ)',
                                data: amounts,
                                borderColor: '#38a169',
                                backgroundColor: 'rgba(56, 161, 105, 0.1)',
                                borderWidth: 2,
                                fill: true,
                                yAxisID: 'y1',
                                tension: 0.4,
                                pointRadius: 4,
                                pointHoverRadius: 6,
                                pointBackgroundColor: '#38a169',
                                pointBorderColor: '#fff',
                                pointBorderWidth: 2
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        interaction: {
                            mode: 'index',
                            intersect: false,
                        },
                        plugins: {
                            legend: {
                                display: true,
                                position: 'top',
                                labels: {
                                    usePointStyle: true,
                                    padding: 15,
                                    font: {
                                        size: 12,
                                        weight: '500',
                                        family: "'Inter', sans-serif"
                                    }
                                }
                            },
                            tooltip: {
                                backgroundColor: 'rgba(0, 0, 0, 0.8)',
                                padding: 12,
                                titleFont: {
                                    size: 13,
                                    weight: '600',
                                    family: "'Inter', sans-serif"
                                },
                                bodyFont: {
                                    size: 12,
                                    family: "'Inter', sans-serif"
                                },
                                callbacks: {
                                    label: function(context) {
                                        let label = context.dataset.label || '';
                                        if (label) {
                                            label += ': ';
                                        }
                                        if (context.parsed.y !== null) {
                                            if (context.datasetIndex === 1) {
                                                label += new Intl.NumberFormat('vi-VN').format(context.parsed.y) + ' đ';
                                            } else {
                                                label += context.parsed.y;
                                            }
                                        }
                                        return label;
                                    }
                                }
                            }
                        },
                        scales: {
                            y: {
                                type: 'linear',
                                display: true,
                                position: 'left',
                                title: {
                                    display: true,
                                    text: 'Number of Orders',
                                    font: {
                                        size: 11,
                                        weight: '600',
                                        family: "'Inter', sans-serif"
                                    },
                                    color: '#3182ce'
                                },
                                grid: {
                                    color: 'rgba(0, 0, 0, 0.05)',
                                    drawBorder: false
                                },
                                ticks: {
                                    font: {
                                        size: 10,
                                        family: "'Inter', sans-serif"
                                    },
                                    color: '#718096'
                                }
                            },
                            y1: {
                                type: 'linear',
                                display: true,
                                position: 'right',
                                title: {
                                    display: true,
                                    text: 'Amount (đ)',
                                    font: {
                                        size: 11,
                                        weight: '600',
                                        family: "'Inter', sans-serif"
                                    },
                                    color: '#38a169'
                                },
                                grid: {
                                    drawOnChartArea: false,
                                    drawBorder: false
                                },
                                ticks: {
                                    font: {
                                        size: 10,
                                        family: "'Inter', sans-serif"
                                    },
                                    color: '#718096',
                                    callback: function(value) {
                                        return new Intl.NumberFormat('vi-VN', {
                                            notation: 'compact',
                                            compactDisplay: 'short'
                                        }).format(value);
                                    }
                                }
                            },
                            x: {
                                grid: {
                                    color: 'rgba(0, 0, 0, 0.05)',
                                    drawBorder: false
                                },
                                ticks: {
                                    font: {
                                        size: 10,
                                        family: "'Inter', sans-serif"
                                    },
                                    color: '#718096'
                                }
                            }
                        }
                    }
                });
            }
        } else {
            const chartContainer = document.getElementById('trendChart');
            if (chartContainer) {
                chartContainer.parentElement.innerHTML = `
                    <div class="empty-state">
                        <div class="empty-state-icon">
                            <i class="bi bi-graph-up"></i>
                        </div>
                        <h5>No Trend Data Available</h5>
                        <p>Data will appear once orders are completed</p>
                    </div>
                `;
            }
        }

        // Clear Filters
        function clearFilters() {
            window.location.href = '${pageContext.request.contextPath}/purchase-orders/history';
        }

        // Auto-submit on supplier change
        document.querySelector('select[name="supplierId"]')?.addEventListener('change', function() {
            this.form.submit();
        });

        // Format numbers
        document.querySelectorAll('.stat-value').forEach(element => {
            const text = element.textContent.trim();
            const number = parseInt(text.replace(/[^\d]/g, ''));
            if (!isNaN(number) && text.indexOf('đ') === -1) {
                element.textContent = new Intl.NumberFormat('vi-VN').format(number);
            }
        });

        // Add active state to current nav item
        const currentPath = window.location.pathname;
        document.querySelectorAll('.nav-item').forEach(item => {
            if (item.getAttribute('href') === currentPath) {
                item.classList.add('active');
            }
        });

        // Console log
        console.log('PO History Page Loaded');
        console.log('Total Orders:', ${totalHistoricalOrders});
        console.log('Trend Data:', trendData ? trendData.length + ' points' : 'No data');
    </script>
</body>
</html>