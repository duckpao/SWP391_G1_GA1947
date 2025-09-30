<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { margin: 0; font-family: Arial, sans-serif; }
        .sidebar {
            width: 240px; background: #2c3e50; color: #ecf0f1;
            position: fixed; top: 0; bottom: 0; padding-top: 20px;
        }
        .sidebar h4 { text-align: center; margin-bottom: 20px; }
        .sidebar a {
            display: block; padding: 12px 20px; color: #ecf0f1;
            text-decoration: none; font-size: 15px;
        }
        .sidebar a:hover { background: #34495e; }
        .content {
            margin-left: 240px; padding: 20px;
            background: #f5f6fa; min-height: 100vh;
        }
        .header {
            background: #fff; padding: 10px 20px; margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <h4>🌐 Menu</h4>

        <!-- Admin -->
        <c:if test="${sessionScope.role eq 'admin'}">
            <a href="${pageContext.request.contextPath}/Dashboard?page=medicine">Quản lý thuốc</a>
            <a href="${pageContext.request.contextPath}/Dashboard?page=users">Quản lý người dùng</a>
            <a href="${pageContext.request.contextPath}/Dashboard?page=reports">Báo cáo</a>
        </c:if>

        <!-- Doctor -->
        <c:if test="${sessionScope.role eq 'doctor'}">
            <a href="${pageContext.request.contextPath}/Medicine/MedicineList">📋 View Medicine Info</a>
            <a href="${pageContext.request.contextPath}/Dashboard?page=patients">Khám bệnh</a>
        </c:if>

        <!-- Pharmacist -->
        <c:if test="${sessionScope.role eq 'pharmacist'}">
            <a href="${pageContext.request.contextPath}/Medicine/MedicineList">📋 View Medicine Info</a>
            <a href="${pageContext.request.contextPath}/Dashboard?page=addMedicine">Thêm thuốc</a>
            <a href="${pageContext.request.contextPath}/Dashboard?page=expired">Thuốc hết hạn</a>
        </c:if>

        <!-- Supplier -->
        <c:if test="${sessionScope.role eq 'supplier'}">
            <a href="${pageContext.request.contextPath}/Dashboard?page=supply">Cung cấp thuốc</a>
        </c:if>

        <!-- Auditor -->
        <c:if test="${sessionScope.role eq 'auditor'}">
            <a href="${pageContext.request.contextPath}/Dashboard?page=reports">Kiểm toán & Báo cáo</a>
        </c:if>
    </div>

    <!-- Nội dung -->
    <div class="content">
        <div class="header">
            Xin chào, <b>${sessionScope.user.username}</b> (Role: ${sessionScope.role})
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-danger float-end">Đăng xuất</a>
        </div>

        <c:choose>
            <c:when test="${page eq 'medicine'}">
                <jsp:include page="/Medicine/MedicineList.jsp"/>
            </c:when>
            <c:when test="${page eq 'addMedicine'}">
                <jsp:include page="/Medicine/addMedicine.jsp"/>
            </c:when>
            <c:when test="${page eq 'users'}">
                <h3>Quản lý người dùng (Admin)</h3>
            </c:when>
            <c:when test="${page eq 'patients'}">
                <h3>Khám bệnh (Doctor)</h3>
            </c:when>
            <c:when test="${page eq 'supply'}">
                <h3>Cung cấp thuốc (Supplier)</h3>
            </c:when>
            <c:when test="${page eq 'expired'}">
                <h3>Danh sách thuốc hết hạn (Pharmacist)</h3>
            </c:when>
            <c:when test="${page eq 'reports'}">
                <h3>Báo cáo / kiểm toán</h3>
            </c:when>
            <c:otherwise>
                <h2>Chào mừng đến với hệ thống!</h2>
                <p>Chọn chức năng ở menu bên trái.</p>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
