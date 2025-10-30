<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý người dùng - Pharmacy Warehouse Management System</title>
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
    from { opacity: 0; }
    to { opacity: 1; }
}

@keyframes slideDown {
    from { transform: translateY(-15px); opacity: 0; }
    to { transform: translateY(0); opacity: 1; }
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

            .sidebar-item[type="button"] {
                font-family: inherit;
                font-weight: 500;
                font-size: 14px;
                color: #495057;
                text-align: left;
                border: none;
                background: none;
                width: 100%;
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 12px 16px;
                border-radius: 8px;
                cursor: pointer;
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

            .btn-edit {
                background: #495057;
                color: white;
                padding: 8px 16px;
                font-size: 13px;
                border: 1px solid #343a40;
            }

            .btn-edit:hover {
                background: #343a40;
            }

            .btn-delete {
                background: #dc3545;
                color: white;
                padding: 8px 16px;
                font-size: 13px;
                border: 1px solid #c82333;
            }

            .btn-delete:hover {
                background: #c82333;
            }

            .btn-toggle {
                background: #ffc107;
                color: #212529;
                padding: 8px 16px;
                font-size: 13px;
                border: 1px solid #e0a800;
            }

            .btn-toggle:hover {
                background: #e0a800;
            }

            .btn-unlock {
                background: #28a745;
                color: white;
                border: 1px solid #218838;
            }

            .btn-unlock:hover {
                background: #218838;
            }

            .btn-reset {
                background: #6c757d;
                color: white;
                padding: 10px 20px;
                border: 1px solid #5a6268;
            }

            .btn-reset:hover {
                background: #5a6268;
            }

            .content {
                padding: 40px;
            }

            .stats-bar {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .stat-card {
                background: #f8f9fa;
                color: #2c3e50;
                padding: 20px;
                border-radius: 12px;
                border: 1px solid #dee2e6;
                border-left: 4px solid #495057;
            }

            .stat-card h3 {
                font-size: 14px;
                font-weight: 500;
                color: #6c757d;
                margin-bottom: 8px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .stat-card p {
                font-size: 32px;
                font-weight: 700;
                color: #495057;
            }

            .filter-section {
                background: #f8f9fa;
                padding: 24px;
                border-radius: 12px;
                margin-bottom: 24px;
                border: 1px solid #dee2e6;
            }

            .filter-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }

            .filter-header h2 {
                font-size: 18px;
                font-weight: 600;
                color: #2c3e50;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .filter-grid {
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

            .form-control {
                padding: 10px 14px;
                border: 2px solid #dee2e6;
                border-radius: 8px;
                font-size: 14px;
                font-family: inherit;
                transition: all 0.2s;
                background: white;
                color: #2c3e50;
            }

            .form-control:focus {
                outline: none;
                border-color: #6c757d;
                box-shadow: 0 0 0 3px rgba(108, 117, 125, 0.1);
            }

            .filter-actions {
                display: flex;
                gap: 12px;
                justify-content: flex-end;
            }

            .active-filters {
                display: flex;
                gap: 8px;
                flex-wrap: wrap;
                margin-top: 16px;
            }

            .filter-tag {
                background: #495057;
                color: white;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                display: flex;
                align-items: center;
                gap: 6px;
            }

            .filter-tag button {
                background: none;
                border: none;
                color: white;
                cursor: pointer;
                padding: 0;
                font-size: 16px;
                line-height: 1;
            }

            .table-container {
                overflow-x: auto;
                border-radius: 12px;
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
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                display: inline-block;
            }

            .badge-active {
                background: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }

            .badge-locked {
                background: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }

            .role-badge {
                padding: 6px 12px;
                border-radius: 6px;
                font-size: 12px;
                font-weight: 500;
                display: inline-block;
            }

            .role-admin {
                background: #cfe2ff;
                color: #084298;
                border: 1px solid #9ec5fe;
            }
            .role-doctor {
                background: #fff3cd;
                color: #664d03;
                border: 1px solid #ffecb5;
            }
            .role-pharmacist {
                background: #d1e7dd;
                color: #0f5132;
                border: 1px solid #badbcc;
            }
            .role-manager {
                background: #e7d6ff;
                color: #4a148c;
                border: 1px solid #d1b3ff;
            }
            .role-auditor {
                background: #f8d7da;
                color: #842029;
                border: 1px solid #f1aeb5;
            }
            .role-procurementofficer {
                background: #e2d9f3;
                color: #5a23c8;
                border: 1px solid #d3bef0;
            }
            .role-supplier {
                background: #cff4fc;
                color: #055160;
                border: 1px solid #b6effb;
            }

            .action-buttons {
                display: flex;
                gap: 8px;
                flex-wrap: wrap;
            }

            form.inline {
                display: inline;
                margin: 0;
            }

            .empty-state {
                text-align: center;
                padding: 60px 20px;
                color: #6c757d;
            }

            .empty-state-icon {
                font-size: 64px;
                margin-bottom: 16px;
                opacity: 0.3;
            }

            

            .btn-cancel {
                background: #e9ecef;
                color: #495057;
                border: 1px solid #dee2e6;
            }

            .btn-cancel:hover {
                background: #dee2e6;
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
                    <a class="sidebar-item sidebar-item-primary" href="${pageContext.request.contextPath}/admin-dashboard">
                        Dashboard
                    </a>
                    <a class="sidebar-item" href="${pageContext.request.contextPath}/user-reports/generate">
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
                            <span class="header-icon">👥</span>
                            Quản lý người dùng
                        </h1>
                    </div>

                    <div class="content">
                        <!-- Error/Success messages -->
                        <c:if test="${not empty param.error}">
                            <div class="alert alert-error">
                                <strong>⚠️ Lỗi:</strong>
                                <c:choose>
                                    <c:when test="${param.error == 'cannot_modify_admin'}">
                                        Không thể khóa/mở khóa tài khoản Admin!
                                    </c:when>
                                    <c:when test="${param.error == 'cannot_delete_admin'}">
                                        Không thể xóa tài khoản Admin!
                                    </c:when>
                                    <c:when test="${param.error == 'delete_failed'}">
                                        Xóa người dùng thất bại!
                                    </c:when>
                                    <c:otherwise>
                                        ${param.error}
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:if>

                        <c:if test="${not empty param.success}">
                            <div class="alert alert-success">
                                <strong>✅ Thành công:</strong>
                                <c:choose>
                                    <c:when test="${param.success == 'deleted'}">
                                        Đã xóa người dùng thành công!
                                    </c:when>
                                    <c:otherwise>
                                        ${param.success}
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:if>

                        <!-- Stats -->
                        <div class="stats-bar">
                            <div class="stat-card">
                                <h3>Tổng người dùng</h3>
                                <p>${totalUsers}</p>
                            </div>
                            <div class="stat-card">
                                <h3>Đang hoạt động</h3>
                                <p>${activeUsers}</p>
                            </div>
                            <div class="stat-card">
                                <h3>Bị khóa</h3>
                                <p>${lockedUsers}</p>
                            </div>
                        </div>

                        <!-- Filter Section -->
                        <div class="filter-section">
                            <div class="filter-header">
                                <h2>🔍 Tìm kiếm & Lọc</h2>
                            </div>

                            <form method="get" action="${pageContext.request.contextPath}/admin-dashboard">
                                <div class="filter-grid">
                                    <div class="form-group">
                                        <label for="keyword">Từ khóa</label>
                                        <input 
                                            type="text" 
                                            id="keyword" 
                                            name="keyword" 
                                            class="form-control" 
                                            placeholder="Tìm theo tên, email, số điện thoại..."
                                            value="${param.keyword}">
                                    </div>

                                    <div class="form-group">
                                        <label for="role">Vai trò</label>
                                        <select id="role" name="role" class="form-control">
                                            <option value="">-- Tất cả vai trò --</option>
                                            <option value="Admin" ${param.role == 'Admin' ? 'selected' : ''}>Admin</option>
                                            <option value="Doctor" ${param.role == 'Doctor' ? 'selected' : ''}>Doctor</option>
                                            <option value="Pharmacist" ${param.role == 'Pharmacist' ? 'selected' : ''}>Pharmacist</option>
                                            <option value="Manager" ${param.role == 'Manager' ? 'selected' : ''}>Manager</option>
                                            <option value="Auditor" ${param.role == 'Auditor' ? 'selected' : ''}>Auditor</option>
                                            <option value="ProcurementOfficer" ${param.role == 'ProcurementOfficer' ? 'selected' : ''}>Procurement Officer</option>
                                            <option value="Supplier" ${param.role == 'Supplier' ? 'selected' : ''}>Supplier</option>
                                        </select>
                                    </div>

                                    <div class="form-group">
                                        <label for="status">Trạng thái</label>
                                        <select id="status" name="status" class="form-control">
                                            <option value="">-- Tất cả trạng thái --</option>
                                            <option value="active" ${param.status == 'active' ? 'selected' : ''}>Đang hoạt động</option>
                                            <option value="locked" ${param.status == 'locked' ? 'selected' : ''}>Bị khóa</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="filter-actions">
                                    <a href="${pageContext.request.contextPath}/admin-dashboard" class="btn btn-reset">
                                        🔄 Xóa bộ lọc
                                    </a>
                                    <button type="submit" class="btn btn-primary">
                                        🔍 Tìm kiếm
                                    </button>
                                </div>

                                <!-- Active Filters -->
                                <c:if test="${not empty param.keyword || not empty param.role || not empty param.status}">
                                    <div class="active-filters">
                                        <c:if test="${not empty param.keyword}">
                                            <span class="filter-tag">
                                                Từ khóa: "${param.keyword}"
                                                <a href="${pageContext.request.contextPath}/admin-dashboard?role=${param.role}&status=${param.status}">
                                                    <button type="button">×</button>
                                                </a>
                                            </span>
                                        </c:if>
                                        <c:if test="${not empty param.role}">
                                            <span class="filter-tag">
                                                Vai trò: ${param.role}
                                                <a href="${pageContext.request.contextPath}/admin-dashboard?keyword=${param.keyword}&status=${param.status}">
                                                    <button type="button">×</button>
                                                </a>
                                            </span>
                                        </c:if>
                                        <c:if test="${not empty param.status}">
                                            <span class="filter-tag">
                                                Trạng thái: ${param.status == 'active' ? 'Đang hoạt động' : 'Bị khóa'}
                                                <a href="${pageContext.request.contextPath}/admin-dashboard?keyword=${param.keyword}&role=${param.role}">
                                                    <button type="button">×</button>
                                                </a>
                                            </span>
                                        </c:if>
                                    </div>
                                </c:if>
                            </form>
                        </div>

                        <!-- Result Count -->
                        <c:if test="${not empty users}">
                            <div class="result-count">
                                📊 Tìm thấy <strong>${users.size()}</strong> người dùng
                            </div>
                        </c:if>

                        <!-- Users Table -->
                        <div class="table-container">
                            <c:choose>
                                <c:when test="${empty users}">
                                    <div class="empty-state">
                                        <div class="empty-state-icon">📭</div>
                                        <h3>Không tìm thấy người dùng nào</h3>
                                        <p>Thử thay đổi bộ lọc hoặc tạo tài khoản mới</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Tên đăng nhập</th>
                                                <th>Email</th>
                                                <th>Số điện thoại</th>
                                                <th>Vai trò</th>
                                                <th>Trạng thái</th>
                                                <th>Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="u" items="${users}">
                                                <tr>
                                                    <td><strong>#${u.userId}</strong></td>
                                                    <td>${u.username}</td>
                                                    <td>${u.email != null ? u.email : '-'}</td>
                                                    <td>${u.phone != null ? u.phone : '-'}</td>
                                                    <td>
                                                        <span class="role-badge role-${u.role.toLowerCase()}">
                                                            ${u.role}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span class="badge ${u.isActive ? 'badge-active' : 'badge-locked'}">
                                                            ${u.isActive ? '✓ Active' : '🔒 Locked'}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <div class="action-buttons">
                                                            <c:choose>
                                                                <c:when test="${u.role == 'Admin'}">
                                                                    <span class="badge" style="background: #fff3cd; color: #664d03; border: 1px solid #ffecb5;">
                                                                        🛡️ Tài khoản được bảo vệ
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <a class="btn btn-edit" href="${pageContext.request.contextPath}/admin-dashboard/edit?id=${u.userId}">
                                                                        ✏️ Sửa
                                                                    </a>

                                                                    <form class="inline" action="${pageContext.request.contextPath}/admin-dashboard/toggle" method="post">
                                                                        <input type="hidden" name="id" value="${u.userId}" />
                                                                        <input type="hidden" name="active" value="${!u.isActive}" />
                                                                        <button class="btn ${u.isActive ? 'btn-toggle' : 'btn-unlock'}" type="submit">
                                                                            ${u.isActive ? '🔒 Khóa' : '🔓 Mở'}
                                                                        </button>
                                                                    </form>

                                                                    <button class="btn btn-delete" onclick="confirmDelete(${u.userId}, '${u.username}')">
                                                                        🗑️ Xóa
                                                                    </button>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer include -->
        <%@ include file="footer.jsp" %>

        <!-- Delete Confirmation Modal -->
        <div id="deleteModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">⚠️ Xác nhận xóa</div>
                <div class="modal-body">
                    Bạn có chắc chắn muốn xóa người dùng <strong id="deleteUsername"></strong>?
                    <br><br>
                    Hành động này không thể hoàn tác!
                </div>
                <div class="modal-actions">
                    <button class="btn btn-cancel" onclick="closeDeleteModal()">Hủy</button>
                    <form id="deleteForm" class="inline" action="${pageContext.request.contextPath}/admin-dashboard/delete" method="post">
                        <input type="hidden" name="id" id="deleteUserId" />
                        <button class="btn btn-delete" type="submit">Xác nhận xóa</button>
                    </form>
                </div>
            </div>
        </div>
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
            function confirmDelete(userId, username) {
                document.getElementById('deleteUserId').value = userId;
                document.getElementById('deleteUsername').textContent = username;
                document.getElementById('deleteModal').classList.add('active');
            }

            function closeDeleteModal() {
                document.getElementById('deleteModal').classList.remove('active');
            }

            document.getElementById('deleteModal').addEventListener('click', function (e) {
                if (e.target === this) {
                    closeDeleteModal();
                }
            });
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