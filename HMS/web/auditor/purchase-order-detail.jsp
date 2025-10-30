<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Purchase Order Details</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
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
        }

        /* Sidebar styling updated to white theme */
        .sidebar {
            width: 280px;
            background: white;
            color: #1f2937;
            padding: 30px 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            border-right: 1px solid #e5e7eb;
            overflow-y: auto;
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

        /* Main content area styling */
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
            color: #3b82f6;
            text-decoration: none;
        }

        .breadcrumb-item.active {
            color: #6b7280;
        }

        .page-actions {
            display: flex;
            gap: 12px;
            margin-bottom: 30px;
        }

        .btn {
            padding: 10px 20px;
            border-radius: 10px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            font-family: inherit;
        }

        .btn-secondary {
            background: #f3f4f6;
            color: #374151;
        }

        .btn-secondary:hover {
            background: #e5e7eb;
        }

        .btn-primary {
            background: #3b82f6;
            color: white;
        }

        .btn-primary:hover {
            background: #2563eb;
        }

        /* Card styling */
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
            display: flex;
            align-items: center;
            gap: 10px;
            border-top: 4px solid #3b82f6;
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

        .info-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 24px;
            margin-bottom: 24px;
        }

        .info-group {
            display: flex;
            flex-direction: column;
        }

        .info-label {
            font-size: 13px;
            font-weight: 600;
            color: #9ca3af;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }

        .info-value {
            font-size: 16px;
            font-weight: 600;
            color: #1f2937;
        }

        .info-value.primary {
            color: #3b82f6;
        }

        .badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            width: fit-content;
        }

        .badge-success {
            background: #d1fae5;
            color: #065f46;
        }

        .badge-warning {
            background: #fef3c7;
            color: #92400e;
        }

        .badge-danger {
            background: #fee2e2;
            color: #991b1b;
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

        tfoot {
            background: #f9fafb;
            border-top: 2px solid #e5e7eb;
        }

        code {
            background: #f3f4f6;
            padding: 4px 8px;
            border-radius: 4px;
            font-family: 'Courier New', monospace;
            font-size: 13px;
        }

        /* Quick actions buttons */
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 16px;
        }

        .action-btn {
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            padding: 16px;
            text-align: center;
            text-decoration: none;
            color: #374151;
            transition: all 0.3s ease;
            cursor: pointer;
            font-family: inherit;
            font-size: 14px;
            font-weight: 600;
        }

        .action-btn:hover {
            border-color: #3b82f6;
            background: #f9fafb;
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(59, 130, 246, 0.15);
        }

        .action-btn i {
            font-size: 24px;
            display: block;
            margin-bottom: 8px;
            color: #3b82f6;
        }

        /* Responsive design */
        @media (max-width: 768px) {
            .page-wrapper {
                flex-direction: column;
            }

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

            .info-row {
                grid-template-columns: 1fr;
            }

            .page-actions {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }

            .quick-actions {
                grid-template-columns: 1fr;
            }
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
    </style>
</head>
<body>
    <!-- Include header.jsp -->
    <%@ include file="header.jsp" %>

    <div class="page-wrapper">
        <div class="dashboard-container">
            <!-- Sidebar from auditor dashboard -->
            <div class="sidebar">
                <div class="sidebar-header">
                    <h4><i class="bi bi-hospital"></i> Auditor</h4>
                    <hr class="sidebar-divider">
                    <!-- Removed user info section -->
                </div>

                <nav>
                    <a class="nav-link" href="${pageContext.request.contextPath}/auditor-dashboard">
                        <i class="bi bi-speedometer2"></i> Dashboard
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/purchase-orders">
                        <i class="bi bi-receipt"></i> Purchase Orders
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/purchase-orders/history">
                        <i class="bi bi-clock-history"></i> PO History & Trends
                    </a>
                    <a class="nav-link" href="#">
                        <i class="bi bi-box-seam"></i> Inventory Audit
                    </a>
                    <a class="nav-link" href="#">
                        <i class="bi bi-graph-up"></i> Reports
                    </a>
                    <a class="nav-link" href="#">
                        <i class="bi bi-journal-text"></i> System Logs
                    </a>
                    <hr class="nav-divider">
                    <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                        <i class="bi bi-box-arrow-right"></i> Đăng xuất
                    </a>
                </nav>
            </div>

            <!-- Main content with new styling -->
            <div class="main-content">
                <!-- Header -->
                <div class="page-header">
                    <h2><i class="bi bi-receipt-cutoff"></i> Purchase Order Details</h2>
                </div>

                <div class="page-actions">
                    <a href="purchase-orders" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> Back to List
                    </a>
                    <button class="btn btn-primary" onclick="window.print()">
                        <i class="bi bi-printer"></i> Print
                    </button>
                </div>

                <!-- PO Information -->
                <div class="dashboard-card">
                    <div class="card-header">
                        <h5><i class="bi bi-info-circle"></i> Purchase Order Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="info-row">
                            <div class="info-group">
                                <span class="info-label">PO ID</span>
                                <span class="info-value primary">#${purchaseOrder.poId}</span>
                            </div>
                            <div class="info-group">
                                <span class="info-label">Status</span>
                                <span class="badge badge-success">${purchaseOrder.status}</span>
                            </div>
                            <div class="info-group">
                                <span class="info-label">Order Date</span>
                                <span class="info-value">
                                    <i class="bi bi-calendar"></i>
                                    <fmt:formatDate value="${purchaseOrder.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                                </span>
                            </div>
                            <div class="info-group">
                                <span class="info-label">Expected Delivery</span>
                                <span class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty purchaseOrder.expectedDeliveryDate}">
                                            <i class="bi bi-truck"></i>
                                            <fmt:formatDate value="${purchaseOrder.expectedDeliveryDate}" pattern="dd/MM/yyyy"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #9ca3af;">Not specified</span>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="info-group">
                                <span class="info-label">Manager</span>
                                <span class="info-value"><i class="bi bi-person-badge"></i> ${purchaseOrder.managerName}</span>
                            </div>
                            <div class="info-group">
                                <span class="info-label">Last Updated</span>
                                <span class="info-value">
                                    <i class="bi bi-clock-history"></i>
                                    <fmt:formatDate value="${purchaseOrder.updatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </span>
                            </div>
                        </div>
                        <c:if test="${not empty purchaseOrder.notes}">
                            <hr style="border: none; border-top: 1px solid #e5e7eb; margin: 24px 0;">
                            <div class="info-group">
                                <span class="info-label">Notes</span>
                                <span class="info-value">${purchaseOrder.notes}</span>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Items List Card -->
                <div class="dashboard-card">
                    <div class="card-header">
                        <h5><i class="bi bi-box-seam"></i> Order Items</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table>
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Medicine Code</th>
                                        <th>Medicine Name</th>
                                        <th>Manufacturer</th>
                                        <th>Quantity</th>
                                        <th>Unit</th>
                                        <th>Unit Price</th>
                                        <th>Subtotal</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:set var="totalAmount" value="0"/>
                                    <c:forEach var="item" items="${items}" varStatus="status">
                                        <tr>
                                            <td>${status.index + 1}</td>
                                            <td><code>${item.medicineCode}</code></td>
                                            <td><strong>${item.medicineName}</strong></td>
                                            <td>${item.manufacturer}</td>
                                            <td><span class="badge badge-success">${item.quantity}</span></td>
                                            <td>${item.unit}</td>
                                            <td>
                                                <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="$"/>
                                            </td>
                                            <td>
                                                <strong>
                                                    <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="$"/>
                                                </strong>
                                            </td>
                                        </tr>
                                        <c:set var="totalAmount" value="${totalAmount + item.subtotal}"/>
                                    </c:forEach>
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <td colspan="7" style="text-align: right;"><strong>Total Amount:</strong></td>
                                        <td>
                                            <strong style="color: #3b82f6; font-size: 16px;">
                                                <fmt:formatNumber value="${totalAmount}" type="currency" currencySymbol="$"/>
                                            </strong>
                                        </td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Supplier Info and Quick Actions -->
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px;">
                    <!-- Supplier Information -->
                    <div class="dashboard-card">
                        <div class="card-header">
                            <h5><i class="bi bi-building"></i> Supplier Information</h5>
                        </div>
                        <div class="card-body">
                            <div class="info-group" style="margin-bottom: 16px;">
                                <span class="info-label">Supplier Name</span>
                                <span class="info-value">${purchaseOrder.supplierName}</span>
                            </div>
                            <div class="info-group">
                                <span class="info-label">Supplier ID</span>
                                <span class="info-value">#${purchaseOrder.supplierId}</span>
                            </div>
                        </div>
                    </div>

                    <!-- Quick Actions -->
                    <div class="dashboard-card">
                        <div class="card-header">
                            <h5><i class="bi bi-lightning"></i> Quick Actions</h5>
                        </div>
                        <div class="card-body">
                            <div class="quick-actions">
                                <button class="action-btn" onclick="viewAuditLog()">
                                    <i class="bi bi-journal-text"></i>
                                    View Audit Log
                                </button>
                                <button class="action-btn" onclick="viewRelatedDocs()">
                                    <i class="bi bi-file-earmark-text"></i>
                                    Related Documents
                                </button>
                                <button class="action-btn" onclick="exportPDF()">
                                    <i class="bi bi-file-pdf"></i>
                                    Export as PDF
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Include footer.jsp -->
    <%@ include file="footer.jsp" %>

    <script>
        function viewAuditLog() {
            alert('View audit log functionality to be implemented');
        }

        function viewRelatedDocs() {
            alert('View related documents functionality to be implemented');
        }

        function exportPDF() {
            alert('Export to PDF functionality to be implemented');
        }
    </script>
</body>
</html>
