<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Thêm lô thuốc</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">

        <div class="container mt-5">
            <h4 class="mb-4 text-primary">
                <i class="bi bi-plus-circle"></i> Thêm lô cho đơn #${order.poId}
            </h4>

            <form method="post" action="${pageContext.request.contextPath}/pharmacist/Batch-Add">

                <input type="hidden" name="poId" value="${order.poId}" />

                <table class="table table-bordered align-middle">
                    <thead class="table-secondary">
                        <tr>
                            <th>Thuốc</th>
                            <th>Hàm lượng</th>
                            <th>Dạng</th>
                            <th>HSD</th>
                            <th>Ngày nhận</th>
                            <th>Số lượng</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${order.items}">
                            <tr>
                                <td>
                                    <input type="hidden" name="medicineCode" value="${item.medicineCode}">
                                    ${item.medicineName}
                                </td>
                                <td>${item.medicineStrength}</td>
                                <td>${item.medicineDosageForm}</td>
                                <td><input type="date" name="expiryDate" class="form-control" required></td>
                                <td><input type="date" name="receivedDate" class="form-control" required></td>
                                <td>
                                    <input type="number" name="initialQuantity" value="${item.quantity}"
                                           min="1" class="form-control" required>
                                </td>
                                <td style="display:none;">
                                    <input type="hidden" name="supplierId" value="${order.supplierId}">
                                </td>

                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <div class="text-end mt-3">
                    <button type="submit" class="btn btn-success px-4">Lưu lô thuốc</button>
                    <a href="${pageContext.request.contextPath}/pharmacist/manage-batch"
                       class="btn btn-outline-secondary">Hủy</a>
                </div>
            </form>
        </div>
    </body>
</html>
