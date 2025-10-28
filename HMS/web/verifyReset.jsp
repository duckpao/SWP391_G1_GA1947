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
            font-family: 'Inter', sans-serif;
            background: #f9fafb;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .container {
            width: 100%;
            max-width: 450px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            animation: slideUp 0.5s ease;
        }
        
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .header {
            background: white;
            color: #1f2937;
            padding: 40px 30px;
            text-align: center;
            border-bottom: 4px solid #3b82f6;
        }
        
        .icon {
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
        
        .header h1 {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 8px;
            color: #1f2937;
        }
        
        .header p {
            font-size: 14px;
            color: #6b7280;
        }
        
        .body {
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
        
        .otp-input {
            width: 100%;
            padding: 16px;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-size: 24px;
            font-weight: 600;
            text-align: center;
            letter-spacing: 8px;
            font-family: 'Courier New', monospace;
            transition: all 0.3s ease;
            background: #f9fafb;
            color: #1f2937;
        }
        
        .otp-input:focus {
            outline: none;
            border-color: #3b82f6;
            background: white;
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
        }
        
        .btn {
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
        }
        
        .btn:hover {
            background: #2563eb;
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(59, 130, 246, 0.3);
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
            background: #fee2e2;
            border: 1px solid #fca5a5;
            color: #991b1b;
        }
        
        .footer {
            padding: 24px 30px;
            background: #f9fafb;
            border-top: 1px solid #e5e7eb;
            text-align: center;
        }
        
        .footer a {
            color: #3b82f6;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
        }
        
        .footer a:hover {
            color: #2563eb;
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="icon">🔐</div>
            <h1>Xác nhận OTP</h1>
            <p>Nhập mã xác thực đã gửi đến email</p>
        </div>

        <div class="body">
            <% if (request.getAttribute("error") != null) { %>
            <div class="alert">
                <span>⚠️</span>
                <span>${error}</span>
            </div>
            <% } %>

            <form action="VerifyResetServlet" method="post">
                <div class="form-group">
                    <label for="otp">Mã OTP (6 số)</label>
                    <input 
                        type="text" 
                        id="otp"
                        name="otp" 
                        class="otp-input" 
                        placeholder="000000"
                        required 
                        maxlength="6"
                        pattern="[0-9]{6}"
                        autofocus>
                </div>

                <button type="submit" class="btn">
                    ✅ Xác nhận
                </button>
            </form>
        </div>

        <div class="footer">
            <a href="${pageContext.request.contextPath}/login">⬅️ Quay lại đăng nhập</a>
        </div>
    </div>
</body>
</html>
