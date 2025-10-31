<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh Sửa Hồ Sơ</title>
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
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .container {
            width: 100%;
            max-width: 500px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
            border: 1px solid #e9ecef;
            overflow: hidden;
        }
        .header {
            background: white;
            color: #2c3e50;
            padding: 30px 40px;
            text-align: center;
            border-bottom: 2px solid #e9ecef;
        }
        .header h1 {
            font-size: 28px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            color: #2c3e50;
        }
        .header-icon {
            font-size: 32px;
        }
        .content {
            padding: 40px;
        }
        .form-group {
            margin-bottom: 24px;
        }
        .form-group label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .form-group input {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #dee2e6;
            border-radius: 8px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.3s ease;
            background: #f8f9fa;
            color: #2c3e50;
        }
        .form-group input:focus {
            outline: none;
            border-color: #6c757d;
            background: white;
            box-shadow: 0 0 0 3px rgba(108, 117, 125, 0.1);
        }
        .form-group input:disabled {
            background-color: #e9ecef;
            cursor: not-allowed;
            color: #6c757d;
        }
        .form-group input::placeholder {
            color: #adb5bd;
        }
        .btn {
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        .btn-save {
            background: #495057;
            color: white;
            margin-bottom: 16px;
            border: 1px solid #343a40;
        }
        .btn-save:hover {
            background: #343a40;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(52, 58, 64, 0.2);
        }
        .btn-save:active {
            transform: translateY(0);
        }
        .btn-back {
            background: white;
            color: #6c757d;
            border: 2px solid #6c757d;
        }
        .btn-back:hover {
            background: #6c757d;
            color: white;
        }
        .error-message {
            background: #ffebee;
            color: #c62828;
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 16px;
            border-left: 4px solid #ef5350;
            display: none;
            border: 1px solid #ef9a9a;
        }
        .error-message.show {
            display: block;
        }
        .divider {
            text-align: center;
            margin: 24px 0;
            color: #adb5bd;
            font-size: 13px;
        }
        .info-box {
            background: #e3f2fd;
            border-left: 4px solid #90caf9;
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 13px;
            color: #1565c0;
            margin-bottom: 24px;
            line-height: 1.5;
            border: 1px solid #90caf9;
        }
        .info-box strong {
            display: block;
            margin-bottom: 4px;
        }
        @media (max-width: 640px) {
            .header {
                padding: 24px;
            }
            .header h1 {
                font-size: 22px;
            }
            .content {
                padding: 24px;
            }
        }
    </style>
    <script>
        window.addEventListener('DOMContentLoaded', function() {
            const error = '${error}';
           
            if (error && error !== 'null' && error !== '') {
                document.querySelector('.error-message').textContent = error;
                document.querySelector('.error-message').classList.add('show');
            }
        });
        function validatePhone(input) {
            const phone = input.value.replace(/\D/g, '');
            if (phone.length > 11) {
                input.value = phone.substring(0, 11);
            } else {
                input.value = phone;
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>
                <span class="header-icon">✏️</span>
                Chỉnh Sửa Hồ Sơ
            </h1>
        </div>
        <div class="content">
            <div class="error-message"></div>
            <div class="info-box">
                <strong>ℹ️ Lưu ý:</strong>
                Bạn chỉ có thể chỉnh sửa tên đăng nhập và số điện thoại. Nếu bạn là Supplier, bạn có thể chỉnh sửa thêm tên công ty và địa chỉ. Email không thể thay đổi.
            </div>
            <form action="edit-profile" method="post">
                <div class="form-group">
                    <label>Email (Không thể thay đổi)</label>
                    <input type="email" value="${sessionScope.user.email}" disabled>
                </div>
                <div class="form-group">
                    <label>Tên Đăng Nhập</label>
                    <input type="text" name="username" value="${sessionScope.user.username}"
                           placeholder="Nhập tên đăng nhập" required maxlength="50">
                </div>
                <div class="form-group">
                    <label>Số Điện Thoại</label>
                    <input type="tel" name="phone" value="${sessionScope.user.phone}"
                           placeholder="Nhập số điện thoại (10-11 chữ số)"
                           required pattern="[0-9]{10,11}"
                           oninput="validatePhone(this)" maxlength="11">
                </div>
                <c:if test="${sessionScope.user.role == 'Supplier'}">
                    <div class="form-group">
                        <label>Tên Công Ty</label>
                        <input type="text" name="companyName" value="${supplier.name}"
                               placeholder="Nhập tên công ty" required maxlength="100">
                    </div>
                    <div class="form-group">
                        <label>Địa Chỉ</label>
                        <input type="text" name="address" value="${supplier.address}"
                               placeholder="Nhập địa chỉ công ty" maxlength="200">
                    </div>
                </c:if>
                <button type="submit" class="btn btn-save">
                    💾 Lưu Thay Đổi
                </button>
            </form>
            <div class="divider">━━━━━━━━━━━━━━━━</div>
            <button onclick="window.location.href='profile'" class="btn btn-back">
                ← Quay Lại Hồ Sơ
            </button>
        </div>
    </div>
</body>
</html>