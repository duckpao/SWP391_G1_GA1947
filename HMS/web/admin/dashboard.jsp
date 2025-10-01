<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Quản lý người dùng - Hệ thống quản lý kho bệnh viện</title>
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
    
    .btn-primary {
      background: white;
      color: #667eea;
    }
    
    .btn-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
    }
    
    .btn-edit {
      background: #3b82f6;
      color: white;
      padding: 8px 16px;
      font-size: 13px;
    }
    
    .btn-edit:hover {
      background: #2563eb;
    }
    
    .btn-delete {
      background: #ef4444;
      color: white;
      padding: 8px 16px;
      font-size: 13px;
    }
    
    .btn-delete:hover {
      background: #dc2626;
    }
    
    .btn-toggle {
      background: #f59e0b;
      color: white;
      padding: 8px 16px;
      font-size: 13px;
    }
    
    .btn-toggle:hover {
      background: #d97706;
    }
    
    .btn-unlock {
      background: #10b981;
      color: white;
    }
    
    .btn-unlock:hover {
      background: #059669;
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
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 20px;
      border-radius: 12px;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }
    
    .stat-card h3 {
      font-size: 14px;
      font-weight: 500;
      opacity: 0.9;
      margin-bottom: 8px;
    }
    
    .stat-card p {
      font-size: 32px;
      font-weight: 700;
    }
    
    .table-container {
      overflow-x: auto;
      border-radius: 12px;
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
      border-radius: 20px;
      font-size: 12px;
      font-weight: 600;
      display: inline-block;
    }
    
    .badge-active {
      background: #d1fae5;
      color: #065f46;
    }
    
    .badge-locked {
      background: #fee2e2;
      color: #991b1b;
    }
    
    .role-badge {
      padding: 6px 12px;
      border-radius: 6px;
      font-size: 12px;
      font-weight: 500;
      display: inline-block;
    }
    
    .role-admin { background: #dbeafe; color: #1e40af; }
    .role-doctor { background: #fef3c7; color: #92400e; }
    .role-pharmacist { background: #d1fae5; color: #065f46; }
    .role-manager { background: #e0e7ff; color: #3730a3; }
    .role-auditor { background: #fce7f3; color: #9f1239; }
    .role-procurement { background: #f3e8ff; color: #6b21a8; }
    .role-supplier { background: #dbeafe; color: #075985; }
    
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
      color: #6b7280;
    }
    
    .empty-state-icon {
      font-size: 64px;
      margin-bottom: 16px;
      opacity: 0.5;
    }
    
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
    
    .modal.active {
      display: flex;
    }
    
    .modal-content {
      background: white;
      padding: 30px;
      border-radius: 12px;
      max-width: 400px;
      width: 90%;
    }
    
    .modal-header {
      font-size: 20px;
      font-weight: 700;
      margin-bottom: 16px;
      color: #1f2937;
    }
    
    .modal-body {
      color: #6b7280;
      margin-bottom: 24px;
      line-height: 1.6;
    }
    
    .modal-actions {
      display: flex;
      gap: 12px;
      justify-content: flex-end;
    }
    
    .btn-cancel {
      background: #e5e7eb;
      color: #374151;
    }
    
    .btn-cancel:hover {
      background: #d1d5db;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>
        <span class="header-icon">👥</span>
        Quản lý người dùng
      </h1>
      <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/users/create">
        ➕ Tạo tài khoản mới
      </a>
    </div>
    
    <div class="content">
      <div class="stats-bar">
        <div class="stat-card">
          <h3>Tổng người dùng</h3>
          <p>${users.size()}</p>
        </div>
        <div class="stat-card">
          <h3>Đang hoạt động</h3>
          <p><c:out value="${users.stream().filter(u -> u.isActive).count()}"/></p>
        </div>
        <div class="stat-card">
          <h3>Bị khóa</h3>
          <p><c:out value="${users.stream().filter(u -> !u.isActive).count()}"/></p>
        </div>
      </div>
      
      <div class="table-container">
        <c:choose>
          <c:when test="${empty users}">
            <div class="empty-state">
              <div class="empty-state-icon">📭</div>
              <h3>Chưa có người dùng nào</h3>
              <p>Nhấn "Tạo tài khoản mới" để thêm người dùng đầu tiên</p>
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
                        <a class="btn btn-edit" href="${pageContext.request.contextPath}/admin/users/edit?id=${u.userId}">
                          ✏️ Sửa
                        </a>
                        
                        <form class="inline" action="${pageContext.request.contextPath}/admin/users/toggle" method="post">
                          <input type="hidden" name="id" value="${u.userId}" />
                          <input type="hidden" name="active" value="${!u.isActive}" />
                          <button class="btn ${u.isActive ? 'btn-toggle' : 'btn-unlock'}" type="submit">
                            ${u.isActive ? '🔒 Khóa' : '🔓 Mở'}
                          </button>
                        </form>
                        
                        <button class="btn btn-delete" onclick="confirmDelete(${u.userId}, '${u.username}')">
                          🗑️ Xóa
                        </button>
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
  
  <!-- Modal xác nhận xóa -->
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
        <form id="deleteForm" class="inline" action="${pageContext.request.contextPath}/admin/users/delete" method="post">
          <input type="hidden" name="id" id="deleteUserId" />
          <button class="btn btn-delete" type="submit">Xác nhận xóa</button>
        </form>
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
    
    // Đóng modal khi click bên ngoài
    document.getElementById('deleteModal').addEventListener('click', function(e) {
      if (e.target === this) {
        closeDeleteModal();
      }
    });
  </script>
</body>
</html>