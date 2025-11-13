<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đơn hàng đã giao | PWMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            background-color: #f9fafb;
            font-family: 'Inter', sans-serif;
            color: #374151;
        }

        .page-wrapper {
            display: flex;
            min-height: 100vh;
        }

        /* === SIDEBAR === */
        .sidebar {
            width: 250px;
            background-color: #ffffff;
            border-right: 1px solid #e5e7eb;
            display: flex;
            flex-direction: column;
            padding-top: 15px;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.08);
        }

        .menu a {
            display: flex;
            align-items: center;
            padding: 12px 25px;
            color: #6b7280;
            text-decoration: none;
            font-weight: 500;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .menu a i {
            width: 20px;
            margin-right: 12px;
            color: #6b7280;
        }

        .menu a:hover {
            background-color: #f3f4f6;
            color: #495057;
            transform: translateX(4px);
        }

        .menu a.active {
            background-color: #f3f4f6;
            font-weight: 600;
            color: #6b7280;
        }

        /* === MAIN === */
        .main {
            flex: 1;
            padding: 30px;
            background-color: #f9fafb;
        }

        h3 {
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 25px;
        }

        .card {
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        .table thead {
            background-color: #6b7280;
            color: white;
        }

        .btn-action {
            border-radius: 6px;
        }

        /* === ORDER DETAIL CARD === */
        .order-detail-card {
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 16px;
            background-color: #ffffff;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
            transition: all 0.2s ease-in-out;
        }

        .order-detail-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        .order-detail-header {
            font-weight: 600;
            color: #1f2937;
        }

        .order-detail-meta {
            color: #6b7280;
            font-size: 14px;
        }

        .badge-custom {
            font-size: 13px;
            padding: 6px 10px;
            border-radius: 8px;
        }

    </style>
</head>
<body>

<%@ include file="/admin/header.jsp" %>

<div class="page-wrapper">
    <!-- SIDEBAR -->
    <div class="sidebar">
        <div class="menu">
            <a href="${pageContext.request.contextPath}/view-medicine">
                <i class="bi bi-capsule"></i> Quản lý thuốc
            </a>
            <a href="${pageContext.request.contextPath}/pharmacist/View_MedicineRequest">
                <i class="bi bi-file-earmark-plus"></i> Yêu cầu thuốc
            </a>
            <a href="${pageContext.request.contextPath}/pharmacist/ViewDeliveredOrder" class="active">
                <i class="bi bi-truck"></i> Đơn hàng đã giao
            </a>
            <a href="${pageContext.request.contextPath}/pharmacist/manage-batch">
                <i class="bi bi-box-seam"></i> Quản lý số lô/lô hàng
            </a>
            <a href="${pageContext.request.contextPath}/pharmacist/recordExpiredDamaged">
                <i class="bi bi-exclamation-triangle"></i> Thuốc hết hạn/hư hỏng
            </a>
            <a href="${pageContext.request.contextPath}/report">
                <i class="bi bi-graph-up"></i> Báo cáo thống kê
            </a>
        </div>
    </div>

    <!-- MAIN CONTENT -->
    <div class="main">
        <h3><i class="bi bi-truck"></i> Đơn hàng đã giao</h3>

        <c:if test="${empty deliveredOrders}">
            <div class="alert alert-warning">Hiện chưa có đơn hàng nào được giao.</div>
        </c:if>

        <c:if test="${not empty deliveredOrders}">
            <div class="card">
                <div class="card-body">
                    <table class="table table-hover align-middle text-center">
                        <thead>
                        <tr>
                            <th>Mã đơn hàng</th>
                            <th>Ngày đặt</th>
                            <th>Nhà cung cấp</th>
                            <th>Người quản lý</th>
                            <th>Trạng thái</th>
                            <th>Chi tiết</th>
                            <th>Thêm lô</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="order" items="${deliveredOrders}">
                            <tr>
                                <td>${order.poId}</td>
                                <td>${order.orderDate}</td>
                                <td>${order.supplierName}</td>
                                <td>${order.managerName}</td>
                                <td><span class="badge bg-success">${order.status}</span></td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary btn-action"
                                            type="button" data-bs-toggle="collapse"
                                            data-bs-target="#details${order.poId}">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                </td>
                                <td>
    <a href="${pageContext.request.contextPath}/pharmacist/Batch-Add?poId=${order.poId}"
       class="btn btn-sm btn-outline-success btn-action">
        <i class="bi bi-plus-circle"></i>
    </a>
</td>

                            </tr>

                            <!-- CHI TIẾT ĐƠN HÀNG -->
                           <!-- CHI TIẾT ĐƠN HÀNG -->
<tr class="collapse bg-light" id="details${order.poId}">
    <td colspan="7">
        <div class="p-4 bg-white rounded-4 shadow-sm border mt-2">
            <!-- Tiêu đề -->
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 class="fw-semibold text-primary mb-0">
                    <i class="bi bi-info-circle"></i> Chi tiết đơn hàng #${order.poId}
                </h4>
                <div>
                    <span class="badge bg-light text-dark border px-3 py-2">
                        <i class="bi bi-buildings"></i> ${order.supplierName}
                    </span>
                    <span class="text-muted small ms-2">
                        Ngày đặt: ${order.orderDate}
                    </span>
                </div>
            </div>

            <!-- Nếu không có item -->
            <c:if test="${empty order.items}">
                <div class="alert alert-secondary">Không có mặt hàng nào trong đơn này.</div>
            </c:if>

            <!-- Danh sách mặt hàng -->
            <c:forEach var="item" items="${order.items}">
                <div class="p-3 mb-3 border rounded-4 shadow-sm bg-light">
                    <div class="d-flex justify-content-between align-items-start flex-wrap">
                        <div>
                            <h6 class="fw-semibold text-dark mb-1">
                                ${item.medicineName}
                                <span class="text-primary">${item.medicineStrength}</span>
                            </h6>
                            <div class="text-muted small mb-2">
                                <i class="bi bi-capsule"></i> Dạng: ${item.medicineDosageForm} |
                                <i class="bi bi-diagram-3"></i> Nhóm: ${item.medicineCategory} |
                                <i class="bi bi-droplet-half"></i> Hoạt chất: ${item.activeIngredient}
                            </div>
                            <div class="d-flex flex-wrap gap-2">
                                <span class="badge bg-secondary rounded-pill px-3 py-2">
                                    <i class="bi bi-box"></i> SL: ${item.quantity}
                                </span>
                                <span class="badge bg-info text-dark rounded-pill px-3 py-2">
                                    <i class="bi bi-cash-stack"></i> Đơn giá: ${item.unitPrice} VNĐ
                                </span>
                                <span class="badge bg-success rounded-pill px-3 py-2">
                                    <i class="bi bi-calculator"></i> Tổng: ${item.unitPrice * item.quantity} VNĐ
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <!-- Tổng tiền đơn hàng -->
            <c:set var="totalPrice" value="0" />
            <c:forEach var="item" items="${order.items}">
                <c:set var="totalPrice" value="${totalPrice + (item.unitPrice * item.quantity)}" />
            </c:forEach>
            <div class="text-end mt-3">
                <span class="fw-semibold text-dark">Tổng giá trị đơn hàng:</span>
                <span class="badge bg-success fs-6 px-3 py-2">${totalPrice} VNĐ</span>
            </div>
        </div>
    </td>
</tr>


                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
