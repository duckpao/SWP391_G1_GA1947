<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Hết hạn / Hư hỏng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
        <style>
            body {
                display: flex;
                min-height: 100vh;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f3f4f6;
            }
            /* Sidebar */
            .sidebar {
                width: 250px;
                background: linear-gradient(180deg, #6d28d9, #4f46e5);
                color: #fff;
                display: flex;
                flex-direction: column;
                padding-top: 15px;
            }
            .profile {
                text-align: center;
                margin-bottom: 15px;
                border-bottom: 1px solid rgba(255,255,255,0.1);
                padding-bottom: 10px;
            }
            .profile img {
                width: 60px;
                height: 60px;
                border-radius: 50%;
                border: 2px solid #a78bfa;
                margin-bottom: 10px;
            }
            .profile h5 {
                margin:0;
                color:#fff;
            }
            .profile span {
                font-size:13px;
                color:#d1d5db;
            }
            .menu a {
                display:flex;
                align-items:center;
                padding:12px 25px;
                color:#e5e7eb;
                text-decoration:none;
                font-size:14px;
                transition:0.3s;
            }
            .menu a i {
                width:20px;
                margin-right:10px;
            }
            .menu a:hover, .menu a.active {
                background-color: rgba(255,255,255,0.15);
                color:#fff;
            }
            /* Main content */
            .main {
                flex:1;
                padding:30px;
            }
            h2 {
                color:#111827;
                margin-bottom:25px;
                font-weight:600;
            }
            table {
                width:100%;
                border-collapse: collapse;
                background:#fff;
                box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            }
            thead {
                background: linear-gradient(135deg,#7c3aed,#6366f1);
                color:white;
            }
            th, td {
                padding:12px;
                border-bottom:1px solid #e5e7eb;
                text-align:center;
            }
            tr:hover {
                background-color:#f9fafb;
            }
            .btn {
                border-radius:6px;
                padding:4px 10px;
                font-size:14px;
            }
        </style>
    </head>

    <body>

        <!-- Sidebar -->
        <div class="sidebar">
            <div class="profile">
                <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png" alt="User">
                <h5>${sessionScope.username}</h5>
                <span>${sessionScope.role}</span>
            </div>
            <div class="menu">
                <a href="${pageContext.request.contextPath}/home.jsp"><i class="fa fa-home"></i> Trang chủ</a>
                <a href="${pageContext.request.contextPath}/view-medicine"><i class="fa fa-pills"></i> Quản lý thuốc</a>
                <a href="${pageContext.request.contextPath}/pharmacist/View_MedicineRequest"><i class="fa fa-file-medical"></i> Yêu cầu thuốc</a>
                <a href="${pageContext.request.contextPath}/pharmacist/manage-batch"><i class="fa fa-warehouse"></i> Quản lý số lô</a>
                <a href="${pageContext.request.contextPath}/pharmacist/recordExpiredDamaged" class="active"><i class="fa fa-exclamation-triangle"></i> Hết hạn / Hư hỏng</a>
                <a href="${pageContext.request.contextPath}/report"><i class="fa fa-chart-line"></i> Báo cáo</a>
                <a href="${pageContext.request.contextPath}/logout"><i class="fa fa-sign-out-alt"></i> Đăng xuất</a>
            </div>
        </div>

        <!-- Main content -->
        <div class="main">
            <h2>Ghi nhận thuốc hết hạn / hư hỏng</h2>

            <!-- ===== FORM THÊM ===== -->
            <form action="${pageContext.request.contextPath}/pharmacist/recordExpiredDamaged" method="post" class="row g-3 bg-white p-3 rounded shadow-sm mb-4">
                <div class="col-md-4">
                    <label class="form-label fw-bold">Medicine (Batch)</label>
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
                    <label class="form-label fw-bold">Loại</label>
                    <select name="type" class="form-select" required>
                        <option value="Expired">Hết hạn</option>
                        <option value="Damaged">Hư hỏng</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label fw-bold">Số lượng</label>
                    <input type="number" name="quantity" class="form-control" min="1" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold">Ghi chú</label>
                    <input type="text" name="notes" class="form-control" placeholder="Tuỳ chọn">
                </div>
                <div class="col-md-1 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary w-100">Add</button>
                </div>
            </form>

            <!-- ===== BẢNG GIAO DỊCH ===== -->
            <div class="table-responsive">
                <table class="table table-bordered align-middle">
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
                                <td>${t.transactionId}</td>
                                <td>${t.medicineName}</td>
                                <td>${t.lotNumber}</td>
                                <td>${t.username}</td>
                                <!-- Thêm màu cho cột Loại -->
                                <td>
                                    <span class="badge
                                          <c:choose>
                                              <c:when test="${t.type == 'Expired'}">bg-danger</c:when>
                                              <c:when test="${t.type == 'Damaged'}">bg-warning text-dark</c:when>
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
                        <c:if test="${empty transactions}">
                            <tr>
                                <td colspan="7" class="text-center text-muted py-3">Chưa có giao dịch</td>
                            </tr>
                        </c:if>
                    </tbody>

                </table>
            </div>
        </div>

    </body>
</html>
