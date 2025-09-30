<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Admin Dashboard - Users</title>
  <style>
    body{font-family:system-ui,Arial;margin:24px;background:#f7f7f9}
    .topbar{display:flex;justify-content:space-between;align-items:center;margin-bottom:16px}
    table{width:100%;border-collapse:collapse;background:#fff}
    th,td{border:1px solid #e5e7eb;padding:10px}
    th{background:#f3f4f6;text-align:left}
    .btn{padding:6px 10px;border:1px solid #d1d5db;background:#fff;border-radius:6px;cursor:pointer}
    .btn.primary{background:#2563eb;color:#fff;border-color:#2563eb}
    .badge{padding:2px 8px;border-radius:999px;font-size:12px}
    .green{background:#dcfce7;color:#166534}
    .red{background:#fee2e2;color:#991b1b}
    form.inline{display:inline}
  </style>
</head>
<body>
  <div class="topbar">
    <h2>Quản trị người dùng</h2>
    <a class="btn primary" href="${pageContext.request.contextPath}/admin/users/create">+ Tạo tài khoản</a>
  </div>

  <table>
    <thead>
      <tr>
        <th>ID</th><th>Username</th><th>Email</th><th>Phone</th>
        <th>Role</th><th>Trạng thái</th><th>Hành động</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="u" items="${users}">
        <tr>
          <td>${u.userId}</td>
          <td>${u.username}</td>
          <td>${u.email}</td>
          <td>${u.phone}</td>
          <td>${u.role}</td>
          <td>
            <span class="badge ${u.isActive ? 'green' : 'red'}">
              ${u.isActive ? 'Active' : 'Locked'}
            </span>
          </td>
          <td>
            <a class="btn" href="${pageContext.request.contextPath}/admin/users/edit?id=${u.userId}">Sửa</a>

            <!-- Khóa/Mở khóa dùng POST -->
            <form class="inline" action="${pageContext.request.contextPath}/admin/users/toggle" method="post">
              <input type="hidden" name="id" value="${u.userId}" />
              <!-- gửi giá trị ngược lại để toggle -->
              <input type="hidden" name="active" value="${!u.isActive}" />
              <button class="btn" type="submit">
                <c:out value="${u.isActive ? 'Khóa' : 'Mở khóa'}" />
              </button>
            </form>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
</body>
</html>
