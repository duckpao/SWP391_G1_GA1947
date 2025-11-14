<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>In Transit Orders - Hospital System</title>
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
            border-left: 5px solid #17a2b8;
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
            color: #17a2b8;
        }
        /* Card styling */
        .dashboard-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            margin-bottom: 30px;
            overflow: hidden;
            border-top: 3px solid #17a2b8;
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
        .status-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-intransit {
            background: #d1ecf1;
            color: #0c5460;
        }
        .btn {
            padding: 8px 16px;
            border-radius: 8px;
            border: none;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .btn-info {
            background: #17a2b8;
            color: white;
        }
        .btn-info:hover {
            background: #138496;
        }
        .btn-success {
            background: #28a745;
            color: white;
        }
        .btn-success:hover {
            background: #218838;
        }
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
        .alert-success {
            background: #dcfce7;
            color: #166534;
            border: 1px solid #86efac;
        }
        .alert-danger {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fca5a5;
        }
        .empty-state {
            padding: 60px;
            text-align: center;
            background: #f9fafb;
            border-radius: 12px;
            margin: 20px 0;
        }
        .empty-state h3 {
            color: #28a745;
            font-size: 24px;
            margin-bottom: 12px;
        }
        .empty-state p {
            color: #6b7280;
            font-size: 16px;
        }
        /* Modal styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
        }
        .modal.show {
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .modal-content {
            background: white;
            border-radius: 12px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            max-width: 700px;
            width: 90%;
            max-height: 90vh;
            display: flex;
            flex-direction: column;
        }
        .modal-header {
            padding: 24px;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #17a2b8;
            color: white;
            border-radius: 12px 12px 0 0;
        }
        .modal-header h5 {
            font-size: 18px;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .modal-body {
            padding: 24px;
            overflow-y: auto;
            flex: 1;
        }
        .modal-footer {
            padding: 24px;
            border-top: 1px solid #e5e7eb;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            background: #f9fafb;
            border-radius: 0 0 12px 12px;
        }
        .close-btn {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: white;
            opacity: 0.8;
        }
        .close-btn:hover {
            opacity: 1;
        }
        .info-section {
            margin: 20px 0;
            padding: 15px;
            background: #f9fafb;
            border-radius: 8px;
            border-left: 4px solid #17a2b8;
        }
        .info-section h3 {
            margin-top: 0;
            color: #17a2b8;
            font-size: 16px;
            margin-bottom: 12px;
        }
        .info-row {
            display: flex;
            padding: 8px 0;
            border-bottom: 1px solid #e5e7eb;
        }
        .info-row:last-child {
            border-bottom: none;
        }
        .info-label {
            font-weight: 600;
            width: 180px;
            color: #6b7280;
            font-size: 14px;
        }
        .info-value {
            flex: 1;
            color: #1f2937;
            font-size: 14px;
        }
        .items-table {
            width: 100%;
            margin-top: 10px;
            border-collapse: collapse;
        }
        .items-table th {
            background: #6c757d;
            color: white;
            padding: 12px;
            text-align: left;
            font-size: 13px;
        }
        .items-table td {
            padding: 12px;
            border-bottom: 1px solid #e5e7eb;
            font-size: 13px;
        }
        .confirm-modal .modal-header {
            background: #ffc107;
            color: #333;
        }
        .warning-icon {
            font-size: 48px;
            color: #ffc107;
            text-align: center;
            margin: 20px 0;
        }
        .confirm-details {
            background: #fff3cd;
            border: 1px solid #ffc107;
            border-radius: 8px;
            padding: 15px;
            margin: 20px 0;
        }
        .spinner {
            border: 4px solid #f3f3f3;
            border-top: 4px solid #17a2b8;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin: 20px auto;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
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
            .page-header h2 {
                font-size: 24px;
            }
            .stats-grid {
                grid-template-columns: 1fr;
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

<!-- Order History Section -->
<h6 style="font-size: 11px; font-weight: 600; color: #9ca3af; margin-bottom: 8px; text-transform: uppercase; letter-spacing: 0.5px;">
    ORDER HISTORY
</h6>
<a class="nav-link" href="${pageContext.request.contextPath}/manager/sent-orders">
    <i class="bi bi-send-check"></i> Sent Orders
</a>
                    <a class="nav-link active" href="${pageContext.request.contextPath}/manage/transit">
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

</li>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Page Header -->
            <div class="page-header">
                <h2><i class="bi bi-truck"></i> In Transit Orders</h2>
            </div>

            <!-- Message Alerts -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="bi bi-exclamation-circle"></i>
                    <strong>Error:</strong> ${error}
                </div>
            </c:if>

            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-content">
                        <div class="stat-info">
                            <h6>Orders In Transit</h6>
                            <h3>${orderCount}</h3>
                        </div>
                        <div class="stat-icon">
                            <i class="bi bi-truck"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Orders Table -->
            <div class="dashboard-card">
                <div class="card-header">
                    <h5><i class="bi bi-list-ul"></i> Transit Order List</h5>
                </div>
                <div class="card-body">
                    <c:if test="${empty orders}">
                        <div class="empty-state">
                            <div style="font-size: 64px; margin-bottom: 16px;">✅</div>
                            <h3>No Orders In Transit</h3>
                            <p>All orders have been delivered or are awaiting shipment.</p>
                        </div>
                    </c:if>

                    <c:if test="${not empty orders}">
                        <table>
                            <thead>
                                <tr>
                                    <th>ASN ID</th>
                                    <th>PO ID</th>
                                    <th>Supplier</th>
                                    <th>Tracking Number</th>
                                    <th>Carrier</th>
                                    <th>Shipment Date</th>
                                    <th>Expected Delivery</th>
                                    <th>Items / Quantity</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${orders}">
                                    <tr>
                                        <td><strong>#${order.asnId}</strong></td>
                                        <td>#${order.poId}</td>
                                        <td><strong>${order.supplierName}</strong></td>
                                        <td><code style="background: #f3f4f6; padding: 4px 8px; border-radius: 4px; font-size: 12px;">${order.trackingNumber}</code></td>
                                        <td>${order.carrier}</td>
                                        <td><fmt:formatDate value="${order.shipmentDate}" pattern="dd/MM/yyyy"/></td>
                                        <td><fmt:formatDate value="${order.expectedDeliveryDate}" pattern="dd/MM/yyyy"/></td>
                                        <td>
                                            <strong>${order.totalItems}</strong> items / 
                                            <strong style="color: #17a2b8;">${order.totalQuantity}</strong> units
                                        </td>
                                        <td><span class="status-badge status-intransit">${order.status}</span></td>
                                        <td style="white-space: nowrap;">
                                            <button class="btn btn-info" 
                                                    onclick="viewDetails(${order.asnId})">
                                                <i class="bi bi-eye"></i> Details
                                            </button>
                                            <button class="btn btn-success" 
                                                    onclick="confirmDelivery(${order.asnId}, ${order.poId}, '${order.supplierName}', '${order.trackingNumber}', ${order.totalQuantity})">
                                                <i class="bi bi-check-circle"></i> Confirm
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- Details Modal -->
    <div id="detailsModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h5 id="detailsTitle"><i class="bi bi-info-circle"></i> Order Details</h5>
                <button class="close-btn" onclick="closeDetailsModal()">&times;</button>
            </div>
            <div class="modal-body" id="detailsContent">
                <div class="spinner"></div>
                <p style="text-align: center;">Loading...</p>
            </div>
            <div class="modal-footer">
                <button onclick="closeDetailsModal()" class="btn" style="background: #6c757d; color: white;">
                    <i class="bi bi-x"></i> Close
                </button>
            </div>
        </div>
    </div>

    <!-- Confirm Delivery Modal -->
    <div id="confirmModal" class="modal">
        <div class="modal-content confirm-modal">
            <div class="modal-header">
                <h5><i class="bi bi-exclamation-triangle"></i> Confirm Delivery</h5>
                <button class="close-btn" onclick="closeConfirmModal()">&times;</button>
            </div>
            <div class="modal-body">
                <div class="warning-icon">⚠️</div>
                <p id="confirmMessage" style="font-size: 16px; text-align: center; font-weight: 600; color: #333;"></p>
                <div class="confirm-details" id="confirmDetails"></div>
                <p style="color: #6b7280; text-align: center; margin-top: 20px; font-size: 14px;">
                    <i class="bi bi-info-circle"></i> After confirmation, you will be redirected to payment.
                </p>
            </div>
            <div class="modal-footer">
                <button onclick="closeConfirmModal()" class="btn" style="background: #6c757d; color: white;">
                    <i class="bi bi-x"></i> Cancel
                </button>
                <button onclick="submitConfirmDelivery()" id="confirmBtn" class="btn btn-success">
                    <i class="bi bi-check-circle"></i> Confirm Delivery
                </button>
            </div>
        </div>
    </div>

    <script>
        let currentAsnId = null;
        let currentPoId = null;
        let currentSupplierName = '';
        let currentTotalQuantity = 0;

        // View Details
        function viewDetails(asnId) {
            console.log('Opening details for ASN #' + asnId);
            document.getElementById('detailsModal').classList.add('show');
            document.getElementById('detailsContent').innerHTML =
                '<div class="spinner"></div><p style="text-align: center;">Loading details...</p>';

            fetch('${pageContext.request.contextPath}/manage/transit?action=details&asnId=' + asnId)
                .then(response => {
                    if (!response.ok) throw new Error('HTTP ' + response.status);
                    return response.json();
                })
                .then(data => {
                    if (data.success) {
                        displayDetails(data);
                    } else {
                        document.getElementById('detailsContent').innerHTML =
                            '<div class="alert alert-danger"><strong>Error:</strong> ' + data.message + '</div>';
                    }
                })
                .catch(error => {
                    document.getElementById('detailsContent').innerHTML =
                        '<div class="alert alert-danger"><strong>Error:</strong> ' + error.message + '</div>';
                });
        }

        function displayDetails(data) {
            const asn = data.asn;
            const items = data.items;

            let html = '<div class="info-section">';
            html += '<h3><i class="bi bi-box-seam"></i> Shipment Information</h3>';
            html += '<div class="info-row"><div class="info-label">ASN ID:</div><div class="info-value"><strong>#' + asn.asnId + '</strong></div></div>';
            html += '<div class="info-row"><div class="info-label">PO ID:</div><div class="info-value"><strong>#' + asn.poId + '</strong></div></div>';
            html += '<div class="info-row"><div class="info-label">Supplier:</div><div class="info-value"><strong>' + asn.supplierName + '</strong></div></div>';
            html += '<div class="info-row"><div class="info-label">Tracking Number:</div><div class="info-value"><code style="background: #f3f4f6; padding: 4px 8px; border-radius: 4px;">' + asn.trackingNumber + '</code></div></div>';
            html += '<div class="info-row"><div class="info-label">Carrier:</div><div class="info-value">' + asn.carrier + '</div></div>';
            html += '<div class="info-row"><div class="info-label">Shipment Date:</div><div class="info-value">' + asn.shipmentDate + '</div></div>';
            html += '<div class="info-row"><div class="info-label">Status:</div><div class="info-value"><span class="status-badge status-intransit">' + asn.status + '</span></div></div>';
            if (asn.notes && asn.notes.trim() !== '') {
                html += '<div class="info-row"><div class="info-label">Notes:</div><div class="info-value">' + asn.notes + '</div></div>';
            }
            html += '</div>';

            html += '<div class="info-section">';
            html += '<h3><i class="bi bi-capsule"></i> Order Items (' + items.length + ' items)</h3>';
            html += '<table class="items-table">';
            html += '<thead><tr><th>Medicine Name</th><th>Quantity</th><th>Unit</th><th>Lot Number</th></tr></thead>';
            html += '<tbody>';
            items.forEach(item => {
                html += '<tr>';
                html += '<td><strong>' + item.medicineName + '</strong></td>';
                html += '<td style="text-align: center;"><strong style="color: #17a2b8; font-size: 16px;">' + item.quantity + '</strong></td>';
                html += '<td>' + (item.unit || 'N/A') + '</td>';
                html += '<td><code style="background: #f3f4f6; padding: 4px 8px; border-radius: 4px; font-size: 12px;">' + (item.lotNumber || 'N/A') + '</code></td>';
                html += '</tr>';
            });
            html += '</tbody></table>';
            html += '</div>';

            document.getElementById('detailsContent').innerHTML = html;
            document.getElementById('detailsTitle').innerHTML = '<i class="bi bi-info-circle"></i> Order Details - ASN #' + asn.asnId;
        }

        function closeDetailsModal() {
            document.getElementById('detailsModal').classList.remove('show');
        }

        // Confirm Delivery
        function confirmDelivery(asnId, poId, supplierName, trackingNumber, totalQuantity) {
            currentAsnId = asnId;
            currentPoId = poId;
            currentSupplierName = supplierName;
            currentTotalQuantity = totalQuantity;

            document.getElementById('confirmMessage').innerHTML =
                'Are you sure you want to confirm delivery for order <strong style="color: #17a2b8;">ASN #' + asnId + '</strong> from supplier <strong style="color: #28a745;">' + supplierName + '</strong>?';

            let detailsHtml = '<div class="info-row"><div class="info-label">ASN ID:</div><div class="info-value"><strong>#' + asnId + '</strong></div></div>';
            detailsHtml += '<div class="info-row"><div class="info-label">PO ID:</div><div class="info-value"><strong>#' + poId + '</strong></div></div>';
            detailsHtml += '<div class="info-row"><div class="info-label">Tracking Number:</div><div class="info-value"><code style="background: #f3f4f6; padding: 4px 8px; border-radius: 4px;">' + trackingNumber + '</code></div></div>';
            detailsHtml += '<div class="info-row"><div class="info-label">Supplier:</div><div class="info-value"><strong>' + supplierName + '</strong></div></div>';
            detailsHtml += '<div class="info-row"><div class="info-label">Total Quantity:</div><div class="info-value"><strong style="color: #17a2b8; font-size: 18px;">' + totalQuantity + '</strong> units</div></div>';

            document.getElementById('confirmDetails').innerHTML = detailsHtml;
            document.getElementById('confirmModal').classList.add('show');
        }

        function closeConfirmModal() {
            document.getElementById('confirmModal').classList.remove('show');
            const btn = document.getElementById('confirmBtn');
            btn.disabled = false;
            btn.innerHTML = '<i class="bi bi-check-circle"></i> Confirm Delivery';
        }

        function submitConfirmDelivery() {
            const btn = document.getElementById('confirmBtn');
            btn.disabled = true;
            btn.innerHTML = '<span style="display: inline-block; width: 15px; height: 15px; border: 2px solid white; border-top-color: transparent; border-radius: 50%; animation: spin 0.6s linear infinite;"></span> Processing...';

            const formData = new FormData();
            formData.append('action', 'confirmDelivery');
            formData.append('asnId', currentAsnId);

            fetch('${pageContext.request.contextPath}/manage/transit', {
                method: 'POST',
                body: formData
            })
            .then(async response => {
                const text = await response.text();
                let data;
                try {
                    data = JSON.parse(text);
                } catch (e) {
                    console.error("Response is not JSON:", text);
                    throw new Error("Server error");
                }
                if (!response.ok) {
                    throw new Error(data.message || 'Server error');
                }
                return data;
            })
            .then(data => {
                if (data.success) {
                    alert('✅ Delivery confirmed successfully!\n\nDelivery Note ID: #' + data.dnId);
                    closeConfirmModal();
                    
                    // Redirect to VNPay
                    setTimeout(() => redirectToVNPay(data.poId), 500);
                } else {
                    alert('❌ Error: ' + data.message);
                    btn.disabled = false;
                    btn.innerHTML = '<i class="bi bi-check-circle"></i> Confirm Delivery';
                }
            })
            .catch(err => {
                console.error("Error:", err);
                alert("❌ Error: " + err.message);
                btn.disabled = false;
                btn.innerHTML = '<i class="bi bi-check-circle"></i> Confirm Delivery';
            });
        }

        function redirectToVNPay(poId) {
            console.log('Redirecting to VNPay for payment...');
            
            // Show loading overlay
            const overlay = document.createElement('div');
            overlay.style.cssText = 'position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.8); z-index: 9999; display: flex; align-items: center; justify-content: center;';
            overlay.innerHTML = `
                <div style="background: white; padding: 40px; border-radius: 12px; text-align: center; box-shadow: 0 20px 60px rgba(0,0,0,0.3);">
                    <div style="font-size: 64px; margin-bottom: 20px;">💳</div>
                    <h2 style="margin: 0 0 15px 0; color: #1f2937;">Redirecting to VNPay</h2>
                    <p style="color: #6b7280; margin-bottom: 20px;">Please wait...</p>
                    <div class="spinner"></div>
                </div>
            `;
            document.body.appendChild(overlay);
            
            // Create form to submit
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '${pageContext.request.contextPath}/vnpay-payment';
            
            const asnInput = document.createElement('input');
            asnInput.type = 'hidden';
            asnInput.name = 'asnId';
            asnInput.value = currentAsnId;
            form.appendChild(asnInput);
            
            const poInput = document.createElement('input');
            poInput.type = 'hidden';
            poInput.name = 'poId';
            poInput.value = poId;
            form.appendChild(poInput);
            
            document.body.appendChild(form);
            setTimeout(() => form.submit(), 1000);
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            if (event.target.classList.contains('modal')) {
                event.target.classList.remove('show');
            }
        }

        // Log page load
        console.log('Transit Orders Page Loaded');
        console.log('Total orders in transit: ${orderCount}');
    </script>
</body>
<%@ include file="/admin/footer.jsp" %>
</html>