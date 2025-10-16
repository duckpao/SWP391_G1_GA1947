<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đặt lại mật khẩu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script>
        function validatePassword() {
            const newPass = document.getElementById("newPassword").value;
            const confirm = document.getElementById("confirmPassword").value;
            const match = document.getElementById("match");

            if (confirm && newPass !== confirm) {
                match.textContent = "❌ Mật khẩu không khớp";
                match.style.color = "red";
            } else {
                match.textContent = "";
            }
        }
    </script>
</head>
<body class="bg-light d-flex align-items-center" style="height:100vh;">
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card shadow">
                <div class="card-header text-center">
                    <h5>Đặt lại mật khẩu</h5>
                </div>
                <div class="card-body">
                    <form action="reset-password" method="post">
                        <div class="mb-3">
                            <label>Mật khẩu mới</label>
                            <input type="password" id="newPassword" name="newPassword" class="form-control" onkeyup="validatePassword()" required>
                        </div>
                        <div class="mb-3">
                            <label>Nhập lại mật khẩu mới</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" onkeyup="validatePassword()" required>
                            <small id="match"></small>
                        </div>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-success">Lưu thay đổi</button>
                        </div>
                        <div class="text-danger mt-2">${error}</div>
                        <div class="text-success mt-2">${message}</div>
                    </form>
                </div>
                <div class="card-footer text-center">
                    <a href="login.jsp">Quay lại Đăng nhập</a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
