<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Danh sách ASN đã gửi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <h2 class="mb-4">📃 Danh sách ASN đã gửi</h2>
    <table class="table table-bordered table-hover">
        <thead class="table-primary">
            <tr>
                <th>ID</th>
                <th>PO ID</th>
                <th>Ngày giao hàng</th>
                <th>Trạng thái</th>
                <th>Ngày tạo</th>
                <th>Ghi chú</th>
            </tr>
        </thead>
        <tbody id="asnTableBody">
        </tbody>
    </table>
    <a href="supplier-dashboard.jsp" class="btn btn-secondary">⬅ Quay lại</a>
</div>

<script>
    fetch("${pageContext.request.contextPath}/ASNServlet?action=getBySupplier&supplierId=${sessionScope.supplierId}")
        .then(res => res.json())
        .then(data => {
            const tbody = document.getElementById("asnTableBody");
            data.forEach(a => {
                tbody.innerHTML += `
                    <tr>
                        <td>${a.asnId}</td>
                        <td>${a.poId}</td>
                        <td>${a.shipmentDate}</td>
                        <td>${a.status}</td>
                        <td>${a.createdAt || ''}</td>
                        <td>${a.notes || ''}</td>
                    </tr>`;
            });
        })
        .catch(err => console.error(err));
</script>
</body>
</html>
