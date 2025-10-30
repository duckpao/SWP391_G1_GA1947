<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác nhận OTP - Hệ thống quản lý kho bệnh viện</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: #f0f2f5;
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
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.08);
            overflow: hidden;
            animation: slideUp 0.5s ease;
        }
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .otp-header {
            background: white;
            color: #1f2937;
            padding: 40px 30px;
            text-align: center;
            border-bottom: 1px solid #e5e7eb;
        }
        .otp-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #e8f0fe 0%, #d3e3fd 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 36px;
        }
        .otp-header h1 {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 8px;
            color: #1f2937;
        }
        .otp-header p {
            font-size: 14px;
            color: #6b7280;
            line-height: 1.5;
        }
        .otp-body {
            padding: 40px 30px;
        }
        .info-box {
            background: #f3f4f6;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 24px;
            display: flex;
            gap: 12px;
            align-items: flex-start;
        }
        .info-box-icon { font-size: 20px; flex-shrink: 0; }
        .info-box-text { font-size: 14px; color: #374151; line-height: 1.6; }
        .form-group { margin-bottom: 24px; }
        .form-group label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }
        .input-wrapper { position: relative; }
        .input-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 18px;
            color: #6b7280;
        }
        .form-control {
            width: 100%;
            padding: 14px 16px 14px 48px;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-family: inherit;
            transition: all 0.2s ease;
            background: #f3f4f6;
            text-align: center;
            letter-spacing: 0.5em;
            font-weight: 600;
            color: #1f2937;
        }
        .form-control:focus { outline: none; background: #e5e7eb; }
        .btn-verify {
            width: 100%;
            padding: 16px;
            background: #6b7280;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            margin-top: 8px;
        }
        .btn-verify:hover { background: #4b5563; }
        .btn-verify:active { transform: scale(0.98); }
        .alert { padding: 14px 16px; border-radius: 8px; margin-bottom: 20px; font-size: 14px; font-weight: 500; display: flex; align-items: center; gap: 10px; }
        .alert-danger { background: #fef2f2; border: 1px solid #fecaca; color: #991b1b; }
        .otp-footer {
            padding: 24px 30px;
            background: #ffffff;
            border-top: 1px solid #e5e7eb;
            text-align: center;
        }
        .otp-footer a {
            color: #6b7280;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.2s;
        }
        .otp-footer a:hover { color: #374151; }
        @media (max-width: 640px) {
            .otp-header { padding: 32px 24px; }
            .otp-body { padding: 32px 24px; }
            .otp-footer { padding: 20px 24px; }
        }
    </style>
</head>
<body>
    <div class="otp-container">
        <div class="otp-header">
            <div class="otp-icon">🔐</div>
            <h1>Xác nhận OTP</h1>
            <p>Nhập mã xác thực đã gửi đến email</p>
        </div>

        <div class="otp-body">
            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <span>⚠️</span>
                <span>${error}</span>
            </div>
            <% } %>

            <div class="info-box">
                <span class="info-box-icon">📧</span>
                <div class="info-box-text">
                    Mã OTP gồm 6 chữ số đã được gửi đến email của bạn. Vui lòng kiểm tra hộp thư đến hoặc thư rác.
                </div>
            </div>

            <form action="VerifyResetServlet" method="post">
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
        </div>

        <div class="otp-footer">
            <a href="${pageContext.request.contextPath}/login">🔙 Quay lại đăng nhập</a>
        </div>
    </div>
</body>
</html>
