<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Tạo ASN mới</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <h2 class="mb-4">📦 Tạo ASN (Advanced Shipping Notice)</h2>
<form action="${pageContext.request.contextPath}/supplier/create-asn" method="post">
    <input type="hidden" name="action" value="create">
    <input type="hidden" name="poId" value="${param.poId}"> <!-- Hoặc servlet gán -->
    <input type="hidden" name="trackingNumber" id="trackingNumber">

    <script>
        // Sinh mã vận đơn ngẫu nhiên 6 ký tự chữ + số
        function generateTrackingNumber() {
            const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
            let result = '';
            for (let i = 0; i < 6; i++) {
                result += chars.charAt(Math.floor(Math.random() * chars.length));
            }
            return result;
        }
        document.getElementById("trackingNumber").value = generateTrackingNumber();
    </script>

    <div class="mb-3">
        <label>Ngày giao hàng (yyyy-mm-dd)</label>
        <input type="date" name="shipmentDate" class="form-control" required>
    </div>

    <div class="mb-3">
        <label>Hãng vận chuyển</label>
        <input type="text" name="carrier" class="form-control" required>
    </div>

    <div class="mb-3">
        <label>Ghi chú (nếu có)</label>
        <textarea name="notes" class="form-control"></textarea>
    </div>

    <button class="btn btn-primary">Tạo ASN</button>
    <a href="supplier-dashboard.jsp" class="btn btn-secondary">Quay lại</a>
</form>

</div>
</body>
</html>
