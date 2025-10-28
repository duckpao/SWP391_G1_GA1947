<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PO History & Trend Analysis</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        .stats-card {
            border-left: 4px solid;
            transition: transform 0.2s;
        }
        .stats-card:hover {
            transform: translateY(-5px);
        }
        .filter-section {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .chart-container {
            position: relative;
            height: 300px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container-fluid py-4">
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2><i class="bi bi-clock-history"></i> Purchase Orders History & Trend Analysis</h2>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/auditor/auditor-dashboard.jsp">Dashboard</a>
                        </li>
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/purchase-orders">Purchase Orders</a>
                        </li>
                        <li class="breadcrumb-item active">History</li>
                    </ol>
                </nav>
            </div>
            <div>
                <span class="badge bg-info">Auditor: ${sessionScope.username}</span>
            </div>
        </div>

        <!-- Statistics Cards -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="card stats-card border-primary">
                    <div class="card-body">
                        <h6 class="text-muted">Total Historical Orders</h6>
                        <h3 class="mb-0">${totalHistoricalOrders}</h3>
                        <small class="text-muted"><i class="bi bi-archive"></i> Completed & Received</small>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card stats-card border-success">
                    <div class="card-body">
                        <h6 class="text-muted">Total Historical Amount</h6>
                        <h3 class="mb-0 text-success">
                            <fmt:formatNumber value="${totalHistoricalAmount}" type="currency" currencySymbol="$"/>
                        </h3>
                        <small class="text-muted"><i class="bi bi-cash-stack"></i> All completed orders</small>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card stats-card border-info">
                    <div class="card-body">
                        <h6 class="text-muted">Average Order Value</h6>
                        <h3 class="mb-0 text-info">
                            <fmt:formatNumber value="${avgOrderValue}" type="currency" currencySymbol="$"/>
                        </h3>
                        <small class="text-muted"><i class="bi bi-graph-up"></i> Per order</small>
                    </div>
                </div>
            </div>
        </div>

        <!-- Charts Row -->
        <div class="row mb-4">
            <!-- Trend Chart -->
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-white">
                        <h5 class="mb-0"><i class="bi bi-graph-up-arrow"></i> Order Trends Over Time</h5>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="trendChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Supplier Performance -->
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header bg-white">
                        <h5 class="mb-0"><i class="bi bi-trophy"></i> Top Suppliers</h5>
                    </div>
                    <div class="card-body" style="max-height: 350px; overflow-y: auto;">
                        <c:forEach var="perf" items="${supplierPerformance}" varStatus="status">
                            <c:if test="${status.index < 5}">
                                <div class="mb-3 pb-3 border-bottom">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <strong>${perf.supplierName}</strong>
                                            <br>
                                            <small class="text-muted">
                                                ${perf.totalOrders} orders • 
                                                <fmt:formatNumber value="${perf.totalAmount}" type="currency" currencySymbol="$"/>
                                            </small>
                                        </div>
                                        <div class="text-end">
                                            <span class="badge bg-success">#${status.index + 1}</span>
                                        </div>
                                    </div>
                                    <div class="progress mt-2" style="height: 5px;">
                                        <div class="progress-bar" role="progressbar" 
                                             style="width: ${(perf.completedOrders * 100.0 / perf.totalOrders)}%">
                                        </div>
                                    </div>
                                    <small class="text-muted">
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
                <div class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label">Supplier</label>
                        <select name="supplierId" class="form-select" onchange="this.form.submit()">
                            <option value="">All Suppliers</option>
                            <c:forEach var="supplier" items="${suppliers}">
                                <option value="${supplier.supplierId}" 
                                        ${selectedSupplierId == supplier.supplierId ? 'selected' : ''}>
                                    ${supplier.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">From Date</label>
                        <input type="date" name="fromDate" class="form-control" value="${fromDate}">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">To Date</label>
                        <input type="date" name="toDate" class="form-control" value="${toDate}">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Search</label>
                        <input type="text" name="search" class="form-control" 
                               placeholder="PO ID, Supplier..." value="${searchKeyword}">
                    </div>
                </div>
                <div class="row mt-3">
                    <div class="col-12">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-search"></i> Filter
                        </button>
                        <button type="button" class="btn btn-secondary" onclick="clearFilters()">
                            <i class="bi bi-x-circle"></i> Clear
                        </button>
                        <button type="button" class="btn btn-success" onclick="exportToExcel()">
                            <i class="bi bi-file-earmark-excel"></i> Export Excel
                        </button>
                        <button type="button" class="btn btn-danger" onclick="exportToPDF()">
                            <i class="bi bi-file-earmark-pdf"></i> Export PDF
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Historical Orders Table -->
        <div class="card">
            <div class="card-header bg-white">
                <h5 class="mb-0"><i class="bi bi-table"></i> Historical Purchase Orders</h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
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
                                        <td colspan="8" class="text-center py-4">
                                            <i class="bi bi-inbox" style="font-size: 3rem; color: #ccc;"></i>
                                            <p class="text-muted mt-2">No historical orders found for selected criteria</p>
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
                                                <span class="${po.statusBadgeClass}">${po.status}</span>
                                            </td>
                                            <td>
                                                <span class="badge bg-secondary">${po.itemCount} items</span>
                                            </td>
                                            <td>
                                                <fmt:formatNumber value="${po.totalAmount}" 
                                                                type="currency" currencySymbol="$"/>
                                            </td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/purchase-orders?action=view&id=${po.poId}" 
                                                   class="btn btn-sm btn-info" title="View Details">
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
            // TODO: Implement Excel export
        }

        function exportToPDF() {
            alert('Export to PDF functionality to be implemented');
            // TODO: Implement PDF export
        }
    </script>
</body>
</html>