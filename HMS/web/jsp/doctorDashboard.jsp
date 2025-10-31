<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng điều khiển - Bác sĩ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    
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
            flex: 1;
            min-height: calc(100vh - 60px);
        }

        /* Main content */
        .main {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 20px;
            background-color: #f9fafb;
        }

        .page-header {
            background: white;
            padding: 30px;
            border-radius: 12px;
            margin-bottom: 30px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            border-left: 4px solid #6b7280;
        }

        .page-header h1 {
            color: #1f2937;
            margin-bottom: 10px;
            font-size: 28px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .page-header p {
            color: #6b7280;
            font-size: 15px;
            margin: 0;
        }

        /* Menu grid */
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 24px;
        }

        .menu-card {
            background: white;
            padding: 40px 30px;
            border-radius: 12px;
            text-align: center;
            text-decoration: none;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            border-top: 4px solid #6b7280;
            position: relative;
            overflow: hidden;
        }

        .menu-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #6b7280, #9ca3af);
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }

        .menu-card:hover::before {
            transform: scaleX(1);
        }

        .menu-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 30px rgba(0,0,0,0.12);
        }

        .menu-icon {
            width: 80px;
            height: 80px;
            margin: 0 auto 20px;
            background: #f3f4f6;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            transition: all 0.3s ease;
        }

        .menu-card:hover .menu-icon {
            background: #6b7280;
            transform: scale(1.1);
        }

        .menu-card:hover .menu-icon i {
            color: white;
        }

        .menu-icon i {
            color: #6b7280;
            transition: color 0.3s ease;
        }

        .menu-card h2 {
            color: #1f2937;
            margin-bottom: 12px;
            font-size: 20px;
            font-weight: 700;
        }

        .menu-card p {
            color: #6b7280;
            line-height: 1.6;
            font-size: 14px;
            margin: 0;
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
            .main {
                padding: 20px 15px;
            }

            .page-header {
                padding: 24px 20px;
            }

            .page-header h1 {
                font-size: 22px;
            }

            .menu-grid {
                grid-template-columns: 1fr;
            }

            .menu-card {
                padding: 30px 20px;
            }
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="page-wrapper">
        <!-- Main content -->
        <div class="main">
            <div class="page-header">
                <h1>
                    <i class="bi bi-person-circle"></i>
                    Chào mừng, Bác sĩ!
                </h1>
                <p>Quản lý yêu cầu cấp phát thuốc và tra cứu thông tin thuốc</p>
            </div>

            <div class="menu-grid">
                <a href="manage-requests" class="menu-card">
                    <div class="menu-icon">
                        <i class="bi bi-clipboard-check"></i>
                    </div>
                    <h2>Quản lý Yêu cầu Cấp phát</h2>
                    <p>Xem và quản lý các yêu cầu cấp phát thuốc của bạn</p>
                </a>

                <a href="view-medicine" class="menu-card">
                    <div class="menu-icon">
                        <i class="bi bi-capsule"></i>
                    </div>
                    <h2>Xem Danh sách Thuốc</h2>
                    <p>Tra cứu thông tin chi tiết về các loại thuốc có sẵn</p>
                </a>
            </div>
        </div>
    </div>

    <%@ include file="footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>