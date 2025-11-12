<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventory Report</title>
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

        /* Stats cards */
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

        /* Tabs styling */
        .nav-tabs {
            display: flex;
            gap: 0;
            border-bottom: 2px solid #e5e7eb;
            margin-bottom: 30px;
            list-style: none;
        }

        .nav-tabs .nav-link {
            color: #6b7280;
            padding: 12px 20px;
            border: none;
            background: none;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            border-bottom: 3px solid transparent;
            margin-bottom: -2px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border-radius: 0;
        }

        .nav-tabs .nav-link:hover {
            color: #1f2937;
            background: transparent;
            transform: none;
        }

        .nav-tabs .nav-link.active {
            color: #3b82f6;
            border-bottom-color: #3b82f6;
            background: transparent;
        }

        .nav-item {
            list-style: none;
        }

        /* Filter section */
        .filter-section {
            background: white;
            padding: 24px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            border-top: 3px solid #3b82f6;
        }

        .filter-section h5 {
            font-size: 18px;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .filter-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            align-items: flex-end;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
            font-size: 14px;
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

        /* Card styling */
        .card {
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

        /* Table styling */
        .table-responsive {
            overflow-x: auto;
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

        /* Status badges */
        .status-approved {
            background: #dcfce7;
            color: #166534;
            padding: 6px 12px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 12px;
        }

        .status-quarantined {
            background: #fef3c7;
            color: #92400e;
            padding: 6px 12px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 12px;
        }

        .badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
            background: #e5e7eb;
            color: #374151;
        }

        .badge-primary {
            background: #dbeafe;
            color: #1e40af;
        }

        .badge-secondary {
            background: #e5e7eb;
            color: #374151;
        }

        .badge-success {
            background: #dcfce7;
            color: #166534;
        }

        /* Button styling */
        .btn {
            padding: 10px 16px;
            border-radius: 8px;
            border: none;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .btn-primary {
            background: #3b82f6;
            color: white;
        }

        .btn-primary:hover {
            background: #2563eb;
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

        /* Alert styling */
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

        /* Button group */
        .button-group {
            display: flex;
            gap: 12px;
            margin-top: 24px;
            justify-content: flex-end;
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

            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 16px;
            }

            .page-header h2 {
                font-size: 24px;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .nav-tabs {
                flex-wrap: wrap;
            }

            .filter-row {
                grid-template-columns: 1fr;
            }

            table {
                font-size: 12px;
            }

            table th,
            table td {
                padding: 12px 8px;
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
                <a class="nav-link" href="${pageContext.request.contextPath}/cancelled-tasks">
                    <i class="bi bi-ban"></i> Cancelled Orders
                </a>
                
                <hr class="nav-divider">
                
                <!-- Reports Section -->
                <a class="nav-link active" href="${pageContext.request.contextPath}/inventory-report">
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
            <!-- Header -->
            <div class="page-header">
                <h2>
                    <i class="bi bi-boxes"></i> ${pageTitle}
                </h2>
            </div>

            <!-- Statistics Cards (Summary Only) -->
            <c:if test="${reportType == 'summary' && statistics != null}">
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-content">
                            <div class="stat-info">
                                <h6>Total Medicines</h6>
                                <h3>${statistics.get('totalMedicines')}</h3>
                            </div>
                            <div class="stat-icon">
                                <i class="bi bi-capsule"></i>
                            </div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-content">
                            <div class="stat-info">
                                <h6>Total Batches</h6>
                                <h3>${statistics.get('totalBatches')}</h3>
                            </div>
                            <div class="stat-icon">
                                <i class="bi bi-boxes"></i>
                            </div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-content">
                            <div class="stat-info">
                                <h6>Total Quantity</h6>
                                <h3>${statistics.get('totalQuantity')}</h3>
                            </div>
                            <div class="stat-icon">
                                <i class="bi bi-stack"></i>
                            </div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-content">
                            <div class="stat-info">
                                <h6>Approved Quantity</h6>
                                <h3>${statistics.get('approvedQuantity')}</h3>
                            </div>
                            <div class="stat-icon">
                                <i class="bi bi-check-circle"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Report Type Tabs -->
            <ul class="nav-tabs" role="tablist">
                <li class="nav-item">
                    <a class="nav-link ${reportType == 'summary' ? 'active' : ''}" href="?type=summary">
                        <i class="bi bi-chart-bar"></i> Summary
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${reportType == 'supplier' ? 'active' : ''}" href="?type=supplier">
                        <i class="bi bi-building"></i> By Supplier
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${reportType == 'batch' ? 'active' : ''}" href="?type=batch">
                        <i class="bi bi-cube"></i> Batch Details
                    </a>
                </li>
            </ul>

            <!-- Filter Section for Batch Report -->
            <c:if test="${reportType == 'batch'}">
                <div class="filter-section">
                    <h5><i class="bi bi-sliders"></i> Filters</h5>
                    <form method="get" class="filter-row">
                        <input type="hidden" name="type" value="batch">
                        
                        <div class="form-group">
                            <label>Start Date (Received)</label>
                            <input type="date" name="startDate" value="${startDate}">
                        </div>

                        <div class="form-group">
                            <label>End Date (Received)</label>
                            <input type="date" name="endDate" value="${endDate}">
                        </div>

                        <div class="form-group">
                            <button type="submit" class="btn btn-primary" style="width: 100%;">
                                <i class="bi bi-search"></i> Filter
                            </button>
                        </div>
                    </form>
                </div>
            </c:if>

            <!-- Results Card -->
            <div class="card">
                <div class="card-header">
                    <h5>
                        <i class="bi bi-list-ul"></i> Results
                        <span class="badge">${reports.size()}</span>
                    </h5>
                </div>
                <div class="card-body">
                    <c:if test="${empty reports}">
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle"></i> No data available for this report.
                        </div>
                    </c:if>

                    <!-- Summary Table -->
                    <c:if test="${reportType == 'summary' && not empty reports}">
                        <div class="table-responsive">
                            <table id="reportTable">
                                <thead>
                                    <tr>
                                        <th>Medicine Code</th>
                                        <th>Medicine Name</th>
                                        <th>Category</th>
                                        <th>Total Batches</th>
                                        <th>Total Qty</th>
                                        <th>Approved Qty</th>
                                        <th>Quarantined Qty</th>
                                        <th>Nearest Expiry</th>
                                        <th>Last Received</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${reports}" var="report">
                                        <tr>
                                            <td><strong>${report.medicineCode}</strong></td>
                                            <td>${report.medicineName}</td>
                                            <td><span class="badge badge-secondary">${report.category}</span></td>
                                            <td><span class="badge badge-primary">${report.totalBatches}</span></td>
                                            <td><strong>${report.totalQuantity}</strong></td>
                                            <td><span class="status-approved">${report.approvedQuantity}</span></td>
                                            <td><span class="status-quarantined">${report.quarantinedQuantity}</span></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${report.nearestExpiry != null}">
                                                        <fmt:formatDate value="${report.nearestExpiry}" pattern="yyyy-MM-dd"/>
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${report.lastReceived != null}">
                                                        <fmt:formatDate value="${report.lastReceived}" pattern="yyyy-MM-dd"/>
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>

                    <!-- Supplier Table -->
                    <c:if test="${reportType == 'supplier' && not empty reports}">
                        <div class="table-responsive">
                            <table id="reportTable">
                                <thead>
                                    <tr>
                                        <th>Supplier ID</th>
                                        <th>Supplier Name</th>
                                        <th>Total Batches</th>
                                        <th>Total Qty</th>
                                        <th>Medicine Types</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${reports}" var="report">
                                        <tr>
                                            <td><strong>#${report.supplierId}</strong></td>
                                            <td>${report.supplierName}</td>
                                            <td><span class="badge badge-primary">${report.totalBatches}</span></td>
                                            <td><strong>${report.totalQuantity}</strong></td>
                                            <td><span class="badge badge-success">${report.medicineTypes}</span></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>

                    <!-- Batch Details Table -->
                    <c:if test="${reportType == 'batch' && not empty reports}">
                        <div class="table-responsive">
                            <table id="reportTable">
                                <thead>
                                    <tr>
                                        <th>Batch ID</th>
                                        <th>Medicine Code</th>
                                        <th>Medicine Name</th>
                                        <th>Lot Number</th>
                                        <th>Status</th>
                                        <th>Current Qty</th>
                                        <th>Expiry Date</th>
                                        <th>Received Date</th>
                                        <th>Supplier</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${reports}" var="report">
                                        <tr>
                                            <td><strong>#${report.batchId}</strong></td>
                                            <td><code>${report.medicineCode}</code></td>
                                            <td>${report.medicineName}</td>
                                            <td>${report.lotNumber}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${report.status == 'Approved'}">
                                                        <span class="badge badge-success">${report.status}</span>
                                                    </c:when>
                                                    <c:when test="${report.status == 'Quarantined'}">
                                                        <span class="status-quarantined">${report.status}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-primary">${report.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><strong>${report.currentQuantity}</strong></td>
                                            <td><fmt:formatDate value="${report.expiryDate}" pattern="yyyy-MM-dd"/></td>
                                            <td><fmt:formatDate value="${report.receivedDate}" pattern="yyyy-MM-dd"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${report.supplierName != null}">
                                                        ${report.supplierName}
                                                    </c:when>
                                                    <c:otherwise>N/A</c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>

                    <!-- Export Buttons -->
                    <c:if test="${not empty reports}">
                        <div class="button-group">
                            <button onclick="exportToCSV()" class="btn btn-success">
                                <i class="bi bi-file-earmark-csv"></i> Export CSV
                            </button>
                            <button onclick="printTable()" class="btn btn-primary">
                                <i class="bi bi-printer"></i> Print
                            </button>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <script>
        function exportToCSV() {
            const table = document.getElementById('reportTable');
            let csv = [];
            
            for (let row of table.rows) {
                let rowData = [];
                for (let cell of row.cells) {
                    rowData.push('"' + cell.innerText.replace(/"/g, '""') + '"');
                }
                csv.push(rowData.join(','));
            }
            
            const csvContent = 'data:text/csv;charset=utf-8,' + csv.join('\n');
            const link = document.createElement('a');
            link.setAttribute('href', encodeURI(csvContent));
            link.setAttribute('download', 'inventory-report-' + new Date().toISOString().split('T')[0] + '.csv');
            link.click();
        }

        function printTable() {
            const table = document.getElementById('reportTable').outerHTML;
            const printWindow = window.open('', '', 'height=600,width=900');
            printWindow.document.write('<html><head><title>Inventory Report</title>');
            printWindow.document.write('<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">');
            printWindow.document.write('<style>body { padding: 20px; font-family: Inter, sans-serif; } table { width: 100%; border-collapse: collapse; } th, td { border: 1px solid #ddd; padding: 8px; text-align: left; } th { background-color: #f9fafb; }</style>');
            printWindow.document.write('</head><body>');
            printWindow.document.write('<h2 class="mb-4">${pageTitle}</h2>');
            printWindow.document.write(table);
            printWindow.document.write('</body></html>');
            printWindow.document.close();
            printWindow.print();
        }
    </script>
</body>
<%@ include file="/admin/footer.jsp" %>
</html>