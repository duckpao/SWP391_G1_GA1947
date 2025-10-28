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

        .status-approved { background: #d4edda; color: #155724; }
        .status-low { background: #fff3cd; color: #856404; }
        .status-out { background: #f8d7da; color: #721c24; }

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
            <a href="${pageContext.request.contextPath}/warehouse"><i class="fa fa-warehouse"></i> Quản lý kho</a>
            <a href="${pageContext.request.contextPath}/doctor-management"><i class="fa fa-user-md"></i> Quản lý bác sĩ</a>
            <a href="${pageContext.request.contextPath}/report"><i class="fa fa-chart-line"></i> Báo cáo thống kê</a>
            <a href="${pageContext.request.contextPath}/logout"><i class="fa fa-sign-out-alt"></i> Đăng xuất</a>
        </div>
    </div>

    <!-- Main content -->
    <div class="main">
        <h1>Medicine Details</h1>

        <!-- Search -->
        <div class="search-container">
            <form action="${pageContext.request.contextPath}/view-medicine" method="get" class="search-form">
                <input type="text" name="keyword" value="${keyword}" placeholder="🔍 Search medicine..." class="form-control">
                <select name="category" class="form-select">
                    <option value="All" ${selectedCategory == 'All' ? 'selected' : ''}>All Categories</option>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat}" ${selectedCategory == cat ? 'selected' : ''}>${cat}</option>
                    </c:forEach>
                </select>
                <select name="status" class="form-select">
                    <option value="" ${selectedStatus == '' ? 'selected' : ''}>All Status</option>
                    <option value="In Stock" ${selectedStatus == 'In Stock' ? 'selected' : ''}>In Stock</option>
                    <option value="Low Stock" ${selectedStatus == 'Low Stock' ? 'selected' : ''}>Low Stock</option>
                    <option value="Out of Stock" ${selectedStatus == 'Out of Stock' ? 'selected' : ''}>Out of Stock</option>
                </select>
                <button type="submit" class="btn btn-success">Tìm kiếm</button>
                <a href="${pageContext.request.contextPath}/view-medicine" class="btn btn-secondary">Reset</a>
            </form>
        </div>

        <!-- Buttons -->
        <div class="d-flex mb-3">
            <a href="${pageContext.request.contextPath}/create-request" class="btn btn-primary">📝 Create Request</a>
            <c:if test="${sessionScope.role eq 'Pharmacist'}">
                <button class="btn btn-success ms-auto" data-bs-toggle="modal" data-bs-target="#addMedicineModal">➕ Add New Medicine</button>
            </c:if>
        </div>

        <!-- Medicine Table -->
        <c:choose>
            <c:when test="${not empty medicines}">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Category</th>
                            <th>Description</th>
                            <th>Batch ID</th>
                            <th>Lot</th>
                            <th>Expiry</th>
                            <th>Quantity</th>
                            <th>Status</th>
                            <th>Received</th>
                            <c:if test="${sessionScope.role eq 'Pharmacist'}">
                                <th>Edit</th><th>Delete</th>
                            </c:if>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="medicine" items="${medicines}">
                            <c:forEach var="batch" items="${medicine.batches}" varStatus="st">
                                <tr>
                                    <c:if test="${st.first}">
                                        <td rowspan="${medicine.batches.size()}">${medicine.medicineId}</td>
                                        <td rowspan="${medicine.batches.size()}"><strong>${medicine.name}</strong></td>
                                        <td rowspan="${medicine.batches.size()}">${medicine.category}</td>
                                        <td rowspan="${medicine.batches.size()}">${medicine.description}</td>
                                    </c:if>
                                    <td>${batch.batchId}</td>
                                    <td>${batch.lotNumber}</td>
                                    <td><fmt:formatDate value="${batch.expiryDate}" pattern="dd/MM/yyyy"/></td>
                                    <td>${batch.currentQuantity}</td>
                                    <td>
                                        <span class="status-badge
                                            ${batch.status == 'In Stock' ? 'status-approved' :
                                              batch.status == 'Low Stock' ? 'status-low' : 'status-out'}">
                                            ${batch.status}
                                        </span>
                                    </td>
                                    <td><fmt:formatDate value="${batch.receivedDate}" pattern="dd/MM/yyyy"/></td>
                                    <c:if test="${sessionScope.role eq 'Pharmacist'}">
                                        <td>
                                            <button class="btn btn-warning btn-sm"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#editMedicineModal"
                                                    onclick="fillEditForm('${medicine.medicineId}','${medicine.name}','${medicine.category}','${medicine.description}','${batch.batchId}','${batch.lotNumber}','${batch.expiryDate}','${batch.currentQuantity}')">✏️</button>
                                        </td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/Medicine/delete" method="post" onsubmit="return confirm('Delete this medicine?');">
                                                <input type="hidden" name="id" value="${medicine.medicineId}">
                                                <button type="submit" class="btn btn-danger btn-sm">🗑</button>
                                            </form>
                                        </td>
                                    </c:if>
                                </tr>
                            </c:forEach>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <h3>No medicines found</h3>
                    <p>Try adjusting your search filters.</p>
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
                                <div class="mb-3">
                                    <label class="form-label">Medicine Name</label>
                                    <input type="text" class="form-control" name="name" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Category</label>
                                    <input type="text" class="form-control" name="category" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Description</label>
                                    <textarea class="form-control" name="description"></textarea>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Supplier ID</label>
                                    <input type="number" class="form-control" name="supplierId" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Lot Number</label>
                                    <input type="text" class="form-control" name="lotNumber" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Expiry Date</label>
                                    <input type="date" class="form-control" name="expiryDate"
                                           required min="<%= java.time.LocalDate.now() %>">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Quantity</label>
                                    <input type="number" class="form-control" name="quantity" required>
                                </div>
                                <div class="modal-footer">
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
                    <input type="hidden" name="batchId" id="edit-batchId">
                    <input type="hidden" name="supplierId" id="edit-supplierId"> <!-- Thêm dòng này -->

                    <div class="mb-3">
                        <label class="form-label">Medicine Name</label>
                        <input type="text" class="form-control" name="name" id="edit-name" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Category</label>
                        <input type="text" class="form-control" name="category" id="edit-category" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" name="description" id="edit-description"></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Batch ID</label>
                        <input type="text" class="form-control" name="batchId" id="edit-batchId" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Lot Number</label>
                        <input type="text" class="form-control" name="lotNumber" id="edit-lotNumber" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Expiry Date</label>
                        <input type="date" class="form-control" name="expiryDate" id="edit-expiryDate" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Quantity</label>
                        <input type="number" class="form-control" name="quantity" id="edit-quantity" required>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-success">Update</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function fillEditForm(id, name, category, description, batchId, lotNumber, expiryDate, quantity) {
            document.getElementById('edit-id').value = id;
            document.getElementById('edit-name').value = name;
            document.getElementById('edit-category').value = category;
            document.getElementById('edit-description').value = description;
            document.getElementById('edit-batchId').value = batchId;
            document.getElementById('edit-lotNumber').value = lotNumber;
            document.getElementById('edit-expiryDate').value = expiryDate;
            document.getElementById('edit-quantity').value = quantity;
        }
    </script>
</body>
</html>
