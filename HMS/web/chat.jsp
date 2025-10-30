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

        <script>
            // Sửa: userid -> userId (chữ I viết hoa)
            const currentUserId = parseInt('${sessionScope.user.userId}');
            const currentUsername = '${sessionScope.user.username}';
            let websocket = null;
            let selectedUserId = null;
            let typingTimeout = null;

            // Connect to WebSocket
            function connectWebSocket() {
                const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
                const wsUrl = protocol + '//' + window.location.host + '${pageContext.request.contextPath}/chat';

                websocket = new WebSocket(wsUrl);

                websocket.onopen = function () {
                    console.log('WebSocket connected');
                    // Register user
                    websocket.send(JSON.stringify({
                        action: 'register',
                        userId: currentUserId.toString()
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
                    setTimeout(connectWebSocket, 3000); // Reconnect after 3 seconds
                };
            }

            function handleWebSocketMessage(data) {
                console.log('WebSocket message received:', data); // Debug
                switch (data.type) {
                    case 'message':
                        if (data.senderId == selectedUserId || data.senderId == currentUserId) {
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
                        // Chỉ load user list một lần khi connect
                        break;
                }
            }

            function displayMessage(data) {
                const messagesDiv = document.getElementById('chatMessages');
                const messageDiv = document.createElement('div');
                messageDiv.className = 'message ' + (data.senderId == currentUserId ? 'sent' : 'received');

                const time = new Date(data.timestamp).toLocaleTimeString();
                messageDiv.innerHTML = `
                    <div>${data.content}</div>
                    <div class="message-time">${time}</div>
                `;

                messagesDiv.appendChild(messageDiv);
                messagesDiv.scrollTop = messagesDiv.scrollHeight;
            }

            function sendMessage() {
                const input = document.getElementById('messageInput');
                const content = input.value.trim();

                if (content && selectedUserId && websocket.readyState === WebSocket.OPEN) {
                    websocket.send(JSON.stringify({
                        action: 'sendMessage',
                        senderId: currentUserId,
                        receiverId: selectedUserId,
                        content: content,
                        type: 'text'
                    }));

                    input.value = '';
                }
            }

            function showTypingIndicator(isTyping) {
                const indicator = document.getElementById('typingIndicator');
                indicator.style.display = isTyping ? 'block' : 'none';
            }

            function sendTypingIndicator(isTyping) {
                if (selectedUserId && websocket.readyState === WebSocket.OPEN) {
                    websocket.send(JSON.stringify({
                        action: 'typing',
                        senderId: currentUserId,
                        receiverId: selectedUserId,
                        isTyping: isTyping
                    }));
                }
            }

            function loadUserList() {
                console.log('=== LOADING USER LIST ===');

                // Kiểm tra xem đã load chưa
                const userListDiv = document.getElementById('userList');
                if (userListDiv.hasAttribute('data-loaded')) {
                    console.log('User list already loaded, skipping...');
                    return;
                }

                fetch('${pageContext.request.contextPath}/getUserList')
                        .then(response => {
                            console.log('Response status:', response.status);
                            return response.json();
                        })
                        .then(users => {
                            console.log('Raw data from server:', JSON.stringify(users, null, 2));
                            console.log('Number of users from server:', users.length);

                            userListDiv.innerHTML = ''; // Clear trước

                            let displayCount = 0;
                            users.forEach((user, index) => {
                                console.log(`Processing user ${index}:`, user);

                                const userDiv = document.createElement('div');
                                userDiv.className = 'user-item';
                                userDiv.setAttribute('data-user-id', user.user_id);
                                userDiv.innerHTML =
                                        '<span class="status-indicator status-online"></span>' +
                                        user.username + ' (' + user.role + ') [ID: ' + user.user_id + ']';
                                userDiv.onclick = () => selectUser(user.user_id, user.username);
                                userListDiv.appendChild(userDiv);
                                displayCount++;
                            });

                            console.log('Total users displayed:', displayCount);
                            userListDiv.setAttribute('data-loaded', 'true');
                        })
                        .catch(error => {
                            console.error('Error loading users:', error);
                        });
            }

            function selectUser(userId, username) {
                selectedUserId = userId;
                document.getElementById('chatWithUser').textContent = username;
                document.getElementById('chatContainer').style.display = 'block';
                document.getElementById('chatMessages').innerHTML = '';

                // Load chat history
                loadChatHistory(userId);

                // Update UI
                document.querySelectorAll('.user-item').forEach(item => {
                    item.classList.remove('active');
                });
                event.target.classList.add('active');
            }

            function loadChatHistory(otherUserId) {
                fetch(`${pageContext.request.contextPath}/getChatHistory?userId1=${currentUserId}&userId2=${otherUserId}&limit=50`)
                        .then(response => response.json())
                        .then(messages => {
                            messages.reverse().forEach(msg => {
                                displayMessage({
                                    senderId: msg.senderId,
                                    content: msg.messageContent,
                                    timestamp: new Date(msg.sentAt).getTime()
                                });
                            });
                        })
                        .catch(error => console.error('Error loading chat history:', error));
            }

            function showNotification(message) {
                // You can use browser notification API or display in UI
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

                typingTimeout = setTimeout(() => {
                    sendTypingIndicator(false);
                }, 1000);
            });

            // Initialize
            window.addEventListener('load', function () {
                loadUserList(); // Load user list khi trang load xong
                connectWebSocket(); // Sau đó mới connect WebSocket
            });
        </script>
    </body>
</html>