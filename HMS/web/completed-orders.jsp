<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Completed Orders - Manager</title>
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
                    <a href="${pageContext.request.contextPath}/manager/sent-orders" class="nav-link">
                        <i class="bi bi-send-check"></i> Sent Orders
                    </a>
                    <a href="${pageContext.request.contextPath}/manager/intransit-orders" class="nav-link">
                        <i class="bi bi-truck"></i> In Transit
                    </a>
                    <a href="${pageContext.request.contextPath}/manager/completed-orders" class="nav-link active">
                        <i class="bi bi-check-circle"></i> Completed
                    </a>
                </div>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-10 p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2><i class="bi bi-check-circle-fill text-success"></i> Completed Orders</h2>
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
                    <div class="card-header bg-success text-white">
                        <i class="bi bi-check-circle"></i> Successfully Completed Orders
                    </div>
                    <div class="card-body">
                        <c:if test="${empty completedOrders}">
                            <div class="alert alert-info">
                                <i class="bi bi-info-circle"></i> No completed orders found.
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty completedOrders}">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead class="table-light">
                                        <tr>
                                            <th>PO #</th>
                                            <th>Supplier</th>
                                            <th>Order Date</th>
                                            <th>Completed Date</th>
                                            <th>Status</th>
                                            <th>Rating</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${completedOrders}" var="order">
                                            <tr>
                                                <td><strong>#${order.poId}</strong></td>
                                                <td>${order.supplierName}</td>
                                                <td>${order.orderDate}</td>
                                                <td>${order.updatedAt}</td>
                                                <td>
                                                    <span class="badge bg-success">
                                                        <i class="bi bi-check-circle"></i> ${order.status}
                                                    </span>
                                                </td>
                                                <td>
                                                    <c:set var="isRated" value="${ratedMap[order.poId]}" />
                                                    <c:set var="ratingValue" value="${ratingValueMap[order.poId]}" />
                                                    
                                                    <c:choose>
                                                        <c:when test="${isRated}">
                                                            <div class="text-warning">
                                                                <c:forEach begin="1" end="${ratingValue}">
                                                                    <i class="bi bi-star-fill"></i>
                                                                </c:forEach>
                                                                <c:forEach begin="${ratingValue + 1}" end="5">
                                                                    <i class="bi bi-star"></i>
                                                                </c:forEach>
                                                                <br>
                                                                <small class="badge bg-info">Rated</small>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="${pageContext.request.contextPath}/manager/rate-supplier?poId=${order.poId}" 
                                                               class="btn btn-sm btn-warning">
                                                                <i class="bi bi-star"></i> Rate Now
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <button class="btn btn-sm btn-info" onclick="toggleDetails(${order.poId})">
                                                        <i class="bi bi-eye"></i> View Full Details
                                                    </button>
                                                </td>
                                            </tr>
                                            
                                            <!-- Full Details Row -->
                                            <tr id="details-${order.poId}" style="display: none;">
                                                <td colspan="7" class="bg-light">
                                                    <div class="p-4">
                                                        <h5 class="mb-3">
                                                            <i class="bi bi-file-earmark-text"></i> Complete Order Information - PO #${order.poId}
                                                        </h5>
                                                        
                                                        <div class="row">
                                                            <!-- Left Column: PO Info -->
                                                            <div class="col-md-6">
                                                                <div class="card mb-3">
                                                                    <div class="card-header bg-primary text-white">
                                                                        <i class="bi bi-info-circle"></i> Purchase Order Details
                                                                    </div>
                                                                    <div class="card-body">
                                                                        <table class="table table-sm table-borderless">
                                                                            <tr>
                                                                                <td><strong>PO ID:</strong></td>
                                                                                <td>#${order.poId}</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td><strong>Status:</strong></td>
                                                                                <td><span class="badge bg-success">${order.status}</span></td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td><strong>Supplier:</strong></td>
                                                                                <td>${order.supplierName}</td>
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
                                                                                <td>${order.expectedDeliveryDate}</td>
                                                                            </tr>
                                                                            <tr>
                                                                                <td><strong>Completed Date:</strong></td>
                                                                                <td>${order.updatedAt}</td>
                                                                            </tr>
                                                                        </table>
                                                                        
                                                                        <c:if test="${not empty order.notes}">
                                                                            <div class="alert alert-info mb-0">
                                                                                <strong><i class="bi bi-sticky"></i> Notes:</strong><br>
                                                                                ${order.notes}
                                                                            </div>
                                                                        </c:if>
                                                                    </div>
                                                                </div>
                                                                
                                                                <!-- ASN Info (if exists) -->
                                                                <c:if test="${order.hasAsn}">
                                                                    <div class="card">
                                                                        <div class="card-header bg-info text-white">
                                                                            <i class="bi bi-truck"></i> Shipping Information (ASN)
                                                                        </div>
                                                                        <div class="card-body">
                                                                            <table class="table table-sm table-borderless">
                                                                                <tr>
                                                                                    <td><strong>Tracking Number:</strong></td>
                                                                                    <td><code>${order.trackingNumber}</code></td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td><strong>Carrier:</strong></td>
                                                                                    <td>${order.carrier}</td>
                                                                                </tr>
                                                                                <tr>
                                                                                    <td><strong>ASN Status:</strong></td>
                                                                                    <td><span class="badge bg-success">${order.asnStatus}</span></td>
                                                                                </tr>
                                                                            </table>
                                                                            
                                                                            <a href="${pageContext.request.contextPath}/manager/view-asn?poId=${order.poId}" 
                                                                               class="btn btn-sm btn-outline-info">
                                                                                <i class="bi bi-eye"></i> View Full ASN Details
                                                                            </a>
                                                                        </div>
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                            
                                                            <!-- Right Column: Order Items -->
                                                            <div class="col-md-6">
                                                                <div class="card">
                                                                    <div class="card-header bg-warning">
                                                                        <i class="bi bi-capsule"></i> Order Items
                                                                    </div>
                                                                    <div class="card-body">
                                                                        <c:set var="items" value="${poItemsMap[order.poId]}" />
                                                                        <c:if test="${empty items}">
                                                                            <p class="text-muted">No items found</p>
                                                                        </c:if>
                                                                        
                                                                        <c:if test="${not empty items}">
                                                                            <ul class="list-group mb-3">
                                                                                <c:forEach items="${items}" var="item">
                                                                                    <li class="list-group-item">
                                                                                        <div class="d-flex justify-content-between align-items-start">
                                                                                            <div>
                                                                                                <h6 class="mb-1">${item.medicineName}</h6>
                                                                                                <c:if test="${not empty item.medicineStrength}">
                                                                                                    <span class="badge bg-primary">${item.medicineStrength}</span>
                                                                                                </c:if>
                                                                                                <br>
                                                                                                <small class="text-muted">
                                                                                                    <i class="bi bi-upc"></i> ${item.medicineCode}<br>
                                                                                                    <i class="bi bi-capsule"></i> ${item.medicineDosageForm}<br>
                                                                                                    <i class="bi bi-building"></i> ${item.medicineManufacturer}
                                                                                                </small>
                                                                                                <c:if test="${not empty item.unitPrice && item.unitPrice > 0}">
                                                                                                    <br>
                                                                                                    <small class="text-success">
                                                                                                        <i class="bi bi-cash"></i> ${item.unitPrice} VNĐ/unit
                                                                                                    </small>
                                                                                                </c:if>
                                                                                            </div>
                                                                                            <div class="text-end">
                                                                                                <span class="badge bg-success fs-6">${item.quantity} units</span>
                                                                                                <c:if test="${not empty item.unitPrice && item.unitPrice > 0}">
                                                                                                    <br>
                                                                                                    <small class="text-success">
                                                                                                        <strong>${item.quantity * item.unitPrice} VNĐ</strong>
                                                                                                    </small>
                                                                                                </c:if>
                                                                                            </div>
                                                                                        </div>
                                                                                    </li>
                                                                                </c:forEach>
                                                                            </ul>
                                                                            
                                                                            <div class="alert alert-success">
                                                                                <div class="d-flex justify-content-between">
                                                                                    <strong><i class="bi bi-box-seam"></i> Total Items:</strong>
                                                                                    <span>${items.size()}</span>
                                                                                </div>
                                                                                <c:set var="totalQty" value="0" />
                                                                                <c:forEach items="${items}" var="item">
                                                                                    <c:set var="totalQty" value="${totalQty + item.quantity}" />
                                                                                </c:forEach>
                                                                                <div class="d-flex justify-content-between">
                                                                                    <strong><i class="bi bi-boxes"></i> Total Quantity:</strong>
                                                                                    <span>${totalQty} units</span>
                                                                                </div>
                                                                            </div>
                                                                        </c:if>
                                                                    </div>
                                                                </div>
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