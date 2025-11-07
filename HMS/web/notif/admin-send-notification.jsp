<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gửi Thông Báo - Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
        .modal-custom {
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

        .modal-custom.active {
            display: flex;
        }

        .modal-content-custom {
            background: #fff;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.25);
            animation: slideDown 0.25s ease;
        }

        .modal-header-custom {
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 16px;
            color: #2c3e50;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .modal-body-custom p {
            font-size: 15px;
            color: #495057;
            margin-bottom: 12px;
        }

        .modal-actions-custom {
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

        /* Main content layout */
        .main-content {
            flex: 1;
            padding: 30px;
            overflow-y: auto;
            background: #ffffff;
        }

        .container-custom {
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

        .content {
            padding: 40px;
        }

        .form-section {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 30px;
            border: 1px solid #e9ecef;
        }

        .preview-section {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            border: 2px dashed #dee2e6;
        }

        .notification-preview {
            background: white;
            border-radius: 8px;
            padding: 20px;
            border-left: 4px solid #0d6efd;
        }

        .icon-selector {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .icon-option {
            width: 60px;
            height: 60px;
            border: 2px solid #dee2e6;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s;
        }

        .icon-option:hover, .icon-option.active {
            border-color: #0d6efd;
            background: #e7f3ff;
        }

        .priority-badge {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 600;
            margin-right: 10px;
        }

        .btn-back {
            padding: 10px 20px;
            background: #6c757d;
            color: white;
            border: 1px solid #5a6268;
            border-radius: 8px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }

        .btn-back:hover {
            background: #5a6268;
            color: white;
            transform: translateY(-1px);
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
    <%@ include file="/admin/header.jsp" %>

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
                <a class="sidebar-item sidebar-item-primary" href="${pageContext.request.contextPath}/admin-dashboard/notifications">
                    🛎️ Gửi Thông báo
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
            <div class="container-custom">
                <div class="header">
                    <h1>
                        <span class="header-icon">📧</span>
                        Gửi Thông Báo
                    </h1>
                </div>

                <div class="content">
                    <div class="row">
                        <!-- Form Section -->
                        <div class="col-lg-7">
                            <div class="form-section">
                                <h4 class="mb-4">Thông tin thông báo</h4>
                                <form id="notificationForm">
                                    
                                    <!-- Người nhận -->
                                    <div class="mb-4">
                                        <label class="form-label fw-bold">
                                            <i class="fas fa-users me-2"></i>Người nhận
                                        </label>
                                        <select class="form-select" name="receiverId" id="receiverId" required>
                                            <option value="all" selected>Tất cả người dùng (Broadcast)</option>
                                            <optgroup label="Người dùng cụ thể">
                                                <c:forEach var="user" items="${users}">
                                                    <option value="${user.getUserId()}">
                                                        ${user.getUsername()} - ${user.getRole()} 
                                                        (${user.getEmail()})
                                                    </option>
                                                </c:forEach>
                                            </optgroup>
                                        </select>
                                    </div>

                                    <!-- Tiêu đề -->
                                    <div class="mb-4">
                                        <label class="form-label fw-bold">
                                            <i class="fas fa-heading me-2"></i>Tiêu đề *
                                        </label>
                                        <input type="text" 
                                               class="form-control" 
                                               name="title" 
                                               id="title"
                                               placeholder="Nhập tiêu đề thông báo" 
                                               required 
                                               maxlength="200">
                                    </div>

                                    <!-- Nội dung -->
                                    <div class="mb-4">
                                        <label class="form-label fw-bold">
                                            <i class="fas fa-align-left me-2"></i>Nội dung *
                                        </label>
                                        <textarea class="form-control" 
                                                  name="message" 
                                                  id="message"
                                                  rows="5" 
                                                  placeholder="Nhập nội dung thông báo" 
                                                  required></textarea>
                                    </div>

                                    <!-- Loại thông báo -->
                                    <div class="mb-4">
                                        <label class="form-label fw-bold">
                                            <i class="fas fa-tag me-2"></i>Loại thông báo
                                        </label>
                                        <div class="icon-selector">
                                            <div class="icon-option active" data-type="info" onclick="selectType('info')">
                                                <i class="fas fa-info-circle fa-2x text-primary"></i>
                                            </div>
                                            <div class="icon-option" data-type="warning" onclick="selectType('warning')">
                                                <i class="fas fa-exclamation-triangle fa-2x text-warning"></i>
                                            </div>
                                            <div class="icon-option" data-type="success" onclick="selectType('success')">
                                                <i class="fas fa-check-circle fa-2x text-success"></i>
                                            </div>
                                            <div class="icon-option" data-type="error" onclick="selectType('error')">
                                                <i class="fas fa-times-circle fa-2x text-danger"></i>
                                            </div>
                                            <div class="icon-option" data-type="alert" onclick="selectType('alert')">
                                                <i class="fas fa-bell fa-2x text-danger"></i>
                                            </div>
                                        </div>
                                        <input type="hidden" name="notificationType" id="notificationType" value="info">
                                    </div>

                                    <!-- Mức độ ưu tiên -->
                                    <div class="mb-4">
                                        <label class="form-label fw-bold">
                                            <i class="fas fa-flag me-2"></i>Mức độ ưu tiên
                                        </label>
                                        <select class="form-select" name="priority" id="priority">
                                            <option value="low">Thấp</option>
                                            <option value="normal" selected>Bình thường</option>
                                            <option value="high">Cao</option>
                                            <option value="urgent">Khẩn cấp</option>
                                        </select>
                                    </div>

                                    <!-- Link (tùy chọn) -->
                                    <div class="mb-4">
                                        <label class="form-label fw-bold">
                                            <i class="fas fa-link me-2"></i>Link đính kèm (tùy chọn)
                                        </label>
                                        <input type="url" 
                                               class="form-control" 
                                               name="linkUrl" 
                                               id="linkUrl"
                                               placeholder="https://example.com">
                                    </div>

                                    <!-- Buttons -->
                                    <div class="d-flex gap-2">
                                        <button type="submit" class="btn btn-primary flex-grow-1">
                                            <i class="fas fa-paper-plane me-2"></i>Gửi thông báo
                                        </button>
                                        <button type="reset" class="btn btn-outline-secondary" onclick="resetForm()">
                                            <i class="fas fa-redo me-2"></i>Đặt lại
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Preview Section -->
                        <div class="col-lg-5">
                            <div class="preview-section sticky-top" style="top: 20px;">
                                <h4 class="mb-3">
                                    <i class="fas fa-eye me-2"></i>Xem trước
                                </h4>
                                <div class="notification-preview" id="notificationPreview">
                                    <div class="d-flex align-items-start">
                                        <div class="me-3">
                                            <div style="width: 50px; height: 50px; background: #e7f3ff; border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                                                <i class="fas fa-info-circle fa-2x text-primary"></i>
                                            </div>
                                        </div>
                                        <div class="flex-grow-1">
                                            <h5 class="mb-2 text-muted">Tiêu đề thông báo</h5>
                                            <p class="mb-3 text-muted">Nội dung thông báo sẽ hiển thị ở đây...</p>
                                            <div class="mb-2">
                                                <span class="priority-badge" style="background: #e9ecef; color: #495057;">
                                                    Bình thường
                                                </span>
                                                <span class="badge bg-secondary">Tất cả người dùng</span>
                                            </div>
                                            <small class="text-muted">
                                                <i class="fas fa-clock me-1"></i>
                                                Vừa xong
                                            </small>
                                        </div>
                                    </div>
                                </div>

                                <div class="alert alert-info mt-4">
                                    <i class="fas fa-info-circle me-2"></i>
                                    <strong>Lưu ý:</strong> Thông báo sẽ được gửi ngay lập tức.
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer include -->
    <%@ include file="/admin/footer.jsp" %>

    <!-- Modal chuyển Dashboard -->
    <div id="switchDashboardModal" class="modal-custom">
        <div class="modal-content-custom" style="max-width:600px;">
            <div class="modal-header-custom">🔁 Chuyển Dashboard</div>
            <div class="modal-body-custom">
                <p>Chọn dashboard bạn muốn truy cập:</p>
                <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:12px;margin-top:16px;">
                    <a href="doctor-dashboard" style="background:#495057;color:#ffffff;padding:12px;border-radius:8px;text-align:center;text-decoration:none;font-weight:600;">Doctor</a>
                    <a href="view-medicine" style="background:#495057;color:#ffffff;padding:12px;border-radius:8px;text-align:center;text-decoration:none;font-weight:600;">Pharmacist</a>
                    <a href="manager-dashboard" style="background:#495057;color:#ffffff;padding:12px;border-radius:8px;text-align:center;text-decoration:none;font-weight:600;">Manager</a>
                    <a href="auditor-dashboard" style="background:#495057;color:#ffffff;padding:12px;border-radius:8px;text-align:center;text-decoration:none;font-weight:600;">Auditor</a>
                </div>
            </div>
            <div class="modal-actions-custom" style="justify-content:center;margin-top:20px;">
                <button onclick="closeSwitchDashboardModal()" style="background:#f1f3f5;color:#212529;padding:10px 20px;border:none;border-radius:6px;font-weight:600;cursor:pointer;">Đóng</button>
            </div>
        </div>
    </div>

    <!-- Toast Container -->
    <div class="toast-container position-fixed bottom-0 end-0 p-3">
        <div id="successToast" class="toast align-items-center text-white bg-success border-0" role="alert">
            <div class="d-flex">
                <div class="toast-body">
                    <i class="fas fa-check-circle me-2"></i>
                    <span id="toastMessage"></span>
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // ===== NOTIFICATION TYPE SELECTION =====
        function selectType(type) {
            console.log('Selecting type:', type);
            
            // Remove active class from all options
            document.querySelectorAll('.icon-option').forEach(function(el) {
                el.classList.remove('active');
            });
            
            // Add active class to selected option
            const selectedOption = document.querySelector('.icon-option[data-type="' + type + '"]');
            if (selectedOption) {
                selectedOption.classList.add('active');
            }
            
            // Update hidden input value
            document.getElementById('notificationType').value = type;
            
            // Update preview
            updatePreview();
            
            console.log('Type selected:', type);
        }

        // ===== UPDATE PREVIEW =====
        function updatePreview() {
            const title = document.getElementById('title').value || 'Tiêu đề thông báo';
            const message = document.getElementById('message').value || 'Nội dung thông báo sẽ hiển thị ở đây...';
            const type = document.getElementById('notificationType').value;
            const priority = document.getElementById('priority').value;
            const receiverId = document.getElementById('receiverId').value;
            
            // Icon và màu theo loại
            const typeConfig = {
                'info': { icon: 'fa-info-circle', color: '#0d6efd', bgColor: '#e7f3ff', label: 'Thông tin' },
                'warning': { icon: 'fa-exclamation-triangle', color: '#ffc107', bgColor: '#fff3cd', label: 'Cảnh báo' },
                'success': { icon: 'fa-check-circle', color: '#198754', bgColor: '#d1e7dd', label: 'Thành công' },
                'error': { icon: 'fa-times-circle', color: '#dc3545', bgColor: '#f8d7da', label: 'Lỗi' },
                'alert': { icon: 'fa-bell', color: '#dc3545', bgColor: '#f8d7da', label: 'Cảnh báo khẩn' }
            };
            
            const config = typeConfig[type] || typeConfig['info'];
            
            // Priority badge
            const priorityConfig = {
                'low': { label: 'Thấp', bg: '#e9ecef', color: '#495057' },
                'normal': { label: 'Bình thường', bg: '#e9ecef', color: '#495057' },
                'high': { label: 'Cao', bg: '#fff3cd', color: '#856404' },
                'urgent': { label: 'Khẩn cấp', bg: '#f8d7da', color: '#721c24' }
            };
            
            const priorityStyle = priorityConfig[priority] || priorityConfig['normal'];
            
            // Receiver label
            let receiverLabel = 'Tất cả người dùng';
            if (receiverId !== 'all') {
                const selectedOption = document.querySelector('#receiverId option[value="' + receiverId + '"]');
                if (selectedOption) {
                    receiverLabel = selectedOption.text;
                }
            }
            
            // Update preview HTML
            const previewHtml = 
                '<div class="d-flex align-items-start">' +
                    '<div class="me-3">' +
                        '<div style="width: 50px; height: 50px; background: ' + config.bgColor + '; border-radius: 50%; display: flex; align-items: center; justify-content: center;">' +
                            '<i class="fas ' + config.icon + ' fa-2x" style="color: ' + config.color + ';"></i>' +
                        '</div>' +
                    '</div>' +
                    '<div class="flex-grow-1">' +
                        '<h5 class="mb-2" style="color: #2c3e50;">' + escapeHtml(title) + '</h5>' +
                        '<p class="mb-3" style="color: #495057;">' + escapeHtml(message) + '</p>' +
                        '<div class="mb-2">' +
                            '<span class="priority-badge" style="background: ' + priorityStyle.bg + '; color: ' + priorityStyle.color + ';">' +
                                priorityStyle.label +
                            '</span>' +
                            '<span class="badge" style="background: ' + config.bgColor + '; color: ' + config.color + ';">' +
                                config.label +
                            '</span>' +
                            '<span class="badge bg-secondary">' + escapeHtml(receiverLabel) + '</span>' +
                        '</div>' +
                        '<small class="text-muted">' +
                            '<i class="fas fa-clock me-1"></i>' +
                            'Vừa xong' +
                        '</small>' +
                    '</div>' +
                '</div>';
            
            document.getElementById('notificationPreview').innerHTML = previewHtml;
        }

        // ===== ESCAPE HTML =====
        function escapeHtml(text) {
            const map = {
                '&': '&amp;',
                '<': '&lt;',
                '>': '&gt;',
                '"': '&quot;',
                "'": '&#039;'
            };
            return text.replace(/[&<>"']/g, function(m) { return map[m]; });
        }

        // ===== RESET FORM =====
        function resetForm() {
            selectType('info');
            updatePreview();
        }

        // ===== MODAL FUNCTIONS =====
        function openSwitchDashboardModal() {
            document.getElementById("switchDashboardModal").classList.add("active");
        }

        function closeSwitchDashboardModal() {
            document.getElementById("switchDashboardModal").classList.remove("active");
        }

        // ===== SHOW TOAST =====
        function showToast(message) {
            document.getElementById('toastMessage').textContent = message;
            const toast = new bootstrap.Toast(document.getElementById('successToast'));
            toast.show();
        }

        // ===== FORM SUBMISSION =====
        document.getElementById('notificationForm').addEventListener('submit', function(e) {
            e.preventDefault();
           
            console.log('=== Form Submission Started ===');
           
            const title = document.getElementById('title').value.trim();
            const message = document.getElementById('message').value.trim();
            const receiverId = document.getElementById('receiverId').value;
            const notificationType = document.getElementById('notificationType').value;
            const priority = document.getElementById('priority').value;
            const linkUrl = document.getElementById('linkUrl').value.trim();
           
            console.log('Form values:', { title, message, receiverId, notificationType, priority, linkUrl });
           
            if (!title || title === '') {
                alert('Vui lòng nhập tiêu đề!');
                return;
            }
           
            if (!message || message === '') {
                alert('Vui lòng nhập nội dung!');
                return;
            }
           
            const params = new URLSearchParams();
            params.append('title', title);
            params.append('message', message);
            params.append('receiverId', receiverId);
            params.append('notificationType', notificationType);
            params.append('priority', priority);
            params.append('linkUrl', linkUrl);
           
            console.log('Sending POST request...');
           
            fetch('${pageContext.request.contextPath}/notifications?action=send', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params
            })
            .then(function(response) {
                console.log('Response received:', response.status);
                return response.text();
            })
            .then(function(text) {
                console.log('Response text:', text);
               
                try {
                    const data = JSON.parse(text);
                    console.log('Parsed response:', data);
                   
                    if (data.success) {
                        showToast('Thông báo đã được gửi thành công!');
                        setTimeout(function() {
                            document.getElementById('notificationForm').reset();
                            selectType('info');
                        }, 1500);
                    } else {
                        alert('Lỗi: ' + (data.message || 'Unknown error'));
                    }
                } catch (e) {
                    console.error('JSON parse error:', e);
                    alert('Lỗi: Không thể đọc response từ server\n' + text);
                }
            })
            .catch(function(error) {
                console.error('Fetch error:', error);
                alert('Có lỗi xảy ra khi gửi: ' + error.message);
            });
        });

        // ===== EVENT LISTENERS FOR LIVE PREVIEW =====
        document.getElementById('title').addEventListener('input', updatePreview);
        document.getElementById('message').addEventListener('input', updatePreview);
        document.getElementById('priority').addEventListener('change', updatePreview);
        document.getElementById('receiverId').addEventListener('change', updatePreview);

        // ===== MODAL CLOSE ON OUTSIDE CLICK =====
        document.getElementById("switchDashboardModal").addEventListener("click", function (e) {
            if (e.target === this) {
                closeSwitchDashboardModal();
            }
        });

        // ===== INITIALIZE ON PAGE LOAD =====
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Page loaded, initializing preview...');
            updatePreview();
        });
    </script>
</body>
</html>