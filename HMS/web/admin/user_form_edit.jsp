<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chỉnh sửa tài khoản - Hệ thống quản lý kho bệnh viện</title>
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
            }
            .page-wrapper {
                display: flex;
                flex-direction: column;
                flex: 1;
            }
            .main-content {
                flex: 1;
                padding: 40px 20px;
                background: #ffffff;
            }
            .container {
                max-width: 600px;
                margin: 0 auto;
                background: white;
                border-radius: 16px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.07);
                overflow: hidden;
            }
            .header {
                background: white;
                border-bottom: 4px solid #495057;
                color: #1f2937;
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
                background: #f3f4f6;
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
                background: linear-gradient(135deg, #495057 0%, #343a40 100%);
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
                border-color: #495057;
                box-shadow: 0 0 0 3px rgba(73, 80, 87, 0.1);
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
            /* Updated button colors to #495057 */
            .btn-primary {
                background: #495057;
                color: white;
            }
            .btn-primary:hover {
                background: #343a40;
                transform: translateY(-2px);
                box-shadow: 0 8px 16px rgba(73, 80, 87, 0.3);
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
            .password-section {
                background: #f8f9fa;
                border: 2px solid #e5e7eb;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 24px;
            }
            .password-section h3 {
                font-size: 16px;
                color: #495057;
                margin-bottom: 16px;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .password-toggle {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 16px;
            }
            .password-toggle input[type="checkbox"] {
                width: auto;
                cursor: pointer;
            }
            .password-toggle label {
                margin: 0;
                font-weight: 500;
                font-size: 14px;
                cursor: pointer;
            }
            .password-fields {
                display: none;
            }
            .password-fields.active {
                display: block;
            }
            .password-hint {
                font-size: 12px;
                color: #6b7280;
                margin-top: 4px;
            }
            .error-message {
                background: #fee2e2;
                border: 1px solid #fca5a5;
                border-radius: 6px;
                padding: 12px;
                color: #991b1b;
                font-size: 13px;
                margin-bottom: 20px;
            }
            .supplier-fields {
                display: none;
            }
            .supplier-fields.active {
                display: block;
            }
        </style>
    </head>
    <body>
    <!-- Include header.jsp -->
    <%@ include file="header.jsp" %>
    <div class="page-wrapper">
        <div class="main-content">
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
                    <%-- Hiển thị lỗi nếu có --%>
                    <c:if test="${not empty error}">
                        <div class="error-message">
                            ⚠️ ${error}
                        </div>
                    </c:if>
                    <%-- Hiển thị thông báo thành công nếu có --%>
                    <c:if test="${not empty success}">
                        <div style="
                            background:#dcfce7;
                            color:#166534;
                            padding:12px 16px;
                            border-radius:8px;
                            border:1px solid #bbf7d0;
                            margin-bottom:20px;
                            font-size:14px;
                            font-weight:500;">
                            ✅ ${success}
                        </div>
                    </c:if>
                    <div class="info-note">
                        ℹ️ Không thể thay đổi tên đăng nhập. Mật khẩu là tùy chọn - chỉ điền nếu muốn thay đổi.
                    </div>
                    <form action="${pageContext.request.contextPath}/admin-dashboard/edit" method="post">
                        <input type="hidden" name="userId" value="${user.userId}">
                        <input type="hidden" name="username" value="${user.username}">
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
                            <select name="role" id="roleSelect" required>
                                <c:set var="r" value="${user.role}" />
                                <option value="Admin" ${r=='Admin'?'selected':''}>👑 Admin - Quản trị viên</option>
                                <option value="Doctor" ${r=='Doctor'?'selected':''}>👨‍⚕️ Doctor - Bác sĩ</option>
                                <option value="Pharmacist" ${r=='Pharmacist'?'selected':''}>💊 Pharmacist - Dược sĩ</option>
                                <option value="Manager" ${r=='Manager'?'selected':''}>📊 Manager - Quản lý</option>
                                <option value="Auditor" ${r=='Auditor'?'selected':''}>🔍 Auditor - Kiểm toán</option>
                                <option value="ProcurementOfficer" ${r=='ProcurementOfficer'?'selected':''}>📦 Procurement Officer</option>
                                <option value="Supplier" ${r=='Supplier'?'selected':''}>🚚 Supplier - Nhà cung cấp</option>
                            </select>
                        </div>
                        <!-- Supplier Fields -->
                        <div class="supplier-fields ${user.role == 'Supplier' ? 'active' : ''}" id="supplierFields">
                            <div class="form-group">
                                <label>Tên Công Ty <span>*</span></label>
                                <input type="text" name="companyName" id="companyName" value="${supplier.name}" placeholder="Nhập tên công ty" ${user.role == 'Supplier' ? 'required' : ''}>
                            </div>
                            <div class="form-group">
                                <label>Địa Chỉ</label>
                                <input type="text" name="address" id="address" value="${supplier.address}" placeholder="Nhập địa chỉ công ty">
                            </div>
                        </div>
                        <!-- Password Section -->
                        <div class="password-section">
                            <h3>🔐 Đổi mật khẩu</h3>
                           
                            <div class="password-toggle">
                                <input type="checkbox" id="changePassword" onchange="togglePasswordFields()">
                                <label for="changePassword">Tôi muốn đổi mật khẩu</label>
                            </div>
                            <div class="password-fields" id="passwordFields">
                                <div class="form-group">
                                    <label>Mật khẩu mới</label>
                                    <input type="password" name="newPassword" id="newPassword"
                                           placeholder="Nhập mật khẩu mới (tối thiểu 6 ký tự)">
                                    <div class="password-hint">
                                        💡 Mật khẩu nên có ít nhất 6 ký tự, bao gồm chữ và số
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label>Xác nhận mật khẩu mới</label>
                                    <input type="password" name="confirmPassword" id="confirmPassword"
                                           placeholder="Nhập lại mật khẩu mới">
                                </div>
                            </div>
                        </div>
                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">
                                ✓ Cập nhật
                            </button>
                            <a href="${pageContext.request.contextPath}/admin-dashboard" class="btn btn-secondary">
                                ← Quay lại
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <!-- Include footer.jsp -->
        <%@ include file="footer.jsp" %>
    </div>
    <script>
        function togglePasswordFields() {
            const checkbox = document.getElementById('changePassword');
            const fields = document.getElementById('passwordFields');
            const newPassword = document.getElementById('newPassword');
            const confirmPassword = document.getElementById('confirmPassword');
           
            if (checkbox.checked) {
                fields.classList.add('active');
                newPassword.required = true;
                confirmPassword.required = true;
            } else {
                fields.classList.remove('active');
                newPassword.required = false;
                confirmPassword.required = false;
                newPassword.value = '';
                confirmPassword.value = '';
            }
        }
        function toggleSupplierFields() {
            const roleSelect = document.getElementById('roleSelect');
            const fields = document.getElementById('supplierFields');
            const companyName = document.getElementById('companyName');
           
            if (roleSelect.value === 'Supplier') {
                fields.classList.add('active');
                companyName.required = true;
            } else {
                fields.classList.remove('active');
                companyName.required = false;
            }
        }
        // Validate password match before submit
        document.querySelector('form').addEventListener('submit', function(e) {
            const changePassword = document.getElementById('changePassword');
           
            if (changePassword.checked) {
                const newPassword = document.getElementById('newPassword').value;
                const confirmPassword = document.getElementById('confirmPassword').value;
               
                if (newPassword !== confirmPassword) {
                    e.preventDefault();
                    alert('⚠️ Mật khẩu xác nhận không khớp!');
                    return false;
                }
               
                if (newPassword.length < 6) {
                    e.preventDefault();
                    alert('⚠️ Mật khẩu phải có ít nhất 6 ký tự!');
                    return false;
                }
            }
            const roleSelect = document.getElementById('roleSelect');
            if (roleSelect.value === 'Supplier') {
                const companyName = document.getElementById('companyName').value.trim();
                if (companyName === '') {
                    e.preventDefault();
                    alert('⚠️ Tên công ty không được để trống!');
                    return false;
                }
            }
        });
        // Initial call to set supplier fields visibility
        toggleSupplierFields();
        // Add event listener for role change
        document.getElementById('roleSelect').addEventListener('change', toggleSupplierFields);
    </script>
</body>
</html>