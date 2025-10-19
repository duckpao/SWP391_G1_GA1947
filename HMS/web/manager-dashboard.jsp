<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manager Dashboard - Hospital System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .dashboard-card {
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .stat-card {
            text-align: center;
            padding: 20px;
            border-radius: 10px;
            color: white;
            margin-bottom: 20px;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.2);
        }
        .stat-card-blue { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .stat-card-green { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
        .stat-card-orange { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); }
        .status-badge {
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-draft { background-color: #6c757d; color: white; }
        .status-sent { background-color: #0dcaf0; color: white; }
        .status-rejected { background-color: #dc3545; color: white; }
        .status-cancelled { background-color: #6c757d; color: white; }
        .details-row {
            background-color: #f8f9fa;
            border-left: 3px solid #0d6efd;
        }
        .details-content {
            padding: 15px;
        }
        .item-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .item-list li {
            padding: 10px;
            border-bottom: 1px solid #dee2e6;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .item-list li:last-child {
            border-bottom: none;
        }
        .priority-high { color: #dc3545; font-weight: bold; }
        .priority-medium { color: #ffc107; font-weight: bold; }
        .priority-low { color: #17a2b8; font-weight: bold; }
        .report-button {
            display: inline-block;
            margin: 5px;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="fas fa-hospital"></i> Hospital Manager
            </a>
            <div class="ms-auto d-flex align-items-center">
                <span class="text-white me-3">
                    <i class="fas fa-user"></i> ${manager.username}
                </span>
                <a class="btn btn-outline-light btn-sm" href="logout">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <!-- Message Alert -->
        <c:if test="${not empty message}">
            <div class="alert alert-${messageType == 'success' ? 'success' : 'danger'} alert-dismissible fade show">
                <i class="fas fa-${messageType == 'success' ? 'check-circle' : 'exclamation-circle'}"></i>
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Dashboard Header -->
        <div class="row mb-4">
            <div class="col-12">
                <h2><i class="fas fa-tachometer-alt"></i> Manager Dashboard</h2>
                <p class="text-muted">Welcome back, ${manager.username}!</p>
            </div>
        </div>

        <!-- Statistics Cards -->
        <div class="row">
            <div class="col-md-4">
                <div class="stat-card stat-card-blue">
                    <h3><i class="fas fa-warehouse"></i></h3>
                    <p>Warehouse Status</p>
                    <h5>${warehouseStatus}</h5>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card stat-card-green">
                    <h3><i class="fas fa-exclamation-triangle"></i></h3>
                    <p>Stock Alerts</p>
                    <h5>${stockAlerts.size()} Items Low</h5>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card stat-card-orange">
                    <h3><i class="fas fa-clipboard-list"></i></h3>
                    <p>Stock Requests</p>
                    <h5>${pendingRequests.size()} Orders</h5>
                </div>
            </div>
        </div>

        <!-- Quick Actions - Reports Section -->
        <div class="row mt-4">
            <div class="col-12">
                <div class="card dashboard-card">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">
                            <i class="fas fa-chart-bar"></i> Reports & Actions
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <!-- Inventory Report -->
                            <div class="col-md-6">
                                <div class="card border-info mb-3">
                                    <div class="card-body">
                                        <h5 class="card-title">
                                            <i class="fas fa-boxes text-info"></i> Inventory Report
                                        </h5>
                                        <p class="card-text">View detailed inventory information including medicine stock levels, batches, and supplier performance.</p>
                                        <div class="btn-group w-100" role="group">
                                            <a href="${pageContext.request.contextPath}/inventory-report?type=summary" 
                                               class="btn btn-info btn-sm">
                                                <i class="fas fa-chart-pie"></i> Summary
                                            </a>
                                            <a href="${pageContext.request.contextPath}/inventory-report?type=supplier" 
                                               class="btn btn-info btn-sm">
                                                <i class="fas fa-building"></i> By Supplier
                                            </a>
                                            <a href="${pageContext.request.contextPath}/inventory-report?type=batch" 
                                               class="btn btn-info btn-sm">
                                                <i class="fas fa-cube"></i> Batch Details
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Expiry Report -->
                            <div class="col-md-6">
                                <div class="card border-danger mb-3">
                                    <div class="card-body">
                                        <h5 class="card-title">
                                            <i class="fas fa-calendar-times text-danger"></i> Expiry Report
                                        </h5>
                                        <p class="card-text">Monitor medicines expiring soon and manage batch expiry dates to prevent expired stock.</p>
                                        <div class="btn-group w-100" role="group">
                                            <a href="${pageContext.request.contextPath}/expiry-report?days=7" 
                                               class="btn btn-danger btn-sm">
                                                <i class="fas fa-exclamation-circle"></i> 7 Days
                                            </a>
                                            <a href="${pageContext.request.contextPath}/expiry-report?days=30" 
                                               class="btn btn-danger btn-sm">
                                                <i class="fas fa-calendar-alt"></i> 30 Days
                                            </a>
                                            <a href="${pageContext.request.contextPath}/expiry-report?days=60" 
                                               class="btn btn-danger btn-sm">
                                                <i class="fas fa-history"></i> 60 Days
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Content - Stock Requests Section -->
        <div class="row mt-4">
            <div class="col-12">
                <div class="card dashboard-card">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">
                            <i class="fas fa-clipboard-list"></i> Stock Requests
                        </h5>
                        <div>
                            <a href="create-stock" class="btn btn-light btn-sm me-2">
                                <i class="fas fa-plus"></i> New Request
                            </a>
                            <a href="cancelled-tasks" class="btn btn-secondary btn-sm me-2">
                                <i class="fas fa-ban"></i> View Cancelled Tasks
                            </a>
                            <a href="tasks/assign" class="btn btn-info btn-sm">
                                <i class="fas fa-tasks"></i> Assign Tasks
                            </a>
                        </div>
                    </div>
                    <div class="card-body">
                        <c:if test="${empty pendingRequests}">
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle"></i> No stock requests at the moment.
                            </div>
                        </c:if>

                        <c:if test="${not empty pendingRequests}">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th width="80">PO #</th>
                                            <th width="100">Status</th>
                                            <th>Supplier</th>
                                            <th>Order Date</th>
                                            <th>Expected Delivery</th>
                                            <th>Manager</th>
                                            <th width="300">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${pendingRequests}" var="order">
                                            <tr>
                                                <td><strong>#${order.poId}</strong></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${order.status == 'Draft'}">
                                                            <span class="status-badge status-draft">Draft</span>
                                                        </c:when>
                                                        <c:when test="${order.status == 'Sent'}">
                                                            <span class="status-badge status-sent">Sent</span>
                                                        </c:when>
                                                        <c:when test="${order.status == 'Cancelled'}">
                                                            <span class="status-badge status-cancelled">Cancelled</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge status-rejected">Rejected</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty order.supplierName}">
                                                            ${order.supplierName}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Not assigned</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${order.orderDate}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty order.expectedDeliveryDate}">
                                                            ${order.expectedDeliveryDate}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">N/A</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${order.managerName}</td>
                                                <td>
                                                    <button class="btn btn-info btn-sm" 
                                                            onclick="toggleDetails(${order.poId})" 
                                                            title="View Details">
                                                        <i class="fas fa-eye"></i> Details
                                                    </button>
                                                    <c:choose>
                                                        <c:when test="${order.status == 'Draft'}">
                                                            <button class="btn btn-success btn-sm" 
                                                                    onclick="approveOrder(${order.poId})" 
                                                                    title="Send to Supplier">
                                                                <i class="fas fa-paper-plane"></i> Send
                                                            </button>
                                                            <a href="edit-stock?poId=${order.poId}" 
                                                               class="btn btn-warning btn-sm" 
                                                               title="Edit">
                                                                <i class="fas fa-edit"></i>
                                                            </a>
                                                            <button class="btn btn-danger btn-sm" 
                                                                    onclick="deleteOrder(${order.poId})" 
                                                                    title="Delete">
                                                                <i class="fas fa-trash"></i>
                                                            </button>
                                                        </c:when>
                                                        <c:when test="${order.status == 'Sent'}">
                                                            <button class="btn btn-warning btn-sm" 
                                                                    onclick="cancelOrder(${order.poId})" 
                                                                    title="Cancel Request">
                                                                <i class="fas fa-ban"></i> Cancel
                                                            </button>
                                                        </c:when>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                            <!-- Details Row (Hidden by default) -->
                                            <tr id="details-${order.poId}" class="details-row" style="display: none;">
                                                <td colspan="7">
                                                    <div class="details-content">
                                                        <div class="row">
                                                            <div class="col-md-6">
                                                                <h6><i class="fas fa-info-circle"></i> General Information</h6>
                                                                <table class="table table-sm table-borderless">
                                                                    <tr>
                                                                        <td width="150"><strong>PO ID:</strong></td>
                                                                        <td>#${order.poId}</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td><strong>Status:</strong></td>
                                                                        <td>${order.status}</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td><strong>Manager:</strong></td>
                                                                        <td>${order.managerName}</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td><strong>Order Date:</strong></td>
                                                                        <td>${order.orderDate}</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td><strong>Expected Delivery:</strong></td>
                                                                        <td>
                                                                            <c:choose>
                                                                                <c:when test="${not empty order.expectedDeliveryDate}">
                                                                                    ${order.expectedDeliveryDate}
                                                                                </c:when>
                                                                                <c:otherwise>N/A</c:otherwise>
                                                                            </c:choose>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                                <c:if test="${not empty order.notes}">
                                                                    <h6 class="mt-3"><i class="fas fa-sticky-note"></i> Notes</h6>
                                                                    <div class="alert alert-secondary">
                                                                        <small style="white-space: pre-wrap;">${order.notes}</small>
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <h6><i class="fas fa-pills"></i> Order Items</h6>
                                                                <c:set var="items" value="${poItemsMap[order.poId]}" />
                                                                <c:choose>
                                                                    <c:when test="${not empty items}">
                                                                        <ul class="item-list">
                                                                            <c:forEach items="${items}" var="item">
                                                                                <li>
                                                                                    <div>
                                                                                        <strong>${item.medicineName}</strong>
                                                                                        <br>
                                                                                        <small class="priority-${item.priority == 'High' ? 'high' : item.priority == 'Medium' ? 'medium' : 'low'}">
                                                                                            <i class="fas fa-flag"></i> Priority: ${item.priority}
                                                                                        </small>
                                                                                        <c:if test="${not empty item.notes}">
                                                                                            <br>
                                                                                            <small class="text-muted">
                                                                                                <i class="fas fa-comment"></i> ${item.notes}
                                                                                            </small>
                                                                                        </c:if>
                                                                                    </div>
                                                                                    <div class="text-end">
                                                                                        <span class="badge bg-primary fs-6">${item.quantity} units</span>
                                                                                    </div>
                                                                                </li>
                                                                            </c:forEach>
                                                                        </ul>
                                                                        <div class="mt-2 text-end">
                                                                            <strong>Total Items: ${items.size()}</strong>
                                                                        </div>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <div class="alert alert-warning">
                                                                            <i class="fas fa-exclamation-triangle"></i> No items found
                                                                        </div>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- Stock Alerts Card -->
        <div class="row mt-4">
            <div class="col-md-12">
                <div class="card dashboard-card">
                    <div class="card-body">
                        <h6 class="card-subtitle mb-2 text-muted">
                            <i class="fas fa-exclamation-triangle"></i> Stock Alerts
                        </h6>
                        <h2 class="card-title">${stockAlerts.size()}</h2>
                        <p class="card-text">Currently have ${stockAlerts.size()} medicines below stock threshold</p>
                        <a href="${pageContext.request.contextPath}/stock-alerts" class="btn btn-warning">
                            <i class="fas fa-eye"></i> View All Alerts
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-trash"></i> Delete Stock Request
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="manage-stock" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="poId" id="deletePoId">
                        <p>Are you sure you want to delete this stock request? This action cannot be undone.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-trash"></i> Delete
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Cancel Order Modal -->
    <div class="modal fade" id="cancelModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-warning text-dark">
                    <h5 class="modal-title">
                        <i class="fas fa-ban"></i> Cancel Stock Request
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="approve-stock" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="cancel">
                        <input type="hidden" name="poId" id="cancelPoId">
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle"></i> 
                            <strong>Warning:</strong> This will cancel the purchase order that has been sent to the supplier.
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Cancellation Reason <span class="text-danger">*</span></label>
                            <textarea class="form-control" name="reason" rows="3" 
                                      placeholder="Enter reason for cancellation (minimum 10 characters)..." 
                                      required minlength="10"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-warning">
                            <i class="fas fa-ban"></i> Cancel Order
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function toggleDetails(poId) {
            const detailsRow = document.getElementById('details-' + poId);
            if (detailsRow.style.display === 'none') {
                detailsRow.style.display = 'table-row';
            } else {
                detailsRow.style.display = 'none';
            }
        }

        function approveOrder(poId) {
            if (confirm('Send this purchase order to supplier?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'approve-stock';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'approve';
                
                const poIdInput = document.createElement('input');
                poIdInput.type = 'hidden';
                poIdInput.name = 'poId';
                poIdInput.value = poId;
                
                form.appendChild(actionInput);
                form.appendChild(poIdInput);
                document.body.appendChild(form);
                form.submit();
            }
        }

        function deleteOrder(poId) {
            document.getElementById('deletePoId').value = poId;
            const modal = new bootstrap.Modal(document.getElementById('deleteModal'));
            modal.show();
        }

        function cancelOrder(poId) {
            document.getElementById('cancelPoId').value = poId;
            const modal = new bootstrap.Modal(document.getElementById('cancelModal'));
            modal.show();
        }

        // Auto-dismiss alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert-dismissible');
            alerts.forEach(function(alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html>