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
    <style>
        .status-cancelled { background-color: #6c757d; color: white; }
        .dashboard-card {
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
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
    </style>
</head>
<body>
    <div class="container mt-4">
        <h2><i class="fas fa-ban"></i> Cancelled Tasks</h2>
        <div class="card dashboard-card">
            <div class="card-body">
                <c:if test="${empty cancelledOrders}">
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle"></i> No cancelled tasks at the moment.
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
                                    <th>Expected Delivery</th>
                                    <th>Manager</th>
                                    <th width="200">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${cancelledOrders}" var="order">
                                    <tr>
                                        <td><strong>#${order.poId}</strong></td>
                                        <td><span class="status-badge status-cancelled">Cancelled</span></td>
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