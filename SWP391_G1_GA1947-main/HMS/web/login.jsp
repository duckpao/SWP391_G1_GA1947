<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Login</title>
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    .login-box {
      max-width: 360px;
      margin: auto;
      padding: 30px;
    }
    .login-box h3 {
      margin-bottom: 20px;
    }
    .form-control {
      padding: 8px 12px;
      font-size: 14px;
    }
    .form-outline {
      margin-bottom: 15px; 
    }
    .btn-login {
      width: 100%;
      padding: 8px;
    }
  </style>
</head>
<body>

<section class="vh-100 d-flex align-items-center">
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-sm-6">
        <div class="login-box shadow rounded">
          <h3 class="fw-bold text-center">Đăng nhập</h3>

<form action="${pageContext.request.contextPath}/login" method="post">


            <div class="form-outline">
              <input type="text" id="formUsername" name="username" class="form-control" required />
              <label class="form-label" for="formUsername">Tên đăng nhập</label>
            </div>

            <div class="form-outline">
              <input type="password" id="formPassword" name="password" class="form-control" required />
              <label class="form-label" for="formPassword">Mật khẩu</label>
            </div>

            <button class="btn btn-info btn-login mt-2" type="submit">Đăng nhập</button>

            <c:if test="${not empty error}">
              <p class="text-danger mt-2">${error}</p>
            </c:if>

            <p class="small mt-3"><a class="text-muted" href="#!">Quên mật khẩu?</a></p>
            <p class="small">Chưa có tài khoản? <a href="#!" class="link-info">Đăng ký</a></p>
          </form>
        </div>
      </div>
    </div>
  </div>
</section>

</body>
</html>
