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
        .alert-item {
            border-left: 4px solid;
            padding: 10px;
            margin-bottom: 10px;
            background: #f8f9fa;
        }
        .alert-critical { border-color: #dc3545; }
        .alert-high { border-color: #ffc107; }
        .alert-medium { border-color: #17a2b8; }
        .stat-card {
            text-align: center;
            padding: 20px;
            border-radius: 10px;
            color: white;
            margin-bottom: 20px;
        }
        .stat-card-blue { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .stat-card-green { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
        .stat-card-orange { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); }
        .modal-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
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
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <span class="nav-link">
                            <i class="fas fa-user"></i> ${manager.username}
                        </span>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="logout">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </a>
                    </li>
                </ul>
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
                    <p>Pending Requests</p>
                    <h5>${pendingRequests.size()} Orders</h5>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="row mt-4">
            <!-- Stock Alerts Section -->
            <div class="col-lg-6">
                <div class="card dashboard-card">
                    <div class="card-header bg-warning text-dark">
                        <h5 class="mb-0">
                            <i class="fas fa-bell"></i> Stock Alerts
                        </h5>
                    </div>
                    <div class="card-body" style="max-height: 400px; overflow-y: auto;">
                        <c:if test="${empty stockAlerts}">
                            <div class="alert alert-success">
                                <i class="fas fa-check-circle"></i> All stocks are at safe levels!
                            </div>
                        </c:if>
                        <c:forEach items="${stockAlerts}" var="alert">
                            <div class="alert-item alert-${alert.alertLevel.toLowerCase()}">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div>
                                        <h6 class="mb-1">
                                            <strong>${alert.medicineName}</strong>
                                            <span class="${alert.alertLevelBadgeClass}">${alert.alertLevel}</span>
                                        </h6>
                                        <small class="text-muted">
                                            <i class="fas fa-tag"></i> ${alert.category}
                                        </small>
                                        <br>
                                        <small>
                                            <i class="fas fa-boxes"></i> Current: ${alert.currentQuantity} units
                                            | Threshold: ${alert.threshold} units
                                        </small>
                                        <c:if test="${not empty alert.nearestExpiry}">
                                            <br>
                                            <small class="text-danger">
                                                <i class="fas fa-calendar-times"></i> 
                                                Nearest Expiry: ${alert.nearestExpiry}
                                            </small>
                                        </c:if>
                                    </div>
                                    <button class="btn btn-sm btn-primary" 
                                            onclick="quickOrder(${alert.medicineId}, '${alert.medicineName}')">
                                        <i class="fas fa-plus"></i> Order
                                    </button>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <!-- Pending Stock Requests Section -->
            <div class="col-lg-6">
                <div class="card dashboard-card">
                    <div class="card-header bg-primary text-white">
                        <div class="d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">
                                <i class="fas fa-clipboard-list"></i> Pending Stock Requests
                            </h5>
                            <a href="create-stock" class="btn btn-light btn-sm">
                                <i class="fas fa-plus"></i> New Request
                            </a>
                        </div>
                    </div>
                    <div class="card-body" style="max-height: 400px; overflow-y: auto;">
                        <c:if test="${empty pendingRequests}">
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle"></i> No pending requests at the moment.
                            </div>
                        </c:if>
                        <c:forEach items="${pendingRequests}" var="order">
                            <div class="card mb-3 border-start border-3 border-${order.status == 'Sent' ? 'warning' : 'secondary'}">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div class="flex-grow-1">
                                            <h6>
                                                PO #${order.poId}
                                                <span class="${order.statusBadgeClass}">${order.status}</span>
                                            </h6>
                                            <c:choose>
                                                <c:when test="${not empty order.supplierName}">
                                                    <p class="mb-1">
                                                        <i class="fas fa-truck"></i> 
                                                        <strong>Supplier:</strong> ${order.supplierName}
                                                    </p>
                                                </c:when>
                                                <c:otherwise>
                                                    <p class="mb-1">
                                                        <i class="fas fa-truck"></i> 
                                                        <strong>Supplier:</strong> <span class="text-muted">Not assigned yet</span>
                                                    </p>
                                                </c:otherwise>
                                            </c:choose>
                                            <small class="text-muted">
                                                <i class="fas fa-calendar"></i> Order Date: ${order.orderDate}
                                            </small>
                                            <c:if test="${not empty order.managerName}">
                                                <br>
                                                <small class="text-muted">
                                                    <i class="fas fa-user"></i> Manager: ${order.managerName}
                                                </small>
                                            </c:if>
                                            <c:if test="${not empty order.expectedDeliveryDate}">
                                                <br>
                                                <small class="text-info">
                                                    <i class="fas fa-shipping-fast"></i> 
                                                    Expected: ${order.expectedDeliveryDate}
                                                </small>
                                            </c:if>
                                        </div>
                                        <c:if test="${order.status == 'Sent'}">
                                            <div class="btn-group-vertical ms-2">
                                                <button class="btn btn-sm btn-success mb-1" 
                                                        onclick="approveOrder(${order.poId})">
                                                    <i class="fas fa-check"></i> Approve
                                                </button>
                                                <button class="btn btn-sm btn-danger" 
                                                        onclick="rejectOrder(${order.poId})">
                                                    <i class="fas fa-times"></i> Reject
                                                </button>
                                            </div>
                                        </c:if>
                                    </div>
                                    <c:if test="${not empty order.notes}">
                                        <div class="mt-2 p-2 bg-light rounded">
                                            <small><strong>Details:</strong></small>
                                            <pre class="mb-0" style="font-size: 11px; white-space: pre-wrap;">${order.notes}</pre>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="row mt-4">
            <div class="col-12">
                <div class="card dashboard-card">
                    <div class="card-header bg-dark text-white">
                        <h5 class="mb-0"><i class="fas fa-bolt"></i> Quick Actions</h5>
                    </div>
                    <div class="card-body">
                        <div class="row text-center">
                            <div class="col-md-3">
                                <a href="create-stock" class="btn btn-outline-primary btn-lg w-100">
                                    <i class="fas fa-plus-circle fa-2x d-block mb-2"></i>
                                    Create Stock Request
                                </a>
                            </div>
                            <div class="col-md-3">
                                <a href="view-inventory" class="btn btn-outline-info btn-lg w-100">
                                    <i class="fas fa-boxes fa-2x d-block mb-2"></i>
                                    View Inventory
                                </a>
                            </div>
                            <div class="col-md-3">
                                <a href="suppliers" class="btn btn-outline-success btn-lg w-100">
                                    <i class="fas fa-truck fa-2x d-block mb-2"></i>
                                    Manage Suppliers
                                </a>
                            </div>
                            <div class="col-md-3">
                                <a href="reports" class="btn btn-outline-warning btn-lg w-100">
                                    <i class="fas fa-chart-bar fa-2x d-block mb-2"></i>
                                    View Reports
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Reject Order Modal -->
    <div class="modal fade" id="rejectModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-times-circle"></i> Reject Stock Request
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="approve-stock" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="reject">
                        <input type="hidden" name="poId" id="rejectPoId">
                        <div class="mb-3">
                            <label class="form-label">Reason for Rejection:</label>
                            <textarea class="form-control" name="reason" rows="4" 
                                      placeholder="Enter reason for rejecting this request..." required></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-times"></i> Reject Request
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function approveOrder(poId) {
            if (confirm('Are you sure you want to approve this stock request?')) {
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

        function rejectOrder(poId) {
            document.getElementById('rejectPoId').value = poId;
            const modal = new bootstrap.Modal(document.getElementById('rejectModal'));
            modal.show();
        }

        function quickOrder(medicineId, medicineName) {
            alert('Quick order feature for: ' + medicineName + '\nRedirecting to create stock request...');
            window.location.href = 'create-stock';
        }
    </script>
</body>
</html>