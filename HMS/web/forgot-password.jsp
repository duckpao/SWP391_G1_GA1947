<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu - Hệ thống quản lý kho bệnh viện</title>
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 32px;
            text-align: center;
        }

        .card-header-icon {
            width: 64px;
            height: 64px;
            background: rgba(255, 255, 255, 0.2);
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
            opacity: 0.9;
            margin: 0;
        }

        .card-body {
            padding: 32px;
        }

        .info-box {
            background: #f0f9ff;
            border: 1px solid #bae6fd;
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 24px;
            display: flex;
            gap: 12px;
        }

        .info-icon {
            font-size: 20px;
            flex-shrink: 0;
        }

        .info-text {
            font-size: 13px;
            color: #0c4a6e;
            line-height: 1.5;
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

        .input-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 18px;
            color: #9ca3af;
        }

        input[type="text"] {
            width: 100%;
            padding: 12px 16px 12px 48px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.3s ease;
            background: white;
        }

        input[type="text"]:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        input[type="text"]::placeholder {
            color: #9ca3af;
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
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
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
            animation: fadeIn 0.3s ease;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
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
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .card-footer a:hover {
            color: #764ba2;
            text-decoration: underline;
        }

        .help-text {
            font-size: 13px;
            color: #6b7280;
            margin-top: 12px;
            text-align: center;
            line-height: 1.5;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="card">
            <div class="card-header">
                <div class="card-header-icon">🔑</div>
                <h1>Quên mật khẩu?</h1>
                <p>Đừng lo lắng, chúng tôi sẽ giúp bạn lấy lại</p>
            </div>

            <div class="card-body">
                <div class="info-box">
                    <div class="info-icon">💡</div>
                    <div class="info-text">
                        Nhập email hoặc số điện thoại đã đăng ký. Chúng tôi sẽ gửi link đặt lại mật khẩu cho bạn.
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

                <form action="forgot-password" method="post">
                    <div class="form-group">
                        <label for="emailOrPhone">Email hoặc Số điện thoại</label>
                        <div class="input-wrapper">
                            <span class="input-icon">📧</span>
                            <input type="text" 
                                   id="emailOrPhone" 
                                   name="emailOrPhone" 
                                   placeholder="example@email.com hoặc 0123456789"
                                   required>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary">
                        <span>📨</span>
                        <span>Gửi link đặt lại mật khẩu</span>
                    </button>

                    <div class="help-text">
                        Link đặt lại mật khẩu sẽ được gửi đến email hoặc số điện thoại của bạn trong vài phút.
                    </div>
                </form>
            </div>

            <div class="card-footer">
                <a href="${pageContext.request.contextPath}/login">
                    <span>←</span>
                    <span>Quay lại Đăng nhập</span>
                </a>
            </div>
        </div>
    </div>
</body>
</html>