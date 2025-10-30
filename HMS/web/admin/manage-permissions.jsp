<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý phân quyền - Pharmacy Warehouse Management System</title>
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

        .btn-cancel {
            background: #e9ecef;
            color: #495057;
            border: 1px solid #dee2e6;
        }

        .btn-cancel:hover {
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

        .section {
            background: #f8f9fa;
            padding: 24px;
            border-radius: 12px;
            margin-bottom: 24px;
            border: 1px solid #dee2e6;
        }

        .section-header {
            font-size: 18px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #495057;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-control {
            width: 100%;
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

        .search-wrapper {
            position: relative;
            margin-bottom: 12px;
        }

        .search-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
            font-size: 16px;
        }

        .search-input {
            padding-left: 42px;
            padding-right: 42px;
        }

        .clear-search {
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #6c757d;
            cursor: pointer;
            font-size: 18px;
            padding: 4px;
            display: none;
            transition: color 0.2s;
        }

        .clear-search:hover {
            color: #495057;
        }

        .clear-search.visible {
            display: block;
        }

        .user-list-count {
            font-size: 13px;
            color: #6c757d;
            margin-top: 12px;
            padding: 8px 0;
        }

        .table-container {
            overflow-x: auto;
            border-radius: 12px;
            border: 1px solid #dee2e6;
            margin-top: 16px;
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
            cursor: pointer;
        }

        tbody tr:hover {
            background: #f8f9fa;
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

        .user-info-card {
            background: white;
            border: 2px solid #495057;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 24px;
        }

        .user-info-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 12px;
        }

        .user-avatar {
            width: 48px;
            height: 48px;
            background: linear-gradient(135deg, #495057 0%, #343a40 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 20px;
            font-weight: 700;
        }

        .user-details h3 {
            font-size: 18px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 4px;
        }

        .user-meta {
            font-size: 13px;
            color: #6c757d;
        }

        .stats-summary {
            display: flex;
            gap: 20px;
            margin-top: 16px;
            padding: 16px;
            background: #f8f9fa;
            border-radius: 8px;
            border: 1px solid #dee2e6;
        }

        .stat-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .stat-label {
            font-size: 13px;
            color: #6c757d;
        }

        .stat-value {
            font-size: 16px;
            font-weight: 700;
            color: #495057;
        }

        .select-all-section {
            padding: 16px;
            background: #f8f9fa;
            border-radius: 8px;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 12px;
            border: 1px solid #dee2e6;
        }

        .select-all-section label {
            font-weight: 600;
            color: #495057;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 0;
        }

        .select-all-section input[type="checkbox"] {
            width: 20px;
            height: 20px;
            cursor: pointer;
            accent-color: #495057;
        }

        .permissions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 16px;
            margin-top: 20px;
        }

        .permission-card {
            background: white;
            border: 2px solid #dee2e6;
            border-radius: 8px;
            padding: 16px;
            transition: all 0.2s;
            cursor: pointer;
        }

        .permission-card:hover {
            border-color: #495057;
            box-shadow: 0 4px 12px rgba(73, 80, 87, 0.1);
        }

        .permission-card.selected {
            border-color: #495057;
            background: #f8f9fa;
        }

        .permission-checkbox {
            display: flex;
            align-items: flex-start;
            gap: 12px;
        }

        .permission-checkbox input[type="checkbox"] {
            width: 20px;
            height: 20px;
            cursor: pointer;
            margin-top: 2px;
            accent-color: #495057;
        }

        .permission-info {
            flex: 1;
        }

        .permission-name {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 4px;
            font-size: 14px;
        }

        .permission-desc {
            font-size: 13px;
            color: #6c757d;
            line-height: 1.4;
        }

        .form-actions {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 24px;
            padding-top: 24px;
            border-top: 2px solid #dee2e6;
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

        .empty-state h3 {
            font-size: 20px;
            color: #495057;
            margin-bottom: 8px;
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
                flex-direction: column;
                gap: 16px;
            }

            .header h1 {
                font-size: 20px;
            }

            .content {
                padding: 20px;
            }

            .permissions-grid {
                grid-template-columns: 1fr;
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
                <a class="sidebar-item" href="${pageContext.request.contextPath}/user-reports/generate">
                    📊 Báo cáo
                </a>
                <a class="sidebar-item" href="${pageContext.request.contextPath}/admin-dashboard/config">
                    ⚙️ Cấu hình
                </a>
                <a class="sidebar-item sidebar-item-primary" href="${pageContext.request.contextPath}/admin/permissions">
                    🔐 Phân quyền
                </a>
                <a class="sidebar-item" href="${pageContext.request.contextPath}/admin-dashboard/create">
                    ➕ Tạo tài khoản
                </a>
            </div>
        </div>

        <!-- Main content -->
        <div class="main-content">
            <div class="container">
                <div class="header">
                    <h1>
                        <span class="header-icon">🔐</span>
                        Quản lý phân quyền
                    </h1>
                </div>

                <div class="content">
                    <!-- Error/Success messages -->
                    <c:if test="${not empty param.error}">
                        <div class="alert alert-error">
                            <strong>⚠️ Lỗi:</strong>
                            <c:choose>
                                <c:when test="${param.error == 'update_failed'}">
                                    Cập nhật phân quyền thất bại!
                                </c:when>
                                <c:when test="${param.error == 'invalid_input'}">
                                    Dữ liệu không hợp lệ!
                                </c:when>
                                <c:when test="${param.error == 'database_error'}">
                                    Lỗi kết nối cơ sở dữ liệu!
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
                                <c:when test="${param.success == 'updated'}">
                                    Đã cập nhật phân quyền thành công!
                                </c:when>
                                <c:otherwise>
                                    ${param.success}
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                    <!-- User Selection Section -->
                    <div class="section">
                        <div class="section-header">
                            👤 Bước 1: Chọn người dùng
                        </div>

                        <div class="form-group">
                            <label for="userSearch">Tìm kiếm người dùng:</label>

                            <div class="search-wrapper">
                                <span class="search-icon">🔍</span>
                                <input
                                    type="text"
                                    id="userSearch"
                                    class="form-control search-input"
                                    placeholder="Nhập tên, email hoặc số điện thoại..."
                                    autocomplete="off"
                                    value="${not empty selectedUser ? selectedUser.username : ''}">
                                <button type="button" class="clear-search" id="clearSearch" onclick="clearSearch()">✕</button>
                            </div>

                            <div class="user-list-count">
                                Tổng số người dùng: <strong id="totalUserCount">${users.size()}</strong> | Hiển thị: <strong id="visibleUserCount">${users.size()}</strong>
                            </div>

                            <c:choose>
                                <c:when test="${not empty users}">
                                    <div class="table-container">
                                        <table>
                                            <thead>
                                                <tr>
                                                    <th>Tên người dùng</th>
                                                    <th>Email</th>
                                                    <th>Số điện thoại</th>
                                                    <th>Vai trò</th>
                                                </tr>
                                            </thead>
                                            <tbody id="userListBody">
                                                <c:forEach var="user" items="${users}">
                                                    <tr class="user-row"
                                                        data-user-id="${user.userId}"
                                                        data-username="${user.username}"
                                                        data-role="${user.role}"
                                                        data-email="${user.email}"
                                                        data-phone="${user.phone}"
                                                        onclick="selectUserFromTable(this)">
                                                        <td><strong>${user.username}</strong></td>
                                                        <td>${user.email != null ? user.email : '-'}</td>
                                                        <td>${user.phone != null ? user.phone : '-'}</td>
                                                        <td><span class="role-badge role-${user.role.toLowerCase()}">${user.role}</span></td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="empty-state">
                                        <div class="empty-state-icon">👥</div>
                                        <h3>Không có người dùng nào</h3>
                                        <p>Không có người dùng nào trong hệ thống</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                            <form method="get" action="${pageContext.request.contextPath}/admin/permissions" id="userSelectForm" style="display: none;">
                                <input type="hidden" name="userId" id="selectedUserId" value="${param.userId}">
                            </form>
                        </div>
                    </div>

                    <!-- Permissions Section -->
                    <c:choose>
                        <c:when test="${not empty selectedUser}">
                            <div class="user-info-card">
                                <div class="user-info-header">
                                    <div class="user-avatar">
                                        ${selectedUser.username.substring(0, 1).toUpperCase()}
                                    </div>
                                    <div class="user-details">
                                        <h3>
                                            ${selectedUser.username}
                                            <span class="role-badge role-${selectedUser.role.toLowerCase()}">
                                                ${selectedUser.role}
                                            </span>
                                        </h3>
                                        <div class="user-meta">
                                            📧 ${selectedUser.email != null ? selectedUser.email : 'Chưa có email'}
                                            • 📱 ${selectedUser.phone != null ? selectedUser.phone : 'Chưa có SĐT'}
                                        </div>
                                    </div>
                                </div>

                                <div class="stats-summary">
                                    <div class="stat-item">
                                        <span class="stat-label">Tổng quyền có sẵn:</span>
                                        <span class="stat-value">${allPermissions.size()}</span>
                                    </div>
                                    <div class="stat-item">
                                        <span class="stat-label">Quyền đã gán:</span>
                                        <span class="stat-value" id="selectedCount">${userPermissionIds.size()}</span>
                                    </div>
                                </div>
                            </div>

                            <div class="section">
                                <div class="section-header">
                                    ⚙️ Bước 2: Chọn quyền truy cập
                                </div>

                                <form method="post" action="${pageContext.request.contextPath}/admin/permissions" id="permissionsForm">
                                    <input type="hidden" name="userId" value="${selectedUser.userId}" />

                                    <div class="select-all-section">
                                        <label>
                                            <input type="checkbox" id="selectAll" onclick="toggleAllPermissions(this)">
                                            <strong>Chọn tất cả quyền</strong>
                                        </label>
                                    </div>

                                    <div class="permissions-grid">
                                        <c:forEach var="perm" items="${allPermissions}">
                                            <div class="permission-card ${userPermissionIds.contains(perm.permissionId) ? 'selected' : ''}"
                                                 onclick="toggleCard(this)">
                                                <label class="permission-checkbox">
                                                    <input
                                                        type="checkbox"
                                                        name="permissionIds"
                                                        value="${perm.permissionId}"
                                                        class="permission-input"
                                                        ${userPermissionIds.contains(perm.permissionId) ? 'checked' : ''}
                                                        onclick="event.stopPropagation(); updateCard(this)">
                                                    <div class="permission-info">
                                                        <div class="permission-name">
                                                            ${perm.permissionName}
                                                        </div>
                                                        <div class="permission-desc">
                                                            ${perm.description != null ? perm.description : 'Không có mô tả'}
                                                        </div>
                                                    </div>
                                                </label>
                                            </div>
                                        </c:forEach>
                                    </div>

                                    <c:if test="${empty allPermissions}">
                                        <div class="empty-state">
                                            <div class="empty-state-icon">📭</div>
                                            <h3>Chưa có quyền nào</h3>
                                            <p>Chưa có quyền nào trong hệ thống</p>
                                        </div>
                                    </c:if>

                                    <div class="form-actions">
                                        <a href="${pageContext.request.contextPath}/admin/permissions" class="btn btn-cancel">
                                            ↩️ Chọn người khác
                                        </a>
                                        <button type="submit" class="btn btn-primary">
                                            💾 Lưu phân quyền
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <div class="empty-state-icon">👆</div>
                                <h3>Chọn người dùng để bắt đầu</h3>
                                <p>Vui lòng chọn một người dùng từ danh sách trên để phân quyền</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer include -->
    <%@ include file="footer.jsp" %>

    <script>
        const searchInput = document.getElementById('userSearch');
        const clearBtn = document.getElementById('clearSearch');
        const userRows = document.querySelectorAll('.user-row');
        const visibleUserCount = document.getElementById('visibleUserCount');
        const totalUserCount = document.getElementById('totalUserCount');

        searchInput.addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase().trim();

            if (searchTerm) {
                clearBtn.classList.add('visible');
            } else {
                clearBtn.classList.remove('visible');
            }

            let visibleCount = 0;
            userRows.forEach(row => {
                const username = row.dataset.username.toLowerCase();
                const email = (row.dataset.email || '').toLowerCase();
                const phone = (row.dataset.phone || '').toLowerCase();
                const role = row.dataset.role.toLowerCase();

                if (username.includes(searchTerm) ||
                    email.includes(searchTerm) ||
                    phone.includes(searchTerm) ||
                    role.includes(searchTerm)) {
                    row.style.display = 'table-row';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });

            visibleUserCount.textContent = visibleCount;
        });

        function clearSearch() {
            searchInput.value = '';
            clearBtn.classList.remove('visible');
            userRows.forEach(row => {
                row.style.display = 'table-row';
            });
            visibleUserCount.textContent = totalUserCount.textContent;
            searchInput.focus();
        }

        function selectUserFromTable(row) {
            const userId = row.dataset.userId;
            const username = row.dataset.username;

            searchInput.value = username;

            document.getElementById('selectedUserId').value = userId;
            document.getElementById('userSelectForm').submit();
        }

        function toggleCard(card) {
            const checkbox = card.querySelector('input[type="checkbox"]');
            checkbox.checked = !checkbox.checked;
            updateCard(checkbox);
        }

        function updateCard(checkbox) {
            const card = checkbox.closest('.permission-card');
            if (checkbox.checked) {
                card.classList.add('selected');
            } else {
                card.classList.remove('selected');
            }
            updateSelectedCount();
            updateSelectAllState();
        }

        function updateSelectedCount() {
            const checked = document.querySelectorAll('.permission-input:checked').length;
            const countElement = document.getElementById('selectedCount');
            if (countElement) {
                countElement.textContent = checked;
            }
        }

        function toggleAllPermissions(checkbox) {
            const allCheckboxes = document.querySelectorAll('.permission-input');
            const isChecked = checkbox.checked;

            allCheckboxes.forEach(cb => {
                cb.checked = isChecked;
                const card = cb.closest('.permission-card');
                if (isChecked) {
                    card.classList.add('selected');
                } else {
                    card.classList.remove('selected');
                }
            });

            updateSelectedCount();
        }

        function updateSelectAllState() {
            const selectAll = document.getElementById('selectAll');
            if (!selectAll) return;

            const allCheckboxes = document.querySelectorAll('.permission-input');
            const checkedCheckboxes = document.querySelectorAll('.permission-input:checked');

            if (checkedCheckboxes.length === 0) {
                selectAll.checked = false;
                selectAll.indeterminate = false;
            } else if (checkedCheckboxes.length === allCheckboxes.length) {
                selectAll.checked = true;
                selectAll.indeterminate = false;
            } else {
                selectAll.checked = false;
                selectAll.indeterminate = true;
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            updateSelectedCount();
            updateSelectAllState();

            if (searchInput.value.trim()) {
                clearBtn.classList.add('visible');
            }
        });
    </script>
</body>
</html>