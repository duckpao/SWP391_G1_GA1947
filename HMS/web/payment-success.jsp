<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thanh toán thành công</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .success-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
            max-width: 600px;
            width: 100%;
        }
        .success-header {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            padding: 3rem 2rem;
            text-align: center;
            color: white;
        }
        .success-icon {
            width: 100px;
            height: 100px;
            background: white;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
            animation: scaleIn 0.5s ease-out;
        }
        @keyframes scaleIn {
            0% { transform: scale(0); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }
        .success-icon i {
            font-size: 3rem;
            color: #38ef7d;
        }
        .success-body {
            padding: 2rem;
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 1rem 0;
            border-bottom: 1px solid #f0f0f0;
        }
        .info-row:last-child {
            border-bottom: none;
        }
        .info-label {
            color: #666;
            font-weight: 500;
        }
        .info-value {
            font-weight: 600;
            color: #333;
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
        .btn-primary-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
        }
        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .confetti {
            position: fixed;
            width: 10px;
            height: 10px;
            background: #f0f0f0;
            position: absolute;
            animation: confetti-fall 3s linear infinite;
        }
        @keyframes confetti-fall {
            to {
                transform: translateY(100vh) rotate(360deg);
                opacity: 0;
            }
        }
    </style>
</head>
<body>
    <div class="success-card">
        <div class="success-header">
            <div class="success-icon">
                <i class="bi bi-check-circle-fill"></i>
            </div>
            <h2 class="mb-0">Thanh toán thành công!</h2>
            <p class="mb-0 mt-2">Giao dịch đã được xử lý thành công</p>
        </div>
        
        <div class="success-body">
            <div class="alert alert-success" role="alert">
                <i class="bi bi-info-circle"></i>
                <strong>Thông báo:</strong> ${message}
            </div>
            
            <div class="info-section">
                <h5 class="mb-3"><i class="bi bi-receipt"></i> Chi tiết giao dịch</h5>
                
                <div class="info-row">
                    <span class="info-label">
                        <i class="bi bi-hash"></i> Mã hóa đơn
                    </span>
                    <span class="info-value">#${invoiceId}</span>
                </div>
                
                <div class="info-row">
                    <span class="info-label">
                        <i class="bi bi-credit-card"></i> Mã giao dịch MoMo
                    </span>
                    <span class="info-value">${transactionId}</span>
                </div>
                
                <div class="info-row">
                    <span class="info-label">
                        <i class="bi bi-cash"></i> Số tiền
                    </span>
                    <span class="info-value text-success">
                        <fmt:formatNumber value="${amount}" pattern="#,###"/> VNĐ
                    </span>
                </div>
                
                <div class="info-row">
                    <span class="info-label">
                        <i class="bi bi-calendar-check"></i> Thời gian
                    </span>
                    <span class="info-value">
                        <jsp:useBean id="now" class="java.util.Date"/>
                        <fmt:formatDate value="${now}" pattern="dd/MM/yyyy HH:mm:ss"/>
                    </span>
                </div>
                
                <div class="info-row">
                    <span class="info-label">
                        <i class="bi bi-shield-check"></i> Trạng thái
                    </span>
                    <span class="info-value">
                        <span class="badge bg-success">
                            <i class="bi bi-check-all"></i> Đã thanh toán
                        </span>
                    </span>
                </div>
            </div>
            
            <div class="btn-group-custom">
                <a href="invoices" class="btn btn-primary-custom btn-custom">
                    <i class="bi bi-list-ul"></i> Xem danh sách hóa đơn
                </a>
                <a href="invoices?action=view&id=${invoiceId}" class="btn btn-outline-primary btn-custom">
                    <i class="bi bi-eye"></i> Xem chi tiết
                </a>
            </div>
            
            <div class="text-center mt-3">
                <button onclick="window.print()" class="btn btn-outline-secondary btn-sm">
                    <i class="bi bi-printer"></i> In biên nhận
                </button>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Confetti effect
        function createConfetti() {
            const colors = ['#ff6b6b', '#4ecdc4', '#45b7d1', '#f9ca24', '#6c5ce7'];
            for (let i = 0; i < 50; i++) {
                const confetti = document.createElement('div');
                confetti.className = 'confetti';
                confetti.style.left = Math.random() * 100 + '%';
                confetti.style.animationDelay = Math.random() * 3 + 's';
                confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                document.body.appendChild(confetti);
                
                setTimeout(() => confetti.remove(), 3000);
            }
        }
        
        // Trigger confetti on load
        window.addEventListener('load', createConfetti);
        
        // Auto redirect after 10 seconds
        setTimeout(() => {
            if (confirm('Bạn có muốn quay lại danh sách hóa đơn?')) {
                window.location.href = 'invoices';
            }
        }, 10000);
    </script>
</body>
</html>