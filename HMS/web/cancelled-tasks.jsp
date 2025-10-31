<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cancelled Tasks - Hospital System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .dashboard-card {
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .status-cancelled {
            background-color: #6c757d;
            color: white;
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 12px;
            font-weight: bold;
        }
        .details-row {
            background-color: #f8f9fa;
            border-left: 3px solid #dc3545;
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
            padding: 15px;
            border-bottom: 1px solid #dee2e6;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            background: white;
            margin-bottom: 10px;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        .item-list li:last-child {
            border-bottom: none;
        }
        .medicine-main-info {
            font-size: 1.1rem;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 8px;
        }
        .medicine-detail-row {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-top: 8px;
        }
        .medicine-detail-item {
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 0.9rem;
            color: #6c757d;
        }
        .medicine-detail-item i {
            width: 16px;
            color: #dc3545;
        }
        .medicine-code-badge {
            background: #e9ecef;
            padding: 3px 8px;
            border-radius: 4px;
            font-family: monospace;
            font-size: 0.85rem;
        }
        .quantity-badge {
            font-size: 1.1rem;
            padding: 8px 16px;
        }
        .priority-high { color: #dc3545; font-weight: bold; }
        .priority-medium { color: #ffc107; font-weight: bold; }
        .priority-low { color: #17a2b8; font-weight: bold; }
        .priority-critical { 
            color: #fff; 
            background: #dc3545; 
            padding: 3px 8px; 
            border-radius: 4px;
            font-weight: bold;
        }
        .cancellation-reason {
            background: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 12px;
            margin-top: 10px;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="manager-dashboard">
                <i class="fas fa-hospital"></i> Hospital Manager
            </a>
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="manager-dashboard">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </a>
                </li>
            </ul>
        </div>
    </nav>

    <div class="container mt-4">
        <!-- Page Header -->
        <div class="row mb-4">
            <div class="col-12">
                <h2><i class="fas fa-ban text-danger"></i> Cancelled Stock Requests</h2>
                <p class="text-muted">View all cancelled purchase orders and their details</p>
            </div>
        </div>

        <!-- Cancelled Orders List -->
        <div class="row">
            <div class="col-12">
                <div class="card dashboard-card">
                    <div class="card-header bg-danger text-white">
                        <h5 class="mb-0">
                            <i class="fas fa-times-circle"></i> Cancelled Orders
                        </h5>
                    </div>
                    <div class="card-body">
                        <c:if test="${empty cancelledOrders}">
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle"></i> No cancelled orders found.
                            </div>
                        </c:if>

                        <c:if test="${not empty cancelledOrders}">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th width="80">PO #</th>
                                            <th width="100">Status</th>
                                            <th>Supplier</th>
                                            <th>Order Date</th>
                                            <th>Cancelled Date</th>
                                            <th>Manager</th>
                                            <th width="150">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${cancelledOrders}" var="order">
                                            <tr>
                                                <td><strong>#${order.poId}</strong></td>
                                                <td>
                                                    <span class="status-cancelled">Cancelled</span>
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
                                                <td>${order.updatedAt}</td>
                                                <td>${order.managerName}</td>
                                                <td>
                                                    <button class="btn btn-info btn-sm" 
                                                            onclick="toggleDetails(${order.poId})" 
                                                            title="View Details">
                                                        <i class="fas fa-eye"></i> Details
                                                    </button>
                                                </td>
                                            </tr>
                                            <!-- Details Row -->
                                            <tr id="details-${order.poId}" class="details-row" style="display: none;">
                                                <td colspan="7">
                                                    <div class="details-content">
                                                        <div class="row">
                                                            <div class="col-md-5">
                                                                <h6><i class="fas fa-info-circle"></i> General Information</h6>
                                                                <table class="table table-sm table-borderless">
                                                                    <tr>
                                                                        <td width="150"><strong>PO ID:</strong></td>
                                                                        <td>#${order.poId}</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td><strong>Status:</strong></td>
                                                                        <td><span class="status-cancelled">Cancelled</span></td>
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
                                                                        <td><strong>Cancelled Date:</strong></td>
                                                                        <td>${order.updatedAt}</td>
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
                                                                
                                                                <!-- Cancellation Reason -->
                                                                <c:if test="${not empty order.notes}">
                                                                    <h6 class="mt-3"><i class="fas fa-exclamation-triangle"></i> Cancellation Reason</h6>
                                                                    <div class="cancellation-reason">
                                                                        <strong>Reason:</strong><br>
                                                                        <span style="white-space: pre-wrap;">${order.notes}</span>
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                            
                                                            <div class="col-md-7">
                                                                <h6><i class="fas fa-pills"></i> Order Items</h6>
                                                                <c:set var="items" value="${poItemsMap[order.poId]}" />
                                                                <c:choose>
                                                                    <c:when test="${not empty items}">
                                                                        <ul class="item-list">
                                                                            <c:forEach items="${items}" var="item">
                                                                                <li>
                                                                                    <div style="flex: 1;">
                                                                                        <!-- Medicine Name & Code -->
                                                                                        <div class="medicine-main-info">
                                                                                            ${item.medicineName}
                                                                                            <c:if test="${not empty item.medicineStrength}">
                                                                                                <span class="text-danger">${item.medicineStrength}</span>
                                                                                            </c:if>
                                                                                            <span class="medicine-code-badge">${item.medicineCode}</span>
                                                                                        </div>
                                                                                        
                                                                                        <!-- Medicine Details -->
                                                                                        <div class="medicine-detail-row">
                                                                                            <c:if test="${not empty item.medicineDosageForm}">
                                                                                                <div class="medicine-detail-item">
                                                                                                    <i class="fas fa-pills"></i>
                                                                                                    <span>${item.medicineDosageForm}</span>
                                                                                                </div>
                                                                                            </c:if>
                                                                                            <c:if test="${not empty item.medicineCategory}">
                                                                                                <div class="medicine-detail-item">
                                                                                                    <i class="fas fa-tag"></i>
                                                                                                    <span>${item.medicineCategory}</span>
                                                                                                </div>
                                                                                            </c:if>
                                                                                            <c:if test="${not empty item.medicineManufacturer}">
                                                                                                <div class="medicine-detail-item">
                                                                                                    <i class="fas fa-industry"></i>
                                                                                                    <span>${item.medicineManufacturer}</span>
                                                                                                </div>
                                                                                            </c:if>
                                                                                        </div>
                                                                                        
                                                                                        <!-- Priority -->
                                                                                        <div class="mt-2">
                                                                                            <small class="priority-${item.priority == 'High' || item.priority == 'Critical' ? 'high' : item.priority == 'Medium' ? 'medium' : 'low'}">
                                                                                                <i class="fas fa-flag"></i> Priority: ${item.priority}
                                                                                            </small>
                                                                                        </div>
                                                                                        
                                                                                        <!-- Item Notes -->
                                                                                        <c:if test="${not empty item.notes}">
                                                                                            <div class="mt-2">
                                                                                                <small class="text-muted">
                                                                                                    <i class="fas fa-comment"></i> ${item.notes}
                                                                                                </small>
                                                                                            </div>
                                                                                        </c:if>
                                                                                    </div>
                                                                                    <div class="text-end ms-3">
                                                                                        <span class="badge bg-secondary quantity-badge">${item.quantity} units</span>
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
    </script>
</body>
</html>