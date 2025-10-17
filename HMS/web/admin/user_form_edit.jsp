<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Chỉnh sửa tài khoản - Hệ thống quản lý kho bệnh viện</title>
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
      display: flex;
      align-items: center;
      justify-content: center;
    }
    
    .container {
      max-width: 600px;
      width: 100%;
      background: white;
      border-radius: 16px;
      box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
      overflow: hidden;
    }
    
    .header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 30px 40px;
      text-align: center;
    }
    
    .header h1 {
      font-size: 24px;
      font-weight: 700;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 12px;
    }
    
    .header-icon {
      font-size: 28px;
    }
    
    .form-container {
      padding: 40px;
    }
    
    .user-info {
      background: #f9fafb;
      border-radius: 8px;
      padding: 16px;
      margin-bottom: 24px;
      display: flex;
      align-items: center;
      gap: 12px;
    }
    
    .user-avatar {
      width: 50px;
      height: 50px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-size: 20px;
      font-weight: 700;
    }
    
    .user-details {
      flex: 1;
    }
    
    .user-details strong {
      display: block;
      font-size: 16px;
      color: #1f2937;
      margin-bottom: 4px;
    }
    
    .user-details span {
      font-size: 13px;
      color: #6b7280;
    }
    
    .form-group {
      margin-bottom: 24px;
    }
    
    label {
      display: block;
      margin-bottom: 8px;
      font-weight: 600;
      color: #374151;
      font-size: 14px;
    }
    
    label span {
      color: #ef4444;
    }
    
    input, select {
      width: 100%;
      padding: 12px 16px;
      border: 2px solid #e5e7eb;
      border-radius: 8px;
      font-size: 14px;
      font-family: inherit;
      transition: all 0.3s ease;
    }
    
    input:focus, select:focus {
      outline: none;
      border-color: #667eea;
      box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }
    
    input[readonly] {
      background: #f3f4f6;
      color: #6b7280;
      cursor: not-allowed;
    }
    
    select {
      cursor: pointer;
      background-color: white;
    }
    
    .form-actions {
      display: flex;
      gap: 12px;
      margin-top: 32px;
    }
    
    .btn {
      flex: 1;
      padding: 14px 24px;
      border: none;
      border-radius: 8px;
      font-size: 15px;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
    }
    
    .btn-primary {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
    }
    
    .btn-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 16px rgba(102, 126, 234, 0.3);
    }
    
    .btn-secondary {
      background: #f3f4f6;
      color: #374151;
    }
    
    .btn-secondary:hover {
      background: #e5e7eb;
    }
    
    .info-note {
      background: #fef3c7;
      border-left: 4px solid #f59e0b;
      padding: 12px;
      border-radius: 6px;
      font-size: 13px;
      color: #92400e;
      margin-bottom: 24px;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>
        <span class="header-icon">✏️</span>
        Chỉnh sửa tài khoản
      </h1>
    </div>
    
    <div class="form-container">
      <div class="user-info">
        <div class="user-avatar">
          ${user.username.substring(0,1).toUpperCase()}
        </div>
        <div class="user-details">
          <strong>${user.username}</strong>
          <span>ID: #${user.userId} | ${user.role}</span>
        </div>
      </div>
      
      <div class="info-note">
        ℹ️ Không thể thay đổi tên đăng nhập. Để đổi mật khẩu, vui lòng sử dụng chức năng riêng.
      </div>
      
      <form action="${pageContext.request.contextPath}/admin/users/edit" method="post">
        <input type="hidden" name="userId" value="${user.userId}">
        
        <div class="form-group">
          <label>Tên đăng nhập</label>
          <input type="text" value="${user.username}" readonly>
        </div>
        
        <div class="form-group">
          <label>Email</label>
          <input type="email" name="email" value="${user.email}" placeholder="example@hospital.com">
        </div>
        
        <div class="form-group">
          <label>Số điện thoại</label>
          <input type="tel" name="phone" value="${user.phone}" placeholder="0123456789">
        </div>
        
        <div class="form-group">
          <label>Vai trò <span>*</span></label>
          <select name="role" required>
            <c:set var="r" value="${user.role}" />
            <option value="Admin" ${r=='Admin'?'selected':''}>👑 Admin - Quản trị viên</option>
            <option value="Doctor" ${r=='Doctor'?'selected':''}>👨‍⚕️ Doctor - Bác sĩ</option>
            <option value="Pharmacist" ${r=='Pharmacist'?'selected':''}>💊 Pharmacist - Dược sĩ</option>
            <option value="Manager" ${r=='Manager'?'selected':''}>📊 Manager - Quản lý</option>
            <option value="Auditor" ${r=='Auditor'?'selected':''}>🔍 Auditor - Kiểm toán</option>
            <option value="Supplier" ${r=='Supplier'?'selected':''}>🚚 Supplier - Nhà cung cấp</option>
          </select>
        </div>
        
        <div class="form-actions">
          <button type="submit" class="btn btn-primary">
            ✓ Cập nhật
          </button>
          <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary">
            ← Quay lại
          </a>
        </div>
      </form>
    </div>
  </div>
</body>
</html>