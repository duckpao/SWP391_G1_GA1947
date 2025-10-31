<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi mật khẩu</title>
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
            background: #f3f4f6;
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
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            border: 1px solid #e5e7eb;
        }

        .header {
            background: white;
            color: #1f2937;
            padding: 30px 40px;
            text-align: center;
            border-bottom: 2px solid #e5e7eb;
        }

        .header h1 {
            font-size: 28px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
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
            color: #1f2937;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-group input {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.3s ease;
            background: #f9fafb;
        }

        .form-group input:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-group input::placeholder {
            color: #9ca3af;
        }

        .match-status {
            font-size: 13px;
            font-weight: 600;
            margin-top: 6px;
            display: block;
            min-height: 20px;
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
            background: #3b82f6;
            color: white;
            margin-bottom: 16px;
        }

        .btn-save:hover {
            background: #2563eb;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(59, 130, 246, 0.3);
        }

        .btn-save:active {
            transform: translateY(0);
        }

        .btn-home {
            background: white;
            color: #3b82f6;
            border: 2px solid #3b82f6;
        }

        .btn-home:hover {
            background: #eff6ff;
            border-color: #2563eb;
            color: #2563eb;
        }

        .error-message {
            background: #fee2e2;
            color: #991b1b;
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 16px;
            border-left: 4px solid #dc2626;
            display: none;
        }

        .error-message.show {
            display: block;
        }

        .success-message {
            background: #d1fae5;
            color: #065f46;
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 16px;
            border-left: 4px solid #059669;
            display: none;
        }

        .success-message.show {
            display: block;
        }

        .divider {
            text-align: center;
            margin: 24px 0;
            color: #9ca3af;
            font-size: 13px;
        }

        .info-box {
            background: #eff6ff;
            border-left: 4px solid #3b82f6;
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 13px;
            color: #1e40af;
            margin-bottom: 24px;
            line-height: 1.5;
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
        function validatePassword() {
            const newPass = document.getElementById("newPassword").value;
            const confirm = document.getElementById("confirmPassword").value;
            const match = document.getElementById("match");
            
            if (confirm && newPass !== confirm) {
                match.textContent = "❌ Mật khẩu không khớp";
                match.style.color = "#dc2626";
            } else if (newPass && confirm && newPass === confirm) {
                match.textContent = "✅ Mật khẩu khớp";
                match.style.color = "#059669";
            } else {
                match.textContent = "";
            }
        }

        function handleSubmit(event) {
            const newPass = document.getElementById("newPassword").value;
            const confirm = document.getElementById("confirmPassword").value;
            
            if (newPass !== confirm) {
                event.preventDefault();
                alert("Mật khẩu không khớp!");
                return false;
            }
            
            if (newPass.length < 6) {
                event.preventDefault();
                alert("Mật khẩu mới phải có tối thiểu 6 ký tự!");
                return false;
            }
        }

        window.addEventListener('DOMContentLoaded', function() {
            const error = '${error}';
            const message = '${message}';
            
            if (error && error !== 'null' && error !== '') {
                document.querySelector('.error-message').textContent = error;
                document.querySelector('.error-message').classList.add('show');
            }
            
            if (message && message !== 'null' && message !== '') {
                document.querySelector('.success-message').textContent = message;
                document.querySelector('.success-message').classList.add('show');
                
                // Tự động chuyển trang sau 2 giây
                setTimeout(function() {
                    window.location.href = 'home.jsp'; // Thay đổi URL này theo trang chủ của bạn
                }, 2000);
            }
        });
    </script>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>
                <span class="header-icon">🔐</span>
                Đổi mật khẩu
            </h1>
        </div>

        <div class="content">
            <div class="error-message"></div>
            <div class="success-message"></div>

            <div class="info-box">
                <strong>ℹ️ Lưu ý bảo mật:</strong>
                Mật khẩu mới phải có tối thiểu 6 ký tự
            </div>

            <form action="change-password" method="post" onsubmit="handleSubmit(event)">
                <div class="form-group">
                    <label>Mật khẩu hiện tại</label>
                    <input type="password" name="currentPassword" placeholder="Nhập mật khẩu hiện tại" required>
                </div>

                <div class="form-group">
                    <label>Mật khẩu mới</label>
                    <input type="password" id="newPassword" name="newPassword" placeholder="Nhập mật khẩu mới (tối thiểu 6 ký tự)" onkeyup="validatePassword()" required minlength="6">
                </div>

                <div class="form-group">
                    <label>Xác nhận mật khẩu mới</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Xác nhận mật khẩu mới" onkeyup="validatePassword()" required minlength="6">
                    <span class="match-status" id="match"></span>
                </div>

                <button type="submit" class="btn btn-save">
                    💾 Lưu thay đổi
                </button>
            </form>

            <div class="divider">━━━━━━━━━━━━━━━━</div>

            <button onclick="history.back()" class="btn btn-home">
                👤 Quay lại
            </button>
        </div>
    </div>
</body>
</html>