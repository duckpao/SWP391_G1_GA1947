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
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      padding: 20px;
    }
    
    .container {
      max-width: 1400px;
      margin: 0 auto;
      background: #fff;
      border-radius: 16px;
      box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
      overflow: hidden;
    }
    
    .header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 30px 40px;
      display: flex;
      justify-content: space-between;
      align-items: center;
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
      background: rgba(255, 255, 255, 0.2);
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
      background: white;
      color: #667eea;
    }
    
    .btn-back:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    }
    
    .btn-primary {
      background: #667eea;
      color: white;
    }
    
    .btn-primary:hover {
      background: #5568d3;
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
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
      border-color: #667eea;
      box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }

    /* Search Box Styles */
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

    /* Custom Select with Search Results */
    .select-wrapper {
      position: relative;
    }

    .user-dropdown {
      position: absolute;
      top: 100%;
      left: 0;
      right: 0;
      background: white;
      border: 1px solid #d1d5db;
      border-top: none;
      border-radius: 0 0 8px 8px;
      max-height: 300px;
      overflow-y: auto;
      z-index: 1000;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
      display: none;
    }

    .user-dropdown.active {
      display: block;
    }

    .user-option {
      padding: 12px 14px;
      cursor: pointer;
      transition: background 0.2s;
      border-bottom: 1px solid #f3f4f6;
    }

    .user-option:hover {
      background: #f9fafb;
    }

    .user-option:last-child {
      border-bottom: none;
    }

    .user-option-name {
      font-weight: 600;
      color: #1f2937;
      margin-bottom: 4px;
    }

    .user-option-meta {
      font-size: 12px;
      color: #6b7280;
      display: flex;
      align-items: center;
      gap: 12px;
    }

    .no-results {
      padding: 20px;
      text-align: center;
      color: #6b7280;
      font-size: 14px;
    }

    .search-info {
      font-size: 12px;
      color: #6b7280;
      margin-top: 8px;
      font-style: italic;
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
      border-color: #667eea;
      box-shadow: 0 4px 12px rgba(102, 126, 234, 0.1);
    }
    
    .permission-card.selected {
      border-color: #667eea;
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
      accent-color: #667eea;
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
      border: 2px solid #667eea;
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
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
      color: #667eea;
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
      color: #667eea;
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
      accent-color: #667eea;
    }
  </style>
</head>
<body>
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
      <!-- Success/Error Messages -->
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
      
      <!-- Step 1: Select User with Search -->
      <div class="section">
        <div class="section-header">
          👤 Bước 1: Chọn người dùng
        </div>
        
        <div class="form-group">
          <label for="userSearch">Tìm kiếm và chọn người dùng:</label>
          
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
            
            <div class="user-dropdown" id="userDropdown">
              <c:forEach var="user" items="${users}">
                <div class="user-option" 
                     data-user-id="${user.userId}"
                     data-username="${user.username}"
                     data-role="${user.role}"
                     data-email="${user.email}"
                     data-phone="${user.phone}"
                     onclick="selectUser(this)">
                  <div class="user-option-name">${user.username}</div>
                  <div class="user-option-meta">
                    <span class="role-badge role-${user.role.toLowerCase()}">${user.role}</span>
                    <span>📧 ${user.email != null ? user.email : '-'}</span>
                  </div>
                </div>
              </c:forEach>
              
              <div class="no-results" id="noResults" style="display: none;">
                Không tìm thấy người dùng nào
              </div>
            </div>
          </div>
          
          <div class="search-info">
            💡 Gợi ý: Bắt đầu nhập để tìm kiếm người dùng
          </div>
          
          <form method="get" action="${pageContext.request.contextPath}/admin/permissions" id="userSelectForm" style="display: none;">
            <input type="hidden" name="userId" id="selectedUserId" value="${param.userId}">
          </form>
        </div>
      </div>
      
      <!-- Step 2: Assign Permissions (only show if user is selected) -->
      <c:choose>
        <c:when test="${not empty selectedUser}">
          <!-- User Info Card -->
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
          
          <!-- Permissions Form -->
          <div class="section">
            <div class="section-header">
              ⚙️ Bước 2: Chọn quyền truy cập
            </div>
            
            <form method="post" action="${pageContext.request.contextPath}/admin/permissions" id="permissionsForm">
              <input type="hidden" name="userId" value="${selectedUser.userId}" />
              
              <!-- Select All Option -->
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
            <p>Vui lòng tìm và chọn một người dùng từ ô tìm kiếm trên để phân quyền</p>
          </div>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
  
  <script>
    const searchInput = document.getElementById('userSearch');
    const userDropdown = document.getElementById('userDropdown');
    const clearBtn = document.getElementById('clearSearch');
    const noResults = document.getElementById('noResults');
    const userOptions = document.querySelectorAll('.user-option');

    // Show/hide dropdown and filter users
    searchInput.addEventListener('input', function() {
      const searchTerm = this.value.toLowerCase().trim();
      
      // Show/hide clear button
      if (searchTerm) {
        clearBtn.classList.add('visible');
      } else {
        clearBtn.classList.remove('visible');
      }
      
      // Filter users
      let hasResults = false;
      userOptions.forEach(option => {
        const username = option.dataset.username.toLowerCase();
        const email = (option.dataset.email || '').toLowerCase();
        const phone = (option.dataset.phone || '').toLowerCase();
        const role = option.dataset.role.toLowerCase();
        
        if (username.includes(searchTerm) || 
            email.includes(searchTerm) || 
            phone.includes(searchTerm) ||
            role.includes(searchTerm)) {
          option.style.display = 'block';
          hasResults = true;
        } else {
          option.style.display = 'none';
        }
      });
      
      // Show dropdown if there's input
      if (searchTerm) {
        userDropdown.classList.add('active');
        noResults.style.display = hasResults ? 'none' : 'block';
      } else {
        userDropdown.classList.remove('active');
      }
    });

    // Show dropdown on focus
    searchInput.addEventListener('focus', function() {
      if (this.value.trim()) {
        userDropdown.classList.add('active');
      }
    });

    // Hide dropdown when clicking outside
    document.addEventListener('click', function(e) {
      if (!e.target.closest('.select-wrapper')) {
        userDropdown.classList.remove('active');
      }
    });

    // Select user
    function selectUser(option) {
      const userId = option.dataset.userId;
      const username = option.dataset.username;
      
      searchInput.value = username;
      userDropdown.classList.remove('active');
      
      // Submit form to load user permissions
      document.getElementById('selectedUserId').value = userId;
      document.getElementById('userSelectForm').submit();
    }

    // Clear search
    function clearSearch() {
      searchInput.value = '';
      clearBtn.classList.remove('visible');
      userDropdown.classList.remove('active');
      userOptions.forEach(option => {
        option.style.display = 'block';
      });
      searchInput.focus();
    }

    // Permission management functions
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
    
    // Initialize on page load
    document.addEventListener('DOMContentLoaded', function() {
      updateSelectedCount();
      updateSelectAllState();
      
      // Show clear button if search has value
      if (searchInput.value.trim()) {
        clearBtn.classList.add('visible');
      }
    });
  </script>
</body>
</html>