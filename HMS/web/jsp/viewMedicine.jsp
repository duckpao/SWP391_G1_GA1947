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
        <!-- Added Google Fonts for better typography -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

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
                background-color: #ffffff;
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
                font-size: 14px;
                line-height: 1.5;
                color: #333;
            }

            .page-wrapper {
                display: flex;
                flex: 1;
                min-height: calc(100vh - 60px);
            }

            /* Updated sidebar to white theme with light border, similar to Auditor design */
            .sidebar {
                width: 250px;
                background-color: #ffffff;
                color: #6c757d;
                display: flex;
                flex-direction: column;
                padding-top: 15px;
                border-right: 1px solid #e9ecef;
                box-shadow: none;
            }

            .menu a {
                display: flex;
                align-items: center;
                padding: 12px 25px;
                color: #6c757d;
                text-decoration: none;
                font-size: 14px;
                font-weight: 500;
                transition: all 0.3s ease;
                border-left: 3px solid transparent;
                border-radius: 0;
            }

            .menu a i {
                width: 20px;
                margin-right: 10px;
                color: #6c757d;
            }

            /* Active menu item now has light blue background instead of dark */
            .menu a:hover {
                background-color: #f0f7ff;
                color: #495057;
                border-left-color: transparent;
                padding-left: 25px;
            }

            .menu a.active {
                background-color: #e7f1ff;
                color: #0066cc;
                border-left-color: #0066cc;
                padding-left: 22px;
            }

            .menu a.active i {
                color: #0066cc;
            }

            .main {
                flex: 1;
                padding: 30px;
                background-color: #ffffff;
                overflow-y: auto;
            }

            h1 {
                font-size: 28px;
                margin-bottom: 25px;
                font-weight: 700;
                color: #1a1a1a;
                letter-spacing: -0.5px;
            }

            .search-container {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 10px;
                border: 1px solid #e0e0e0;
                margin-bottom: 25px;
            }

            .search-form {
                display: grid;
                grid-template-columns: 2fr 1fr 1fr auto auto;
                gap: 15px;
                align-items: end;
            }

            .form-control, .form-select {
                border: 1px solid #ddd;
                border-radius: 6px;
                padding: 10px 12px;
                font-size: 14px;
                transition: all 0.3s ease;
            }

            .form-control:focus, .form-select:focus {
                border-color: #6c757d;
                box-shadow: 0 0 0 3px rgba(108, 117, 125, 0.1);
            }

            table {
                background: white;
                border-collapse: collapse;
                width: 100%;
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 1px 3px rgba(0,0,0,0.08);
            }

            /* Table header now uses light gray instead of dark gray */
            thead {
                background-color: #f8f9fa;
                color: #495057;
                border-bottom: 2px solid #dee2e6;
            }

            thead th {
                font-weight: 600;
                font-size: 13px;
                letter-spacing: 0.3px;
                text-transform: uppercase;
                padding: 14px 12px;
                color: #495057;
            }

            tbody td {
                padding: 12px;
                border-bottom: 1px solid #f0f0f0;
                font-size: 14px;
            }

            tbody tr:hover {
                background-color: #f8f9fa;
            }

            tbody tr:last-child td {
                border-bottom: none;
            }

            .status-badge {
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
            }

            .status-approved {
                background: #d4edda;
                color: #155724;
            }
            .status-low {
                background: #fff3cd;
                color: #856404;
            }
            .status-out {
                background: #f8d7da;
                color: #721c24;
            }

            .empty-state {
                text-align: center;
                color: #777;
                padding: 50px;
            }

            /* Updated button colors to gray theme */
            .btn-success {
                background-color: #6c757d;
                border-color: #6c757d;
                color: white;
                font-weight: 600;
                padding: 10px 16px;
                border-radius: 6px;
                transition: all 0.3s ease;
            }

            .btn-success:hover {
                background-color: #5a6268;
                border-color: #5a6268;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(108, 117, 125, 0.2);
                color: white;
            }

            .btn-warning {
                background-color: #6c757d;
                border-color: #6c757d;
                color: white;
                font-weight: 600;
                padding: 6px 12px;
                border-radius: 6px;
                transition: all 0.3s ease;
            }

            .btn-warning:hover {
                background-color: #5a6268;
                border-color: #5a6268;
                color: white;
            }

            .btn-secondary {
                background-color: #e9ecef;
                border-color: #e9ecef;
                color: #495057;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .btn-secondary:hover {
                background-color: #dee2e6;
                border-color: #dee2e6;
                color: #495057;
            }

            .btn-danger {
                background-color: #dc3545;
                border-color: #dc3545;
                transition: all 0.3s ease;
            }

            .btn-danger:hover {
                background-color: #c82333;
                border-color: #c82333;
            }

            .modal-header {
                background-color: #f8f9fa;
                border-bottom: 2px solid #e0e0e0;
            }

            .modal-title {
                font-weight: 700;
                color: #1a1a1a;
            }

            .card {
                border: 1px solid #e0e0e0;
                border-radius: 8px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.08);
            }

            .d-flex {
                gap: 10px;
            }
        </style>
    </head>

    <body>
        <%@ include file="header.jsp" %>

        <div class="page-wrapper">
            <div class="sidebar">
                <div class="menu">
                    <a href="${pageContext.request.contextPath}/view-medicine" class="active"><i class="fa fa-pills"></i> Quản lý thuốc</a>
                    <a href="${pageContext.request.contextPath}/create-request"><i class="fa fa-file-medical"></i> Yêu cầu thuốc</a>
                    <a href="${pageContext.request.contextPath}/pharmacist/manage-batch"><i class="fa fa-warehouse"></i> Quản lý số lô/lô hàng</a>
                    <a href="${pageContext.request.contextPath}/pharmacist/recordExpiredDamaged"><i class="fa fa-user-md"></i> thuốc hết hạn/hư hỏng</a>
                    <a href="${pageContext.request.contextPath}/report"><i class="fa fa-chart-line"></i> Báo cáo thống kê</a>
                </div>
            </div>

            <div class="main">
                <h1>Medicine Details</h1>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

                <div class="card p-3 mb-4">
                    <form action="${pageContext.request.contextPath}/view-medicine" method="get" class="row g-2 align-items-center">
                        <div class="col-md-4">
                            <input type="text" name="keyword" value="${keyword}" placeholder="🔍 Tìm kiếm thuốc..."
                                   class="form-control">
                        </div>

                        <div class="col-md-3">
                            <select name="category" class="form-select">
                                <option value="All" ${selectedCategory == 'All' ? 'selected' : ''}>Tất cả loại</option>
                                <c:forEach var="cat" items="${categories}">
                                    <option value="${cat}" ${selectedCategory == cat ? 'selected' : ''}>${cat}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-3">
                            <select name="status" class="form-select">
                                <option value="" ${selectedStatus == '' ? 'selected' : ''}>Tất cả trạng thái</option>
                                <option value="In Stock" ${selectedStatus == 'In Stock' ? 'selected' : ''}>Còn nhiều</option>
                                <option value="Low Stock" ${selectedStatus == 'Low Stock' ? 'selected' : ''}>Sắp hết</option>
                                <option value="Out of Stock" ${selectedStatus == 'Out of Stock' ? 'selected' : ''}>Hết hàng</option>
                            </select>
                        </div>

                        <div class="col-md-2 d-flex gap-2">
                            <button type="submit" class="btn btn-success flex-fill">Tìm kiếm</button>
                            <a href="${pageContext.request.contextPath}/view-medicine" class="btn btn-secondary flex-fill">Reset</a>
                        </div>
                    </form>
                </div>

                <div class="d-flex mb-3">
                    <c:if test="${sessionScope.role eq 'Doctor'}">
                        <a href="${pageContext.request.contextPath}/create-request" class="btn btn-success">📝 Create Request</a>
                    </c:if>
                    <c:if test="${sessionScope.role eq 'Pharmacist'}">
                        <button class="btn btn-success ms-auto" data-bs-toggle="modal" data-bs-target="#addMedicineModal">➕ Add New Medicine</button>
                    </c:if>
                </div>

                <c:choose>
                    <c:when test="${not empty medicines}">
                        <table class="table table-bordered table-striped align-middle text-center">
                            <thead>
                                <tr>
                                    <th>Mã thuốc</th>
                                    <th>Tên thuốc</th>
                                    <th>Loại</th>
                                    <th>Mô tả</th>
                                    <th>Hoạt chất</th>
                                    <th>Dạng bào chế</th>
                                    <th>Hàm lượng</th>
                                    <th>Đơn vị</th>
                                    <th>Nhà sản xuất</th>
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
                                                        data-id="${m.medicineCode}"
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
                                                    <button type="submit" class="btn btn-danger btn-sm">🗑</button>
                                                </form>
                                            </td>
                                        </c:if>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>

                    <c:otherwise>
                        <div class="empty-state text-center mt-3">
                            <h3>Không có thuốc nào</h3>
                            <p>Hãy thêm thuốc mới hoặc điều chỉnh bộ lọc tìm kiếm.</p>
                        </div>
                    </c:otherwise>
                </c:choose>

                <div class="modal fade" id="addMedicineModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">➕ Add New Medicine</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>

                            <div class="modal-body">
                                <form method="post" action="${pageContext.request.contextPath}/Medicine/add">
                                    <div class="row g-3">

                                        <div class="col-md-6">
                                            <label class="form-label">Tên thuốc</label>
                                            <input type="text" class="form-control" name="name" required>
                                        </div>

                                        <div class="col-md-6">
                                            <label class="form-label">Loại</label>
                                            <input type="text" class="form-control" name="category" required>
                                        </div>

                                        <div class="col-md-12">
                                            <label class="form-label">Mô tả</label>
                                            <textarea class="form-control" name="description" rows="2"></textarea>
                                        </div>

                                        <div class="col-md-6">
                                            <label class="form-label">Hoạt chất</label>
                                            <input type="text" class="form-control" name="activeIngredient">
                                        </div>

                                        <div class="col-md-6">
                                            <label class="form-label">Dạng bào chế</label>
                                            <input type="text" class="form-control" name="dosageForm">
                                        </div>

                                        <div class="col-md-4">
                                            <label class="form-label">Hàm lượng</label>
                                            <input type="text" class="form-control" name="strength">
                                        </div>

                                        <div class="col-md-4">
                                            <label class="form-label">Đơn vị</label>
                                            <input type="text" class="form-control" name="unit">
                                        </div>

                                        <div class="col-md-4">
                                            <label class="form-label">Nhà sản xuất</label>
                                            <input type="text" class="form-control" name="manufacturer">
                                        </div>

                                        <div class="col-md-4">
                                            <label class="form-label">Xuất xứ</label>
                                            <input type="text" class="form-control" name="origin">
                                        </div>

                                        <div class="col-md-4">
                                            <label class="form-label">Nhóm thuốc</label>
                                            <input type="text" class="form-control" name="drugGroup">
                                        </div>

                                        <div class="col-md-4">
                                            <label class="form-label">Loại thuốc</label>
                                            <input type="text" class="form-control" name="drugType">
                                        </div>

                                        <div class="col-md-4">
                                            <label class="form-label">Tồn kho</label>
                                            <input type="number" class="form-control" name="stock" required>
                                        </div>

                                        <div class="col-md-4">
                                            <label class="form-label">Hạn sử dụng</label>
                                            <input type="date" class="form-control" name="expiryDate" required
                                                   min="<%= java.time.LocalDate.now() %>">
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

                <div class="modal fade" id="editMedicineModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">✏ Edit Medicine</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>

                            <div class="modal-body">
                                <form method="post" action="${pageContext.request.contextPath}/Medicine/update">
                                    <input type="hidden" name="id" id="edit-id">

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
            </div>
        </div>

        <%@ include file="footer.jsp" %>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            document.querySelectorAll('.edit-btn').forEach(button => {
                button.addEventListener('click', function () {
                    document.getElementById('edit-id').value = this.dataset.id;
                    document.getElementById('edit-name').value = this.dataset.name;
                    document.getElementById('edit-category').value = this.dataset.category;
                    document.getElementById('edit-description').value = this.dataset.description;
                    document.getElementById('edit-activeIngredient').value = this.dataset.activeingredient;
                    document.getElementById('edit-dosageForm').value = this.dataset.dosageform;
                    document.getElementById('edit-strength').value = this.dataset.strength;
                    document.getElementById('edit-unit').value = this.dataset.unit;
                    document.getElementById('edit-manufacturer').value = this.dataset.manufacturer;
                    document.getElementById('edit-origin').value = this.dataset.origin;
                    document.getElementById('edit-drugGroup').value = this.dataset.druggroup;
                    document.getElementById('edit-drugType').value = this.dataset.drugtype;
                    document.getElementById('edit-stock').value = this.dataset.stock;
                    document.getElementById('edit-expiryDate').value = this.dataset.expirydate;
                });
            });
        </script>
    </body>
</html>
