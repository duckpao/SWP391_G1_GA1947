<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Manage Medication Requests</title>
</head>
<body>
    <h1>Manage Medication Requests</h1>
    <a href="create-request">Create Medication Request</a><br><br>
    <div style="border: 1px solid black; padding: 10px;">
        <h3>Pending Requests</h3>
        <c:forEach var="req" items="${requests}">
            <p>ID: ${req.requestId} - Ngày: ${req.requestDate} - Trạng thái: ${req.status} - Ghi chú: ${req.notes}</p>
            <a href="update-request?requestId=${req.requestId}">Update</a>
            <a href="cancel-request?requestId=${req.requestId}" onclick="return confirm('Bạn có chắc muốn hủy yêu cầu này?')">Cancel</a><br>
        </c:forEach>
    </div>
    <a href="view-request-history">View Request History</a><br>
    <a href="doctor-dashboard">Back to Dashboard</a>
</body>
</html>