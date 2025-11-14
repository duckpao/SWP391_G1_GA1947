<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Completed Orders - Manager</title>
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
        /* Card styling */
        .dashboard-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            margin-bottom: 30px;
            overflow: hidden;
            border-top: 3px solid #10b981;
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
            vertical-align: middle;
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
        .status-completed {
            background: #dcfce7;
            color: #166534;
        }
        .status-rated {
            background: #dbeafe;
            color: #1e40af;
        }
        .rating-stars {
            color: #f59e0b;
            font-size: 14px;
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
            margin-right: 4px;
        }
        .btn-info {
            background: #3b82f6;
            color: white;
        }
        .btn-info:hover {
            background: #2563eb;
        }
        .btn-warning {
            background: #f59e0b;
            color: white;
        }
        .btn-warning:hover {
            background: #d97706;
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
        /* Details Section */
        .details-row {
            background: #f9fafb;
        }
        .details-content {
            padding: 24px;
        }
        .details-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            border: 1px solid #e5e7eb;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }
        .details-card-header {
            font-size: 16px;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
            padding-bottom: 12px;
            border-bottom: 2px solid #e5e7eb;
        }
        .details-table {
            width: 100%;
            font-size: 14px;
        }
        .details-table tr {
            border-bottom: 1px solid #f3f4f6;
        }
        .details-table td {
            padding: 10px 0;
        }
        .details-table td:first-child {
            font-weight: 600;
            color: #374151;
            width: 180px;
        }
        .item-card {
            padding: 16px;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            margin-bottom: 12px;
            background: white;
            transition: all 0.3s ease;
        }
        .item-card:hover {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            border-color: #3b82f6;
        }
        .tracking-code {
            font-family: 'Courier New', monospace;
            background: #f3f4f6;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            color: #374151;
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
            .details-content {
                padding: 16px;
            }
            table {
                font-size: 12px;
            }
            table th,
            table td {
                padding: 12px 8px;
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
                    <a class="nav-link" href="${pageContext.request.contextPath}/manage/transit">
                    <i class="bi bi-truck"></i> Transit Orders
                </a>

<a class="nav-link active" href="${pageContext.request.contextPath}/manager/completed-orders">
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
            <!-- Message Alerts -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">
                    <i class="bi bi-exclamation-circle"></i>
                    ${errorMessage}
                </div>
            </c:if>
            
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">
                    <i class="bi bi-check-circle"></i>
                    ${successMessage}
                </div>
            </c:if>
            
            <c:if test="${not empty message}">
                <div class="alert alert-${messageType == 'success' ? 'success' : 'danger'}">
                    <i class="bi bi-${messageType == 'success' ? 'check-circle' : 'exclamation-circle'}"></i>
                    ${message}
                </div>
            </c:if>

            <!-- Completed Orders Section -->
            <div class="dashboard-card">
                <div class="card-header">
                    <h5><i class="bi bi-check-circle-fill" style="color: #10b981;"></i> Completed Orders</h5>
                </div>
                <div class="card-body">
                    <c:if test="${empty completedOrders}">
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle"></i> No completed orders found.
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty completedOrders}">
                        <div class="table-responsive">
                            <table>
                                <thead>
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
                                                <span class="status-badge status-completed">
                                                    <i class="bi bi-check-circle"></i> ${order.status}
                                                </span>
                                            </td>
                                            <td>
                                                <c:set var="isRated" value="${ratedMap[order.poId]}" />
                                                <c:set var="ratingValue" value="${ratingValueMap[order.poId]}" />
                                                
                                                <c:choose>
                                                    <c:when test="${isRated}">
                                                        <div>
                                                            <div class="rating-stars">
                                                                <c:forEach begin="1" end="${ratingValue}">
                                                                    <i class="bi bi-star-fill"></i>
                                                                </c:forEach>
                                                                <c:forEach begin="${ratingValue + 1}" end="5">
                                                                    <i class="bi bi-star"></i>
                                                                </c:forEach>
                                                            </div>
                                                            <span class="status-badge status-rated" style="font-size: 10px; padding: 4px 8px; margin-top: 4px;">Rated</span>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button onclick="openRatingModal(${order.poId}, '${order.supplierName}')" 
                                                                class="btn btn-warning" style="padding: 6px 12px; font-size: 12px;">
                                                            <i class="bi bi-star"></i> Rate Now
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <button class="btn btn-info" onclick="toggleDetails(${order.poId})">
                                                    <i class="bi bi-eye"></i> Details
                                                </button>
                                            </td>
                                        </tr>
                                        
                                        <!-- Full Details Row -->
                                        <tr id="details-${order.poId}" class="details-row" style="display: none;">
                                            <td colspan="7">
                                                <div class="details-content">
                                                    <h5 style="font-size: 18px; font-weight: 700; color: #1f2937; margin-bottom: 20px;">
                                                        <i class="bi bi-file-earmark-text"></i> Complete Order Information - PO #${order.poId}
                                                    </h5>
                                                    
                                                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                                                        <!-- Left Column: PO & ASN Info -->
                                                        <div>
                                                            <!-- PO Details -->
                                                            <div class="details-card">
                                                                <div class="details-card-header">
                                                                    <i class="bi bi-info-circle" style="color: #3b82f6;"></i>
                                                                    Purchase Order Details
                                                                </div>
                                                                <table class="details-table">
                                                                    <tr>
                                                                        <td>PO ID:</td>
                                                                        <td><strong>#${order.poId}</strong></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>Status:</td>
                                                                        <td><span class="status-badge status-completed">${order.status}</span></td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>Supplier:</td>
                                                                        <td>${order.supplierName}</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>Manager:</td>
                                                                        <td>${order.managerName}</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>Order Date:</td>
                                                                        <td>${order.orderDate}</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>Expected Delivery:</td>
                                                                        <td>${order.expectedDeliveryDate}</td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td>Completed Date:</td>
                                                                        <td><strong style="color: #10b981;">${order.updatedAt}</strong></td>
                                                                    </tr>
                                                                </table>
                                                                
                                                                <c:if test="${not empty order.notes}">
                                                                    <div class="alert alert-info" style="margin-top: 16px; margin-bottom: 0;">
                                                                        <strong><i class="bi bi-sticky"></i> Notes:</strong><br>
                                                                        <span style="white-space: pre-wrap;">${order.notes}</span>
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                            
                                                            <!-- ASN Info -->
                                                            <c:if test="${order.hasAsn}">
                                                                <div class="details-card">
                                                                    <div class="details-card-header">
                                                                        <i class="bi bi-truck" style="color: #3b82f6;"></i>
                                                                        Shipping Information (ASN)
                                                                    </div>
                                                                    <table class="details-table">
                                                                        <tr>
                                                                            <td>Tracking Number:</td>
                                                                            <td><span class="tracking-code">${order.trackingNumber}</span></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>Carrier:</td>
                                                                            <td>${order.carrier}</td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>ASN Status:</td>
                                                                            <td><span class="status-badge status-completed">${order.asnStatus}</span></td>
                                                                        </tr>
                                                                    </table>
                                                                    
                                                                    <a href="${pageContext.request.contextPath}/manager/view-asn?poId=${order.poId}" 
                                                                       class="btn btn-info" style="margin-top: 12px;">
                                                                        <i class="bi bi-eye"></i> View Full ASN Details
                                                                    </a>
                                                                </div>
                                                            </c:if>
                                                        </div>
                                                        
                                                        <!-- Right Column: Order Items -->
                                                        <div>
                                                            <div class="details-card">
                                                                <div class="details-card-header">
                                                                    <i class="bi bi-capsule" style="color: #f59e0b;"></i>
                                                                    Order Items
                                                                </div>
                                                                
                                                                <c:set var="items" value="${poItemsMap[order.poId]}" />
                                                                <c:if test="${empty items}">
                                                                    <p style="color: #9ca3af;">No items found</p>
                                                                </c:if>
                                                                
                                                                <c:if test="${not empty items}">
                                                                    <div style="max-height: 600px; overflow-y: auto;">
                                                                        <c:forEach items="${items}" var="item">
                                                                            <div class="item-card">
                                                                                <div style="display: flex; justify-content: space-between; align-items: start;">
                                                                                    <div style="flex: 1;">
                                                                                        <div style="font-size: 15px; font-weight: 600; color: #1f2937; margin-bottom: 8px;">
                                                                                            ${item.medicineName}
                                                                                            <c:if test="${not empty item.medicineStrength}">
                                                                                                <span style="color: #3b82f6; font-weight: 600;">${item.medicineStrength}</span>
                                                                                            </c:if>
                                                                                        </div>
                                                                                        <div style="display: flex; flex-direction: column; gap: 4px; font-size: 13px; color: #6b7280;">
                                                                                            <div><i class="bi bi-upc"></i> ${item.medicineCode}</div>
                                                                                            <div><i class="bi bi-capsule"></i> ${item.medicineDosageForm}</div>
                                                                                            <c:if test="${not empty item.medicineManufacturer}">
                                                                                                <div><i class="bi bi-building"></i> ${item.medicineManufacturer}</div>
                                                                                            </c:if>
                                                                                            <c:if test="${not empty item.unitPrice && item.unitPrice > 0}">
                                                                                                <div style="color: #10b981; font-weight: 600;">
                                                                                                    <i class="bi bi-cash"></i> ${item.unitPrice} VNĐ/unit
                                                                                                </div>
                                                                                            </c:if>
                                                                                        </div>
                                                                                    </div>
                                                                                    <div style="text-align: right;">
                                                                                        <div style="background: #10b981; color: white; padding: 8px 14px; border-radius: 6px; font-weight: 600; font-size: 14px;">
                                                                                            ${item.quantity} units
                                                                                        </div>
                                                                                        <c:if test="${not empty item.unitPrice && item.unitPrice > 0}">
                                                                                            <div style="margin-top: 8px; color: #10b981; font-weight: 600; font-size: 13px;">
                                                                                                ${item.quantity * item.unitPrice} VNĐ
                                                                                            </div>
                                                                                        </c:if>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                        </c:forEach>
                                                                    </div>
                                                                    
                                                                    <div style="margin-top: 16px; padding: 12px; background: #dcfce7; border-radius: 8px; border: 1px solid #86efac;">
                                                                        <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                                                                            <strong style="color: #166534;"><i class="bi bi-box-seam"></i> Total Items:</strong>
                                                                            <span style="color: #166534; font-weight: 600;">${items.size()}</span>
                                                                        </div>
                                                                        <c:set var="totalQty" value="0" />
                                                                        <c:forEach items="${items}" var="item">
                                                                            <c:set var="totalQty" value="${totalQty + item.quantity}" />
                                                                        </c:forEach>
                                                                        <div style="display: flex; justify-content: space-between;">
                                                                            <strong style="color: #166534;"><i class="bi bi-boxes"></i> Total Quantity:</strong>
                                                                            <span style="color: #166534; font-weight: 600;">${totalQty} units</span>
                                                                        </div>
                                                                    </div>
                                                                </c:if>
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
    
    <!-- Rating Modal -->
    <div id="ratingModal" class="modal">
        <div class="modal-content" style="max-width: 500px;">
            <div class="modal-header" style="background: #f59e0b; border-bottom: 1px solid #d97706;">
                <h5 style="color: white;"><i class="bi bi-star-fill"></i> Rate Supplier</h5>
                <button class="close-btn" onclick="closeRatingModal()" style="color: white;">&times;</button>
            </div>
            <form id="ratingForm" method="POST" action="${pageContext.request.contextPath}/manager/rate-supplier">
                <div class="modal-body">
                    <input type="hidden" name="poId" id="ratingPoId">
                    
                    <div style="text-align: center; margin-bottom: 24px;">
                        <h6 style="color: #374151; margin-bottom: 8px;">Rate your experience with</h6>
                        <h4 id="supplierNameDisplay" style="color: #1f2937; margin: 0;"></h4>
                    </div>
                    
                    <!-- Star Rating -->
                    <div style="margin-bottom: 24px;">
                        <label style="display: block; font-weight: 600; color: #374151; margin-bottom: 12px;">
                            Rating <span style="color: #ef4444;">*</span>
                        </label>
                        <div style="text-align: center;">
                            <div class="star-rating" id="starRating">
                                <i class="bi bi-star star" data-rating="1"></i>
                                <i class="bi bi-star star" data-rating="2"></i>
                                <i class="bi bi-star star" data-rating="3"></i>
                                <i class="bi bi-star star" data-rating="4"></i>
                                <i class="bi bi-star star" data-rating="5"></i>
                            </div>
                            <input type="hidden" name="rating" id="ratingValue" required>
                            <p id="ratingText" style="margin-top: 12px; color: #6b7280; font-size: 14px; font-weight: 600;"></p>
                        </div>
                    </div>
                    
                    <!-- Quality Rating -->
                    <div style="margin-bottom: 20px;">
                        <label style="display: block; font-weight: 600; color: #374151; margin-bottom: 8px;">
                            <i class="bi bi-clipboard-check"></i> Product Quality <span style="color: #ef4444;">*</span>
                        </label>
                        <select name="qualityRating" required style="width: 100%; padding: 10px; border: 1px solid #e5e7eb; border-radius: 8px; font-size: 14px;">
                            <option value="">Select quality rating</option>
                            <option value="5">Excellent - Exceeded expectations</option>
                            <option value="4">Good - Met expectations</option>
                            <option value="3">Average - Acceptable</option>
                            <option value="2">Below Average - Needs improvement</option>
                            <option value="1">Poor - Unacceptable</option>
                        </select>
                    </div>
                    
                    <!-- Delivery Rating -->
                    <div style="margin-bottom: 20px;">
                        <label style="display: block; font-weight: 600; color: #374151; margin-bottom: 8px;">
                            <i class="bi bi-truck"></i> Delivery Performance <span style="color: #ef4444;">*</span>
                        </label>
                        <select name="deliveryRating" required style="width: 100%; padding: 10px; border: 1px solid #e5e7eb; border-radius: 8px; font-size: 14px;">
                            <option value="">Select delivery rating</option>
                            <option value="5">Excellent - Early/On-time delivery</option>
                            <option value="4">Good - Minor delays</option>
                            <option value="3">Average - Moderate delays</option>
                            <option value="2">Below Average - Significant delays</option>
                            <option value="1">Poor - Very late delivery</option>
                        </select>
                    </div>
                    
                    <!-- Communication Rating -->
                    <div style="margin-bottom: 20px;">
                        <label style="display: block; font-weight: 600; color: #374151; margin-bottom: 8px;">
                            <i class="bi bi-chat-dots"></i> Communication <span style="color: #ef4444;">*</span>
                        </label>
                        <select name="communicationRating" required style="width: 100%; padding: 10px; border: 1px solid #e5e7eb; border-radius: 8px; font-size: 14px;">
                            <option value="">Select communication rating</option>
                            <option value="5">Excellent - Very responsive</option>
                            <option value="4">Good - Responsive</option>
                            <option value="3">Average - Acceptable response time</option>
                            <option value="2">Below Average - Slow response</option>
                            <option value="1">Poor - Unresponsive</option>
                        </select>
                    </div>
                    
                    <!-- Comments -->
                    <div style="margin-bottom: 20px;">
                        <label style="display: block; font-weight: 600; color: #374151; margin-bottom: 8px;">
                            <i class="bi bi-chat-left-text"></i> Comments
                        </label>
                        <textarea name="comments" rows="4" 
                                  style="width: 100%; padding: 10px; border: 1px solid #e5e7eb; border-radius: 8px; font-family: inherit; font-size: 14px; resize: vertical;"
                                  placeholder="Share your experience with this supplier (optional)"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" onclick="closeRatingModal()" class="btn" style="background: #6b7280; color: white;">
                        <i class="bi bi-x"></i> Cancel
                    </button>
                    <button type="submit" class="btn btn-warning" id="submitRatingBtn">
                        <i class="bi bi-star-fill"></i> Submit Rating
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    <style>
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
            overflow-y: auto;
        }
        .modal.show {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .modal-content {
            background: white;
            border-radius: 12px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            width: 100%;
            animation: modalSlideIn 0.3s ease;
        }
        @keyframes modalSlideIn {
            from {
                opacity: 0;
                transform: translateY(-50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        .modal-header {
            padding: 20px 24px;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            align-items: center;
            justify-content: space-between;
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
        }
        .modal-footer {
            padding: 20px 24px;
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
            font-size: 28px;
            cursor: pointer;
            line-height: 1;
            opacity: 0.8;
            transition: opacity 0.3s;
        }
        .close-btn:hover {
            opacity: 1;
        }
        
        /* Star Rating */
        .star-rating {
            display: inline-flex;
            gap: 8px;
            font-size: 48px;
        }
        .star-rating .star {
            color: #d1d5db;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .star-rating .star:hover,
        .star-rating .star.active {
            color: #f59e0b;
            transform: scale(1.1);
        }
        .star-rating .star.hover {
            color: #fbbf24;
        }
    </style>
    
    <script>
        let currentPoId = null;
        let currentSupplierName = '';
        
        function openRatingModal(poId, supplierName) {
            currentPoId = poId;
            currentSupplierName = supplierName;
            
            document.getElementById('ratingPoId').value = poId;
            document.getElementById('supplierNameDisplay').textContent = supplierName;
            document.getElementById('ratingModal').classList.add('show');
            
            // Reset form
            document.getElementById('ratingForm').reset();
            resetStars();
        }
        
        function closeRatingModal() {
            document.getElementById('ratingModal').classList.remove('show');
            resetStars();
        }
        
        function resetStars() {
            const stars = document.querySelectorAll('.star');
            stars.forEach(star => {
                star.classList.remove('active', 'hover');
            });
            document.getElementById('ratingValue').value = '';
            document.getElementById('ratingText').textContent = '';
        }
        
        // Star rating functionality
        const stars = document.querySelectorAll('.star');
        let selectedRating = 0;
        
        stars.forEach(star => {
            // Click to select
            star.addEventListener('click', function() {
                selectedRating = parseInt(this.dataset.rating);
                document.getElementById('ratingValue').value = selectedRating;
                updateStars(selectedRating);
                updateRatingText(selectedRating);
            });
            
            // Hover effect
            star.addEventListener('mouseenter', function() {
                const rating = parseInt(this.dataset.rating);
                stars.forEach((s, index) => {
                    if (index < rating) {
                        s.classList.add('hover');
                    } else {
                        s.classList.remove('hover');
                    }
                });
            });
        });
        
        // Reset hover on mouse leave
        document.getElementById('starRating').addEventListener('mouseleave', function() {
            stars.forEach(s => s.classList.remove('hover'));
        });
        
        function updateStars(rating) {
            stars.forEach((star, index) => {
                if (index < rating) {
                    star.classList.add('active');
                    star.classList.remove('bi-star');
                    star.classList.add('bi-star-fill');
                } else {
                    star.classList.remove('active');
                    star.classList.remove('bi-star-fill');
                    star.classList.add('bi-star');
                }
            });
        }
        
        function updateRatingText(rating) {
            const texts = {
                1: 'Poor',
                2: 'Fair',
                3: 'Good',
                4: 'Very Good',
                5: 'Excellent'
            };
            document.getElementById('ratingText').textContent = texts[rating] || '';
        }
        
        // Form validation
        document.getElementById('ratingForm').addEventListener('submit', function(e) {
            const ratingValue = document.getElementById('ratingValue').value;
            if (!ratingValue) {
                e.preventDefault();
                alert('Please select a star rating');
                return false;
            }
        });
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('ratingModal');
            if (event.target === modal) {
                closeRatingModal();
            }
        }
        
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
<%@ include file="/admin/footer.jsp" %>
</html>