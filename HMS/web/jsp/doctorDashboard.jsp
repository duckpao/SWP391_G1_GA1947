<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng điều khiển - Bác sĩ</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background: #ffffff;
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .header {
            background: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            border-top: 4px solid #6c757d;
        }

        .header h1 {
            color: #1f2937;
            margin-bottom: 10px;
            font-size: 28px;
        }

        .header p {
            color: #666;
            font-size: 16px;
        }

        .logout-btn {
            float: right;
            background: #6c757d;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
            transition: background 0.3s;
        }

        .logout-btn:hover {
            background: #5a6268;
        }

        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .menu-card {
            background: white;
            padding: 40px 30px;
            border-radius: 15px;
            text-align: center;
            text-decoration: none;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s, box-shadow 0.3s;
            border-top: 4px solid #6c757d;
        }

        .menu-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .menu-icon {
            font-size: 60px;
            margin-bottom: 20px;
        }

        .menu-card h2 {
            color: #1f2937;
            margin-bottom: 15px;
            font-size: 22px;
        }

        .menu-card p {
            color: #666;
            line-height: 1.6;
            font-size: 15px;
        }

        .clear {
            clear: both;
        }
    </style>
</head>
<%@ include file="header.jsp" %>
<body>
    <div class="container">
        <div class="header">
            <h1>Chào mừng, Bác sĩ! 👨‍⚕️</h1>
            <p>Quản lý yêu cầu cấp phát thuốc và tra cứu thông tin thuốc</p>
            <div class="clear"></div>
        </div>

        <div class="menu-grid">
            <a href="manage-requests" class="menu-card">
                <div class="menu-icon">📋</div>
                <h2>Quản lý Yêu cầu Cấp phát</h2>
                <p>Xem và quản lý các yêu cầu cấp phát thuốc</p>
            </a>

            <a href="view-medicine" class="menu-card">
                <div class="menu-icon">💊</div>
                <h2>Xem Danh sách Thuốc</h2>
                <p>Tra cứu thông tin chi tiết về các loại thuốc</p>
            </a>
        </div>
    </div>
</body>
<%@ include file="footer.jsp" %>
</html>
