<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xóa Thuốc</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4">
<div class="container">
    <h3 class="mb-4 text-danger">🗑 Xóa Thuốc</h3>

    <p>Bạn có chắc chắn muốn xóa thuốc <strong>${medicine.name}</strong> không?</p>

    <form method="post" action="${pageContext.request.contextPath}/medicine/delete">
        <input type="hidden" name="id" value="${medicine.id}">
        <button type="submit" class="btn btn-danger">Xóa</button>
        <a href="${pageContext.request.contextPath}/Medicine/MedicineList" class="btn btn-secondary">Hủy</a>
    </form>
</div>
</body>
</html>
