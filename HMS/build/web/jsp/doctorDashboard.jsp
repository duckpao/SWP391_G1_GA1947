<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Bảng điều khiển - Bác sĩ</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
                background: #ffffff;
                min-height: 100vh;
                padding: 40px 20px;
            }

            .container {
                width: 100%;
                max-width: 1200px;
                margin: 0 auto;
            }

            /* Header Section */
            .page-header {
                background: white;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                overflow: hidden;
                margin-bottom: 30px;
                animation: slideUp 0.5s ease;
            }

            @keyframes slideUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .header-section {
                background: white;
                color: #1f2937;
                padding: 40px 30px;
                text-align: center;
                border-bottom: 4px solid #6c757d;
            }

            .header-icon {
                width: 80px;
                height: 80px;
                background: #eff6ff;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 20px;
                font-size: 40px;
            }

            .header-section h1 {
                font-size: 28px;
                font-weight: 700;
                margin-bottom: 8px;
                color: #1f2937;
            }

            .header-section p {
                font-size: 14px;
                color: #6b7280;
            }

            /* Menu Grid */
            .menu-section {
                background: white;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                overflow: hidden;
                padding: 40px 30px;
                animation: slideUp 0.5s ease 0.1s both;
            }

            .menu-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
                gap: 24px;
            }

            .menu-card {
                background: #ffffff;
                border: 2px solid #e5e7eb;
                border-radius: 16px;
                padding: 32px 24px;
                text-align: center;
                text-decoration: none;
                transition: all 0.3s ease;
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
                background: linear-gradient(90deg, #6c757d, #95a5a6);
                transform: scaleX(0);
                transition: transform 0.3s ease;
            }

            .menu-card:hover::before {
                transform: scaleX(1);
            }

            .menu-card:hover {
                border-color: #6c757d;
                box-shadow: 0 8px 24px rgba(108, 117, 125, 0.2);
                transform: translateY(-4px);
            }

            .menu-icon {
                width: 70px;
                height: 70px;
                margin: 0 auto 20px;
                background: #f8f9fa;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 32px;
                transition: all 0.3s ease;
            }

            .menu-card:hover .menu-icon {
                background: #6c757d;
                transform: scale(1.1) rotate(5deg);
            }

            .menu-card:hover .menu-icon {
                color: white;
            }

            .menu-card h2 {
                color: #1f2937;
                margin-bottom: 12px;
                font-size: 18px;
                font-weight: 700;
            }

            .menu-card p {
                color: #6b7280;
                line-height: 1.6;
                font-size: 14px;
                margin: 0;
            }

            /* Icon Colors */
            .icon-primary {
                color: #6c757d;
            }
            .icon-success {
                color: #10b981;
            }
            .icon-info {
                color: #3b82f6;
            }
            .icon-warning {
                color: #f59e0b;
            }

            /* Responsive */
            @media (max-width: 768px) {
                body {
                    padding: 20px 15px;
                }

                .header-section h1 {
                    font-size: 24px;
                }

                .menu-grid {
                    grid-template-columns: 1fr;
                }

                .menu-section {
                    padding: 30px 20px;
                }
            }

            @media (max-width: 480px) {
                .header-icon {
                    width: 60px;
                    height: 60px;
                    font-size: 30px;
                }

                .menu-icon {
                    width: 60px;
                    height: 60px;
                    font-size: 28px;
                }
            }
        </style>
    </head>
    <body>
        <%@ include file="/admin/header.jsp" %>

        <div class="container">
            <!-- Header -->
            <div class="page-header">
                <div class="header-section">
                    <div class="header-icon">👨‍⚕️</div>
                    <h1>Chào mừng, Bác sĩ!</h1>
                    <p>Quản lý yêu cầu cấp phát thuốc và tra cứu thông tin thuốc</p>
                </div>
            </div>

            <!-- Menu Section -->
            <div class="menu-section">
                <div class="menu-grid">
                    <!-- Quản lý Yêu cầu -->
                    <a href="manage-requests" class="menu-card">
                        <div class="menu-icon">
                            <span class="icon-primary">📋</span>
                        </div>
                        <h2>Quản lý Yêu cầu</h2>
                        <p>Xem và quản lý các yêu cầu cấp phát thuốc của bạn</p>
                    </a>
                    <a href="view-request-history" class="menu-card">
                        <div class="menu-icon">
                            <span class="icon-info">📜</span>
                        </div>
                        <h2>Lịch sử Yêu cầu</h2>
                        <p>Xem lại lịch sử các yêu cầu đã thực hiện</p>
                    </a><a href="view-medicine?dashboard=doctor" class="menu-card">

                        <div class="menu-icon">
                            <span class="icon-warning">💊</span>
                        </div>
                        <h2>Danh sách Thuốc</h2>
                        <p>Tra cứu thông tin chi tiết về các loại thuốc có sẵn</p>
                    </a>
                    <!-- Tạo Yêu cầu Mới -->
                    <a href="create-request" class="menu-card">
                        <div class="menu-icon">
                            <span class="icon-success">✚</span>
                        </div>
                        <h2>Tạo Yêu cầu Mới</h2>
                        <p>Tạo yêu cầu cấp phát thuốc mới cho bệnh nhân</p>
                    </a>

                    <!-- Lịch sử Yêu cầu -->


                    <!-- Danh sách Thuốc -->

                </div>
            </div>
        </div>

        <%@ include file="/admin/footer.jsp" %>
    </body>
</html>