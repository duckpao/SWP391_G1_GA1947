<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đơn hàng đã giao | PWMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/sidebar.css" rel="stylesheet">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: #f9fafb;
            font-size: 14px;
            color: #374151;
        }

        .page-wrapper {
            display: flex;
            min-height: calc(100vh - 60px);
        }

        /* Sidebar */
        

        .main {
            flex: 1;
            padding: 30px;
            background-color: #f9fafb;
        }

        h1 {
            font-size: 28px;
            margin-bottom: 25px;
            font-weight: 700;
            color: #1f2937;
        }

        /* Card Styling */
        .card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            border: none;
            margin-bottom: 24px;
        }

        .card-header {
            background: linear-gradient(135deg, #6b7280 0%, #4b5563 100%);
            color: white;
            padding: 16px 24px;
            border-radius: 12px 12px 0 0;
            border: none;
        }

        .card-header h5 {
            margin: 0;
            font-weight: 600;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .badge {
            background-color: rgba(255, 255, 255, 0.2);
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 13px;
            margin-left: 8px;
        }

        /* Table Styling */
        .table-responsive {
            border-radius: 0 0 12px 12px;
            overflow: hidden;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
        }

        thead {
            background-color: #f9fafb;
        }

        th {
            padding: 14px 16px;
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #6b7280;
            border-bottom: 2px solid #e5e7eb;
            text-align: left;
        }

        tbody tr {
            transition: all 0.2s ease;
            border-bottom: 1px solid #e5e7eb;
        }

        tbody tr:hover {
            background-color: #f9fafb;
        }

        td {
            padding: 14px 16px;
            font-size: 14px;
            vertical-align: middle;
        }

        /* Detail Row Styling */
        .detail-row {
            display: none;
            background-color: #f9fafb;
        }

        .detail-row.show {
            display: table-row;
        }

        .detail-content {
            padding: 20px 24px;
            border-top: 2px solid #e5e7eb;
        }

        .detail-header {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 2px solid #e5e7eb;
        }

        .detail-header h6 {
            font-weight: 600;
            color: #1f2937;
            margin: 0;
        }

        .item-card {
            background: white;
            padding: 16px;
            border-radius: 8px;
            border-left: 3px solid #6b7280;
            margin-bottom: 12px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
        }

        .item-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 8px;
        }

        .item-name {
            font-weight: 600;
            color: #1f2937;
            font-size: 15px;
        }

        .item-info {
            display: flex;
            gap: 16px;
            margin-bottom: 8px;
            color: #6b7280;
            font-size: 13px;
        }

        .item-badges {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .item-badge {
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 500;
        }

        .badge-quantity {
            background-color: #dbeafe;
            color: #1e40af;
        }

        .badge-price {
            background-color: #fef3c7;
            color: #92400e;
        }

        .badge-total {
            background-color: #d1fae5;
            color: #065f46;
        }

        .total-section {
            text-align: right;
            padding: 16px;
            background: white;
            border-radius: 8px;
            margin-top: 16px;
        }

        .total-label {
            font-weight: 600;
            color: #6b7280;
            font-size: 14px;
        }

        .total-value {
            font-weight: 700;
            color: #065f46;
            font-size: 18px;
            margin-left: 12px;
        }

        /* Status Badges */
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }

        .status-delivered {
            background: #d1fae5;
            color: #065f46;
        }

        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }

        /* Action Buttons */
        .btn {
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s ease;
            border: none;
        }

        .btn-sm {
            padding: 6px 12px;
            font-size: 13px;
        }

        .btn-view {
            background-color: #3b82f6;
            color: white;
            border: none;
            transition: all 0.2s ease;
        }

        .btn-view:hover {
            background-color: #2563eb;
            transform: translateY(-1px);
        }

        .btn-view i {
            transition: transform 0.3s ease;
        }

        .btn-view.active i {
            transform: rotate(180deg);
        }

        .btn-add {
            background-color: #10b981;
            color: white;
        }

        .btn-add:hover {
            background-color: #059669;
            transform: translateY(-1px);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #9ca3af;
        }

        .empty-state i {
            font-size: 64px;
            color: #d1d5db;
            margin-bottom: 16px;
        }

        /* Alerts */
        .alert {
            border-radius: 12px;
            border: none;
            margin-bottom: 24px;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .page-wrapper {
                flex-direction: column;
            }
            
            .sidebar {
                width: 100%;
            }

            .item-header {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>

<%@ include file="/admin/header.jsp" %>

<div class="page-wrapper">
    <!-- SIDEBAR -->
    <c:set var="pageParam" value="pharmacist/view-order-details" scope="request"/>
    <%@ include file="/pharmacist/sidebar.jsp" %>

    <!-- MAIN CONTENT -->
    <div class="main">
        <h1><i class="bi bi-truck"></i> Đơn hàng đã giao</h1>

        <!-- Success/Error Messages -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle"></i> ${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-circle"></i> ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Results Card -->
        <div class="card">
            <div class="card-header">
                <h5>
                    <i class="bi bi-list-ul"></i> Danh sách đơn hàng
                    <span class="badge">${deliveredOrders != null ? deliveredOrders.size() : 0}</span>
                </h5>
            </div>
            <div class="card-body p-0">
                <c:choose>
                    <c:when test="${not empty deliveredOrders}">
                        <div class="table-responsive">
                            <table>
                                <thead>
                                    <tr>
                                        <th style="width: 50px;"></th>
                                        <th>Mã đơn hàng</th>
                                        <th>Ngày đặt</th>
                                        <th>Nhà cung cấp</th>
                                        <th>Người quản lý</th>
                                        <th>Số mặt hàng</th>
                                        <th>Tổng tiền</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="order" items="${deliveredOrders}" varStatus="status">
                                        <tr>
                                            <td>
                                                <button class="btn btn-view btn-sm toggle-detail" 
                                                        data-target="detail-${status.index}">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                            </td>
                                            <td><strong>#${order.poId}</strong></td>
                                            <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/></td>
                                            <td>${order.supplierName}</td>
                                            <td>${order.managerName}</td>
                                            <td>
                                                <span class="badge bg-primary">
                                                    ${order.itemCount} items
                                                </span>
                                            </td>
                                            <td><strong><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫"/></strong></td>
                                            <td><span class="status-badge status-delivered">${order.status}</span></td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/pharmacist/Batch-Add?poId=${order.poId}"
                                                   class="btn btn-add btn-sm">
                                                    <i class="bi bi-plus-circle"></i> Thêm lô
                                                </a>
                                            </td>
                                        </tr>
                                        
                                        <!-- Detail Row -->
                                        <tr class="detail-row" id="detail-${status.index}">
                                            <td colspan="9">
                                                <div class="detail-content">
                                                    <div class="detail-header">
                                                        <h6>
                                                            <i class="bi bi-info-circle"></i> Chi tiết đơn hàng #${order.poId}
                                                        </h6>
                                                        <div>
                                                            <span class="badge bg-secondary">${order.supplierName}</span>
                                                            <span class="text-muted ms-2" style="font-size: 13px;">
                                                                <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy"/>
                                                            </span>
                                                        </div>
                                                    </div>

                                                    <c:choose>
                                                        <c:when test="${empty order.items}">
                                                            <div class="alert alert-warning mb-0">
                                                                <i class="bi bi-exclamation-triangle"></i> Không có mặt hàng nào trong đơn này.
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:set var="totalPrice" value="0" />
                                                            <c:forEach var="item" items="${order.items}">
                                                                <div class="item-card">
                                                                    <div class="item-header">
                                                                        <div>
                                                                            <div class="item-name">
                                                                                ${item.medicineName} 
                                                                                <span style="color: #3b82f6;">${item.medicineStrength}</span>
                                                                            </div>
                                                                            <div class="item-info">
                                                                                <span><i class="bi bi-capsule"></i> ${item.medicineDosageForm}</span>
                                                                                <span><i class="bi bi-diagram-3"></i> ${item.medicineCategory}</span>
                                                                                <span><i class="bi bi-droplet-half"></i> ${item.activeIngredient}</span>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="item-badges">
                                                                        <span class="item-badge badge-quantity">
                                                                            <i class="bi bi-box"></i> SL: ${item.quantity}
                                                                        </span>
                                                                        <span class="item-badge badge-price">
                                                                            <i class="bi bi-cash-stack"></i> 
                                                                            <fmt:formatNumber value="${item.unitPrice}" type="currency" currencySymbol="₫"/>
                                                                        </span>
                                                                        <span class="item-badge badge-total">
                                                                            <i class="bi bi-calculator"></i> 
                                                                            <fmt:formatNumber value="${item.unitPrice * item.quantity}" type="currency" currencySymbol="₫"/>
                                                                        </span>
                                                                    </div>
                                                                </div>
                                                                <c:set var="totalPrice" value="${totalPrice + (item.unitPrice * item.quantity)}" />
                                                            </c:forEach>

                                                            <div class="total-section">
                                                                <span class="total-label">Tổng giá trị đơn hàng:</span>
                                                                <span class="total-value">
                                                                    <fmt:formatNumber value="${totalPrice}" type="currency" currencySymbol="₫"/>
                                                                </span>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <i class="bi bi-inbox"></i>
                            <h3>Chưa có đơn hàng nào</h3>
                            <p>Hiện chưa có đơn hàng nào được giao</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Toggle detail row
    document.querySelectorAll('.toggle-detail').forEach(btn => {
        btn.addEventListener('click', function() {
            const targetId = this.dataset.target;
            const detailRow = document.getElementById(targetId);
            
            detailRow.classList.toggle('show');
            this.classList.toggle('active');
        });
    });
</script>
</body>
</html>