<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Yêu cầu Cấp phát</title>
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
            background: #ffffff;
            min-height: 100vh;
            padding: 40px 20px;
        }

        .container {
            width: 100%;
            max-width: 1000px;
            margin: 0 auto;
        }

        /* Page Header */
        .page-header {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            margin-bottom: 30px;
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

        .header-section {
            background: white;
            color: #1f2937;
            padding: 40px 30px;
            border-bottom: 4px solid #6c757d;
        }

        .header-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 16px;
        }

        .header-title {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .header-icon {
            width: 50px;
            height: 50px;
            background: #eff6ff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }

        .header-section h1 {
            font-size: 28px;
            font-weight: 700;
            margin: 0;
            color: #1f2937;
        }

        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: linear-gradient(135deg, #6c757d 0%, #5a6268 100%);
            color: white;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 12px;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(108, 117, 125, 0.2);
            position: relative;
            overflow: hidden;
        }

        .back-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s;
        }

        .back-btn:hover::before {
            left: 100%;
        }

        .back-btn:hover {
            background: linear-gradient(135deg, #5a6268 0%, #495057 100%);
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(108, 117, 125, 0.4);
            color: white;
        }

        .back-btn:active {
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(108, 117, 125, 0.3);
        }

        .header-section p {
            font-size: 14px;
            color: #6b7280;
            margin: 0;
        }

        /* Alert Messages */
        .alert {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 20px 30px;
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 12px;
            animation: slideUp 0.5s ease 0.05s both;
            border-left: 4px solid;
        }

        .alert-success {
            background: #d1fae5;
            color: #065f46;
            border-left-color: #10b981;
        }

        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            border-left-color: #ef4444;
        }

        .alert i {
            font-size: 20px;
        }

        /* Requests Section */
        .requests-section {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            animation: slideUp 0.5s ease 0.1s both;
            margin-bottom: 30px;
        }

        .section-header {
            background: #ffffff;
            padding: 24px 30px;
            border-bottom: 1px solid #e5e7eb;
            border-left: 4px solid #6c757d;
        }

        .section-header h2 {
            font-size: 18px;
            font-weight: 700;
            color: #1f2937;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-body {
            padding: 30px;
        }

        /* Request Card */
        .request-card {
            padding: 20px;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            margin-bottom: 16px;
            transition: all 0.3s ease;
            background: #ffffff;
        }

        .request-card:hover {
            border-color: #6c757d;
            box-shadow: 0 4px 12px rgba(108, 117, 125, 0.1);
        }

        .request-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 12px;
            margin-bottom: 16px;
        }

        .info-item {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .info-label {
            font-size: 12px;
            font-weight: 600;
            color: #6b7280;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .info-value {
            font-size: 14px;
            color: #1f2937;
            font-weight: 500;
        }

        /* Status Badge */
        .status-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }

        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .status-approved {
            background: #d1fae5;
            color: #065f46;
        }

        .status-rejected {
            background: #fee2e2;
            color: #991b1b;
        }

        /* Button Group */
        .btn-group {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 12px;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            position: relative;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
            transition: left 0.5s;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn-update {
            background: linear-gradient(135deg, #6c757d 0%, #5a6268 100%);
            color: white;
        }

        .btn-update:hover {
            background: linear-gradient(135deg, #5a6268 0%, #495057 100%);
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(108, 117, 125, 0.4);
            color: white;
        }

        .btn-update:active {
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(108, 117, 125, 0.3);
        }

        .btn-cancel {
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
            color: white;
        }

        .btn-cancel:hover {
            background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(239, 68, 68, 0.4);
            color: white;
        }

        .btn-cancel:active {
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(239, 68, 68, 0.3);
        }

        /* History Link Section */
        .history-section {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 30px;
            text-align: center;
            animation: slideUp 0.5s ease 0.15s both;
        }

        .history-section a {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: linear-gradient(135deg, #6c757d 0%, #5a6268 100%);
            color: white;
            padding: 16px 40px;
            text-decoration: none;
            border-radius: 12px;
            font-weight: 600;
            font-size: 15px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(108, 117, 125, 0.2);
            position: relative;
            overflow: hidden;
        }

        .history-section a::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s;
        }

        .history-section a:hover::before {
            left: 100%;
        }

        .history-section a:hover {
            background: linear-gradient(135deg, #5a6268 0%, #495057 100%);
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(108, 117, 125, 0.4);
            color: white;
        }

        .history-section a:active {
            transform: translateY(-1px);
            box-shadow: 0 4px 15px rgba(108, 117, 125, 0.3);
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 30px;
            color: #6b7280;
        }

        .empty-state-icon {
            font-size: 48px;
            margin-bottom: 16px;
        }

        .empty-state h3 {
            font-size: 18px;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 8px;
        }

        .empty-state p {
            font-size: 14px;
            color: #6b7280;
        }

        /* Responsive */
        @media (max-width: 768px) {
            body {
                padding: 20px 15px;
            }

            .header-section {
                padding: 30px 20px;
            }

            .header-top {
                flex-direction: column;
                align-items: flex-start;
            }

            .header-section h1 {
                font-size: 24px;
            }

            .section-body {
                padding: 20px;
            }

            .request-info {
                grid-template-columns: 1fr;
            }

            .btn-group {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <%@ include file="/admin/header.jsp" %>

    <div class="container">
        <!-- Header -->
        <div class="page-header">
            <div class="header-section">
                <div class="header-top">
                    <div class="header-title">
                        <div class="header-icon">📋</div>
                        <h1>Quản lý Yêu cầu Cấp phát</h1>
                    </div>
                    <a href="doctor-dashboard" class="back-btn">
                        ← Quay lại Dashboard
                    </a>
                </div>
                <p>Xem và quản lý các yêu cầu cấp phát thuốc đang chờ xử lý</p>
            </div>
        </div>

        <!-- Alert Messages -->
        <c:if test="${not empty param.message}">
            <c:choose>
                <c:when test="${param.message == 'cancel_success'}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        <span>Hủy yêu cầu thành công!</span>
                    </div>
                </c:when>
                <c:when test="${param.message == 'error_cancel'}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-triangle"></i>
                        <span>Hủy yêu cầu thất bại. Vui lòng thử lại!</span>
                    </div>
                </c:when>
            </c:choose>
        </c:if>

        <!-- Requests Section -->
        <div class="requests-section">
            <div class="section-header">
                <h2>
                    ⏳ Yêu cầu Đang Chờ Xử Lý
                </h2>
            </div>

            <div class="section-body">
                <c:choose>
                    <c:when test="${empty requests}">
                        <div class="empty-state">
                            <div class="empty-state-icon">📭</div>
                            <h3>Không có yêu cầu nào đang chờ xử lý</h3>
                            <p>Tất cả yêu cầu của bạn đã được xử lý hoặc chưa có yêu cầu nào.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="req" items="${requests}">
                            <div class="request-card">
                                <div class="request-info">
                                    <div class="info-item">
                                        <span class="info-label">Mã Yêu Cầu</span>
                                        <span class="info-value">#${req.requestId}</span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">Ngày Tạo</span>
                                        <span class="info-value">📅 ${req.requestDate}</span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">Trạng Thái</span>
                                        <span class="info-value">
                                            <span class="status-badge status-${req.status.toLowerCase()}">
                                                ${req.status}
                                            </span>
                                        </span>
                                    </div>
                                    <div class="info-item">
                                        <span class="info-label">Ghi Chú</span>
                                        <span class="info-value">
                                            ${req.notes != null && req.notes != '' ? req.notes : 'Không có'}
                                        </span>
                                    </div>
                                </div>
                                <div class="btn-group">
                                    <a href="update-request?requestId=${req.requestId}" class="btn btn-update">
                                        ✏️ Cập nhật
                                    </a>
                                    <a href="cancel-request?requestId=${req.requestId}" 
                                       class="btn btn-cancel"
                                       onclick="return confirm('Bạn có chắc muốn hủy yêu cầu này?')">
                                        ✕ Hủy yêu cầu
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- History Link -->
        <div class="history-section">
            <a href="view-request-history">
                🕐 Xem Lịch sử Yêu cầu
            </a>
        </div>
    </div>

    <%@ include file="/admin/footer.jsp" %>
</body>
</html>