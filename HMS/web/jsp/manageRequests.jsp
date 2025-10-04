<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Manage Medication Requests</title>
</head>
<body>
    <h1>Manage Medication Requests</h1>
    <!-- Hiển thị thông báo dựa trên tham số message -->
    <c:if test="${not empty param.message}">
        <c:choose>
            <c:when test="${param.message == 'cancel_success'}">
                <p style="color:green">Hủy yêu cầu thành công!</p>
            </c:when>
            <c:when test="${param.message == 'error_cancel'}">
                <p style="color:red">Hủy yêu cầu thất bại. Vui lòng thử lại!</p>
            </c:when>
        </c:choose>
    </c:if>
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