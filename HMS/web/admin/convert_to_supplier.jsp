<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chuyển User thành Supplier</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-5">
    <div class="container">
        <h2 class="mb-4">🧾 Chuyển người dùng thành Supplier</h2>

        <form action="${pageContext.request.contextPath}/admin-dashboard/convert-supplier" method="post">
            <input type="hidden" name="user_id" value="${param.userId}" />

            <div class="mb-3">
                <label class="form-label">Tên Supplier</label>
                <input type="text" name="name" class="form-control" required />
            </div>

            <div class="mb-3">
                <label class="form-label">Email liên hệ</label>
                <input type="email" name="contact_email" class="form-control" required />
            </div>

            <div class="mb-3">
                <label class="form-label">Số điện thoại</label>
                <input type="text" name="contact_phone" class="form-control" required />
            </div>

            <div class="mb-3">
                <label class="form-label">Địa chỉ</label>
                <input type="text" name="address" class="form-control" required />
            </div>

            <div class="mb-3">
                <label class="form-label">Điểm đánh giá hiệu suất</label>
                <input type="number" step="0.1" name="performance_rating" class="form-control" value="0" />
            </div>

            <button type="submit" class="btn btn-success">✅ Xác nhận chuyển đổi</button>
            <a href="${pageContext.request.contextPath}/admin-dashboard" class="btn btn-secondary">⬅️ Quay lại</a>
        </form>
    </div>
</body>
</html>
