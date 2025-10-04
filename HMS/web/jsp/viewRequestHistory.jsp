<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>View Request History</title>
</head>
<body>
    <h1>View Request History</h1>
    <!-- Form tìm kiếm -->
    <form action="view-request-history" method="get">
        <label>Tìm theo tên thuốc:</label>
        <input type="text" name="medicineName" value="${param.medicineName}" placeholder="Nhập tên thuốc"><br>
        <label>Tìm theo ngày:</label>
        <input type="date" name="date" value="${param.date}"><br>
        <button type="submit">Tìm kiếm</button>
        <a href="view-request-history"><button type="button">Xóa bộ lọc</button></a>
    </form>
    <br>
    <c:forEach var="req" items="${requests}">
        <p>ID: ${req.requestId} - Ngày: ${req.requestDate} - Trạng thái: ${req.status} - Ghi chú: ${req.notes}</p>
        <c:set var="items" value="${requestItemsMap[req.requestId]}"/>
        <c:if test="${not empty items}">
            <ul>
                <c:forEach var="item" items="${items}">
                    <li>Thuốc: ${item.medicineName} - Số lượng: ${item.quantity}</li>
                </c:forEach>
            </ul>
        </c:if>
    </c:forEach>
    <a href="manage-requests">Back to Manage Requests</a>
</body>
</html>