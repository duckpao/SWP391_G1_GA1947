<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cập Nhật Thuốc - Vật Tư</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">
<div class="container">
    <h3 class="mb-4">✏ Cập Nhật Thuốc - Vật Tư</h3>

    <form method="post" action="${pageContext.request.contextPath}/medicine/update">
        <input type="hidden" name="id" value="${medicine.id}">

        <div class="mb-3">
            <label class="form-label">Tên thuốc</label>
            <input type="text" class="form-control" name="name" value="${medicine.name}" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Danh mục</label>
            <input type="text" class="form-control" name="category" value="${medicine.category}" required>
        </div>

        <div class="mb-3">
            <label class="form-label">Mô tả</label>
            <textarea class="form-control" name="description" rows="3">${medicine.description}</textarea>
        </div>

        <button type="submit" class="btn btn-primary">Cập nhật</button>
        <a href="${pageContext.request.contextPath}/Medicine/MedicineList" class="btn btn-secondary">Hủy</a>
    </form>
</div>
</body>
</html>
