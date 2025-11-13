<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý lô thuốc</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
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
                display: flex;
                flex-direction: column;
                background-color: #f9fafb;
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
                font-size: 14px;
                line-height: 1.5;
                color: #374151;
            }

            .page-wrapper {
                display: flex;
                flex: 1;
                min-height: calc(100vh - 60px);
            }

            /* White theme sidebar */
            .sidebar {
                width: 250px;
                background-color: #ffffff;
                color: #6c757d;
                display: flex;
                flex-direction: column;
                padding-top: 15px;
                border-right: 1px solid #e5e7eb;
                box-shadow: 2px 0 10px rgba(0, 0, 0, 0.08);
            }

            .menu a {
                display: flex;
                align-items: center;
                padding: 12px 25px;
                color: #6b7280;
                text-decoration: none;
                font-size: 14px;
                font-weight: 500;
                transition: all 0.3s ease;
                border-radius: 0;
                margin: 4px 0;
            }

            .menu a i {
                width: 20px;
                margin-right: 12px;
                color: #6b7280;
            }

            .menu a:hover {
                background-color: #f3f4f6;
                color: #495057;
                transform: translateX(4px);
            }

            .menu a.active {
                background-color: #f3f4f6;
                color: #6b7280;
                font-weight: 600;
            }

            .menu a.active i {
                color: #6b7280;
            }

            /* Main content */
            .main {
                flex: 1;
                padding: 30px;
                background-color: #f9fafb;
                overflow-y: auto;
            }

            h1 {
                font-size: 28px;
                margin-bottom: 25px;
                font-weight: 700;
                color: #1f2937;
                letter-spacing: -0.5px;
            }

            /* Search bar container */
            .search-container {
                background: white;
                padding: 20px;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
                margin-bottom: 24px;
            }

            .search-bar {
                display: flex;
                flex-wrap: wrap;
                gap: 12px;
                align-items: center;
            }

            .input-group {
                flex: 1 1 300px;
            }

            .input-group-text {
                background: white;
                border: 2px solid #e5e7eb;
                border-right: none;
                color: #6b7280;
            }

            .form-control, .form-select {
                padding: 10px 14px;
                border: 2px solid #e5e7eb;
                border-radius: 8px;
                font-size: 14px;
                font-family: 'Inter', sans-serif;
                transition: all 0.3s ease;
            }

            .input-group .form-control {
                border-left: none;
            }

            .form-control:focus, .form-select:focus {
                border-color: #6b7280;
                box-shadow: 0 0 0 3px rgba(107, 114, 128, 0.1);
                outline: none;
            }

            /* Button styling */
            .btn {
                padding: 10px 20px;
                border-radius: 8px;
                font-weight: 600;
                font-size: 14px;
                transition: all 0.3s ease;
                border: none;
            }

            .btn-search {
                background-color: #6b7280;
                color: white;
            }

            .btn-search:hover {
                background-color: #4b5563;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(107, 114, 128, 0.2);
            }

            .btn-reset {
                background-color: #9ca3af;
                color: white;
            }

            .btn-reset:hover {
                background-color: #6b7280;
            }

            .btn-warning {
                background-color: #f59e0b;
                color: white;
            }

            .btn-warning:hover {
                background-color: #d97706;
                transform: translateY(-2px);
            }

            .btn-danger {
                background-color: #ef4444;
                color: white;
            }

            .btn-danger:hover {
                background-color: #dc2626;
                transform: translateY(-2px);
            }

            /* Table container */
            .table-container {
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
                overflow: hidden;
            }

            table {
                background: white;
                border-collapse: collapse;
                width: 100%;
                margin: 0;
            }

            thead {
                background: #6b7280;
                color: white;
            }

            th {
                padding: 14px 12px;
                font-weight: 600;
                font-size: 13px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                text-align: center;
            }

            td {
                padding: 12px;
                border-bottom: 1px solid #e5e7eb;
                font-size: 14px;
                text-align: center;
            }

            tbody tr:hover {
                background-color: #f9fafb;
            }

            tbody tr:last-child td {
                border-bottom: none;
            }

            /* Status badges */
            .status-badge {
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                display: inline-block;
            }

            .status-available {
                background: #d1fae5;
                color: #065f46;
            }

            .status-low {
                background: #fef3c7;
                color: #92400e;
            }

            .status-expired {
                background: #fee2e2;
                color: #991b1b;
            }

            /* Pagination */
            .pagination {
                display: flex;
                justify-content: center;
                margin-top: 20px;
                gap: 5px;
            }

            .page-item .page-link {
                color: #6b7280;
                border: 1px solid #e5e7eb;
                border-radius: 8px;
                padding: 8px 14px;
                font-weight: 500;
                transition: all 0.3s ease;
            }

            .page-item .page-link:hover {
                background-color: #f3f4f6;
                border-color: #6b7280;
            }

            .page-item.active .page-link {
                background-color: #6b7280;
                color: white;
                border-color: #6b7280;
            }

            .page-item.disabled .page-link {
                background-color: #f3f4f6;
                color: #9ca3af;
                cursor: not-allowed;
            }

            /* Modal styling */
            .modal-content {
                border-radius: 12px;
                border: none;
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
            }

            .modal-header {
                background-color: #f59e0b;
                color: white;
                border-bottom: none;
                border-radius: 12px 12px 0 0;
                padding: 20px 24px;
            }

            .modal-title {
                font-weight: 700;
            }

            .modal-body {
                padding: 24px;
            }

            .modal-footer {
                background-color: #f9fafb;
                border-top: 2px solid #e5e7eb;
                padding: 16px 24px;
            }

            .modal-body .mb-3 label {
                font-weight: 600;
                color: #374151;
                font-size: 13px;
                margin-bottom: 6px;
            }

            /* Empty state */
            .empty-state {
                text-align: center;
                color: #9ca3af;
                padding: 60px 20px;
            }

            .empty-state h3 {
                color: #6b7280;
                margin-bottom: 10px;
            }

            /* Scrollbar styling */
            ::-webkit-scrollbar {
                width: 8px;
            }

            ::-webkit-scrollbar-track {
                background: rgba(0, 0, 0, 0.05);
            }

            ::-webkit-scrollbar-thumb {
                background: rgba(0, 0, 0, 0.2);
                border-radius: 4px;
            }

            ::-webkit-scrollbar-thumb:hover {
                background: rgba(0, 0, 0, 0.3);
            }

            /* Responsive */
            @media (max-width: 768px) {
                .page-wrapper {
                    flex-direction: column;
                }

                .sidebar {
                    width: 100%;
                    border-right: none;
                    border-bottom: 1px solid #e5e7eb;
                }

                .main {
                    padding: 20px;
                }

                h1 {
                    font-size: 22px;
                }
            }
        </style>
    </head>

    <body>
        <%@ include file="/admin/header.jsp" %>

        <div class="page-wrapper">
            <!-- Sidebar -->
            <div class="sidebar">
                <div class="menu">
                    <a href="${pageContext.request.contextPath}/view-medicine">
                        <i class="bi bi-capsule"></i> Quản lý thuốc
                    </a>
                    <a href="${pageContext.request.contextPath}/pharmacist/View_MedicineRequest">
                        <i class="bi bi-file-earmark-plus"></i> Yêu cầu thuốc
                    </a>
                    <a href="${pageContext.request.contextPath}/pharmacist/view-order-details">
                        <i class="bi bi-box-seam"></i> Đơn hàng đã giao
                    </a>
                    <a href="${pageContext.request.contextPath}/pharmacist/manage-batch" class="active">
                        <i class="bi bi-box-seam"></i> Quản lý số lô/lô hàng
                    </a>
                    <a href="${pageContext.request.contextPath}/pharmacist/recordExpiredDamaged">
                        <i class="bi bi-exclamation-triangle"></i> Thuốc hết hạn/hư hỏng
                    </a>
                    <a href="${pageContext.request.contextPath}/report">
                        <i class="bi bi-graph-up"></i> Báo cáo thống kê
                    </a>
                </div>
            </div>

            <!-- Main content -->
            <div class="main">
                <h1>Quản lý số lô thuốc</h1>

                <!-- Search + Filter Container -->
                <div class="search-container mb-4">
                    <form action="${pageContext.request.contextPath}/pharmacist/manage-batch" method="get" class="row g-3">

                        <!-- Keyword / Lot Number -->
                        <div class="col-md-3">
                            <input type="text" name="lotNumber" value="${param.lotNumber}"
                                   placeholder="🔍 Số lô..." class="form-control">
                        </div>

                        <!-- Dropdown Filter -->
                        <div class="col-md-4 position-relative">
                            <div class="dropdown w-100">
                                <button id="filterDropdown" class="btn btn-outline-primary dropdown-toggle w-100"
                                        type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    <c:choose>
                                        <c:when test="${not empty medicineLabel or not empty supplierLabel}">
                                            <c:if test="${not empty medicineLabel}">${medicineLabel}</c:if>
                                            <c:if test="${not empty medicineLabel and not empty supplierLabel}"> | </c:if>
                                            <c:if test="${not empty supplierLabel}">${supplierLabel}</c:if>
                                        </c:when>
                                        <c:otherwise>Chọn tiêu chí lọc</c:otherwise>
                                    </c:choose>
                                </button>


                                <!-- Dropdown menu -->
                                <ul class="dropdown-menu p-3" style="width: 100%; max-height: 400px; overflow: visible;">
                                    <!-- Tên thuốc -->
                                    <li class="dropdown-submenu position-relative">
                                        <a href="#" class="dropdown-item fw-bold">Tên thuốc</a>
                                        <ul class="dropdown-menu submenu shadow-sm bg-white"
                                            style="position: absolute; top: 0; left: 100%; min-width: 200px; max-height: 300px; overflow-y: auto;">
                                            <c:forEach var="m" items="${medicineList}">
                                                <li>
                                                    <a href="#" class="dropdown-item filter-option"
                                                       data-type="medicine" data-value="${m.medicineCode}" data-label="${m.name}">
                                                        ${m.name}
                                                    </a>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </li>

                                    <!-- Nhà cung cấp -->
                                    <li class="dropdown-submenu position-relative mt-2">
                                        <a href="#" class="dropdown-item fw-bold">Nhà cung cấp</a>
                                        <ul class="dropdown-menu submenu shadow-sm bg-white"
                                            style="position: absolute; top: 0; left: 100%; min-width: 200px; max-height: 300px; overflow-y: auto;">
                                            <c:forEach var="s" items="${supplierList}">
                                                <li>
                                                    <a href="#" class="dropdown-item filter-option"
                                                       data-type="supplier" data-value="${s.supplierId}" data-label="${s.name}">
                                                        ${s.name}
                                                    </a>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </li>
                                </ul>
                            </div>
                        </div>

                        <!-- Hidden Inputs -->
                        <input type="hidden" id="selectedMedicine" name="medicineCode" value="${param.medicineCode}" data-label="${medicineLabel}">
                        <input type="hidden" id="selectedSupplier" name="supplierId" value="${param.supplierId}" data-label="${supplierLabel}">


                        <!-- Status -->
                        <div class="col-md-2">
                            <select name="status" class="form-select">
                                <option value="" ${param.status == '' ? 'selected' : ''}>Tất cả</option>
                                <option value="Received" ${param.status == 'Received' ? 'selected' : ''}>Received</option>
                                <option value="Quarantined" ${param.status == 'Quarantined' ? 'selected' : ''}>Quarantined</option>
                                <option value="Approved" ${param.status == 'Approved' ? 'selected' : ''}>Approved</option>
                            </select>
                        </div>

                        <!-- Buttons -->
                        <div class="col-md-3 d-flex gap-2">
                            <button type="submit" class="btn btn-success flex-fill">Tìm kiếm</button>
                            <a href="${pageContext.request.contextPath}/pharmacist/manage-batch" class="btn btn-secondary flex-fill">Reset</a>
                        </div>
                    </form>
                </div>


                <%--<c:if test="${sessionScope.role eq 'Pharmacist'}">
                    <div class="d-flex justify-content-end mb-3">
                        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addMedicineModal">
                            <i class="bi bi-plus-circle"></i> Add New Batch
                        </button>
                    </div>
                </c:if>
                --%>
                <!-- Table -->
                <c:choose>
                    <c:when test="${not empty batches}">
                        <div class="table-container">
                            <table id="batchTable" class="table table-hover align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Số lô</th>
                                        <th>Tên thuốc</th>
                                        <th>Nhà cung cấp</th>
                                        <th>Ngày nhập</th>
                                        <th>Hạn sử dụng</th>
                                        <th>Tồn kho</th>
                                        <th>Trạng thái</th>
                                        <th>Chỉnh sửa</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="b" items="${batches}">
                                        <tr>
                                            <td><strong>${b.batchId}</strong></td>
                                            <td>${b.lotNumber}</td>
                                            <td>${b.medicineName}</td>
                                            <td>${b.supplierName}</td>
                                            <td><fmt:formatDate value="${b.receivedDate}" pattern="dd/MM/yyyy"/></td>
                                            <td><fmt:formatDate value="${b.expiryDate}" pattern="yyyy-MM-dd"/></td>
                                            <td>${b.currentQuantity}</td>
                                            <td>
                                                <span class="status-badge
                                                      ${b.status == 'Available' ? 'status-available' :
                                                        (b.status == 'Low Stock' ? 'status-low' : 'status-expired')}">
                                                          ${b.status}
                                                      </span>
                                                </td>
                                                <td>
                                                    <button class="btn btn-warning btn-sm"
                                                            data-bs-toggle="modal"
                                                            data-bs-target="#editBatchModal"
                                                            data-id="${b.batchId}"
                                                            data-lot="${b.lotNumber}"
                                                            data-medicine="${b.medicineName}"
                                                            data-supplier="${b.supplierName}"
                                                            data-expiry="<fmt:formatDate value='${b.expiryDate}' pattern='yyyy-MM-dd'/>"
                                                            data-received="<fmt:formatDate value='${b.receivedDate}' pattern='yyyy-MM-dd'/>"
                                                            data-current="${b.currentQuantity}"
                                                            data-status="${b.status}"
                                                            data-quarantinenotes="${b.quarantineNotes}">
                                                        <i class="bi bi-pencil-square"></i>
                                                    </button>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${b.status eq 'Received' || b.status eq 'Quarantined'}">
                                                            <button class="btn btn-info btn-sm"
                                                                    data-bs-toggle="modal"
                                                                    data-bs-target="#qcModal"
                                                                    data-id="${b.batchId}">
                                                                <i class="bi bi-clipboard-check"></i> Kiểm chứng
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button class="btn btn-secondary btn-sm" disabled>
                                                                <i class="bi bi-shield-check"></i> Đã kiểm chứng
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            <nav><ul class="pagination" id="pagination"></ul></nav>
                            </c:when>
                            <c:otherwise>
                            <div class="table-container">
                                <div class="empty-state">
                                    <h3>Không có dữ liệu lô hàng</h3>
                                    <p>Chưa có lô thuốc nào được thêm vào hệ thống.</p>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>


            <!-- Modal chỉnh sửa -->
            <div class="modal fade" id="editBatchModal" tabindex="-1">
                <div class="modal-dialog">
                    <form action="${pageContext.request.contextPath}/pharmacist/Batch-Update" 
                          method="post" class="modal-content">

                        <div class="modal-header">
                            <h5 class="modal-title"><i class="bi bi-pencil-square"></i> Cập nhật lô thuốc</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>

                        <div class="modal-body">
                            <input type="hidden" id="edit-id" name="batchId">

                            <div class="mb-3">
                                <label>Số lô</label>
                                <input type="text" id="edit-lot" class="form-control" readonly>
                            </div>

                            <div class="mb-3">
                                <label>Tên thuốc</label>
                                <input type="text" id="edit-medicine" class="form-control" readonly>
                            </div>

                            <div class="mb-3">
                                <label>Nhà cung cấp</label>
                                <input type="text" id="edit-supplier" class="form-control" readonly>
                            </div>

                            <div class="mb-3">
                                <label>Hạn sử dụng</label>
                                <input type="date" id="edit-expiry" name="expiryDate" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label>Ngày nhập</label>
                                <input type="date" id="edit-received" class="form-control" readonly disabled>
                                <input type="hidden" name="receivedDate" id="hidden-received">
                            </div>


                            <div class="mb-3">
                                <label>Tồn kho</label>
                                <input type="number" id="edit-current" name="currentQuantity" class="form-control" required>
                            </div>

                            <div class="mb-3">
                                <label>Trạng thái</label>
                                <select id="edit-status" name="status" class="form-select">
                                    <option value="Received">Received</option>
                                    <option value="Quarantined">Quarantined</option>
                                    <option value="Approved">Approved</option>

                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="edit-quarantine-notes" class="form-label">Ghi chú kiểm định (Quarantine Notes)</label>
                                <textarea id="edit-quarantine-notes"
                                          name="quarantineNotes"
                                          class="form-control"
                                          rows="2"
                                          placeholder="Nhập ghi chú kiểm định, tình trạng lô thuốc..."></textarea>
                            </div>

                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button class="btn btn-warning"><i class="bi bi-check-circle"></i> Cập nhật</button>
                        </div>
                    </form>
                </div>
            </div>



            <!-- Modal Kiểm chứng -->                   
            <div class="modal fade" id="qcModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog">
                    <form action="${pageContext.request.contextPath}/pharmacist/BatchQualityCheck" method="post" class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">🧪 Kiểm chứng chất lượng</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>

                        <div class="modal-body">
                            <input type="hidden" name="batchId" id="qc-batch-id">

                            <div class="mb-3">
                                <label for="qc-status" class="form-label">Trạng thái mới</label>
                                <select id="qc-status" name="status" class="form-select" required>
                                    <option value="Quarantined">Quarantined (Cần đánh giá thêm)</option>
                                    <option value="Approved">Approved (Đạt chuẩn)</option>
                                    <option value="Rejected">Rejected (Không đạt)</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="qc-notes" class="form-label">Ghi chú kiểm chứng</label>
                                <textarea id="qc-notes" name="quarantineNotes" class="form-control" rows="3"></textarea>
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-success">Lưu</button>
                        </div>
                    </form>
                </div>
            </div>

            <%@ include file="/admin/footer.jsp" %>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script>

