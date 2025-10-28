<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ - Hệ thống quản lý kho bệnh viện</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
        }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1 {
            font-size: 28px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .header-icon {
            width: 40px;
            height: 40px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .user-info span {
            font-size: 14px;
            font-weight: 500;
            opacity: 0.95;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-logout {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .btn-logout:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
        }

        .btn-login {
            background: white;
            color: #667eea;
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .content {
            padding: 40px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 24px;
            margin-bottom: 40px;
        }

        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 28px;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(102, 126, 234, 0.4);
        }

        .stat-card:hover::before {
            opacity: 1;
        }

        .stat-icon {
            font-size: 36px;
            margin-bottom: 12px;
            display: block;
        }

        .stat-label {
            font-size: 14px;
            font-weight: 500;
            opacity: 0.9;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stat-value {
            font-size: 42px;
            font-weight: 700;
            line-height: 1;
        }

        .section-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.07);
            margin-bottom: 28px;
            overflow: hidden;
            border: 1px solid #e5e7eb;
        }

        .section-header {
            padding: 24px 28px;
            background: linear-gradient(135deg, #f9fafb 0%, #f3f4f6 100%);
            border-bottom: 2px solid #e5e7eb;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .section-header h2 {
            font-size: 20px;
            font-weight: 700;
            color: #1f2937;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-icon {
            font-size: 24px;
        }

        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background: #f9fafb;
        }

        th {
            padding: 16px 20px;
            text-align: left;
            font-weight: 600;
            font-size: 13px;
            color: #374151;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 2px solid #e5e7eb;
        }

        td {
            padding: 18px 20px;
            border-bottom: 1px solid #f3f4f6;
            font-size: 14px;
            color: #1f2937;
        }

        tbody tr {
            transition: all 0.2s ease;
        }

        tbody tr:hover {
            background: #f9fafb;
            transform: scale(1.01);
        }

        .badge {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }

        .badge-warning {
            background: #fef3c7;
            color: #92400e;
        }

        .badge-success {
            background: #d1fae5;
            color: #065f46;
        }

        .badge-info {
            background: #dbeafe;
            color: #1e40af;
        }

        .badge-danger {
            background: #fee2e2;
            color: #991b1b;
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6b7280;
        }

        .empty-icon {
            font-size: 64px;
            margin-bottom: 16px;
            opacity: 0.5;
        }

        .empty-state h3 {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 8px;
            color: #374151;
        }

        .empty-state p {
            font-size: 14px;
            color: #6b7280;
        }

        .row-number {
            font-weight: 600;
            color: #6b7280;
        }

        .medicine-name {
            font-weight: 600;
            color: #1f2937;
        }

        .lot-number {
            font-family: 'Courier New', monospace;
            background: #f3f4f6;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 13px;
        }

        .quantity-low {
            color: #dc2626;
            font-weight: 600;
        }

        .quantity-medium {
            color: #f59e0b;
            font-weight: 600;
        }

        .quantity-high {
            color: #059669;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>
                <span class="header-icon">🏥</span>
                Quản lý kho bệnh viện
            </h1>
            <div class="user-info">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <span>👤 Xin chào, <strong>${sessionScope.user.username}</strong></span>
                        <a href="javascript:void(0)" onclick="confirmLogout()" class="btn btn-logout">
                            🚪 Đăng xuất
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-login">
                            🔐 Đăng nhập
                        </a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-login">
                            📝 Đăng ký
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="content">
            <!-- Thống kê -->
            <div class="stats-grid">
                <div class="stat-card">
                    <span class="stat-icon">💊</span>
                    <div class="stat-label">Thuốc</div>
                    <div class="stat-value">${stats.totalMedicines}</div>
                </div>
                <div class="stat-card">
                    <span class="stat-icon">📦</span>
                    <div class="stat-label">Lô thuốc</div>
                    <div class="stat-value">${stats.totalBatches}</div>
                </div>
                <div class="stat-card">
                    <span class="stat-icon">🧾</span>
                    <div class="stat-label">Hóa đơn</div>
                    <div class="stat-value">${stats.totalInvoices}</div>
                </div>
                <div class="stat-card">
                    <span class="stat-icon">💳</span>
                    <div class="stat-label">Giao dịch</div>
                    <div class="stat-value">${stats.totalTransactions}</div>
                </div>
            </div>

            <!-- Lô thuốc sắp hết hạn -->
            <div class="section-card">
                <div class="section-header">
                    <h2>
                        <span class="section-icon">⚠️</span>
                        Lô thuốc sắp hết hạn (≤ 60 ngày)
                    </h2>
                </div>
                <div class="table-container">
                    <c:choose>
                        <c:when test="${empty expiringBatches}">
                            <div class="empty-state">
                                <div class="empty-icon">✅</div>
                                <h3>Tuyệt vời!</h3>
                                <p>Không có lô thuốc nào sắp hết hạn</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table>
                                <thead>
                                    <tr>
                                        <th style="width: 60px;">#</th>
                                        <th>Tên thuốc</th>
                                        <th>Số lô</th>
                                        <th>Hạn sử dụng</th>
                                        <th>Số lượng còn</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="b" items="${expiringBatches}" varStatus="loop">
                                        <tr>
                                            <td><span class="row-number">${loop.index + 1}</span></td>
                                            <td><span class="medicine-name">${b.medicineName}</span></td>
                                            <td><span class="lot-number">${b.lotNumber}</span></td>
                                            <td>
                                                <span class="badge badge-warning">
                                                    📅 ${b.expiryDate}
                                                </span>
                                            </td>
                                            <td>
                                                <span class="${b.currentQuantity < 50 ? 'quantity-low' : b.currentQuantity < 100 ? 'quantity-medium' : 'quantity-high'}">
                                                    ${b.currentQuantity}
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Đơn hàng gần đây -->
            <div class="section-card">
                <div class="section-header">
                    <h2>
                        <span class="section-icon">📋</span>
                        Đơn hàng gần đây
                    </h2>
                </div>
                <div class="table-container">
                    <c:choose>
                        <c:when test="${empty recentOrders}">
                            <div class="empty-state">
                                <div class="empty-icon">📭</div>
                                <h3>Chưa có đơn hàng</h3>
                                <p>Không có đơn hàng nào gần đây</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table>
                                <thead>
                                    <tr>
                                        <th style="width: 60px;">#</th>
                                        <th>Mã đơn hàng</th>
                                        <th>Nhà cung cấp</th>
                                        <th>Ngày đặt</th>
                                        <th>Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="po" items="${recentOrders}" varStatus="loop">
                                        <tr>
                                            <td><span class="row-number">${loop.index + 1}</span></td>
                                            <td>
                                                <strong style="color: #667eea;">PO-${po.poId}</strong>
                                            </td>
                                            <td>${po.supplierName}</td>
                                            <td>
                                                <span class="badge badge-info">
                                                    📅 ${po.orderDate}
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge ${po.status == 'Completed' ? 'badge-success' : po.status == 'Pending' ? 'badge-warning' : 'badge-info'}">
                                                    ${po.status}
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Giao dịch gần đây -->
            <div class="section-card">
                <div class="section-header">
                    <h2>
                        <span class="section-icon">💰</span>
                        Giao dịch gần đây
                    </h2>
                </div>
                <div class="table-container">
                    <c:choose>
                        <c:when test="${empty recentTransactions}">
                            <div class="empty-state">
                                <div class="empty-icon">💤</div>
                                <h3>Chưa có giao dịch</h3>
                                <p>Không có giao dịch nào gần đây</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table>
                                <thead>
                                    <tr>
                                        <th style="width: 60px;">#</th>
                                        <th>Loại</th>
                                        <th>Tên thuốc</th>
                                        <th>Số lượng</th>
                                        <th>Ngày giao dịch</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="t" items="${recentTransactions}" varStatus="loop">
                                        <tr>
                                            <td><span class="row-number">${loop.index + 1}</span></td>
                                            <td>
                                                <span class="badge ${t.type == 'IN' ? 'badge-success' : 'badge-danger'}">
                                                    ${t.type == 'IN' ? '➕ Nhập' : '➖ Xuất'}
                                                </span>
                                            </td>
                                            <td><span class="medicine-name">${t.medicineName}</span></td>
                                            <td>
                                                <strong style="color: ${t.type == 'IN' ? '#059669' : '#dc2626'};">
                                                    ${t.type == 'IN' ? '+' : '-'}${t.quantity}
                                                </strong>
                                            </td>
                                            <td>
                                                <span class="badge badge-info">
                                                    📅 ${t.transactionDate}
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <script>
        function confirmLogout() {
            if (confirm("Bạn có chắc chắn muốn đăng xuất không?")) {
                window.location.href = 'logout';
            }
        }
    </script>
</body>
</html>