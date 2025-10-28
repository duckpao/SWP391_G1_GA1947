<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expiry Report - Hospital Stock Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .stats-card {
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            padding: 20px;
        }
        .stat-critical { border-left: 5px solid #dc3545; background: #fff5f5; }
        .stat-high { border-left: 5px solid #fd7e14; background: #fffaf5; }
        .stat-medium { border-left: 5px solid #ffc107; background: #fffef5; }
        .stat-total { border-left: 5px solid #0dcaf0; background: #f5f7ff; }
        .badge-critical { background-color: #dc3545; color: white; }
        .badge-high { background-color: #fd7e14; color: white; }
        .badge-medium { background-color: #ffc107; color: #000; }
        .filter-section { background: #f8f9fa; padding: 20px; border-radius: 10px; margin-bottom: 20px; }
        table tbody tr:hover { background-color: #f5f5f5; }
    </style>
</head>
<body>
    <div class="container-fluid mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="fas fa-calendar-times text-danger"></i> ${pageTitle}</h2>
            <a href="${pageContext.request.contextPath}/manager-dashboard" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Back
            </a>
        </div>

        <!-- Statistics Cards -->
        <div class="row mb-4">
            <c:forEach items="${statistics}" var="stat">
                <div class="col-md-3">
                    <div class="stats-card 
                        ${stat.key.contains('Critical') ? 'stat-critical' : ''}
                        ${stat.key.contains('High') ? 'stat-high' : ''}
                        ${stat.key.contains('Medium') ? 'stat-medium' : ''}
                        ${stat.key.equals('Total') ? 'stat-total' : ''}">
                        <h6 class="text-muted mb-2">${stat.key}</h6>
                        <h3 class="mb-0">${stat.value}</h3>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Filter Section -->
        <div class="filter-section">
            <h5 class="mb-3"><i class="fas fa-sliders-h"></i> Filters</h5>
            <form method="get" class="row g-3">
                <div class="col-md-2">
                    <label class="form-label"><strong>Days Threshold</strong></label>
                    <select name="days" class="form-select">
                        <option value="7" ${daysThreshold == 7 ? 'selected' : ''}>7 days</option>
                        <option value="14" ${daysThreshold == 14 ? 'selected' : ''}>14 days</option>
                        <option value="30" ${daysThreshold == 30 ? 'selected' : ''}>30 days</option>
                        <option value="60" ${daysThreshold == 60 ? 'selected' : ''}>60 days</option>
                    </select>
                </div>

                <div class="col-md-2">
                    <label class="form-label"><strong>Batch Status</strong></label>
                    <select name="status" class="form-select">
                        <option value="All" ${statusFilter == 'All' ? 'selected' : ''}>All Status</option>
                        <option value="Approved" ${statusFilter == 'Approved' ? 'selected' : ''}>Approved</option>
                        <option value="Quarantined" ${statusFilter == 'Quarantined' ? 'selected' : ''}>Quarantined</option>
                        <option value="Received" ${statusFilter == 'Received' ? 'selected' : ''}>Received</option>
                    </select>
                </div>

                <div class="col-md-2">
                    <label class="form-label"><strong>Use Date Range</strong></label>
                    <input type="checkbox" name="useRange" value="true" class="form-check-input" 
                           onchange="toggleDateRange()" ${useRange == 'true' ? 'checked' : ''} style="width: 20px; height: 20px;">
                </div>

                <div class="col-md-2" id="startDateDiv" style="${useRange == 'true' ? '' : 'display:none;'}">
                    <label class="form-label"><strong>Start Date</strong></label>
                    <input type="date" name="startDate" class="form-control" value="${startDate}">
                </div>

                <div class="col-md-2" id="endDateDiv" style="${useRange == 'true' ? '' : 'display:none;'}">
                    <label class="form-label"><strong>End Date</strong></label>
                    <input type="date" name="endDate" class="form-control" value="${endDate}">
                </div>

                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-search"></i> Filter
                    </button>
                </div>
            </form>
        </div>

        <!-- Results Table -->
        <div class="card shadow">
            <div class="card-header bg-danger text-white">
                <h5 class="mb-0">
                    <i class="fas fa-list"></i> Expiry Records 
                    <span class="badge bg-light text-dark">${reports.size()}</span>
                </h5>
            </div>
            <div class="card-body">
                <c:if test="${empty reports}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i> No medicines expiring in this period.
                    </div>
                </c:if>

                <c:if test="${not empty reports}">
                    <div class="table-responsive">
                        <table class="table table-hover table-striped" id="expiryTable">
                            <thead class="table-dark">
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
                                        <td><span class="badge bg-secondary">${report.category}</span></td>
                                        <td>${report.lotNumber}</td>
                                        <td><span class="badge bg-info">${report.status}</span></td>
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
                    <div class="mt-4 text-end">
                        <button onclick="exportToCSV()" class="btn btn-success me-2">
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
            printWindow.document.write('<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">');
            printWindow.document.write('<style>body { padding: 20px; font-family: Arial; } table { border-collapse: collapse; width: 100%; } th, td { border: 1px solid #ddd; padding: 8px; text-align: left; } th { background-color: #343a40; color: white; }</style>');
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