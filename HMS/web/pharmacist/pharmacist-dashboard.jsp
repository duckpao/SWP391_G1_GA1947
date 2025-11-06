<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
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
            margin-right: 8px;
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

        .menu-section {
            display: none;
        }

        .menu-section h6 {
            display: none;
        }

        /* Main content */
        .main {
            flex: 1;
            padding: 30px;
            background-color: #f9fafb;
            overflow-y: auto;
        }

        .page-header {
            margin-bottom: 30px;
        }

        .page-header h1 {
            font-size: 28px;
            font-weight: 700;
            color: #1f2937;
            letter-spacing: -0.5px;
            margin-bottom: 5px;
        }

        .page-header p {
            color: #6b7280;
            font-size: 14px;
        }

        /* Stats cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            border-left: 4px solid #6b7280;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
        }

        .stat-card.primary {
            border-left-color: #3b82f6;
        }

        .stat-card.success {
            border-left-color: #10b981;
        }

        .stat-card.warning {
            border-left-color: #f59e0b;
        }

        .stat-content {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
        }

        .stat-info h6 {
            font-size: 13px;
            font-weight: 600;
            color: #9ca3af;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stat-info h2 {
            font-size: 32px;
            font-weight: 700;
            color: #1f2937;
            margin: 0;
        }

        .stat-icon {
            font-size: 32px;
            opacity: 0.8;
        }

        /* Section card */
        .section-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            margin-bottom: 24px;
            overflow: hidden;
        }

        .section-header {
            background: white;
            padding: 20px 24px;
            border-bottom: 2px solid #e5e7eb;
        }

        .section-header h3 {
            font-size: 18px;
            font-weight: 700;
            color: #1f2937;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-body {
            padding: 24px;
        }

        /* List group */
        .notification-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .notification-item {
            padding: 16px 0;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .notification-item:last-child {
            border-bottom: none;
        }

        .notification-icon {
            font-size: 20px;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f3f4f6;
            border-radius: 8px;
            flex-shrink: 0;
        }

        .notification-text {
            flex: 1;
            font-size: 14px;
            color: #374151;
        }

        /* Logout button */
        .logout-section {
            margin-top: auto;
            padding: 15px 20px;
            border-top: 1px solid #e5e7eb;
        }

        .logout-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            width: 100%;
            padding: 12px;
            background-color: #6b7280;
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s ease;
            text-decoration: none;
            cursor: pointer;
        }

        .logout-btn:hover {
            background-color: #4b5563;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(107, 114, 128, 0.2);
            color: white;
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

            .page-header h1 {
                font-size: 22px;
            }

            .stats-grid {
                grid-template-columns: 1fr;
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
                <a href="${pageContext.request.contextPath}/dashboard" class="active">
                    🏠 Dashboard
                </a>
                
                <a href="${pageContext.request.contextPath}/view-medicine">
                    💊 Kho thuốc
                </a>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main">
            <div class="page-header">
                <h1>Chào mừng, ${sessionScope.username} 👋</h1>
                <p>Đây là tổng quan hoạt động của bạn</p>
            </div>

            <!-- Stats Grid -->
            <div class="stats-grid">
                <div class="stat-card primary">
                    <div class="stat-content">
                        <div class="stat-info">
                            <h6>Tổng số thuốc</h6>
                            <h2>${medicineCount}</h2>
                        </div>
                        <div class="stat-icon" style="color: #3b82f6;">
                            <i class="bi bi-capsule"></i>
                        </div>
                    </div>
                </div>

                <div class="stat-card success">
                    <div class="stat-content">
                        <div class="stat-info">
                            <h6>Số đơn thuốc</h6>
                            <h2>${prescriptionCount}</h2>
                        </div>
                        <div class="stat-icon" style="color: #10b981;">
                            <i class="bi bi-clipboard-check"></i>
                        </div>
                    </div>
                </div>

                <div class="stat-card warning">
                    <div class="stat-content">
                        <div class="stat-info">
                            <h6>Yêu cầu chờ duyệt</h6>
                            <h2>${pendingRequests}</h2>
                        </div>
                        <div class="stat-icon" style="color: #f59e0b;">
                            <i class="bi bi-clock-history"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Notifications -->
            <div class="section-card">
                <div class="section-header">
                    <h3>
                        <i class="bi bi-bell"></i>
                        Thông báo gần đây
                    </h3>
                </div>
                <div class="section-body">
                    <ul class="notification-list">
                        <li class="notification-item">
                            <div class="notification-icon" style="color: #3b82f6;">
                                <i class="bi bi-capsule"></i>
                            </div>
                            <div class="notification-text">
                                <strong>Cập nhật lô thuốc mới</strong> ngày ${latestBatchDate}
                            </div>
                        </li>
                        <li class="notification-item">
                            <div class="notification-icon" style="color: #f59e0b;">
                                <i class="bi bi-box-seam"></i>
                            </div>
                            <div class="notification-text">
                                <strong>Đơn hàng ${latestRequest}</strong> đang chờ xử lý
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="/admin/footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>