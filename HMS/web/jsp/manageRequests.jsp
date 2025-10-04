<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Medication Requests</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 30px 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .header h1 {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 10px;
        }
        
        .header p {
            font-size: 14px;
            opacity: 0.9;
        }
        
        .content {
            padding: 30px;
        }
        
        /* Alert Messages */
        .alert {
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 500;
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }
        
        /* Navigation */
        .nav-section {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }
        
        .nav-btn {
            padding: 12px 25px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
        }
        
        .nav-btn-primary {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
        }
        
        .nav-btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(79, 172, 254, 0.4);
        }
        
        .nav-btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .nav-btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
        
        /* Requests Section */
        .requests-section {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 25px;
        }
        
        .section-title {
            font-size: 22px;
            color: #333;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .request-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 20px;
            border: 2px solid #e0e0e0;
            transition: all 0.3s;
        }
        
        .request-card:hover {
            border-color: #667eea;
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.15);
            transform: translateY(-3px);
        }
        
        .request-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 15px;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .request-info {
            flex: 1;
        }
        
        .request-id {
            font-size: 18px;
            font-weight: 700;
            color: #667eea;
            margin-bottom: 8px;
        }
        
        .request-meta {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            margin-bottom: 10px;
        }
        
        .meta-item {
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 14px;
            color: #666;
        }
        
        .status-badge {
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            display: inline-block;
        }
        
        .status-pending {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-approved {
            background: #d4edda;
            color: #155724;
        }
        
        .status-rejected {
            background: #f8d7da;
            color: #721c24;
        }
        
        .request-notes {
            background: #f8f9fa;
            padding: 12px 15px;
            border-radius: 8px;
            margin-top: 12px;
            font-size: 14px;
            color: #555;
            border-left: 3px solid #667eea;
        }
        
        .request-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .action-btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        
        .btn-update {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
        }
        
        .btn-update:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(79, 172, 254, 0.4);
        }
        
        .btn-cancel {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
        }
        
        .btn-cancel:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(245, 87, 108, 0.4);
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        
        .empty-state-icon {
            font-size: 80px;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        
        .empty-state h3 {
            font-size: 22px;
            color: #666;
            margin-bottom: 10px;
        }
        
        .empty-state p {
            font-size: 14px;
            color: #999;
        }
        
        @media (max-width: 768px) {
            .content {
                padding: 20px;
            }
            
            .request-header {
                flex-direction: column;
            }
            
            .request-actions {
                width: 100%;
            }
            
            .action-btn {
                flex: 1;
            }
            
            .nav-section {
                flex-direction: column;
            }
            
            .nav-btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📋 Manage Medication Requests</h1>
            <p>View and manage your pending medication requests</p>
        </div>
        
        <div class="content">
            <!-- Alert Messages -->
            <c:if test="${not empty param.message}">
                <c:choose>
                    <c:when test="${param.message == 'cancel_success'}">
                        <div class="alert alert-success">
                            ✅ Request cancelled successfully!
                        </div>
                    </c:when>
                    <c:when test="${param.message == 'error_cancel'}">
                        <div class="alert alert-error">
                            ⚠️ Failed to cancel request. Please try again!
                        </div>
                    </c:when>
                    <c:when test="${param.message == 'update_success'}">
                        <div class="alert alert-success">
                            ✅ Request updated successfully!
                        </div>
                    </c:when>
                </c:choose>
            </c:if>
            
            <!-- Navigation -->
            <div class="nav-section">
                <a href="view-request-history" class="nav-btn nav-btn-primary">
                    📜 View Request History
                </a>
                <a href="create-request" class="nav-btn nav-btn-primary">
                    ➕ Create New Request
                </a>
                <a href="doctor-dashboard" class="nav-btn nav-btn-secondary">
                    🏠 Back to Dashboard
                </a>
            </div>
            
            <!-- Pending Requests Section -->
            <div class="requests-section">
                <h2 class="section-title">⏳ Pending Requests</h2>
                
                <c:choose>
                    <c:when test="${not empty requests}">
                        <c:forEach var="req" items="${requests}">
                            <div class="request-card">
                                <div class="request-header">
                                    <div class="request-info">
                                        <div class="request-id">Request #${req.requestId}</div>
                                        <div class="request-meta">
                                            <div class="meta-item">
                                                📅 <strong>Date:</strong> 
                                                <fmt:formatDate value="${req.requestDate}" pattern="dd/MM/yyyy"/>
                                            </div>
                                            <div class="meta-item">
                                                <span class="status-badge status-pending">${req.status}</span>
                                            </div>
                                        </div>
                                        <c:if test="${not empty req.notes}">
                                            <div class="request-notes">
                                                <strong>📝 Notes:</strong> ${req.notes}
                                            </div>
                                        </c:if>
                                    </div>
                                    <div class="request-actions">
                                        <a href="update-request?requestId=${req.requestId}" class="action-btn btn-update">
                                            ✏️ Update
                                        </a>
                                        <a href="cancel-request?requestId=${req.requestId}" 
                                           class="action-btn btn-cancel"
                                           onclick="return confirm('Are you sure you want to cancel this request?')">
                                            ❌ Cancel
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <div class="empty-state-icon">📭</div>
                            <h3>No Pending Requests</h3>
                            <p>You don't have any pending medication requests at the moment.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</body>
</html>