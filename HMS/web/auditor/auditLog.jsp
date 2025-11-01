<!-- ========================================
     1. auditLog.jsp - Main Audit Log Page
     ======================================== -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Audit Logs - System Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: #f9fafb;
            color: #374151;
        }

        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar - Same as dashboard */
        .sidebar {
            width: 280px;
            background: white;
            color: #1f2937;
            padding: 30px 20px;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.08);
            overflow-y: auto;
            border-right: 1px solid #e5e7eb;
        }

        .sidebar-header h4 {
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
            color: #1f2937;
        }

        .sidebar-header hr {
            border: none;
            border-top: 1px solid #e5e7eb;
            margin: 15px 0;
        }

        .nav-link {
            color: #6b7280;
            text-decoration: none;
            padding: 12px 16px;
            border-radius: 10px;
            margin: 6px 0;
            display: flex;
            align-items: center;
            gap: 12px;
            transition: all 0.3s ease;
            font-size: 14px;
            font-weight: 500;
        }

        .nav-link:hover,
        .nav-link.active {
            background: #f3f4f6;
            color: #3b82f6;
            transform: translateX(4px);
        }

        .nav-divider {
            border: none;
            border-top: 1px solid #e5e7eb;
            margin: 15px 0;
        }

        /* Main content */
        .main-content {
            flex: 1;
            padding: 40px;
            overflow-y: auto;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .page-header h2 {
            font-size: 32px;
            font-weight: 700;
            color: #1f2937;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .header-actions {
            display: flex;
            gap: 12px;
        }

        .btn {
            padding: 10px 20px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: #3b82f6;
            color: white;
        }

        .btn-primary:hover {
            background: #2563eb;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }

        .btn-info {
            background: #0ea5e9;
            color: white;
        }

        .btn-warning {
            background: #f59e0b;
            color: white;
        }

        .btn-success {
            background: #10b981;
            color: white;
        }

        .btn-secondary {
            background: #6b7280;
            color: white;
        }

        /* Alert messages */
        .alert {
            padding: 16px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .alert-success {
            background: #d1fae5;
            color: #065f46;
            border-left: 4px solid #10b981;
        }

        .alert-danger {
            background: #fee2e2;
            color: #991b1b;
            border-left: 4px solid #ef4444;
        }

        /* Stats cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            border-left: 5px solid #3b82f6;
        }

        .stat-card h6 {
            font-size: 13px;
            font-weight: 600;
            color: #9ca3af;
            margin-bottom: 8px;
            text-transform: uppercase;
        }

        .stat-card h3 {
            font-size: 24px;
            font-weight: 700;
            color: #1f2937;
        }

        /* Filter card */
        .filter-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            padding: 24px;
            margin-bottom: 30px;
        }

        .filter-card h5 {
            font-size: 18px;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 16px;
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #6b7280;
            margin-bottom: 6px;
        }

        .form-control {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        /* Table */
        .table-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            overflow: hidden;
        }

        .table-responsive {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background: #f9fafb;
        }

        th {
            padding: 16px;
            text-align: left;
            font-size: 13px;
            font-weight: 700;
            color: #6b7280;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 2px solid #e5e7eb;
        }

        td {
            padding: 16px;
            border-bottom: 1px solid #e5e7eb;
            font-size: 14px;
            color: #374151;
        }

        tr:hover {
            background: #f9fafb;
        }

        /* Badges */
        .badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .badge-primary {
            background: #dbeafe;
            color: #1e40af;
        }

        .badge-success {
            background: #d1fae5;
            color: #065f46;
        }

        .badge-warning {
            background: #fef3c7;
            color: #92400e;
        }

        .badge-danger {
            background: #fee2e2;
            color: #991b1b;
        }

        .badge-info {
            background: #e0f2fe;
            color: #075985;
        }

        /* Risk badges */
        .risk-high {
            background: #fee2e2;
            color: #991b1b;
        }

        .risk-medium {
            background: #fef3c7;
            color: #92400e;
        }

        .risk-low {
            background: #d1fae5;
            color: #065f46;
        }

        /* Category badges */
        .category-security {
            background: #f3e8ff;
            color: #6b21a8;
        }

        .category-inventory {
            background: #e0f2fe;
            color: #075985;
        }

        .category-procurement {
            background: #fed7aa;
            color: #9a3412;
        }

        .category-other {
            background: #e5e7eb;
            color: #374151;
        }

        /* Pagination */
        .pagination {
            display: flex;
            justify-content: center;
            gap: 8px;
            padding: 24px;
            list-style: none;
        }

        .page-item a {
            padding: 8px 16px;
            border-radius: 8px;
            text-decoration: none;
            color: #374151;
            background: white;
            border: 1px solid #e5e7eb;
            transition: all 0.3s ease;
        }

        .page-item a:hover {
            background: #f3f4f6;
            border-color: #3b82f6;
            color: #3b82f6;
        }

        .page-item.active a {
            background: #3b82f6;
            color: white;
            border-color: #3b82f6;
        }

        .page-item.disabled a {
            opacity: 0.5;
            cursor: not-allowed;
        }

        /* Modal */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }

        .modal.show {
            display: flex;
        }

        .modal-dialog {
            background: white;
            border-radius: 15px;
            max-width: 500px;
            width: 90%;
            max-height: 90vh;
            overflow-y: auto;
        }

        .modal-header {
            padding: 24px;
            border-bottom: 1px solid #e5e7eb;
        }

        .modal-header h5 {
            font-size: 18px;
            font-weight: 700;
            color: #1f2937;
        }

        .modal-body {
            padding: 24px;
        }

        .modal-footer {
            padding: 16px 24px;
            border-top: 1px solid #e5e7eb;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }

        /* Empty state */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }

        .empty-state i {
            font-size: 64px;
            color: #d1d5db;
            margin-bottom: 20px;
        }

        .empty-state h4 {
            font-size: 20px;
            font-weight: 600;
            color: #6b7280;
            margin-bottom: 10px;
        }

        .empty-state p {
            color: #9ca3af;
        }

        @media (max-width: 768px) {
            .dashboard-container {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
            }

            .main-content {
                padding: 20px;
            }

            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 16px;
            }

            .stats-grid,
            .form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <%@ include file="/admin/header.jsp" %>
    
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <h4><i class="bi bi-hospital"></i> Auditor</h4>
                <hr class="sidebar-divider">
            </div>

            <nav>
                <a class="nav-link" href="${pageContext.request.contextPath}/auditor-dashboard">
                    <i class="bi bi-speedometer2"></i> Dashboard
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/purchase-orders">
                    <i class="bi bi-receipt"></i> Purchase Orders
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/purchase-orders/history">
                    <i class="bi bi-clock-history"></i> PO History & Trends
                </a>
                
                <hr class="nav-divider">
                
                <a class="nav-link active" href="${pageContext.request.contextPath}/auditlog?action=view">
                    <i class="bi bi-clipboard-data"></i> Audit Logs
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/auditlog?action=statistics">
                    <i class="bi bi-graph-up"></i> Statistics
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/auditlog?action=alerts">
                    <i class="bi bi-exclamation-triangle"></i> Security Alerts
                </a>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="page-header">
                <h2><i class="bi bi-clipboard-data"></i> Audit Logs</h2>
                <div class="header-actions">
                    <a href="auditlog?action=statistics" class="btn btn-info">
                        <i class="bi bi-graph-up"></i> Statistics
                    </a>
                    <a href="auditlog?action=alerts" class="btn btn-warning">
                        <i class="bi bi-exclamation-triangle"></i> Alerts
                    </a>
                </div>
            </div>
            
            <!-- Alert Messages -->
            <c:if test="${not empty message}">
                <div class="alert alert-${messageType}">
                    <i class="bi bi-check-circle"></i>
                    ${message}
                </div>
            </c:if>
            
            <!-- Quick Stats -->
            <div class="stats-grid">
                <div class="stat-card">
                    <h6>Total Logs</h6>
                    <h3>${totalRecords}</h3>
                </div>
                <div class="stat-card">
                    <h6>Current Page</h6>
                    <h3>${currentPage} / ${totalPages}</h3>
                </div>
                <div class="stat-card">
                    <h6>Page Size</h6>
                    <h3>${pageSize}</h3>
                </div>
                <div class="stat-card">
                    <h6>Active Filters</h6>
                    <h3>
                        ${(not empty startDate ? 1 : 0) + 
                          (not empty username ? 1 : 0) + 
                          (not empty role ? 1 : 0) + 
                          (not empty actionFilter ? 1 : 0)}
                    </h3>
                </div>
            </div>
            
            <!-- Filters -->
            <div class="filter-card">
                <h5><i class="bi bi-funnel"></i> Filters</h5>
                <form action="auditlog" method="get">
                    <input type="hidden" name="action" value="view">
                    <div class="form-grid">
                        <div class="form-group">
                            <label>Start Date</label>
                            <input type="date" class="form-control" name="startDate" value="${startDate}">
                        </div>
                        <div class="form-group">
                            <label>End Date</label>
                            <input type="date" class="form-control" name="endDate" value="${endDate}">
                        </div>
                        <div class="form-group">
                            <label>Username</label>
                            <input type="text" class="form-control" name="username" 
                                   placeholder="Search username..." value="${username}">
                        </div>
                        <div class="form-group">
                            <label>Role</label>
                            <select class="form-control" name="role">
                                <option value="">All Roles</option>
                                <c:forEach items="${roles}" var="r">
                                    <option value="${r}" ${role eq r ? 'selected' : ''}>${r}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Action</label>
                            <select class="form-control" name="actionFilter">
                                <option value="">All Actions</option>
                                <c:forEach items="${actions}" var="act">
                                    <option value="${act}" ${actionFilter eq act ? 'selected' : ''}>${act}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Table Name</label>
                            <select class="form-control" name="tableName">
                                <option value="">All Tables</option>
                                <c:forEach items="${tables}" var="tbl">
                                    <option value="${tbl}" ${tableName eq tbl ? 'selected' : ''}>${tbl}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Risk Level</label>
                            <select class="form-control" name="riskLevel">
                                <option value="">All Levels</option>
                                <option value="high" ${riskLevel eq 'high' ? 'selected' : ''}>High</option>
                                <option value="medium" ${riskLevel eq 'medium' ? 'selected' : ''}>Medium</option>
                                <option value="low" ${riskLevel eq 'low' ? 'selected' : ''}>Low</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Category</label>
                            <select class="form-control" name="category">
                                <option value="">All Categories</option>
                                <option value="Security" ${category eq 'Security' ? 'selected' : ''}>Security</option>
                                <option value="Inventory" ${category eq 'Inventory' ? 'selected' : ''}>Inventory</option>
                                <option value="Procurement" ${category eq 'Procurement' ? 'selected' : ''}>Procurement</option>
                                <option value="Other" ${category eq 'Other' ? 'selected' : ''}>Other</option>
                            </select>
                        </div>
                    </div>
                    <div style="display: flex; gap: 12px;">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-search"></i> Apply Filters
                        </button>
                        <a href="auditlog?action=view" class="btn btn-secondary">
                            <i class="bi bi-arrow-clockwise"></i> Reset
                        </a>
                    </div>
                </form>
            </div>
            
            <!-- Audit Logs Table -->
            <div class="table-card">
                <div class="table-responsive">

                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Date/Time</th>
                                <th>User</th>
                                <th>Role</th>
                                <th>Action</th>
                                <th>Table</th>
                                <th>Details</th>
                                <th>IP Address</th>
                                <th>Risk</th>
                                <th>Category</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${logs}" var="log">
                                <tr>
                                    <td>${log.logId}</td>
                                    <td>
                                        <fmt:formatDate value="${log.logDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                    </td>
                                    <td>
                                        <strong>${log.username}</strong><br>
                                        <small style="color: #9ca3af;">${log.email}</small>
                                    </td>
                                    <td><span class="badge badge-primary">${log.role}</span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${log.action eq 'LOGIN'}">
                                                <i class="bi bi-box-arrow-in-right" style="color: #10b981;"></i>
                                            </c:when>
                                            <c:when test="${log.action eq 'LOGOUT'}">
                                                <i class="bi bi-box-arrow-right" style="color: #6b7280;"></i>
                                            </c:when>
                                            <c:when test="${log.action eq 'CREATE'}">
                                                <i class="bi bi-plus-circle" style="color: #3b82f6;"></i>
                                            </c:when>
                                            <c:when test="${log.action eq 'UPDATE'}">
                                                <i class="bi bi-pencil" style="color: #f59e0b;"></i>
                                            </c:when>
                                            <c:when test="${log.action eq 'DELETE'}">
                                                <i class="bi bi-trash" style="color: #ef4444;"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="bi bi-circle-fill" style="color: #3b82f6;"></i>
                                            </c:otherwise>
                                        </c:choose>
                                        ${log.action}
                                    </td>
                                    <td><code style="background: #f3f4f6; padding: 2px 6px; border-radius: 4px; font-size: 12px;">${log.tableName != null ? log.tableName : '-'}</code></td>
                                    <td style="max-width: 300px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" title="${log.details}">
                                        ${log.details}
                                    </td>
                                    <td><small>${log.ipAddress}</small></td>
                                    <td><span class="badge risk-${log.riskLevel}">${log.riskLevel}</span></td>
                                    <td><span class="badge category-${log.category.toLowerCase()}">${log.category}</span></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty logs}">
                                <tr>
                                    <td colspan="10">
                                        <div class="empty-state">
                                            <i class="bi bi-inbox"></i>
                                            <h4>No audit logs found</h4>
                                            <p>Try adjusting your filters</p>
                                        </div>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                    
                    
                </div>
                
                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <ul class="pagination">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a href="?action=view&page=${currentPage - 1}&pageSize=${pageSize}&startDate=${startDate}&endDate=${endDate}&username=${username}&role=${role}&actionFilter=${actionFilter}&tableName=${tableName}&riskLevel=${riskLevel}&category=${category}">
                                Previous
                            </a>
                        </li>
                        
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <c:if test="${i >= currentPage - 2 && i <= currentPage + 2}">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a href="?action=view&page=${i}&pageSize=${pageSize}&startDate=${startDate}&endDate=${endDate}&username=${username}&role=${role}&actionFilter=${actionFilter}&tableName=${tableName}&riskLevel=${riskLevel}&category=${category}">
                                        ${i}
                                    </a>
                                </li>
                            </c:if>
                        </c:forEach>
                        
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a href="?action=view&page=${currentPage + 1}&pageSize=${pageSize}&startDate=${startDate}&endDate=${endDate}&username=${username}&role=${role}&actionFilter=${actionFilter}&tableName=${tableName}&riskLevel=${riskLevel}&category=${category}">
                                Next
                            </a>
                        </li>
                    </ul>
                </c:if>
            </div>
        </div>
    </div>
    
   
    
    <script>
        function openModal(id) {
            document.getElementById(id).classList.add('show');
        }
        
        function closeModal(id) {
            document.getElementById(id).classList.remove('show');
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            if (event.target.classList.contains('modal')) {
                event.target.classList.remove('show');
            }
        }
    </script>
    
    <%@ include file="/admin/footer.jsp" %>
</body>
</html>