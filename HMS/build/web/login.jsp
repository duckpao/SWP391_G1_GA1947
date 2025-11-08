<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng nhập - Hệ thống quản lý kho bệnh viện</title>
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
                border-bottom: 3px solid #6c757d;
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
                background: #ffffff;
            }

            .form-control:focus {
                outline: none;
                border-color: #6c757d;
                background: white;
                box-shadow: 0 0 0 4px rgba(108, 117, 125, 0.1);
            }

            .btn-login {
                width: 100%;
                padding: 16px;
                background: #6c757d;
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
                background: #5a6268;
                transform: translateY(-2px);
                box-shadow: 0 10px 30px rgba(108, 117, 125, 0.3);
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
                background: #ffffff;
                border-top: 1px solid #e5e7eb;
                text-align: center;
            }

            .login-footer a {
                color: #6c757d;
                text-decoration: none;
                font-weight: 600;
                font-size: 14px;
                transition: all 0.2s;
            }

            .login-footer a:hover {
                color: #5a6268;
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
                color: #6c757d;
            }

            /* CAPTCHA Styles */
            .captcha-container {
                background: #f8f9fa;
                border: 2px solid #e9ecef;
                border-radius: 12px;
                padding: 20px;
                margin-top: 20px;
                animation: fadeIn 0.3s ease;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: scale(0.95);
                }
                to {
                    opacity: 1;
                    transform: scale(1);
                }
            }

            .captcha-header {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 16px;
                font-size: 14px;
                font-weight: 600;
                color: #dc3545;
            }

            .captcha-image-wrapper {
                position: relative;
                display: flex;
                align-items: center;
                gap: 12px;
                margin-bottom: 16px;
            }

            .captcha-image {
                flex: 1;
                border: 2px solid #dee2e6;
                border-radius: 8px;
                background: white;
                overflow: hidden;
            }

            .captcha-image img {
                width: 100%;
                height: auto;
                display: block;
            }

            .captcha-refresh {
                background: #6c757d;
                color: white;
                border: none;
                border-radius: 8px;
                width: 48px;
                height: 48px;
                cursor: pointer;
                font-size: 20px;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .captcha-refresh:hover {
                background: #5a6268;
                transform: rotate(180deg);
            }

            .captcha-input {
                width: 100%;
                padding: 12px 16px;
                border: 2px solid #ced4da;
                border-radius: 8px;
                font-size: 16px;
                text-align: center;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .captcha-input:focus {
                outline: none;
                border-color: #6c757d;
                box-shadow: 0 0 0 4px rgba(108, 117, 125, 0.1);
            }

            .captcha-hint {
                text-align: center;
                font-size: 13px;
                color: #6c757d;
                margin-top: 8px;
            }

            .loading {
                pointer-events: none;
                opacity: 0.6;
            }

            .spinner {
                display: inline-block;
                width: 14px;
                height: 14px;
                border: 2px solid rgba(255,255,255,0.3);
                border-radius: 50%;
                border-top-color: white;
                animation: spin 0.6s linear infinite;
            }

            @keyframes spin {
                to { transform: rotate(360deg); }
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

                <form action="login" method="post" id="loginForm">
                    <div class="form-group">
                        <label for="emailOrUsername">Email hoặc Username</label>
                        <div class="input-wrapper">
                            <span class="input-icon">👤</span>
                            <input 
                                type="text" 
                                id="emailOrUsername" 
                                name="emailOrUsername" 
                                class="form-control" 
                                placeholder="Nhập email hoặc username"
                                required
                                autofocus
                                value="${param.emailOrUsername}">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="password">Mật khẩu</label>
                        <div class="input-wrapper">
                            <span class="input-icon">🔐</span>
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

                    <%-- CAPTCHA Section (hiển thị sau 3 lần sai) --%>
                    <% if (request.getAttribute("needCaptcha") != null && (Boolean)request.getAttribute("needCaptcha")) { %>
                    <div class="captcha-container">
                        <div class="captcha-header">
                            <span>🔒</span>
                            <span>Vui lòng giải phép tính để tiếp tục</span>
                        </div>
                        
                        <div class="captcha-image-wrapper">
                            <div class="captcha-image">
                                <img id="captchaImg" src="${captchaImage}" alt="CAPTCHA">
                            </div>
                            <button type="button" class="captcha-refresh" onclick="refreshCaptcha()" title="Làm mới CAPTCHA">
                                🔄
                            </button>
                        </div>

                        <input 
                            type="text" 
                            name="captcha" 
                            class="captcha-input" 
                            placeholder="Nhập đáp án" 
                            required
                            autocomplete="off"
                            pattern="[0-9]*"
                            inputmode="numeric">
                        
                        <div class="captcha-hint">
                            💡 Nhập kết quả của phép tính trên
                        </div>
                    </div>
                    <% } %>

                    <button type="submit" class="btn-login" id="loginBtn">
                        Đăng nhập
                    </button>
                </form>
            </div>

            <div class="login-footer">
                <a href="${pageContext.request.contextPath}/home.jsp">
                    <i class="fas fa-home"></i> Trang chủ
                </a>
                <span class="divider">|</span>
                <a href="${pageContext.request.contextPath}/register">Đăng ký tài khoản</a>
                <span class="divider">|</span>
                <a href="${pageContext.request.contextPath}/forgot-password">Quên mật khẩu?</a>
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

            function refreshCaptcha() {
                const btn = document.querySelector('.captcha-refresh');
                const img = document.getElementById('captchaImg');
                
                btn.disabled = true;
                btn.innerHTML = '<div class="spinner"></div>';
                
                fetch('${pageContext.request.contextPath}/refresh-captcha')
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            img.src = data.image;
                            document.querySelector('.captcha-input').value = '';
                            document.querySelector('.captcha-input').focus();
                        }
                    })
                    .catch(error => {
                        console.error('Error refreshing CAPTCHA:', error);
                        alert('Không thể làm mới CAPTCHA. Vui lòng tải lại trang.');
                    })
                    .finally(() => {
                        btn.disabled = false;
                        btn.innerHTML = '🔄';
                    });
            }

            // Auto focus vào CAPTCHA input nếu có
            window.addEventListener('DOMContentLoaded', function() {
                const captchaInput = document.querySelector('.captcha-input');
                if (captchaInput) {
                    captchaInput.focus();
                }
            });

            // Prevent multiple submissions
            document.getElementById('loginForm').addEventListener('submit', function(e) {
                const btn = document.getElementById('loginBtn');
                if (btn.classList.contains('loading')) {
                    e.preventDefault();
                    return;
                }
                btn.classList.add('loading');
                btn.innerHTML = '<span class="spinner"></span> Đang xử lý...';
            });
        </script>
    </body>
</html>