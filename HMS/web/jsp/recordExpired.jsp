<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Record Expired/Damaged Medicines</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="container mt-5">

<h2>Record Expired/Damaged Medicines</h2>
<hr>

<!-- Thông báo kết quả -->
<c:if test="${not empty message}">
    <div class="alert alert-info">
        ${message}
    </div>
</c:if>

<form action="record-Expired" method="post" class="row g-3">
    <!-- Chọn batch -->
    <div class="col-md-6">
        <label for="batchId" class="form-label">Batch</label>
        <select name="batchId" id="batchId" class="form-select" required>
            <c:forEach var="medicine" items="${medicines}">
                <c:forEach var="batch" items="${medicine.batches}">
                    <option value="${batch.batchId}">
                        ${medicine.name} - Lot: ${batch.lotNumber} (Qty: ${batch.currentQuantity})
                    </option>
                </c:forEach>
            </c:forEach>
        </select>
    </div>

    <!-- Nhập số lượng -->
    <div class="col-md-6">
        <label for="quantity" class="form-label">Quantity</label>
        <input type="number" class="form-control" id="quantity" name="quantity" min="1" required>
    </div>

    <!-- Lý do -->
    <div class="col-md-6">
        <label for="reason" class="form-label">Reason</label>
        <select name="reason" id="reason" class="form-select" required>
            <option value="Expired">Expired</option>
            <option value="Damaged">Damaged</option>
        </select>
    </div>

    <!-- Ghi chú -->
    <div class="col-md-6">
        <label for="notes" class="form-label">Notes</label>
        <input type="text" class="form-control" id="notes" name="notes">
    </div>

    <!-- Nút submit -->
    <div class="col-12">
        <button type="submit" class="btn btn-primary">Save Record</button>
        <a href="listmedicine.jsp" class="btn btn-secondary">Cancel</a>
    </div>
</form>

</body>
</html>
