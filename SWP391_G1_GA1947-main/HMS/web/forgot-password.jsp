<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quên mật khẩu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center" style="height:100vh;">
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card shadow">
                <div class="card-header text-center">
                    <h5>Quên mật khẩu</h5>
                </div>
                <div class="card-body">
                    <form action="forgot-password" method="post">
                        <div class="mb-3">
                            <label>Email hoặc Số điện thoại</label>
                            <input type="text" name="emailOrPhone" class="form-control" required>
                        </div>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary">Gửi link đặt lại</button>
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
