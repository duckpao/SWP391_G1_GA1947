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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
    <%@ include file="/admin/header.jsp" %>

    <div class="page-wrapper">
        <div class="sidebar">
            <div class="menu">
                <a href="${pageContext.request.contextPath}/view-medicine"><i class="fa fa-pills"></i> Quản lý thuốc</a>
                <a href="${pageContext.request.contextPath}/pharmacist/View_MedicineRequest"><i class="fa fa-file-medical"></i> Yêu cầu thuốc</a>
                <a href="${pageContext.request.contextPath}/pharmacist/ViewDeliveredOrder"><i class="fa fa-truck"></i> Đơn hàng đã giao</a>
                <a href="${pageContext.request.contextPath}/pharmacist/manage-batch" class="active"><i class="fa fa-warehouse"></i> Quản lý số lô/lô hàng</a>
                <a href="${pageContext.request.contextPath}/pharmacist/recordExpiredDamaged"><i class="fa fa-exclamation-triangle"></i> Thuốc hết hạn/hư hỏng</a>
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
            <form class="row mb-3" method="get" action="${pageContext.request.contextPath}/pharmacist/manage-batch">
                <div class="col-md-4">
                    <input type="text" name="lotNumber" class="form-control" 
                           placeholder="Tìm theo số lô..." 
                           value="${param.lotNumber}">
                </div>
                <div class="col-md-3">
                    <select name="medicineCode" class="form-control">
                        <option value="">-- Chọn thuốc --</option>
                        <c:forEach var="med" items="${medicineList}">
                            <option value="${med.medicineCode}" 
                                ${param.medicineCode == med.medicineCode ? 'selected' : ''}>
                                ${med.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <select name="supplierId" class="form-control">
                        <option value="">-- Chọn NCC --</option>
                        <c:forEach var="sup" items="${supplierList}">
                            <option value="${sup.supplierId}" 
                                ${param.supplierId == sup.supplierId ? 'selected' : ''}>
                                ${sup.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <button class="btn btn-outline-secondary w-100" type="submit">
                        <i class="fa fa-search"></i> Tìm kiếm
                    </button>
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
                        <th>Số lượng của lô</th> <!-- ✅ ĐÃ SỬA LABEL -->
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="batch" items="${batches}">
                        <tr>
                            <td class="text-center">${batch.batchId}</td>
                            <td>${batch.medicineName}</td>
                            <td>${batch.supplierName}</td>
                            <td><strong>${batch.lotNumber}</strong></td>
                            <td class="text-center">${batch.receivedDate}</td>
                            <td class="text-center ${batch.expirySoon ? 'text-danger fw-bold' : ''}">
                                ${batch.expiryDate}
                            </td>
                            <td class="text-end">${batch.initialQuantity}</td>
                            
                            <!-- ✅ HIỂN THỊ batch_quantity THAY VÌ current_quantity -->
                            <td class="text-end">
                                <span class="badge bg-primary">${batch.batchQuantity}</span>
                            </td>
                            
                            <td class="text-center">
                                <span class="badge 
                                    <c:choose>
                                        <c:when test="${batch.status == 'Approved'}">bg-success</c:when>
                                        <c:when test="${batch.status == 'Quarantined'}">bg-warning text-dark</c:when>
                                        <c:when test="${batch.status == 'Rejected'}">bg-danger</c:when>
                                        <c:when test="${batch.status == 'Expired'}">bg-secondary</c:when>
                                        <c:otherwise>bg-info</c:otherwise>
                                    </c:choose>">
                                    ${batch.status}
                                </span>
                            </td>
                            <td class="text-center">
                                <!-- Nút Kiểm định chất lượng (chỉ hiện khi Quarantined) -->
                                <c:if test="${batch.status == 'Quarantined'}">
                                    <a href="${pageContext.request.contextPath}/pharmacist/BatchQualityCheck?batchId=${batch.batchId}" 
                                       class="btn btn-sm btn-outline-success"
                                       title="Kiểm định chất lượng">
                                        <i class="fa fa-check-circle"></i> Kiểm định
                                    </a>
                                </c:if>
                                
                                <!-- Nút Sửa -->
                                <a href="${pageContext.request.contextPath}/pharmacist/Batch-Update?batchId=${batch.batchId}" 
                                   class="btn btn-sm btn-outline-primary"
                                   title="Chỉnh sửa thông tin lô">
                                    <i class="fa fa-edit"></i> Sửa
                                </a>
                                
                                <!-- Nút Xóa -->
                                <a href="${pageContext.request.contextPath}/pharmacist/Batch-Delete?batchId=${batch.batchId}" 
                                   onclick="return confirm('Bạn có chắc muốn xóa lô ${batch.lotNumber}?')" 
                                   class="btn btn-sm btn-outline-danger"
                                   title="Xóa lô này">
                                    <i class="fa fa-trash"></i> Xóa
                                </a>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty batches}">
                        <tr>
                            <td colspan="10" class="text-center text-muted py-4">
                                <i class="fa fa-inbox fa-3x mb-3 d-block"></i>
                                Không có lô thuốc nào trong hệ thống.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <%@ include file="/admin/footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>