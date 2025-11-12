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

        /* Sidebar styling - matching auditor dashboard */
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

        /* Main content area */
        .main-content {
            flex: 1;
            padding: 40px;
            overflow-y: auto;
            background: #f9fafb;
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
            margin-bottom: 8px;
        }

        .page-header .subtitle {
            color: #9ca3af;
            font-size: 14px;
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
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            border-left: 5px solid #3b82f6;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.12);
        }

        .stat-card.primary {
            border-left-color: #3b82f6;
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

        /* Dashboard Card */
        .dashboard-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
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

        /* Charts Section */
        .charts-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
            margin-bottom: 30px;
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
            padding: 16px 0;
            border-bottom: 1px solid #e5e7eb;
        }

        .supplier-item:last-child {
            border-bottom: none;
        }

        .supplier-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
        }

        .supplier-name {
            font-weight: 600;
            color: #1f2937;
            font-size: 14px;
        }

        .rank-badge {
            background: #f3f4f6;
            color: #4b5563;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 12px;
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
            font-size: 13px;
            color: #6b7280;
            margin-bottom: 8px;
        }

        .progress-bar-wrapper {
            height: 6px;
            background: #f3f4f6;
            border-radius: 3px;
            overflow: hidden;
            margin-bottom: 6px;
        }

        .progress-bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #3b82f6, #10b981);
            transition: width 0.6s ease;
        }

        .completion-text {
            font-size: 12px;
            color: #9ca3af;
        }

        /* Filter Section */
        .filter-section {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            padding: 24px;
            margin-bottom: 30px;
        }

        .filter-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 16px;
            margin-bottom: 16px;
        }

        .form-group label {
            font-size: 13px;
            font-weight: 600;
            color: #4b5563;
            margin-bottom: 8px;
            display: block;
        }

        .form-control, .form-select {
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 10px 14px;
            font-size: 14px;
            transition: all 0.2s;
            width: 100%;
        }

        .form-control:focus, .form-select:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
            outline: none;
        }

        .btn-group {
            display: flex;
            gap: 12px;
        }

        .btn {
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            border: none;
            cursor: pointer;
            transition: all 0.2s;
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
        }

        .btn-secondary {
            background: #f3f4f6;
            color: #4b5563;
        }

        .btn-secondary:hover {
            background: #e5e7eb;
        }

        /* Table */
        .table-responsive {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background: #f9fafb;
        }

        th {
            padding: 16px 20px;
            text-align: left;
            font-size: 12px;
            font-weight: 700;
            color: #6b7280;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 1px solid #e5e7eb;
        }

        td {
            padding: 16px 20px;
            font-size: 14px;
            color: #4b5563;
            border-bottom: 1px solid #f3f4f6;
        }

        tbody tr:hover {
            background: #f9fafb;
        }

        /* Status Badges */
        .badge {
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
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

        /* Action Button */
        .action-btn {
            background: #3b82f6;
            color: white;
            padding: 8px 16px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.2s;
        }

        .action-btn:hover {
            background: #2563eb;
            color: white;
            transform: translateY(-1px);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 30px;
        }

        .empty-state-icon {
            font-size: 48px;
            color: #d1d5db;
            margin-bottom: 16px;
        }

        .empty-state h5 {
            font-weight: 600;
            color: #4b5563;
            margin-bottom: 8px;
        }

        .empty-state p {
            color: #9ca3af;
            font-size: 14px;
        }

        /* Scrollbar */
        ::-webkit-scrollbar {
            width: 8px;
            height: 8px;
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
        @media (max-width: 1200px) {
            .stats-grid {
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

            .filter-grid {
                grid-template-columns: 1fr;
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
                <h4><i class="bi bi-hospital"></i> Auditor</h4>
                <hr class="sidebar-divider">
            </div>

            <nav>
                <a class="nav-link" href="${pageContext.request.contextPath}/auditor-dashboard">
                    <i class="bi bi-speedometer2"></i> Dashboard
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/purchase-orders">
                    <i class="bi bi-receipt"></i> Purchase Orders
                </a>
                <a class="nav-link active" href="${pageContext.request.contextPath}/purchase-orders/history">
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
                <a class="nav-link" href="${pageContext.request.contextPath}/auditlog?action=alerts">
                    <i class="bi bi-exclamation-triangle"></i> Security Alerts
                </a>
            </nav>
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
            <div class="stats-grid">
                <div class="stat-card primary">
                    <div class="stat-content">
                        <div class="stat-info">
                            <h6>Total Orders</h6>
                            <h3>${totalHistoricalOrders}</h3>
                        </div>
                        <div class="stat-icon" style="color: #3b82f6;">
                            <i class="bi bi-cart-check"></i>
                        </div>
                    </div>
                </div>

                <div class="stat-card success">
                    <div class="stat-content">
                        <div class="stat-info">
                            <h6>Total Amount</h6>
                            <h3>
                                <fmt:formatNumber value="${totalHistoricalAmount}" pattern="#,###" /> đ
                            </h3>
                        </div>
                        <div class="stat-icon" style="color: #10b981;">
                            <i class="bi bi-cash-stack"></i>
                        </div>
                    </div>
                </div>

                <div class="stat-card warning">
                    <div class="stat-content">
                        <div class="stat-info">
                            <h6>Avg Order Value</h6>
                            <h3>
                                <fmt:formatNumber value="${avgOrderValue}" pattern="#,###" /> đ
                            </h3>
                        </div>
                        <div class="stat-icon" style="color: #f59e0b;">
                            <i class="bi bi-calculator"></i>
                        </div>
                    </div>
                </div>

                <div class="stat-card info">
                    <div class="stat-content">
                        <div class="stat-info">
                            <h6>Suppliers</h6>
                            <h3>${supplierPerformance.size()}</h3>
                        </div>
                        <div class="stat-icon" style="color: #3b82f6;">
                            <i class="bi bi-building"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Charts Section -->
            <div class="charts-grid">
                <!-- Trend Chart -->
                <div class="dashboard-card">
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
                <div class="dashboard-card">
                    <div class="card-header">
                        <h5>
                            <i class="bi bi-trophy"></i>
                            Top Suppliers
                        </h5>
                    </div>
                    <div class="card-body" style="padding: 0;">
                        <div class="supplier-list">
                            <c:choose>
                                <c:when test="${empty supplierPerformance}">
                                    <div class="empty-state" style="padding: 30px;">
                                        <div class="empty-state-icon">
                                            <i class="bi bi-inbox"></i>
                                        </div>
                                        <p>No supplier data</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="perf" items="${supplierPerformance}" varStatus="status">
                                        <c:if test="${status.index < 5}">
                                            <div class="supplier-item" style="padding: 16px 24px;">
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
            <div class="dashboard-card">
                <div class="card-header">
                    <h5>
                        <i class="bi bi-list-ul"></i>
                        Purchase Orders List
                    </h5>
                </div>
                <div class="card-body" style="padding: 0;">
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
                                borderColor: '#3b82f6',
                                backgroundColor: 'rgba(59, 130, 246, 0.1)',
                                borderWidth: 2,
                                fill: true,
                                yAxisID: 'y',
                                tension: 0.4,
                                pointRadius: 4,
                                pointHoverRadius: 6,
                                pointBackgroundColor: '#3b82f6',
                                pointBorderColor: '#fff',
                                pointBorderWidth: 2
                            },
                            {
                                label: 'Total Amount (đ)',
                                data: amounts,
                                borderColor: '#10b981',
                                backgroundColor: 'rgba(16, 185, 129, 0.1)',
                                borderWidth: 2,
                                fill: true,
                                yAxisID: 'y1',
                                tension: 0.4,
                                pointRadius: 4,
                                pointHoverRadius: 6,
                                pointBackgroundColor: '#10b981',
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
                                    color: '#3b82f6'
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
                                    color: '#6b7280'
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
                                    color: '#10b981'
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
                                    color: '#6b7280',
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
                                    color: '#6b7280'
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

        // Console log
        console.log('PO History Page Loaded');
        console.log('Total Orders:', ${totalHistoricalOrders});
        console.log('Trend Data:', trendData ? trendData.length + ' points' : 'No data');
    </script>
    
    <%@ include file="/admin/footer.jsp" %>
</body>
</html>