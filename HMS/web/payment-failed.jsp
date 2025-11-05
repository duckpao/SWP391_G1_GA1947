<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thanh toán thất bại</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .failed-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
            max-width: 600px;
            width: 100%;
        }
        .failed-header {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
            padding: 3rem 2rem;
            text-align: center;
            color: white;
        }
        .failed-icon {
            width: 100px;
            height: 100px;
            background: white;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
            animation: shake 0.5s ease-out;
        }
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-10px); }
            75% { transform: translateX(10px); }
        }
        .failed-icon i {
            font-size: 3rem;
            color: #ff6b6b;
        }
        .failed-body {
            padding: 2rem;
        }
        .error-box {
            background: #fff5f5;
            border-left: 4px solid #ff6b6b;
            padding: 1.5rem;
            border-radius: 8px;
            margin: 1.5rem 0;
        }
        .error-code {
            background: #ff6b6b;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            display: inline-block;
            font-weight: 600;
            margin-bottom: 1rem;
        }
        .btn-group-custom {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }
        .btn-custom {
            flex: 1;
            padding: 0.8rem;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s;
        }
        .btn-retry {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            border: none;
            color: white;
        }
        .btn-retry:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(245, 87, 108, 0.4);
            color: white;
        }
        .support-section {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 10px;
            margin-top: 2rem;
        }
        .support-section h6 {
            color: #495057;
            margin-bottom: 1rem;
        }
        .support-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.5rem;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="failed-card">
        <div class="failed-header">
            <div class="failed-icon">
                <i class="bi bi-x-circle-fill"></i>
            </div>
            <h2 class="mb-0">Thanh toán thất bại!</h2>
            <p class="mb-0 mt-2">Giao dịch không thể hoàn tất</p>
        </div>
        
        <div class="failed-body">
            <div class="alert alert-danger" role="alert">
                <i class="bi bi-exclamation-triangle-fill"></i>
                <strong>Lỗi!</strong> Giao dịch của bạn không thành công.
            </div>
            
            <c:if test="${not empty resultCode}">
                <div class="text-center mb-3">
                    <span class="error-code">
                        <i class="bi bi-hash"></i> Mã lỗi: ${resultCode}
                    </span>
                </div>
            </c:if>
            
            <div class="error-box">
                <h5 class="text-danger mb-2">
                    <i class="bi bi-info-circle"></i> Nguyên nhân
                </h5>
                <p class="mb-0">
                    <c:choose>
                        <c:when test="${not empty error}">
                            ${error}
                        </c:when>
                        <c:otherwise>
                            Có lỗi xảy ra trong quá trình xử lý thanh toán. Vui lòng thử lại sau.
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>
            
            <div class="mt-4">
                <h6><i class="bi bi-lightbulb"></i> Một số nguyên nhân thường gặp:</h6>
                <ul class="list-unstyled">
                    <li class="mb-2">
                        <i class="bi bi-dot text-danger"></i> Số dư tài khoản không đủ
                    </li>
                    <li class="mb-2">
                        <i class="bi bi-dot text-danger"></i> Thông tin thanh toán không chính xác
                    </li>
                    <li class="mb-2">
                        <i class="bi bi-dot text-danger"></i> Quá thời gian thanh toán
                    </li>
                    <li class="mb-2">
                        <i class="bi bi-dot text-danger"></i> Lỗi kết nối mạng
                    </li>
                    <li class="mb-2">
                        <i class="bi bi-dot text-danger"></i> Hủy giao dịch bởi người dùng
                    </li>
                </ul>
            </div>
            
            <div class="btn-group-custom">
                <button onclick="history.back()" class="btn btn-retry btn-custom">
                    <i class="bi bi-arrow-repeat"></i> Thử lại
                </button>
                <a href="invoices" class="btn btn-outline-secondary btn-custom">
                    <i class="bi bi-house"></i> Về trang chủ
                </a>
            </div>
            
            <div class="support-section">
                <h6><i class="bi bi-headset"></i> Cần hỗ trợ?</h6>
                <div class="support-item">
                    <i class="bi bi-telephone"></i>
                    <span>Hotline: <strong>1900 xxxx</strong></span>
                </div>
                <div class="support-item">
                    <i class="bi bi-envelope"></i>
                    <span>Email: <strong>support@hospital.com</strong></span>
                </div>
                <div class="support-item">
                    <i class="bi bi-clock"></i>
                    <span>Làm việc: <strong>24/7</strong></span>
                </div>
            </div>
            
            <div class="text-center mt-3">
                <small class="text-muted">
                    <i class="bi bi-shield-check"></i> 
                    Giao dịch được bảo mật bởi MoMo
                </small>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto focus on retry button
        window.addEventListener('load', () => {
            document.querySelector('.btn-retry')?.focus();
        });
        
        // Log error for debugging
        console.error('Payment failed:', {
            resultCode: '${resultCode}',
            error: '${error}'
        });
    </script>
</body>
</html>