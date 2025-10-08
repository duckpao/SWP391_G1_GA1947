<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Cập Nhật Yêu Cầu Thuốc</title>
</head>
<body>
    <h1>Cập Nhật Yêu Cầu Thuốc</h1>
    <c:if test="${not empty error}">
        <p style="color:red">${error}</p>
    </c:if>
    <form action="update-request" method="post">
        <input type="hidden" name="requestId" value="${request.requestId}">
        <label>Ghi chú:</label>
        <input type="text" name="notes" value="${request.notes}" required><br>
        <label>Danh sách thuốc:</label><br>
        <c:forEach var="item" items="${items}" varStatus="loop">
            <select name="medicine_id" style="display:inline-block">
                <c:forEach var="med" items="${medicines}">
                    <option value="${med.medicineId}" ${item.medicineId == med.medicineId ? 'selected' : ''}>${med.name}</option>
                </c:forEach>
            </select>
            <input type="number" name="quantity" value="${item.quantity}" min="1" required style="display:inline-block">
            <br>
        </c:forEach>
        <button type="submit">Cập Nhật</button>
    </form>
    <a href="manage-requests">Quay lại Quản lý Yêu cầu</a>
</body>
</html>