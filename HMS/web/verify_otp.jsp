<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xác thực OTP - Hệ thống quản lý kho bệnh viện</title>
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

            .otp-container {
                width: 100%;
                max-width: 450px;
                background: white;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
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

            .otp-header {
                background: white;
                color: #1f2937;
                padding: 40px 30px;
                text-align: center;
                border-bottom: 4px solid #3b82f6;
            }

            .otp-icon {
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

            .otp-header h1 {
                font-size: 28px;
                font-weight: 700;
                margin-bottom: 8px;
            }

            .otp-header p {
                font-size: 14px;
                opacity: 0.7;
                line-height: 1.5;
            }

            .otp-body {
                padding: 40px 30px;
            }

            .info-box {
                background: #eff6ff;
                border: 1px solid #bfdbfe;
                border-radius: 10px;
                padding: 16px;
                margin-bottom: 24px;
                display: flex;
                gap: 12px;
                align-items: flex-start;
            }

            .info-box-icon {
                font-size: 20px;
                flex-shrink: 0;
            }

            .info-box-text {
                font-size: 14px;
                color: #1e40af;
                line-height: 1.6;
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
                text-align: center;
                letter-spacing: 0.5em;
                font-weight: 600;
            }

            .form-control:focus {
                outline: none;
                border-color: #3b82f6;
                background: white;
                box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
            }

            .btn-verify {
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

            .btn-verify:hover {
                background: #2563eb;
                transform: translateY(-2px);
                box-shadow: 0 10px 30px rgba(59, 130, 246, 0.4);
            }

            .btn-verify:active {
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

            .otp-footer {
                padding: 24px 30px;
                background: #f9fafb;
                border-top: 1px solid #e5e7eb;
                text-align: center;
            }

            .otp-footer a {
                color: #3b82f6;
                text-decoration: none;
                font-weight: 600;
                font-size: 14px;
                transition: all 0.2s;
            }

            .otp-footer a:hover {
                color: #2563eb;
                text-decoration: underline;
            }

            .divider {
                color: #9ca3af;
                margin: 0 8px;
            }

            .resend-timer {
                text-align: center;
                margin-top: 16px;
                font-size: 14px;
                color: #6b7280;
            }

            .resend-link {
                color: #3b82f6;
                cursor: pointer;
                font-weight: 600;
                text-decoration: none;
            }

            .resend-link:hover {
                text-decoration: underline;
            }

            .resend-link.disabled {
                color: #9ca3af;
                cursor: not-allowed;
                text-decoration: none;
            }
        </style>
    </head>
    <body>
        <div class="otp-container">
            <div class="otp-header">
                <div class="otp-icon">🔐</div>
                <h1>Xác thực OTP</h1>
                <p>Vui lòng nhập mã xác thực đã được gửi đến email của bạn</p>
            </div>

            <div class="otp-body">
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

                <div class="info-box">
                    <span class="info-box-icon">📧</span>
                    <div class="info-box-text">
                        Mã OTP gồm 6 chữ số đã được gửi đến email của bạn. Vui lòng kiểm tra hộp thư đến hoặc thư rác.
                    </div>
                </div>

                <form action="VerifyOTPServlet" method="post">
                    <div class="form-group">
                        <label for="otp">Mã OTP</label>
                        <div class="input-wrapper">
                            <span class="input-icon">🔢</span>
                            <input 
                                type="text" 
                                id="otp" 
                                name="otp" 
                                class="form-control" 
                                placeholder="000000"
                                maxlength="6"
                                pattern="[0-9]{6}"
                                required
                                autofocus>
                        </div>
                    </div>

                    <button type="submit" class="btn-verify">
                        ✅ Xác nhận OTP
                    </button>
                </form>

                <div class="resend-timer">
                    <span id="timer-text">Chưa nhận được mã? </span>
                    <a href="#" class="resend-link disabled" id="resend-link" onclick="resendOTP(event)">
                        Gửi lại (<span id="countdown">60</span>s)
                    </a>
                </div>
            </div>

            <div class="otp-footer">
                <a href="${pageContext.request.contextPath}/login">🔙 Quay lại đăng nhập</a>
                <span class="divider">|</span>
                <a href="${pageContext.request.contextPath}/support">💬 Hỗ trợ</a>
            </div>
        </div>

        <script>
        </script>
    </body>
</html>
