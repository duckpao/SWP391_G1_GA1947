<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Medicine Details</title>
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

            /* Search container */
            .search-container {
                background: white;
                padding: 24px;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
                margin-bottom: 24px;
            }

            .form-control, .form-select {
                padding: 10px 14px;
                border: 2px solid #e5e7eb;
                border-radius: 8px;
                font-size: 14px;
                font-family: 'Inter', sans-serif;
                transition: all 0.3s ease;
            }

            .form-control:focus, .form-select:focus {
                border-color: #6b7280;
                box-shadow: 0 0 0 3px rgba(107, 114, 128, 0.1);
                outline: none;
            }

            /* Gray button styling */
            .btn {
                padding: 10px 20px;
                border-radius: 8px;
                font-weight: 600;
                font-size: 14px;
                transition: all 0.3s ease;
                border: none;
            }

            .btn-primary {
                background-color: #6b7280;
                color: white;
            }

            .btn-primary:hover {
                background-color: #4b5563;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(107, 114, 128, 0.2);
            }

            .btn-success {
                background-color: #6b7280;
                color: white;
            }

            .btn-success:hover {
                background-color: #4b5563;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(107, 114, 128, 0.2);
            }

            .btn-secondary {
                background-color: #9ca3af;
                color: white;
            }

            .btn-secondary:hover {
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

            /* Table styling */
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
            }

            td {
                padding: 12px;
                border-bottom: 1px solid #e5e7eb;
                font-size: 14px;
            }

            tbody tr:hover {
                background-color: #f9fafb;
            }

            tbody tr:last-child td {
                border-bottom: none;
            }

            .status-badge {
                padding: 4px 10px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
            }

            .status-approved {
                background: #d1fae5;
                color: #065f46;
            }

            .status-low {
                background: #fef3c7;
                color: #92400e;
            }

            .status-out {
                background: #fee2e2;
                color: #991b1b;
            }

            .empty-state {
                text-align: center;
                color: #9ca3af;
                padding: 60px 20px;
            }

            .empty-state h3 {
                color: #6b7280;
                margin-bottom: 10px;
            }

            /* Modal styling */
            .modal-content {
                border-radius: 12px;
                border: none;
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
            }

            .modal-header {
                background-color: #f9fafb;
                border-bottom: 2px solid #e5e7eb;
                padding: 20px 24px;
            }

            .modal-title {
                font-weight: 700;
                color: #1f2937;
            }

            .modal-body {
                padding: 24px;
            }

            .modal-footer {
                background-color: #f9fafb;
                border-top: 2px solid #e5e7eb;
                padding: 16px 24px;
            }

            .form-label {
                font-weight: 600;
                color: #374151;
                font-size: 13px;
                margin-bottom: 6px;
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
            }

            /* Hiển thị submenu khi hover */
            .dropdown-submenu {
                position: relative;
            }

            .dropdown-submenu > .submenu {
                display: none;
                position: absolute;
                left: 100%;
                top: 0;
                margin-left: 0.1rem;
            }

            .dropdown-submenu:hover > .submenu {
                display: block;
            }

            /* Hiện submenu khi hover vào mục cha */
            .dropdown-submenu:hover > .submenu {
                display: block !important;
            }

            /* Giữ không đóng dropdown chính khi hover */
            .dropdown-menu.show {
                overflow: visible !important;
            }

            /* Mũi tên phải */
            .dropdown-submenu > a::after {
                content: "›";
                float: right;
                margin-left: 5px;
            }

            #filterButton.btn-outline-primary {
                padding: 10px 14px !important;
                border: 2px solid #e5e7eb !important;
                border-radius: 8px !important;
                font-size: 14px !important;
                background-color: white !important;
                color: #374151 !important;
                text-align: left !important;
                height: 42px !important;
            }

            #filterButton.btn-outline-primary:hover {
                border-color: #6b7280 !important;
                background-color: white !important;
                color: #374151 !important;
            }

            #filterButton.btn-outline-primary:focus {
                border-color: #6b7280 !important;
                box-shadow: 0 0 0 3px rgba(107, 114, 128, 0.1) !important;
                background-color: white !important;
            }

            /* === Modal Tổng Thể === */
            .modal-content {
                border-radius: 16px;
                overflow: hidden;
                border: none;
                box-shadow: 0 10px 28px rgba(0, 0, 0, 0.25);
            }

            /* === Header === */
            .modal-header {
                background: linear-gradient(120deg, #20c997, #198754);
                color: white;
                border-bottom: none;
                padding: 1rem 1.5rem;
            }

            .modal-title {
                font-weight: 700;
                font-size: 1.25rem;
                display: flex;
                align-items: center;
                gap: 6px;
            }

            .btn-close {
                filter: brightness(0) invert(1);
            }

            /* === Nội dung === */
            .modal-body {
                background-color: #f8f9fa;
                padding: 28px;
            }

            .form-label {
                font-weight: 600;
                color: #2d2d2d;
                margin-bottom: 5px;
            }

            .form-control,
            .form-select {
                border-radius: 8px;
                padding: 10px 12px;
                border: 1px solid #d0d5dd;
                background-color: #fff;
                transition: all 0.2s ease-in-out;
            }

            .form-control:focus,
            .form-select:focus {
                border-color: #20c997;
                box-shadow: 0 0 0 0.15rem rgba(32, 201, 151, 0.25);
            }

            /* === Phần tiêu đề nhóm (nếu muốn chia section sau này) === */
            .section-title {
                font-weight: 700;
                color: #198754;
                margin-top: 25px;
                border-bottom: 2px solid #20c997;
                padding-bottom: 6px;
                font-size: 1rem;
            }

            /* === Footer === */
            .modal-footer {
                background-color: #f1f3f5;
                border-top: none;
                padding: 1rem 1.5rem;
            }

            .btn-success {
                background-color: #20c997;
                border: none;
                border-radius: 8px;
                font-weight: 600;
                padding: 8px 18px;
                transition: 0.2s;
            }

            .btn-success:hover {
                background-color: #17a589;
                transform: translateY(-1px);
            }

            .btn-secondary {
                border-radius: 8px;
                font-weight: 600;
            }

            /* === Giao diện đồng bộ giữa Add và Edit === */
            #addMedicineModal .modal-header i {
                color: #e3f9f0;
            }

            #editMedicineModal .modal-header {
                background: linear-gradient(120deg, #0d6efd, #1a73e8);
            }

        </style>
    </head>

    <body>
        <%@ include file="/admin/header.jsp" %>

        <div class="page-wrapper">
            <!-- Sidebar -->
            <div class="sidebar">
                <div class="menu">
                    <a href="${pageContext.request.contextPath}/view-medicine" class="active">
                        <i class="bi bi-capsule"></i> Quản lý thuốc
                    </a>

                    <c:if test="${sessionScope.role eq 'Doctor'}">
                        <a href="${pageContext.request.contextPath}/create-request">
                            <i class="bi bi-file-earmark-plus"></i> Yêu cầu thuốc
                        </a>
                    </c:if>

                    <c:if test="${sessionScope.role eq 'Pharmacist'}">
                        <a href="${pageContext.request.contextPath}/pharmacist/View_MedicineRequest">
                            <i class="bi bi-file-earmark-plus"></i> Yêu cầu thuốc
                        </a>
                        <a href="${pageContext.request.contextPath}/pharmacist/view-order-details">
                            <i class="bi bi-box-seam"></i> Đơn hàng đã giao
                        </a>
                        <a href="${pageContext.request.contextPath}/pharmacist/manage-batch">
                            <i class="bi bi-box-seam"></i> Quản lý số lô/lô hàng
                        </a>
                        <a href="${pageContext.request.contextPath}/pharmacist/recordExpiredDamaged">
                            <i class="bi bi-exclamation-triangle"></i> Thuốc hết hạn/hư hỏng
                        </a>
                        <a href="${pageContext.request.contextPath}/report">
                            <i class="bi bi-graph-up"></i> Báo cáo thống kê
                        </a>
                    </c:if>
                </div>
            </div>

            <!-- Main Content -->
            <div class="main">
                <h1>Medicine Details</h1>

                <!-- Search + Filter Container -->
                <div class="search-container mb-4">
                    <form action="${pageContext.request.contextPath}/view-medicine" method="get" class="row g-3">

                        <!-- Keyword -->
                        <div class="col-md-4">
                            <input type="text" name="keyword" value="${keyword}"
                                   placeholder="🔍 Tìm kiếm thuốc..." class="form-control">
                        </div>

                        <!-- Dropdown Filter Type -->
                        <div class="col-md-4 position-relative">
                            <div class="dropdown w-100">
                                <button id="filterButton"
                                        class="btn btn-outline-primary dropdown-toggle w-100"
                                        type="button"
                                        data-bs-toggle="dropdown"
                                        aria-expanded="false">
                                    Chọn tiêu chí lọc
                                </button>

                                <!-- Mega Dropdown -->
                                <ul class="dropdown-menu p-3" style="width: 100%; max-height: 400px; overflow-y: auto;">
                                    <!-- Danh mục -->
                                    <li class="dropdown-submenu position-relative">
                                        <a href="#" class="dropdown-item fw-bold">Danh mục</a>
                                        <ul class="dropdown-menu submenu shadow-sm bg-white">
                                            <c:forEach var="cat" items="${categories}">
                                                <li>
                                                    <a href="#" class="dropdown-item filter-option"
                                                       data-type="category" data-value="${cat}">${cat}</a>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </li>
                                    <!-- Hoạt chất -->
                                    <li class="dropdown-submenu position-relative mt-2">
                                        <a href="#" class="dropdown-item fw-bold">Hoạt chất</a>
                                        <ul class="dropdown-menu submenu shadow-sm bg-white">
                                            <c:forEach var="ai" items="${activeIngredients}">
                                                <li>
                                                    <a href="#" class="dropdown-item filter-option"
                                                       data-type="activeIngredient" data-value="${ai}">${ai}</a>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </li>
                                    <!-- Nhóm thuốc -->
                                    <li class="dropdown-submenu position-relative mt-2">
                                        <a href="#" class="dropdown-item fw-bold">Nhóm thuốc</a>
                                        <ul class="dropdown-menu submenu shadow-sm bg-white">
                                            <c:forEach var="dg" items="${drugGroups}">
                                                <li>
                                                    <a href="#" class="dropdown-item filter-option"
                                                       data-type="drugGroup" data-value="${dg}">${dg}</a>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </li>
                                    <!-- Loại thuốc -->
                                    <li class="dropdown-submenu position-relative mt-2">
                                        <a href="#" class="dropdown-item fw-bold">Loại thuốc</a>
                                        <ul class="dropdown-menu submenu shadow-sm bg-white">
                                            <c:forEach var="dt" items="${drugTypes}">
                                                <li>
                                                    <a href="#" class="dropdown-item filter-option"
                                                       data-type="drugType" data-value="${dt}">${dt}</a>
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </li>
                                </ul>
                            </div>
                        </div>

                        <!-- Hidden Inputs cho từng filter -->
                        <input type="hidden" name="category" id="filterCategory" value="${selectedCategory != null ? selectedCategory : ''}">
                        <input type="hidden" name="activeIngredient" id="filterActiveIngredient" value="${selectedActiveIngredient != null ? selectedActiveIngredient : ''}">
                        <input type="hidden" name="drugGroup" id="filterDrugGroup" value="${selectedDrugGroup != null ? selectedDrugGroup : ''}">
                        <input type="hidden" name="drugType" id="filterDrugType" value="${selectedDrugType != null ? selectedDrugType : ''}">

                        <!-- Status -->
                        <div class="col-md-2">
                            <select name="status" class="form-select">
                                <option value="" ${selectedStatus == '' ? 'selected' : ''}>Tất cả</option>
                                <option value="In Stock" ${selectedStatus == 'In Stock' ? 'selected' : ''}>Còn nhiều</option>
                                <option value="Low Stock" ${selectedStatus == 'Low Stock' ? 'selected' : ''}>Sắp hết</option>
                                <option value="Out of Stock" ${selectedStatus == 'Out of Stock' ? 'selected' : ''}>Hết hàng</option>
                            </select>
                        </div>

                        <!-- Buttons -->
                        <div class="col-md-2 d-flex gap-2">
                            <button type="submit" class="btn btn-success flex-fill">Tìm kiếm</button>
                            <a href="${pageContext.request.contextPath}/view-medicine" class="btn btn-secondary flex-fill">Reset</a>
                        </div>
                    </form>
                </div>


                <!-- Action Buttons -->
                <div class="d-flex mb-3 gap-2">
                    <c:if test="${sessionScope.role eq 'Doctor'}">
                        <a href="${pageContext.request.contextPath}/create-request" class="btn btn-primary">
                            <i class="bi bi-file-earmark-plus"></i> Create Request
                        </a>

                    </c:if>

                    <c:if test="${not empty sessionScope.success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            ${sessionScope.success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="success" scope="session"/>
                    </c:if>

                    <c:if test="${not empty sessionScope.error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            ${sessionScope.error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="error" scope="session"/>
                    </c:if>

                    <c:if test="${sessionScope.role eq 'Pharmacist'}">
                        <button class="btn btn-success ms-auto" data-bs-toggle="modal" data-bs-target="#addMedicineModal">
                            <i class="bi bi-plus-circle"></i> Add New Medicine
                        </button>
                    </c:if>
                </div>

                <!-- Medicine Table -->
                <c:choose>
                    <c:when test="${not empty medicines}">
                        <div class="table-container">
                            <table class="table table-hover align-middle text-center mb-0">
                                <thead>
                                    <tr>
                                        <th>Mã thuốc</th>
                                        <th>Tên thuốc</th>
                                        <th>Danh mục</th>
                                        <th>Mô tả</th>
                                        <th>Hoạt chất</th>
                                        <th>Dạng bào chế</th>
                                        <th>Hàm lượng</th>
                                        <th>Đơn vị</th>
                                        <th>Nhà sản xuất</th>
                                        <th>Nhà cung cấp</th>
                                        <th>Xuất xứ</th>
                                        <th>Nhóm thuốc</th>
                                        <th>Loại thuốc</th>
                                        <th>Tồn kho</th>
                                        <th>Hạn sử dụng</th>
                                            <c:if test="${sessionScope.role eq 'Pharmacist'}">
                                            <th>Chỉnh sửa</th>
                                            <th>Xóa</th>
                                            </c:if>
                                    </tr>
                                </thead>

                                <tbody>
                                    <c:forEach var="m" items="${medicines}">
                                        <tr>
                                            <td>${m.medicineCode}</td>
                                            <td><strong>${m.name}</strong></td>
                                            <td>${m.category}</td>
                                            <td>${m.description}</td>
                                            <td>${m.activeIngredient}</td>
                                            <td>${m.dosageForm}</td>
                                            <td>${m.strength}</td>
                                            <td>${m.unit}</td>
                                            <td>${m.manufacturer}</td>
                                            <td>${m.supplierName}</td>
                                            <td>${m.countryOfOrigin}</td>
                                            <td>${m.drugGroup}</td>
                                            <td>${m.drugType}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty m.batches}">
                                                        ${m.batches[0].currentQuantity}
                                                    </c:when>
                                                    <c:otherwise>0</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty m.batches and m.batches[0].expiryDate ne null}">
                                                        <fmt:formatDate value="${m.batches[0].expiryDate}" pattern="dd/MM/yyyy"/>
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>

                                            <c:if test="${sessionScope.role eq 'Pharmacist'}">
                                                <td>
                                                    <button class="btn btn-warning btn-sm edit-btn"
                                                            data-bs-toggle="modal"
                                                            data-bs-target="#editMedicineModal"
                                                            data-medicinecode="${m.medicineCode}"
                                                            data-batchid="${m.batches[0].batchId}"
                                                            data-supplierid="${m.batches[0].supplierId}"
                                                            data-name="${m.name}"
                                                            data-category="${m.category}"
                                                            data-description="${m.description}"
                                                            data-activeingredient="${m.activeIngredient}"
                                                            data-dosageform="${m.dosageForm}"
                                                            data-strength="${m.strength}"
                                                            data-unit="${m.unit}"
                                                            data-manufacturer="${m.manufacturer}"
                                                            data-origin="${m.countryOfOrigin}"
                                                            data-druggroup="${m.drugGroup}"
                                                            data-drugtype="${m.drugType}"
                                                            data-stock="${m.batches[0].currentQuantity}"
                                                            data-expirydate="<fmt:formatDate value='${m.batches[0].expiryDate}' pattern='yyyy-MM-dd'/>">
                                                        <i class="bi bi-pencil-square"></i>
                                                    </button>
                                                </td>

                                                <td>
                                                    <form action="${pageContext.request.contextPath}/Medicine/delete" method="post"
                                                          onsubmit="return confirm('Xóa thuốc này?');">
                                                        <input type="hidden" name="medicineCode" value="${m.medicineCode}">
                                                        <button type="submit" class="btn btn-danger btn-sm">
                                                            <i class="bi bi-trash"></i>
                                                        </button>
                                                    </form>
                                                </td>
                                            </c:if>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <div class="empty-state">
                            <h3>Không có thuốc nào</h3>
                            <p>Hãy thêm thuốc mới hoặc điều chỉnh bộ lọc tìm kiếm.</p>
                        </div>
                    </c:otherwise>
                </c:choose>


                <!-- Modal Add Medicine -->
                <div class="modal fade" id="addMedicineModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title"><i class="bi bi-plus-circle"></i> Add New Medicine</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>

                            <div class="modal-body">
                                <form method="post" action="${pageContext.request.contextPath}/Medicine/add">
                                    <div class="row g-3">
                                        <!-- Tên thuốc -->
                                        <div class="col-md-6">
                                            <label class="form-label">Tên thuốc</label>
                                            <input type="text" class="form-control" name="name" required>
                                        </div>

                                        <!-- Danh mục -->
                                        <div class="col-md-6">
                                            <label class="form-label">Danh mục</label>
                                            <select class="form-select" name="category" required>
                                                <option value="">-- Chọn danh mục thuốc --</option>
                                                <option>Vitamin & Khoáng chất</option>
                                                <option>Tim mạch</option>
                                                <option>Kháng sinh</option>
                                                <option>Hô hấp</option>
                                                <option>Nội tiết</option>
                                                <option>Tiêu hóa</option>
                                            </select>
                                        </div>

                                        <!-- Mô tả -->
                                        <div class="col-md-12">
                                            <label class="form-label">Mô tả</label>
                                            <textarea class="form-control" name="description" rows="2"></textarea>
                                        </div>

                                        <!-- Hoạt chất -->
                                        <div class="col-md-6">
                                            <label class="form-label">Hoạt chất</label>
                                            <input type="text" class="form-control" name="activeIngredient">
                                        </div>

                                        <!-- Dạng bào chế -->
                                        <div class="col-md-6">
                                            <label class="form-label">Dạng bào chế</label>
                                            <select class="form-select" name="dosageForm">
                                                <option value="">-- Chọn dạng bào chế --</option>
                                                <option>Viên nén</option>
                                                <option>Viên nhộng</option>
                                                <option>Dung dịch</option>
                                                <option>Siro</option>
                                                <option>Thuốc tiêm</option>
                                                <option>Thuốc mỡ</option>
                                            </select>
                                        </div>

                                        <!-- Hàm lượng, Đơn vị, Nhà sản xuất -->
                                        <div class="col-md-4">
                                            <label class="form-label">Hàm lượng</label>
                                            <select class="form-select" name="strength">
                                                <option value="">-- Chọn hàm lượng --</option>
                                                <option>10mg</option>
                                                <option>50mg</option>
                                                <option>100mg</option>
                                            </select>
                                        </div>

                                        <div class="col-md-4">
                                            <label class="form-label">Đơn vị</label>
                                            <select class="form-select" name="unit">
                                                <option value="">-- Chọn đơn vị --</option>
                                                <option>Viên</option>
                                                <option>Ống</option>
                                                <option>Chai</option>
                                                <option>Gói</option>
                                                <option>Tuýp</option>
                                            </select>
                                        </div>

                                        <div class="col-md-4">
                                            <label class="form-label">Nhà sản xuất</label>
                                            <input type="text" class="form-control" name="manufacturer" placeholder="Nhập tên nhà sản xuất" required>
                                        </div>

                                        <!-- Nhà cung cấp -->
                                        <div class="col-md-4">
                                            <label class="form-label">Nhà cung cấp</label>
                                            <select class="form-select" name="supplierId" required>
                                                <option value="">-- Chọn nhà cung cấp --</option>
                                                <c:forEach var="s" items="${supplierList}">
                                                    <option value="${s.supplierId}">${s.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <!-- Xuất xứ -->
                                        <div class="col-md-4">
                                            <label class="form-label">Xuất xứ</label>
                                            <select class="form-select" name="origin">
                                                <option value="">-- Chọn quốc gia --</option>
                                                <option>Việt Nam</option>
                                                <option>Mỹ</option>
                                                <option>Nhật Bản</option>
                                                <option>Hàn Quốc</option>
                                                <option>Pháp</option>
                                            </select>
                                        </div>

                                        <!-- Nhóm thuốc -->
                                        <div class="col-md-4">
                                            <label class="form-label">Nhóm thuốc</label>
                                            <select class="form-select" name="drugGroup">
                                                <option value="">-- Chọn nhóm thuốc --</option>
                                                <option>Điều trị ung thư</option>
                                                <option>Giảm đau - Hạ sốt</option>
                                                <option>Tim mạch</option>
                                                <option>Tiêu hóa</option>
                                                <option>Vitamin - Khoáng chất</option>
                                            </select>
                                        </div>

                                        <!-- Loại thuốc, tồn kho, hạn -->
                                        <div class="col-md-4">
                                            <label class="form-label">Loại thuốc</label>
                                            <select class="form-select" name="drugType">
                                                <option value="">-- Chọn loại thuốc --</option>
                                                <option>Đặc trị</option>
                                                <option>Bảo hiểm</option>
                                                <option>Khác</option>
                                            </select>
                                        </div>

                                        <div class="col-md-4">
                                            <label class="form-label">Tồn kho</label>
                                            <input type="number" class="form-control" name="stock" required>
                                        </div>

                                        <div class="col-md-4">
                                            <label class="form-label">Hạn sử dụng</label>
                                            <input type="date" class="form-control" name="expiryDate" required min="<%= java.time.LocalDate.now() %>">
                                        </div>
                                    </div>

                                    <div class="modal-footer mt-3">
                                        <button type="submit" class="btn btn-success">Save</button>
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Edit Medicine Modal -->
                <div class="modal fade" id="editMedicineModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title"><i class="bi bi-pencil-square"></i> Edit Medicine</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <form method="post" action="${pageContext.request.contextPath}/Medicine/update">
                                    <!-- Hidden fields -->
                                    <input type="hidden" name="medicineCode" id="edit-medicineCode">
                                    <input type="hidden" name="batchId" id="edit-batchId">

                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label class="form-label">Medicine Name</label>
                                            <input type="text" class="form-control" name="name" id="edit-name" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label">Category</label>
                                            <input type="text" class="form-control" name="category" id="edit-category" required>
                                        </div>
                                        <div class="col-md-12">
                                            <label class="form-label">Description</label>
                                            <textarea class="form-control" name="description" id="edit-description" rows="2"></textarea>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label">Active Ingredient</label>
                                            <input type="text" class="form-control" name="activeIngredient" id="edit-activeIngredient">
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label">Dosage Form</label>
                                            <input type="text" class="form-control" name="dosageForm" id="edit-dosageForm">
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label">Strength</label>
                                            <input type="text" class="form-control" name="strength" id="edit-strength">
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label">Unit</label>
                                            <input type="text" class="form-control" name="unit" id="edit-unit">
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label">Manufacturer</label>
                                            <input type="text" class="form-control" name="manufacturer" id="edit-manufacturer">
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label">Nhà cung cấp</label>
                                            <select class="form-select" name="supplierId" id="edit-supplierId" required>
                                                <option value="">-- Chọn nhà cung cấp --</option>
                                                <c:forEach var="s" items="${supplierList}">
                                                    <option value="${s.supplierId}">${s.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label">Origin</label>
                                            <input type="text" class="form-control" name="origin" id="edit-origin">
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label">Drug Group</label>
                                            <input type="text" class="form-control" name="drugGroup" id="edit-drugGroup">
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label">Drug Type</label>
                                            <input type="text" class="form-control" name="drugType" id="edit-drugType">
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label">Stock Quantity</label>
                                            <input type="number" class="form-control" name="stock" id="edit-stock">
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label">Expiry Date</label>
                                            <input type="date" class="form-control" name="expiryDate" id="edit-expiryDate"
                                                   min="<%= java.time.LocalDate.now() %>">
                                        </div>
                                    </div>

                                    <div class="modal-footer mt-3">
                                        <button type="submit" class="btn btn-success">Update</button>
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <%@ include file="/admin/footer.jsp" %>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

                <script>
                                                              const editModal = document.getElementById('editMedicineModal');
                                                              editModal.addEventListener('show.bs.modal', function (event) {
                                                                  const button = event.relatedTarget; // Nút bấm mở modal
                                                                  const dataset = button.dataset;

                                                                  document.getElementById('edit-medicineCode').value = dataset.medicinecode;
                                                                  document.getElementById('edit-batchId').value = dataset.batchid;
                                                                  document.getElementById('edit-supplierId').value = dataset.supplierid;
                                                                  document.getElementById('edit-name').value = dataset.name;
                                                                  document.getElementById('edit-category').value = dataset.category;
                                                                  document.getElementById('edit-description').value = dataset.description;
                                                                  document.getElementById('edit-activeIngredient').value = dataset.activeingredient;
                                                                  document.getElementById('edit-dosageForm').value = dataset.dosageform;
                                                                  document.getElementById('edit-strength').value = dataset.strength;
                                                                  document.getElementById('edit-unit').value = dataset.unit;
                                                                  document.getElementById('edit-manufacturer').value = dataset.manufacturer;
                                                                  document.getElementById('edit-origin').value = dataset.origin;
                                                                  document.getElementById('edit-drugGroup').value = dataset.druggroup;
                                                                  document.getElementById('edit-drugType').value = dataset.drugtype;
                                                                  document.getElementById('edit-stock').value = dataset.stock;
                                                                  document.getElementById('edit-expiryDate').value = dataset.expirydate;
                                                              });

                                                              // Script cho Filter Dropdown
                                                              document.addEventListener("DOMContentLoaded", function () {
                                                                  const filterOptions = document.querySelectorAll(".filter-option");
                                                                  const filterButton = document.getElementById("filterButton");

                                                                  // 4 hidden inputs
                                                                  const filterCategory = document.getElementById("filterCategory");
                                                                  const filterActiveIngredient = document.getElementById("filterActiveIngredient");
                                                                  const filterDrugGroup = document.getElementById("filterDrugGroup");
                                                                  const filterDrugType = document.getElementById("filterDrugType");

                                                                  function updateButtonText() {
                                                                      // Chỉ lấy những giá trị đã chọn, bỏ "All" hoặc rỗng
                                                                      const values = [
                                                                          filterCategory.value,
                                                                          filterActiveIngredient.value,
                                                                          filterDrugGroup.value,
                                                                          filterDrugType.value
                                                                      ].filter(v => v && v.toLowerCase() !== "all");

                                                                      filterButton.textContent = values.length > 0 ? values.join(" | ") : "Chọn tiêu chí lọc";
                                                                  }

                                                                  filterOptions.forEach(option => {
                                                                      option.addEventListener("click", function (e) {
                                                                          e.preventDefault();
                                                                          e.stopPropagation(); // Ngăn sự kiện lan truyền

                                                                          const type = this.dataset.type;
                                                                          const value = this.innerText.trim();

                                                                          // Set value vào hidden input
                                                                          switch (type) {
                                                                              case "category":
                                                                                  filterCategory.value = value;
                                                                                  break;
                                                                              case "activeIngredient":
                                                                                  filterActiveIngredient.value = value;
                                                                                  break;
                                                                              case "drugGroup":
                                                                                  filterDrugGroup.value = value;
                                                                                  break;
                                                                              case "drugType":
                                                                                  filterDrugType.value = value;
                                                                                  break;
                                                                          }

                                                                          updateButtonText();

                                                                          // Đóng tất cả dropdown
                                                                          document.querySelectorAll('.dropdown-menu').forEach(menu => menu.classList.remove('show'));
                                                                      });
                                                                  });

                                                                  // Khởi tạo hiển thị ban đầu
                                                                  updateButtonText();
                                                              });

                </script>
                </body>
                </html>
