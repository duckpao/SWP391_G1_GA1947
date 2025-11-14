<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Medicine Details</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/sidebar.css" rel="stylesheet">

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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

            

            .main {
                flex: 1;
                padding: 30px;
                background-color: #f9fafb;
            }

            h1 {
                font-size: 28px;
                margin-bottom: 25px;
                font-weight: 700;
                color: #1f2937;
            }

            /* Search Container */
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
                transition: all 0.3s ease;
            }

            .form-control:focus, .form-select:focus {
                border-color: #6b7280;
                box-shadow: 0 0 0 3px rgba(107, 114, 128, 0.1);
                outline: none;
            }

            /* Buttons */
            .btn {
                padding: 10px 20px;
                border-radius: 8px;
                font-weight: 600;
                font-size: 14px;
                transition: all 0.3s ease;
                border: none;
            }

            .btn-success {
                background-color: #6b7280;
                color: white;
            }

            .btn-success:hover {
                background-color: #4b5563;
                transform: translateY(-2px);
            }

            .btn-secondary {
                background-color: #9ca3af;
                color: white;
            }

            .btn-warning {
                background-color: #f59e0b;
                color: white;
            }

            .btn-danger {
                background-color: #ef4444;
                color: white;
            }

            /* Table Card */
            .card {
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
                border: none;
                margin-bottom: 24px;
            }

            .card-header {
                background: linear-gradient(135deg, #6b7280 0%, #4b5563 100%);
                color: white;
                padding: 16px 24px;
                border-radius: 12px 12px 0 0;
                border: none;
            }

            .card-header h5 {
                margin: 0;
                font-weight: 600;
                font-size: 16px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .badge {
                background-color: rgba(255, 255, 255, 0.2);
                padding: 4px 10px;
                border-radius: 12px;
                font-size: 13px;
                margin-left: 8px;
            }

            /* Table Styling */
            .table-responsive {
                border-radius: 0 0 12px 12px;
                overflow: hidden;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin: 0;
            }

            thead {
                background-color: #f9fafb;
            }

            th {
                padding: 14px 16px;
                font-weight: 600;
                font-size: 13px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                color: #6b7280;
                border-bottom: 2px solid #e5e7eb;
                text-align: left;
            }

            tbody tr {
                transition: all 0.2s ease;
                border-bottom: 1px solid #e5e7eb;
            }

            tbody tr:hover {
                background-color: #f9fafb;
            }

            td {
                padding: 14px 16px;
                font-size: 14px;
                vertical-align: middle;
            }

            /* Dropdown Detail Row */
            .detail-row {
                display: none;
                background-color: #f9fafb;
            }

            .detail-row.show {
                display: table-row;
            }

            .detail-content {
                padding: 20px 24px;
                border-top: 2px solid #e5e7eb;
            }

            .detail-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 16px;
            }

            .detail-item {
                background: white;
                padding: 12px 16px;
                border-radius: 8px;
                border-left: 3px solid #6b7280;
            }

            .detail-label {
                font-size: 12px;
                font-weight: 600;
                color: #6b7280;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                margin-bottom: 4px;
            }

            .detail-value {
                font-size: 14px;
                color: #1f2937;
                font-weight: 500;
            }

            /* Status Badges */
            .status-badge {
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                display: inline-block;
            }

            .status-in-stock {
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

            /* Action Buttons */
            .btn-sm {
                padding: 6px 12px;
                font-size: 13px;
            }

            .btn-view {
                background-color: #3b82f6;
                color: white;
                border: none;
                transition: all 0.2s ease;
            }

            .btn-view:hover {
                background-color: #2563eb;
                transform: translateY(-1px);
            }

            .btn-view i {
                transition: transform 0.3s ease;
            }

            .btn-view.active i {
                transform: rotate(180deg);
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

            /* Dropdown styling */
            .dropdown-submenu {
                position: relative;
            }

            .dropdown-submenu > .submenu {
                display: none;
                position: absolute;
                left: 100%;
                top: 0;
            }

            .dropdown-submenu:hover > .submenu {
                display: block;
            }

            #filterButton {
                text-align: left;
                height: 42px;
                background-color: white !important;
                color: #374151 !important;
                border: 2px solid #e5e7eb !important;
            }

            #filterButton:hover {
                border-color: #6b7280 !important;
            }

            /* Modal Styling */
            .modal-content {
                border-radius: 16px;
                overflow: hidden;
                border: none;
                box-shadow: 0 10px 28px rgba(0, 0, 0, 0.25);
            }

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

            .modal-body {
                background-color: #f8f9fa;
                padding: 28px;
            }

            .form-label {
                font-weight: 600;
                color: #2d2d2d;
                margin-bottom: 5px;
            }

            .modal-footer {
                background-color: #f1f3f5;
                border-top: none;
                padding: 1rem 1.5rem;
            }

            .collapse-icon {
                transition: transform 0.3s ease;
                font-size: 12px;
            }

            .btn-link[aria-expanded="true"] .collapse-icon {
                transform: rotate(90deg);
            }

            .btn-link {
                color: #374151 !important;
                font-size: 14px;
            }

            .btn-link:hover {
                color: #6b7280 !important;
            }

            /* Style cho các option item */
            .filter-option {
                font-size: 13px;
                padding: 6px 12px;
                transition: all 0.2s ease;
            }

            .filter-option:hover {
                background-color: #f3f4f6;
                color: #6b7280;
            }

            /* Dropdown menu style */
            .dropdown-menu {
                border: 2px solid #e5e7eb;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            }

            #editMedicineModal .modal-header {
                background: linear-gradient(120deg, #0d6efd, #1a73e8);
            }

            /* Responsive */
            @media (max-width: 768px) {
                .page-wrapper {
                    flex-direction: column;
                }

                .sidebar {
                    width: 100%;
                }

                .detail-grid {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>

    <body>
        <%@ include file="/admin/header.jsp" %>

        <div class="page-wrapper">
    <%@ include file="/pharmacist/sidebar.jsp" %>

            <!-- Main Content -->
            <div class="main">
                <h1><i class="bi bi-capsule"></i> Medicine Management</h1>

                <!-- Search Container - FIXED: Restored original form structure -->
                <div class="search-container">
    <form action="${pageContext.request.contextPath}/view-medicine" method="get" class="row g-3">
        <!-- Keyword Search -->
        <div class="col-md-3">
            <input type="text" name="keyword" value="${keyword}"
                   placeholder="🔍 Tìm kiếm thuốc..." class="form-control">
        </div>

        <!-- Filter 1: Category -->
        <div class="col-md-2">
            <select name="category" class="form-select">
                <option value="">Tất cả danh mục</option>
                <c:forEach var="cat" items="${categories}">
                    <c:if test="${cat ne 'All'}">
                        <option value="${cat}" ${selectedCategory eq cat ? 'selected' : ''}>
                            ${cat}
                        </option>
                    </c:if>
                </c:forEach>
            </select>
        </div>

        <!-- Filter 2: Active Ingredient -->
        <div class="col-md-2">
            <select name="activeIngredient" class="form-select">
                <option value="">Tất cả hoạt chất</option>
                <c:forEach var="ai" items="${activeIngredients}">
                    <c:if test="${ai ne 'All'}">
                        <option value="${ai}" ${selectedActiveIngredient eq ai ? 'selected' : ''}>
                            ${ai}
                        </option>
                    </c:if>
                </c:forEach>
            </select>
        </div>

        <!-- Filter 3: Drug Group -->
        <div class="col-md-2">
            <select name="drugGroup" class="form-select">
                <option value="">Tất cả nhóm thuốc</option>
                <c:forEach var="dg" items="${drugGroups}">
                    <c:if test="${dg ne 'All'}">
                        <option value="${dg}" ${selectedDrugGroup eq dg ? 'selected' : ''}>
                            ${dg}
                        </option>
                    </c:if>
                </c:forEach>
            </select>
        </div>

        <!-- Filter 4: Drug Type -->
        <div class="col-md-2">
            <select name="drugType" class="form-select">
                <option value="">Tất cả loại thuốc</option>
                <c:forEach var="dt" items="${drugTypes}">
                    <c:if test="${dt ne 'All'}">
                        <option value="${dt}" ${selectedDrugType eq dt ? 'selected' : ''}>
                            ${dt}
                        </option>
                    </c:if>
                </c:forEach>
            </select>
        </div>

        <!-- Status Filter -->
        <div class="col-md-1">
            <select name="status" class="form-select">
                <option value="" ${selectedStatus == '' ? 'selected' : ''}>Tất cả</option>
                <option value="In Stock" ${selectedStatus == 'In Stock' ? 'selected' : ''}>Còn hàng</option>
                <option value="Low Stock" ${selectedStatus == 'Low Stock' ? 'selected' : ''}>Sắp hết</option>
                <option value="Out of Stock" ${selectedStatus == 'Out of Stock' ? 'selected' : ''}>Hết hàng</option>
            </select>
        </div>

        <!-- Action Buttons -->
        <div class="col-md-12 d-flex gap-2 mt-2">
            <button type="submit" class="btn btn-success">
                <i class="bi bi-search"></i> Tìm kiếm
            </button>
            <a href="${pageContext.request.contextPath}/view-medicine" class="btn btn-secondary">
                <i class="bi bi-arrow-clockwise"></i> Reset
            </a>
        </div>
    </form>
</div>

                <!-- Action Buttons - FIXED: Added Admin role check -->
                <div class="d-flex mb-3 gap-2">
                    <c:if test="${sessionScope.role eq 'Doctor' or sessionScope.role eq 'Admin'}">
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

                    <c:if test="${sessionScope.role eq 'Pharmacist' or sessionScope.role eq 'Admin'}">
                        <button class="btn btn-success ms-auto" data-bs-toggle="modal" data-bs-target="#addMedicineModal">
                            <i class="bi bi-plus-circle"></i> Add Medicine
                        </button>
                    </c:if>
                </div>

                <!-- Results Card -->
                <div class="card">
                    <div class="card-header">
                        <h5>
                            <i class="bi bi-list-ul"></i> Medicine List
                            <span class="badge">${medicines != null ? medicines.size() : 0}</span>
                        </h5>
                    </div>
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${not empty medicines}">
                                <div class="table-responsive">
                                    <table>
                                        <thead>
                                            <tr>
                                                <th style="width: 50px;"></th>
                                                <th>Medicine Code</th>
                                                <th>Medicine Name</th>
                                                <th>Category</th>
                                                <th>Total Batches</th>
                                                <th>Total Qty</th>
                                                <th>Approved Qty</th>
                                                <th>Nearest Expiry</th>
                                                <th>Last Received</th>
                                                    <c:if test="${sessionScope.role eq 'Pharmacist' or sessionScope.role eq 'Admin'}">
                                                    <th>Actions</th>
                                                    </c:if>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="m" items="${medicines}" varStatus="status">
                                                <tr>
                                                    <td>
                                                        <button class="btn btn-view btn-sm toggle-detail" 
                                                                data-target="detail-${status.index}">
                                                            <i class="bi bi-eye"></i>
                                                        </button>
                                                    </td>
                                                    <td><strong>${m.medicineCode}</strong></td>
                                                    <td>${m.name}</td>
                                                    <td><span class="badge bg-secondary">${m.category}</span></td>
                                                    <td>
                                                        <span class="badge bg-primary">
                                                            <c:choose>
                                                                <c:when test="${not empty m.batches}">
                                                                    ${m.batches.size()}
                                                                </c:when>
                                                                <c:otherwise>0</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <strong>
                                                            <c:set var="totalQty" value="0"/>
                                                            <c:forEach var="b" items="${m.batches}">
                                                                <c:set var="totalQty" value="${totalQty + b.currentQuantity}"/>
                                                            </c:forEach>
                                                            ${totalQty}
                                                        </strong>
                                                    </td>
                                                    <td>
                                                        <span class="status-badge status-in-stock">
                                                            <c:set var="approvedQty" value="0"/>
                                                            <c:forEach var="b" items="${m.batches}">
                                                                <c:if test="${b.status eq 'Approved'}">
                                                                    <c:set var="approvedQty" value="${approvedQty + b.currentQuantity}"/>
                                                                </c:if>
                                                            </c:forEach>
                                                            ${approvedQty}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty m.batches}">
                                                                <c:set var="nearestExpiry" value="${null}"/>
                                                                <c:forEach var="b" items="${m.batches}">
                                                                    <c:if test="${b.expiryDate ne null}">
                                                                        <c:choose>
                                                                            <c:when test="${nearestExpiry eq null or b.expiryDate.time < nearestExpiry.time}">
                                                                                <c:set var="nearestExpiry" value="${b.expiryDate}"/>
                                                                            </c:when>
                                                                        </c:choose>
                                                                    </c:if>
                                                                </c:forEach>
                                                                <c:choose>
                                                                    <c:when test="${nearestExpiry ne null}">
                                                                        <fmt:formatDate value="${nearestExpiry}" pattern="dd/MM/yyyy"/>
                                                                    </c:when>
                                                                    <c:otherwise>-</c:otherwise>
                                                                </c:choose>
                                                            </c:when>
                                                            <c:otherwise>-</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty m.batches}">
                                                                <c:set var="lastReceived" value="${null}"/>
                                                                <c:forEach var="b" items="${m.batches}">
                                                                    <c:if test="${b.receivedDate ne null}">
                                                                        <c:choose>
                                                                            <c:when test="${lastReceived eq null or b.receivedDate.time > lastReceived.time}">
                                                                                <c:set var="lastReceived" value="${b.receivedDate}"/>
                                                                            </c:when>
                                                                        </c:choose>
                                                                    </c:if>
                                                                </c:forEach>
                                                                <c:choose>
                                                                    <c:when test="${lastReceived ne null}">
                                                                        <fmt:formatDate value="${lastReceived}" pattern="dd/MM/yyyy"/>
                                                                    </c:when>
                                                                    <c:otherwise>-</c:otherwise>
                                                                </c:choose>
                                                            </c:when>
                                                            <c:otherwise>-</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <c:if test="${sessionScope.role eq 'Pharmacist' or sessionScope.role eq 'Admin'}">
                                                        <td>
                                                            <button class="btn btn-warning btn-sm edit-btn" data-bs-toggle="modal"
                                                                    data-bs-target="#editMedicineModal"
                                                                    data-medicinecode="${m.medicineCode}"
                                                                    data-batchid="${not empty m.batches ? m.batches[0].batchId : ''}"
                                                                    data-supplierid="${not empty m.batches ? m.batches[0].supplierId : ''}"
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
                                                                    data-stock="${not empty m.batches ? m.batches[0].currentQuantity : 0}"
                                                                    data-expirydate="<fmt:formatDate value='${not empty m.batches ? m.batches[0].expiryDate : null}' pattern='yyyy-MM-dd'/>">
                                                                <i class="bi bi-pencil"></i>
                                                            </button>
                                                            <form action="${pageContext.request.contextPath}/Medicine/delete" method="post" 
                                                                  style="display:inline;" onsubmit="return confirm('Xóa thuốc này?');">
                                                                <input type="hidden" name="medicineCode" value="${m.medicineCode}">
                                                                <button type="submit" class="btn btn-danger btn-sm">
                                                                    <i class="bi bi-trash"></i>
                                                                </button>
                                                            </form>
                                                        </td>
                                                    </c:if>
                                                </tr>
                                                <tr class="detail-row" id="detail-${status.index}">
                                                    <td colspan="11">
                                                        <div class="detail-content">
                                                            <div class="detail-grid">
                                                                <div class="detail-item">
                                                                    <div class="detail-label">Mô tả</div>
                                                                    <div class="detail-value">${m.description}</div>
                                                                </div>
                                                                <div class="detail-item">
                                                                    <div class="detail-label">Hoạt chất</div>
                                                                    <div class="detail-value">${m.activeIngredient}</div>
                                                                </div>
                                                                <div class="detail-item">
                                                                    <div class="detail-label">Dạng bào chế</div>
                                                                    <div class="detail-value">${m.dosageForm}</div>
                                                                </div>
                                                                <div class="detail-item">
                                                                    <div class="detail-label">Hàm lượng</div>
                                                                    <div class="detail-value">${m.strength}</div>
                                                                </div>
                                                                <div class="detail-item">
                                                                    <div class="detail-label">Đơn vị</div>
                                                                    <div class="detail-value">${m.unit}</div>
                                                                </div>
                                                                <div class="detail-item">
                                                                    <div class="detail-label">Nhà sản xuất</div>
                                                                    <div class="detail-value">${m.manufacturer}</div>
                                                                </div>
                                                                <div class="detail-item">
                                                                    <div class="detail-label">Nhà cung cấp</div>
                                                                    <div class="detail-value">${m.supplierName}</div>
                                                                </div>
                                                                <div class="detail-item">
                                                                    <div class="detail-label">Xuất xứ</div>
                                                                    <div class="detail-value">${m.countryOfOrigin}</div>
                                                                </div>
                                                                <div class="detail-item">
                                                                    <div class="detail-label">Nhóm thuốc</div>
                                                                    <div class="detail-value">${m.drugGroup}</div>
                                                                </div>
                                                                <div class="detail-item">
                                                                    <div class="detail-label">Loại thuốc</div>
                                                                    <div class="detail-value">${m.drugType}</div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <i class="bi bi-inbox"></i>
                                    <h3>No medicines found</h3>
                                    <p>Try adjusting your search filters</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

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
                                                                      // Toggle detail row
                                                                      document.querySelectorAll('.toggle-detail').forEach(btn => {
                                                                          btn.addEventListener('click', function () {
                                                                              const targetId = this.dataset.target;
                                                                              const detailRow = document.getElementById(targetId);

                                                                              detailRow.classList.toggle('show');
                                                                              this.classList.toggle('active');
                                                                          });
                                                                      });

                                                                      // Filter dropdown logic - FIXED
                                                                      document.addEventListener("DOMContentLoaded", function () {
                                                                          const filterOptions = document.querySelectorAll(".filter-option");
                                                                          const filterButton = document.getElementById("filterButton");

                                                                          // 4 hidden inputs
                                                                          const filterCategory = document.getElementById("filterCategory");
                                                                          const filterActiveIngredient = document.getElementById("filterActiveIngredient");
                                                                          const filterDrugGroup = document.getElementById("filterDrugGroup");
                                                                          const filterDrugType = document.getElementById("filterDrugType");

                                                                          function updateButtonText() {
                                                                              // Lấy những giá trị đã chọn, bỏ rỗng
                                                                              const values = [
                                                                                  filterCategory.value,
                                                                                  filterActiveIngredient.value,
                                                                                  filterDrugGroup.value,
                                                                                  filterDrugType.value
                                                                              ].filter(v => v && v.trim() !== '');

                                                                              filterButton.textContent = values.length > 0 ? values.join(" | ") : "Chọn tiêu chí lọc";
                                                                          }

                                                                          filterOptions.forEach(option => {
                                                                              option.addEventListener("click", function (e) {
                                                                                  e.preventDefault();
                                                                                  e.stopPropagation();

                                                                                  const type = this.dataset.type;
                                                                                  const value = this.innerText.trim();

                                                                                  // Clear tất cả filters trước
                                                                                  filterCategory.value = '';
                                                                                  filterActiveIngredient.value = '';
                                                                                  filterDrugGroup.value = '';
                                                                                  filterDrugType.value = '';

                                                                                  // Set value vào hidden input tương ứng
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

                                                                                  // Đóng dropdown
                                                                                  const dropdownMenu = this.closest('.dropdown-menu');
                                                                                  const dropdown = bootstrap.Dropdown.getInstance(filterButton);
                                                                                  if (dropdown) {
                                                                                      dropdown.hide();
                                                                                  }
                                                                              });
                                                                          });

                                                                          // Khởi tạo hiển thị ban đầu
                                                                          updateButtonText();
                                                                      });

                                                                      // Edit Modal Handler - FIXED
                                                                      const editModal = document.getElementById('editMedicineModal');
                                                                      if (editModal) {
                                                                          editModal.addEventListener('show.bs.modal', function (event) {
                                                                              const button = event.relatedTarget;
                                                                              if (!button)
                                                                                  return;

                                                                              const dataset = button.dataset;

                                                                              document.getElementById('edit-medicineCode').value = dataset.medicinecode || '';
                                                                              document.getElementById('edit-batchId').value = dataset.batchid || '';
                                                                              document.getElementById('edit-supplierId').value = dataset.supplierid || '';
                                                                              document.getElementById('edit-name').value = dataset.name || '';
                                                                              document.getElementById('edit-category').value = dataset.category || '';
                                                                              document.getElementById('edit-description').value = dataset.description || '';
                                                                              document.getElementById('edit-activeIngredient').value = dataset.activeingredient || '';
                                                                              document.getElementById('edit-dosageForm').value = dataset.dosageform || '';
                                                                              document.getElementById('edit-strength').value = dataset.strength || '';
                                                                              document.getElementById('edit-unit').value = dataset.unit || '';
                                                                              document.getElementById('edit-manufacturer').value = dataset.manufacturer || '';
                                                                              document.getElementById('edit-origin').value = dataset.origin || '';
                                                                              document.getElementById('edit-drugGroup').value = dataset.druggroup || '';
                                                                              document.getElementById('edit-drugType').value = dataset.drugtype || '';
                                                                              document.getElementById('edit-stock').value = dataset.stock || '';

                                                                              // Format date properly
                                                                              if (dataset.expirydate && dataset.expirydate !== 'null') {
                                                                                  document.getElementById('edit-expiryDate').value = dataset.expirydate;
                                                                              } else {
                                                                                  document.getElementById('edit-expiryDate').value = '';
                                                                              }
                                                                          });
                                                                      }

                                                                      document.addEventListener("DOMContentLoaded", function () {
                                                                          const filterOptions = document.querySelectorAll(".filter-option");
                                                                          const filterButton = document.getElementById("filterButton");

                                                                          // 4 hidden inputs
                                                                          const filterCategory = document.getElementById("filterCategory");
                                                                          const filterActiveIngredient = document.getElementById("filterActiveIngredient");
                                                                          const filterDrugGroup = document.getElementById("filterDrugGroup");
                                                                          const filterDrugType = document.getElementById("filterDrugType");

                                                                          function updateButtonText() {
                                                                              const values = [
                                                                                  filterCategory.value,
                                                                                  filterActiveIngredient.value,
                                                                                  filterDrugGroup.value,
                                                                                  filterDrugType.value
                                                                              ].filter(v => v && v.trim() !== '');

                                                                              filterButton.textContent = values.length > 0 ? values.join(" | ") : "Chọn tiêu chí lọc";
                                                                          }

                                                                          filterOptions.forEach(option => {
                                                                              option.addEventListener("click", function (e) {
                                                                                  e.preventDefault();
                                                                                  e.stopPropagation();

                                                                                  const type = this.dataset.type;
                                                                                  const value = this.dataset.value;

                                                                                  // Clear tất cả filters trước
                                                                                  filterCategory.value = '';
                                                                                  filterActiveIngredient.value = '';
                                                                                  filterDrugGroup.value = '';
                                                                                  filterDrugType.value = '';

                                                                                  // Set value vào hidden input tương ứng
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

                                                                                  // Đóng dropdown
                                                                                  const dropdown = bootstrap.Dropdown.getInstance(filterButton);
                                                                                  if (dropdown) {
                                                                                      dropdown.hide();
                                                                                  }
                                                                              });
                                                                          });

                                                                          // Khởi tạo hiển thị ban đầu
                                                                          updateButtonText();
                                                                      });
        </script>
    </body>
</html>