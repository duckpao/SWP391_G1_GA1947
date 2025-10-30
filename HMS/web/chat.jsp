<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Chat System</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/chat.css">
    </head>
    <body>
        <div class="user-list">
            <h3>Select User to Chat</h3>
            <div id="userList"></div>
        </div>

        <div class="chat-container" style="display: none;" id="chatContainer">
            <div class="chat-header">
                Chat with <span id="chatWithUser"></span>
            </div>

            <div class="chat-messages" id="chatMessages"></div>

            <div class="typing-indicator" id="typingIndicator">
                User is typing...
            </div>

            <div class="chat-input-container">
                <input type="text" id="messageInput" placeholder="Type a message..." />
                <button id="sendBtn">Send</button>
            </div>
        </div>

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
                    alert('User session error. Please login again.');
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
                            // Hiển thị tin nhắn nếu:
                            // 1. Tin nhắn từ user đang chat (selectedUserId gửi cho tôi)
                            // 2. KHÔNG hiển thị tin nhắn tôi vừa gửi đi (vì đã hiển thị local rồi)
                            const isFromSelectedUser = (data.senderId == selectedUserId && data.receiverId == CURRENT_USER_ID);
                            const isMyOwnMessage = (data.senderId == CURRENT_USER_ID);
                            
                            // Chỉ hiển thị tin nhắn nhận được, không hiển thị tin nhắn tự gửi
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
                    
                    // Chỉ kiểm tra duplicate cho tin nhắn từ server (có messageId)
                    // Tin nhắn local (isLocal: true) luôn hiển thị
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

                    const time = new Date(data.timestamp).toLocaleTimeString();
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
                        
                        // Hiển thị tin nhắn NGAY LẬP TỨC trước khi gửi
                        displayMessage({
                            senderId: CURRENT_USER_ID,
                            receiverId: selectedUserId,
                            content: content,
                            timestamp: timestamp,
                            isLocal: true  // Đánh dấu đây là tin nhắn local
                        });
                        
                        // Sau đó mới gửi qua WebSocket
                        websocket.send(JSON.stringify({
                            action: 'sendMessage',
                            senderId: CURRENT_USER_ID,
                            receiverId: selectedUserId,
                            content: content,
                            type: 'text',
                            timestamp: timestamp
                        }));

                        // Clear input
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
                                    user.username + ' (' + user.role + ') [ID: ' + user.user_id + ']';
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
                    console.log('CURRENT_USER_ID before loadChatHistory:', CURRENT_USER_ID);

                    selectedUserId = userId;
                    document.getElementById('chatWithUser').textContent = username;
                    document.getElementById('chatContainer').style.display = 'block';

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

                    // Validate parameters - sử dụng CURRENT_USER_ID
                    if (!CURRENT_USER_ID || isNaN(CURRENT_USER_ID) || CURRENT_USER_ID <= 0) {
                        console.error('INVALID CURRENT_USER_ID:', CURRENT_USER_ID);
                        alert('Session error. Please reload the page.');
                        return;
                    }

                    if (!otherUserId || isNaN(otherUserId) || otherUserId <= 0) {
                        console.error('INVALID otherUserId:', otherUserId);
                        return;
                    }

                    // Build URL - sử dụng CURRENT_USER_ID
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
                                chatMessages.innerHTML = '<div style="padding: 20px; text-align: center; color: #999;">No messages yet. Start the conversation!</div>';
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
                            chatMessages.innerHTML = '<div style="padding: 20px; text-align: center; color: #dc3545;">Failed to load chat history: ' + error.message + '</div>';
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
    </body>
</html>