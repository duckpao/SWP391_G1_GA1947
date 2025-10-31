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
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: #f9fafb;
            min-height: 100vh;
            padding: 20px;
        }

        .container-fluid {
            max-width: 1400px;
            margin: 0 auto;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            color: #1f2937;
        }

        .header h2 {
            font-size: 28px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            font-size: 14px;
        }

        .btn-secondary {
            background: #e5e7eb;
            color: #374151;
        }

        .btn-secondary:hover {
            background: #d1d5db;
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

        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stats-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            border-left: 5px solid;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .stats-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
        }

        .stat-critical { border-left-color: #dc3545; }
        .stat-high { border-left-color: #fd7e14; }
        .stat-medium { border-left-color: #ffc107; }
        .stat-total { border-left-color: #3b82f6; }

        .stats-card h6 {
            color: #6b7280;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }

        .stats-card h3 {
            font-size: 32px;
            font-weight: 700;
            color: #1f2937;
        }

        .filter-section {
            background: white;
            padding: 24px;
            border-radius: 12px;
            margin-bottom: 30px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .filter-section h5 {
            font-size: 16px;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
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
            font-size: 13px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .form-control, .form-select {
            padding: 10px 12px;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            font-size: 14px;
            font-family: inherit;
            transition: border-color 0.3s ease;
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
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .card-header {
            background: white;
            color: #1f2937;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px solid #3b82f6;
        }

        .card-header h5 {
            font-size: 16px;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .badge-light {
            background: #e5e7eb;
            color: #374151;
        }

        .badge-critical { background: #dc3545; color: white; }
        .badge-high { background: #fd7e14; color: white; }
        .badge-medium { background: #ffc107; color: #000; }
        .badge-secondary { background: #6b7280; color: white; }
        .badge-info { background: #0dcaf0; color: #000; }
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
            background: #d1fae5;
            color: #065f46;
            border: 1px solid #a7f3d0;
        }

        .alert-info {
            background: #dbeafe;
            color: #1e40af;
            border: 1px solid #bfdbfe;
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
            background: #f3f4f6;
            border-bottom: 2px solid #e5e7eb;
        }

        thead th {
            padding: 12px;
            text-align: left;
            font-weight: 700;
            color: #374151;
            text-transform: uppercase;
            font-size: 12px;
            letter-spacing: 0.3px;
            white-space: nowrap;
        }

        tbody td {
            padding: 12px;
            border-bottom: 1px solid #e5e7eb;
            color: #1f2937;
        }

        tbody tr:hover {
            background: #f9fafb;
        }

        .text-danger { color: #dc3545; }
        .text-warning { color: #fd7e14; }
        .text-success { color: #10b981; }
        .text-info { color: #0dcaf0; }

        .fw-bold { font-weight: 700; }

        .export-buttons {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 24px;
            flex-wrap: wrap;
        }

        .export-buttons .btn {
            padding: 10px 20px;
        }

        /* Status badges with specific colors */
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
            background: #dc3545; 
            color: white; 
        }

        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 16px;
                align-items: flex-start;
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
                padding: 8px;
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
<body>
    <div class="container-fluid">
        <div class="header">
            <h2>
                <i class="fas fa-calendar-times"></i> 
                <c:choose>
                    <c:when test="${not empty pageTitle}">${pageTitle}</c:when>
                    <c:otherwise>Expiry Report</c:otherwise>
                </c:choose>
            </h2>
            <a href="${pageContext.request.contextPath}/manager-dashboard" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
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
            <h5><i class="fas fa-sliders-h"></i> Filter Options</h5>
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
                        <i class="fas fa-search"></i> Apply Filters
                    </button>
                </div>
            </form>
        </div>

        <!-- Results Table -->
        <div class="results-card">
            <div class="card-header">
                <h5>
                    <i class="fas fa-list-alt"></i> Expiry Records
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
                            <i class="fas fa-check-circle"></i> 
                            <div>
                                <strong>Good News!</strong> No medicines are expiring in the selected period.
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:if test="${param.useRange == 'true' || useRange == 'true'}">
                            <div class="alert alert-info" style="margin-bottom: 20px;">
                                <i class="fas fa-info-circle"></i>
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
                                <i class="fas fa-file-csv"></i> Export to CSV
                            </button>
                            <button onclick="exportToExcel()" class="btn btn-success">
                                <i class="fas fa-file-excel"></i> Export to Excel
                            </button>
                            <button onclick="printTable()" class="btn btn-primary">
                                <i class="fas fa-print"></i> Print Report
                            </button>
                        </div>
                    </c:otherwise>
                </c:choose>
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
            link.setAttribute('download', 'expiry-report-' + timestamp + '.csv');
            link.style.visibility = 'hidden';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }

        function exportToExcel() {
            const table = document.getElementById('expiryTable');
            if (!table) {
                alert('No table data to export');
                return;
            }
            
            let html = '<html><head><meta charset="utf-8"><style>table{border-collapse:collapse;width:100%;}th,td{border:1px solid #ddd;padding:8px;text-align:left;}th{background-color:#3b82f6;color:white;}</style></head><body>';
            html += '<h2>Expiry Report - ' + new Date().toLocaleDateString() + '</h2>';
            html += table.outerHTML;
            html += '</body></html>';
            
            const blob = new Blob([html], { type: 'application/vnd.ms-excel' });
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
</html>