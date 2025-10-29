<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chat System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        
        .chat-container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .chat-header {
            background: #007bff;
            color: white;
            padding: 15px;
            font-size: 18px;
            font-weight: bold;
        }
        
        .chat-messages {
            height: 400px;
            overflow-y: auto;
            padding: 20px;
            background: #fafafa;
        }
        
        .message {
            margin-bottom: 15px;
            padding: 10px 15px;
            border-radius: 18px;
            max-width: 70%;
            word-wrap: break-word;
        }
        
        .message.sent {
            background: #007bff;
            color: white;
            margin-left: auto;
            text-align: right;
        }
        
        .message.received {
            background: #e9ecef;
            color: #333;
        }
        
        .message-time {
            font-size: 11px;
            opacity: 0.7;
            margin-top: 5px;
        }
        
        .typing-indicator {
            padding: 10px;
            font-style: italic;
            color: #666;
            display: none;
        }
        
        .chat-input-container {
            padding: 15px;
            background: white;
            border-top: 1px solid #ddd;
            display: flex;
            gap: 10px;
        }
        
        #messageInput {
            flex: 1;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 25px;
            outline: none;
        }
        
        #sendBtn {
            padding: 10px 25px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-weight: bold;
        }
        
        #sendBtn:hover {
            background: #0056b3;
        }
        
        .user-list {
            max-width: 800px;
            margin: 20px auto;
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .user-item {
            padding: 10px;
            margin: 5px 0;
            background: #f8f9fa;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s;
        }
        
        .user-item:hover {
            background: #e9ecef;
        }
        
        .user-item.active {
            background: #007bff;
            color: white;
        }
        
        .status-indicator {
            display: inline-block;
            width: 8px;
            height: 8px;
            border-radius: 50%;
            margin-right: 8px;
        }
        
        .status-online {
            background: #28a745;
        }
        
        .status-offline {
            background: #dc3545;
        }
    </style>
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
        const currentUserId = ${sessionScope.user.userid};
        const currentUsername = '${sessionScope.user.username}';
        let websocket = null;
        let selectedUserId = null;
        let typingTimeout = null;

        // Connect to WebSocket
        function connectWebSocket() {
            const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
            const wsUrl = protocol + '//' + window.location.host + '${pageContext.request.contextPath}/chat';
            
            websocket = new WebSocket(wsUrl);
            
            websocket.onopen = function() {
                console.log('WebSocket connected');
                // Register user
                websocket.send(JSON.stringify({
                    action: 'register',
                    userId: currentUserId.toString()
                }));
            };
            
            websocket.onmessage = function(event) {
                const data = JSON.parse(event.data);
                handleWebSocketMessage(data);
            };
            
            websocket.onerror = function(error) {
                console.error('WebSocket error:', error);
            };
            
            websocket.onclose = function() {
                console.log('WebSocket closed');
                setTimeout(connectWebSocket, 3000); // Reconnect after 3 seconds
            };
        }

        function handleWebSocketMessage(data) {
            switch(data.type) {
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
                    loadUserList();
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
            fetch('${pageContext.request.contextPath}/getUserList')
                .then(response => response.json())
                .then(users => {
                    const userListDiv = document.getElementById('userList');
                    userListDiv.innerHTML = '';
                    
                    users.forEach(user => {
                        if (user.user_id != currentUserId) {
                            const userDiv = document.createElement('div');
                            userDiv.className = 'user-item';
                            userDiv.innerHTML = `
                                <span class="status-indicator status-online"></span>
                                ${user.username} (${user.role})
                            `;
                            userDiv.onclick = () => selectUser(user.user_id, user.username);
                            userListDiv.appendChild(userDiv);
                        }
                    });
                })
                .catch(error => console.error('Error loading users:', error));
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
        
        document.getElementById('messageInput').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                sendMessage();
            }
        });

        document.getElementById('messageInput').addEventListener('input', function() {
            clearTimeout(typingTimeout);
            sendTypingIndicator(true);
            
            typingTimeout = setTimeout(() => {
                sendTypingIndicator(false);
            }, 1000);
        });

        // Initialize
        connectWebSocket();
    </script>
</body>
</html>