<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Tạo tài khoản - Pharmacy Warehouse Management System</title>
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

    /* Modal chuyển dashboard */
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
    
    .main-content {
      flex: 1;
      padding: 30px;
      overflow-y: auto;
      background: #ffffff;
    }
    
    .container {
      max-width: 800px;
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
      border: 2px solid #dee2e6;
      border-radius: 8px;
      font-size: 14px;
      font-family: inherit;
      transition: all 0.3s ease;
      background: white;
      color: #2c3e50;
    }
    
    input:focus, select:focus {
      outline: none;
      border-color: #6c757d;
      box-shadow: 0 0 0 3px rgba(108, 117, 125, 0.1);
    }
    
    input::placeholder {
      color: #9ca3af;
    }
    
    select {
      cursor: pointer;
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
      border: 1px solid #dee2e6;
    }
    
    .btn-secondary:hover {
      background: #dee2e6;
    }
    
    .info-box {
      background: #e7f1ff;
      border-left: 4px solid #495057;
      padding: 16px;
      border-radius: 8px;
      margin-bottom: 24px;
      font-size: 14px;
      color: #084298;
    }
    
    .password-hint {
      font-size: 12px;
      color: #6b7280;
      margin-top: 6px;
    }

    .alert {
      padding: 12px 16px;
      border-radius: 8px;
      margin-bottom: 20px;
      font-size: 14px;
      font-weight: 500;
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

      .form-container {
        padding: 20px;
      }
    }
  </style>
</head>
<body>
  <!-- Include header.jsp -->
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
          Dashboard
        </a>
        <a class="sidebar-item" href="${pageContext.request.contextPath}/user-reports/generate">
          📊 Báo cáo
        </a>
        <a class="sidebar-item" href="${pageContext.request.contextPath}/admin-dashboard/config">
          ⚙️ Cấu hình
        </a>
        <a class="sidebar-item" href="${pageContext.request.contextPath}/admin-dashboard/notifications">
          🛎️ Gửi Thông báo
        </a>
        <a class="sidebar-item sidebar-item-primary" href="${pageContext.request.contextPath}/admin-dashboard/create">
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
            <span class="header-icon">➕</span>
            Tạo tài khoản mới
          </h1>
        </div>
        
        <div class="form-container">
          <div class="info-box">
            💡 Tài khoản mới sẽ được kích hoạt tự động sau khi tạo
          </div>

          <%-- Thông báo lỗi hoặc thành công --%>
          <c:if test="${not empty error}">
            <div class="alert alert-error">
              ⚠️ ${error}
            </div>
          </c:if>

          <c:if test="${not empty success}">
            <div class="alert alert-success">
              ✅ ${success}
            </div>
          </c:if>
          
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
    </div>
  </div>

  <!-- Modal chuyển dashboard -->
  <div id="switchDashboardModal" class="modal">
    <div class="modal-content" style="max-width:600px;">
      <div class="modal-header">🔁 Chuyển Dashboard</div>
      <div class="modal-body">
        <p>Chọn dashboard bạn muốn truy cập:</p>
        <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:12px;margin-top:16px;">
          <a href="doctor-dashboard" style="background:#495057;color:#ffffff;padding:12px;border-radius:8px;text-align:center;text-decoration:none;font-weight:600;">Doctor</a>
          <a href="view-medicine?dashboard=pharmacist" style="background:#495057;color:#ffffff;padding:12px;border-radius:8px;text-align:center;text-decoration:none;font-weight:600;">Pharmacist</a>
          <a href="manager-dashboard" style="background:#495057;color:#ffffff;padding:12px;border-radius:8px;text-align:center;text-decoration:none;font-weight:600;">Manager</a>
          <a href="auditor-dashboard" style="background:#495057;color:#ffffff;padding:12px;border-radius:8px;text-align:center;text-decoration:none;font-weight:600;">Auditor</a>
        </div>
      </div>
      <div class="modal-actions" style="justify-content:center;margin-top:20px;">
        <button onclick="closeSwitchDashboardModal()" style="background:#f1f3f5;color:#212529;padding:10px 20px;border:none;border-radius:6px;font-weight:600;cursor:pointer;">Đóng</button>
      </div>
    </div>
  </div>
  
  <!-- Include footer.jsp -->
  <%@ include file="footer.jsp" %>

  <script>
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