<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Quản lý lô thuốc</title>

    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

    <style>
        body {
            display: flex;
            min-height: 100vh;
            background-color: #f3f4f6;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .sidebar {
            width: 250px;
            background: linear-gradient(180deg, #6d28d9, #4f46e5);
            color: white;
            display: flex;
            flex-direction: column;
            padding-top: 20px;
        }
        .profile {
            text-align: center;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            padding-bottom: 15px;
            margin-bottom: 10px;
        }
        .profile img {
            width: 70px; height: 70px; border-radius: 50%;
            border: 2px solid #a78bfa; margin-bottom: 8px;
        }
        .menu a {
            display: flex; align-items: center;
            padding: 12px 25px; color: #e5e7eb;
            text-decoration: none; font-size: 14px;
            transition: 0.3s;
        }
        .menu a:hover, .menu a.active {
            background-color: rgba(255,255,255,0.15);
            color: #fff;
        }
        .main { flex: 1; padding: 30px; }
        h1 {
            font-size: 26px; margin-bottom: 25px;
            font-weight: 600; color: #111827;
        }
        .search-bar {
            background: #fff; border-radius: 12px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
            padding: 15px 20px; margin-bottom: 20px;
            display: flex; flex-wrap: wrap;
            gap: 10px; align-items: center;
        }
        .btn-search { background-color: #16a34a; color: #fff; border-radius: 8px; }
        .btn-reset { background-color: #6b7280; color: #fff; border-radius: 8px; }
        table {
            background: white; border-collapse: collapse;
            width: 100%; box-shadow: 0 2px 6px rgba(0,0,0,0.05);
            border-radius: 8px; overflow: hidden;
        }
        thead { background: linear-gradient(135deg,#7c3aed,#6366f1); color: white; }
        th, td { padding: 12px; border-bottom: 1px solid #e0e0e0; text-align: center; }
        .status-badge {
            padding: 5px 12px; border-radius: 20px;
            font-size: 12px; font-weight: 500;
        }
        .status-available { background: #d4edda; color: #155724; }
        .status-low { background: #fff3cd; color: #856404; }
        .status-expired { background: #f8d7da; color: #721c24; }

        /* pagination */
        .pagination { display:flex; justify-content:center; margin-top:20px; gap:5px; }
        .page-item .page-link {
            color:#4f46e5; border:1px solid #ddd;
            border-radius:6px; padding:6px 12px;
        }
        .page-item.active .page-link {
            background-color:#4f46e5; color:white; border-color:#4f46e5;
        }
        .page-item.disabled .page-link {
            background-color:#f3f4f6; color:#9ca3af;
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
            <a href="${pageContext.request.contextPath}/view-medicine"><i class="fa fa-pills"></i> Quản lý thuốc</a>
            <a href="${pageContext.request.contextPath}/create-request"><i class="fa fa-file-medical"></i> Yêu cầu thuốc</a>
            <a href="${pageContext.request.contextPath}/pharmacist/manage-batch" class="active"><i class="fa fa-warehouse"></i> Quản lý số lô</a>
            <a href="${pageContext.request.contextPath}/doctor-management"><i class="fa fa-user-md"></i> Quản lý bác sĩ</a>
            <a href="${pageContext.request.contextPath}/report"><i class="fa fa-chart-line"></i> Báo cáo</a>
            <a href="${pageContext.request.contextPath}/logout"><i class="fa fa-sign-out-alt"></i> Đăng xuất</a>
        </div>
    </div>

    <!-- Main content -->
    <div class="main">
        <h1>Quản lý số lô thuốc</h1>

        <!-- Thanh tìm kiếm -->
        <div class="search-bar">
            <div class="input-group" style="flex: 1 1 300px;">
                <span class="input-group-text bg-white border-end-0"><i class="fa fa-search"></i></span>
                <input type="text" id="searchInput" class="form-control border-start-0" placeholder="Tìm tên thuốc hoặc số lô...">
            </div>

            <select id="categoryFilter" class="form-select" style="max-width:200px;">
                <option value="">Tất cả loại</option>
                <option value="Tablet">Viên nén</option>
                <option value="Syrup">Siro</option>
                <option value="Injection">Tiêm</option>
            </select>

            <select id="statusFilter" class="form-select" style="max-width:180px;">
                <option value="">Tất cả trạng thái</option>
                <option value="Available">Còn hàng</option>
                <option value="Low Stock">Sắp hết</option>
                <option value="Expired">Hết hạn</option>
            </select>

            <button class="btn btn-search px-4" onclick="applyFilter()">Tìm kiếm</button>
            <button class="btn btn-reset px-4" onclick="resetFilter()">Reset</button>
            <button class="btn btn-success ms-auto" data-bs-toggle="modal" data-bs-target="#addBatchModal">➕ Thêm lô mới</button>
        </div>

        <!-- Bảng danh sách -->
        <c:choose>
            <c:when test="${not empty batchList}">
                <table id="batchTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Số lô</th>
                            <th>Tên thuốc</th>
                            <th>Nhà cung cấp</th>
                            <th>Hạn dùng</th>
                            <th>SL ban đầu</th>
                            <th>SL hiện tại</th>
                            <th>Trạng thái</th>
                            <th>Chỉnh sửa</th>
                            <th>Xóa</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="b" items="${batchList}">
                            <tr>
                                <td>${b.batchId}</td>
                                <td>${b.lotNumber}</td>
                                <td>${b.medicineName}</td>
                                <td>${b.supplierName}</td>
                                <td><fmt:formatDate value="${b.expiryDate}" pattern="dd/MM/yyyy"/></td>
                                <td>${b.initialQuantity}</td>
                                <td>${b.currentQuantity}</td>
                                <td>
                                    <span class="status-badge
                                        ${b.status == 'Available' ? 'status-available' :
                                          (b.status == 'Low Stock' ? 'status-low' : 'status-expired')}">
                                        ${b.status}
                                    </span>
                                </td>
                                <td>
                                    <button class="btn btn-warning btn-sm" data-bs-toggle="modal" data-bs-target="#editBatchModal"
                                            onclick="fillEdit('${b.batchId}','${b.lotNumber}','${b.expiryDate}','${b.currentQuantity}','${b.status}')">✏️</button>
                                </td>
                                <td>
                                    <a href="delete-batch?id=${b.batchId}" class="btn btn-danger btn-sm"
                                       onclick="return confirm('Bạn có chắc muốn xóa lô này không?')">🗑</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <nav><ul class="pagination" id="pagination"></ul></nav>
            </c:when>
            <c:otherwise>
                <div class="text-center text-muted mt-4">Không có dữ liệu lô hàng.</div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Modal thêm -->
    <div class="modal fade" id="addBatchModal" tabindex="-1">
        <div class="modal-dialog">
            <form action="add-batch" method="post" class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title">Thêm lô thuốc mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label>Số lô</label>
                        <input type="text" name="lotNumber" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label>Hạn dùng</label>
                        <input type="date" name="expiryDate" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label>Số lượng ban đầu</label>
                        <input type="number" name="initialQuantity" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label>Trạng thái</label>
                        <select name="status" class="form-select">
                            <option value="Available">Còn hàng</option>
                            <option value="Low Stock">Sắp hết</option>
                            <option value="Expired">Hết hạn</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button class="btn btn-success">Lưu</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal chỉnh sửa -->
    <div class="modal fade" id="editBatchModal" tabindex="-1">
        <div class="modal-dialog">
            <form action="update-batch" method="post" class="modal-content">
                <div class="modal-header bg-warning">
                    <h5 class="modal-title">Chỉnh sửa lô thuốc</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="edit-id" name="batchId">
                    <div class="mb-3">
                        <label>Số lô</label>
                        <input type="text" id="edit-lot" name="lotNumber" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label>Hạn dùng</label>
                        <input type="date" id="edit-expiry" name="expiryDate" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label>Số lượng hiện tại</label>
                        <input type="number" id="edit-qty" name="currentQuantity" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label>Trạng thái</label>
                        <select id="edit-status" name="status" class="form-select">
                            <option value="Available">Còn hàng</option>
                            <option value="Low Stock">Sắp hết</option>
                            <option value="Expired">Hết hạn</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button class="btn btn-warning">Cập nhật</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Script -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function fillEdit(id, lot, expiry, qty, status) {
            document.getElementById('edit-id').value = id;
            document.getElementById('edit-lot').value = lot;
            document.getElementById('edit-expiry').value = expiry.split('T')[0];
            document.getElementById('edit-qty').value = qty;
            document.getElementById('edit-status').value = status;
        }

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
            if (pageCount === 0) return;
            const prev = document.createElement("li");
            prev.className = "page-item" + (currentPage === 1 ? " disabled" : "");
            prev.innerHTML = `<a class="page-link" href="#">&laquo;</a>`;
            prev.addEventListener("click", () => {
                if (currentPage > 1) { currentPage--; displayPage(currentPage); setupPagination(); }
            });
            pagination.appendChild(prev);
            for (let i = 1; i <= pageCount; i++) {
                const li = document.createElement("li");
                li.className = "page-item" + (i === currentPage ? " active" : "");
                li.innerHTML = `<a class="page-link" href="#">${i}</a>`;
                li.addEventListener("click", () => { currentPage = i; displayPage(currentPage); setupPagination(); });
                pagination.appendChild(li);
            }
            const next = document.createElement("li");
            next.className = "page-item" + (currentPage === pageCount ? " disabled" : "");
            next.innerHTML = `<a class="page-link" href="#">&raquo;</a>`;
            next.addEventListener("click", () => {
                if (currentPage < pageCount) { currentPage++; displayPage(currentPage); setupPagination(); }
            });
            pagination.appendChild(next);
            displayPage(currentPage);
        }

        function applyFilter() {
            const s = document.getElementById("searchInput").value.toLowerCase();
            const c = document.getElementById("categoryFilter").value.toLowerCase();
            const st = document.getElementById("statusFilter").value.toLowerCase();
            filteredRows = allRows.filter(row => {
                const text = row.innerText.toLowerCase();
                return text.includes(s) && (c ? text.includes(c) : true) && (st ? text.includes(st) : true);
            });
            allRows.forEach(r => r.style.display = "none");
            currentPage = 1; setupPagination();
        }

        function resetFilter() {
            document.getElementById("searchInput").value = "";
            document.getElementById("categoryFilter").value = "";
            document.getElementById("statusFilter").value = "";
            filteredRows = [...allRows]; currentPage = 1; setupPagination();
        }

        if (allRows.length > 0) setupPagination();
    </script>
</body>
</html>
