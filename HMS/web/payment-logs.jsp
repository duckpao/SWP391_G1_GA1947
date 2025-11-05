<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment Logs - MoMo Debug</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #1e1e1e;
            color: #d4d4d4;
            font-family: 'Consolas', 'Monaco', monospace;
        }
        
        .console-container {
            background-color: #252526;
            border-radius: 8px;
            padding: 20px;
            margin: 20px auto;
            max-width: 1400px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.5);
        }
        
        .console-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 15px 20px;
            border-radius: 8px 8px 0 0;
            margin: -20px -20px 20px -20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .console-header h2 {
            margin: 0;
            color: white;
            font-size: 1.5rem;
        }
        
        .log-entry {
            padding: 12px;
            border-left: 4px solid #3794ff;
            margin-bottom: 10px;
            background-color: #1e1e1e;
            border-radius: 4px;
            font-size: 14px;
            line-height: 1.6;
            word-wrap: break-word;
            transition: all 0.2s;
        }
        
        .log-entry:hover {
            background-color: #2d2d30;
            transform: translateX(5px);
        }
        
        .log-entry.INFO {
            border-left-color: #3794ff;
        }
        
        .log-entry.ERROR {
            border-left-color: #f48771;
            background-color: #2d1e1e;
        }
        
        .log-entry.REQUEST {
            border-left-color: #89d185;
            background-color: #1e2d1e;
        }
        
        .log-entry.RESPONSE {
            border-left-color: #dcdcaa;
            background-color: #2d2d1e;
        }
        
        .log-timestamp {
            color: #858585;
            font-size: 12px;
            margin-right: 10px;
        }
        
        .log-type {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: bold;
            margin-right: 10px;
        }
        
        .log-type.INFO {
            background-color: #3794ff;
            color: white;
        }
        
        .log-type.ERROR {
            background-color: #f48771;
            color: white;
        }
        
        .log-type.REQUEST {
            background-color: #89d185;
            color: #1e1e1e;
        }
        
        .log-type.RESPONSE {
            background-color: #dcdcaa;
            color: #1e1e1e;
        }
        
        .log-message {
            color: #d4d4d4;
            white-space: pre-wrap;
        }
        
        .btn-refresh {
            background-color: #3794ff;
            border: none;
            color: white;
            padding: 8px 20px;
            border-radius: 6px;
            font-weight: 500;
            transition: all 0.3s;
        }
        
        .btn-refresh:hover {
            background-color: #2a7fd8;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(55, 148, 255, 0.4);
        }
        
        .btn-clear {
            background-color: #f48771;
            border: none;
            color: white;
            padding: 8px 20px;
            border-radius: 6px;
            font-weight: 500;
            transition: all 0.3s;
        }
        
        .btn-clear:hover {
            background-color: #e76f5c;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(244, 135, 113, 0.4);
        }
        
        .empty-logs {
            text-align: center;
            padding: 60px;
            color: #858585;
        }
        
        .empty-logs i {
            font-size: 4rem;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        
        .auto-refresh-badge {
            background-color: rgba(255, 255, 255, 0.2);
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            margin-left: 10px;
        }
        
        .stats-bar {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            padding: 15px;
            background-color: #1e1e1e;
            border-radius: 6px;
        }
        
        .stat-item {
            flex: 1;
            text-align: center;
            padding: 10px;
            border-radius: 4px;
        }
        
        .stat-item.info {
            background-color: rgba(55, 148, 255, 0.1);
        }
        
        .stat-item.error {
            background-color: rgba(244, 135, 113, 0.1);
        }
        
        .stat-item.request {
            background-color: rgba(137, 209, 133, 0.1);
        }
        
        .stat-item.response {
            background-color: rgba(220, 220, 170, 0.1);
        }
        
        .stat-number {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .stat-label {
            font-size: 12px;
            color: #858585;
            text-transform: uppercase;
        }
    </style>
</head>
<body>
    <div class="console-container">
        <div class="console-header">
            <div>
                <h2><i class="bi bi-terminal"></i> MoMo Payment Debug Console</h2>
                <span class="auto-refresh-badge">
                    <i class="bi bi-arrow-clockwise"></i> Auto-refresh: 3s
                </span>
            </div>
            <div>
                <button class="btn btn-refresh" onclick="location.reload()">
                    <i class="bi bi-arrow-clockwise"></i> Refresh
                </button>
                <button class="btn btn-clear" onclick="clearLogs()">
                    <i class="bi bi-trash"></i> Clear Logs
                </button>
                <a href="invoices?action=pending" class="btn btn-refresh">
                    <i class="bi bi-receipt"></i> Back to Invoices
                </a>
            </div>
        </div>
        
        <!-- Statistics Bar -->
        <div class="stats-bar">
            <div class="stat-item info">
                <div class="stat-number" style="color: #3794ff;">
                    <c:set var="infoCount" value="0"/>
                    <c:forEach var="log" items="${logs}">
                        <c:if test="${log.type == 'INFO'}">
                            <c:set var="infoCount" value="${infoCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${infoCount}
                </div>
                <div class="stat-label">Info</div>
            </div>
            
            <div class="stat-item error">
                <div class="stat-number" style="color: #f48771;">
                    <c:set var="errorCount" value="0"/>
                    <c:forEach var="log" items="${logs}">
                        <c:if test="${log.type == 'ERROR'}">
                            <c:set var="errorCount" value="${errorCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${errorCount}
                </div>
                <div class="stat-label">Errors</div>
            </div>
            
            <div class="stat-item request">
                <div class="stat-number" style="color: #89d185;">
                    <c:set var="requestCount" value="0"/>
                    <c:forEach var="log" items="${logs}">
                        <c:if test="${log.type == 'REQUEST'}">
                            <c:set var="requestCount" value="${requestCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${requestCount}
                </div>
                <div class="stat-label">Requests</div>
            </div>
            
            <div class="stat-item response">
                <div class="stat-number" style="color: #dcdcaa;">
                    <c:set var="responseCount" value="0"/>
                    <c:forEach var="log" items="${logs}">
                        <c:if test="${log.type == 'RESPONSE'}">
                            <c:set var="responseCount" value="${responseCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    ${responseCount}
                </div>
                <div class="stat-label">Responses</div>
            </div>
        </div>
        
        <!-- Logs Display -->
        <c:choose>
            <c:when test="${empty logs}">
                <div class="empty-logs">
                    <i class="bi bi-inbox"></i>
                    <h4>No logs yet</h4>
                    <p>Try making a payment to see logs here</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="logs-container">
                    <c:forEach var="log" items="${logs}">
                        <div class="log-entry ${log.type}">
                            <span class="log-timestamp">${log.timestamp}</span>
                            <span class="log-type ${log.type}">${log.type}</span>
                            <div class="log-message">${log.message}</div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <script>
        function clearLogs() {
            if (confirm('Are you sure you want to clear all logs?')) {
                window.location.href = 'payment-logs?action=clear';
            }
        }
        
        // Auto-refresh every 3 seconds
        setTimeout(function() {
            location.reload();
        }, 3000);
        
        // Scroll to bottom on load
        window.addEventListener('load', function() {
            var logsContainer = document.querySelector('.logs-container');
            if (logsContainer && logsContainer.children.length > 0) {
                logsContainer.children[0].scrollIntoView({ behavior: 'smooth' });
            }
        });
    </script>
</body>
</html>