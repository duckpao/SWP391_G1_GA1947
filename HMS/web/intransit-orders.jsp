<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>In Transit Orders - Manager</title>
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
                    <a href="${pageContext.request.contextPath}/manager/intransit-orders" class="nav-link active">
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
                    <h2><i class="bi bi-truck"></i> In Transit Orders</h2>
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
                    <div class="card-header bg-info text-white">
                        <i class="bi bi-truck"></i> Orders Being Shipped
                    </div>
                    <div class="card-body">
                        <c:if test="${empty inTransitOrders}">
                            <div class="alert alert-info">
                                <i class="bi bi-info-circle"></i> No orders in transit.
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty inTransitOrders}">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead class="table-light">
                                        <tr>
                                            <th>PO #</th>
                                            <th>Supplier</th>
                                            <th>Tracking</th>
                                            <th>Carrier</th>
                                            <th>ASN Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${inTransitOrders}" var="order">
                                            <tr>
                                                <td><strong>#${order.poId}</strong></td>
                                                <td>${order.supplierName}</td>
                                                <td>
                                                    <c:if test="${not empty order.trackingNumber}">
                                                        <code>${order.trackingNumber}</code>
                                                    </c:if>
                                                    <c:if test="${empty order.trackingNumber}">
                                                        <span class="text-muted">N/A</span>
                                                    </c:if>
                                                </td>
                                                <td>${order.carrier != null ? order.carrier : 'N/A'}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${order.asnStatus == 'Sent'}">
                                                            <span class="badge bg-info">
                                                                <i class="bi bi-send"></i> Shipped
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.asnStatus == 'InTransit'}">
                                                            <span class="badge bg-primary">
                                                                <i class="bi bi-truck"></i> In Transit
                                                            </span>
                                                        </c:when>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/manager/view-asn?poId=${order.poId}" 
                                                       class="btn btn-sm btn-outline-info">
                                                        <i class="bi bi-eye"></i> View ASN
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/manager/pay-invoice?poId=${order.poId}" 
                                                       class="btn btn-sm btn-success">
                                                        <i class="bi bi-cash"></i> Payment
                                                    </a>
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
</body>
</html>