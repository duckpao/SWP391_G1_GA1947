<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký tài khoản</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: #f0f2f5;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .container {
            width: 100%;
            max-width: 500px;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
            overflow: hidden;
        }

        .header {
            background: #ffffff;
            padding: 48px 40px 32px;
            text-align: center;
        }

        .icon-circle {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #e8f0fe 0%, #d3e3fd 100%);
            border-radius: 50%;
            margin: 0 auto 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 36px;
        }

        .header h1 {
            font-size: 28px;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 8px;
        }

        .header p {
            font-size: 14px;
            color: #6b7280;
            font-weight: 400;
        }

        .divider {
            height: 1px;
            background: #e5e7eb;
            margin: 0 40px;
        }

        .content {
            padding: 32px 40px 40px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }

        .input-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input-icon {
            position: absolute;
            left: 16px;
            font-size: 18px;
            z-index: 1;
        }

        .form-group input {
            width: 100%;
            padding: 14px 16px 14px 48px;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-family: inherit;
            background: #f3f4f6;
            color: #1f2937;
            transition: all 0.2s ease;
        }

        .form-group input:focus {
            outline: none;
            background: #e5e7eb;
        }

        .form-group input::placeholder {
            color: #9ca3af;
        }

        .password-toggle {
            position: absolute;
            right: 16px;
            cursor: pointer;
            font-size: 18px;
            z-index: 1;
            user-select: none;
        }

        .password-strength {
            font-size: 12px;
            font-weight: 500;
            margin-top: 8px;
            display: inline-block;
        }

        .match-status {
            font-size: 12px;
            font-weight: 500;
            margin-top: 8px;
            display: block;
            min-height: 18px;
        }

        .btn {
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-top: 8px;
        }

        .btn-register {
            background: #6b7280;
            color: #ffffff;
        }

        .btn-register:hover {
            background: #4b5563;
        }

        .btn-register:active {
            transform: scale(0.98);
        }

        .error-message {
            background: #fef2f2;
            color: #991b1b;
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 500;
            margin-bottom: 16px;
            border-left: 3px solid #dc2626;
            display: none;
        }

        .error-message.show {
            display: block;
        }

        .success-message {
            background: #f0fdf4;
            color: #065f46;
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 500;
            margin-bottom: 16px;
            border-left: 3px solid #10b981;
            display: none;
        }

        .success-message.show {
            display: block;
        }

        .footer-links {
            text-align: center;
            padding: 24px 40px 32px;
            border-top: 1px solid #e5e7eb;
            font-size: 14px;
            color: #6b7280;
        }

        .footer-links a {
            color: #6b7280;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s ease;
        }

        .footer-links a:hover {
            color: #374151;
        }

        .separator {
            margin: 0 12px;
            color: #d1d5db;
        }

        @media (max-width: 640px) {
            .header {
                padding: 40px 24px 24px;
            }

            .content {
                padding: 24px;
            }

            .footer-links {
                padding: 20px 24px 28px;
            }

            .divider {
                margin: 0 24px;
            }
        }
    </style>
    <script>
        function togglePassword(inputId, iconId) {
            const input = document.getElementById(inputId);
            const icon = document.getElementById(iconId);
            
            if (input.type === 'password') {
                input.type = 'text';
                icon.textContent = '🙈';
            } else {
                input.type = 'password';
                icon.textContent = '👁️';
            }
        }

        function validatePassword() {
            const password = document.getElementById("password").value;
            const confirm = document.getElementById("confirmPassword").value;
            const strength = document.getElementById("strength");

            let msg = "Yếu";
            let color = "#dc2626";
            let regexStrong = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/;
            
            if (regexStrong.test(password)) {
                msg = "Mạnh";
                color = "#059669";
            } else if (password.length >= 6) {
                msg = "Trung bình";
                color = "#f59e0b";
            } else {
                msg = "Yếu";
                color = "#dc2626";
            }
            
            strength.textContent = "💪 Độ mạnh: " + msg;
            strength.style.color = color;

            if (confirm && password !== confirm) {
                document.getElementById("match").textContent = "❌ Mật khẩu không khớp";
                document.getElementById("match").style.color = "#dc2626";
            } else if (confirm && password === confirm) {
                document.getElementById("match").textContent = "✓ Mật khẩu khớp";
                document.getElementById("match").style.color = "#059669";
            } else {
                document.getElementById("match").textContent = "";
            }
        }

        function handleSubmit(event) {
            const password = document.getElementById("password").value;
            const confirm = document.getElementById("confirmPassword").value;
            
            if (password !== confirm) {
                event.preventDefault();
                alert("Mật khẩu không khớp!");
                return false;
            }
        }

        window.addEventListener('DOMContentLoaded', function() {
            const error = '${error}';
            const message = '${message}';
            
            if (error) {
                document.querySelector('.error-message').textContent = error;
                document.querySelector('.error-message').classList.add('show');
            }
            
            if (message) {
                document.querySelector('.success-message').textContent = message;
                document.querySelector('.success-message').classList.add('show');
            }
        });
    </script>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="icon-circle">✨</div>
            <h1>Đăng ký</h1>
            <p>Hệ thống quản lý kho bệnh viện</p>
        </div>

        <div class="divider"></div>

        <div class="content">
            <div class="error-message"></div>
            <div class="success-message"></div>

            <form action="register" method="post" onsubmit="handleSubmit(event)">
                <div class="form-group">
                    <label>Họ và tên</label>
                    <div class="input-wrapper">
                        <span class="input-icon">👤</span>
                        <input type="text" name="username" placeholder="Nguyễn Văn A" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>Email hoặc Username</label>
                    <div class="input-wrapper">
                        <span class="input-icon">📧</span>
                        <input type="email" name="email" placeholder="example@email.com" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>Số điện thoại</label>
                    <div class="input-wrapper">
                        <span class="input-icon">📱</span>
                        <input type="text" name="phone" placeholder="0912345678" required>
                    </div>
                </div>

                <div class="form-group">
                    <label>Mật khẩu</label>
                    <div class="input-wrapper">
                        <span class="input-icon">🔒</span>
                        <input type="password" id="password" name="password" placeholder="••••••" onkeyup="validatePassword()" required>
                        <span class="password-toggle" id="toggleIcon1" onclick="togglePassword('password', 'toggleIcon1')">👁️</span>
                    </div>
                    <span class="password-strength" id="strength"></span>
                </div>

                <div class="form-group">
                    <label>Xác nhận mật khẩu</label>
                    <div class="input-wrapper">
                        <span class="input-icon">🔒</span>
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="••••••" onkeyup="validatePassword()" required>
                        <span class="password-toggle" id="toggleIcon2" onclick="togglePassword('confirmPassword', 'toggleIcon2')">👁️</span>
                    </div>
                    <span class="match-status" id="match"></span>
                </div>

                <button type="submit" class="btn btn-register">
                    Đăng ký
                </button>
            </form>
        </div>

        <div class="footer-links">
            <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
            <span class="separator">|</span>
            <a href="home.jsp">Quay lại trang chủ</a>
        </div>
    </div>
</body>
</html>