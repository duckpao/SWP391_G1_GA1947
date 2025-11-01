<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông Báo - Hệ Thống Quản Lý Bệnh Viện</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-blue: #2c5f8d;
            --primary-light: #4a7ba7;
            --gray-50: #f9fafb;
            --gray-100: #f3f4f6;
            --gray-200: #e5e7eb;
            --gray-300: #d1d5db;
            --gray-400: #9ca3af;
            --gray-500: #6b7280;
            --gray-600: #4b5563;
            --gray-700: #374151;
            --gray-800: #1f2937;
            --success: #059669;
            --warning: #d97706;
            --danger: #dc2626;
            --info: #0284c7;
        }

        body {
            background: linear-gradient(135deg, #f9fafb 0%, #f3f4f6 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            color: var(--gray-800);
        }
        
        .notification-container {
            max-width: 1100px;
            margin: 0 auto;
            padding: 20px;
        }
        
        /* Header Card */
        .notification-header {
            background: white;
            padding: 28px 32px;
            border-radius: 12px;
            margin-bottom: 24px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05), 0 1px 2px rgba(0,0,0,0.06);
            border: 1px solid var(--gray-200);
            animation: slideDown 0.4s ease-out;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .page-title {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 0;
            font-size: 1.75rem;
            font-weight: 600;
            color: var(--primary-blue);
            letter-spacing: -0.02em;
        }

        .page-title i {
            color: var(--primary-light);
            font-size: 1.6rem;
        }

        /* Buttons - Medical Gray Theme */
        .btn-medical {
            background: white;
            color: var(--gray-700);
            border: 1.5px solid var(--gray-300);
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-medical:hover {
            background: var(--gray-50);
            border-color: var(--gray-400);
            color: var(--gray-800);
            transform: translateY(-1px);
            box-shadow: 0 2px 4px rgba(0,0,0,0.08);
        }

        .btn-medical:active {
            transform: translateY(0);
        }

        .btn-medical i {
            font-size: 0.95rem;
        }

        .btn-primary-medical {
            background: var(--primary-blue);
            color: white;
            border: 1.5px solid var(--primary-blue);
        }

        .btn-primary-medical:hover {
            background: var(--primary-light);
            border-color: var(--primary-light);
            color: white;
        }

        /* Notification Item */
        .notification-item {
            background: white;
            border: 1px solid var(--gray-200);
            border-left: 4px solid var(--gray-300);
            border-radius: 10px;
            margin-bottom: 14px;
            padding: 20px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            animation: fadeInUp 0.4s ease-out backwards;
        }

        .notification-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent 0%, rgba(44, 95, 141, 0.02) 100%);
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .notification-item:hover::before {
            opacity: 1;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(15px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .notification-item:nth-child(1) { animation-delay: 0.05s; }
        .notification-item:nth-child(2) { animation-delay: 0.1s; }
        .notification-item:nth-child(3) { animation-delay: 0.15s; }
        .notification-item:nth-child(4) { animation-delay: 0.2s; }
        .notification-item:nth-child(5) { animation-delay: 0.25s; }
        
        .notification-item:hover {
            box-shadow: 0 4px 12px rgba(44, 95, 141, 0.08);
            transform: translateX(4px);
            border-left-width: 5px;
        }
        
        .notification-item.unread {
            background: linear-gradient(to right, #f0f7ff 0%, #ffffff 100%);
            border-left-color: var(--primary-blue);
            box-shadow: 0 2px 8px rgba(44, 95, 141, 0.06);
        }
        
        .notification-item.priority-urgent {
            border-left-color: var(--danger);
        }
        
        .notification-item.priority-high {
            border-left-color: var(--warning);
        }
        
        /* Icon Styles */
        .notification-icon {
            width: 52px;
            height: 52px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
            flex-shrink: 0;
            transition: transform 0.3s ease;
        }

        .notification-item:hover .notification-icon {
            transform: scale(1.05);
        }
        
        .type-info { 
            background: linear-gradient(135deg, #e0f2fe 0%, #dbeafe 100%);
            color: var(--info);
        }
        
        .type-warning { 
            background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
            color: var(--warning);
        }
        
        .type-success { 
            background: linear-gradient(135deg, #d1fae5 0%, #bbf7d0 100%);
            color: var(--success);
        }
        
        .type-error { 
            background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
            color: var(--danger);
        }
        
        .type-alert { 
            background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%);
            color: var(--gray-600);
        }
        
        /* Badge Styles */
        .badge-unread {
            background: var(--primary-blue);
            color: white;
            font-size: 0.7rem;
            padding: 4px 10px;
            border-radius: 6px;
            font-weight: 600;
            letter-spacing: 0.02em;
        }

        .badge-priority {
            font-size: 0.7rem;
            padding: 4px 10px;
            border-radius: 6px;
            font-weight: 600;
            border: 1px solid;
        }

        .badge-urgent {
            background: #fee2e2;
            color: var(--danger);
            border-color: #fecaca;
        }

        .badge-high {
            background: #fef3c7;
            color: var(--warning);
            border-color: #fde68a;
        }

        .unread-count-badge {
            background: var(--danger);
            color: white;
            font-size: 0.85rem;
            padding: 6px 12px;
            border-radius: 8px;
            font-weight: 600;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.85; }
        }
        
        /* Action Buttons */
        .notification-actions {
            opacity: 0;
            transition: opacity 0.3s ease;
            display: flex;
            gap: 6px;
        }
        
        .notification-item:hover .notification-actions {
            opacity: 1;
        }

        .action-btn {
            padding: 6px 12px;
            border-radius: 6px;
            border: 1px solid var(--gray-300);
            background: white;
            color: var(--gray-600);
            font-size: 0.9rem;
            transition: all 0.2s ease;
            cursor: pointer;
        }

        .action-btn:hover {
            background: var(--gray-50);
            border-color: var(--gray-400);
            transform: translateY(-1px);
        }

        .action-btn.btn-check {
            color: var(--success);
            border-color: #bbf7d0;
        }

        .action-btn.btn-check:hover {
            background: #f0fdf4;
            border-color: var(--success);
        }

        .action-btn.btn-delete {
            color: var(--danger);
            border-color: #fecaca;
        }

        .action-btn.btn-delete:hover {
            background: #fef2f2;
            border-color: var(--danger);
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 80px 20px;
            background: white;
            border-radius: 12px;
            border: 2px dashed var(--gray-300);
            animation: fadeIn 0.6s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        .empty-state i {
            font-size: 72px;
            color: var(--gray-300);
            margin-bottom: 20px;
            animation: float 3s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        .empty-state h4 {
            color: var(--gray-700);
            font-weight: 600;
            margin-bottom: 8px;
        }

        .empty-state p {
            color: var(--gray-500);
        }

        /* WebSocket Status */
        .ws-indicator {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 0.85rem;
            background: var(--gray-50);
            border: 1px solid var(--gray-200);
            color: var(--gray-600);
            font-weight: 500;
        }

        .ws-indicator .dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: var(--gray-400);
        }

        .ws-indicator.connected {
            background: #f0fdf4;
            border-color: #bbf7d0;
            color: var(--success);
        }

        .ws-indicator.connected .dot {
            background: var(--success);
            animation: pulse-dot 2s infinite;
        }

        @keyframes pulse-dot {
            0%, 100% { opacity: 1; box-shadow: 0 0 0 0 rgba(5, 150, 105, 0.4); }
            50% { opacity: 0.8; box-shadow: 0 0 0 4px rgba(5, 150, 105, 0); }
        }

        .ws-indicator.connecting .dot {
            background: var(--warning);
            animation: blink 1s infinite;
        }

        @keyframes blink {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.3; }
        }

        /* Notification Content */
        .notification-title {
            font-size: 1.05rem;
            font-weight: 600;
            color: var(--gray-800);
            margin-bottom: 8px;
            line-height: 1.4;
        }

        .notification-message {
            color: var(--gray-600);
            line-height: 1.6;
            margin-bottom: 12px;
        }

        .notification-meta {
            font-size: 0.85rem;
            color: var(--gray-500);
        }

        .notification-meta strong {
            color: var(--gray-700);
            font-weight: 600;
        }

        .notification-meta i {
            color: var(--gray-400);
        }

        /* Link Button */
        .link-btn {
            padding: 6px 14px;
            border-radius: 6px;
            border: 1px solid var(--primary-blue);
            background: white;
            color: var(--primary-blue);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .link-btn:hover {
            background: var(--primary-blue);
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(44, 95, 141, 0.2);
        }

        /* Toast Notification */
        .toast-medical {
            position: fixed;
            top: 20px;
            right: 20px;
            background: white;
            border: 1px solid var(--gray-200);
            border-left: 4px solid var(--success);
            border-radius: 8px;
            padding: 16px 20px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            z-index: 9999;
            display: flex;
            align-items: center;
            gap: 12px;
            animation: slideInRight 0.3s ease-out;
        }

        @keyframes slideInRight {
            from {
                transform: translateX(400px);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        .toast-medical.toast-success { border-left-color: var(--success); }
        .toast-medical.toast-danger { border-left-color: var(--danger); }
        .toast-medical.toast-warning { border-left-color: var(--warning); }

        .toast-medical i {
            font-size: 1.2rem;
        }

        .toast-medical.toast-success i { color: var(--success); }
        .toast-medical.toast-danger i { color: var(--danger); }
        .toast-medical.toast-warning i { color: var(--warning); }

        /* Responsive */
        @media (max-width: 768px) {
            .notification-header {
                padding: 20px;
            }

            .page-title {
                font-size: 1.4rem;
            }

            .notification-item {
                padding: 16px;
            }

            .notification-icon {
                width: 44px;
                height: 44px;
            }

            .btn-medical {
                padding: 8px 14px;
                font-size: 0.9rem;
            }

            .notification-actions {
                opacity: 1;
            }
        }

        /* Loading Animation */
        .loading-spinner {
            display: inline-block;
            width: 16px;
            height: 16px;
            border: 2px solid var(--gray-300);
            border-radius: 50%;
            border-top-color: var(--primary-blue);
            animation: spin 0.6s linear infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <div class="container mt-4 notification-container">
        <div class="notification-header">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h2 class="page-title">
                    <i class="fas fa-bell"></i>
                    <span>Thông Báo</span>
                    <c:if test="${unreadCount > 0}">
                        <span class="unread-count-badge" id="unreadBadge">${unreadCount}</span>
                    </c:if>
                </h2>
                <div class="ws-indicator" id="wsIndicator">
                    <span class="dot"></span>
                    <span class="text">Đang kết nối...</span>
                </div>
            </div>
            <div class="d-flex justify-content-end gap-2 flex-wrap">
                <c:if test="${unreadCount > 0}">
                    <button class="btn-medical btn-primary-medical" onclick="markAllAsRead()">
                        <i class="fas fa-check-double"></i>
                        <span>Đánh dấu tất cả đã đọc</span>
                    </button>
                </c:if>
                
                <c:choose>
                    <c:when test="${sessionScope.user.role == 'Admin'}">
                        <a href="${pageContext.request.contextPath}/admin-dashboard" class="btn-medical">
                            <i class="fas fa-arrow-left"></i>
                            <span>Quay lại Dashboard</span>
                        </a>
                    </c:when>
                    <c:when test="${sessionScope.user.role == 'Supplier'}">
                        <a href="${pageContext.request.contextPath}/supplier-dashboard" class="btn-medical">
                            <i class="fas fa-arrow-left"></i>
                            <span>Quay lại Dashboard</span>
                        </a>
                    </c:when>
                    <c:when test="${sessionScope.user.role == 'Manager'}">
                        <a href="${pageContext.request.contextPath}/manager-dashboard" class="btn-medical">
                            <i class="fas fa-arrow-left"></i>
                            <span>Quay lại Dashboard</span>
                        </a>
                    </c:when>
                    <c:when test="${sessionScope.user.role == 'Doctor'}">
                        <a href="${pageContext.request.contextPath}/doctor-dashboard" class="btn-medical">
                            <i class="fas fa-arrow-left"></i>
                            <span>Quay lại Dashboard</span>
                        </a>
                    </c:when>
                    <c:when test="${sessionScope.user.role == 'Auditor'}">
                        <a href="${pageContext.request.contextPath}/auditor-dashboard" class="btn-medical">
                            <i class="fas fa-arrow-left"></i>
                            <span>Quay lại Dashboard</span>
                        </a>
                    </c:when>
                    <c:when test="${sessionScope.user.role == 'Pharmacist'}">
                        <a href="${pageContext.request.contextPath}/view-medicine" class="btn-medical">
                            <i class="fas fa-arrow-left"></i>
                            <span>Quay lại</span>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/dashboard" class="btn-medical">
                            <i class="fas fa-arrow-left"></i>
                            <span>Quay lại</span>
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty notifications}">
                <div class="empty-state">
                    <i class="fas fa-bell-slash"></i>
                    <h4>Chưa có thông báo</h4>
                    <p class="text-muted mb-0">Bạn sẽ nhận được thông báo ở đây khi có cập nhật mới từ hệ thống</p>
                </div>
            </c:when>
            <c:otherwise>
                <div id="notificationList">
                    <c:forEach var="notif" items="${notifications}">
                        <div class="notification-item ${notif.isRead() ? '' : 'unread'} priority-${notif.getPriority()}" 
                             data-id="${notif.getNotificationId()}" 
                             data-read="${notif.isRead()}">
                            <div class="d-flex align-items-start gap-3">
                                <div class="notification-icon type-${notif.getNotificationType()}">
                                    <c:choose>
                                        <c:when test="${notif.getNotificationType() == 'info'}">
                                            <i class="fas fa-info-circle"></i>
                                        </c:when>
                                        <c:when test="${notif.getNotificationType() == 'warning'}">
                                            <i class="fas fa-exclamation-triangle"></i>
                                        </c:when>
                                        <c:when test="${notif.getNotificationType() == 'success'}">
                                            <i class="fas fa-check-circle"></i>
                                        </c:when>
                                        <c:when test="${notif.getNotificationType() == 'error'}">
                                            <i class="fas fa-times-circle"></i>
                                        </c:when>
                                        <c:when test="${notif.getNotificationType() == 'alert'}">
                                            <i class="fas fa-bell"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-info-circle"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <div class="flex-grow-1">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <div>
                                            <h5 class="notification-title">
                                                ${notif.getTitle()}
                                                <c:if test="${!notif.isRead()}">
                                                    <span class="badge-unread ms-2">Mới</span>
                                                </c:if>
                                                <c:if test="${notif.getPriority() == 'urgent'}">
                                                    <span class="badge-priority badge-urgent ms-2">Khẩn cấp</span>
                                                </c:if>
                                                <c:if test="${notif.getPriority() == 'high'}">
                                                    <span class="badge-priority badge-high ms-2">Ưu tiên cao</span>
                                                </c:if>
                                            </h5>
                                        </div>
                                        <div class="notification-actions">
                                            <c:if test="${!notif.isRead()}">
                                                <button class="action-btn btn-check" 
                                                        onclick="markAsRead(${notif.getNotificationId()})"
                                                        title="Đánh dấu đã đọc">
                                                    <i class="fas fa-check"></i>
                                                </button>
                                            </c:if>
                                            <button class="action-btn btn-delete" 
                                                    onclick="deleteNotification(${notif.getNotificationId()})"
                                                    title="Xóa thông báo">
                                                <i class="fas fa-trash-alt"></i>
                                            </button>
                                        </div>
                                    </div>
                                    
                                    <p class="notification-message">${notif.getMessage()}</p>
                                    
                                    <div class="d-flex justify-content-between align-items-center">
                                        <small class="notification-meta">
                                            <i class="fas fa-user-md me-1"></i>
                                            <strong>${notif.getSenderUsername()}</strong>
                                            <i class="fas fa-clock ms-3 me-1"></i>
                                            <fmt:formatDate value="${notif.getCreatedAt()}" 
                                                          pattern="dd/MM/yyyy HH:mm"/>
                                        </small>
                                        <c:if test="${not empty notif.getLinkUrl()}">
                                            <a href="${notif.getLinkUrl()}" class="link-btn">
                                                <i class="fas fa-external-link-alt"></i>
                                                <span>Xem chi tiết</span>
                                            </a>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const contextPath = '${pageContext.request.contextPath}';

        console.log('Page loaded - Total notifications:', ${notifications.size()});
        console.log('Unread count:', ${unreadCount});

        // Đánh dấu một thông báo đã đọc
        function markAsRead(notificationId) {
            console.log('markAsRead called with ID:', notificationId);
            
            const item = document.querySelector(`[data-id="${notificationId}"]`);
            if (item) {
                item.style.opacity = '0.6';
                item.style.pointerEvents = 'none';
            }
            
            fetch(contextPath + '/notifications?action=markAsRead&id=' + notificationId, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                }
            })
            .then(response => {
                console.log('Response status:', response.status);
                if (!response.ok) {
                    throw new Error('Network response was not ok: ' + response.status);
                }
                return response.json();
            })
            .then(data => {
                console.log('Server response:', data);
                if (data.success) {
                    showToast('Đã đánh dấu đã đọc', 'success');
                    setTimeout(() => window.location.reload(), 600);
                } else {
                    if (item) {
                        item.style.opacity = '1';
                        item.style.pointerEvents = 'auto';
                    }
                    showToast('Không thể đánh dấu: ' + (data.message || 'Lỗi không xác định'), 'danger');
                }
            })
            .catch(error => {
                console.error('Error marking as read:', error);
                if (item) {
                    item.style.opacity = '1';
                    item.style.pointerEvents = 'auto';
                }
                showToast('Có lỗi xảy ra, vui lòng thử lại', 'danger');
            });
        }

        // Đánh dấu tất cả đã đọc
        function markAllAsRead() {
            if (!confirm('Đánh dấu tất cả thông báo là đã đọc?')) {
                return;
            }
            
            console.log('markAllAsRead called');
            
            const btn = event.target.closest('.btn-medical');
            if (btn) {
                btn.disabled = true;
                btn.innerHTML = '<span class="loading-spinner me-2"></span><span>Đang xử lý...</span>';
            }
            
            fetch(contextPath + '/notifications?action=markAllAsRead', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                }
            })
            .then(response => {
                console.log('Response status:', response.status);
                if (!response.ok) {
                    throw new Error('Network response was not ok: ' + response.status);
                }
                return response.json();
            })
            .then(data => {
                console.log('Server response:', data);
                if (data.success) {
                    showToast('Đã đánh dấu tất cả', 'success');
                    setTimeout(() => window.location.reload(), 600);
                } else {
                    if (btn) {
                        btn.disabled = false;
                        btn.innerHTML = '<i class="fas fa-check-double"></i><span>Đánh dấu tất cả đã đọc</span>';
                    }
                    showToast('Không thể đánh dấu: ' + (data.message || 'Lỗi không xác định'), 'danger');
                }
            })
            .catch(error => {
                console.error('Error marking all as read:', error);
                if (btn) {
                    btn.disabled = false;
                    btn.innerHTML = '<i class="fas fa-check-double"></i><span>Đánh dấu tất cả đã đọc</span>';
                }
                showToast('Có lỗi xảy ra, vui lòng thử lại', 'danger');
            });
        }

        // Xóa thông báo
        function deleteNotification(notificationId) {
            if (!confirm('Bạn có chắc muốn xóa thông báo này?')) {
                return;
            }
            
            console.log('=== DELETE NOTIFICATION ===');
            console.log('Notification ID:', notificationId);
            
            const item = document.querySelector(`[data-id="${notificationId}"]`);
            if (item) {
                item.style.opacity = '0.5';
                item.style.pointerEvents = 'none';
            }
            
            fetch(contextPath + '/notifications?action=delete&id=' + notificationId, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                }
            })
            .then(response => {
                console.log('Response status:', response.status);
                console.log('Response ok:', response.ok);
                if (!response.ok) {
                    throw new Error('Network response was not ok: ' + response.status);
                }
                return response.json();
            })
            .then(data => {
                console.log('Server response:', data);
                if (data.success) {
                    console.log('✓ Delete successful, reloading page...');
                    
                    // Smooth fade out animation
                    if (item) {
                        item.style.transition = 'all 0.4s ease-out';
                        item.style.opacity = '0';
                        item.style.transform = 'translateX(-30px)';
                    }
                    
                    showToast('Đã xóa thông báo', 'success');
                    setTimeout(() => {
                        console.log('Executing reload...');
                        window.location.reload();
                    }, 600);
                } else {
                    console.error('Delete failed:', data.message);
                    if (item) {
                        item.style.opacity = '1';
                        item.style.pointerEvents = 'auto';
                    }
                    showToast('Không thể xóa: ' + (data.message || 'Lỗi không xác định'), 'danger');
                }
            })
            .catch(error => {
                console.error('Error deleting notification:', error);
                if (item) {
                    item.style.opacity = '1';
                    item.style.pointerEvents = 'auto';
                }
                showToast('Có lỗi xảy ra: ' + error.message, 'danger');
            });
        }

        // Cập nhật số lượng thông báo chưa đọc
        function updateUnreadCount() {
            fetch(contextPath + '/notifications?action=getUnreadCount')
                .then(response => {
                    if (!response.ok) throw new Error('Network response was not ok');
                    return response.json();
                })
                .then(data => {
                    console.log('Unread count updated:', data.unreadCount);
                    const badge = document.getElementById('unreadBadge');
                    if (data.unreadCount > 0) {
                        if (badge) {
                            badge.textContent = data.unreadCount;
                        } else {
                            const title = document.querySelector('.page-title');
                            const newBadge = document.createElement('span');
                            newBadge.id = 'unreadBadge';
                            newBadge.className = 'unread-count-badge';
                            newBadge.textContent = data.unreadCount;
                            title.appendChild(newBadge);
                        }
                    } else {
                        if (badge) badge.remove();
                    }
                })
                .catch(error => console.error('Error updating unread count:', error));
        }

        // Medical-themed Toast notification
        function showToast(message, type = 'success') {
            const toast = document.createElement('div');
            toast.className = `toast-medical toast-${type}`;
            
            const icons = {
                'success': 'fa-check-circle',
                'danger': 'fa-times-circle',
                'warning': 'fa-exclamation-triangle',
                'info': 'fa-info-circle'
            };
            
            toast.innerHTML = `
                <i class="fas ${icons[type] || icons.info}"></i>
                <span style="color: var(--gray-800); font-weight: 500;">${message}</span>
            `;
            
            document.body.appendChild(toast);
            
            setTimeout(() => {
                toast.style.transition = 'all 0.3s ease-out';
                toast.style.opacity = '0';
                toast.style.transform = 'translateX(400px)';
                setTimeout(() => toast.remove(), 300);
            }, 2500);
        }

        // ============== WEBSOCKET FOR REAL-TIME UPDATES ==============
        let notificationPageWs = null;
        let reconnectAttempts = 0;
        const maxReconnectAttempts = 5;

        function updateWsIndicator(status) {
            const indicator = document.getElementById('wsIndicator');
            if (!indicator) return;

            const statusTexts = {
                'connected': 'Kết nối realtime',
                'connecting': 'Đang kết nối...',
                'disconnected': 'Mất kết nối'
            };

            indicator.className = 'ws-indicator ' + status;
            indicator.querySelector('.text').textContent = statusTexts[status] || 'Không xác định';
        }

        function initPageWebSocket() {
            <c:if test="${sessionScope.user == null}">
                console.log('No user logged in, skipping WebSocket');
                return;
            </c:if>

            const userId = ${sessionScope.user.userId};
            const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
            const wsUrl = protocol + '//' + window.location.host + contextPath + '/notifications';
            
            console.log('Connecting page WebSocket:', wsUrl);
            updateWsIndicator('connecting');
            
            try {
                notificationPageWs = new WebSocket(wsUrl);
                
                notificationPageWs.onopen = function() {
                    console.log('✓ Page WebSocket connected');
                    reconnectAttempts = 0;
                    updateWsIndicator('connected');
                    
                    // Register user
                    notificationPageWs.send(JSON.stringify({
                        action: 'register',
                        userId: userId
                    }));
                };
                
                notificationPageWs.onmessage = function(event) {
                    try {
                        const data = JSON.parse(event.data);
                        console.log('Page WebSocket message:', data);
                        
                        switch(data.type) {
                            case 'registered':
                                console.log('✓ Registered for notifications');
                                break;

                            case 'newNotification':
                                // Show toast and reload to display new notification
                                showToast('Bạn có thông báo mới!', 'info');
                                setTimeout(() => window.location.reload(), 1500);
                                break;
                                
                            case 'unreadCount':
                                // Update badge in real-time
                                const badge = document.getElementById('unreadBadge');
                                if (data.count > 0) {
                                    if (badge) {
                                        badge.textContent = data.count;
                                    } else {
                                        const title = document.querySelector('.page-title');
                                        const newBadge = document.createElement('span');
                                        newBadge.id = 'unreadBadge';
                                        newBadge.className = 'unread-count-badge';
                                        newBadge.textContent = data.count;
                                        title.appendChild(newBadge);
                                    }
                                } else {
                                    if (badge) badge.remove();
                                }
                                break;

                            case 'error':
                                console.error('WebSocket error:', data.message);
                                break;
                        }
                    } catch (e) {
                        console.error('Error parsing WebSocket message:', e);
                    }
                };
                
                notificationPageWs.onerror = function(error) {
                    console.error('❌ Page WebSocket error:', error);
                    updateWsIndicator('disconnected');
                };
                
                notificationPageWs.onclose = function() {
                    console.log('Page WebSocket closed');
                    updateWsIndicator('disconnected');
                    
                    // Try to reconnect
                    if (reconnectAttempts < maxReconnectAttempts) {
                        reconnectAttempts++;
                        const delay = Math.min(1000 * Math.pow(2, reconnectAttempts), 30000);
                        console.log(`Reconnecting in ${delay}ms (attempt ${reconnectAttempts}/${maxReconnectAttempts})`);
                        setTimeout(initPageWebSocket, delay);
                    } else {
                        console.log('Max reconnect attempts reached');
                    }
                };
                
            } catch (e) {
                console.error('Failed to create WebSocket:', e);
                updateWsIndicator('disconnected');
            }
        }

        // Cleanup on page unload
        window.addEventListener('beforeunload', function() {
            if (notificationPageWs && notificationPageWs.readyState === WebSocket.OPEN) {
                notificationPageWs.close();
            }
        });

        // Initialize WebSocket when page loads
        <c:if test="${sessionScope.user != null}">
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', initPageWebSocket);
        } else {
            initPageWebSocket();
        }
        </c:if>
    </script>
</body>
</html>