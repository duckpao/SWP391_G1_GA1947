<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Quản lý phân quyền - Hệ thống quản lý kho bệnh viện</title>
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

    /* Added main-content wrapper for layout */
    .main-content {
      margin-left: 260px;
      flex: 1;
      padding: 20px;
    }

    .container {
      max-width: 1400px;
      margin: 0 auto;
      background: #fff;
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

    .btn-back {
      background: #f3f4f6;
      color: #3b82f6;
    }

    .btn-back:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
      background: #e5e7eb;
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

    .content {
      padding: 40px;
    }

    .alert {
      padding: 16px;
      margin-bottom: 20px;
      border-radius: 8px;
      font-size: 14px;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .alert-success {
      background: #d1fae5;
      border: 1px solid #6ee7b7;
      color: #065f46;
    }

    .alert-error {
      background: #fee2e2;
      border: 1px solid #fca5a5;
      color: #991b1b;
    }

    .section {
      background: #f9fafb;
      padding: 24px;
      border-radius: 12px;
      margin-bottom: 24px;
      border: 1px solid #e5e7eb;
    }

    .section-header {
      font-size: 18px;
      font-weight: 600;
      color: #1f2937;
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
      font-size: 14px;
      font-weight: 600;
      color: #374151;
      margin-bottom: 8px;
    }

    .form-control {
      width: 100%;
      padding: 12px 14px;
      border: 1px solid #d1d5db;
      border-radius: 8px;
      font-size: 14px;
      font-family: inherit;
      transition: all 0.2s;
    }

    .form-control:focus {
      outline: none;
      border-color: #3b82f6;
      box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
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
      color: #6b7280;
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
      color: #6b7280;
      cursor: pointer;
      font-size: 18px;
      padding: 4px;
      display: none;
      transition: color 0.2s;
    }

    .clear-search:hover {
      color: #374151;
    }

    .clear-search.visible {
      display: block;
    }

    .select-wrapper {
      position: relative;
    }

    .user-list-table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 16px;
    }

    .user-list-table thead {
      background: #f3f4f6;
      border-bottom: 2px solid #e5e7eb;
    }

    .user-list-table th {
      padding: 12px 14px;
      text-align: left;
      font-weight: 600;
      color: #374151;
      font-size: 13px;
    }

    .user-list-table tbody tr {
      border-bottom: 1px solid #e5e7eb;
      transition: background 0.2s;
      cursor: pointer;
    }

    .user-list-table tbody tr:hover {
      background: #f9fafb;
    }

    .user-list-table td {
      padding: 12px 14px;
      font-size: 14px;
      color: #374151;
    }

    .user-list-table .user-name {
      font-weight: 600;
      color: #1f2937;
    }

    .user-list-table .user-email {
      color: #6b7280;
      font-size: 13px;
    }

    .user-list-table .user-phone {
      color: #6b7280;
      font-size: 13px;
    }

    .user-list-empty {
      text-align: center;
      padding: 40px 20px;
      color: #6b7280;
    }

    .user-list-count {
      font-size: 13px;
      color: #6b7280;
      margin-top: 12px;
      padding: 8px 0;
    }

    .permissions-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
      gap: 16px;
      margin-top: 20px;
    }

    .permission-card {
      background: white;
      border: 2px solid #e5e7eb;
      border-radius: 8px;
      padding: 16px;
      transition: all 0.2s;
      cursor: pointer;
    }

    .permission-card:hover {
      border-color: #3b82f6;
      box-shadow: 0 4px 12px rgba(59, 130, 246, 0.1);
    }

    .permission-card.selected {
      border-color: #3b82f6;
      background: #f0f4ff;
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
      accent-color: #3b82f6;
    }

    .permission-info {
      flex: 1;
    }

    .permission-name {
      font-weight: 600;
      color: #1f2937;
      margin-bottom: 4px;
      font-size: 14px;
    }

    .permission-desc {
      font-size: 13px;
      color: #6b7280;
      line-height: 1.4;
    }

    .user-info-card {
      background: white;
      border: 2px solid #3b82f6;
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
      background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
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
      color: #1f2937;
      margin-bottom: 4px;
    }

    .user-meta {
      font-size: 13px;
      color: #6b7280;
    }

    .role-badge {
      padding: 6px 12px;
      border-radius: 6px;
      font-size: 12px;
      font-weight: 600;
      display: inline-block;
      margin-left: 8px;
    }

    .role-admin { background: #dbeafe; color: #1e40af; }
    .role-doctor { background: #fef3c7; color: #92400e; }
    .role-pharmacist { background: #d1fae5; color: #065f46; }
    .role-manager { background: #e0e7ff; color: #3730a3; }
    .role-auditor { background: #fce7f3; color: #9f1239; }
    .role-procurementofficer { background: #f3e8ff; color: #6b21a8; }
    .role-supplier { background: #dbeafe; color: #075985; }

    .empty-state {
      text-align: center;
      padding: 60px 20px;
      color: #6b7280;
    }

    .empty-state-icon {
      font-size: 64px;
      margin-bottom: 16px;
      opacity: 0.5;
    }

    .empty-state h3 {
      font-size: 20px;
      color: #374151;
      margin-bottom: 8px;
    }

    .form-actions {
      display: flex;
      gap: 12px;
      justify-content: flex-end;
      margin-top: 24px;
      padding-top: 24px;
      border-top: 2px solid #e5e7eb;
    }

    .btn-cancel {
      background: #e5e7eb;
      color: #374151;
    }

    .btn-cancel:hover {
      background: #d1d5db;
    }

    .stats-summary {
      display: flex;
      gap: 20px;
      margin-top: 16px;
      padding: 16px;
      background: #f0f4ff;
      border-radius: 8px;
      border: 1px solid #c7d2fe;
    }

    .stat-item {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .stat-label {
      font-size: 13px;
      color: #6b7280;
    }

    .stat-value {
      font-size: 16px;
      font-weight: 700;
      color: #3b82f6;
    }

    .select-all-section {
      padding: 16px;
      background: #f0f4ff;
      border-radius: 8px;
      margin-bottom: 16px;
      display: flex;
      align-items: center;
      gap: 12px;
    }

    .select-all-section label {
      font-weight: 600;
      color: #3b82f6;
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
      accent-color: #3b82f6;
    }

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

      .main-content {
        margin-left: 0;
        padding: 10px;
      }

      .container {
        border-radius: 8px;
      }

      .header {
        flex-direction: column;
        gap: 16px;
        padding: 20px;
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
  <!-- Added sidebar from admin-dashboard -->
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

  <!-- Wrapped content in main-content div -->
  <div class="main-content">
    <div class="container">
      <div class="header">
        <h1>
          <span class="header-icon">🔐</span>
          Quản lý phân quyền
        </h1>
        <a class="btn btn-back" href="${pageContext.request.contextPath}/admin-dashboard">
          ← Quay lại danh sách
        </a>
      </div>

      <div class="content">
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

        <div class="section">
          <div class="section-header">
            👤 Bước 1: Chọn người dùng
          </div>

          <div class="form-group">
            <label for="userSearch">Tìm kiếm người dùng:</label>

            <div class="search-wrapper select-wrapper">
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
                <table class="user-list-table">
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
                        <td class="user-name">${user.username}</td>
                        <td class="user-email">${user.email != null ? user.email : '-'}</td>
                        <td class="user-phone">${user.phone != null ? user.phone : '-'}</td>
                        <td><span class="role-badge role-${user.role.toLowerCase()}">${user.role}</span></td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </c:when>
              <c:otherwise>
                <div class="user-list-empty">
                  <div class="empty-state-icon">👥</div>
                  <p>Không có người dùng nào trong hệ thống</p>
                </div>
              </c:otherwise>
            </c:choose>

            <form method="get" action="${pageContext.request.contextPath}/admin/permissions" id="userSelectForm" style="display: none;">
              <input type="hidden" name="userId" id="selectedUserId" value="${param.userId}">
            </form>
          </div>
        </div>

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
                    <h3>Chưa có quyền nào trong hệ thống</h3>
                    <p>Vui lòng thêm các quyền vào database trước</p>
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

  <script>
    const searchInput = document.getElementById('userSearch');
    const clearBtn = document.getElementById('clearSearch');
    const userRows = document.querySelectorAll('.user-row');
    const userListBody = document.getElementById('userListBody');
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
