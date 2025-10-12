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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
        }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px 40px;
            text-align: center;
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

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.3s ease;
            background: #f9fafb;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-group input::placeholder {
            color: #9ca3af;
        }

        .password-strength {
            font-size: 13px;
            font-weight: 600;
            margin-top: 6px;
            display: inline-block;
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

        .btn-register {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            margin-bottom: 16px;
        }

        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.3);
        }

        .btn-register:active {
            transform: translateY(0);
        }

        .btn-home {
            background: #f3f4f6;
            color: #667eea;
            border: 2px solid #e5e7eb;
        }

        .btn-home:hover {
            background: #e5e7eb;
            border-color: #d1d5db;
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

        .login-link {
            text-align: center;
            font-size: 14px;
            color: #6b7280;
        }

        .login-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 700;
            transition: all 0.2s ease;
        }

        .login-link a:hover {
            color: #764ba2;
            text-decoration: underline;
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
            <h1>
                <span class="header-icon">📝</span>
                Đăng ký tài khoản
            </h1>
        </div>

        <div class="content">
            <div class="error-message"></div>
            <div class="success-message"></div>

            <form action="register" method="post" onsubmit="handleSubmit(event)">
                <div class="form-group">
                    <label>Họ tên</label>
                    <input type="text" name="username" placeholder="Nhập họ tên của bạn" required>
                </div>

                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" placeholder="Nhập địa chỉ email" required>
                </div>

                <div class="form-group">
                    <label>Số điện thoại</label>
                    <input type="text" name="phone" placeholder="Nhập số điện thoại" required>
                </div>

                <div class="form-group">
                    <label>Mật khẩu</label>
                    <input type="password" id="password" name="password" placeholder="Tối thiểu 6 ký tự" onkeyup="validatePassword()" required>
                    <span class="password-strength" id="strength"></span>
                </div>

                <div class="form-group">
                    <label>Nhập lại mật khẩu</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Xác nhận mật khẩu" onkeyup="validatePassword()" required>
                    <span class="match-status" id="match"></span>
                </div>

                <button type="submit" class="btn btn-register">
                    🚀 Đăng ký
                </button>
            </form>

            <div class="divider">━━━━━━━━━━━━━━━━</div>

            <button onclick="window.location.href='home.jsp'" class="btn btn-home">
                🏠 Quay lại Trang chủ
            </button>

            <div class="login-link" style="margin-top: 20px;">
                Đã có tài khoản? <a href="login.jsp">Đăng nhập ngay</a>
            </div>
        </div>
    </div>
</body>
</html>