<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expiry Report - Hospital Stock Management</title>
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

        .btn-secondary {
            background: #6b7280;
            color: white;
        }

        .btn-secondary:hover {
            background: #4b5563;
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

        .btn-danger {
            background: #ef4444;
            color: white;
        }

        .btn-danger:hover {
            background: #dc2626;
        }

        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stats-card {
            background: white;
            border-radius: 15px;
            padding: 24px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            border-left: 5px solid;
            transition: all 0.3s ease;
            border-top: 1px solid #e5e7eb;
        }

        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.12);
        }

        .stat-critical { border-left-color: #ef4444; }
        .stat-high { border-left-color: #f59e0b; }
        .stat-medium { border-left-color: #eab308; }
        .stat-total { border-left-color: #3b82f6; }

        .stats-card h6 {
            font-size: 13px;
            font-weight: 600;
            color: #9ca3af;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stats-card h3 {
            font-size: 28px;
            font-weight: 700;
            color: #1f2937;
            margin: 0;
        }

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

        .filter-form {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 16px;
            align-items: end;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-label {
            font-size: 14px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }

        .form-control, .form-select {
            padding: 10px 12px;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 8px;
            padding-top: 8px;
        }

        .checkbox-group input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: #3b82f6;
        }

        .checkbox-group label {
            font-size: 14px;
            color: #374151;
            cursor: pointer;
        }

        .results-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            border-top: 3px solid #3b82f6;
        }

        .card-header {
            background: #f9fafb;
            padding: 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #e5e7eb;
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
            display: inline-block;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
        }

        .badge-light {
            background: #e5e7eb;
            color: #374151;
        }

        .badge-critical { background: #ef4444; color: white; }
        .badge-high { background: #f59e0b; color: white; }
        .badge-medium { background: #eab308; color: white; }
        .badge-secondary { background: #6b7280; color: white; }
        .badge-info { background: #3b82f6; color: white; }
        .badge-success { background: #10b981; color: white; }

        .card-body {
            padding: 24px;
        }

        .alert {
            padding: 16px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 14px;
        }

        .alert-success {
            background: #dcfce7;
            color: #166534;
            border: 1px solid #86efac;
        }

        .alert-info {
            background: #dbeafe;
            color: #1e40af;
            border: 1px solid #93c5fd;
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

        thead th {
            padding: 16px;
            text-align: left;
            font-weight: 600;
            color: #374151;
            white-space: nowrap;
        }

        tbody td {
            padding: 16px;
            border-bottom: 1px solid #e5e7eb;
            color: #1f2937;
        }

        tbody tr:hover {
            background: #f9fafb;
        }

        .text-danger { color: #ef4444; }
        .text-warning { color: #f59e0b; }
        .text-success { color: #10b981; }
        .text-info { color: #3b82f6; }

        .fw-bold { font-weight: 700; }

        .export-buttons {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 24px;
            flex-wrap: wrap;
        }

        .status-approved { 
            background: #10b981; 
            color: white; 
        }
        
        .status-quarantined { 
            background: #f59e0b; 
            color: white; 
        }
        
        .status-received { 
            background: #3b82f6; 
            color: white; 
        }
        
        .status-expired { 
            background: #ef4444; 
            color: white; 
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
                gap: 16px;
                align-items: flex-start;
            }

            .page-header h2 {
                font-size: 24px;
            }

            .filter-form {
                grid-template-columns: 1fr;
            }

            .stats-row {
                grid-template-columns: 1fr;
            }

            table {
                font-size: 12px;
            }

            thead th, tbody td {
                padding: 12px 8px;
            }

            .export-buttons {
                flex-direction: column;
            }

            .export-buttons .btn {
                width: 100%;
                justify-content: center;
            }
        }

        /* Loading state */
        .loading {
            text-align: center;
            padding: 40px;
            color: #6b7280;
        }

        .loading i {
            font-size: 48px;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
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

<!-- Order History Section -->
<h6 style="font-size: 11px; font-weight: 600; color: #9ca3af; margin-bottom: 8px; text-transform: uppercase; letter-spacing: 0.5px;">
    ORDER HISTORY
</h6>
<a class="nav-link" href="${pageContext.request.contextPath}/manager/sent-orders">
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
                <a class="nav-link active" href="${pageContext.request.contextPath}/expiry-report?days=30">
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
            <div class="page-header">
                <h2>
                    <i class="bi bi-calendar-times"></i> 
                    <c:choose>
                        <c:when test="${not empty pageTitle}">${pageTitle}</c:when>
                        <c:otherwise>Expiry Report</c:otherwise>
                    </c:choose>
                </h2>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">
                    <i class="bi bi-box-arrow-right"></i> Logout
                </a>
            </div>

            <!-- Statistics Cards -->
            <c:if test="${not empty statistics}">
                <div class="stats-row">
                    <c:forEach items="${statistics}" var="stat">
                        <div class="stats-card 
                            ${stat.key.contains('Critical') ? 'stat-critical' : ''}
                            ${stat.key.contains('High') ? 'stat-high' : ''}
                            ${stat.key.contains('Medium') ? 'stat-medium' : ''}
                            ${stat.key.equals('Total') ? 'stat-total' : ''}">
                            <h6>${stat.key}</h6>
                            <h3><fmt:formatNumber value="${stat.value}" pattern="#,##0"/></h3>
                        </div>
                    </c:forEach>
                </div>
            </c:if>

            <!-- Filter Section -->
            <div class="filter-section">
                <h5><i class="bi bi-sliders"></i> Filter Options</h5>
                <form method="get" action="" class="filter-form">
                    <div class="form-group">
                        <label class="form-label">Days Threshold</label>
                        <select name="days" class="form-select">
                            <option value="7" ${param.days == '7' || daysThreshold == 7 ? 'selected' : ''}>7 days</option>
                            <option value="14" ${param.days == '14' || daysThreshold == 14 ? 'selected' : ''}>14 days</option>
                            <option value="30" ${param.days == '30' || daysThreshold == 30 ? 'selected' : ''}>30 days</option>
                            <option value="60" ${param.days == '60' || daysThreshold == 60 ? 'selected' : ''}>60 days</option>
                            <option value="90" ${param.days == '90' || daysThreshold == 90 ? 'selected' : ''}>90 days</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Batch Status</label>
                        <select name="status" class="form-select">
                            <option value="All" ${param.status == 'All' || statusFilter == 'All' || empty statusFilter ? 'selected' : ''}>All Status</option>
                            <option value="Approved" ${param.status == 'Approved' || statusFilter == 'Approved' ? 'selected' : ''}>Approved</option>
                            <option value="Quarantined" ${param.status == 'Quarantined' || statusFilter == 'Quarantined' ? 'selected' : ''}>Quarantined</option>
                            <option value="Received" ${param.status == 'Received' || statusFilter == 'Received' ? 'selected' : ''}>Received</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">&nbsp;</label>
                        <div class="checkbox-group">
                            <input type="checkbox" id="useRangeCheck" name="useRange" value="true" 
                                   onchange="toggleDateRange(this)" 
                                   ${param.useRange == 'true' || useRange == 'true' ? 'checked' : ''}>
                            <label for="useRangeCheck">Use Custom Date Range</label>
                        </div>
                    </div>

                    <div class="form-group" id="startDateDiv" style="${param.useRange == 'true' || useRange == 'true' ? '' : 'display:none;'}">
                        <label class="form-label">Start Date</label>
                        <input type="date" name="startDate" class="form-control" 
                               value="${param.startDate != null ? param.startDate : startDate}" 
                               max="<fmt:formatDate value='${currentDate}' pattern='yyyy-MM-dd'/>">
                    </div>

                    <div class="form-group" id="endDateDiv" style="${param.useRange == 'true' || useRange == 'true' ? '' : 'display:none;'}">
                        <label class="form-label">End Date</label>
                        <input type="date" name="endDate" class="form-control" 
                               value="${param.endDate != null ? param.endDate : endDate}">
                    </div>

                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-search"></i> Apply Filters
                        </button>
                    </div>
                </form>
            </div>

            <!-- Results Table -->
            <div class="results-card">
                <div class="card-header">
                    <h5>
                        <i class="bi bi-list-ul"></i> Expiry Records
                    </h5>
                    <span class="badge badge-light">
                        <c:choose>
                            <c:when test="${not empty reports}">${reports.size()} Records</c:when>
                            <c:otherwise>0 Records</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${empty reports}">
                            <div class="alert alert-success">
                                <i class="bi bi-check-circle"></i> 
                                <div>
                                    <strong>Good News!</strong> No medicines are expiring in the selected period.
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:if test="${param.useRange == 'true' || useRange == 'true'}">
                                <div class="alert alert-info" style="margin-bottom: 20px;">
                                    <i class="bi bi-info-circle"></i>
                                    <div>
                                        Showing records expiring between 
                                        <strong>${param.startDate != null ? param.startDate : startDate}</strong> and 
                                        <strong>${param.endDate != null ? param.endDate : endDate}</strong>
                                    </div>
                                </div>
                            </c:if>

                            <div class="table-responsive">
                                <table id="expiryTable">
                                    <thead>
                                        <tr>
                                            <th>Batch ID</th>
                                            <th>Medicine Code</th>
                                            <th>Medicine Name</th>
                                            <th>Category</th>
                                            <th>Lot Number</th>
                                            <th>Status</th>
                                            <th>Current Qty</th>
                                            <th>Expiry Date</th>
                                            <th>Days Until Expiry</th>
                                            <th>Alert Level</th>
                                            <th>Supplier</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${reports}" var="report">
                                            <tr>
                                                <td><strong>#${report.batchId}</strong></td>
                                                <td><code>${report.medicineCode}</code></td>
                                                <td><strong>${report.medicineName}</strong></td>
                                                <td><span class="badge badge-secondary">${report.category}</span></td>
                                                <td>${report.lotNumber}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${report.status == 'Approved'}">
                                                            <span class="badge status-approved">${report.status}</span>
                                                        </c:when>
                                                        <c:when test="${report.status == 'Quarantined'}">
                                                            <span class="badge status-quarantined">${report.status}</span>
                                                        </c:when>
                                                        <c:when test="${report.status == 'Received'}">
                                                            <span class="badge status-received">${report.status}</span>
                                                        </c:when>
                                                        <c:when test="${report.status == 'Expired'}">
                                                            <span class="badge status-expired">${report.status}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge badge-secondary">${report.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td><strong><fmt:formatNumber value="${report.currentQuantity}" pattern="#,##0"/></strong></td>
                                                <td>
                                                    <fmt:formatDate value="${report.expiryDate}" pattern="dd MMM yyyy"/>
                                                </td>
                                                <td>
                                                    <span class="${report.daysUntilExpiry <= 7 ? 'text-danger' : 
                                                                  report.daysUntilExpiry <= 14 ? 'text-warning' : 'text-success'} fw-bold">
                                                        ${report.daysUntilExpiry} days
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="badge ${
                                                        report.daysUntilExpiry <= 7 ? 'badge-critical' : 
                                                        report.daysUntilExpiry <= 14 ? 'badge-high' : 'badge-medium'}">
                                                        ${report.alertLevel}
                                                    </span>
                                                </td>
                                                <td>${report.supplierName != null ? report.supplierName : 'N/A'}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <!-- Export Buttons -->
                            <div class="export-buttons">
                                <button onclick="exportToCSV()" class="btn btn-success">
                                    <i class="bi bi-file-earmark-csv"></i> Export to CSV
                                </button>
                                <button onclick="exportToExcel()" class="btn btn-success">
                                    <i class="bi bi-file-earmark-excel"></i> Export to Excel
                                </button>
                                <button onclick="printTable()" class="btn btn-primary">
                                    <i class="bi bi-printer"></i> Print Report
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <script>
        function toggleDateRange(checkbox) {
            const startDateDiv = document.getElementById('startDateDiv');
            const endDateDiv = document.getElementById('endDateDiv');
            const display = checkbox.checked ? '' : 'none';
            startDateDiv.style.display = display;
            endDateDiv.style.display = display;
        }

        function exportToCSV() {
            const table = document.getElementById('expiryTable');
            if (!table) {
                alert('No table data to export');
                return;
            }
            
            let csv = [];
            const rows = table.querySelectorAll('tr');
            
            for (let row of rows) {
                let rowData = [];
                const cells = row.querySelectorAll('td, th');
                for (let cell of cells) {
                    let text = cell.innerText.trim().replace(/\s+/g, ' ');
                    text = text.replace(/"/g, '""');
                    rowData.push('"' + text + '"');
                }
                if (rowData.length > 0) {
                    csv.push(rowData.join(','));
                }
            }
            
            const csvContent = csv.join('\n');
            const BOM = '\uFEFF';
            const blob = new Blob([BOM + csvContent], { type: 'text/csv;charset=utf-8;' });
            const link = document.createElement('a');
            const url = URL.createObjectURL(blob);
            
            const timestamp = new Date().toISOString().split('T')[0];
            link.setAttribute('href', url);
            link.setAttribute('download', 'expiry-report-' + timestamp + '.xls');
            link.style.visibility = 'hidden';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }

        function printTable() {
            const table = document.getElementById('expiryTable');
            if (!table) {
                alert('No table data to print');
                return;
            }
            
            const printWindow = window.open('', '', 'height=600,width=900');
            printWindow.document.write('<!DOCTYPE html><html><head><title>Expiry Report</title>');
            printWindow.document.write('<style>');
            printWindow.document.write('body { padding: 20px; font-family: Arial, sans-serif; }');
            printWindow.document.write('h2 { color: #1f2937; margin-bottom: 10px; }');
            printWindow.document.write('.info { color: #6b7280; margin-bottom: 20px; }');
            printWindow.document.write('table { border-collapse: collapse; width: 100%; margin-top: 20px; }');
            printWindow.document.write('th, td { border: 1px solid #ddd; padding: 8px; text-align: left; font-size: 12px; }');
            printWindow.document.write('th { background-color: #3b82f6; color: white; font-weight: bold; }');
            printWindow.document.write('tr:nth-child(even) { background-color: #f9fafb; }');
            printWindow.document.write('@media print { body { padding: 10px; } }');
            printWindow.document.write('</style>');
            printWindow.document.write('</head><body>');
            printWindow.document.write('<h2>Hospital Stock Management - Expiry Report</h2>');
            printWindow.document.write('<p class="info">Generated on: ' + new Date().toLocaleString() + '</p>');
            printWindow.document.write(table.outerHTML);
            printWindow.document.write('</body></html>');
            printWindow.document.close();
            
            printWindow.onload = function() {
                printWindow.print();
            };
        }

        // Initialize on page load
        document.addEventListener('DOMContentLoaded', function() {
            const checkbox = document.getElementById('useRangeCheck');
            if (checkbox && checkbox.checked) {
                toggleDateRange(checkbox);
            }
        });
    </script>
</body>
<%@ include file="/admin/footer.jsp" %>
</html>