<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <style>
            body {
                display: flex;
                min-height: 100vh;
                margin: 0;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f5f5f5;
            }

            /* Sidebar */
            .sidebar {
                width: 250px;
                background: linear-gradient(180deg, #6a11cb 0%, #2575fc 100%);
                color: white;
                display: flex;
                flex-direction: column;
                padding: 20px 0;
            }

            .sidebar .profile {
                text-align: center;
                margin-bottom: 30px;
            }

            .sidebar .profile img {
                width: 70px;
                height: 70px;
                border-radius: 50%;
                margin-bottom: 10px;
                border: 2px solid #fff;
            }

            .sidebar .profile h5 {
                font-size: 16px;
                margin: 0;
            }

            .sidebar .profile small {
                color: #d0d0d0;
            }

            .sidebar a {
                color: white;
                text-decoration: none;
                padding: 12px 20px;
                display: block;
                transition: 0.3s;
                font-weight: 500;
            }

            .sidebar a:hover, .sidebar a.active {
                background-color: rgba(255, 255, 255, 0.2);
                border-left: 5px solid #fff;
            }

            .sidebar .menu-section {
                margin-top: 15px;
            }

            .sidebar .menu-section h6 {
                font-size: 13px;
                margin-left: 20px;
                margin-bottom: 8px;
                color: #d0d0d0;
                text-transform: uppercase;
            }

            /* Main content */
            .main {
                flex: 1;
                padding: 30px;
            }

            .main h1 {
                font-size: 28px;
                margin-bottom: 20px;
                font-weight: 600;
            }

            .card {
                border: none;
                border-radius: 12px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                transition: transform 0.3s;
            }

            .card:hover {
                transform: translateY(-5px);
            }

            .card-title {
                font-size: 18px;
                font-weight: 600;
            }

            .logout-btn {
                margin-top: auto;
                padding: 12px 20px;
                background-color: #e74c3c;
                border: none;
                color: white;
                font-weight: 600;
                border-radius: 6px;
                text-align: center;
                transition: 0.3s;
                margin: 20px;
            }

            .logout-btn:hover {
                background-color: #c0392b;
            }
        </style>
    </head>
    <body>

        <!-- Sidebar -->
        <div class="sidebar">
            <div class="profile">
                <img src="https://cdn-icons-png.flaticon.com/512/3135/3135715.png" alt="User">
                <h5>${sessionScope.username}</h5>
                <small>${sessionScope.role}</small>
            </div>

            <div class="menu-section">
                <h6>Trang chính</h6>
                <a href="${pageContext.request.contextPath}/dashboard" class="active">🏠 Dashboard</a>
            </div>

            <div class="menu-section">
                <h6>Chức năng</h6>
                <c:if test="${sessionScope.role eq 'Pharmacist' || sessionScope.role eq 'Doctor'}">
                    <a href="${pageContext.request.contextPath}/view-medicine">💊 Kho thuốc</a>
                </c:if>
                <c:if test="${sessionScope.role eq 'Doctor'}">
                    <a href="${pageContext.request.contextPath}/prescriptions">📋 Kê đơn thuốc</a>
                </c:if>
                <c:if test="${sessionScope.role eq 'Admin'}">
                    <a href="${pageContext.request.contextPath}/manage-users">👥 Quản lý người dùng</a>
                    <a href="${pageContext.request.contextPath}/reports">📊 Báo cáo thống kê</a>
                </c:if>
                <c:if test="${sessionScope.role eq 'Supplier'}">
                    <a href="${pageContext.request.contextPath}/supplier/create-asn.jsp">📃 Tạo ASN mới</a>
                    <a href="${pageContext.request.contextPath}/supplier/view-asn.jsp">📦 Xem ASN đã gửi</a>
                    <a href="${pageContext.request.contextPath}/reports">📊 Báo cáo thống kê</a>
                </c:if>
            </div>

            <div class="menu-section">
                <h6>Khác</h6>
                <a href="${pageContext.request.contextPath}/help">❓ Trợ giúp</a>
            </div>

            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">🚪 Đăng xuất</a>
        </div>

        <!-- Main Content -->
        <div class="main">
            <h1>Chào mừng, ${sessionScope.username} 👋</h1>

            <div class="row">
                <div class="col-md-4 mb-4">
                    <div class="card text-center p-4">
                        <h5 class="card-title">Tổng số thuốc</h5>
                        <h2>${medicineCount}</h2>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="card text-center p-4">
                        <h5 class="card-title">Số đơn thuốc</h5>
                        <h2>${prescriptionCount}</h2>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="card text-center p-4">
                        <h5 class="card-title">Yêu cầu chờ duyệt</h5>
                        <h2>${pendingRequests}</h2>
                    </div>
                </div>
            </div>

            <hr>

            <h3 class="mt-4">Thông báo gần đây</h3>
            <ul class="list-group">
                <li class="list-group-item">💊 Cập nhật lô thuốc mới ngày ${latestBatchDate}</li>
                <li class="list-group-item">📦 Đơn hàng ${latestRequest} đang chờ xử lý</li>
            </ul>
        </div>

    </body>
</html>
