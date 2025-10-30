<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách yêu cầu thuốc</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            display: flex;
            min-height: 100vh;
            background-color: #f3f4f6;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
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
            margin: 0;
            color: #fff;
        }

        .profile span {
            font-size: 13px;
            color: #d1d5db;
        }

        .menu a {
            display: flex;
            align-items: center;
            padding: 12px 25px;
            color: #e5e7eb;
            text-decoration: none;
            font-size: 14px;
            transition: 0.3s;
        }

        .menu a i {
            width: 20px;
            margin-right: 10px;
        }

        .menu a:hover, .menu a.active {
            background-color: rgba(255,255,255,0.15);
            color: #fff;
        }

        /* Main content */
        .main {
            flex: 1;
            padding: 30px;
        }

        h2 {
            color: #111827;
            margin-bottom: 25px;
            font-weight: 600;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }

        thead {
            background: linear-gradient(135deg, #7c3aed, #6366f1);
            color: white;
        }

        th, td {
            padding: 12px;
            border-bottom: 1px solid #e5e7eb;
            text-align: center;
        }

        tr:hover {
            background-color: #f9fafb;
        }

        .status {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 500;
        }

        .status.Pending { background-color: #fff3cd; color: #856404; }
        .status.Approved { background-color: #d4edda; color: #155724; }
        .status.Fulfilled { background-color: #cce5ff; color: #004085; }
        .status.Canceled { background-color: #f8d7da; color: #721c24; }

        /* Nút xử lý */
        .btn-approve {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 6px 14px;
            border-radius: 8px;
            font-size: 14px;
            transition: 0.3s;
        }
        .btn-approve:hover { background-color: #45a049; }

        .btn-reject {
            background-color: #f44336;
            color: white;
            border: none;
            padding: 6px 14px;
            border-radius: 8px;
            font-size: 14px;
            transition: 0.3s;
        }
        .btn-reject:hover { background-color: #e53935; }
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
        <a href="${pageContext.request.contextPath}/pharmacist/View_MedicineRequest" class="active"><i class="fa fa-file-medical"></i> Yêu cầu thuốc</a>
        <a href="${pageContext.request.contextPath}/pharmacist/manage-batch"><i class="fa fa-warehouse"></i> Quản lý số lô</a>
        <a href="${pageContext.request.contextPath}/pharmacist/recordExpiredDamaged"><i class="fa fa-exclamation-triangle"></i> Hết hạn / Hư hỏng</a>
        <a href="${pageContext.request.contextPath}/report"><i class="fa fa-chart-line"></i> Báo cáo</a>
        <a href="${pageContext.request.contextPath}/logout"><i class="fa fa-sign-out-alt"></i> Đăng xuất</a>
    </div>
</div>

<!-- Main content -->
<div class="main">
    <h2>Danh sách yêu cầu thuốc</h2>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <div class="table-responsive">
        <table class="table table-bordered align-middle">
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
                </tr>
            </thead>
            <tbody>
                <c:forEach var="req" items="${requestList}">
                    <tr>
                        <td>${req.requestId}</td>
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
                                    <!-- Chấp nhận -->
                                    <form action="${pageContext.request.contextPath}/PharmacistUpdateRequest" method="get" style="display:inline;">
                                        <input type="hidden" name="action" value="approve"/>
                                        <input type="hidden" name="requestId" value="${req.requestId}"/>
                                        <button type="submit" class="btn btn-success btn-sm">Chấp nhận</button>
                                    </form>
                                    <!-- Từ chối với lý do -->
                                    <form action="${pageContext.request.contextPath}/PharmacistUpdateRequest" method="get" style="display:inline;" onsubmit="return addRejectReason(this)">
                                        <input type="hidden" name="action" value="reject"/>
                                        <input type="hidden" name="requestId" value="${req.requestId}"/>
                                        <input type="hidden" name="reason" value=""/>
                                        <button type="submit" class="btn btn-danger btn-sm">Từ chối</button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary">Đã xử lý</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<script>
function addRejectReason(form) {
    var reason = prompt("Nhập lý do từ chối yêu cầu:");
    if(reason == null || reason.trim() === "") {
        alert("Bạn phải nhập lý do từ chối!");
        return false; // Hủy submit
    }
    form.reason.value = reason;
    return true;
}
</script>


</body>
</html>
