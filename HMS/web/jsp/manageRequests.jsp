<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Yêu cầu Cấp phát</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background: #ffffff;
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .header {
            background: white;
            padding: 25px 30px;
            border-radius: 15px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border-top: 4px solid #e5e7eb;
        }

        .header h1 {
            color: #000000;
            font-size: 28px;
            margin-bottom: 5px;
        }

        .back-btn {
            display: inline-block;
            background: #6c757d;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 8px;
            margin-top: 10px;
            font-weight: bold;
        }

        .back-btn:hover {
            background: #5a6268;
        }

        .alert {
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-weight: bold;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .requests-section {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-bottom: 20px;
        }

        .requests-section h2 {
            color: #000000;
            margin-bottom: 20px;
            font-size: 22px;
            border-bottom: 3px solid #e5e7eb;
            padding-bottom: 10px;
        }

        .request-card {
            background: #f9fafb;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 15px;
            border-left: 4px solid #e5e7eb;
        }

        .request-info {
            margin-bottom: 15px;
        }

        .request-info p {
            color: #000000;
            margin: 8px 0;
            font-size: 15px;
        }

        .request-info strong {
            color: #000000;
            min-width: 120px;
            display: inline-block;
        }

        .status {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: bold;
        }

        .status-pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-approved {
            background: #d4edda;
            color: #155724;
        }

        .status-rejected {
            background: #f8d7da;
            color: #721c24;
        }

        .btn-group {
            margin-top: 10px;
        }

        .btn {
            display: inline-block;
            padding: 8px 20px;
            text-decoration: none;
            border-radius: 6px;
            margin-right: 10px;
            font-weight: bold;
            font-size: 14px;
        }

        /* Changed button colors to gray */
        .btn-update {
            background: #6c757d;
            color: white;
        }

        .btn-update:hover {
            background: #5a6268;
        }

        .btn-cancel {
            background: #6c757d;
            color: white;
        }

        .btn-cancel:hover {
            background: #5a6268;
        }

        .history-link {
            background: white;
            padding: 20px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        }

        .history-link a {
            display: inline-block;
            background: #6c757d;
            color: white;
            padding: 12px 30px;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
            font-size: 16px;
        }

        .history-link a:hover {
            background: #5a6268;
        }

        .no-requests {
            text-align: center;
            padding: 40px;
            color: #000000;
            font-size: 16px;
        }
    </style>
</head>
<%@ include file="header.jsp" %>

<body>
    <div class="container">
        <div class="header">
            <h1>Quản lý Yêu cầu Cấp phát Thuốc</h1>
            <a href="doctor-dashboard" class="back-btn">Quay lại Dashboard</a>
        </div>

        <!-- Thông báo -->
        <c:if test="${not empty param.message}">
            <c:choose>
                <c:when test="${param.message == 'cancel_success'}">
                    <div class="alert alert-success">
                        Hủy yêu cầu thành công!
                    </div>
                </c:when>
                <c:when test="${param.message == 'error_cancel'}">
                    <div class="alert alert-error">
                        Hủy yêu cầu thất bại. Vui lòng thử lại!
                    </div>
                </c:when>
            </c:choose>
        </c:if>

        <!-- Danh sách yêu cầu đang chờ -->
        <div class="requests-section">
            <h2>Yêu cầu Đang Chờ Xử Lý</h2>
            
            <c:choose>
                <c:when test="${empty requests}">
                    <div class="no-requests">
                        Không có yêu cầu nào đang chờ xử lý
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="req" items="${requests}">
                        <div class="request-card">
                            <div class="request-info">
                                <p><strong>Mã yêu cầu:</strong> ${req.requestId}</p>
                                <p><strong>Ngày tạo:</strong> ${req.requestDate}</p>
                                <p><strong>Trạng thái:</strong> 
                                    <span class="status status-${req.status.toLowerCase()}">
                                        ${req.status}
                                    </span>
                                </p>
                                <p><strong>Ghi chú:</strong> ${req.notes != null && req.notes != '' ? req.notes : 'Không có'}</p>
                            </div>
                            <div class="btn-group">
                                <a href="update-request?requestId=${req.requestId}" class="btn btn-update">
                                    Cập nhật
                                </a>
                                <a href="cancel-request?requestId=${req.requestId}" 
                                   class="btn btn-cancel"
                                   onclick="return confirm('Bạn có chắc muốn hủy yêu cầu này?')">
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
            <a href="view-request-history">Xem Lịch sử Yêu cầu</a>
        </div>
    </div>
</body>
<%@ include file="footer.jsp" %>

</html>
