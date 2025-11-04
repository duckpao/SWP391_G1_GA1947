<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử yêu cầu - Hệ thống quản lý kho bệnh viện</title>
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
            padding: 40px 20px;
        }

        .container {
            width: 100%;
            max-width: 1000px;
            margin: 0 auto;
        }

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
            text-align: center;
            border-bottom: 4px solid #3b82f6;
        }

        .header-icon {
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

        .header-section h1 {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .header-section p {
            font-size: 14px;
            color: #6b7280;
        }

        .search-section {
            padding: 40px 30px;
            background: white;
        }

        .search-form {
            display: grid;
            grid-template-columns: 1fr 1fr auto auto;
            gap: 16px;
            align-items: flex-end;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            font-size: 14px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }

        .form-control {
            padding: 12px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-size: 15px;
            font-family: inherit;
            transition: all 0.3s ease;
            background: #f9fafb;
        }

        .form-control:focus {
            outline: none;
            border-color: #3b82f6;
            background: white;
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: inherit;
        }

        .btn-search {
            background: #3b82f6;
            color: white;
        }

        .btn-search:hover {
            background: #2563eb;
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(59, 130, 246, 0.4);
        }

        .btn-clear {
            background: #e5e7eb;
            color: #374151;
        }

        .btn-clear:hover {
            background: #d1d5db;
        }

        .results-section {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            animation: slideUp 0.5s ease 0.1s both;
        }

        .results-header {
            background: #f9fafb;
            padding: 24px 30px;
            border-bottom: 1px solid #e5e7eb;
            border-left: 4px solid #3b82f6;
        }

        .results-header h2 {
            font-size: 18px;
            font-weight: 700;
            color: #1f2937;
        }

        .results-body {
            padding: 30px;
        }

        .request-item {
            padding: 20px;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            margin-bottom: 16px;
            transition: all 0.3s ease;
        }

        .request-item:hover {
            border-color: #3b82f6;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.1);
        }

        .request-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
            flex-wrap: wrap;
            gap: 12px;
        }

        .request-id {
            font-weight: 700;
            color: #1f2937;
            font-size: 16px;
        }

        .request-date {
            font-size: 14px;
            color: #6b7280;
        }

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

        .request-notes {
            font-size: 14px;
            color: #6b7280;
            margin-bottom: 12px;
        }

        .items-list {
            background: #f9fafb;
            border-radius: 8px;
            padding: 12px;
            margin-top: 12px;
        }

        .items-list li {
            list-style: none;
            padding: 8px 0;
            font-size: 14px;
            color: #374151;
            border-bottom: 1px solid #e5e7eb;
        }

        .items-list li:last-child {
            border-bottom: none;
        }

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

        .footer-section {
            padding: 24px 30px;
            background: #f9fafb;
            border-top: 1px solid #e5e7eb;
            text-align: center;
        }

        .footer-section a {
            color: #3b82f6;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.2s;
        }

        .footer-section a:hover {
            color: #2563eb;
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            .search-form {
                grid-template-columns: 1fr;
            }

            .request-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .header-section h1 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="page-header">
            <div class="header-section">
                <div class="header-icon">📋</div>
                <h1>Lịch sử yêu cầu</h1>
                <p>Hệ thống quản lý kho bệnh viện</p>
            </div>

            <!-- Search Form -->
            <div class="search-section">
                <form action="view-request-history" method="get" class="search-form">
                    <div class="form-group">
                        <label for="medicineName">Tìm theo tên thuốc</label>
                        <input 
                            type="text" 
                            id="medicineName"
                            name="medicineName" 
                            value="${param.medicineName}" 
                            placeholder="Nhập tên thuốc"
                            class="form-control">
                    </div>

                    <div class="form-group">
                        <label for="date">Tìm theo ngày</label>
                        <input 
                            type="date" 
                            id="date"
                            name="date" 
                            value="${param.date}"
                            class="form-control">
                    </div>

                    <button type="submit" class="btn btn-search">🔍 Tìm kiếm</button>
                    <a href="view-request-history" style="text-decoration: none;">
                        <button type="button" class="btn btn-clear">✕ Xóa bộ lọc</button>
                    </a>
                </form>
            </div>
        </div>

        <!-- Results -->
        <div class="results-section">
            <div class="results-header">
                <h2>Kết quả</h2>
            </div>

            <div class="results-body">
                <c:choose>
                    <c:when test="${empty requests}">
                        <div class="empty-state">
                            <div class="empty-state-icon">📭</div>
                            <h3>Không có yêu cầu nào</h3>
                            <p>Hãy thử điều chỉnh bộ lọc của bạn</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="req" items="${requests}">
                            <div class="request-item">
                                <div class="request-header">
                                    <span class="request-id">ID: ${req.requestId}</span>
                                    <span class="request-date">📅 ${req.requestDate}</span>
                                    <c:choose>
                                        <c:when test="${req.status == 'Pending'}">
                                            <span class="status-badge status-pending">${req.status}</span>
                                        </c:when>
                                        <c:when test="${req.status == 'Approved'}">
                                            <span class="status-badge status-approved">${req.status}</span>
                                        </c:when>
                                        <c:when test="${req.status == 'Rejected'}">
                                            <span class="status-badge status-rejected">${req.status}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge">${req.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <c:if test="${not empty req.notes}">
                                    <div class="request-notes">
                                        📝 Ghi chú: ${req.notes}
                                    </div>
                                </c:if>

                                <c:set var="items" value="${requestItemsMap[req.requestId]}"/>
                                <c:if test="${not empty items}">
                                    <div class="items-list">
                                        <c:forEach var="item" items="${items}">
                                            <li>💊 ${item.medicineName} - Số lượng: <strong>${item.quantity}</strong></li>
                                        </c:forEach>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="footer-section">
                <a href="manage-requests">← Quay lại Quản lý yêu cầu</a>
            </div>
        </div>
    </div>
</body>
</html>
