<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý kho bệnh viện</title>
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="d-flex justify-content-between align-items-center p-3 border-bottom bg-white">
    <h5 class="mb-0">Quản lý kho bệnh viện</h5>
    <div>
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <span class="me-3">Xin chào, ${sessionScope.user.username}</span>
                <a href="javascript:void(0)" onclick="confirmLogout()" class="text-decoration-none text-danger">Đăng xuất</a>
            </c:when>
            <c:otherwise>
                <a href="login.jsp" class="text-decoration-none me-3">Đăng nhập</a>
                <a href="register.jsp" class="text-decoration-none">Đăng ký</a>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    function confirmLogout() {
        if (confirm("Bạn có chắc chắn muốn đăng xuất không?")) {
            window.location.href = 'logout';
        }
    }
</script>

<div class="container py-4">

    <!-- Thống kê -->
    <div class="row text-center mb-4">
        <div class="col-md-3">
            <div class="border p-3 bg-white">
                <div>Thuốc</div>
                <h4>${stats.totalMedicines}</h4>
            </div>
        </div>
        <div class="col-md-3">
            <div class="border p-3 bg-white">
                <div>Lô thuốc</div>
                <h4>${stats.totalBatches}</h4>
            </div>
        </div>
        <div class="col-md-3">
            <div class="border p-3 bg-white">
                <div>Hóa đơn</div>
                <h4>${stats.totalInvoices}</h4>
            </div>
        </div>
        <div class="col-md-3">
            <div class="border p-3 bg-white">
                <div>Giao dịch</div>
                <h4>${stats.totalTransactions}</h4>
            </div>
        </div>
    </div>

    <!-- Bảng lô thuốc sắp hết hạn -->
    <div class="card mb-4">
        <div class="card-header bg-white">
            <strong>Lô thuốc sắp hết hạn (≤ 60 ngày)</strong>
        </div>
        <div class="card-body p-0">
            <table class="table table-bordered table-sm mb-0">
                <thead class="table-light">
                    <tr>
                        <th>#</th>
                        <th>Tên thuốc</th>
                        <th>Số lô</th>
                        <th>Hạn sử dụng</th>
                        <th>Số lượng còn</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="b" items="${expiringBatches}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1}</td>
                            <td>${b.medicineName}</td>
                            <td>${b.lotNumber}</td>
                            <td>${b.expiryDate}</td>
                            <td>${b.currentQuantity}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty expiringBatches}">
                        <tr>
                            <td colspan="5" class="text-center text-muted">
                                Không có lô thuốc nào sắp hết hạn
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Bảng đơn hàng gần đây -->
    <div class="card mb-4">
        <div class="card-header bg-white">
            <strong>Đơn hàng gần đây</strong>
        </div>
        <div class="card-body p-0">
            <table class="table table-bordered table-sm mb-0">
                <thead class="table-light">
                    <tr>
                        <th>#</th>
                        <th>Mã đơn hàng</th>
                        <th>Nhà cung cấp</th>
                        <th>Ngày đặt</th>
                        <th>Trạng thái</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="po" items="${recentOrders}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1}</td>
                            <td>PO-${po.poId}</td>
                            <td>${po.supplierName}</td>
                            <td>${po.orderDate}</td>
                            <td>${po.status}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty recentOrders}">
                        <tr>
                            <td colspan="5" class="text-center text-muted">
                                Không có đơn hàng nào gần đây
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Bảng giao dịch gần đây -->
    <div class="card">
        <div class="card-header bg-white">
            <strong>Giao dịch gần đây</strong>
        </div>
        <div class="card-body p-0">
            <table class="table table-bordered table-sm mb-0">
                <thead class="table-light">
                    <tr>
                        <th>#</th>
                        <th>Loại</th>
                        <th>Tên thuốc</th>
                        <th>Số lượng</th>
                        <th>Ngày</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="t" items="${recentTransactions}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1}</td>
                            <td>${t.type}</td>
                            <td>${t.medicineName}</td>
                            <td>${t.quantity}</td>
                            <td>${t.transactionDate}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty recentTransactions}">
                        <tr>
                            <td colspan="5" class="text-center text-muted">
                                Không có giao dịch nào gần đây
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
