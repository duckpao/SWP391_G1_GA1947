<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Request History</title>
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
            max-width: 1400px;
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
        }
        
        .content {
            padding: 30px;
        }
        
        /* Search Form */
        .search-container {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 30px;
            border: 2px solid #e0e0e0;
        }
        
        .search-title {
            font-size: 20px;
            color: #333;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .search-form {
            display: grid;
            grid-template-columns: 1fr 1fr auto auto;
            gap: 15px;
            align-items: end;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
        }
        
        .form-group label {
            font-weight: 600;
            margin-bottom: 8px;
            color: #555;
            font-size: 14px;
        }
        
        .form-group input {
            padding: 12px 15px;
            border: 2px solid #ddd;
            border-radius: 10px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        
        .btn-search {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-search:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
        }
        
        .btn-reset {
            background: #6c757d;
            color: white;
        }
        
        .btn-reset:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
        
        /* Results Info */
        .results-info {
            background: #e7f3ff;
            border-left: 4px solid #2196F3;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            color: #0d47a1;
            font-weight: 500;
        }
        
        /* Navigation */
        .nav-links {
            margin-bottom: 25px;
        }
        
        .nav-btn {
            padding: 12px 25px;
            background: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 10px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
            font-size: 14px;
        }
        
        .nav-btn:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
        
        /* Request Cards */
        .request-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            border: 2px solid #e0e0e0;
            transition: all 0.3s;
        }
        
        .request-card:hover {
            border-color: #667eea;
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.15);
        }
        
        .request-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 15px;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .request-id {
            font-size: 20px;
            font-weight: 700;
            color: #667eea;
            margin-bottom: 10px;
        }
        
        .request-meta {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            font-size: 14px;
            color: #666;
        }
        
        .meta-item {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .status-badge {
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
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
        
        .status-cancelled {
            background: #e2e3e5;
            color: #383d41;
        }
        
        .request-notes {
            background: #f8f9fa;
            padding: 12px 15px;
            border-radius: 8px;
            margin: 15px 0;
            font-size: 14px;
            color: #555;
            border-left: 3px solid #667eea;
        }
        
        /* Medicine Items */
        .medicine-items {
            margin-top: 20px;
        }
        
        .items-title {
            font-size: 16px;
            font-weight: 600;
            color: #333;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .medicine-list {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
        }
        
        .medicine-item {
            background: white;
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-left: 3px solid #4facfe;
        }
        
        .medicine-item:last-child {
            margin-bottom: 0;
        }
        
        .medicine-name {
            font-weight: 600;
            color: #333;
            font-size: 14px;
        }
        
        .medicine-quantity {
            background: #667eea;
            color: white;
            padding: 5px 12px;
            border-radius: 15px;
            font-size: 13px;
            font-weight: 600;
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 80px 20px;
            color: #999;
        }
        
        .empty-state-icon {
            font-size: 80px;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        
        .empty-state h3 {
            font-size: 24px;
            color: #666;
            margin-bottom: 10px;
        }
        
        .empty-state p {
            font-size: 14px;
            color: #999;
        }
        
        @media (max-width: 1024px) {
            .search-form {
                grid-template-columns: 1fr 1fr;
            }
            
            .search-form .btn {
                grid-column: span 1;
            }
        }
        
        @media (max-width: 768px) {
            .search-form {
                grid-template-columns: 1fr;
            }
            
            .content {
                padding: 20px;
            }
            
            .request-meta {
                flex-direction: column;
                gap: 10px;
            }
            
            .medicine-item {
                flex-direction: column;
                align-items: start;
                gap: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📜 Request History</h1>
        </div>
        
        <div class="content">
            <!-- Search Form -->
            <div class="search-container">
                <h2 class="search-title">🔍 Search Requests</h2>
                <form action="view-request-history" method="get" class="search-form">
                    <div class="form-group">
                        <label for="medicineName">Medicine Name</label>
                        <input type="text" 
                               id="medicineName" 
                               name="medicineName" 
                               value="${param.medicineName}" 
                               placeholder="Enter medicine name...">
                    </div>
                    
                    <div class="form-group">
                        <label for="date">Request Date</label>
                        <input type="date" 
                               id="date" 
                               name="date" 
                               value="${param.date}">
                    </div>
                    
                    <button type="submit" class="btn btn-search">🔍 Search</button>
                    <a href="view-request-history" class="btn btn-reset">🔄 Reset</a>
                </form>
            </div>
            
            <!-- Results Info -->
            <c:if test="${not empty param.medicineName or not empty param.date}">
                <div class="results-info">
                    <strong>Search Results:</strong> Found ${requests.size()} request(s)
                    <c:if test="${not empty param.medicineName}"> for medicine "${param.medicineName}"</c:if>
                    <c:if test="${not empty param.date}"> on date ${param.date}</c:if>
                </div>
            </c:if>
            
            <!-- Navigation -->
            <div class="nav-links">
                <a href="manage-requests" class="nav-btn">🔙 Back to Manage Requests</a>
            </div>
            
            <!-- Request Cards -->
            <c:choose>
                <c:when test="${not empty requests}">
                    <c:forEach var="req" items="${requests}">
                        <div class="request-card">
                            <div class="request-header">
                                <div>
                                    <div class="request-id">Request #${req.requestId}</div>
                                    <div class="request-meta">
                                        <div class="meta-item">
                                            📅 <strong>Date:</strong> 
                                            <fmt:formatDate value="${req.requestDate}" pattern="dd/MM/yyyy"/>
                                        </div>
                                        <div class="meta-item">
                                            <c:choose>
                                                <c:when test="${req.status == 'Pending'}">
                                                    <span class="status-badge status-pending">${req.status}</span>
                                                </c:when>
                                                <c:when test="${req.status == 'Approved'}">
                                                    <span class="status-badge status-approved">${req.status}</span>
                                                </c:when>
                                                <c:when test="${req.status == 'Rejected'}">
                                                    <span class="status-badge status-rejected">${req.status}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge status-cancelled">${req.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <c:if test="${not empty req.notes}">
                                <div class="request-notes">
                                    <strong>📝 Notes:</strong> ${req.notes}
                                </div>
                            </c:if>
                            
                            <!-- Medicine Items -->
                            <c:set var="items" value="${requestItemsMap[req.requestId]}"/>
                            <c:if test="${not empty items}">
                                <div class="medicine-items">
                                    <div class="items-title">💊 Requested Medicines</div>
                                    <div class="medicine-list">
                                        <c:forEach var="item" items="${items}">
                                            <div class="medicine-item">
                                                <span class="medicine-name">${item.medicineName}</span>
                                                <span class="medicine-quantity">Qty: ${item.quantity}</span>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <div class="empty-state-icon">📭</div>
                        <h3>No Requests Found</h3>
                        <p>There are no requests matching your search criteria.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>