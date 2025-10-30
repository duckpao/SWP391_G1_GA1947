<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý số lô (Batch / Lot)</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html, body {
            height: 100%;
        }

        body {
            display: flex;
            flex-direction: column;
            background-color: #ffffff;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            font-size: 14px;
            line-height: 1.5;
            color: #333;
        }

        .page-wrapper {
            display: flex;
            flex: 1;
            min-height: calc(100vh - 60px);
        }

        /* Updated sidebar styling to match view-med with white theme and light border */
        .sidebar {
            width: 250px;
            background-color: #ffffff;
            color: #6c757d;
            display: flex;
            flex-direction: column;
            padding-top: 15px;
            border-right: 1px solid #e9ecef;
            box-shadow: none;
        }

        .menu a {
            display: flex;
            align-items: center;
            padding: 12px 25px;
            color: #6c757d;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
            border-radius: 0;
        }

        /* Added icon styling */
        .menu a i {
            width: 20px;
            margin-right: 10px;
            color: #6c757d;
        }

        .menu a:hover {
            background-color: #f0f7ff;
            color: #495057;
            border-left-color: transparent;
            padding-left: 25px;
        }

        .menu a.active {
            background-color: #e7f1ff;
            color: #0066cc;
            border-left-color: #0066cc;
            padding-left: 22px;
        }

        /* Active icon color */
        .menu a.active i {
            color: #0066cc;
        }

        .main {
            flex: 1;
            padding: 30px;
            background-color: #ffffff;
            overflow-y: auto;
        }

        h3 {
            font-size: 28px;
            margin-bottom: 25px;
            font-weight: 700;
            color: #1a1a1a;
            letter-spacing: -0.5px;
        }

        /* Updated all button colors to gray theme */
        .btn-primary, .btn-outline-primary, .btn-outline-danger, .btn-outline-success, .btn-outline-secondary {
            background-color: #6c757d;
            color: white;
            border: 1px solid #6c757d;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-primary:hover, .btn-outline-primary:hover, .btn-outline-danger:hover, .btn-outline-success:hover, .btn-outline-secondary:hover {
            background-color: #5a6268;
            border-color: #5a6268;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(108, 117, 125, 0.2);
        }

        .table {
            background-color: #ffffff;
            border-collapse: collapse;
        }

        /* Updated table header to light gray instead of dark */
        .table thead.table-dark {
            background-color: transparent;
            color: #ffffff;
            border-bottom: 1px solid #dee2e6;
        }

        .table thead th {
            font-weight: 600;
            font-size: 13px;
            letter-spacing: 0.3px;
            text-transform: uppercase;
            color: #ffffff;
        }

        .table tbody tr {
            border-bottom: 1px solid #e9ecef;
        }

        .table tbody tr:hover {
            background-color: #f8f9fa;
        }

        .form-control {
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 10px 12px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: #6c757d;
            box-shadow: 0 0 0 3px rgba(108, 117, 125, 0.1);
            outline: none;
        }

        .badge {
            padding: 6px 12px;
            border-radius: 4px;
            font-weight: 600;
            font-size: 12px;
        }

        .container {
            max-width: 100%;
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="page-wrapper">
        <!-- Updated sidebar with icons matching view-med -->
        <div class="sidebar">
            <div class="menu">
                <a href="${pageContext.request.contextPath}/view-medicine"><i class="fa fa-pills"></i> Quản lý thuốc</a>
                <a href="${pageContext.request.contextPath}/create-request"><i class="fa fa-file-medical"></i> Yêu cầu thuốc</a>
                <a href="${pageContext.request.contextPath}/pharmacist/manage-batch" class="active"><i class="fa fa-warehouse"></i> Quản lý số lô/lô hàng</a>
                <a href="${pageContext.request.contextPath}/pharmacist/recordExpiredDamaged"><i class="fa fa-user-md"></i> thuốc hết hạn/hư hỏng</a>
                <a href="${pageContext.request.contextPath}/report"><i class="fa fa-chart-line"></i> Báo cáo thống kê</a>
            </div>
        </div>

        <div class="main">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="fw-bold">Quản lý số lô (Batch / Lot)</h3>
                <a href="${pageContext.request.contextPath}/batch/manage?action=new" class="btn btn-primary">
                    Thêm lô mới
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
    </div>

    <%@ include file="footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
