<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hết hạn / Hư hỏng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
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
            background-color: #f9fafb;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            font-size: 14px;
            line-height: 1.5;
            color: #374151;
        }

        .page-wrapper {
            display: flex;
            flex: 1;
            min-height: calc(100vh - 60px);
        }

        /* White theme sidebar */
        .sidebar {
            width: 250px;
            background-color: #ffffff;
            color: #6c757d;
            display: flex;
            flex-direction: column;
            padding-top: 15px;
            border-right: 1px solid #e5e7eb;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.08);
        }

        .menu a {
            display: flex;
            align-items: center;
            padding: 12px 25px;
            color: #6b7280;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
            border-radius: 0;
            margin: 4px 0;
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
            color: #6b7280;
            font-weight: 600;
        }

        .menu a.active i {
            color: #6b7280;
        }

        /* Main content */
        .main {
            flex: 1;
            padding: 30px;
            background-color: #f9fafb;
            overflow-y: auto;
        }

        h2 {
            font-size: 28px;
            margin-bottom: 25px;
            font-weight: 700;
            color: #1f2937;
            letter-spacing: -0.5px;
        }

        /* Form container */
        .form-container {
            background: white;
            padding: 24px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            margin-bottom: 24px;
        }

        .form-label {
            font-weight: 600;
            color: #374151;
            font-size: 13px;
            margin-bottom: 6px;
        }

        .form-control, .form-select {
            padding: 10px 14px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 14px;
            font-family: 'Inter', sans-serif;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: #6b7280;
            box-shadow: 0 0 0 3px rgba(107, 114, 128, 0.1);
            outline: none;
        }

        /* Gray button styling */
        .btn {
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s ease;
            border: none;
        }

        .btn-primary {
            background-color: #6b7280;
            color: white;
        }

        .btn-primary:hover {
            background-color: #4b5563;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(107, 114, 128, 0.2);
        }

        /* Table container */
        .table-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            overflow: hidden;
        }

        table {
            background: white;
            border-collapse: collapse;
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
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            text-align: center;
        }

        td {
            padding: 12px;
            border-bottom: 1px solid #e5e7eb;
            font-size: 14px;
            text-align: center;
        }

        tbody tr:hover {
            background-color: #f9fafb;
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        /* Badge styling */
        .badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .bg-danger {
            background-color: #fee2e2;
            color: #991b1b;
        }

        .bg-warning {
            background-color: #fef3c7;
            color: #92400e;
        }

        .bg-secondary {
            background-color: #e5e7eb;
            color: #6b7280;
        }

        /* Empty state */
        .empty-state {
            text-align: center;
            color: #9ca3af;
            padding: 60px 20px;
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

        /* Responsive */
        @media (max-width: 768px) {
            .page-wrapper {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                border-right: none;
                border-bottom: 1px solid #e5e7eb;
            }

            .main {
                padding: 20px;
            }

            h2 {
                font-size: 22px;
            }
        }
    </style>
</head>

<body>
    <%@ include file="/admin/header.jsp" %>

    <div class="page-wrapper">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="menu">
                <a href="${pageContext.request.contextPath}/view-medicine?dashboard=pharmacist">
                    <i class="bi bi-capsule"></i> Quản lý thuốc
                </a>
                <a href="${pageContext.request.contextPath}/pharmacist/View_MedicineRequest">
                    <i class="bi bi-file-earmark-plus"></i> Yêu cầu thuốc
                </a>
                <a href="${pageContext.request.contextPath}/pharmacist/manage-batch">
                    <i class="bi bi-box-seam"></i> Quản lý số lô/lô hàng
                </a>
                <a href="${pageContext.request.contextPath}/pharmacist/recordExpiredDamaged" class="active">
                    <i class="bi bi-exclamation-triangle"></i> Thuốc hết hạn/hư hỏng
                </a>
                <a href="${pageContext.request.contextPath}/report">
                    <i class="bi bi-graph-up"></i> Báo cáo thống kê
                </a>
            </div>
        </div>

        <!-- Main content -->
        <div class="main">
            <h2>Ghi nhận thuốc hết hạn / hư hỏng</h2>

            <!-- Form thêm -->
            <div class="form-container">
                <form action="${pageContext.request.contextPath}/pharmacist/recordExpiredDamaged" method="post" class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label">Medicine (Batch)</label>
                        <select name="batchId" class="form-select" required>
                            <option value="">-- Chọn lô thuốc --</option>
                            <c:forEach var="b" items="${batches}">
                                <option value="${b.batchId}">
                                    ${b.medicineName} (Lot: ${b.lotNumber}) - Qty: ${b.currentQuantity}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Loại</label>
                        <select name="type" class="form-select" required>
                            <option value="Expired">Hết hạn</option>
                            <option value="Damaged">Hư hỏng</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Số lượng</label>
                        <input type="number" name="quantity" class="form-control" min="1" required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Ghi chú</label>
                        <input type="text" name="notes" class="form-control" placeholder="Tuỳ chọn">
                    </div>
                    <div class="col-md-1 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="bi bi-plus-circle"></i> Add
                        </button>
                    </div>
                </form>
            </div>

            <!-- Bảng giao dịch -->
            <c:choose>
                <c:when test="${not empty transactions}">
                    <div class="table-container">
                        <table class="table table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Tên thuốc</th>
                                    <th>Số lô</th>
                                    <th>Người ghi nhận</th>
                                    <th>Loại</th>
                                    <th>Số lượng</th>
                                    <th>Ngày</th>
                                    <th>Ghi chú</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="t" items="${transactions}">
                                    <tr>
                                        <td><strong>${t.transactionId}</strong></td>
                                        <td>${t.medicineName}</td>
                                        <td>${t.lotNumber}</td>
                                        <td>${t.username}</td>
                                        <td>
                                            <span class="badge
                                                  <c:choose>
                                                      <c:when test="${t.type == 'Expired'}">bg-danger</c:when>
                                                      <c:when test="${t.type == 'Damaged'}">bg-warning</c:when>
                                                      <c:otherwise>bg-secondary</c:otherwise>
                                                  </c:choose>
                                                  ">
                                                ${t.type}
                                            </span>
                                        </td>
                                        <td>${t.quantity}</td>
                                        <td>${t.transactionDate}</td>
                                        <td>${t.notes}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-container">
                        <div class="empty-state">
                            <h3>Chưa có giao dịch nào</h3>
                            <p>Chưa có bản ghi thuốc hết hạn hoặc hư hỏng.</p>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <%@ include file="/admin/footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>