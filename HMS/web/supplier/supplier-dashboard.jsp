<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Supplier Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            display: flex;
            min-height: 100vh;
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }

        .sidebar {
            width: 250px;
            background: linear-gradient(180deg, #2b5876 0%, #4e4376 100%);
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

        .sidebar h5 {
            margin: 0;
            font-size: 16px;
        }

        .sidebar small {
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

        .logout-btn {
            margin-top: auto;
            padding: 12px 20px;
            background-color: #e74c3c;
            border: none;
            color: white;
            font-weight: 600;
            border-radius: 6px;
            text-align: center;
            margin: 20px;
            transition: 0.3s;
        }

        .logout-btn:hover {
            background-color: #c0392b;
        }

        .main {
            flex: 1;
            padding: 30px;
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
    </style>
</head>
<body>

    <!-- Sidebar -->
    <div class="sidebar">
        <div class="profile">
            <img src="https://cdn-icons-png.flaticon.com/512/1077/1077012.png" alt="Supplier">
            <h5>${sessionScope.supplierName}</h5>
            <small>Supplier</small>
        </div>

        <div class="menu-section">
            <h6>Trang chính</h6>
            <a href="${pageContext.request.contextPath}/supplier-dashboard" class="active">🏠 Dashboard</a>
        </div>

        <div class="menu-section">
            <h6>Quản lý</h6>
            <a href="${pageContext.request.contextPath}/purchase-orders">📦 Đơn hàng (PO)</a>
            <a href="${pageContext.request.contextPath}/asns">🚚 ASN của tôi</a>
            <a href="${pageContext.request.contextPath}/ASNServlet?action=createBySupplier">➕ Tạo ASN mới</a>
        </div>

        <div class="menu-section">
            <h6>Khác</h6>
            <a href="${pageContext.request.contextPath}/help">❓ Trợ giúp</a>
        </div>

        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">🚪 Đăng xuất</a>
    </div>

    <!-- Main content -->
    <div class="main">
        <h1>Chào mừng, ${sessionScope.supplierName} 👋</h1>

        <div class="row">
            <div class="col-md-4 mb-4">
                <div class="card text-center p-4">
                    <h5 class="card-title">Tổng số PO</h5>
                    <h2>${poCount}</h2>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card text-center p-4">
                    <h5 class="card-title">Tổng số ASN</h5>
                    <h2>${asnCount}</h2>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card text-center p-4">
                    <h5 class="card-title">ASN đang chờ duyệt</h5>
                    <h2>${pendingASN}</h2>
                </div>
            </div>
        </div>

        <hr>

        <h3 class="mt-4">Thông báo gần đây</h3>
        <ul class="list-group">
            <li class="list-group-item">📦 PO mới được giao: ${latestPO}</li>
            <li class="list-group-item">🚚 ASN ${latestASN} đang chờ xác nhận</li>
        </ul>
    </div>

</body>
</html>
