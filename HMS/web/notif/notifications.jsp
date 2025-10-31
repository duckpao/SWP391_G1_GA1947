<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông Báo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .notification-item {
            border-left: 4px solid #dee2e6;
            transition: all 0.3s ease;
        }
        .notification-item:hover {
            background-color: #f8f9fa;
            transform: translateX(5px);
        }
        .notification-item.unread {
            background-color: #e7f3ff;
            border-left-color: #0d6efd;
        }
        .notification-item.priority-urgent {
            border-left-color: #dc3545;
        }
        .notification-item.priority-high {
            border-left-color: #fd7e14;
        }
        .notification-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
        }
        .type-info { background-color: #cfe2ff; color: #084298; }
        .type-warning { background-color: #fff3cd; color: #664d03; }
        .type-success { background-color: #d1e7dd; color: #0f5132; }
        .type-error { background-color: #f8d7da; color: #842029; }
        .type-alert { background-color: #f8d7da; color: #842029; }
        .badge-priority {
            font-size: 0.75rem;
            padding: 0.25rem 0.5rem;
        }
        .notification-actions {
            opacity: 0;
            transition: opacity 0.3s;
        }
        .notification-item:hover .notification-actions {
            opacity: 1;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2>
                        <i class="fas fa-bell me-2"></i>Thông Báo
                        <c:if test="${unreadCount > 0}">
                            <span class="badge bg-danger ms-2" id="unreadBadge">${unreadCount}</span>
                        </c:if>
                    </h2>
                    <div>
                        <button class="btn btn-outline-primary" onclick="markAllAsRead()">
                            <i class="fas fa-check-double"></i> Đánh dấu tất cả đã đọc
                        </button>
                        
                        <%-- ✅ Dynamic back button based on user role --%>
                        <c:choose>
                            <c:when test="${sessionScope.user.role == 'Admin'}">
                                <a href="${pageContext.request.contextPath}/admin-dashboard" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i> Quay lại Dashboard
                                </a>
                            </c:when>
                            <c:when test="${sessionScope.user.role == 'Supplier'}">
                                <a href="${pageContext.request.contextPath}/supplier-dashboard" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i> Quay lại Dashboard
                                </a>
                            </c:when>
                            <c:when test="${sessionScope.user.role == 'Manager'}">
                                <a href="${pageContext.request.contextPath}/manager-dashboard" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i> Quay lại Dashboard
                                </a>
                            </c:when>
                            <c:when test="${sessionScope.user.role == 'Doctor'}">
                                <a href="${pageContext.request.contextPath}/doctor-dashboard" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i> Quay lại Dashboard
                                </a>
                            </c:when>
                            <c:when test="${sessionScope.user.role == 'Auditor'}">
                                <a href="${pageContext.request.contextPath}/auditor-dashboard" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i> Quay lại Dashboard
                                </a>
                            </c:when>
                            <c:when test="${sessionScope.user.role == 'Pharmacist'}">
                                <a href="${pageContext.request.contextPath}/view-medicine" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i> Quay lại
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i> Quay lại
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <c:if test="${empty notifications}">
                    <div class="alert alert-info text-center">
                        <i class="fas fa-info-circle fa-2x mb-3"></i>
                        <p class="mb-0">Bạn chưa có thông báo nào</p>
                    </div>
                </c:if>

                <div class="list-group" id="notificationList">
                    <c:forEach var="notif" items="${notifications}">
                        <div class="list-group-item notification-item ${notif.isRead() ? '' : 'unread'} priority-${notif.getPriority()}" 
                             data-id="${notif.getNotificationId()}" 
                             data-read="${notif.isRead()}">
                            <div class="d-flex align-items-start">
                                <div class="notification-icon type-${notif.getNotificationType()} me-3">
                                    <c:choose>
                                        <c:when test="${notif.getNotificationType() == 'info'}">
                                            <i class="fas fa-info"></i>
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
                                    </c:choose>
                                </div>
                                
                                <div class="flex-grow-1">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <h5 class="mb-1">
                                            ${notif.getTitle()}
                                            <c:if test="${!notif.isRead()}">
                                                <span class="badge bg-primary badge-priority ms-2">Mới</span>
                                            </c:if>
                                            <c:if test="${notif.getPriority() == 'urgent'}">
                                                <span class="badge bg-danger badge-priority ms-2">Khẩn cấp</span>
                                            </c:if>
                                            <c:if test="${notif.getPriority() == 'high'}">
                                                <span class="badge bg-warning badge-priority ms-2">Cao</span>
                                            </c:if>
                                        </h5>
                                        <div class="notification-actions">
                                            <c:if test="${!notif.isRead()}">
                                                <button class="btn btn-sm btn-outline-primary me-1" 
                                                        onclick="markAsRead(${notif.getNotificationId()})"
                                                        title="Đánh dấu đã đọc">
                                                    <i class="fas fa-check"></i>
                                                </button>
                                            </c:if>
                                            <button class="btn btn-sm btn-outline-danger" 
                                                    onclick="deleteNotification(${notif.getNotificationId()})"
                                                    title="Xóa">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </div>
                                    </div>
                                    
                                    <p class="mb-2">${notif.getMessage()}</p>
                                    
                                    <div class="d-flex justify-content-between align-items-center">
                                        <small class="text-muted">
                                            <i class="fas fa-user me-1"></i>
                                            Từ: ${notif.getSenderUsername()}
                                            <i class="fas fa-clock ms-3 me-1"></i>
                                            <fmt:formatDate value="${notif.getCreatedAt()}" 
                                                          pattern="dd/MM/yyyy HH:mm"/>
                                        </small>
                                        <c:if test="${not empty notif.getLinkUrl()}">
                                            <a href="${notif.getLinkUrl()}" class="btn btn-sm btn-outline-primary">
                                                <i class="fas fa-external-link-alt"></i> Xem chi tiết
                                            </a>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let lastCheckTime = new Date().getTime();

        // Đánh dấu một thông báo đã đọc
        function markAsRead(notificationId) {
            fetch('${pageContext.request.contextPath}/notifications?action=markAsRead&id=' + notificationId)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        const item = document.querySelector(`[data-id="${notificationId}"]`);
                        item.classList.remove('unread');
                        item.setAttribute('data-read', 'true');
                        updateUnreadCount();
                    }
                });
        }

        // Đánh dấu tất cả đã đọc
        function markAllAsRead() {
            if (confirm('Đánh dấu tất cả thông báo đã đọc?')) {
                fetch('${pageContext.request.contextPath}/notifications?action=markAllAsRead')
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            document.querySelectorAll('.notification-item.unread').forEach(item => {
                                item.classList.remove('unread');
                                item.setAttribute('data-read', 'true');
                            });
                            updateUnreadCount();
                        }
                    });
            }
        }

        // Xóa thông báo
        function deleteNotification(notificationId) {
            if (confirm('Bạn có chắc muốn xóa thông báo này?')) {
                fetch('${pageContext.request.contextPath}/notifications?action=delete&id=' + notificationId)
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            const item = document.querySelector(`[data-id="${notificationId}"]`);
                            item.style.opacity = '0';
                            setTimeout(() => item.remove(), 300);
                            updateUnreadCount();
                        }
                    });
            }
        }

        // Cập nhật số lượng thông báo chưa đọc
        function updateUnreadCount() {
            fetch('${pageContext.request.contextPath}/notifications?action=getUnreadCount')
                .then(response => response.json())
                .then(data => {
                    const badge = document.getElementById('unreadBadge');
                    if (data.unreadCount > 0) {
                        if (badge) {
                            badge.textContent = data.unreadCount;
                        } else {
                            const h2 = document.querySelector('h2');
                            h2.innerHTML += `<span class="badge bg-danger ms-2" id="unreadBadge">${data.unreadCount}</span>`;
                        }
                    } else {
                        if (badge) badge.remove();
                    }
                });
        }

        // Polling để kiểm tra thông báo mới (mỗi 10 giây)
        function checkForNewNotifications() {
            fetch('${pageContext.request.contextPath}/notifications?action=getLatest&since=' + lastCheckTime)
                .then(response => response.json())
                .then(notifications => {
                    if (notifications.length > 0) {
                        // Reload page để hiển thị thông báo mới
                        location.reload();
                    }
                    lastCheckTime = new Date().getTime();
                });
        }

        // Bắt đầu polling
        setInterval(checkForNewNotifications, 10000);
    </script>
</body>
</html>