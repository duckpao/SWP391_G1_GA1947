<%-- 
    Document   : verify_otp
    Created on : Oct 17, 2025, 9:28:34 PM
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
        <h3>Nhập mã OTP đã được gửi đến email của bạn</h3>
        <form action="VerifyOTPServlet" method="post">
            <input type="text" name="otp" placeholder="Nhập mã OTP" required>
            <button type="submit">Xác nhận</button>
        </form>
    </body>
</html>
