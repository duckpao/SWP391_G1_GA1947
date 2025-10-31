<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Yêu cầu Cấp phát</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html, body {
            height: 100%;
        }

        body {
            display: flex;
            flex-direction: column;
            background-color: #f9fafb;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            font-size: 14px;
            line-height: 1.5;
            color: #374151;
            min-height: 100vh;
        }

        .page-wrapper {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .main {
            max-width: 1200px;
            margin: 0 auto;
            padding: 40px 20px 60px 20px;
            background-color: #f9fafb;
        }

        /* Page header */
        .page-header {
            background: white;
            padding: 30px;
            border-radius: 12px;
            margin-bottom: 24px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            border-left: 4px solid #6b7280;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }

        .page-header h1 {
            color: #1f2937;
            font-size: 28px;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #6b7280;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .back-btn:hover {
            background: #4b5563;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(107, 114, 128, 0.2);
            color: white;
        }

        /* Alert messages */
        .alert {
            padding: 16px 20px;
            border-radius: 10px;
            margin-bottom: 24px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-success {
            background: #d1fae5;
            color: #065f46;
            border: 1px solid #a7f3d0;
        }

        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }

        /* Requests section */
        .requests-section {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            margin-bottom: 24px;
        }

        .requests-section h2 {
            color: #1f2937;
            margin-bottom: 24px;
            font-size: 20px;
            font-weight: 700;
            border-bottom: 2px solid #e5e7eb;
            padding-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Request card */
        .request-card {
            background: #f9fafb;
            padding: 24px;
            border-radius: 10px;
            margin-bottom: 16px;
            border-left: 4px solid #6b7280;
            transition: all 0.3s ease;
        }

        .request-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            transform: translateX(4px);
        }

        .request-info {
            margin-bottom: 16px;
        }

        .request-info p {
            color: #374151;
            margin: 10px 0;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .request-info strong {
            color: #1f2937;
            min-width: 120px;
            font-weight: 600;
        }

        /* Status badges */
        .status {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 12px;
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

        /* Button group */
        .btn-group {
            margin-top: 12px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 10px 18px;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }

        .btn-update {
            background: #6b7280;
            color: white;
        }

        .btn-update:hover {
            background: #4b5563;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(107, 114, 128, 0.2);
            color: white;
        }

        .btn-cancel {
            background: #ef4444;
            color: white;
        }

        .btn-cancel:hover {
            background: #dc2626;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.2);
            color: white;
        }

        /* History link */
        .history-link {
            background: white;
            padding: 24px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            margin-bottom: 40px;
        }

        .history-link a {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: #6b7280;
            color: white;
            padding: 14px 32px;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 15px;
            transition: all 0.3s ease;
        }

        .history-link a:hover {
            background: #4b5563;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(107, 114, 128, 0.2);
            color: white;
        }

        /* Empty state */
        .no-requests {
            text-align: center;
            padding: 60px 20px;
            color: #9ca3af;
        }

        .no-requests h3 {
            color: #6b7280;
            font-size: 18px;
            margin-bottom: 8px;
        }

        .no-requests p {
            color: #9ca3af;
            font-size: 14px;
        }

        /* Scrollbar styling */
        ::-webkit-scrollbar {
            width: 8px;
        }

        ::-webkit-scrollbar-track {
            background: rgba(0, 0, 0, 0.05);
        }

        ::-webkit-scrollbar-thumb {
            background: rgba(0, 0, 0, 0.2);
            border-radius: 4px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: rgba(0, 0, 0, 0.3);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .main {
                padding: 20px 15px;
            }

            .page-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .page-header h1 {
                font-size: 22px;
            }

            .request-info p {
                flex-direction: column;
                align-items: flex-start;
                gap: 4px;
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

    <div class="page-wrapper">
        <div class="main">
            <div class="page-header">
                <h1>
                    <i class="bi bi-clipboard-check"></i>
                    Quản lý Yêu cầu Cấp phát Thuốc
                </h1>
                <a href="doctor-dashboard" class="back-btn">
                    <i class="bi bi-arrow-left"></i>
                    Quay lại Dashboard
                </a>
            </div>

            <!-- Thông báo -->
            <c:if test="${not empty param.message}">
                <c:choose>
                    <c:when test="${param.message == 'cancel_success'}">
                        <div class="alert alert-success">
                            <i class="bi bi-check-circle-fill"></i>
                            <span>Hủy yêu cầu thành công!</span>
                        </div>
                    </c:when>
                    <c:when test="${param.message == 'error_cancel'}">
                        <div class="alert alert-error">
                            <i class="bi bi-exclamation-triangle-fill"></i>
                            <span>Hủy yêu cầu thất bại. Vui lòng thử lại!</span>
                        </div>
                    </c:when>
                </c:choose>
            </c:if>

            <!-- Danh sách yêu cầu đang chờ -->
            <div class="requests-section">
                <h2>
                    <i class="bi bi-hourglass-split"></i>
                    Yêu cầu Đang Chờ Xử Lý
                </h2>
                
                <c:choose>
                    <c:when test="${empty requests}">
                        <div class="no-requests">
                            <h3>Không có yêu cầu nào đang chờ xử lý</h3>
                            <p>Tất cả yêu cầu của bạn đã được xử lý hoặc chưa có yêu cầu nào.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="req" items="${requests}">
                            <div class="request-card">
                                <div class="request-info">
                                    <p>
                                        <strong><i class="bi bi-hash"></i> Mã yêu cầu:</strong>
                                        <span>${req.requestId}</span>
                                    </p>
                                    <p>
                                        <strong><i class="bi bi-calendar-event"></i> Ngày tạo:</strong>
                                        <span>${req.requestDate}</span>
                                    </p>
                                    <p>
                                        <strong><i class="bi bi-flag"></i> Trạng thái:</strong>
                                        <span class="status status-${req.status.toLowerCase()}">
                                            ${req.status}
                                        </span>
                                    </p>
                                    <p>
                                        <strong><i class="bi bi-chat-left-text"></i> Ghi chú:</strong>
                                        <span>${req.notes != null && req.notes != '' ? req.notes : 'Không có'}</span>
                                    </p>
                                </div>
                                <div class="btn-group">
                                    <a href="update-request?requestId=${req.requestId}" class="btn btn-update">
                                        <i class="bi bi-pencil-square"></i>
                                        Cập nhật
                                    </a>
                                    <a href="cancel-request?requestId=${req.requestId}" 
                                       class="btn btn-cancel"
                                       onclick="return confirm('Bạn có chắc muốn hủy yêu cầu này?')">
                                        <i class="bi bi-x-circle"></i>
                                        Hủy yêu cầu
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Link xem lịch sử -->
            <div class="history-link">
                <a href="view-request-history">
                    <i class="bi bi-clock-history"></i>
                    Xem Lịch sử Yêu cầu
                </a>
            </div>
        </div>
    </div>

    <%@ include file="/admin/footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>