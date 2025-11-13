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
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .form-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            padding: 30px;
        }
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        .table-medicine {
            background: white;
            border-radius: 8px;
            overflow: hidden;
        }
        .table thead {
            background-color: #667eea;
            color: white;
        }
        .medicine-row:hover {
            background-color: #f8f9fa;
        }
        .btn-submit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px 40px;
            font-weight: 600;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
        .info-badge {
            background-color: #e3f2fd;
            color: #1976d2;
            padding: 8px 12px;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
        }
        .alert-info {
            background-color: #e3f2fd;
            border-left: 4px solid #2196f3;
            color: #0d47a1;
        }
    </style>
</head>
<body>

<div class="container mt-4 mb-5">
    <!-- Page Header -->
    <div class="page-header">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <h4 class="mb-1">
                    <i class="bi bi-plus-circle-fill"></i> Tạo lô thuốc
                </h4>
                <p class="mb-0 opacity-75">Đơn hàng #${order.poId}</p>
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
    <div class="alert alert-info d-flex align-items-center" role="alert">
        <i class="bi bi-info-circle-fill fs-4 me-3"></i>
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
                                    <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                    Không có thuốc nào trong đơn hàng này
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
            <div class="d-flex justify-content-end gap-3 mt-4">
                <a href="${pageContext.request.contextPath}/pharmacist/ViewDeliveredOrder"
                   class="btn btn-outline-secondary px-4">
                    <i class="bi bi-x-circle"></i> Hủy
                </a>
                <button type="submit" class="btn btn-submit btn-primary px-4">
                    <i class="bi bi-save"></i> Lưu lô thuốc
                </button>
            </div>
        </form>
    </div>
</div>

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