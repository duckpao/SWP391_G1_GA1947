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
        body {
            background-color: #f8f9fa;
        }
        
        .notification-container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .notification-item {
            background: white;
            border: 1px solid #dee2e6;
            border-left: 4px solid #dee2e6;
            border-radius: 8px;
            margin-bottom: 12px;
            padding: 16px;
            transition: all 0.3s ease;
        }
        
        .notification-item:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transform: translateX(5px);
        }
        
        /* ✅ CRITICAL: Only apply blue background to unread notifications */
        .notification-item.unread {
            background-color: #e7f3ff !important;
            border-left-color: #0d6efd !important;
        }
        
        /* ✅ Read notifications should be white */
        .notification-item:not(.unread) {
            background-color: #ffffff !important;
        }
        
        .notification-item.priority-urgent {
            border-left-color: #dc3545 !important;
        }
        
        .notification-item.priority-high {
            border-left-color: #fd7e14 !important;
        }
        
        .notification-icon {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
            flex-shrink: 0;
        }
        
        .type-info { 
            background-color: #d1ecf1; 
            color: #0c5460; 
        }
        
        .type-warning { 
            background-color: #fff3cd; 
            color: #856404; 
        }
        
        .type-success { 
            background-color: #d4edda; 
            color: #155724; 
        }
        
        .type-error { 
            background-color: #f8d7da; 
            color: #721c24; 
        }
        
        .type-alert { 
            background-color: #e2e3e5; 
            color: #383d41; 
        }
        
        .badge-priority {
            font-size: 0.75rem;
            padding: 0.35rem 0.65rem;
            font-weight: 600;
        }
        
        .notification-actions {
            opacity: 0;
            transition: opacity 0.3s;
        }
        
        .notification-item:hover .notification-actions {
            opacity: 1;
        }
        
        .notification-header {
            background: white;
            padding: 24px;
            border-radius: 8px;
            margin-bottom: 24px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 8px;
        }
        
        .empty-state i {
            font-size: 64px;
            color: #adb5bd;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container mt-4 notification-container">
        <div class="notification-header">
            <div class="d-flex justify-content-between align-items-center">
                <h2 class="mb-0">
                    <i class="fas fa-bell me-2"></i>Thông Báo
                    <c:if test="${unreadCount > 0}">
                        <span class="badge bg-danger ms-2" id="unreadBadge">${unreadCount}</span>
                    </c:if>
                </h2>
                <div>
                    <c:if test="${unreadCount > 0}">
                        <button class="btn btn-outline-primary me-2" onclick="markAllAsRead()">
                            <i class="fas fa-check-double"></i> Đánh dấu tất cả đã đọc
                        </button>
                    </c:if>
                    
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
        </div>

        <c:choose>
            <c:when test="${empty notifications}">
                <div class="empty-state">
                    <i class="fas fa-bell-slash"></i>
                    <h4>Chưa có thông báo</h4>
                    <p class="text-muted mb-0">Bạn sẽ nhận được thông báo ở đây khi có cập nhật mới</p>
                </div>
            </c:when>
            <c:otherwise>
                <div id="notificationList">
                    <c:forEach var="notif" items="${notifications}">
                        <div class="notification-item ${notif.isRead() ? '' : 'unread'} priority-${notif.getPriority()}" 
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
                                        <c:otherwise>
                                            <i class="fas fa-info"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <div class="flex-grow-1">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <div>
                                            <h5 class="mb-1">
                                                ${notif.getTitle()}
                                                <c:if test="${!notif.isRead()}">
                                                    <span class="badge bg-primary badge-priority ms-2">Mới</span>
                                                </c:if>
                                                <c:if test="${notif.getPriority() == 'urgent'}">
                                                    <span class="badge bg-danger badge-priority ms-2">Khẩn cấp</span>
                                                </c:if>
                                                <c:if test="${notif.getPriority() == 'high'}">
                                                    <span class="badge bg-warning text-dark badge-priority ms-2">Cao</span>
                                                </c:if>
                                            </h5>
                                        </div>
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
                                    
                                    <p class="mb-2 text-dark">${notif.getMessage()}</p>
                                    
                                    <div class="d-flex justify-content-between align-items-center">
                                        <small class="text-muted">
                                            <i class="fas fa-user me-1"></i>
                                            Từ: <strong>${notif.getSenderUsername()}</strong>
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
            </c:otherwise>
        </c:choose>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let lastCheckTime = new Date().getTime();

        // ✅ Debug: Log notification data on page load
        console.log('Total notifications:', ${notifications.size()});
        console.log('Unread count:', ${unreadCount});

        // Đánh dấu một thông báo đã đọc
        function markAsRead(notificationId) {
            fetch('${pageContext.request.contextPath}/notifications?action=markAsRead&id=' + notificationId, {
                method: 'POST'
            })
                .then(response => {
                    if (!response.ok) throw new Error('Network response was not ok');
                    return response.json();
                })
                .then(data => {
                    if (data.success) {
                        const item = document.querySelector(`[data-id="${notificationId}"]`);
                        if (item) {
                            item.classList.remove('unread');
                            item.setAttribute('data-read', 'true');
                            
                            // Remove "Mới" badge
                            const newBadge = item.querySelector('.badge.bg-primary');
                            if (newBadge) newBadge.remove();
                            
                            // Hide action button
                            const actionBtn = item.querySelector('.notification-actions');
                            if (actionBtn) {
                                const markBtn = actionBtn.querySelector('.btn-outline-primary');
                                if (markBtn) markBtn.remove();
                            }
                        }
                        updateUnreadCount();
                    }
                })
                .catch(error => {
                    console.error('Error marking as read:', error);
                    alert('Có lỗi xảy ra. Vui lòng thử lại!');
                });
        }

        // Đánh dấu tất cả đã đọc
        function markAllAsRead() {
            if (confirm('Đánh dấu tất cả thông báo đã đọc?')) {
                fetch('${pageContext.request.contextPath}/notifications?action=markAllAsRead', {
                    method: 'POST'
                })
                    .then(response => {
                        if (!response.ok) throw new Error('Network response was not ok');
                        return response.json();
                    })
                    .then(data => {
                        if (data.success) {
                            document.querySelectorAll('.notification-item.unread').forEach(item => {
                                item.classList.remove('unread');
                                item.setAttribute('data-read', 'true');
                                
                                // Remove "Mới" badges
                                const newBadge = item.querySelector('.badge.bg-primary');
                                if (newBadge) newBadge.remove();
                                
                                // Hide mark as read buttons
                                const actionBtn = item.querySelector('.notification-actions');
                                if (actionBtn) {
                                    const markBtn = actionBtn.querySelector('.btn-outline-primary');
                                    if (markBtn) markBtn.remove();
                                }
                            });
                            updateUnreadCount();
                        }
                    })
                    .catch(error => {
                        console.error('Error marking all as read:', error);
                        alert('Có lỗi xảy ra. Vui lòng thử lại!');
                    });
            }
        }

        // Xóa thông báo
        function deleteNotification(notificationId) {
            if (confirm('Bạn có chắc muốn xóa thông báo này?')) {
                fetch('${pageContext.request.contextPath}/notifications?action=delete&id=' + notificationId, {
                    method: 'POST'
                })
                    .then(response => {
                        if (!response.ok) throw new Error('Network response was not ok');
                        return response.json();
                    })
                    .then(data => {
                        if (data.success) {
                            const item = document.querySelector(`[data-id="${notificationId}"]`);
                            if (item) {
                                item.style.opacity = '0';
                                item.style.transform = 'translateX(-20px)';
                                setTimeout(() => {
                                    item.remove();
                                    
                                    // Check if no notifications left
                                    const remainingNotifs = document.querySelectorAll('.notification-item').length;
                                    if (remainingNotifs === 0) {
                                        location.reload();
                                    }
                                }, 300);
                            }
                            updateUnreadCount();
                        }
                    })
                    .catch(error => {
                        console.error('Error deleting notification:', error);
                        alert('Có lỗi xảy ra. Vui lòng thử lại!');
                    });
            }
        }

        // Cập nhật số lượng thông báo chưa đọc
        function updateUnreadCount() {
            fetch('${pageContext.request.contextPath}/notifications?action=getUnreadCount')
                .then(response => {
                    if (!response.ok) throw new Error('Network response was not ok');
                    return response.json();
                })
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
                })
                .catch(error => console.error('Error updating unread count:', error));
        }

        // Polling để kiểm tra thông báo mới (mỗi 30 giây)
        function checkForNewNotifications() {
            fetch('${pageContext.request.contextPath}/notifications?action=getLatest&since=' + lastCheckTime)
                .then(response => {
                    if (!response.ok) throw new Error('Network response was not ok');
                    return response.json();
                })
                .then(notifications => {
                    if (Array.isArray(notifications) && notifications.length > 0) {
                        // Show notification count update
                        const currentCount = ${unreadCount};
                        const newCount = notifications.filter(n => !n.isRead).length;
                        
                        if (newCount > 0) {
                            // Show toast notification
                            showToast(`Bạn có ${newCount} thông báo mới!`);
                            
                            // Reload after 2 seconds
                            setTimeout(() => location.reload(), 2000);
                        }
                    }
                    lastCheckTime = new Date().getTime();
                })
                .catch(error => console.error('Error checking notifications:', error));
        }

        // Simple toast notification
        function showToast(message) {
            const toast = document.createElement('div');
            toast.className = 'alert alert-info position-fixed top-0 end-0 m-3';
            toast.style.zIndex = '9999';
            toast.innerHTML = `<i class="fas fa-bell me-2"></i>${message}`;
            document.body.appendChild(toast);
            
            setTimeout(() => {
                toast.style.opacity = '0';
                setTimeout(() => toast.remove(), 300);
            }, 3000);
        }

        // Bắt đầu polling (chỉ nếu có thông báo)
        <c:if test="${not empty notifications}">
        setInterval(checkForNewNotifications, 30000);
        </c:if>
    </script>
</body>
</html>