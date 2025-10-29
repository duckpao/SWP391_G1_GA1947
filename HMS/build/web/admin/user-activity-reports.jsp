<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo cáo hoạt động người dùng - Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: #f9fafb;
            min-height: 100vh;
            display: flex;
        }

        /* Added sidebar styling from admin-dashboard */
        .sidebar {
            width: 260px;
            background: #ffffff;
            border-right: 1px solid #e5e7eb;
            padding: 30px 0;
            min-height: 100vh;
            box-shadow: 2px 0 4px rgba(0, 0, 0, 0.05);
            position: fixed;
            left: 0;
            top: 0;
            overflow-y: auto;
        }

        .sidebar-brand {
            padding: 0 20px 30px;
            border-bottom: 1px solid #e5e7eb;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 18px;
            font-weight: 700;
            color: #1f2937;
        }

        .sidebar-menu {
            display: flex;
            flex-direction: column;
            gap: 8px;
            padding: 0 12px;
        }

        .sidebar-item {
            padding: 12px 16px;
            border-radius: 8px;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
            font-weight: 500;
            color: #374151;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            background: none;
            width: 100%;
            text-align: left;
        }

        .sidebar-item:hover {
            background: #f3f4f6;
            color: #1f2937;
        }

        .sidebar-item-primary {
            background: #eff6ff;
            color: #3b82f6;
            font-weight: 600;
        }

        .sidebar-item-primary:hover {
            background: #dbeafe;
        }

        .sidebar-item-logout {
            background: #fee2e2;
            color: #dc2626;
            font-weight: 600;
            margin-top: 20px;
            border-top: 1px solid #e5e7eb;
            padding-top: 20px;
        }

        .sidebar-item-logout:hover {
            background: #fecaca;
        }

        /* Added main-content wrapper for sidebar layout */
        .main-content {
            margin-left: 260px;
            flex: 1;
            padding: 20px;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.07);
            overflow: hidden;
        }

        .header {
            background: #ffffff;
            color: #1f2937;
            padding: 30px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 3px solid #3b82f6;
        }

        .header h1 {
            font-size: 28px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .header-icon {
            width: 40px;
            height: 40px;
            background: #eff6ff;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
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

        .btn-secondary {
            background: #e5e7eb;
            color: #374151;
            padding: 10px 20px;
        }

        .btn-secondary:hover {
            background: #d1d5db;
        }

        .content {
            padding: 40px;
        }

        .alert {
            padding: 16px;
            margin-bottom: 20px;
            border-radius: 8px;
            font-size: 14px;
        }

        .alert-error {
            background: #fee2e2;
            border: 1px solid #fca5a5;
            color: #991b1b;
        }

        .alert-success {
            background: #d1fae5;
            border: 1px solid #6ee7b7;
            color: #065f46;
        }

        .filter-section {
            background: #f9fafb;
            padding: 24px;
            border-radius: 12px;
            margin-bottom: 24px;
            border: 1px solid #e5e7eb;
        }

        .filter-section h2 {
            font-size: 18px;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .filter-form {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 16px;
            margin-bottom: 16px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .form-group label {
            font-size: 13px;
            font-weight: 600;
            color: #374151;
        }

        .form-control, select {
            padding: 10px 14px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.2s;
            background: white;
        }

        .form-control:focus, select:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .button-group {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 16px;
        }

        .stats-summary {
            background: #f0f9ff;
            color: #1e40af;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            display: flex;
            gap: 30px;
            flex-wrap: wrap;
            border: 1px solid #bae6fd;
        }

        .stats-summary p {
            font-size: 14px;
        }

        .stats-summary strong {
            font-size: 24px;
            display: block;
            margin-top: 4px;
            color: #1e40af;
        }

        .report-section {
            margin-top: 30px;
        }

        .report-header {
            background: #f9fafb;
            padding: 16px 20px;
            border-radius: 8px 8px 0 0;
            border: 1px solid #e5e7eb;
            border-bottom: none;
        }

        .report-header h3 {
            font-size: 18px;
            font-weight: 600;
            color: #1f2937;
        }

        .table-container {
            overflow-x: auto;
            border-radius: 0 0 12px 12px;
            border: 1px solid #e5e7eb;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }

        thead {
            background: #f9fafb;
            border-bottom: 2px solid #e5e7eb;
        }

        th {
            padding: 16px;
            text-align: left;
            font-weight: 600;
            font-size: 13px;
            color: #374151;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            white-space: nowrap;
        }

        td {
            padding: 16px;
            border-bottom: 1px solid #f3f4f6;
            font-size: 14px;
            color: #1f2937;
        }

        tbody tr {
            transition: background-color 0.2s ease;
        }

        tbody tr:hover {
            background: #f9fafb;
        }

        .badge {
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 500;
            display: inline-block;
        }

        .badge-Admin {
            background: #dbeafe;
            color: #1e40af;
        }
        .badge-Doctor {
            background: #fef3c7;
            color: #92400e;
        }
        .badge-Pharmacist {
            background: #d1fae5;
            color: #065f46;
        }
        .badge-Manager {
            background: #e0e7ff;
            color: #3730a3;
        }
        .badge-Auditor {
            background: #fce7f3;
            color: #9f1239;
        }
        .badge-ProcurementOfficer {
            background: #f3e8ff;
            color: #6b21a8;
        }
        .badge-Supplier {
            background: #dbeafe;
            color: #075985;
        }

        .no-data {
            text-align: center;
            padding: 60px 20px;
            color: #6b7280;
            background: white;
            border-radius: 0 0 12px 12px;
        }

        .no-data-icon {
            font-size: 64px;
            margin-bottom: 16px;
            opacity: 0.5;
        }

        .result-count {
            padding: 12px 16px;
            background: #f0f9ff;
            border: 1px solid #bae6fd;
            border-radius: 8px;
            color: #075985;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 16px;
        }

        /* Added responsive design for sidebar */
        @media (max-width: 768px) {
            body {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                min-height: auto;
                position: relative;
                border-right: none;
                border-bottom: 1px solid #e5e7eb;
                padding: 15px 0;
            }

            .sidebar-brand {
                padding: 0 15px 15px;
                margin-bottom: 10px;
            }

            .sidebar-menu {
                padding: 0 8px;
                flex-direction: row;
                flex-wrap: wrap;
                gap: 6px;
            }

            .sidebar-item {
                padding: 8px 12px;
                font-size: 12px;
            }

            .main-content {
                margin-left: 0;
                padding: 15px;
            }

            .container {
                border-radius: 8px;
            }

            .header {
                padding: 20px;
            }

            .header h1 {
                font-size: 20px;
            }
        }
    </style>
</head>
<body>
    <!-- Added sidebar navigation from admin-dashboard -->
    <div class="sidebar">
        <div class="sidebar-brand">
            <span>🏥</span>
            Hệ thống
        </div>
        <div class="sidebar-menu">
            <a class="sidebar-item sidebar-item-primary" href="${pageContext.request.contextPath}/admin-dashboard">
                ← Quay lại Dashboard
            </a>
            <a class="sidebar-item sidebar-item-primary" href="${pageContext.request.contextPath}/user-reports/generate">
                📊 Báo cáo
            </a>
            <a class="sidebar-item sidebar-item-primary" href="${pageContext.request.contextPath}/admin-dashboard/config">
                ⚙️ Cấu hình
            </a>
            <a class="sidebar-item sidebar-item-primary" href="${pageContext.request.contextPath}/admin/permissions">
                🔐 Phân quyền
            </a>
            <a class="sidebar-item sidebar-item-primary" href="${pageContext.request.contextPath}/admin-dashboard/create">
                ➕ Tạo tài khoản
            </a>
            <a class="sidebar-item sidebar-item-logout" href="${pageContext.request.contextPath}/logout">
                🚪 Logout
            </a>
        </div>
    </div>

    <!-- Wrapped main content in main-content div for sidebar layout -->
    <div class="main-content">
        <div class="container">
            <div class="header">
                <div>
                    <h1>
                        <span class="header-icon">📊</span>
                        Báo cáo hoạt động người dùng
                    </h1>
                </div>
            </div>

            <div class="content">
                <c:if test="${not empty error}">
                    <div class="alert alert-error">
                        <strong>⚠️ Lỗi:</strong> ${error}
                    </div>
                </c:if>
                
                <c:if test="${not empty success}">
                    <div class="alert alert-success">
                        <strong>✅ Thành công:</strong> ${success}
                    </div>
                </c:if>
                
                <!-- Filter Section -->
                <div class="filter-section">
                    <h2>🔍 Bộ lọc báo cáo</h2>
                    
                    <form action="${pageContext.request.contextPath}/user-reports/generate" method="GET">
                        <div class="filter-form">
                            <div class="form-group">
                                <label for="reportType">Loại báo cáo:</label>
                                <select name="type" id="reportType" required onchange="toggleFilters()">
                                    <option value="">-- Chọn loại báo cáo --</option>
                                    <option value="summary" ${reportType == 'summary' ? 'selected' : ''}>Báo cáo tổng hợp</option>
                                    <option value="detailed" ${reportType == 'detailed' ? 'selected' : ''}>Nhật ký chi tiết</option>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label for="startDate">Từ ngày:</label>
                                <input type="date" name="startDate" id="startDate" class="form-control"
                                       value="${not empty startDate ? startDate : defaultStartDate}" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="endDate">Đến ngày:</label>
                                <input type="date" name="endDate" id="endDate" class="form-control"
                                       value="${not empty endDate ? endDate : defaultEndDate}" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="role">Lọc theo vai trò:</label>
                                <select name="role" id="role">
                                    <option value="">Tất cả vai trò</option>
                                    <c:forEach var="r" items="${roles}">
                                        <option value="${r}" ${selectedRole == r ? 'selected' : ''}>${r}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            
                            <div class="form-group" id="usernameFilter" style="display: none;">
                                <label for="username">Tên đăng nhập:</label>
                                <input type="text" name="username" id="username" class="form-control"
                                       placeholder="Tìm theo username" value="${username}">
                            </div>
                            
                            <div class="form-group" id="actionFilterGroup" style="display: none;">
                                <label for="actionFilterSelect">Loại hành động:</label>
                                <select name="actionFilter" id="actionFilterSelect">
                                    <option value="">Tất cả hành động</option>
                                    <option value="LOGIN" ${selectedAction == 'LOGIN' ? 'selected' : ''}>LOGIN</option>
                                    <option value="LOGOUT" ${selectedAction == 'LOGOUT' ? 'selected' : ''}>LOGOUT</option>
                                    <option value="CREATE_USER" ${selectedAction == 'CREATE_USER' ? 'selected' : ''}>CREATE_USER</option>
                                    <option value="UPDATE_USER" ${selectedAction == 'UPDATE_USER' ? 'selected' : ''}>UPDATE_USER</option>
                                    <option value="DELETE_USER" ${selectedAction == 'DELETE_USER' ? 'selected' : ''}>DELETE_USER</option>
                                    <option value="VIEW_DASHBOARD" ${selectedAction == 'VIEW_DASHBOARD' ? 'selected' : ''}>VIEW_DASHBOARD</option>
                                    <option value="GENERATE_REPORT" ${selectedAction == 'GENERATE_REPORT' ? 'selected' : ''}>GENERATE_REPORT</option>
                                    <option value="EXPORT_REPORT" ${selectedAction == 'EXPORT_REPORT' ? 'selected' : ''}>EXPORT_REPORT</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="button-group">
                            <button type="reset" class="btn btn-secondary">🔄 Xóa bộ lọc</button>
                            <button type="submit" class="btn btn-primary">🔍 Tạo báo cáo</button>
                        </div>
                    </form>
                </div>
                
                <!-- Report Results -->
                <c:if test="${not empty reportType}">
                    <div class="report-section">
                        <c:if test="${reportType == 'summary'}">
                            <div class="report-header">
                                <h3>📈 Báo cáo tổng hợp hoạt động người dùng</h3>
                            </div>
                            
                            <c:choose>
                                <c:when test="${not empty summaryReports}">
                                    <div class="stats-summary">
                                        <p>Tổng người dùng <strong>${totalUsers}</strong></p>
                                        <p>Tổng hành động <strong>${totalActions}</strong></p>
                                        <p>Tổng đăng nhập <strong>${totalLogins}</strong></p>
                                    </div>
                                    
                                    <div class="table-container">
                                        <table>
                                            <thead>
                                                <tr>
                                                    <th>User ID</th>
                                                    <th>Username</th>
                                                    <th>Email</th>
                                                    <th>Vai trò</th>
                                                    <th>Tổng hành động</th>
                                                    <th>Ngày hoạt động</th>
                                                    <th>Số lần đăng nhập</th>
                                                    <th>TB hành động/ngày</th>
                                                    <th>Hành động phổ biến</th>
                                                    <th>Hoạt động đầu</th>
                                                    <th>Hoạt động cuối</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="report" items="${summaryReports}">
                                                    <tr>
                                                        <td><strong>#${report.userId}</strong></td>
                                                        <td>${report.username}</td>
                                                        <td>${report.email}</td>
                                                        <td><span class="badge badge-${report.role}">${report.role}</span></td>
                                                        <td>${report.totalActions}</td>
                                                        <td>${report.activeDays}</td>
                                                        <td>${report.loginCount}</td>
                                                        <td><fmt:formatNumber value="${report.averageActionsPerDay}" pattern="#0.00"/></td>
                                                        <td>${report.mostCommonAction}</td>
                                                        <td><fmt:formatDate value="${report.firstActivity}" pattern="dd/MM/yyyy HH:mm"/></td>
                                                        <td><fmt:formatDate value="${report.lastActivity}" pattern="dd/MM/yyyy HH:mm"/></td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-data">
                                        <div class="no-data-icon">📭</div>
                                        <h3>Không tìm thấy dữ liệu</h3>
                                        <p>Không có dữ liệu cho các bộ lọc đã chọn</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                        
                        <c:if test="${reportType == 'detailed'}">
                            <div class="report-header">
                                <h3>📋 Nhật ký hoạt động chi tiết</h3>
                            </div>
                            
                            <c:choose>
                                <c:when test="${not empty detailedLogs}">
                                    <div class="result-count">
                                        📊 Tìm thấy <strong>${detailedLogs.size()}</strong> nhật ký
                                    </div>
                                    
                                    <div class="table-container">
                                        <table>
                                            <thead>
                                                <tr>
                                                    <th>Log ID</th>
                                                    <th>User ID</th>
                                                    <th>Username</th>
                                                    <th>Vai trò</th>
                                                    <th>Hành động</th>
                                                    <th>Chi tiết</th>
                                                    <th>IP Address</th>
                                                    <th>Thời gian</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="log" items="${detailedLogs}">
                                                    <tr>
                                                        <td><strong>#${log.logId}</strong></td>
                                                        <td>${log.userId}</td>
                                                        <td>${log.username}</td>
                                                        <td><span class="badge badge-${log.role}">${log.role}</span></td>
                                                        <td><strong>${log.action}</strong></td>
                                                        <td>${log.details}</td>
                                                        <td>${log.ipAddress}</td>
                                                        <td><fmt:formatDate value="${log.logDate}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-data">
                                        <div class="no-data-icon">📭</div>
                                        <h3>Không tìm thấy nhật ký</h3>
                                        <p>Không có nhật ký nào cho các bộ lọc đã chọn</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    
    <script>
        function toggleFilters() {
            const reportType = document.getElementById('reportType').value;
            const usernameFilter = document.getElementById('usernameFilter');
            const actionFilter = document.getElementById('actionFilterGroup');
            
            if (reportType === 'detailed') {
                usernameFilter.style.display = 'block';
                actionFilter.style.display = 'block';
            } else {
                usernameFilter.style.display = 'none';
                actionFilter.style.display = 'none';
            }
        }
        
        window.onload = function() {
            toggleFilters();
        };
    </script>
</body>
</html>
