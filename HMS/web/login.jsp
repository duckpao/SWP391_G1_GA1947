<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng nhập - Hệ thống quản lý kho bệnh viện</title>
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

            .login-container {
                width: 100%;
                max-width: 450px;
                background: white;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
                overflow: hidden;
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

            .login-header {
                background: white;
                border-bottom: 3px solid #3b82f6;
                color: #1f2937;
                padding: 40px 30px;
                text-align: center;
            }

            .login-icon {
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

            .login-header h1 {
                font-size: 28px;
                font-weight: 700;
                margin-bottom: 8px;
                color: #1f2937;
            }

            .login-header p {
                font-size: 14px;
                color: #6b7280;
            }

            .login-body {
                padding: 40px 30px;
            }

            .form-group {
                margin-bottom: 24px;
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
            }

            .input-icon {
                position: absolute;
                left: 16px;
                top: 50%;
                transform: translateY(-50%);
                font-size: 18px;
                color: #9ca3af;
            }

            .form-control {
                width: 100%;
                padding: 14px 16px 14px 48px;
                border: 2px solid #e5e7eb;
                border-radius: 10px;
                font-size: 15px;
                font-family: inherit;
                transition: all 0.3s ease;
                background: #f9fafb;
            }

            .form-control:focus {
                outline: none;
                border-color: #3b82f6;
                background: white;
                box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
            }

            .btn-login {
                width: 100%;
                padding: 16px;
                background: #3b82f6;
                color: white;
                border: none;
                border-radius: 10px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                margin-top: 8px;
            }

            .btn-login:hover {
                background: #2563eb;
                transform: translateY(-2px);
                box-shadow: 0 10px 30px rgba(59, 130, 246, 0.3);
            }

            .btn-login:active {
                transform: translateY(0);
            }

            .alert {
                padding: 14px 16px;
                border-radius: 10px;
                margin-bottom: 20px;
                font-size: 14px;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .alert-danger {
                background: #fee2e2;
                border: 1px solid #fca5a5;
                color: #991b1b;
            }

            .alert-success {
                background: #d1fae5;
                border: 1px solid #6ee7b7;
                color: #065f46;
            }

            .login-footer {
                padding: 24px 30px;
                background: #f9fafb;
                border-top: 1px solid #e5e7eb;
                text-align: center;
            }

            .login-footer a {
                color: #3b82f6;
                text-decoration: none;
                font-weight: 600;
                font-size: 14px;
                transition: all 0.2s;
            }

            .login-footer a:hover {
                color: #2563eb;
                text-decoration: underline;
            }

            .divider {
                color: #9ca3af;
                margin: 0 8px;
            }

            .password-toggle {
                position: absolute;
                right: 16px;
                top: 50%;
                transform: translateY(-50%);
                cursor: pointer;
                font-size: 18px;
                color: #9ca3af;
                user-select: none;
            }

            .password-toggle:hover {
                color: #3b82f6;
            }
        </style>
    </head>
    <body>
        <div class="login-container">
            <div class="login-header">
                <div class="login-icon">🏥</div>
                <h1>Đăng nhập</h1>
                <p>Hệ thống quản lý kho bệnh viện</p>
            </div>

            <div class="login-body">
                <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger">
                    <span>⚠️</span>
                    <span>${error}</span>
                </div>
                <% } %>

                <% if (request.getAttribute("message") != null) { %>
                <div class="alert alert-success">
                    <span>✅</span>
                    <span>${message}</span>
                </div>
                <% } %>

                <form action="login" method="post">
                    <div class="form-group">
                        <label for="emailOrUsername">Email hoặc Username</label>
                        <div class="input-wrapper">
                            <span class="input-icon">📧</span>
                            <input 
                                type="text" 
                                id="emailOrUsername" 
                                name="emailOrUsername" 
                                class="form-control" 
                                placeholder="Nhập email hoặc username"
                                required
                                autofocus>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="password">Mật khẩu</label>
                        <div class="input-wrapper">
                            <span class="input-icon">🔒</span>
                            <input 
                                type="password" 
                                id="password" 
                                name="password" 
                                class="form-control" 
                                placeholder="Nhập mật khẩu"
                                required>
                            <span class="password-toggle" onclick="togglePassword()">👁️</span>
                        </div>
                    </div>

                    <button type="submit" class="btn-login">
                        🚀 Đăng nhập
                    </button>
                </form>

            </div>

            <div class="login-footer">
                <a href="${pageContext.request.contextPath}/register">📝 Đăng ký tài khoản</a>
                <span class="divider">|</span>
                <a href="${pageContext.request.contextPath}/forgot-password">🔑 Quên mật khẩu?</a>
            </div>
        </div>

        <script>
            function togglePassword() {
                const passwordInput = document.getElementById('password');
                const toggle = document.querySelector('.password-toggle');

                if (passwordInput.type === 'password') {
                    passwordInput.type = 'text';
                    toggle.textContent = '🙈';
                } else {
                    passwordInput.type = 'password';
                    toggle.textContent = '👁️';
                }
            }
        </script>
    </body>
</html>
