<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Sửa tài khoản</title>
  <style>
    body {
      font-family: "Nunito Sans", sans-serif;
      background-color: #f7f7f9;
      margin: 0;
      padding: 20px;
    }
    .container {
      max-width: 600px;
      margin: auto;
      padding: 20px;
      background: #fff;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }
    h2 {
      text-align: center;
      color: #2563eb;
    }
    form div {
      margin-bottom: 12px;
    }
    label {
      display: block;
      margin-bottom: 4px;
      font-weight: bold;
    }
    input, select {
      width: 100%;
      padding: 10px;
      margin: 8px 0;
      border-radius: 6px;
      border: 1px solid #ddd;
    }
    .form-actions {
      display: flex;
      justify-content: space-between;
      gap: 10px;
    }
    .form-actions button, .form-actions .cancel-btn {
      width: 48%;
    }
    button {
      background-color: #2563eb;
      color: white;
      border: none;
      padding: 10px 15px;
      border-radius: 6px;
      cursor: pointer;
      font-size: 16px;
    }
    button:hover {
      background-color: #1d4ed8;
    }
    .cancel-btn {
      background-color: #ccc;
      color: black;
      text-decoration: none;
      display: inline-block;
      text-align: center;
      padding: 10px 15px;
      border-radius: 6px;
    }
    .cancel-btn:hover {
      background-color: #b3b3b3;
    }
  </style>
</head>
<body>
  <div class="container">
    <h2>Sửa tài khoản #${user.userId}</h2>
    <form action="${pageContext.request.contextPath}/admin/users/edit" method="post">
      <input type="hidden" name="userId" value="${user.userId}">
      <div><label>Username: <input required name="username" value="${user.username}"></label></div>
      <div><label>Email: <input type="email" name="email" value="${user.email}"></label></div>
      <div><label>Phone: <input name="phone" value="${user.phone}"></label></div>
      <div>
        <label>Role:
          <select name="role">
            <c:set var="r" value="${user.role}" />
            <option value="Admin" ${r=='Admin'?'selected':''}>Admin</option>
            <option value="Doctor" ${r=='Doctor'?'selected':''}>Doctor</option>
            <option value="Pharmacist" ${r=='Pharmacist'?'selected':''}>Pharmacist</option>
            <option value="Manager" ${r=='Manager'?'selected':''}>Manager</option>
            <option value="Auditor" ${r=='Auditor'?'selected':''}>Auditor</option>
            <option value="ProcurementOfficer" ${r=='ProcurementOfficer'?'selected':''}>ProcurementOfficer</option>
            <option value="Supplier" ${r=='Supplier'?'selected':''}>Supplier</option>
          </select>
        </label>
      </div>

      <div class="form-actions">
        <button type="submit">Cập nhật</button>
        <a class="cancel-btn" href="${pageContext.request.contextPath}/admin/users">Quay lại</a>
      </div>
    </form>
  </div>
</body>
</html>
