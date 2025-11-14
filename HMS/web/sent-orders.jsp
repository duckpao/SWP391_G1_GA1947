<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sent Orders - Manager</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
    <%@ include file="/admin/header.jsp" %>
    
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 bg-light vh-100">
                <div class="sidebar p-3">
                    <h5><i class="bi bi-hospital"></i> Manager</h5>
                    <hr>
                    <a href="${pageContext.request.contextPath}/manager-dashboard" class="nav-link">
                        <i class="bi bi-speedometer2"></i> Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/create-stock" class="nav-link">
                        <i class="bi bi-plus-circle"></i> New Stock Request
                    </a>
                    <hr>
                    <h6 class="text-muted">ORDER HISTORY</h6>
                    <a href="${pageContext.request.contextPath}/manager/sent-orders" class="nav-link active">
                        <i class="bi bi-send-check"></i> Sent Orders
                    </a>
                    <a href="${pageContext.request.contextPath}/manager/intransit-orders" class="nav-link">
                        <i class="bi bi-truck"></i> In Transit
                    </a>
                    <a href="${pageContext.request.contextPath}/manager/completed-orders" class="nav-link">
                        <i class="bi bi-check-circle"></i> Completed
                    </a>
                </div>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-10 p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2><i class="bi bi-send-check"></i> Sent Orders</h2>
                    <a href="${pageContext.request.contextPath}/manager-dashboard" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> Back to Dashboard
                    </a>
                </div>
                
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show">
                        <i class="bi bi-exclamation-circle"></i> ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <i class="bi bi-list-ul"></i> Orders Sent to Suppliers
                    </div>
                    <div class="card-body">
                        <c:if test="${empty sentOrders}">
                            <div class="alert alert-info">
                                <i class="bi bi-info-circle"></i> No sent orders found.
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty sentOrders}">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead class="table-light">
                                        <tr>
                                            <th>PO #</th>
                                            <th>Supplier</th>
                                            <th>Order Date</th>
                                            <th>Expected Delivery</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${sentOrders}" var="order">
                                            <tr>
                                                <td><strong>#${order.poId}</strong></td>
                                                <td>${order.supplierName}</td>
                                                <td>${order.orderDate}</td>
                                                <td>${order.expectedDeliveryDate != null ? order.expectedDeliveryDate : 'N/A'}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${order.status == 'Sent'}">
                                                            <span class="badge bg-warning">
                                                                <i class="bi bi-clock"></i> Pending
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.status == 'Approved'}">
                                                            <span class="badge bg-success">
                                                                <i class="bi bi-check-circle"></i> Approved
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.status == 'Rejected'}">
                                                            <span class="badge bg-danger">
                                                                <i class="bi bi-x-circle"></i> Rejected
                                                            </span>
                                                        </c:when>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <button class="btn btn-sm btn-info" onclick="toggleDetails(${order.poId})">
                                                        <i class="bi bi-eye"></i> View Details
                                                    </button>
                                                </td>
                                            </tr>
                                            
                                            <!-- Details Row -->
                                            <tr id="details-${order.poId}" style="display: none;">
                                                <td colspan="6" class="bg-light">
                                                    <div class="p-3">
                                                        <h6><i class="bi bi-info-circle"></i> Order Information</h6>
                                                        <div class="row">
                                                            <div class="col-md-6">
                                                                <table class="table table-sm table-borderless">
                                                                    <tr>
                                                                        <td><strong>PO ID:</strong></td>
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
                                                                </table>
                                                                
                                                                <c:if test="${order.status == 'Rejected'}">
                                                                    <div class="alert alert-danger">
                                                                        <strong><i class="bi bi-exclamation-triangle"></i> Rejection Reason:</strong><br>
                                                                        ${order.notes}
                                                                    </div>
                                                                </c:if>
                                                                
                                                                <c:if test="${not empty order.notes && order.status != 'Rejected'}">
                                                                    <div class="alert alert-info">
                                                                        <strong><i class="bi bi-sticky"></i> Notes:</strong><br>
                                                                        ${order.notes}
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                            
                                                            <div class="col-md-6">
                                                                <h6><i class="bi bi-capsule"></i> Order Items</h6>
                                                                <c:set var="items" value="${poItemsMap[order.poId]}" />
                                                                <c:if test="${empty items}">
                                                                    <p class="text-muted">No items found</p>
                                                                </c:if>
                                                                <c:if test="${not empty items}">
                                                                    <ul class="list-group">
                                                                        <c:forEach items="${items}" var="item">
                                                                            <li class="list-group-item">
                                                                                <div class="d-flex justify-content-between">
                                                                                    <div>
                                                                                        <strong>${item.medicineName}</strong>
                                                                                        <c:if test="${not empty item.medicineStrength}">
                                                                                            <span class="text-primary">${item.medicineStrength}</span>
                                                                                        </c:if>
                                                                                        <br>
                                                                                        <small class="text-muted">
                                                                                            ${item.medicineCode} | ${item.medicineDosageForm}
                                                                                        </small>
                                                                                    </div>
                                                                                    <div class="text-end">
                                                                                        <span class="badge bg-primary">${item.quantity} units</span>
                                                                                    </div>
                                                                                </div>
                                                                            </li>
                                                                        </c:forEach>
                                                                    </ul>
                                                                    
                                                                    <div class="mt-2">
                                                                        <strong>Total Items:</strong> ${items.size()}
                                                                    </div>
                                                                </c:if>
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