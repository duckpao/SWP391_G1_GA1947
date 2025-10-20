<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventory Report</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .stats-card {
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 20px;
            text-align: center;
            margin-bottom: 20px;
            background: white;
        }
        .stat-border { border-left: 5px solid #0dcaf0; }
        .filter-section { 
            background: #f8f9fa; 
            padding: 20px; 
            border-radius: 10px; 
            margin-bottom: 20px;
            border: 1px solid #dee2e6;
        }
        .nav-tabs .nav-link { color: #0dcaf0; }
        .nav-tabs .nav-link.active { 
            background-color: #0dcaf0; 
            color: white;
            border-color: #0dcaf0;
        }
        table { background: white; }
        table tbody tr:hover { background-color: #f5f5f5; }
        .status-approved { background-color: #d4edda; color: #155724; padding: 4px 8px; border-radius: 4px; }
        .status-quarantined { background-color: #fff3cd; color: #856404; padding: 4px 8px; border-radius: 4px; }
        .card { border: none; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
    </style>
</head>
<body>
    <div class="container-fluid mt-4 mb-5">
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>
                <i class="fas fa-boxes text-info"></i> ${pageTitle}
            </h2>
            <a href="${pageContext.request.contextPath}/manager-dashboard" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
        </div>

        <!-- Statistics Cards (Summary Only) -->
        <c:if test="${reportType == 'summary' && statistics != null}">
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="stats-card stat-border">
                        <h6 class="text-muted mb-2">Total Medicines</h6>
                        <h3 class="mb-0 text-info">${statistics.get('totalMedicines')}</h3>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stats-card stat-border">
                        <h6 class="text-muted mb-2">Total Batches</h6>
                        <h3 class="mb-0 text-info">${statistics.get('totalBatches')}</h3>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stats-card stat-border">
                        <h6 class="text-muted mb-2">Total Quantity</h6>
                        <h3 class="mb-0 text-info">${statistics.get('totalQuantity')}</h3>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stats-card stat-border">
                        <h6 class="text-muted mb-2">Approved Quantity</h6>
                        <h3 class="mb-0 text-success">${statistics.get('approvedQuantity')}</h3>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Report Type Tabs -->
        <ul class="nav nav-tabs mb-4" role="tablist">
            <li class="nav-item">
                <a class="nav-link ${reportType == 'summary' ? 'active' : ''}" href="?type=summary">
                    <i class="fas fa-chart-bar"></i> Summary
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${reportType == 'supplier' ? 'active' : ''}" href="?type=supplier">
                    <i class="fas fa-building"></i> By Supplier
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${reportType == 'batch' ? 'active' : ''}" href="?type=batch">
                    <i class="fas fa-cube"></i> Batch Details
                </a>
            </li>
        </ul>

        <!-- Filter Section for Batch Report -->
        <c:if test="${reportType == 'batch'}">
            <div class="filter-section">
                <h5 class="mb-3"><i class="fas fa-sliders-h"></i> Filters</h5>
                <form method="get" class="row g-3">
                    <input type="hidden" name="type" value="batch">
                    
                    <div class="col-md-4">
                        <label class="form-label fw-bold">Start Date (Received)</label>
                        <input type="date" name="startDate" class="form-control" value="${startDate}">
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-bold">End Date (Received)</label>
                        <input type="date" name="endDate" class="form-control" value="${endDate}">
                    </div>

                    <div class="col-md-4 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fas fa-search"></i> Filter
                        </button>
                    </div>
                </form>
            </div>
        </c:if>

        <!-- Results Card -->
        <div class="card">
            <div class="card-header bg-info text-white">
                <h5 class="mb-0">
                    <i class="fas fa-list"></i> Results
                    <span class="badge bg-light text-dark ms-2">${reports.size()}</span>
                </h5>
            </div>
            <div class="card-body">
                <c:if test="${empty reports}">
                    <div class="alert alert-info" role="alert">
                        <i class="fas fa-info-circle"></i> No data available for this report.
                    </div>
                </c:if>

                <!-- Summary Table -->
                <c:if test="${reportType == 'summary' && not empty reports}">
                    <div class="table-responsive">
                        <table class="table table-hover table-striped" id="reportTable">
                            <thead class="table-dark">
                                <tr>
                                    <th>Medicine ID</th>
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
                                        <td><strong>#${report.medicineId}</strong></td>
                                        <td>${report.medicineName}</td>
                                        <td><span class="badge bg-secondary">${report.category}</span></td>
                                        <td><span class="badge bg-primary">${report.totalBatches}</span></td>
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
                        <table class="table table-hover table-striped" id="reportTable">
                            <thead class="table-dark">
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
                                        <td><span class="badge bg-primary">${report.totalBatches}</span></td>
                                        <td><strong>${report.totalQuantity}</strong></td>
                                        <td><span class="badge bg-success">${report.medicineTypes}</span></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>

                <!-- Batch Details Table -->
                <c:if test="${reportType == 'batch' && not empty reports}">
                    <div class="table-responsive">
                        <table class="table table-hover table-striped" id="reportTable">
                            <thead class="table-dark">
                                <tr>
                                    <th>Batch ID</th>
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
                                        <td>${report.medicineName}</td>
                                        <td>${report.lotNumber}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${report.status == 'Approved'}">
                                                    <span class="badge bg-success">${report.status}</span>
                                                </c:when>
                                                <c:when test="${report.status == 'Quarantined'}">
                                                    <span class="badge bg-warning text-dark">${report.status}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-info">${report.status}</span>
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
            printWindow.document.write('<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">');
            printWindow.document.write('<style>body { padding: 20px; }</style>');
            printWindow.document.write('</head><body>');
            printWindow.document.write('<h2 class="mb-4">${pageTitle}</h2>');
            printWindow.document.write(table);
            printWindow.document.write('</body></html>');
            printWindow.document.close();
            printWindow.print();
        }
    </script>
</body>
</html>