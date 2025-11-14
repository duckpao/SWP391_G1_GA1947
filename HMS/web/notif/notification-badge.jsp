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
</style>

<!-- Notification Bell - Direct Link -->
<div class="notification-bell-wrapper">
    <a href="${pageContext.request.contextPath}/notifications" class="notification-bell">
        <i class="fas fa-bell"></i>
        <span class="notification-count" id="notifCount">0</span>
    </a>
</div>

<script>
    (function() {
        var notifContextPath = '${pageContext.request.contextPath}';
        var notifUserId = ${sessionScope.user != null ? sessionScope.user.userId : 0};

        console.log('=== NOTIFICATION BADGE INIT ===');
        console.log('Context Path:', notifContextPath);
        console.log('User ID:', notifUserId);

        // Update notification count
        function updateNotificationCount(count) {
            var countBadge = document.getElementById('notifCount');
            if (countBadge) {
                if (count > 0) {
                    countBadge.textContent = count > 99 ? '99+' : count;
                    countBadge.style.display = 'flex';
                    console.log('? Notification count updated:', count);
                } else {
                    countBadge.style.display = 'none';
                    console.log('? No unread notifications');
                }
            }
        }

        // Load initial notification count (ONE TIME ONLY)
        function loadInitialCount() {
            if (notifUserId === 0) {
                console.log('? No user logged in');
                return;
            }
            
            console.log('? Loading notification count...');
            
            fetch(notifContextPath + '/notifications?action=getUnreadCount')
                .then(function(response) {
                    if (!response.ok) {
                        throw new Error('HTTP ' + response.status);
                    }
                    return response.json();
                })
                .then(function(data) {
                    console.log('? Server response:', data);
                    updateNotificationCount(data.unreadCount);
                })
                .catch(function(error) {
                    console.error('? Error loading count:', error);
                });
        }

        // Initialize when page loads
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', loadInitialCount);
        } else {
            loadInitialCount();
        }
    })();
</script>