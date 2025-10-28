<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expiry Report - Hospital Stock Management</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
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
        }

        .checkbox-group input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: #3b82f6;
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

        .fw-bold { font-weight: 700; }

        .export-buttons {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 24px;
        }

        .export-buttons .btn {
            padding: 10px 20px;
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
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="header">
            <h2><i class="fas fa-calendar-times"></i> ${pageTitle}</h2>
            <a href="${pageContext.request.contextPath}/manager-dashboard" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Back
            </a>
        </div>

        <!-- Statistics Cards -->
        <div class="stats-row">
            <c:forEach items="${statistics}" var="stat">
                <div class="stats-card 
                    ${stat.key.contains('Critical') ? 'stat-critical' : ''}
                    ${stat.key.contains('High') ? 'stat-high' : ''}
                    ${stat.key.contains('Medium') ? 'stat-medium' : ''}
                    ${stat.key.equals('Total') ? 'stat-total' : ''}">
                    <h6>${stat.key}</h6>
                    <h3>${stat.value}</h3>
                </div>
            </c:forEach>
        </div>

        <!-- Filter Section -->
        <div class="filter-section">
            <h5><i class="fas fa-sliders-h"></i> Filters</h5>
            <form method="get" class="filter-form">
                <div class="form-group">
                    <label class="form-label">Days Threshold</label>
                    <select name="days" class="form-select">
                        <option value="7" ${daysThreshold == 7 ? 'selected' : ''}>7 days</option>
                        <option value="14" ${daysThreshold == 14 ? 'selected' : ''}>14 days</option>
                        <option value="30" ${daysThreshold == 30 ? 'selected' : ''}>30 days</option>
                        <option value="60" ${daysThreshold == 60 ? 'selected' : ''}>60 days</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">Batch Status</label>
                    <select name="status" class="form-select">
                        <option value="All" ${statusFilter == 'All' ? 'selected' : ''}>All Status</option>
                        <option value="Approved" ${statusFilter == 'Approved' ? 'selected' : ''}>Approved</option>
                        <option value="Quarantined" ${statusFilter == 'Quarantined' ? 'selected' : ''}>Quarantined</option>
                        <option value="Received" ${statusFilter == 'Received' ? 'selected' : ''}>Received</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">Use Date Range</label>
                    <div class="checkbox-group">
                        <input type="checkbox" name="useRange" value="true" 
                               onchange="toggleDateRange()" ${useRange == 'true' ? 'checked' : ''}>
                    </div>
                </div>

                <div class="form-group" id="startDateDiv" style="${useRange == 'true' ? '' : 'display:none;'}">
                    <label class="form-label">Start Date</label>
                    <input type="date" name="startDate" class="form-control" value="${startDate}">
                </div>

                <div class="form-group" id="endDateDiv" style="${useRange == 'true' ? '' : 'display:none;'}">
                    <label class="form-label">End Date</label>
                    <input type="date" name="endDate" class="form-control" value="${endDate}">
                </div>

                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-search"></i> Filter
                </button>
            </form>
        </div>

        <!-- Results Table -->
        <div class="results-card">
            <div class="card-header">
                <h5>
                    <i class="fas fa-list"></i> Expiry Records
                </h5>
                <span class="badge badge-light">${reports.size()}</span>
            </div>
            <div class="card-body">
                <c:if test="${empty reports}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i> No medicines expiring in this period.
                    </div>
                </c:if>

                <c:if test="${not empty reports}">
                    <div class="table-responsive">
                        <table id="expiryTable">
                            <thead>
                                <tr>
                                    <th>Batch ID</th>
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
                                        <td>#${report.batchId}</td>
                                        <td><strong>${report.medicineName}</strong></td>
                                        <td><span class="badge badge-secondary">${report.category}</span></td>
                                        <td>${report.lotNumber}</td>
                                        <td><span class="badge badge-info">${report.status}</span></td>
                                        <td><strong>${report.currentQuantity}</strong></td>
                                        <td><fmt:formatDate value="${report.expiryDate}" pattern="yyyy-MM-dd"/></td>
                                        <td>
                                            <span class="${report.daysUntilExpiry <= 7 ? 'text-danger' : report.daysUntilExpiry <= 14 ? 'text-warning' : 'text-success'} fw-bold">
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
                            <i class="fas fa-file-csv"></i> Export CSV
                        </button>
                        <button onclick="printTable()" class="btn btn-primary">
                            <i class="fas fa-print"></i> Print
                        </button>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <script>
        function toggleDateRange() {
            const checkbox = document.querySelector('input[name="useRange"]');
            document.getElementById('startDateDiv').style.display = checkbox.checked ? '' : 'none';
            document.getElementById('endDateDiv').style.display = checkbox.checked ? '' : 'none';
        }

        function exportToCSV() {
            const table = document.getElementById('expiryTable');
            if (!table) return;
            
            let csv = [];
            let rows = table.querySelectorAll('tr');
            
            for (let row of rows) {
                let rowData = [];
                let cells = row.querySelectorAll('td, th');
                for (let cell of cells) {
                    let text = cell.innerText.trim();
                    text = text.replace(/"/g, '""');
                    rowData.push('"' + text + '"');
                }
                if (rowData.length > 0) {
                    csv.push(rowData.join(','));
                }
            }
            
            const csvContent = csv.join('\n');
            const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
            const link = document.createElement('a');
            const url = URL.createObjectURL(blob);
            
            link.setAttribute('href', url);
            link.setAttribute('download', 'expiry-report-' + new Date().toISOString().split('T')[0] + '.csv');
            link.style.visibility = 'hidden';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }

        function printTable() {
            const table = document.getElementById('expiryTable');
            if (!table) return;
            
            const printWindow = window.open('', '', 'height=600,width=900');
            printWindow.document.write('<!DOCTYPE html><html><head><title>Expiry Report</title>');
            printWindow.document.write('<style>body { padding: 20px; font-family: Arial; } table { border-collapse: collapse; width: 100%; } th, td { border: 1px solid #ddd; padding: 8px; text-align: left; } th { background-color: #3b82f6; color: white; }</style>');
            printWindow.document.write('</head><body>');
            printWindow.document.write('<h2>' + document.querySelector('h2').innerText + '</h2>');
            printWindow.document.write('<p>Generated on: ' + new Date().toLocaleString() + '</p>');
            printWindow.document.write(table.outerHTML);
            printWindow.document.write('</body></html>');
            printWindow.document.close();
            printWindow.print();
        }
    </script>
</body>
</html>
