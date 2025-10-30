<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Báo cáo hoạt động người dùng - Pharmacy Warehouse Management System</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            html, body {
                height: 100%;
            }

            body {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
                background: #ffffff;
                display: flex;
                flex-direction: column;
                color: #2c3e50;
            }

            .main-wrapper {
                display: flex;
                flex: 1;
            }

            /* ---- Modal chuyển dashboard ---- */
            .modal {
                display: none;
                position: fixed;
                z-index: 9999;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.45);
                justify-content: center;
                align-items: center;
                animation: fadeIn 0.25s ease;
            }

            .modal.active {
                display: flex;
            }

            .modal-content {
                background: #fff;
                border-radius: 12px;
                padding: 24px;
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.25);
                animation: slideDown 0.25s ease;
            }

            .modal-header {
                font-size: 20px;
                font-weight: 700;
                margin-bottom: 16px;
                color: #2c3e50;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .modal-body p {
                font-size: 15px;
                color: #495057;
                margin-bottom: 12px;
            }

            .modal-actions {
                display: flex;
                justify-content: flex-end;
                gap: 10px;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }

            @keyframes slideDown {
                from {
                    transform: translateY(-15px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }

            /* Left sidebar styling */
            .sidebar {
                width: 260px;
                background: #f8f9fa;
                border-right: 1px solid #dee2e6;
                padding: 30px 0;
                min-height: calc(100vh - 73px);
                overflow-y: auto;
            }

            .sidebar-brand {
                padding: 0 20px 30px;
                border-bottom: 1px solid #dee2e6;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
                font-size: 18px;
                font-weight: 700;
                color: #2c3e50;
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
                color: #495057;
                transition: all 0.3s ease;
                border: none;
                cursor: pointer;
                background: none;
                width: 100%;
                text-align: left;
            }

            .sidebar-item:hover {
                background: #e9ecef;
                color: #2c3e50;
            }

            .sidebar-item-primary {
                background: #495057;
                color: white;
                font-weight: 600;
            }

            .sidebar-item-primary:hover {
                background: #343a40;
            }

            .sidebar-item-logout {
                background: #dc3545;
                color: white;
                font-weight: 600;
                margin-top: 20px;
                border-top: 1px solid #dee2e6;
                padding-top: 20px;
            }

            .sidebar-item-logout:hover {
                background: #c82333;
            }

            /* Đồng bộ font nút Chuyển Dashboard với các sidebar-item khác */
            .sidebar-item[type="button"] {
                font-family: inherit;
                font-weight: 500;
                font-size: 14px;
                color: #495057;
                border: none;
                background: none;
                width: 100%;
                text-align: left;
                padding: 12px 16px;
                border-radius: 8px;
                cursor: pointer;
                display: flex;
                align-items: center;
                gap: 10px;
                transition: all 0.3s ease;
            }

            .sidebar-item[type="button"]:hover {
                background: #e9ecef;
                color: #2c3e50;
            }

            /* Main content layout */
            .main-content {
                flex: 1;
                padding: 30px;
                overflow-y: auto;
                background: #ffffff;
            }

            .container {
                max-width: 1400px;
                margin: 0 auto;
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
                overflow: hidden;
                border: 1px solid #e9ecef;
            }

            .header {
                background: #ffffff;
                color: #2c3e50;
                padding: 30px 40px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                border-bottom: 2px solid #dee2e6;
            }

            .header h1 {
                font-size: 28px;
                font-weight: 700;
                display: flex;
                align-items: center;
                gap: 12px;
                color: #2c3e50;
            }

            .header-icon {
                width: 40px;
                height: 40px;
                background: #f8f9fa;
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 20px;
                border: 1px solid #dee2e6;
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
                background: #495057;
                color: white;
                border: 1px solid #343a40;
            }

            .btn-primary:hover {
                background: #343a40;
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(52, 58, 64, 0.2);
            }

            .btn-secondary {
                background: #e9ecef;
                color: #495057;
                padding: 10px 20px;
                border: 1px solid #dee2e6;
            }

            .btn-secondary:hover {
                background: #dee2e6;
            }

            .content {
                padding: 40px;
            }

            .alert {
                padding: 16px;
                margin-bottom: 20px;
                border-radius: 8px;
                font-size: 14px;
                border: 1px solid;
            }

            .alert-error {
                background: #f8d7da;
                border-color: #f5c6cb;
                color: #721c24;
            }

            .alert-success {
                background: #d4edda;
                border-color: #c3e6cb;
                color: #155724;
            }

            .filter-section {
                background: #f8f9fa;
                padding: 24px;
                border-radius: 12px;
                margin-bottom: 24px;
                border: 1px solid #dee2e6;
            }

            .filter-section h2 {
                font-size: 18px;
                font-weight: 600;
                color: #2c3e50;
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
                color: #495057;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .form-control, select {
                padding: 10px 14px;
                border: 2px solid #dee2e6;
                border-radius: 8px;
                font-size: 14px;
                font-family: inherit;
                transition: all 0.2s;
                background: white;
                color: #2c3e50;
            }

            .form-control:focus, select:focus {
                outline: none;
                border-color: #6c757d;
                box-shadow: 0 0 0 3px rgba(108, 117, 125, 0.1);
            }

            .button-group {
                display: flex;
                gap: 12px;
                justify-content: flex-end;
                margin-top: 16px;
            }

            .stats-summary {
                background: #e7f1ff;
                color: #084298;
                padding: 20px;
                border-radius: 12px;
                margin-bottom: 20px;
                display: flex;
                gap: 30px;
                flex-wrap: wrap;
                border: 1px solid #b6d4fe;
            }

            .stats-summary p {
                font-size: 14px;
                font-weight: 500;
            }

            .stats-summary strong {
                font-size: 24px;
                display: block;
                margin-top: 4px;
                color: #052c65;
                font-weight: 700;
            }

            .report-section {
                margin-top: 30px;
            }

            .report-header {
                background: #f8f9fa;
                padding: 16px 20px;
                border-radius: 8px 8px 0 0;
                border: 1px solid #dee2e6;
                border-bottom: none;
            }

            .report-header h3 {
                font-size: 18px;
                font-weight: 600;
                color: #2c3e50;
            }

            .table-container {
                overflow-x: auto;
                border-radius: 0 0 12px 12px;
                border: 1px solid #dee2e6;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                background: white;
            }

            thead {
                background: #f8f9fa;
                border-bottom: 2px solid #dee2e6;
            }

            th {
                padding: 16px;
                text-align: left;
                font-weight: 600;
                font-size: 13px;
                color: #495057;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                white-space: nowrap;
            }

            td {
                padding: 16px;
                border-bottom: 1px solid #f8f9fa;
                font-size: 14px;
                color: #2c3e50;
            }

            tbody tr {
                transition: background-color 0.2s ease;
            }

            tbody tr:hover {
                background: #f8f9fa;
            }

            .badge {
                padding: 6px 12px;
                border-radius: 6px;
                font-size: 12px;
                font-weight: 500;
                display: inline-block;
            }

            .badge-Admin {
                background: #cfe2ff;
                color: #084298;
                border: 1px solid #9ec5fe;
            }
            .badge-Doctor {
                background: #fff3cd;
                color: #664d03;
                border: 1px solid #ffecb5;
            }
            .badge-Pharmacist {
                background: #d1e7dd;
                color: #0f5132;
                border: 1px solid #badbcc;
            }
            .badge-Manager {
                background: #e7d6ff;
                color: #4a148c;
                border: 1px solid #d1b3ff;
            }
            .badge-Auditor {
                background: #f8d7da;
                color: #842029;
                border: 1px solid #f1aeb5;
            }
            .badge-ProcurementOfficer {
                background: #e2d9f3;
                color: #5a23c8;
                border: 1px solid #d3bef0;
            }
            .badge-Supplier {
                background: #cff4fc;
                color: #055160;
                border: 1px solid #b6effb;
            }

            .no-data {
                text-align: center;
                padding: 60px 20px;
                color: #6c757d;
                background: white;
                border-radius: 0 0 12px 12px;
            }

            .no-data-icon {
                font-size: 64px;
                margin-bottom: 16px;
                opacity: 0.3;
            }

            .result-count {
                padding: 12px 16px;
                background: #e7f1ff;
                border: 1px solid #b6d4fe;
                border-radius: 8px;
                color: #084298;
                font-size: 14px;
                font-weight: 500;
                margin-bottom: 16px;
            }

            @media (max-width: 768px) {
                .main-wrapper {
                    flex-direction: column;
                }

                .sidebar {
                    width: 100%;
                    min-height: auto;
                    border-right: none;
                    border-bottom: 1px solid #dee2e6;
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

                .content {
                    padding: 20px;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header include -->
        <%@ include file="header.jsp" %>

        <div class="main-wrapper">
            <!-- Left sidebar -->
            <div class="sidebar">
                <div class="sidebar-brand">
                    <span>🏥</span>
                    Hệ thống
                </div>
                <div class="sidebar-menu">
                    <a class="sidebar-item" href="${pageContext.request.contextPath}/admin-dashboard">
                        ← Quay lại Dashboard
                    </a>
                    <a class="sidebar-item sidebar-item-primary" href="${pageContext.request.contextPath}/user-reports/generate">
                        📊 Báo cáo
                    </a>
                    <a class="sidebar-item" href="${pageContext.request.contextPath}/admin-dashboard/config">
                        ⚙️ Cấu hình
                    </a>
                    <a class="sidebar-item" href="${pageContext.request.contextPath}/admin/permissions">
                        🔐 Phân quyền
                    </a>
                    <a class="sidebar-item" href="${pageContext.request.contextPath}/admin-dashboard/create">
                        ➕ Tạo tài khoản
                    </a>
                    <button class="sidebar-item" type="button" onclick="openSwitchDashboardModal()">
                        🔁 Chuyển Dashboard
                    </button>    
                </div>
            </div>

            <!-- Main content -->
            <div class="main-content">
                <div class="container">
                    <div class="header">
                        <h1>
                            <span class="header-icon">📊</span>
                            Báo cáo hoạt động người dùng
                        </h1>
                    </div>

                    <div class="content">
                        <!-- Error/Success messages -->
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
        </div>

        <!-- Footer include -->
        <%@ include file="footer.jsp" %>
        <!-- 🔁 Modal Chuyển Dashboard -->
        <div id="switchDashboardModal" class="modal">
  <div class="modal-content" style="max-width:600px;">
    <div class="modal-header">🔁 Chuyển Dashboard</div>
    <div class="modal-body">
      <p>Chọn dashboard bạn muốn truy cập:</p>
      <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:12px;margin-top:16px;">
        <a href="doctor-dashboard" style="background:#495057;color:#ffffff;padding:12px;border-radius:8px;text-align:center;text-decoration:none;font-weight:600;">Doctor</a>
        <a href="pharmacist-dashboard" style="background:#495057;color:#ffffff;padding:12px;border-radius:8px;text-align:center;text-decoration:none;font-weight:600;">Pharmacist</a>
        <a href="manager-dashboard" style="background:#495057;color:#ffffff;padding:12px;border-radius:8px;text-align:center;text-decoration:none;font-weight:600;">Manager</a>
        <a href="auditor-dashboard" style="background:#495057;color:#ffffff;padding:12px;border-radius:8px;text-align:center;text-decoration:none;font-weight:600;">Auditor</a>
      </div>
    </div>
    <div class="modal-actions" style="justify-content:center;margin-top:20px;">
      <button onclick="closeSwitchDashboardModal()" style="background:#f1f3f5;color:#212529;padding:10px 20px;border:none;border-radius:6px;font-weight:600;cursor:pointer;">Đóng</button>
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

            window.onload = function () {
                toggleFilters();
            };
            // ---- Modal chuyển dashboard ----
            function openSwitchDashboardModal() {
                document.getElementById("switchDashboardModal").classList.add("active");
            }
            function closeSwitchDashboardModal() {
                document.getElementById("switchDashboardModal").classList.remove("active");
            }
            document.getElementById("switchDashboardModal").addEventListener("click", function (e) {
                if (e.target === this)
                    closeSwitchDashboardModal();
            });
        </script>
    </body>
</html>