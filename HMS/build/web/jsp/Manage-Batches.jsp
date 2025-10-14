<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Quản lý số lô (Batch / Lot)</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-4">

    <!-- Tiêu đề + nút thêm -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold">Quản lý số lô (Batch / Lot)</h3>
        <a href="${pageContext.request.contextPath}/batch/manage?action=new" class="btn btn-primary">
            + Thêm lô mới
        </a>
    </div>

    <!-- Ô tìm kiếm -->
    <form class="row mb-3" method="get" action="${pageContext.request.contextPath}/batch/manage">
        <input type="hidden" name="action" value="search"/>
        <div class="col-md-4">
            <input type="text" name="keyword" class="form-control" placeholder="Tìm theo tên thuốc hoặc số lô...">
        </div>
        <div class="col-md-2">
            <button class="btn btn-outline-secondary" type="submit">Tìm kiếm</button>
        </div>
    </form>

    <!-- Bảng danh sách lô thuốc -->
    <table class="table table-bordered table-striped align-middle">
        <thead class="table-dark text-center">
            <tr>
                <th>ID</th>
                <th>Tên thuốc</th>
                <th>Nhà cung cấp</th>
                <th>Số lô</th>
                <th>Ngày nhận</th>
                <th>Ngày hết hạn</th>
                <th>Số lượng ban đầu</th>
                <th>Số lượng hiện tại</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="batch" items="${batchList}">
                <tr>
                    <td class="text-center">${batch.batchId}</td>
                    <td>${batch.medicineName}</td>
                    <td>${batch.supplierName}</td>
                    <td>${batch.lotNumber}</td>
                    <td>${batch.receivedDate}</td>
                    <td class="${batch.expirySoon ? 'text-danger fw-bold' : ''}">${batch.expiryDate}</td>
                    <td class="text-end">${batch.initialQuantity}</td>
                    <td class="text-end">${batch.currentQuantity}</td>
                    <td class="text-center">
                        <span class="badge 
                            <c:choose>
                                <c:when test="${batch.status == 'Approved'}">bg-success</c:when>
                                <c:when test="${batch.status == 'Quarantined'}">bg-warning text-dark</c:when>
                                <c:when test="${batch.status == 'Rejected'}">bg-danger</c:when>
                                <c:otherwise>bg-secondary</c:otherwise>
                            </c:choose>">
                            ${batch.status}
                        </span>
                    </td>
                    <td class="text-center">
                        <a href="${pageContext.request.contextPath}/batch/manage?action=edit&id=${batch.batchId}" class="btn btn-sm btn-outline-primary">Sửa</a>
                        <a href="${pageContext.request.contextPath}/batch/manage?action=delete&id=${batch.batchId}" 
                           onclick="return confirm('Bạn có chắc muốn xóa lô này?')" 
                           class="btn btn-sm btn-outline-danger">Xóa</a>
                        <c:if test="${batch.status == 'Quarantined'}">
                            <a href="${pageContext.request.contextPath}/batch/manage?action=release&id=${batch.batchId}" 
                               class="btn btn-sm btn-outline-success">Giải phóng</a>
                        </c:if>
                        <c:if test="${batch.status != 'Expired'}">
                            <a href="${pageContext.request.contextPath}/batch/manage?action=markExpired&id=${batch.batchId}" 
                               class="btn btn-sm btn-outline-secondary">Hết hạn</a>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty batchList}">
                <tr>
                    <td colspan="10" class="text-center text-muted">Không có lô thuốc nào trong hệ thống.</td>
                </tr>
            </c:if>
        </tbody>
    </table>
</div>

</body>
</html>
