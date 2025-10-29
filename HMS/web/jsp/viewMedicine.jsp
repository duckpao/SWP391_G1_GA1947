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

        <style>
            body {
                display: flex;
                min-height: 100vh;
                background-color: #f3f4f6;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            /* Sidebar */
            .sidebar {
                width: 250px;
                background: linear-gradient(180deg, #6d28d9, #4f46e5);
                color: #fff;
                display: flex;
                flex-direction: column;
                padding-top: 15px;
            }

            .profile {
                text-align: center;
                margin-bottom: 15px;
                border-bottom: 1px solid rgba(255,255,255,0.1);
                padding-bottom: 10px;
            }

            .profile img {
                width: 60px;
                height: 60px;
                border-radius: 50%;
                border: 2px solid #a78bfa;
                margin-bottom: 10px;
            }

            .profile h5 {
                margin: 0;
                color: #fff;
            }

            .profile span {
                font-size: 13px;
                color: #d1d5db;
            }

            .menu a {
                display: flex;
                align-items: center;
                padding: 12px 25px;
                color: #e5e7eb;
                text-decoration: none;
                font-size: 14px;
                transition: 0.3s;
            }

            .menu a i {
                width: 20px;
                margin-right: 10px;
            }

            .menu a:hover, .menu a.active {
                background-color: rgba(255,255,255,0.15);
                color: #fff;
            }

            /* Main content */
            .main {
                flex: 1;
                padding: 30px;
            }

            h1 {
                font-size: 26px;
                margin-bottom: 25px;
                font-weight: 600;
                color: #111827;
            }

            .search-container {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                border: 1px solid #ddd;
                margin-bottom: 25px;
            }

            .search-form {
                display: grid;
                grid-template-columns: 2fr 1fr 1fr auto auto;
                gap: 15px;
                align-items: end;
            }

            table {
                background: white;
                border-collapse: collapse;
                width: 100%;
            }

            thead {
                background: linear-gradient(135deg, #7c3aed, #6366f1);
                color: white;
            }

            th, td {
                padding: 12px;
                border-bottom: 1px solid #e0e0e0;
            }

            .status-badge {
                padding: 4px 10px;
                border-radius: 20px;
                font-size: 12px;
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
        </style>
    </head>

    <body>

        <!-- Sidebar -->
        <div class="sidebar">
            <div class="profile">
                <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png" alt="User">
                <h5>${sessionScope.username}</h5>
                <span>${sessionScope.role}</span>
            </div>
            <div class="menu">
                <a href="${pageContext.request.contextPath}/home.jsp"><i class="fa fa-home"></i> Trang chủ</a>
                <a href="${pageContext.request.contextPath}/view-medicine" class="active"><i class="fa fa-pills"></i> Quản lý thuốc</a>
                <a href="${pageContext.request.contextPath}/create-request"><i class="fa fa-file-medical"></i> Yêu cầu thuốc</a>
                <a href="${pageContext.request.contextPath}/pharmacist/manage-batch"><i class="fa fa-warehouse"></i> Quản lý số lô/lô hàng</a>
                <a href="${pageContext.request.contextPath}/pharmacist/recordExpiredDamaged"><i class="fa fa-user-md"></i> thuốc hết hạn/hư hỏng</a>
                <a href="${pageContext.request.contextPath}/report"><i class="fa fa-chart-line"></i> Báo cáo thống kê</a>
                <a href="${pageContext.request.contextPath}/logout"><i class="fa fa-sign-out-alt"></i> Đăng xuất</a>
            </div>
        </div>

        <!-- Main content -->
        <div class="main">
            <h1>Medicine Details</h1>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

            <!-- Search -->
            <!-- Search Bar -->
            <div class="card p-3 mb-4 shadow-sm">
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


            <!-- Buttons -->
            <div class="d-flex mb-3">
                <c:if test="${sessionScope.role eq 'Doctor'}">
                    <a href="${pageContext.request.contextPath}/create-request" class="btn btn-primary">📝 Create Request</a>
                </c:if>
                <c:if test="${sessionScope.role eq 'Pharmacist'}">
                    <button class="btn btn-success ms-auto" data-bs-toggle="modal" data-bs-target="#addMedicineModal">➕ Add New Medicine</button>
                </c:if>
            </div>

            <!-- Medicine Table -->
            <c:choose>
                <c:when test="${not empty medicines}">
                    <table class="table table-bordered table-striped align-middle text-center">
                        <thead class="table-light">
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

                                    <!-- ✅ Cột: Tồn kho -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty m.batches}">
                                                ${m.batches[0].currentQuantity}
                                            </c:when>
                                            <c:otherwise>0</c:otherwise>
                                        </c:choose>
                                    </td>

                                    <!-- ✅ Cột: Hạn gần nhất -->
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty m.batches and m.batches[0].expiryDate ne null}">
                                                <fmt:formatDate value="${m.batches[0].expiryDate}" pattern="dd/MM/yyyy"/>
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>

                                    <c:if test="${sessionScope.role eq 'Pharmacist'}">
                                        <%--  <td>
                                            <button class="btn btn-warning btn-sm"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#editMedicineModal"
                                                    onclick="fillEditForm('${m.medicineCode}', '${m.name}', '${m.category}', '${m.description}', '${m.activeIngredient}', '${m.dosageForm}', '${m.strength}', '${m.unit}', '${m.manufacturer}', '${m.countryOfOrigin}', '${m.drugGroup}', '${m.drugType}')">
                                                ✏️
                                            </button>
                                        </td> --%>
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




            <!-- Modal Add Medicine -->
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


      
            <!-- Modal Edit Medicine -->
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

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

            <script>
                                                      // Khi click vào nút Edit, điền dữ liệu vào modal

                                                      function openEditModal(batch) {
                                                          document.getElementById('edit-id').value = batch.id;
                                                          document.getElementById('edit-batchId').value = batch.batchId;
                                                          document.getElementById('edit-supplierId').value = batch.supplierId;
                                                          document.getElementById('edit-name').value = batch.name;
                                                          document.getElementById('edit-category').value = batch.category;
                                                          document.getElementById('edit-description').value = batch.description;
                                                          document.getElementById('edit-lotNumber').value = batch.lotNumber;
                                                          document.getElementById('edit-expiryDate').value = batch.expiryDate;
                                                          document.getElementById('edit-quantity').value = batch.quantity;
                                                          var modal = new bootstrap.Modal(document.getElementById('editMedicineModal'));
                                                          modal.show();
                                                      }
            </script>

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

