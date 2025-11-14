<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo lô thuốc | PWMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/sidebar.css" rel="stylesheet">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: #f9fafb;
            font-size: 14px;
            color: #374151;
        }

        .page-wrapper {
            display: flex;
            min-height: calc(100vh - 60px);
        }

        /* Sidebar - GIỐNG VIEW-MEDICINE */
       

        /* Main Content */
        .main {
            flex: 1;
            padding: 30px;
            background-color: #f9fafb;
        }

        /* Page Header - MÀU GIỐNG VIEW-MEDICINE */
        .page-header {
            background: linear-gradient(135deg, #6b7280 0%, #4b5563 100%);
            color: white;
            padding: 20px 24px;
            border-radius: 12px;
            margin-bottom: 24px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        .page-header h4 {
            margin: 0 0 4px 0;
            font-size: 28px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .page-header p {
            margin: 0;
            opacity: 0.85;
            font-size: 14px;
        }

        .info-badge {
            background-color: rgba(255, 255, 255, 0.2);
            color: white;
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
        }

        /* Alert Info */
        .alert-info {
            background: white;
            border: 2px solid #e5e7eb;
            border-left: 4px solid #6b7280;
            color: #374151;
            border-radius: 12px;
            padding: 20px 24px;
            margin-bottom: 24px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }

        .alert-info strong {
            color: #1f2937;
        }

        .alert-info ul {
            margin-bottom: 0;
            margin-top: 8px;
            padding-left: 20px;
        }

        .alert-info ul li {
            margin-bottom: 4px;
            color: #4b5563;
        }

        /* Form Card */
        .form-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            padding: 0;
            border: none;
            overflow: hidden;
        }

        /* Table Header - MÀU GIỐNG VIEW-MEDICINE */
        .table-medicine thead {
            background-color: #f9fafb;
        }

        .table-medicine thead th {
            padding: 14px 16px;
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #6b7280;
            border-bottom: 2px solid #e5e7eb;
            text-align: left;
        }

        .table-medicine tbody tr {
            transition: all 0.2s ease;
            border-bottom: 1px solid #e5e7eb;
        }

        .medicine-row:hover {
            background-color: #f9fafb;
        }

        .table-medicine tbody td {
            padding: 14px 16px;
            font-size: 14px;
            vertical-align: middle;
        }

        /* Form Controls */
        .form-control, .form-select {
            padding: 8px 12px;
            border: 2px solid #e5e7eb;
            border-radius: 6px;
            font-size: 13px;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: #6b7280;
            box-shadow: 0 0 0 3px rgba(107, 114, 128, 0.1);
            outline: none;
        }

        .form-control-sm {
            padding: 6px 10px;
            font-size: 13px;
        }

        /* Buttons - MÀU GIỐNG VIEW-MEDICINE */
        .btn {
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s ease;
            border: none;
        }

        .btn-submit {
            background-color: #6b7280;
            color: white;
        }

        .btn-submit:hover {
            background-color: #4b5563;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(107, 114, 128, 0.3);
        }

        .btn-outline-secondary {
            background-color: white;
            color: #6b7280;
            border: 2px solid #e5e7eb;
        }

        .btn-outline-secondary:hover {
            background-color: #f3f4f6;
            border-color: #6b7280;
            color: #4b5563;
        }

        /* Badges */
        .badge {
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
        }

        .bg-primary {
            background-color: #6b7280 !important;
        }

        /* Checkbox */
        .form-check-input {
            border: 2px solid #d1d5db;
            border-radius: 4px;
            width: 18px;
            height: 18px;
        }

        .form-check-input:checked {
            background-color: #6b7280;
            border-color: #6b7280;
        }

        .form-check-input:focus {
            border-color: #6b7280;
            box-shadow: 0 0 0 3px rgba(107, 114, 128, 0.1);
        }

        /* Alert Messages */
        .alert {
            border-radius: 8px;
            padding: 14px 18px;
            margin-bottom: 20px;
            border: none;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }

        .alert-danger {
            background-color: #fee2e2;
            color: #991b1b;
        }

        .alert-success {
            background-color: #d1fae5;
            color: #065f46;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #9ca3af;
        }

        .empty-state i {
            font-size: 64px;
            color: #d1d5db;
            margin-bottom: 16px;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .page-wrapper {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
            }

            .main {
                padding: 20px;
            }

            .page-header h4 {
                font-size: 22px;
            }
        }
    </style>
</head>

<body>
    <%@ include file="/admin/header.jsp" %>

    <div class="page-wrapper">
        <!-- Sidebar - GIỐNG VIEW-MEDICINE -->
    <%@ include file="/pharmacist/sidebar.jsp" %>

        <!-- Main Content -->
        <div class="main">
            <!-- Page Header -->
            <div class="page-header">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h4>
                            <i class="bi bi-plus-circle-fill"></i> Tạo lô thuốc
                        </h4>
                        <p>Đơn hàng #${order.poId}</p>
                    </div>
                    <div>
                        <span class="info-badge">
                            <i class="bi bi-building"></i> ${order.supplierName}
                        </span>
                    </div>
                </div>
            </div>

            <!-- Error/Success Messages -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill"></i>
                    <strong>Lỗi!</strong> ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty successMessage}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill"></i>
                    <strong>Thành công!</strong> ${successMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Info Alert -->
            <div class="alert alert-info d-flex align-items-start" role="alert">
                <i class="bi bi-info-circle-fill fs-4 me-3 mt-1"></i>
                <div>
                    <strong>Hướng dẫn:</strong> 
                    <ul class="mb-0 mt-2">
                        <li>Số lượng mặc định lấy từ đơn hàng, bạn có thể điều chỉnh nếu cần</li>
                        <li>Tất cả lô mới sẽ có trạng thái <strong>"Quarantined"</strong> (chờ kiểm định)</li>
                        <li>Sau khi kiểm định, lô sẽ được phê duyệt và số lượng tự động cập nhật vào kho</li>
                    </ul>
                </div>
            </div>

            <!-- Form -->
            <div class="form-card">
                <form method="post" action="${pageContext.request.contextPath}/pharmacist/Batch-Add" id="batchForm">
                    <input type="hidden" name="poId" value="${order.poId}" />

                    <!-- Medicines Table -->
                    <div class="table-responsive">
                        <table class="table table-medicine align-middle">
                            <thead>
                                <tr>
                                    <th style="width: 5%;">#</th>
                                    <th style="width: 25%;">Tên thuốc</th>
                                    <th style="width: 15%;">Hàm lượng</th>
                                    <th style="width: 12%;">Dạng thuốc</th>
                                    <th style="width: 12%;">Ngày nhận</th>
                                    <th style="width: 12%;">Hạn sử dụng</th>
                                    <th style="width: 10%;">Số lượng</th>
                                    <th style="width: 9%;">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" 
                                                   id="selectAll" checked>
                                            <label class="form-check-label" for="selectAll">
                                                Chọn
                                            </label>
                                        </div>
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:if test="${empty order.items}">
                                    <tr>
                                        <td colspan="8" class="text-center py-4 text-muted">
                                            <div class="empty-state">
                                                <i class="bi bi-inbox"></i>
                                                <h5>Không có thuốc nào trong đơn hàng này</h5>
                                            </div>
                                        </td>
                                    </tr>
                                </c:if>

                                <c:forEach var="item" items="${order.items}" varStatus="status">
                                    <tr class="medicine-row item-row">
                                        <td class="text-center">${status.index + 1}</td>
                                        <td>
                                            <input type="hidden" name="medicineCode" value="${item.medicineCode}">
                                            <strong>${item.medicineName}</strong>
                                            <br>
                                            <small class="text-muted">
                                                <i class="bi bi-tag"></i> ${item.medicineCode}
                                            </small>
                                        </td>
                                        <td>
                                            <span class="badge bg-primary">${item.medicineStrength}</span>
                                        </td>
                                        <td>${item.medicineDosageForm}</td>
                                        <td>
                                            <input type="date" 
                                                   name="receivedDate" 
                                                   class="form-control form-control-sm"
                                                   value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>"
                                                   max="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>"
                                                   required>
                                        </td>
                                        <td>
                                            <input type="date" 
                                                   name="expiryDate" 
                                                   class="form-control form-control-sm"
                                                   min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>"
                                                   required>
                                        </td>
                                        <td>
                                            <input type="number" 
                                                   name="quantity" 
                                                   value="${item.quantity}"
                                                   min="1" 
                                                   class="form-control form-control-sm text-center"
                                                   required>
                                        </td>
                                        <td class="text-center">
                                            <div class="form-check d-flex justify-content-center">
                                                <input class="form-check-input item-checkbox" 
                                                       type="checkbox" 
                                                       checked>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Action Buttons -->
                    <div class="d-flex justify-content-end gap-3 p-4" style="background-color: #f9fafb; border-top: 2px solid #e5e7eb;">
                        <a href="${pageContext.request.contextPath}/pharmacist/view-order-details"
                           class="btn btn-outline-secondary px-4">
                            <i class="bi bi-x-circle"></i> Hủy
                        </a>
                        <button type="submit" class="btn btn-submit px-4">
                            <i class="bi bi-save"></i> Lưu lô thuốc
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%@ include file="/admin/footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // ✅ Select All checkbox
        document.getElementById('selectAll').addEventListener('change', function() {
            const checkboxes = document.querySelectorAll('.item-checkbox');
            const rows = document.querySelectorAll('.item-row');
            
            checkboxes.forEach((checkbox, index) => {
                checkbox.checked = this.checked;
                rows[index].style.opacity = this.checked ? '1' : '0.5';
                
                // Disable inputs when unchecked
                const inputs = rows[index].querySelectorAll('input:not(.item-checkbox)');
                inputs.forEach(input => {
                    input.disabled = !this.checked;
                });
            });
        });

        // ✅ Individual checkbox toggle
        document.querySelectorAll('.item-checkbox').forEach((checkbox, index) => {
            checkbox.addEventListener('change', function() {
                const row = document.querySelectorAll('.item-row')[index];
                row.style.opacity = this.checked ? '1' : '0.5';
                
                // Disable inputs when unchecked
                const inputs = row.querySelectorAll('input:not(.item-checkbox)');
                inputs.forEach(input => {
                    input.disabled = !this.checked;
                });
                
                // Update "Select All" checkbox
                const allChecked = Array.from(document.querySelectorAll('.item-checkbox'))
                                        .every(cb => cb.checked);
                document.getElementById('selectAll').checked = allChecked;
            });
        });

        // ✅ Form validation
        document.getElementById('batchForm').addEventListener('submit', function(e) {
            const checkedCount = document.querySelectorAll('.item-checkbox:checked').length;
            
            if (checkedCount === 0) {
                e.preventDefault();
                alert('⚠️ Vui lòng chọn ít nhất một thuốc để tạo lô!');
                return false;
            }
            
            // Validate dates
            let hasError = false;
            document.querySelectorAll('.item-row').forEach((row, index) => {
                const checkbox = row.querySelector('.item-checkbox');
                if (!checkbox.checked) return;
                
                const receivedDate = new Date(row.querySelector('input[name="receivedDate"]').value);
                const expiryDate = new Date(row.querySelector('input[name="expiryDate"]').value);
                
                if (expiryDate <= receivedDate) {
                    alert('❌ Thuốc ' + (index + 1) + ': Ngày hết hạn phải sau ngày nhận!');
                    hasError = true;
                }
            });
            
            if (hasError) {
                e.preventDefault();
                return false;
            }
            
            return confirm(`✅ Bạn có chắc muốn tạo ${checkedCount} lô thuốc?`);
        });

        // ✅ Auto-set expiry date (2 years from received date)
        document.querySelectorAll('input[name="receivedDate"]').forEach(input => {
            input.addEventListener('change', function() {
                const row = this.closest('.item-row');
                const expiryInput = row.querySelector('input[name="expiryDate"]');
                
                if (this.value && !expiryInput.value) {
                    const receivedDate = new Date(this.value);
                    receivedDate.setFullYear(receivedDate.getFullYear() + 2);
                    expiryInput.value = receivedDate.toISOString().split('T')[0];
                }
            });
        });
    </script>
</body>
</html>