<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách yêu cầu thuốc</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            display: flex;
            flex-direction: column;
            background-color: #f9fafb;
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
        }

        .page-wrapper {
            display: flex;
            flex: 1;
        }

        .sidebar {
            width: 250px;
            background-color: #ffffff;
            border-right: 1px solid #e5e7eb;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.08);
            padding-top: 15px;
        }

        .menu a {
            display: flex;
            align-items: center;
            padding: 12px 25px;
            color: #6b7280;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .menu a:hover {
            background-color: #f3f4f6;
            transform: translateX(4px);
        }

        .menu a.active {
            background-color: #f3f4f6;
            color: #6b7280;
            font-weight: 600;
        }

        .main {
            flex: 1;
            padding: 30px;
            background-color: #f9fafb;
        }

        h2 {
            font-size: 28px;
            margin-bottom: 25px;
            font-weight: 700;
            color: #1f2937;
        }

        .alert {
            border-radius: 10px;
            padding: 16px 20px;
            margin-bottom: 24px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-success {
            background: #d1fae5;
            color: #065f46;
            border: 1px solid #6ee7b7;
        }

        .alert-danger {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }

        .table-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            overflow: hidden;
        }

        table {
            width: 100%;
            margin: 0;
        }

        thead {
            background: #6b7280;
            color: white;
        }

        th {
            padding: 14px 12px;
            font-weight: 600;
            text-align: center;
        }

        td {
            padding: 12px;
            border-bottom: 1px solid #e5e7eb;
            text-align: center;
        }

        tbody tr:hover {
            background-color: #f9fafb;
        }

        .status {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }

        .status.Pending {
            background-color: #fef3c7;
            color: #92400e;
        }

        .status.Approved {
            background-color: #d1fae5;
            color: #065f46;
        }

        .status.Fulfilled {
            background-color: #dbeafe;
            color: #1e40af;
        }

        .status.Canceled, .status.Rejected {
            background-color: #fee2e2;
            color: #991b1b;
        }

        .btn {
            padding: 8px 16px;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }

        .btn-success {
            background-color: #10b981;
            color: white;
        }

        .btn-success:hover {
            background-color: #059669;
            transform: translateY(-2px);
        }

        .btn-danger {
            background-color: #ef4444;
            color: white;
        }

        .btn-danger:hover {
            background-color: #dc2626;
            transform: translateY(-2px);
        }

        .btn-primary {
            background-color: #3b82f6;
            color: white;
        }

        .btn-primary:hover {
            background-color: #2563eb;
        }

        .badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .bg-secondary {
            background-color: #6b7280;
            color: white;
        }
    </style>
</head>
<body>
    <%@ include file="/admin/header.jsp" %>

    <div class="page-wrapper">
        <div class="sidebar">
            <div class="menu">
                <a href="${pageContext.request.contextPath}/view-medicine">
                    <i class="fa fa-pills"></i> Quản lý thuốc
                </a>
                <a href="${pageContext.request.contextPath}/pharmacist/View_MedicineRequest" class="active">
                    <i class="fa fa-file-medical"></i> Yêu cầu thuốc
                </a>
                <a href="${pageContext.request.contextPath}/pharmacist/view-order-details">
                    <i class="bi bi-box-seam"></i> Đơn hàng đã giao
                </a>
                <a href="${pageContext.request.contextPath}/pharmacist/manage-batch">
                    <i class="fa fa-warehouse"></i> Quản lý số lô
                </a>
            </div>
        </div>

        <div class="main">
            <h2>Danh sách yêu cầu thuốc</h2>

            <!-- ✅ HIỂN THỊ THÔNG BÁO THÀNH CÔNG -->
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <i class="bi bi-check-circle-fill"></i>
                    <span>${success}</span>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="bi bi-exclamation-triangle-fill"></i>
                    <span>${error}</span>
                </div>
            </c:if>

            <c:choose>
                <c:when test="${not empty requestList}">
                    <div class="table-container">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Request ID</th>
                                    <th>Bác sĩ</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày yêu cầu</th>
                                    <th>Tên thuốc</th>
                                    <th>Số lượng</th>
                                    <th>Ghi chú</th>
                                    <th>Thao tác</th>
                                    <th>Phiếu xuất</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="req" items="${requestList}">
                                    <tr>
                                        <td><strong>${req.requestId}</strong></td>
                                        <td>${req.doctorName}</td>
                                        <td><span class="status ${req.status}">${req.status}</span></td>
                                        <td>${req.requestDate}</td>
                                        <td>
                                            <c:forEach var="item" items="${req.items}">
                                                ${item.medicineName}<br/>
                                            </c:forEach>
                                        </td>
                                        <td>
                                            <c:forEach var="item" items="${req.items}">
                                                ${item.quantity}<br/>
                                            </c:forEach>
                                        </td>
                                        <td>${req.notes}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${req.status == 'Pending'}">
                                                    <div style="display: flex; gap: 8px; justify-content: center;">
                                                        <!-- ✅ FORM CHẤP NHẬN VỚI CONFIRM -->
                                                        <form action="${pageContext.request.contextPath}/PharmacistUpdateRequest" 
                                                              method="post" 
                                                              onsubmit="return confirm('Bạn có chắc chắn muốn CHẤP NHẬN yêu cầu này?\n\n⚠️ Hệ thống sẽ tự động:\n- Trừ kho thuốc theo FIFO (lô hết hạn sớm nhất)\n- Tạo phiếu xuất kho\n- Ghi nhận giao dịch');">
                                                            <input type="hidden" name="action" value="approve"/>
                                                            <input type="hidden" name="requestId" value="${req.requestId}"/>
                                                            <button type="submit" class="btn btn-success btn-sm">
                                                                <i class="bi bi-check-circle"></i> Chấp nhận
                                                            </button>
                                                        </form>

                                                        <!-- ✅ FORM TỪ CHỐI VỚI REASON -->
                                                        <form action="${pageContext.request.contextPath}/PharmacistUpdateRequest" 
                                                              method="post" 
                                                              onsubmit="return addRejectReason(this)">
                                                            <input type="hidden" name="action" value="reject"/>
                                                            <input type="hidden" name="requestId" value="${req.requestId}"/>
                                                            <input type="hidden" name="reason" value=""/>
                                                            <button type="submit" class="btn btn-danger btn-sm">
                                                                <i class="bi bi-x-circle"></i> Từ chối
                                                            </button>
                                                        </form>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">Đã xử lý</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${req.status == 'Approved' || req.status == 'Fulfilled'}">
                                                    <a href="${pageContext.request.contextPath}/pharmacist/viewIssueSlip?requestId=${req.requestId}"
                                                       class="btn btn-primary btn-sm">
                                                        <i class="bi bi-eye"></i> Xem
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    -
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <h3>Không có yêu cầu thuốc nào</h3>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <%@ include file="/admin/footer.jsp" %>

    <script>
        function addRejectReason(form) {
            var reason = prompt("Nhập lý do từ chối yêu cầu:");
            if (reason == null || reason.trim() === "") {
                alert("Bạn phải nhập lý do từ chối!");
                return false;
            }
            form.reason.value = reason;
            return confirm("Xác nhận TỪ CHỐI yêu cầu này với lý do:\n\n" + reason);
        }
    </script>
</body>
</html>