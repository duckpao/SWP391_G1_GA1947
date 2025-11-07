<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    .chat-badge-container {
        position: relative;
        display: inline-block;
    }
    
    .chat-unread-badge {
        position: absolute;
        top: -8px;
        right: -8px;
        min-width: 20px;
        height: 20px;
        background: #dc3545;
        color: white;
        border-radius: 50%;
        display: none;
        align-items: center;
        justify-content: center;
        font-size: 11px;
        font-weight: 700;
        padding: 2px 6px;
        box-shadow: 0 2px 4px rgba(220, 53, 69, 0.3);
        border: 2px solid #ffffff;
        animation: chat-badge-pulse 2s infinite;
        z-index: 10;
    }
    
    .chat-unread-badge.active {
        display: flex;
    }
    
    @keyframes chat-badge-pulse {
        0%, 100% {
            transform: scale(1);
            opacity: 1;
        }
        50% {
            transform: scale(1.1);
            opacity: 0.9;
        }
    }
</style>

<%
    // Get user from session
    model.User sessionUser = (model.User) session.getAttribute("user");
    int currentUserId = (sessionUser != null) ? sessionUser.getUserId() : 0;
%>

<span class="chat-unread-badge" id="chatUnreadBadge">0</span>

<script>
(function() {
    const CURRENT_USER_ID = <%= currentUserId %>;
    let chatWebSocket = null;
    let reconnectInterval = null;
    
    // K?t n?i WebSocket cho badge
    function connectChatBadgeWebSocket() {
        if (!CURRENT_USER_ID || CURRENT_USER_ID <= 0) {
            console.log('Chat badge: No valid user ID');
            return;
        }
        
        const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
        const wsUrl = protocol + '//' + window.location.host + '${pageContext.request.contextPath}/chat';
        
        console.log('Chat badge: Connecting to WebSocket...');
        chatWebSocket = new WebSocket(wsUrl);
        
        chatWebSocket.onopen = function() {
            console.log('Chat badge: WebSocket connected');
            
            // ??ng ký user
            chatWebSocket.send(JSON.stringify({
                action: 'register',
                userId: CURRENT_USER_ID.toString()
            }));
            
            // Load s? tin nh?n ch?a ??c ban ??u
            loadUnreadCount();
            
            // Clear reconnect interval n?u có
            if (reconnectInterval) {
                clearInterval(reconnectInterval);
                reconnectInterval = null;
            }
        };
        
        chatWebSocket.onmessage = function(event) {
            try {
                const data = JSON.parse(event.data);
                console.log('Chat badge: Message received', data.type);
                
                // Khi nh?n tin nh?n m?i
                if (data.type === 'message' && data.receiverId == CURRENT_USER_ID) {
                    // T?ng badge
                    incrementBadge();
                }
                
                // Khi tin nh?n ???c ?ánh d?u là ?ã ??c
                if (data.type === 'messagesRead' && data.readBy == CURRENT_USER_ID) {
                    // Load l?i s? tin nh?n ch?a ??c t? server
                    loadUnreadCount();
                    console.log('Chat badge: Messages marked as read, reloading count');
                }
                
                // Khi ?ánh d?u ??c thành công (t? phía ng??i ??c)
                if (data.type === 'markReadSuccess') {
                    // Load l?i badge count
                    loadUnreadCount();
                    console.log('Chat badge: Mark read success, reloading count');
                }
            } catch (e) {
                console.error('Chat badge: Error parsing message', e);
            }
        };
        
        chatWebSocket.onerror = function(error) {
            console.error('Chat badge: WebSocket error', error);
        };
        
        chatWebSocket.onclose = function() {
            console.log('Chat badge: WebSocket closed, reconnecting...');
            chatWebSocket = null;
            
            // Reconnect sau 3 giây
            if (!reconnectInterval) {
                reconnectInterval = setTimeout(function() {
                    connectChatBadgeWebSocket();
                }, 3000);
            }
        };
    }
    
    // Load s? tin nh?n ch?a ??c t? server
    function loadUnreadCount() {
        fetch('${pageContext.request.contextPath}/chat?action=getUnreadCount&userId=' + CURRENT_USER_ID)
            .then(function(response) {
                return response.json();
            })
            .then(function(data) {
                console.log('Chat badge: Unread count loaded:', data.count);
                updateBadge(data.count);
            })
            .catch(function(error) {
                console.error('Chat badge: Error loading unread count', error);
            });
    }
    
    // C?p nh?t badge
    function updateBadge(count) {
        const badge = document.getElementById('chatUnreadBadge');
        if (!badge) return;
        
        if (count > 0) {
            badge.textContent = count > 99 ? '99+' : count;
            badge.classList.add('active');
        } else {
            badge.classList.remove('active');
        }
    }
    
    // T?ng badge khi có tin nh?n m?i
    function incrementBadge() {
        const badge = document.getElementById('chatUnreadBadge');
        if (!badge) return;
        
        let currentCount = parseInt(badge.textContent) || 0;
        currentCount++;
        updateBadge(currentCount);
    }
    
    // Export function ?? các trang khác có th? g?i ?? reload badge
    window.reloadChatBadge = function() {
        console.log('Chat badge: Manual reload requested');
        loadUnreadCount();
    };
    
    // Export function ?? chat.jsp có th? decrease badge khi ?ánh d?u ??c
    window.decreaseChatBadge = function(count) {
        const badge = document.getElementById('chatUnreadBadge');
        if (!badge) return;
        
        let currentCount = parseInt(badge.textContent) || 0;
        currentCount = Math.max(0, currentCount - count); // Không cho âm
        updateBadge(currentCount);
        console.log('Chat badge: Decreased by', count, 'new count:', currentCount);
    };
    
    // Kh?i t?o khi page load
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
            connectChatBadgeWebSocket();
        });
    } else {
        connectChatBadgeWebSocket();
    }
    
    // Cleanup khi page unload
    window.addEventListener('beforeunload', function() {
        if (chatWebSocket) {
            chatWebSocket.close();
        }
        if (reconnectInterval) {
            clearTimeout(reconnectInterval);
        }
    });
})();
</script>