<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>PO History & Trend Analysis</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
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
                width: 100%;
                flex: 1;
            }

            .sidebar {
                width: 280px;
                background: white;
                color: #1f2937;
                padding: 30px 20px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
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

            /* Removed .user-info styles and HTML element */

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
                margin-bottom: 10px;
            }

            .breadcrumb {
                background: transparent;
                padding: 0;
                margin: 0;
            }

            .breadcrumb-item a {
                color: #6b7280;
                text-decoration: none;
            }

            .breadcrumb-item a:hover {
                color: #3b82f6;
            }

            .breadcrumb-item.active {
                color: #9ca3af;
            }

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

            .stat-card.primary {
                border-left-color: #3b82f6;
            }

            .stat-card.success {
                border-left-color: #10b981;
            }

            .stat-card.info {
                border-left-color: #3b82f6;
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

            .stat-info small {
                font-size: 13px;
                color: #9ca3af;
                margin-top: 8px;
                display: block;
            }

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
                border-top: 4px solid #3b82f6;
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

            .charts-row {
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 20px;
                margin-bottom: 30px;
            }

            .chart-container {
                position: relative;
                height: 300px;
            }

            .supplier-list {
                max-height: 350px;
                overflow-y: auto;
            }

            .supplier-item {
                margin-bottom: 20px;
                padding-bottom: 20px;
                border-bottom: 1px solid #e5e7eb;
            }

            .supplier-item:last-child {
                border-bottom: none;
                margin-bottom: 0;
                padding-bottom: 0;
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
            }

            .supplier-badge {
                background: #10b981;
                color: white;
                padding: 4px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
            }

            .supplier-meta {
                font-size: 13px;
                color: #9ca3af;
                margin-bottom: 8px;
            }

            .progress {
                height: 5px;
                background: #e5e7eb;
                border-radius: 3px;
                overflow: hidden;
                margin-bottom: 8px;
            }

            .progress-bar {
                background: #3b82f6;
                height: 100%;
            }

            .filter-section {
                background: white;
                border-radius: 15px;
                padding: 24px;
                margin-bottom: 30px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            }

            .filter-row {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 16px;
                margin-bottom: 16px;
            }

            .form-group {
                display: flex;
                flex-direction: column;
            }

            .form-group label {
                font-size: 14px;
                font-weight: 600;
                color: #374151;
                margin-bottom: 8px;
            }

            .form-group input,
            .form-group select {
                padding: 10px 12px;
                border: 1px solid #e5e7eb;
                border-radius: 8px;
                font-family: inherit;
                font-size: 14px;
                transition: all 0.3s ease;
            }

            .form-group input:focus,
            .form-group select:focus {
                outline: none;
                border-color: #3b82f6;
                box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
            }

            .button-group {
                display: flex;
                gap: 12px;
                flex-wrap: wrap;
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
                display: flex;
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

            .btn-danger {
                background: #ef4444;
                color: white;
            }

            .btn-danger:hover {
                background: #dc2626;
            }

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

            .status-badge {
                display: inline-block;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
            }

            .status-completed {
                background: #d1fae5;
                color: #065f46;
            }

            .status-pending {
                background: #fef3c7;
                color: #92400e;
            }

            .status-cancelled {
                background: #fee2e2;
                color: #991b1b;
            }

            .items-badge {
                background: #e0e7ff;
                color: #3730a3;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
            }

            .action-btn {
                background: #3b82f6;
                color: white;
                padding: 8px 12px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 14px;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 6px;
            }

            .action-btn:hover {
                background: #2563eb;
            }

            .empty-state {
                text-align: center;
                padding: 40px 20px;
            }

            .empty-state i {
                font-size: 48px;
                color: #d1d5db;
                margin-bottom: 16px;
            }

            .empty-state p {
                color: #9ca3af;
                font-size: 14px;
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

            ::-webkit-scrollbar-thumb:hover {
                background: rgba(0, 0, 0, 0.3);
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

                .charts-row {
                    grid-template-columns: 1fr;
                }

                .filter-row {
                    grid-template-columns: 1fr;
                }

                .button-group {
                    flex-direction: column;
                }

                .btn {
                    width: 100%;
                    justify-content: center;
                }
            }
        </style>
    </head>
    <body>
        <!-- Include header.jsp at the top -->
        <%@ include file="/admin/header.jsp" %>

        <div class="page-wrapper">
            <div class="dashboard-container">
                <div class="sidebar">
                    <div class="sidebar-header">
                        <h4><i class="bi bi-hospital"></i> Auditor</h4>
                        <hr class="sidebar-divider">
                        <!-- Removed user-info section -->
                    </div>

                    <nav>
                        <a class="nav-link" href="${pageContext.request.contextPath}/auditor/auditor-dashboard.jsp">
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
                    <!-- Header -->
                    <div class="page-header">
                        <h2><i class="bi bi-clock-history"></i> Purchase Orders History & Trend Analysis</h2>

                    </div>

                    <!-- Statistics Cards -->
                    <div class="stats-grid">
                        <div class="stat-card primary">
                            <div class="stat-info">
                                <h6>Total Historical Orders</h6>
                                <h3>${totalHistoricalOrders}</h3>
                                <small><i class="bi bi-archive"></i> Completed & Received</small>
                            </div>
                        </div>
                        <div class="stat-card success">
                            <div class="stat-info">
                                <h6>Total Historical Amount</h6>
                                <h3 style="color: #10b981;">
                                    <fmt:formatNumber value="${totalHistoricalAmount}" type="currency" currencySymbol="VNĐ"/>
                                </h3>
                                <small><i class="bi bi-cash-stack"></i> All completed orders</small>
                            </div>
                        </div>
                        <div class="stat-card info">
                            <div class="stat-info">
                                <h6>Average Order Value</h6>
                                <h3 style="color: #3b82f6;">
                                    <fmt:formatNumber value="${avgOrderValue}" type="currency" currencySymbol="VNĐ"/>
                                </h3>
                                <small><i class="bi bi-graph-up"></i> Per order</small>
                            </div>
                        </div>
                    </div>

                    <!-- Charts Row -->
                    <div class="charts-row">
                        <!-- Trend Chart -->
                        <div class="dashboard-card">
                            <div class="card-header">
                                <h5><i class="bi bi-graph-up-arrow"></i> Order Trends Over Time</h5>
                            </div>
                            <div class="card-body">
                                <div class="chart-container">
                                    <canvas id="trendChart"></canvas>
                                </div>
                            </div>
                        </div>

                        <!-- Supplier Performance -->
                        <div class="dashboard-card">
                            <div class="card-header">
                                <h5><i class="bi bi-trophy"></i> Top Suppliers</h5>
                            </div>
                            <div class="card-body">
                                <div class="supplier-list">
                                    <c:forEach var="perf" items="${supplierPerformance}" varStatus="status">
                                        <c:if test="${status.index < 5}">
                                            <div class="supplier-item">
                                                <div class="supplier-header">
                                                    <span class="supplier-name">${perf.supplierName}</span>
                                                    <span class="supplier-badge">#${status.index + 1}</span>
                                                </div>
                                                <div class="supplier-meta">
                                                    ${perf.totalOrders} orders • 
                                                    <fmt:formatNumber value="${perf.totalAmount}" type="currency" currencySymbol="VNĐ"/>
                                                </div>
                                                <div class="progress">
                                                    <div class="progress-bar" 
                                                         style="width: ${(perf.completedOrders * 100.0 / perf.totalOrders)}%">
                                                    </div>
                                                </div>
                                                <small style="color: #9ca3af;">
                                                    Completion: ${perf.completedOrders}/${perf.totalOrders} 
                                                    (${String.format("%.1f", (perf.completedOrders * 100.0 / perf.totalOrders))}%)
                                                </small>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Filter Section -->
                    <div class="filter-section">
                        <form method="get" action="${pageContext.request.contextPath}/purchase-orders/history" id="filterForm">
                            <div class="filter-row">
                                <div class="form-group">
                                    <label>Supplier</label>
                                    <select name="supplierId" onchange="this.form.submit()">
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
                                    <input type="date" name="fromDate" value="${fromDate}">
                                </div>
                                <div class="form-group">
                                    <label>To Date</label>
                                    <input type="date" name="toDate" value="${toDate}">
                                </div>
                                <div class="form-group">
                                    <label>Search</label>
                                    <input type="text" name="search" placeholder="PO ID, Supplier..." value="${searchKeyword}">
                                </div>
                            </div>
                            <div class="button-group">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-search"></i> Filter
                                </button>
                                <button type="button" class="btn btn-secondary" onclick="clearFilters()">
                                    <i class="bi bi-x-circle"></i> Clear
                            </div>
                        </form>
                    </div>

                    <!-- Historical Orders Table -->
                    <div class="dashboard-card">
                        <div class="card-header">
                            <h5><i class="bi bi-table"></i> Historical Purchase Orders</h5>
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
                                                            <i class="bi bi-inbox"></i>
                                                            <p>No historical orders found for selected criteria</p>
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
                                                            <span class="status-badge ${po.statusBadgeClass}">${po.status}</span>
                                                        </td>
                                                        <td>
                                                            <span class="items-badge">${po.itemCount} items</span>
                                                        </td>
                                                        <td>
                                                            <fmt:formatNumber value="${po.totalAmount}" 
                                                                              type="currency" currencySymbol="$"/>
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
        </div>

        <!-- Include footer.jsp at the bottom -->
        <%@ include file="/admin/footer.jsp" %>

        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
        <script>
                                    // Trend Chart
                                    const trendData = ${trendData};

                                    const labels = trendData.map(d => `${d.month}/${d.year}`);
                                        const orderCounts = trendData.map(d => d.orderCount);
                                        const amounts = trendData.map(d => d.totalAmount);

                                        const ctx = document.getElementById('trendChart').getContext('2d');
                                        const trendChart = new Chart(ctx, {
                                            type: 'line',
                                            data: {
                                                labels: labels,
                                                datasets: [
                                                    {
                                                        label: 'Number of Orders',
                                                        data: orderCounts,
                                                        borderColor: 'rgb(75, 192, 192)',
                                                        backgroundColor: 'rgba(75, 192, 192, 0.2)',
                                                        yAxisID: 'y',
                                                        tension: 0.3
                                                    },
                                                    {
                                                        label: 'Total Amount ($)',
                                                        data: amounts,
                                                        borderColor: 'rgb(255, 99, 132)',
                                                        backgroundColor: 'rgba(255, 99, 132, 0.2)',
                                                        yAxisID: 'y1',
                                                        tension: 0.3
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
                                                scales: {
                                                    y: {
                                                        type: 'linear',
                                                        display: true,
                                                        position: 'left',
                                                        title: {
                                                            display: true,
                                                            text: 'Number of Orders'
                                                        }
                                                    },
                                                    y1: {
                                                        type: 'linear',
                                                        display: true,
                                                        position: 'right',
                                                        title: {
                                                            display: true,
                                                            text: 'Amount ($)'
                                                        },
                                                        grid: {
                                                            drawOnChartArea: false,
                                                        },
                                                    },
                                                }
                                            }
                                        });

                                        function clearFilters() {
                                            window.location.href = '${pageContext.request.contextPath}/purchase-orders/history';
                                        }

                                        function exportToExcel() {
                                            alert('Export to Excel functionality to be implemented');
                                        }

                                        function exportToPDF() {
                                            alert('Export to PDF functionality to be implemented');
                                        }
        </script>
    </body>
</html>
