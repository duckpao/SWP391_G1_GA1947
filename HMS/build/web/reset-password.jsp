<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt lại mật khẩu - Hệ thống quản lý kho bệnh viện</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: #f0f2f5;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .container { width:100%; max-width:480px; }
        .card {
            background:white;
            border-radius:12px;
            box-shadow:0 2px 12px rgba(0,0,0,0.08);
            overflow:hidden;
            animation:slideUp 0.4s ease;
        }
        @keyframes slideUp { from { opacity:0; transform:translateY(30px); } to { opacity:1; transform:translateY(0); } }
        .card-header {
            background:white;
            color:#1f2937;
            padding:32px;
            text-align:center;
            border-bottom:1px solid #e5e7eb;
        }
        .card-header-icon {
            width:64px;
            height:64px;
            background:linear-gradient(135deg,#e8f0fe 0%,#d3e3fd 100%);
            border-radius:50%;
            display:flex;
            align-items:center;
            justify-content:center;
            font-size:32px;
            margin:0 auto 16px;
        }
        .card-header h1 {
            font-size:24px;
            font-weight:700;
            margin-bottom:8px;
        }
        .card-header p {
            font-size:14px;
            color:#6b7280;
            margin:0;
        }
        .card-body { padding:32px; }
        .info-box {
            background:#f3f4f6;
            border:1px solid #e5e7eb;
            border-radius:8px;
            padding:16px;
            margin-bottom:24px;
            display:flex;
            gap:12px;
            align-items:flex-start;
        }
        .info-icon { font-size:20px; flex-shrink:0; }
        .info-text { font-size:14px; color:#374151; line-height:1.5; }
        .form-group { margin-bottom:24px; }
        label {
            display:block;
            font-size:14px;
            font-weight:600;
            color:#374151;
            margin-bottom:8px;
        }
        .input-wrapper { position:relative; }
        input[type="password"] {
            width:100%;
            padding:14px 16px;
            border:none;
            border-radius:8px;
            font-size:15px;
            font-family:inherit;
            transition:all 0.2s ease;
            background:#f3f4f6;
            color:#1f2937;
        }
        input[type="password"]:focus { outline:none; background:#e5e7eb; }
        input[type="password"]::placeholder { color:#9ca3af; }
        .validation-message {
            margin-top:8px;
            font-size:14px;
            font-weight:500;
            display:flex;
            align-items:center;
            gap:6px;
        }
        .validation-message.error { color:#dc2626; }
        .validation-message.success { color:#059669; }
        .btn {
            width:100%;
            padding:16px;
            border:none;
            border-radius:8px;
            font-size:16px;
            font-weight:600;
            cursor:pointer;
            transition:all 0.2s ease;
            font-family:inherit;
        }
        .btn-primary {
            background:#6b7280;
            color:white;
        }
        .btn-primary:hover { background:#4b5563; }
        .alert {
            padding:14px 16px;
            border-radius:8px;
            margin-bottom:20px;
            font-size:14px;
            font-weight:500;
            display:flex;
            align-items:center;
            gap:10px;
        }
        .alert-danger { background:#fef2f2; border:1px solid #fecaca; color:#991b1b; }
        .alert-success { background:#f0fdf4; border:1px solid #86efac; color:#065f46; }
        .card-footer {
            padding:24px 32px;
            background:#ffffff;
            border-top:1px solid #e5e7eb;
            text-align:center;
        }
        .card-footer a {
            color:#6b7280;
            text-decoration:none;
            font-weight:600;
            font-size:14px;
            transition:all 0.2s;
            display:inline-flex;
            align-items:center;
            gap:6px;
        }
        .card-footer a:hover { color:#374151; text-decoration:underline; }
    </style>
</head>
<body>
    <div class="container">
        <div class="card">
            <div class="card-header">
                <div class="card-header-icon">🔐</div>
                <h1>Đặt lại mật khẩu</h1>
                <p>Vui lòng nhập mật khẩu mới của bạn</p>
            </div>
            <div class="card-body">
                <div class="info-box">
                    <div class="info-icon">💡</div>
                    <div class="info-text">
                        Mật khẩu mới phải có tối thiểu 6 ký tự để đảm bảo bảo mật cho tài khoản của bạn.
                    </div>
                </div>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger">
                        <span>❌</span>
                        <span>${error}</span>
                    </div>
                <% } %>

                <% if (request.getAttribute("message") != null) { %>
                    <div class="alert alert-success">
                        <span>✅</span>
                        <span>${message}</span>
                    </div>
                <% } %>

                <form action="reset-password" method="post" onsubmit="return validateForm()">
                    <div class="form-group">
                        <label for="newPassword">Mật khẩu mới</label>
                        <div class="input-wrapper">
                            <input type="password" id="newPassword" name="newPassword" placeholder="Nhập mật khẩu mới (tối thiểu 6 ký tự)" minlength="6" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">Xác nhận mật khẩu mới</label>
                        <div class="input-wrapper">
                            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu mới" minlength="6" oninput="validatePassword()" required>
                        </div>
                        <div id="matchMessage" class="validation-message"></div>
                    </div>

                    <button type="submit" class="btn btn-primary">
                        💾 Lưu thay đổi
                    </button>
                </form>
            </div>

            <div class="card-footer">
                <a href="${pageContext.request.contextPath}/login">← Quay lại Đăng nhập</a>
            </div>
        </div>
    </div>

    <script>
        function validatePassword() {
            const newPass = document.getElementById('newPassword').value;
            const confirm = document.getElementById('confirmPassword').value;
            const matchMessage = document.getElementById('matchMessage');

            if (confirm.length === 0) { matchMessage.textContent = ''; return; }
            if (newPass !== confirm) {
                matchMessage.className = 'validation-message error';
                matchMessage.innerHTML = '<span>❌</span><span>Mật khẩu không khớp</span>';
            } else {
                matchMessage.className = 'validation-message success';
                matchMessage.innerHTML = '<span>✓</span><span>Mật khẩu khớp</span>';
            }
        }

        function validateForm() {
            const newPass = document.getElementById('newPassword').value;
            const confirm = document.getElementById('confirmPassword').value;
            if (newPass.length < 6) { alert('Mật khẩu phải có ít nhất 6 ký tự!'); return false; }
            if (newPass !== confirm) { alert('Mật khẩu xác nhận không khớp!'); return false; }
            return true;
        }
    </script>
</body>
</html>
