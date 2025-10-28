<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt lại mật khẩu - Hệ thống quản lý kho bệnh viện</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: #f9fafb;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .container {
            width: 100%;
            max-width: 480px;
        }

        .card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            animation: slideUp 0.4s ease;
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

        .card-header {
            background: white;
            color: #1f2937;
            padding: 32px;
            text-align: center;
            border-bottom: 3px solid #3b82f6;
        }

        .card-header-icon {
            width: 64px;
            height: 64px;
            background: #eff6ff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            margin: 0 auto 16px;
        }

        .card-header h1 {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .card-header p {
            font-size: 14px;
            color: #6b7280;
            margin: 0;
        }

        .card-body {
            padding: 32px;
        }

        .form-group {
            margin-bottom: 24px;
        }

        label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }

        .input-wrapper {
            position: relative;
        }

        input[type="password"] {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.3s ease;
            background: white;
        }

        input[type="password"]:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .password-strength {
            margin-top: 8px;
            font-size: 12px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .strength-indicator {
            height: 4px;
            flex: 1;
            background: #e5e7eb;
            border-radius: 2px;
            overflow: hidden;
        }

        .strength-bar {
            height: 100%;
            width: 0%;
            transition: all 0.3s ease;
            border-radius: 2px;
        }

        .strength-bar.weak {
            width: 33%;
            background: #ef4444;
        }

        .strength-bar.medium {
            width: 66%;
            background: #f59e0b;
        }

        .strength-bar.strong {
            width: 100%;
            background: #10b981;
        }

        .validation-message {
            margin-top: 8px;
            font-size: 13px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .validation-message.error {
            color: #dc2626;
        }

        .validation-message.success {
            color: #059669;
        }

        .btn {
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: inherit;
        }

        .btn-primary {
            background: #3b82f6;
            color: white;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.4);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(59, 130, 246, 0.5);
        }

        .btn-primary:active {
            transform: translateY(0);
        }

        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-danger {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }

        .alert-success {
            background: #d1fae5;
            color: #065f46;
            border: 1px solid #a7f3d0;
        }

        .card-footer {
            padding: 20px 32px;
            background: #f9fafb;
            border-top: 1px solid #e5e7eb;
            text-align: center;
        }

        .card-footer a {
            color: #3b82f6;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.2s ease;
        }

        .card-footer a:hover {
            color: #2563eb;
            text-decoration: underline;
        }

        .password-requirements {
            margin-top: 12px;
            padding: 12px;
            background: #f9fafb;
            border-radius: 8px;
            font-size: 12px;
        }

        .requirement {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 6px;
            color: #6b7280;
        }

        .requirement:last-child {
            margin-bottom: 0;
        }

        .requirement.met {
            color: #059669;
        }

        .requirement-icon {
            font-size: 14px;
        }
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
                            <input type="password" id="newPassword" name="newPassword" 
                                   placeholder="Nhập mật khẩu mới" 
                                   oninput="checkPasswordStrength()" required>
                        </div>
                        <div class="password-strength" id="strengthDisplay" style="display: none;">
                            <div class="strength-indicator">
                                <div class="strength-bar" id="strengthBar"></div>
                            </div>
                            <span id="strengthText"></span>
                        </div>
                        <div class="password-requirements">
                            <div class="requirement" id="req-length">
                                <span class="requirement-icon">○</span>
                                <span>Tối thiểu 8 ký tự</span>
                            </div>
                            <div class="requirement" id="req-upper">
                                <span class="requirement-icon">○</span>
                                <span>Có chữ hoa</span>
                            </div>
                            <div class="requirement" id="req-lower">
                                <span class="requirement-icon">○</span>
                                <span>Có chữ thường</span>
                            </div>
                            <div class="requirement" id="req-number">
                                <span class="requirement-icon">○</span>
                                <span>Có số</span>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">Nhập lại mật khẩu mới</label>
                        <div class="input-wrapper">
                            <input type="password" id="confirmPassword" name="confirmPassword" 
                                   placeholder="Xác nhận mật khẩu mới" 
                                   oninput="validatePassword()" required>
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
        function checkPasswordStrength() {
            const password = document.getElementById('newPassword').value;
            const strengthDisplay = document.getElementById('strengthDisplay');
            const strengthBar = document.getElementById('strengthBar');
            const strengthText = document.getElementById('strengthText');

            // Check requirements
            const hasLength = password.length >= 8;
            const hasUpper = /[A-Z]/.test(password);
            const hasLower = /[a-z]/.test(password);
            const hasNumber = /\d/.test(password);

            // Update requirement indicators
            updateRequirement('req-length', hasLength);
            updateRequirement('req-upper', hasUpper);
            updateRequirement('req-lower', hasLower);
            updateRequirement('req-number', hasNumber);

            if (password.length === 0) {
                strengthDisplay.style.display = 'none';
                return;
            }

            strengthDisplay.style.display = 'flex';

            // Calculate strength
            if (hasLength && hasUpper && hasLower && hasNumber) {
                strengthBar.className = 'strength-bar strong';
                strengthText.textContent = 'Mạnh';
                strengthText.style.color = '#10b981';
            } else if (password.length >= 6 && (hasUpper || hasLower) && hasNumber) {
                strengthBar.className = 'strength-bar medium';
                strengthText.textContent = 'Trung bình';
                strengthText.style.color = '#f59e0b';
            } else {
                strengthBar.className = 'strength-bar weak';
                strengthText.textContent = 'Yếu';
                strengthText.style.color = '#ef4444';
            }

            validatePassword();
        }

        function updateRequirement(id, met) {
            const element = document.getElementById(id);
            const icon = element.querySelector('.requirement-icon');
            if (met) {
                element.classList.add('met');
                icon.textContent = '✓';
            } else {
                element.classList.remove('met');
                icon.textContent = '○';
            }
        }

        function validatePassword() {
            const newPass = document.getElementById('newPassword').value;
            const confirm = document.getElementById('confirmPassword').value;
            const matchMessage = document.getElementById('matchMessage');

            if (confirm.length === 0) {
                matchMessage.textContent = '';
                return;
            }

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

            if (newPass !== confirm) {
                alert('Mật khẩu xác nhận không khớp!');
                return false;
            }

            const hasLength = newPass.length >= 8;
            const hasUpper = /[A-Z]/.test(newPass);
            const hasLower = /[a-z]/.test(newPass);
            const hasNumber = /\d/.test(newPass);

            if (!hasLength || !hasUpper || !hasLower || !hasNumber) {
                alert('Mật khẩu chưa đủ mạnh! Vui lòng đảm bảo đáp ứng tất cả các yêu cầu.');
                return false;
            }

            return true;
        }
    </script>
</body>
</html>
