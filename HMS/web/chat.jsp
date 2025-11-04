<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hệ Thống Nhắn Tin - ${sessionScope.user.username}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        body {
            background-color: #ffffff;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
        }

        .chat-main-container {
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .chat-header-title {
            background: #ffffff;
            color: #2c3e50;
            padding: 30px 0;
            margin-bottom: 30px;
            border-bottom: 2px solid #e9ecef;
        }

        .chat-header-title h2 {
            font-size: 1.8rem;
            font-weight: 700;
            margin: 0;
        }

        .chat-wrapper {
            display: flex;
            gap: 20px;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            border: 1px solid #e9ecef;
            overflow: hidden;
            height: 600px;
        }

        /* User List */
        .user-list {
            width: 320px;
            background: #f8f9fa;
            border-right: 1px solid #e9ecef;
            display: flex;
            flex-direction: column;
        }

        .user-list h3 {
            padding: 20px;
            margin: 0;
            background: #ffffff;
            border-bottom: 1px solid #e9ecef;
            font-size: 1.2rem;
            font-weight: 700;
            color: #2c3e50;
        }

        .user-list-content {
            flex: 1;
            overflow-y: auto;
            padding: 10px;
        }

        .user-item {
            padding: 15px;
            cursor: pointer;
            border-radius: 8px;
            margin-bottom: 8px;
            transition: all 0.3s;
            background: #ffffff;
            border: 1px solid #e9ecef;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .user-item:hover {
            background: #e9ecef;
            border-color: #dee2e6;
            transform: translateX(5px);
        }

        .user-item.active {
            background: #495057;
            color: white;
            border-color: #343a40;
        }

        .status-indicator {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            flex-shrink: 0;
        }

        .status-online {
            background-color: #28a745;
            box-shadow: 0 0 0 2px rgba(40, 167, 69, 0.2);
        }

        .status-offline {
            background-color: #6c757d;
        }

        /* Chat Container */
        .chat-container {
            flex: 1;
            display: flex;
            flex-direction: column;
            background: #ffffff;
        }

        .chat-header {
            padding: 20px;
            background: #f8f9fa;
            border-bottom: 2px solid #e9ecef;
            font-weight: 600;
            font-size: 1.1rem;
            color: #2c3e50;
        }

        .chat-header i {
            margin-right: 8px;
            color: #6c757d;
        }

        .chat-messages {
            flex: 1;
            overflow-y: auto;
            padding: 20px;
            background: #ffffff;
        }

        .message {
            margin-bottom: 15px;
            padding: 12px 16px;
            border-radius: 12px;
            max-width: 70%;
            word-wrap: break-word;
            animation: fadeIn 0.3s ease;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .message.sent {
            background: #495057;
            color: white;
            margin-left: auto;
            border-bottom-right-radius: 4px;
        }

        .message.received {
            background: #f8f9fa;
            color: #2c3e50;
            border: 1px solid #e9ecef;
            margin-right: auto;
            border-bottom-left-radius: 4px;
        }

        .message-time {
            font-size: 0.75rem;
            opacity: 0.7;
            margin-top: 5px;
        }

        .typing-indicator {
            padding: 15px 20px;
            background: #e3f2fd;
            border-top: 1px solid #bbdefb;
            color: #1565c0;
            font-style: italic;
            display: none;
            animation: pulse 1.5s infinite;
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.6; }
        }

        .chat-input-container {
            padding: 20px;
            background: #f8f9fa;
            border-top: 2px solid #e9ecef;
            display: flex;
            gap: 12px;
        }

        #messageInput {
            flex: 1;
            padding: 12px 16px;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s;
            background: #ffffff;
        }

        #messageInput:focus {
            outline: none;
            border-color: #495057;
            box-shadow: 0 0 0 3px rgba(73, 80, 87, 0.1);
        }

        #sendBtn {
            padding: 12px 30px;
            background: #495057;
            color: white;
            border: 1px solid #343a40;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
        }

        #sendBtn:hover {
            background: #343a40;
            border-color: #212529;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(52, 58, 64, 0.2);
        }

        #sendBtn:active {
            transform: translateY(0);
        }

        .empty-state {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100%;
            color: #868e96;
            text-align: center;
            padding: 40px;
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .empty-state h4 {
            margin-bottom: 10px;
            color: #495057;
        }

        .empty-state p {
            color: #868e96;
        }

        /* Scrollbar Styling */
        .user-list-content::-webkit-scrollbar,
        .chat-messages::-webkit-scrollbar {
            width: 8px;
        }

        .user-list-content::-webkit-scrollbar-track,
        .chat-messages::-webkit-scrollbar-track {
            background: #f8f9fa;
        }

        .user-list-content::-webkit-scrollbar-thumb,
        .chat-messages::-webkit-scrollbar-thumb {
            background: #dee2e6;
            border-radius: 4px;
        }

        .user-list-content::-webkit-scrollbar-thumb:hover,
        .chat-messages::-webkit-scrollbar-thumb:hover {
            background: #adb5bd;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .chat-wrapper {
                flex-direction: column;
                height: auto;
            }

            .user-list {
                width: 100%;
                max-height: 300px;
            }

            .chat-container {
                height: 500px;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/admin/header.jsp" />

    <div class="chat-main-container">
        <div class="chat-header-title">
            <div class="container">
                <h2>
                    <i class="fas fa-comments me-2"></i>Hệ Thống Nhắn Tin
                </h2>
            </div>
            
        </div>

        <div class="chat-wrapper">
            <!-- User List -->
            <div class="user-list">
                <h3>
                    <i class="fas fa-users me-2"></i>Danh Sách Người Dùng
                </h3>
                <div class="user-list-content" id="userList">
                    <!-- Users will be loaded here -->
                </div>
            </div>

            <!-- Chat Container -->
            <div class="chat-container" id="chatContainer">
                <div class="empty-state">
                    <i class="fas fa-comment-dots"></i>
                    <h4>Chọn một người dùng để bắt đầu trò chuyện</h4>
                    <p>Hãy chọn một người từ danh sách bên trái</p>
                </div>
            </div>

            <!-- Chat Area (hidden by default) -->
            <div class="chat-container" style="display: none;" id="chatArea">
                <div class="chat-header">
                    <i class="fas fa-user-circle"></i>
                    Chat với <span id="chatWithUser"></span>
                </div>

                <div class="chat-messages" id="chatMessages"></div>

                <div class="typing-indicator" id="typingIndicator">
                    <i class="fas fa-ellipsis-h"></i> Đang nhập...
                </div>

                <div class="chat-input-container">
                    <input type="text" id="messageInput" placeholder="Nhập tin nhắn của bạn..." />
                    <button id="sendBtn">
                        <i class="fas fa-paper-plane me-2"></i>Gửi
                    </button>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/admin/footer.jsp" />

    <%
        // Get user from session using scriptlet
        model.User sessionUser = (model.User) session.getAttribute("user");
        int userIdFromSession = (sessionUser != null) ? sessionUser.getUserId() : 0;
        String usernameFromSession = (sessionUser != null) ? sessionUser.getUsername() : "";
    %>

    <script>
        (function() {
            // ===== KHỞI TẠO BIẾN TRONG CLOSURE =====
            const CURRENT_USER_ID = <%= userIdFromSession %>;
            const CURRENT_USERNAME = "<%= usernameFromSession %>";
            
            console.log('=== INITIAL VALUES (IMMUTABLE) ===');
            console.log('CURRENT_USER_ID:', CURRENT_USER_ID, 'type:', typeof CURRENT_USER_ID);
            console.log('CURRENT_USERNAME:', CURRENT_USERNAME, 'type:', typeof CURRENT_USERNAME);

            // Validate
            if (!CURRENT_USER_ID || CURRENT_USER_ID <= 0) {
                alert('Lỗi phiên làm việc. Vui lòng đăng nhập lại.');
                window.location.href = '${pageContext.request.contextPath}/login.jsp';
                throw new Error('Invalid session');
            }

            // ===== BIẾN KHÁC =====
            let websocket = null;
            let selectedUserId = null;
            let typingTimeout = null;

            // Connect to WebSocket
            function connectWebSocket() {
                const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
                const wsUrl = protocol + '//' + window.location.host + '${pageContext.request.contextPath}/chat';

                websocket = new WebSocket(wsUrl);

                websocket.onopen = function () {
                    console.log('WebSocket connected for user:', CURRENT_USER_ID);
                    websocket.send(JSON.stringify({
                        action: 'register',
                        userId: CURRENT_USER_ID.toString()
                    }));
                };

                websocket.onmessage = function (event) {
                    const data = JSON.parse(event.data);
                    handleWebSocketMessage(data);
                };

                websocket.onerror = function (error) {
                    console.error('WebSocket error:', error);
                };

                websocket.onclose = function () {
                    console.log('WebSocket closed');
                    setTimeout(connectWebSocket, 3000);
                };
            }

            function handleWebSocketMessage(data) {
                console.log('WebSocket message received:', data);

                switch (data.type) {
                    case 'message':
                        const isFromSelectedUser = (data.senderId == selectedUserId && data.receiverId == CURRENT_USER_ID);
                        const isMyOwnMessage = (data.senderId == CURRENT_USER_ID);
                        
                        if (isFromSelectedUser && !isMyOwnMessage) {
                            displayMessage(data);
                        }
                        break;
                    case 'typing':
                        if (data.senderId == selectedUserId) {
                            showTypingIndicator(data.isTyping);
                        }
                        break;
                    case 'notification':
                        showNotification(data.content);
                        break;
                    case 'registered':
                        console.log('User registered:', data.userId);
                        break;
                }
            }

            function displayMessage(data) {
                const messagesDiv = document.getElementById('chatMessages');
                
                if (data.messageId && !data.isLocal) {
                    const existingMessage = messagesDiv.querySelector('[data-message-id="' + data.messageId + '"]');
                    if (existingMessage) {
                        console.log('Message already displayed, skipping:', data.messageId);
                        return;
                    }
                }
                
                const messageDiv = document.createElement('div');
                const isSentByMe = (data.senderId == CURRENT_USER_ID);
                messageDiv.className = 'message ' + (isSentByMe ? 'sent' : 'received');
                
                if (data.messageId) {
                    messageDiv.setAttribute('data-message-id', data.messageId);
                }

                const time = new Date(data.timestamp).toLocaleTimeString('vi-VN');
                messageDiv.innerHTML = 
                    '<div>' + data.content + '</div>' +
                    '<div class="message-time">' + time + '</div>';

                messagesDiv.appendChild(messageDiv);
                messagesDiv.scrollTop = messagesDiv.scrollHeight;
                
                console.log('Message displayed:', {
                    content: data.content,
                    isSentByMe: isSentByMe,
                    isLocal: data.isLocal
                });
            }

            function sendMessage() {
                const input = document.getElementById('messageInput');
                const content = input.value.trim();

                console.log('Sending message - CURRENT_USER_ID:', CURRENT_USER_ID);

                if (content && selectedUserId && websocket && websocket.readyState === WebSocket.OPEN) {
                    const timestamp = new Date().toISOString();
                    
                    displayMessage({
                        senderId: CURRENT_USER_ID,
                        receiverId: selectedUserId,
                        content: content,
                        timestamp: timestamp,
                        isLocal: true
                    });
                    
                    websocket.send(JSON.stringify({
                        action: 'sendMessage',
                        senderId: CURRENT_USER_ID,
                        receiverId: selectedUserId,
                        content: content,
                        type: 'text',
                        timestamp: timestamp
                    }));

                    input.value = '';
                }
            }

            function showTypingIndicator(isTyping) {
                const indicator = document.getElementById('typingIndicator');
                indicator.style.display = isTyping ? 'block' : 'none';
            }

            function sendTypingIndicator(isTyping) {
                if (selectedUserId && websocket && websocket.readyState === WebSocket.OPEN) {
                    websocket.send(JSON.stringify({
                        action: 'typing',
                        senderId: CURRENT_USER_ID,
                        receiverId: selectedUserId,
                        isTyping: isTyping
                    }));
                }
            }

            function loadUserList() {
                console.log('=== LOADING USER LIST ===');

                const userListDiv = document.getElementById('userList');
                if (userListDiv.hasAttribute('data-loaded')) {
                    console.log('User list already loaded, skipping...');
                    return;
                }

                fetch('${pageContext.request.contextPath}/getUserList')
                    .then(function(response) {
                        console.log('Response status:', response.status);
                        return response.json();
                    })
                    .then(function(users) {
                        console.log('Raw data from server:', JSON.stringify(users, null, 2));
                        console.log('Number of users from server:', users.length);

                        userListDiv.innerHTML = '';

                        let displayCount = 0;
                        users.forEach(function(user, index) {
                            console.log('Processing user ' + index + ':', user);

                            const userDiv = document.createElement('div');
                            userDiv.className = 'user-item';
                            userDiv.setAttribute('data-user-id', user.user_id);
                            userDiv.innerHTML =
                                '<span class="status-indicator status-online"></span>' +
                                '<div><strong>' + user.username + '</strong><br>' +
                                '<small style="color: #868e96;">' + user.role + '</small></div>';
                            userDiv.onclick = function() { 
                                selectUser(user.user_id, user.username); 
                            };
                            userListDiv.appendChild(userDiv);
                            displayCount++;
                        });

                        console.log('Total users displayed:', displayCount);
                        userListDiv.setAttribute('data-loaded', 'true');
                    })
                    .catch(function(error) {
                        console.error('Error loading users:', error);
                    });
            }

            function selectUser(userId, username) {
                console.log('=== SELECT USER ===');
                console.log('Selected user:', userId, username);

                selectedUserId = userId;
                document.getElementById('chatWithUser').textContent = username;
                
                // Hide empty state, show chat area
                document.getElementById('chatContainer').style.display = 'none';
                document.getElementById('chatArea').style.display = 'flex';

                document.getElementById('chatMessages').innerHTML = '';

                document.querySelectorAll('.user-item').forEach(function(item) {
                    item.classList.remove('active');
                    if (item.getAttribute('data-user-id') == userId) {
                        item.classList.add('active');
                    }
                });

                loadChatHistory(userId);
            }

            function loadChatHistory(otherUserId) {
                console.log('=== LOADING CHAT HISTORY ===');
                console.log('CURRENT_USER_ID:', CURRENT_USER_ID, 'type:', typeof CURRENT_USER_ID);
                console.log('otherUserId:', otherUserId, 'type:', typeof otherUserId);

                if (!CURRENT_USER_ID || isNaN(CURRENT_USER_ID) || CURRENT_USER_ID <= 0) {
                    console.error('INVALID CURRENT_USER_ID:', CURRENT_USER_ID);
                    alert('Lỗi phiên làm việc. Vui lòng tải lại trang.');
                    return;
                }

                if (!otherUserId || isNaN(otherUserId) || otherUserId <= 0) {
                    console.error('INVALID otherUserId:', otherUserId);
                    return;
                }

                const url = '${pageContext.request.contextPath}/getChatHistory?userId1=' + CURRENT_USER_ID + '&userId2=' + otherUserId + '&limit=50';
                console.log('Fetching URL:', url);

                fetch(url)
                    .then(function(response) {
                        console.log('Response status:', response.status);
                        console.log('Response ok:', response.ok);

                        if (!response.ok) {
                            return response.json().then(function(err) {
                                throw new Error(err.error || 'Failed to load chat history');
                            });
                        }
                        return response.json();
                    })
                    .then(function(messages) {
                        console.log('Chat history loaded:', messages.length + ' messages');

                        const chatMessages = document.getElementById('chatMessages');
                        chatMessages.innerHTML = '';

                        if (messages.length === 0) {
                            chatMessages.innerHTML = '<div style="padding: 40px; text-align: center; color: #868e96;"><i class="fas fa-inbox fa-3x mb-3" style="opacity: 0.3;"></i><br>Chưa có tin nhắn. Hãy bắt đầu cuộc trò chuyện!</div>';
                        } else {
                            messages.forEach(function(msg) {
                                displayMessage({
                                    senderId: msg.senderId,
                                    content: msg.messageContent,
                                    timestamp: msg.sentAt
                                });
                            });
                        }

                        chatMessages.scrollTop = chatMessages.scrollHeight;
                    })
                    .catch(function(error) {
                        console.error('Error loading chat history:', error);
                        const chatMessages = document.getElementById('chatMessages');
                        chatMessages.innerHTML = '<div style="padding: 40px; text-align: center; color: #dc3545;"><i class="fas fa-exclamation-triangle fa-2x mb-3"></i><br>Không thể tải lịch sử trò chuyện: ' + error.message + '</div>';
                    });
            }

            function showNotification(message) {
                console.log('Notification:', message);
            }

            // Event listeners
            document.getElementById('sendBtn').addEventListener('click', sendMessage);

            document.getElementById('messageInput').addEventListener('keypress', function (e) {
                if (e.key === 'Enter') {
                    sendMessage();
                }
            });

            document.getElementById('messageInput').addEventListener('input', function () {
                clearTimeout(typingTimeout);
                sendTypingIndicator(true);

                typingTimeout = setTimeout(function() {
                    sendTypingIndicator(false);
                }, 1000);
            });

            // Initialize
            window.addEventListener('load', function () {
                console.log('=== PAGE LOADED ===');
                console.log('CURRENT_USER_ID at page load:', CURRENT_USER_ID);
                console.log('CURRENT_USERNAME at page load:', CURRENT_USERNAME);
                
                loadUserList();
                connectWebSocket();
            });
        })();
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>