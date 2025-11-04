<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cấu hình hệ thống - Hệ thống quản lý kho bệnh viện</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
                background: #f3f4f6;
                min-height: 100vh;
                padding: 20px;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                background: #fff;
                border-radius: 16px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
                overflow: hidden;
            }

            .header {
                background: #ffffff;
                color: #1f2937;
                padding: 30px 40px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                border-bottom: 2px solid #e5e7eb;
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
                background: #f0f9ff;
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
                background: #3b82f6;
                color: white;
            }

            .btn-primary:hover {
                background: #2563eb;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
            }

            .btn-success {
                background: #10b981;
                color: white;
            }

            .btn-success:hover {
                background: #059669;
            }

            .btn-danger {
                background: #ef4444;
                color: white;
                padding: 6px 12px;
                font-size: 13px;
            }

            .btn-danger:hover {
                background: #dc2626;
            }

            .btn-add {
                background: #3b82f6;
                color: white;
            }

            .btn-add:hover {
                background: #2563eb;
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

            .info-box {
                background: #f0f9ff;
                border: 1px solid #bae6fd;
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 30px;
            }

            .info-box h3 {
                color: #075985;
                font-size: 16px;
                margin-bottom: 12px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .info-box p {
                color: #0c4a6e;
                font-size: 14px;
                line-height: 1.6;
            }

            .config-section {
                background: #f9fafb;
                border: 1px solid #e5e7eb;
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
                border-bottom: 2px solid #e5e7eb;
            }

            .section-header h2 {
                font-size: 18px;
                font-weight: 600;
                color: #1f2937;
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
                border: 1px solid #e5e7eb;
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
                color: #374151;
                font-size: 14px;
            }

            .critical-badge {
                background: #fef3c7;
                color: #92400e;
                padding: 4px 10px;
                border-radius: 12px;
                font-size: 11px;
                font-weight: 600;
                display: inline-block;
                margin-top: 4px;
            }

            .form-control {
                width: 100%;
                padding: 10px 14px;
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

            .config-actions {
                display: flex;
                gap: 8px;
            }

            .add-config-form {
                background: white;
                border: 2px dashed #d1d5db;
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
                color: #374151;
            }

            .timestamp {
                font-size: 12px;
                color: #6b7280;
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

            .save-all-section {
                background: #10b981;
                color: white;
                padding: 20px;
                border-radius: 12px;
                margin-top: 30px;
                text-align: center;
            }

            .save-all-section p {
                margin-bottom: 16px;
                font-size: 14px;
                opacity: 0.9;
            }

            @media (max-width: 768px) {
                .config-item,
                .form-row {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>
                    <span class="header-icon">⚙️</span>
                    Cấu hình hệ thống
                </h1>
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin-dashboard">
                    ← Quay lại Dashboard
                </a>
            </div>

            <div class="content">
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

                <div class="info-box">
                    <h3>📋 Thông tin quan trọng</h3>
                    <p>
                        Trang này cho phép bạn cấu hình các tham số hệ thống như ngưỡng tồn kho thấp, 
                        số lần đăng nhập sai tối đa, thời gian cách ly, v.v. 
                        <strong>Vui lòng cẩn thận khi thay đổi các cấu hình này.</strong>
                    </p>
                </div>

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

                        <div id="addConfigForm" class="add-config-form">
                            <h3 style="margin-bottom: 16px; color: #1f2937;">➕ Thêm cấu hình mới</h3>
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

                    <div class="save-all-section">
                        <p>💾 Lưu tất cả các thay đổi cấu hình</p>
                        <button type="submit" class="btn btn-success" style="font-size: 16px; padding: 14px 32px;">
                            💾 Lưu tất cả
                        </button>
                    </div>
                </form>
            </div>
        </div>

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
