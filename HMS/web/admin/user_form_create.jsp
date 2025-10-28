<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Tạo tài khoản - Hệ thống quản lý kho bệnh viện</title>
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
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
      overflow: hidden;
      border: 1px solid #e5e7eb;
    }
    
    .header {
      background: white;
      color: #1f2937;
      padding: 30px 40px;
      text-align: center;
      border-bottom: 1px solid #e5e7eb;
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
      border-color: #3b82f6;
      box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
    }
    
    input::placeholder {
      color: #9ca3af;
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
      background: #3b82f6;
      color: white;
    }
    
    .btn-primary:hover {
      background: #2563eb;
      transform: translateY(-2px);
      box-shadow: 0 8px 16px rgba(59, 130, 246, 0.3);
    }
    
    .btn-secondary {
      background: #f3f4f6;
      color: #374151;
      border: 1px solid #e5e7eb;
    }
    
    .btn-secondary:hover {
      background: #e5e7eb;
    }
    
    .info-box {
      background: #eff6ff;
      border-left: 4px solid #3b82f6;
      padding: 16px;
      border-radius: 8px;
      margin-bottom: 24px;
      font-size: 14px;
      color: #1e40af;
    }
    
    .password-hint {
      font-size: 12px;
      color: #6b7280;
      margin-top: 6px;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>
        <span class="header-icon">➕</span>
        Tạo tài khoản mới
      </h1>
    </div>
    
    <div class="form-container">
      <div class="info-box">
        💡 Tài khoản mới sẽ được kích hoạt tự động sau khi tạo
      </div>
      
      <form action="${pageContext.request.contextPath}/admin-dashboard/create" method="post">
        <div class="form-group">
          <label>Tên đăng nhập <span>*</span></label>
          <input type="text" name="username" placeholder="Nhập tên đăng nhập" required minlength="3">
        </div>
        
        <div class="form-group">
          <label>Mật khẩu <span>*</span></label>
          <input type="password" name="password" placeholder="Nhập mật khẩu" required minlength="6">
          <div class="password-hint">⚠️ Mật khẩu phải có ít nhất 6 ký tự</div>
        </div>
        
        <div class="form-group">
          <label>Email</label>
          <input type="email" name="email" placeholder="example@hospital.com">
        </div>
        
        <div class="form-group">
          <label>Số điện thoại</label>
          <input type="tel" name="phone" placeholder="0123456789">
        </div>
        
        <div class="form-group">
          <label>Vai trò <span>*</span></label>
          <select name="role" required>
            <option value="">-- Chọn vai trò --</option>
            <option value="Admin">👑 Admin - Quản trị viên</option>
            <option value="Doctor">👨‍⚕️ Doctor - Bác sĩ</option>
            <option value="Pharmacist">💊 Pharmacist - Dược sĩ</option>
            <option value="Manager">📊 Manager - Quản lý</option>
            <option value="Auditor">🔍 Auditor - Kiểm toán</option>
            <option value="Supplier">🚚 Supplier - Nhà cung cấp</option>
          </select>
        </div>
        
        <div class="form-actions">
          <button type="submit" class="btn btn-primary">
            ✓ Tạo tài khoản
          </button>
          <a href="${pageContext.request.contextPath}/admin-dashboard" class="btn btn-secondary">
            ← Quay lại
          </a>
        </div>
      </form>
    </div>
  </div>
</body>
</html>