// JS xử lý dropdown chọn filter 
                // Hover submenu
                document.querySelectorAll('.dropdown-submenu > a').forEach(el => {
                    const submenu = el.nextElementSibling;
                    el.addEventListener('mouseenter', () => {
                        if (submenu)
                            submenu.style.display = 'block';
                    });
                    el.addEventListener('mouseleave', () => {
                        if (submenu)
                            submenu.style.display = 'none';
                    });
                    if (submenu) {
                        submenu.addEventListener('mouseenter', () => submenu.style.display = 'block');
                        submenu.addEventListener('mouseleave', () => submenu.style.display = 'none');
                    }
                });

                // Click chọn option

                document.addEventListener("DOMContentLoaded", function () {
                    const filterOptions = document.querySelectorAll(".filter-option");
                    const filterButton = document.getElementById("filterDropdown");
                    const selectedMedicine = document.getElementById("selectedMedicine");
                    const selectedSupplier = document.getElementById("selectedSupplier");

                    function updateButtonText() {
                        const medLabel = selectedMedicine.dataset.label || "";
                        const supLabel = selectedSupplier.dataset.label || "";
                        const labels = [medLabel, supLabel].filter(Boolean);
                        filterButton.textContent = labels.length > 0 ? labels.join(" | ") : "Chọn tiêu chí lọc";
                    }

                    filterOptions.forEach(option => {
                        option.addEventListener("mousedown", function (e) {
                            e.preventDefault();
                            e.stopPropagation();
                            const {type, value, label} = this.dataset;

                            if (type === "medicine") {
                                selectedMedicine.value = value;
                                selectedMedicine.dataset.label = label;
                            } else if (type === "supplier") {
                                selectedSupplier.value = value;
                                selectedSupplier.dataset.label = label;
                            }

                            updateButtonText();
                            const dropdown = bootstrap.Dropdown.getInstance(filterButton);
                            if (dropdown)
                                dropdown.hide();
                        });
                    });

                    // ✅ Giữ text khi reload lại (JSP đã gán data-label sẵn)
                    updateButtonText();
                });



                // Script tự động copy số lượng ban đầu sang số lượng hiện tại 
                const initialInput = document.getElementById('initialQuantity');
                const currentInput = document.getElementById('currentQuantity');

                if (initialInput && currentInput) {
                    initialInput.addEventListener('input', () => {
                        currentInput.value = initialInput.value || 0;
                    });
                }





                // Modal edit handler

                document.addEventListener("DOMContentLoaded", function () {
                    const modal = document.getElementById("editBatchModal");
                    if (!modal)
                        return;

                    modal.addEventListener("show.bs.modal", function (event) {
                        const button = event.relatedTarget;
                        if (!button)
                            return;
                        console.log("🔍 DATA:", button.dataset);

                        document.getElementById("edit-id").value = button.dataset.id || "";
                        document.getElementById("edit-lot").value = button.dataset.lot || "";
                        document.getElementById("edit-medicine").value = button.dataset.medicine || "";
                        document.getElementById("edit-supplier").value = button.dataset.supplier || "";
                        document.getElementById("edit-received").value = button.dataset.received || "";
                        document.getElementById("hidden-received").value = button.dataset.received || "";
                        // ✅ chỉ hiển thị
                        document.getElementById("edit-expiry").value = button.dataset.expiry || "";
                        document.getElementById("edit-current").value = button.dataset.current || "";
                        document.getElementById("edit-status").value = button.dataset.status || "Received";
                        document.getElementById("edit-quarantine-notes").value = button.dataset.quarantinenotes || "";

                    });
                });




                // Pagination + Filter
                const rowsPerPage = 10;
                const table = document.getElementById("batchTable");
                const pagination = document.getElementById("pagination");
                const allRows = table ? Array.from(table.querySelectorAll("tbody tr")) : [];
                let filteredRows = [...allRows];
                let currentPage = 1;

                function displayPage(page) {
                    const start = (page - 1) * rowsPerPage;
                    const end = start + rowsPerPage;
                    filteredRows.forEach((r, i) => r.style.display = (i >= start && i < end) ? "" : "none");
                }

                function setupPagination() {
                    pagination.innerHTML = "";
                    const pageCount = Math.ceil(filteredRows.length / rowsPerPage);
                    if (pageCount === 0)
                        return;

                    const prev = document.createElement("li");
                    prev.className = "page-item" + (currentPage === 1 ? " disabled" : "");
                    prev.innerHTML = `<a class="page-link" href="#">&laquo;</a>`;
                    prev.addEventListener("click", (e) => {
                        e.preventDefault();
                        if (currentPage > 1) {
                            currentPage--;
                            displayPage(currentPage);
                            setupPagination();
                        }
                    });
                    pagination.appendChild(prev);

                    for (let i = 1; i <= pageCount; i++) {
                        const li = document.createElement("li");
                        li.className = "page-item" + (i === currentPage ? " active" : "");
                        li.innerHTML = `<a class="page-link" href="#">${i}</a>`;
                        li.addEventListener("click", (e) => {
                            e.preventDefault();
                            currentPage = i;
                            displayPage(currentPage);
                            setupPagination();
                        });
                        pagination.appendChild(li);
                    }

                    const next = document.createElement("li");
                    next.className = "page-item" + (currentPage === pageCount ? " disabled" : "");
                    next.innerHTML = `<a class="page-link" href="#">&raquo;</a>`;
                    next.addEventListener("click", (e) => {
                        e.preventDefault();
                        if (currentPage < pageCount) {
                            currentPage++;
                            displayPage(currentPage);
                            setupPagination();
                        }
                    });
                    pagination.appendChild(next);
                    displayPage(currentPage);
                }

                function applyFilter() {
                    const keyword = document.getElementById("searchInput").value.toLowerCase();
                    const status = document.getElementById("statusFilter").value.toLowerCase();

                    filteredRows = allRows.filter(row => {
                        const lot = row.cells[0].innerText.toLowerCase();      // Số lô
                        const name = row.cells[1].innerText.toLowerCase();     // Tên thuốc
                        const rowStatus = row.cells[2].innerText.toLowerCase(); // Trạng thái

                        const matchesKeyword = lot.includes(keyword) || name.includes(keyword);
                        const matchesStatus = status ? rowStatus.includes(status) : true;

                        return matchesKeyword && matchesStatus;
                    });

                    currentPage = 1;
                    setupPagination();
                }


                function resetFilter() {
                    document.getElementById("searchInput").value = "";
                    document.getElementById("statusFilter").value = "";
                    filteredRows = [...allRows];
                    currentPage = 1;
                    setupPagination();
                }

                if (allRows.length > 0)
                    setupPagination();


                // Modal kiểm chứng
                document.addEventListener("DOMContentLoaded", function () {
                    const qcModal = document.getElementById("qcModal");
                    if (!qcModal)
                        return;

                    qcModal.addEventListener("show.bs.modal", function (event) {
                        const button = event.relatedTarget;
                        if (!button)
                            return;

                        // Gán batch_id vào input ẩn
                        document.getElementById("qc-batch-id").value = button.getAttribute("data-id") || "";
                    });
                });
            </script>
        </body>
    </html>
