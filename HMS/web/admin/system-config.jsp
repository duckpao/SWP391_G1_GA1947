<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cấu hình hệ thống - Pharmacy Warehouse Management System</title>
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

            .btn-success {
                background: #28a745;
                color: white;
                border: 1px solid #218838;
            }

            .btn-success:hover {
                background: #218838;
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(40, 167, 69, 0.2);
            }

            .btn-danger {
                background: #dc3545;
                color: white;
                padding: 8px 16px;
                font-size: 13px;
                border: 1px solid #c82333;
            }

            .btn-danger:hover {
                background: #c82333;
            }

            .btn-add {
                background: #495057;
                color: white;
                border: 1px solid #343a40;
            }

            .btn-add:hover {
                background: #343a40;
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
                padding: 16px 20px;
                margin-bottom: 24px;
                border-radius: 8px;
                display: flex;
                align-items: center;
                gap: 12px;
                font-size: 14px;
                font-weight: 500;
                border: 1px solid;
            }

            .alert-success {
                background: #d4edda;
                border-color: #c3e6cb;
                color: #155724;
            }

            .alert-error {
                background: #f8d7da;
                border-color: #f5c6cb;
                color: #721c24;
            }

            .info-box {
                background: #e7f1ff;
                border: 1px solid #b6d4fe;
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 30px;
            }

            .info-box h3 {
                color: #084298;
                font-size: 16px;
                margin-bottom: 12px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .info-box p {
                color: #052c65;
                font-size: 14px;
                line-height: 1.6;
            }

            .config-section {
                background: #f8f9fa;
                border: 1px solid #dee2e6;
                border-radius: 12px;
                padding: 24px;
                margin-bottom: 24px;
            }

            .section-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                padding-bottom: 16px;
                border-bottom: 2px solid #dee2e6;
            }

            .section-header h2 {
                font-size: 18px;
                font-weight: 600;
                color: #2c3e50;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .config-grid {
                display: grid;
                gap: 16px;
            }

            .config-item {
                background: white;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                padding: 20px;
                display: grid;
                grid-template-columns: 250px 1fr auto;
                gap: 20px;
                align-items: center;
                transition: all 0.2s;
            }

            .config-item:hover {
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            }

            .config-key {
                font-weight: 600;
                color: #495057;
                font-size: 14px;
            }

            .critical-badge {
                background: #fff3cd;
                color: #664d03;
                padding: 4px 10px;
                border-radius: 12px;
                font-size: 11px;
                font-weight: 600;
                display: inline-block;
                margin-top: 4px;
                border: 1px solid #ffecb5;
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

            .config-actions {
                display: flex;
                gap: 8px;
            }

            .add-config-form {
                background: white;
                border: 2px dashed #dee2e6;
                border-radius: 8px;
                padding: 20px;
                margin-top: 16px;
                display: none;
            }

            .add-config-form.active {
                display: block;
            }

            .form-row {
                display: grid;
                grid-template-columns: 250px 1fr auto;
                gap: 16px;
                align-items: end;
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

            .timestamp {
                font-size: 12px;
                color: #6c757d;
                font-style: italic;
                margin-top: 4px;
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
                border: 1px solid #dee2e6;
            }

            .modal-header {
                font-size: 20px;
                font-weight: 700;
                margin-bottom: 16px;
                color: #2c3e50;
            }

            .modal-body {
                color: #6c757d;
                margin-bottom: 24px;
                line-height: 1.6;
            }

            .modal-actions {
                display: flex;
                gap: 12px;
                justify-content: flex-end;
            }

            .save-all-section {
                background: #d4edda;
                border: 1px solid #c3e6cb;
                color: #155724;
                padding: 20px;
                border-radius: 12px;
                margin-top: 30px;
                text-align: center;
            }

            .save-all-section p {
                margin-bottom: 16px;
                font-size: 14px;
                font-weight: 500;
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

                .content {
                    padding: 20px;
                }

                .config-item,
                .form-row {
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
                    <a class="sidebar-item sidebar-item-primary" href="${pageContext.request.contextPath}/admin-dashboard/config">
                        ⚙️ Cấu hình
                    </a>
                    <a class="sidebar-item" href="${pageContext.request.contextPath}/admin/permissions">
                        🔐 Phân quyền
                    </a>
                    <a class="sidebar-item" href="${pageContext.request.contextPath}/admin-dashboard/create">
                        ➕ Tạo tài khoản
                    </a>
                    <a class="sidebar-item sidebar-item-logout" href="${pageContext.request.contextPath}/logout">
                        🚪 Logout
                    </a>
                </div>
            </div>

            <!-- Main content -->
            <div class="main-content">
                <div class="container">
                    <div class="header">
                        <h1>
                            <span class="header-icon">⚙️</span>
                            Cấu hình hệ thống
                        </h1>
                    </div>

                    <div class="content">
                        <!-- Error/Success messages -->
                        <c:if test="${not empty param.success}">
                            <div class="alert alert-success">
                                <strong>✓</strong>
                                <c:choose>
                                    <c:when test="${param.success == 'updated'}">Cập nhật cấu hình thành công!</c:when>
                                    <c:when test="${param.success == 'added'}">Thêm cấu hình mới thành công!</c:when>
                                    <c:when test="${param.success == 'deleted'}">Xóa cấu hình thành công!</c:when>
                                    <c:otherwise>${param.success}</c:otherwise>
                                </c:choose>
                            </div>
                        </c:if>

                        <c:if test="${not empty param.error}">
                            <div class="alert alert-error">
                                <strong>⚠</strong>
                                <c:choose>
                                    <c:when test="${param.error == 'update_failed'}">Cập nhật cấu hình thất bại!</c:when>
                                    <c:when test="${param.error == 'add_failed'}">Thêm cấu hình thất bại!</c:when>
                                    <c:when test="${param.error == 'delete_failed'}">Xóa cấu hình thất bại!</c:when>
                                    <c:when test="${param.error == 'key_exists'}">Key cấu hình đã tồn tại!</c:when>
                                    <c:when test="${param.error == 'empty_key'}">Key cấu hình không được để trống!</c:when>
                                    <c:when test="${param.error == 'cannot_delete_critical'}">Không thể xóa cấu hình quan trọng!</c:when>
                                    <c:otherwise>${param.error}</c:otherwise>
                                </c:choose>
                            </div>
                        </c:if>

                        <!-- Info box -->
                        <div class="info-box">
                            <h3>📋 Thông tin quan trọng</h3>
                            <p>
                                Trang này cho phép bạn cấu hình các tham số hệ thống như ngưỡng tồn kho thấp, 
                                số lần đăng nhập sai tối đa, thời gian cách ly, v.v. 
                                <strong>Vui lòng cẩn thận khi thay đổi các cấu hình này.</strong>
                            </p>
                        </div>

                        <!-- Configuration form -->
                        <form method="post" action="${pageContext.request.contextPath}/admin-dashboard/config">
                            <input type="hidden" name="action" value="update" />

                            <div class="config-section">
                                <div class="section-header">
                                    <h2>🔧 Cấu hình hiện tại</h2>
                                    <button type="button" class="btn btn-add" onclick="toggleAddForm()">
                                        ➕ Thêm cấu hình mới
                                    </button>
                                </div>

                                <div class="config-grid">
                                    <c:forEach var="config" items="${configs}">
                                        <div class="config-item">
                                            <div class="config-key">
                                                <div>${config.configKey}</div>
                                                <c:if test="${config.configKey == 'low_stock_threshold' || 
                                                              config.configKey == 'max_failed_attempts' || 
                                                              config.configKey == 'quarantine_period_days'}">
                                                    <span class="critical-badge">🛡️ Quan trọng</span>
                                                </c:if>
                                                <div class="timestamp">
                                                    <fmt:formatDate value="${config.updatedAt}" pattern="dd/MM/yyyy HH:mm" />
                                                </div>
                                            </div>

                                            <div class="config-value">
                                                <input type="hidden" name="config_key" value="${config.configKey}" />
                                                <input type="text" name="config_value" class="form-control" 
                                                       value="${config.configValue}" />
                                            </div>

                                            <div class="config-actions">
                                                <c:if test="${config.configKey != 'low_stock_threshold' && 
                                                              config.configKey != 'max_failed_attempts' && 
                                                              config.configKey != 'quarantine_period_days'}">
                                                    <button type="button" class="btn btn-danger" 
                                                            onclick="confirmDelete('${config.configKey}')">
                                                        🗑️ Xóa
                                                    </button>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <!-- Add new config form -->
                                <div id="addConfigForm" class="add-config-form">
                                    <h3 style="margin-bottom: 16px; color: #2c3e50;">➕ Thêm cấu hình mới</h3>
                                    <div class="form-row">
                                        <div class="form-group">
                                            <label for="new_key">Config Key</label>
                                            <input type="text" id="new_key" name="new_key" class="form-control" 
                                                   placeholder="vd: session_timeout" />
                                        </div>

                                        <div class="form-group">
                                            <label for="new_value">Config Value</label>
                                            <input type="text" id="new_value" name="new_value" class="form-control" 
                                                   placeholder="vd: 30" />
                                        </div>

                                        <div>
                                            <button type="button" class="btn btn-cancel" onclick="toggleAddForm()">
                                                Hủy
                                            </button>
                                        </div>
                                    </div>
                                    <div style="margin-top: 16px; text-align: right;">
                                        <button type="submit" class="btn btn-success" 
                                                onclick="this.form.action='${pageContext.request.contextPath}/admin-dashboard/config'; 
                                                         this.form.querySelector('[name=action]').value='add';">
                                            ✓ Thêm cấu hình
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <!-- Save all section -->
                            <div class="save-all-section">
                                <p>💾 Lưu tất cả các thay đổi cấu hình</p>
                                <button type="submit" class="btn btn-success" style="font-size: 16px; padding: 14px 32px;">
                                    💾 Lưu tất cả
                                </button>
                            </div>
                        </form>
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
                    Bạn có chắc chắn muốn xóa cấu hình <strong id="deleteConfigKey"></strong>?
                    <br><br>
                    Hành động này không thể hoàn tác!
                </div>
                <div class="modal-actions">
                    <button class="btn btn-cancel" onclick="closeDeleteModal()">Hủy</button>
                    <form id="deleteForm" method="post" style="display: inline;">
                        <input type="hidden" name="action" value="delete" />
                        <input type="hidden" name="key" id="deleteKeyInput" />
                        <button class="btn btn-danger" type="submit">Xác nhận xóa</button>
                    </form>
                </div>
            </div>
        </div>

        <script>
            function toggleAddForm() {
                const form = document.getElementById('addConfigForm');
                form.classList.toggle('active');
            }

            function confirmDelete(configKey) {
                document.getElementById('deleteConfigKey').textContent = configKey;
                document.getElementById('deleteKeyInput').value = configKey;
                document.getElementById('deleteForm').action = '${pageContext.request.contextPath}/admin-dashboard/config';
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
        </script>
    </body>
</html>