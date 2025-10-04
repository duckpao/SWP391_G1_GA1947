<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>View Request History</title>
</head>
<body>
    <h1>View Request History</h1>
    <c:forEach var="req" items="${requests}">
        <p>ID: ${req.requestId} - Ngày: ${req.requestDate} - Trạng thái: ${req.status} - Ghi chú: ${req.notes}</p>
    </c:forEach>
    <a href="manage-requests">Back to Manage Requests</a>
</body>
</html>