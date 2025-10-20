<%-- 
Document   : verifyReset
Created on : Oct 18, 2025, 3:19:07 AM
Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <form action="VerifyResetServlet" method="post">
            <h2>Xác nhận OTP</h2>
            <label>Nhập mã OTP đã gửi đến email:</label>
            <input type="text" name="otp" required maxlength="6">
            <button type="submit">Xác nhận</button>
        </form>
    <c:if test="${not empty error}">
        <p style="color:red">${error}</p>
    </c:if>

</body>
</html>
