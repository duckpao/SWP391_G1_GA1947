<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center" style="height:100vh;">
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card shadow">
                <div class="card-header text-center">
                    <h5>Đăng nhập</h5>
                </div>
                <div class="card-body">
                    <form action="login" method="post">
                        <div class="mb-3">
                            <label>Email</label>
                            <input type="email" name="email" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label>Mật khẩu</label>
                            <input type="password" name="password" class="form-control" required>
                        </div>
                        <div class="d-grid mb-2">
                            <button type="submit" class="btn btn-success">Đăng nhập</button>
                        </div>
                        <div class="text-danger">${error}</div>
                        <div class="text-success">${message}</div>
                    </form>
                </div>
                <div class="card-footer text-center">
                    <a href="register.jsp">Đăng ký</a> | 
                    <a href="forgot-password.jsp">Quên mật khẩu?</a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
