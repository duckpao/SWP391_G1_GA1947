<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng ký tài khoản</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script>
        function validatePassword() {
            const password = document.getElementById("password").value;
            const confirm = document.getElementById("confirmPassword").value;
            const strength = document.getElementById("strength");

            let msg = "Yếu";
            let regexStrong = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/;
            if (regexStrong.test(password)) {
                msg = "Mạnh";
                strength.style.color = "green";
            } else if (password.length >= 6) {
                msg = "Trung bình";
                strength.style.color = "orange";
            } else {
                msg = "Yếu";
                strength.style.color = "red";
            }
            strength.textContent = "Độ mạnh mật khẩu: " + msg;

            if (confirm && password !== confirm) {
                document.getElementById("match").textContent = "❌ Mật khẩu không khớp";
                document.getElementById("match").style.color = "red";
            } else {
                document.getElementById("match").textContent = "";
            }
        }
    </script>
</head>
<body class="bg-light d-flex align-items-center" style="height:100vh;">
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow">
                <div class="card-header text-center"><h5>Đăng ký tài khoản</h5></div>
                <div class="card-body">
                    <form action="register" method="post">
                        <div class="mb-3">
                            <label>Họ tên</label>
                            <input type="text" name="username" class="form-control" required/>
                        </div>
                        <div class="mb-3">
                            <label>Email</label>
                            <input type="email" name="email" class="form-control" required/>
                        </div>
                        <div class="mb-3">
                            <label>Số điện thoại</label>
                            <input type="text" name="phone" class="form-control" required/>
                        </div>
                        <div class="mb-3">
                            <label>Mật khẩu</label>
                            <input type="password" id="password" name="password" class="form-control" onkeyup="validatePassword()" required/>
                            <small id="strength"></small>
                        </div>
                        <div class="mb-3">
                            <label>Nhập lại mật khẩu</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" onkeyup="validatePassword()" required/>
                            <small id="match"></small>
                        </div>
                        <div class="mb-3">
                            <label>Vai trò</label>
                            <select name="role" class="form-select" required>
                                <option value="Doctor">Doctor</option>
                                <option value="Pharmacist">Pharmacist</option>
                                <option value="Manager">Manager</option>
                                <option value="Auditor">Auditor</option>
                                <option value="Supplier">Supplier</option>
                            </select>
                        </div>
                        <div class="d-grid">
                            <button type="submit" class="btn btn-success">Đăng ký</button>
                        </div>
                        <div class="text-danger mt-2">${error}</div>
                        <div class="text-success mt-2">${message}</div>
                    </form>
                </div>
                <div class="card-footer text-center">
                    <a href="home.jsp">Quay lại Trang chủ</a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
