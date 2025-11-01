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

    /* WebSocket status indicator */
    .ws-status {
        position: absolute;
        bottom: -2px;
        right: -2px;
        width: 8px;
        height: 8px;
        border-radius: 50%;
        background: #6c757d;
        border: 2px solid white;
    }

    .ws-status.connected {
        background: #28a745;
    }

    .ws-status.connecting {
        background: #ffc107;
        animation: blink 1s infinite;
    }

    @keyframes blink {
        0%, 100% { opacity: 1; }
        50% { opacity: 0.3; }
    }
</style>

<!-- Notification Bell - Direct Link -->
<div class="notification-bell-wrapper">
    <a href="${pageContext.request.contextPath}/notifications" class="notification-bell">
        <i class="fas fa-bell"></i>
        <span class="notification-count" id="notifCount">0</span>
        <span class="ws-status" id="wsStatus" title="WebSocket disconnected"></span>
    </a>
</div>

<script>
    let notificationWs = null;
    let reconnectAttempts = 0;
    let maxReconnectAttempts = 5;
    let reconnectTimeout = null;
    const contextPath = '${pageContext.request.contextPath}';
    const userId = ${sessionScope.user != null ? sessionScope.user.userId : 0};

    // Initialize WebSocket connection
    function initNotificationWebSocket() {
        if (userId === 0) {
            console.log('? No user logged in, skipping WebSocket connection');
            return;
        }

        const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
        const wsUrl = protocol + '//' + window.location.host + contextPath + '/notifications';

        
        console.log('Connecting to WebSocket:', wsUrl);
        updateWsStatus('connecting');

        try {
            notificationWs = new WebSocket(wsUrl);

            notificationWs.onopen = function() {
                console.log('? WebSocket connected');
                reconnectAttempts = 0;
                updateWsStatus('connected');
                
                // Register user
                const registerMsg = {
                    action: 'register',
                    userId: userId
                };
                notificationWs.send(JSON.stringify(registerMsg));
            };

            notificationWs.onmessage = function(event) {
                try {
                    const data = JSON.parse(event.data);
                    console.log('WebSocket message:', data);

                    switch(data.type) {
                        case 'registered':
                            console.log('? Registered for notifications');
                            break;

                        case 'unreadCount':
                            updateNotificationCount(data.count);
                            break;

                        case 'newNotification':
                            handleNewNotification(data);
                            break;

                        case 'error':
                            console.error('WebSocket error:', data.message);
                            break;

                        default:
                            console.log('Unknown message type:', data.type);
                    }
                } catch (e) {
                    console.error('Error parsing WebSocket message:', e);
                }
            };

            notificationWs.onerror = function(error) {
                console.error('? WebSocket error:', error);
                updateWsStatus('disconnected');
            };

            notificationWs.onclose = function() {
                console.log('WebSocket closed');
                updateWsStatus('disconnected');
                
                // Try to reconnect
                if (reconnectAttempts < maxReconnectAttempts) {
                    reconnectAttempts++;
                    const delay = Math.min(1000 * Math.pow(2, reconnectAttempts), 30000);
                    console.log(`Reconnecting in ${delay}ms (attempt ${reconnectAttempts}/${maxReconnectAttempts})`);
                    
                    reconnectTimeout = setTimeout(initNotificationWebSocket, delay);
                } else {
                    console.log('Max reconnect attempts reached. Falling back to polling.');
                    startPolling();
                }
            };

        } catch (e) {
            console.error('Failed to create WebSocket:', e);
            updateWsStatus('disconnected');
            startPolling();
        }
    }

    // Update WebSocket status indicator
    function updateWsStatus(status) {
        const statusEl = document.getElementById('wsStatus');
        if (statusEl) {
            statusEl.className = 'ws-status ' + status;
            const titles = {
                'connected': 'WebSocket connected - Real-time updates enabled',
                'connecting': 'Connecting to WebSocket...',
                'disconnected': 'WebSocket disconnected - Using fallback polling'
            };
            statusEl.title = titles[status] || 'Unknown status';
        }
    }

    // Update notification count
    function updateNotificationCount(count) {
        const countBadge = document.getElementById('notifCount');
        if (countBadge) {
            if (count > 0) {
                countBadge.textContent = count > 99 ? '99+' : count;
                countBadge.style.display = 'flex';
            } else {
                countBadge.style.display = 'none';
            }
            console.log('Updated notification count:', count);
        }
    }

    // Handle new notification
    function handleNewNotification(data) {
        console.log('New notification received:', data);
        
        // Update count immediately
        const countBadge = document.getElementById('notifCount');
        if (countBadge) {
            const currentCount = parseInt(countBadge.textContent) || 0;
            updateNotificationCount(currentCount + 1);
        }

        // Show browser notification if permission granted
        if (Notification.permission === "granted") {
            try {
                new Notification(data.title, {
                    body: data.message,
                    icon: contextPath + '/images/notification-icon.png',
                    tag: 'notification-' + Date.now()
                });
            } catch (error) {
                console.error('Error showing notification:', error);
            }
        }

        // Shake the bell icon
        const bell = document.querySelector('.notification-bell i');
        if (bell) {
            bell.style.animation = 'none';
            setTimeout(() => {
                bell.style.animation = 'shake 0.5s';
            }, 10);
        }
    }

    // Fallback polling if WebSocket fails
    function startPolling() {
        setInterval(function() {
            if (!notificationWs || notificationWs.readyState !== WebSocket.OPEN) {
                fetch(contextPath + '/notifications?action=getUnreadCount')
                    .then(response => response.json())
                    .then(data => {
                        updateNotificationCount(data.unreadCount);
                    })
                    .catch(error => console.error('Polling error:', error));
            }
        }, 30000); // Poll every 30 seconds
    }

    // Request notification permission
    if (typeof Notification !== 'undefined' && Notification.permission === "default") {
        Notification.requestPermission().then(permission => {
            console.log('Notification permission:', permission);
        });
    }

    // Load initial notification count
    function loadInitialCount() {
        if (userId === 0) return;
        
        fetch(contextPath + '/notifications?action=getUnreadCount')
            .then(response => response.json())
            .then(data => {
                updateNotificationCount(data.unreadCount);
            })
            .catch(error => console.error('Error loading count:', error));
    }

    // Cleanup on page unload
    window.addEventListener('beforeunload', function() {
        if (notificationWs) {
            notificationWs.close();
        }
        if (reconnectTimeout) {
            clearTimeout(reconnectTimeout);
        }
    });

    // Initialize when page loads
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            loadInitialCount();
            initNotificationWebSocket();
        });
    } else {
        loadInitialCount();
        initNotificationWebSocket();
    }

    // Add shake animation
    const style = document.createElement('style');
    style.textContent = `
        @keyframes shake {
            0%, 100% { transform: rotate(0deg); }
            10%, 30%, 50%, 70%, 90% { transform: rotate(-10deg); }
            20%, 40%, 60%, 80% { transform: rotate(10deg); }
        }
    `;
    document.head.appendChild(style);
</script>