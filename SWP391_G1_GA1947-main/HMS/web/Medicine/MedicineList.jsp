<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thuốc - Vật tư</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background: #f9f9f9; }
        .sidebar {
            width: 220px; height: 100vh; position: fixed; top: 0; left: 0;
            background: #343a40; color: white; padding-top: 20px;
        }
        .sidebar a {
            display: block; color: white; padding: 10px 20px; text-decoration: none;
        }
        .sidebar a:hover { background: #495057; }
        .content { margin-left: 230px; padding: 20px; }
        .stock-negative { color: red; font-weight: bold; }
        table th, table td { text-align: center; vertical-align: middle; }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar">
    <h5 class="text-center">Menu</h5>
    <a href="${pageContext.request.contextPath}/Dashboard">Dashboard</a>
    <a href="${pageContext.request.contextPath}/Medicine/MedicineList">Danh sách thuốc</a>
    <c:if test="${sessionScope.role eq 'pharmacist'}">
        <a href="#">Thuốc hết hạn</a>
    </c:if>
</div>

<!-- Main content -->
<div class="content">
    <h2 class="mb-4">📦 Thuốc - Vật tư</h2>

    <!-- Search + Add -->
    <form class="row g-2 mb-3" method="get" action="${pageContext.request.contextPath}/Medicine/MedicineList">
        <div class="col-auto">
            <input type="text" class="form-control" name="name" placeholder="Tìm theo tên..." value="${param.name}">
        </div>
        <div class="col-auto">
            <input type="text" class="form-control" name="category" placeholder="Tìm theo danh mục..." value="${param.category}">
        </div>
        <div class="col-auto">
            <button type="submit" class="btn btn-primary">Tìm kiếm</button>
        </div>
        <div class="col-auto">
            <button type="button" class="btn btn-success">Xuất ra Excel</button>
        </div>

        <c:if test="${sessionScope.role eq 'pharmacist'}">
            <div class="col-auto">
                <button type="button" class="btn btn-info" data-bs-toggle="modal" data-bs-target="#addMedicineModal">
                    + Thêm thuốc mới
                </button>
            </div>
        </c:if>
    </form>

    <!-- Bảng danh sách -->
    <table class="table table-bordered table-striped">
        <thead class="table-light">
        <tr>
            <th>MÃ THUỐC</th>
            <th>TÊN THUỐC</th>
            <th>DANH MỤC</th>
            <th>MÔ TẢ</th>
            <th>NHÀ CUNG CẤP</th>
            <th>TỒN KHO</th>
            <th>HẠN GẦN NHẤT</th>
            <th>TRẠNG THÁI</th>
            <c:if test="${sessionScope.role eq 'pharmacist'}">
                <th>SỬA</th>
                <th>XÓA</th>
            </c:if>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="m" items="${medicines}">
            <tr>
                <td>${m.id}</td>
                <td>${m.name}</td>
                <td>${m.category}</td>
                <td>${m.description}</td>
                <td>${m.supplierName}</td>
                <td class="${m.totalStock <= 0 ? 'stock-negative' : ''}">${m.totalStock}</td>
                <td>${m.nearestExpiry}</td>
                <td>${m.status}</td>
                <c:if test="${sessionScope.role eq 'pharmacist'}">
                    <td>
                        <button type="button" 
                                class="btn btn-warning btn-sm"
                                data-bs-toggle="modal" 
                                data-bs-target="#updateMedicineModal"
                               onclick="fillUpdateForm('${m.id}','${m.name}','${m.category}',
                        '${m.description}','${m.supplierName}',
                        '${m.totalStock}','${m.nearestExpiry}',
                        '${m.status}')">

                            ✏
                        </button>
                    </td>
                    <td>
                        <form action="${pageContext.request.contextPath}/Medicine/delete" method="post"
                              onsubmit="return confirm('Bạn có chắc chắn muốn xóa thuốcID=${m.id}?');">
                            <input type="hidden" name="id" value="${m.id}" />
                            <button type="submit" class="btn btn-danger btn-sm">🗑</button>
                        </form>
                    </td>
                </c:if>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <!-- Phân trang -->
    <div class="text-center">
        <c:forEach begin="1" end="${totalPages}" var="p">
            <a class="btn btn-outline-primary btn-sm ${p == currentPage ? 'active' : ''}"
               href="${pageContext.request.contextPath}/Medicine/MedicineList?page=${p}&name=${param.name}&category=${param.category}">
                ${p}
            </a>
        </c:forEach>
    </div>
</div>


<!-- Modal thêm thuốc -->
<div class="modal fade" id="addMedicineModal" tabindex="-1" aria-labelledby="addMedicineModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">➕ Thêm thuốc mới</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <form method="post" action="${pageContext.request.contextPath}/Medicine/add">
            <div class="mb-3">
                <label class="form-label">Tên thuốc</label>
                <input type="text" class="form-control" name="name" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Danh mục</label>
                <input type="text" class="form-control" name="category" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Mô tả</label>
                <textarea class="form-control" name="description"></textarea>
            </div>
            <div class="mb-3">
                <label class="form-label">Nhà cung cấp (Supplier ID)</label>
                <input type="number" class="form-control" name="supplierId" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Số lô</label>
                <input type="text" class="form-control" name="lotNumber" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Hạn sử dụng</label>
                <input type="date" class="form-control" name="expiryDate" 
       required min="<%= java.time.LocalDate.now() %>">

            </div>
            <div class="mb-3">
                <label class="form-label">Số lượng nhập</label>
                <input type="number" class="form-control" name="quantity" required>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-success">Lưu</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
            </div>
        </form>
      </div>
    </div>
  </div>
</div>


<!-- Modal Update -->
<div class="modal fade" id="updateMedicineModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form method="post" action="${pageContext.request.contextPath}/Medicine/update">
        <div class="modal-header">
          <h5 class="modal-title">✏ Cập nhật thuốc</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <input type="hidden" name="id" id="update-id">

          <div class="mb-3">
              <label class="form-label">Tên thuốc</label>
              <input type="text" class="form-control" name="name" id="update-name" required>
          </div>

          <div class="mb-3">
              <label class="form-label">Danh mục</label>
              <input type="text" class="form-control" name="category" id="update-category" required>
          </div>

          <div class="mb-3">
              <label class="form-label">Mô tả</label>
              <textarea class="form-control" name="description" id="update-description"></textarea>
          </div>

          <div class="mb-3">
              <label class="form-label">Hạn sử dụng</label>
              <input type="date" class="form-control" name="expiryDate" id="update-expiryDate"
                     min="<%= java.time.LocalDate.now() %>" required>
          </div>

          <div class="mb-3">
              <label class="form-label">Số lượng tồn kho</label>
              <input type="number" class="form-control" name="totalStock" id="update-totalStock" required>
          </div>
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-success">Lưu thay đổi</button>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
        </div>
      </form>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
function fillUpdateForm(id, name, category, description, supplierId, lotNumber, expiryDate, quantity) {
    document.getElementById("update-id").value = id;
    document.getElementById("update-name").value = name;
    document.getElementById("update-category").value = category;
    document.getElementById("update-description").value = description;
    document.getElementById("update-supplierId").value = supplierId;
    document.getElementById("update-lotNumber").value = lotNumber;
    document.getElementById("update-expiryDate").value = expiryDate;
    document.getElementById("update-quantity").value = quantity;
}
</script>
</body>
</html>
