<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Notification Badge Styles -->
<style>
    .notification-bell-wrapper {
        position: relative;
        display: inline-flex;
        align-items: center;
        z-index: 1000;
    }
    
    .notification-bell {
        position: relative;
        display: flex;
        align-items: center;
        justify-content: center;
        width: 40px;
        height: 40px;
        border-radius: 8px;
        background: #f8f9fa;
        border: 2px solid #dee2e6;
        font-size: 1.2rem;
        color: #495057;
        transition: all 0.3s ease;
        cursor: pointer;
        text-decoration: none;
    }
    
    .notification-bell:hover {
        background: #e9ecef;
        border-color: #adb5bd;
        color: #0d6efd;
        transform: translateY(-1px);
    }
    
    .notification-count {
        position: absolute;
        top: -6px;
        right: -6px;
        background: #dc3545;
        color: white;
        border-radius: 10px;
        min-width: 18px;
        height: 18px;
        display: none;
        align-items: center;
        justify-content: center;
        font-size: 0.6rem;
        font-weight: 700;
        padding: 0 4px;
        box-shadow: 0 2px 4px rgba(220, 53, 69, 0.3);
        animation: pulse 2s infinite;
    }
    
    @keyframes pulse {
        0%, 100% {
            transform: scale(1);
        }
        50% {
            transform: scale(1.15);
        }
    }
    
    .notification-dropdown {
        position: absolute;
        top: calc(100% + 8px);
        right: 0;
        width: 380px;
        max-height: 450px;
        overflow: hidden;
        border: 1px solid #dee2e6;
        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
        border-radius: 8px;
        background: white;
        display: none;
        z-index: 1050;
        opacity: 0;
        transform: translateY(-10px);
        transition: opacity 0.2s ease, transform 0.2s ease;
    }
    
    .notification-dropdown.show {
        display: block;
        opacity: 1;
        transform: translateY(0);
    }
    
    .notification-dropdown-header {
        background: #f8f9fa;
        padding: 16px 20px;
        border-bottom: 1px solid #dee2e6;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    
    .notification-dropdown-header h6 {
        margin: 0;
        font-size: 15px;
        font-weight: 700;
        color: #2c3e50;
    }
    
    .mark-all-read-btn {
        padding: 6px 12px;
        font-size: 12px;
        font-weight: 600;
        color: #0d6efd;
        background: transparent;
        border: 1px solid #0d6efd;
        border-radius: 6px;
        transition: all 0.3s;
        cursor: pointer;
    }
    
    .mark-all-read-btn:hover {
        background: #0d6efd;
        color: white;
    }
    
    .notification-list {
        max-height: 350px;
        overflow-y: auto;
        overflow-x: hidden;
    }
    
    .notification-item-mini {
        padding: 14px 20px;
        border-bottom: 1px solid #f1f3f5;
        transition: all 0.2s;
        cursor: pointer;
        display: flex;
        gap: 12px;
        align-items: flex-start;
        background: white;
    }
    
    .notification-item-mini:last-child {
        border-bottom: none;
    }
    
    .notification-item-mini:hover {
        background-color: #f8f9fa;
    }
    
    .notification-item-mini.unread {
        background-color: #e7f3ff !important;
        border-left: 3px solid #0d6efd;
        padding-left: 17px;
    }
    
    .notification-item-mini.unread:hover {
        background-color: #d7ebff;
    }
    
    .notification-icon {
        width: 36px;
        height: 36px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
        font-size: 14px;
        flex-shrink: 0;
    }
    
    .notification-icon.info {
        background: #d1ecf1;
        color: #0c5460;
    }
    
    .notification-icon.warning {
        background: #fff3cd;
        color: #856404;
    }
    
    .notification-icon.success {
        background: #d4edda;
        color: #155724;
    }
    
    .notification-icon.error {
        background: #f8d7da;
        color: #721c24;
    }
    
    .notification-icon.alert {
        background: #e2e3e5;
        color: #383d41;
    }
    
    .notification-content {
        flex: 1;
        min-width: 0;
        overflow: hidden;
    }
    
    .notification-title {
        font-size: 13px;
        font-weight: 600;
        color: #2c3e50;
        margin: 0 0 4px 0;
        line-height: 1.3;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }
    
    .notification-message {
        font-size: 12px;
        color: #6c757d;
        margin: 0 0 6px 0;
        line-height: 1.4;
        overflow: hidden;
        text-overflow: ellipsis;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        word-break: break-word;
    }
    
    .notification-time {
        font-size: 11px;
        color: #adb5bd;
        font-weight: 500;
    }
    
    .notification-empty {
        text-align: center;
        padding: 40px 20px;
        color: #adb5bd;
    }
    
    .notification-empty i {
        font-size: 48px;
        margin-bottom: 12px;
        opacity: 0.5;
    }
    
    .notification-empty p {
        margin: 0;
        font-size: 14px;
        font-weight: 500;
    }
    
    .notification-footer {
        text-align: center;
        padding: 12px;
        border-top: 1px solid #dee2e6;
        background: #f8f9fa;
    }
    
    .notification-footer a {
        font-size: 13px;
        font-weight: 600;
        color: #0d6efd;
        text-decoration: none;
        transition: color 0.3s;
    }
    
    .notification-footer a:hover {
        color: #0a58ca;
        text-decoration: none;
    }
    
    .notification-list::-webkit-scrollbar {
        width: 6px;
    }
    
    .notification-list::-webkit-scrollbar-track {
        background: #f1f3f5;
    }
    
    .notification-list::-webkit-scrollbar-thumb {
        background: #adb5bd;
        border-radius: 3px;
    }
    
    .notification-list::-webkit-scrollbar-thumb:hover {
        background: #868e96;
    }
    
    @media (max-width: 768px) {
        .notification-dropdown {
            width: calc(100vw - 32px);
            max-width: 380px;
            position: fixed;
            right: 16px;
            left: auto;
        }
    }
</style>

<!-- Notification Bell Dropdown -->
<div class="notification-bell-wrapper">
    <a href="javascript:void(0);" class="notification-bell" id="notificationDropdown" onclick="toggleNotificationDropdown()">
        <i class="fas fa-bell"></i>
        <span class="notification-count" id="notifCount">0</span>
    </a>

    <div class="notification-dropdown" id="notificationDropdownMenu">
        <div class="notification-dropdown-header">
            <h6>Notifications</h6>
            <button class="mark-all-read-btn" onclick="markAllAsReadQuick()">
                Mark all as read
            </button>
        </div>

        <div class="notification-list" id="notificationDropdownList">
            <div class="notification-empty">
                <i class="fas fa-bell-slash"></i>
                <p>No new notifications</p>
            </div>
        </div>

        <div class="notification-footer">
            <a href="${pageContext.request.contextPath}/notifications">
                View all notifications
            </a>
        </div>
    </div>
</div>

<script>
    let lastNotificationCheck = new Date().getTime();
    let isDropdownOpen = false;

    // Toggle notification dropdown
    function toggleNotificationDropdown() {
        const dropdown = document.getElementById('notificationDropdownMenu');
        isDropdownOpen = !isDropdownOpen;
        
        if (isDropdownOpen) {
            dropdown.classList.add('show');
            loadNotificationList();
        } else {
            dropdown.classList.remove('show');
        }
    }

    // Close dropdown when clicking outside
    document.addEventListener('click', function(event) {
        const wrapper = document.querySelector('.notification-bell-wrapper');
        const dropdown = document.getElementById('notificationDropdownMenu');
        
        if (!wrapper.contains(event.target) && isDropdownOpen) {
            dropdown.classList.remove('show');
            isDropdownOpen = false;
        }
    });

    // Prevent dropdown from closing when clicking inside
    document.getElementById('notificationDropdownMenu')?.addEventListener('click', function(event) {
        event.stopPropagation();
    });

    // Load notification count
    function loadNotifications() {
        fetch('${pageContext.request.contextPath}/notifications?action=getUnreadCount')
            .then(response => {
                if (!response.ok) throw new Error('Network response was not ok');
                return response.json();
            })
            .then(data => {
                console.log('Unread count data:', data); // ? Debug log
                const countBadge = document.getElementById('notifCount');
                if (data.unreadCount > 0) {
                    countBadge.textContent = data.unreadCount > 99 ? '99+' : data.unreadCount;
                    countBadge.style.display = 'flex';
                } else {
                    countBadge.style.display = 'none';
                }
            })
            .catch(error => {
                console.error('Error loading notifications:', error);
            });
    }

    // ? Helper function to safely get nested property
    function getProperty(obj, path, defaultValue = '') {
        return path.split('.').reduce((acc, part) => acc && acc[part], obj) || defaultValue;
    }

    // Load notification list
    function loadNotificationList() {
        const list = document.getElementById('notificationDropdownList');
        list.innerHTML = '<div class="notification-empty"><i class="fas fa-spinner fa-spin"></i><p>Loading...</p></div>';
        
        fetch('${pageContext.request.contextPath}/notifications?action=getLatest&since=' + (lastNotificationCheck - 86400000))
            .then(response => {
                if (!response.ok) throw new Error('Network response was not ok');
                return response.json();
            })
            .then(notifications => {
                console.log('Raw notifications data:', notifications); // ? Debug log
                
                if (!Array.isArray(notifications) || notifications.length === 0) {
                    list.innerHTML = `
                        <div class="notification-empty">
                            <i class="fas fa-bell-slash"></i>
                            <p>No new notifications</p>
                        </div>`;
                } else {
                    list.innerHTML = notifications.slice(0, 5).map(notif => {
                        // ? Handle both camelCase and snake_case
                        const notifType = notif.notificationType || notif.notification_type || 'info';
                        const isRead = notif.isRead !== undefined ? notif.isRead : 
                                      (notif.is_read !== undefined ? notif.is_read : false);
                        const notifId = notif.notificationId || notif.notification_id || 0;
                        const title = notif.title || 'Notification';
                        const message = notif.message || '';
                        const createdAt = notif.createdAt || notif.created_at || new Date().getTime();
                        
                        console.log('Processing notification:', { // ? Debug log
                            id: notifId,
                            type: notifType,
                            isRead: isRead,
                            title: title
                        });
                        
                        const iconClass = getNotificationIconClass(notifType);
                        const icon = getNotificationIcon(notifType);
                        const safeTitle = escapeHtml(title);
                        const safeMessage = escapeHtml(truncate(message, 80));
                        const formattedTime = formatTime(createdAt);

                        return `
                            <div class="notification-item-mini ${isRead ? '' : 'unread'}" 
                                 onclick="viewNotification(${notifId})"
                                 data-read="${isRead}">
                                <div class="notification-icon ${iconClass}">
                                    <i class="fas fa-${icon}"></i>
                                </div>
                                <div class="notification-content">
                                    <div class="notification-title">${safeTitle}</div>
                                    <div class="notification-message">${safeMessage}</div>
                                    <div class="notification-time">${formattedTime}</div>
                                </div>
                            </div>`;
                    }).join('');
                }
            })
            .catch(error => {
                console.error('Error loading notification list:', error);
                list.innerHTML = `
                    <div class="notification-empty">
                        <i class="fas fa-exclamation-triangle"></i>
                        <p>Error loading notifications</p>
                    </div>`;
            });
    }

    function getNotificationIcon(type) {
        const icons = {
            'info': 'info-circle',
            'warning': 'exclamation-triangle',
            'success': 'check-circle',
            'error': 'times-circle',
            'alert': 'bell'
        };
        return icons[type] || 'info-circle';
    }

    function getNotificationIconClass(type) {
        const classes = {
            'info': 'info',
            'warning': 'warning',
            'success': 'success',
            'error': 'error',
            'alert': 'alert'
        };
        return classes[type] || 'info';
    }

    function viewNotification(id) {
        window.location.href = '${pageContext.request.contextPath}/notifications?id=' + id;
    }

    function markAllAsReadQuick() {
        fetch('${pageContext.request.contextPath}/notifications?action=markAllAsRead', {
            method: 'POST'
        })
            .then(response => {
                if (!response.ok) throw new Error('Network response was not ok');
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    loadNotifications();
                    loadNotificationList();
                }
            })
            .catch(error => console.error('Error marking as read:', error));
    }

    function truncate(str, length) {
        if (!str) return '';
        return str.length > length ? str.substring(0, length) + '...' : str;
    }

    function escapeHtml(text) {
        if (!text) return '';
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    function formatTime(timestamp) {
        if (!timestamp) return '';
        
        // Handle both timestamp (number) and Date string
        let date;
        if (typeof timestamp === 'number') {
            date = new Date(timestamp);
        } else if (typeof timestamp === 'string') {
            date = new Date(timestamp);
        } else {
            date = new Date();
        }
        
        const now = new Date();
        const diff = Math.floor((now - date) / 1000);

        if (diff < 60) return 'Just now';
        if (diff < 3600) return Math.floor(diff / 60) + ' min ago';
        if (diff < 86400) return Math.floor(diff / 3600) + ' hr ago';
        if (diff < 2592000) return Math.floor(diff / 86400) + ' days ago';
        return date.toLocaleDateString();
    }

    function checkNewNotifications() {
        fetch('${pageContext.request.contextPath}/notifications?action=getLatest&since=' + lastNotificationCheck)
            .then(response => {
                if (!response.ok) throw new Error('Network response was not ok');
                return response.json();
            })
            .then(notifications => {
                if (Array.isArray(notifications) && notifications.length > 0) {
                    showNotificationToast(notifications[0]);
                    loadNotifications();
                }
                lastNotificationCheck = new Date().getTime();
            })
            .catch(error => console.error('Error checking notifications:', error));
    }

    function showNotificationToast(notif) {
        if (!notif) return;
        
        const title = notif.title || notif.Title || 'Notification';
        const message = notif.message || notif.Message || '';
        
        if (Notification.permission === "granted") {
            try {
                new Notification(title, {
                    body: message,
                    icon: '${pageContext.request.contextPath}/images/notification-icon.png',
                    tag: 'notification-' + (notif.notificationId || notif.notification_id || Math.random())
                });
            } catch (error) {
                console.error('Error showing notification:', error);
            }
        }
    }

    // Request notification permission
    if (Notification.permission === "default") {
        Notification.requestPermission();
    }

    // Initialize
    document.addEventListener('DOMContentLoaded', function() {
        console.log('Notification bell initialized'); // ? Debug log
        loadNotifications();
        setInterval(checkNewNotifications, 10000);
    });

    // Fallback if DOMContentLoaded already fired
    if (document.readyState === 'loading') {
        // Already added listener above
    } else {
        console.log('Notification bell initialized (fallback)'); // ? Debug log
        loadNotifications();
        setInterval(checkNewNotifications, 10000);
    }
</script>