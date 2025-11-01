<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ Sơ Người Dùng - ${user.username}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background-color: #ffffff;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .profile-header {
            background: #ffffff;
            color: #2c3e50;
            padding: 40px 0;
            margin-bottom: 30px;
            border-bottom: 2px solid #e9ecef;
        }
        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
            color: #6c757d;
            margin: 0 auto 20px;
            border: 3px solid #dee2e6;
        }
        .profile-card {
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            border: 1px solid #e9ecef;
            padding: 30px;
            margin-bottom: 30px;
        }
        .info-row {
            padding: 15px 0;
            border-bottom: 1px solid #f1f3f5;
        }
        .info-row:last-child {
            border-bottom: none;
        }
        .info-label {
            font-weight: 600;
            color: #868e96;
            margin-bottom: 5px;
            font-size: 0.9rem;
        }
        .info-value {
            color: #2c3e50;
            font-size: 1.1rem;
        }
        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 600;
            display: inline-block;
        }
        .status-active {
            background-color: #e8f5e9;
            color: #2e7d32;
            border: 1px solid #a5d6a7;
        }
        .status-inactive {
            background-color: #ffebee;
            color: #c62828;
            border: 1px solid #ef9a9a;
        }
        .role-badge {
            padding: 6px 12px;
            border-radius: 15px;
            font-weight: 600;
            font-size: 0.9rem;
            border: 1px solid;
        }
        .role-admin {
            background-color: #ffebee;
            color: #c62828;
            border-color: #ef9a9a;
        }
        .role-supplier {
            background-color: #e8f5e9;
            color: #2e7d32;
            border-color: #a5d6a7;
        }
        .role-customer {
            background-color: #e3f2fd;
            color: #1565c0;
            border-color: #90caf9;
        }
        .section-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #dee2e6;
        }
        .btn-edit-profile {
            background: #495057;
            border: 1px solid #343a40;
            color: white;
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s;
        }
        .btn-edit-profile:hover {
            background: #343a40;
            border-color: #212529;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(52, 58, 64, 0.2);
        }
        .btn-outline-secondary {
            border: 2px solid #6c757d;
            color: #6c757d;
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s;
            background: white;
        }
        .btn-outline-secondary:hover {
            background: #6c757d;
            color: white;
            border-color: #6c757d;
            transform: translateY(-1px);
        }
        .supplier-rating {
            font-size: 1.5rem;
            color: #ff9800;
        }
        
        .alert {
            margin-bottom: 20px;
            border-radius: 8px;
            animation: slideDown 0.5s ease;
            border: 1px solid;
        }
        
        .alert-success {
            background-color: #e8f5e9;
            color: #2e7d32;
            border-color: #a5d6a7;
        }
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
    <script>
        function goBackToDashboard() {
            var role = '${user.role}';
            var dashboardUrl = '';
            
            switch(role.toLowerCase()) {
                case 'admin':
                    dashboardUrl = 'admin-dashboard';
                    break;
                case 'supplier':
                    dashboardUrl = 'supplier-dashboard';
                    break;
                case 'auditor':
                    dashboardUrl = 'auditor-dashboard';
                    break;
                case 'doctor':
                    dashboardUrl = 'doctor-dashboard';
                    break;
                case 'pharmacist':
                    dashboardUrl = 'view-medicine';
                    break;
                default:
                    dashboardUrl = 'logout';
                    break;
            }
            
            window.location.href = dashboardUrl;
        }
    </script>
</head>
<body>
    <!-- Profile Header -->
    <div class="profile-header">
        <div class="container">
            <div class="profile-avatar">
                <i class="fas fa-user"></i>
            </div>
            <h2 class="text-center mb-2">${user.username}</h2>
            <p class="text-center mb-0">
                <span class="role-badge 
                    <c:choose>
                        <c:when test="${user.role == 'Admin'}">role-admin</c:when>
                        <c:when test="${user.role == 'Supplier'}">role-supplier</c:when>
                        <c:otherwise>role-customer</c:otherwise>
                    </c:choose>">
                    <i class="fas fa-user-tag me-1"></i>${user.role}
                </span>
            </p>
        </div>
    </div>

    <div class="container pb-5">
        <!-- Success Message -->
        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <div class="row">
            <!-- Thông Tin Cá Nhân -->
            <div class="col-lg-6 mb-4">
                <div class="profile-card">
                    <h3 class="section-title">
                        <i class="fas fa-user-circle me-2"></i>Thông Tin Cá Nhân
                    </h3>
                    
                    <div class="info-row">
                        <div class="info-label">
                            <i class="fas fa-id-card me-2"></i>Mã Người Dùng
                        </div>
                        <div class="info-value">#${user.userId}</div>
                    </div>
                    
                    <div class="info-row">
                        <div class="info-label">
                            <i class="fas fa-user me-2"></i>Tên Đăng Nhập
                        </div>
                        <div class="info-value">${user.username}</div>
                    </div>
                    
                    <div class="info-row">
                        <div class="info-label">
                            <i class="fas fa-envelope me-2"></i>Email
                        </div>
                        <div class="info-value">${user.email}</div>
                    </div>
                    
                    <div class="info-row">
                        <div class="info-label">
                            <i class="fas fa-phone me-2"></i>Số Điện Thoại
                        </div>
                        <div class="info-value">${user.phone}</div>
                    </div>
                    
                    <div class="info-row">
                        <div class="info-label">
                            <i class="fas fa-shield-alt me-2"></i>Vai Trò
                        </div>
                        <div class="info-value">
                            <span class="role-badge 
                                <c:choose>
                                    <c:when test="${user.role == 'Admin'}">role-admin</c:when>
                                    <c:when test="${user.role == 'Supplier'}">role-supplier</c:when>
                                    <c:otherwise>role-customer</c:otherwise>
                                </c:choose>">
                                ${user.role}
                            </span>
                        </div>
                    </div>
                    
                    <div class="info-row">
                        <div class="info-label">
                            <i class="fas fa-toggle-on me-2"></i>Trạng Thái
                        </div>
                        <div class="info-value">
                            <span class="status-badge ${user.isActive ? 'status-active' : 'status-inactive'}">
                                <i class="fas ${user.isActive ? 'fa-check-circle' : 'fa-ban'} me-1"></i>
                                ${user.isActive ? 'Hoạt Động' : 'Khóa'}
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Thông Tin Hoạt Động -->
            <div class="col-lg-6 mb-4">
                <div class="profile-card">
                    <h3 class="section-title">
                        <i class="fas fa-chart-line me-2"></i>Thông Tin Hoạt Động
                    </h3>
                    
                    <div class="info-row">
                        <div class="info-label">
                            <i class="fas fa-clock me-2"></i>Đăng Nhập Gần Nhất
                        </div>
                        <div class="info-value">
                            <c:choose>
                                <c:when test="${user.lastLogin != null}">
                                    <fmt:formatDate value="${user.lastLogin}" pattern="dd/MM/yyyy HH:mm:ss" />
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">Chưa đăng nhập</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Thông Tin Supplier (nếu có) -->
                    <c:if test="${user.role == 'Supplier' && supplier != null}">
                        <div class="mt-4">
                            <h4 class="section-title">
                                <i class="fas fa-building me-2"></i>Thông Tin Nhà Cung Cấp
                            </h4>
                            
                            <div class="info-row">
                                <div class="info-label">
                                    <i class="fas fa-hashtag me-2"></i>Mã Nhà Cung Cấp
                                </div>
                                <div class="info-value">#${supplier.supplierId}</div>
                            </div>
                            
                            <div class="info-row">
                                <div class="info-label">
                                    <i class="fas fa-store me-2"></i>Tên Công Ty
                                </div>
                                <div class="info-value">${supplier.name}</div>
                            </div>
                            
                            <div class="info-row">
                                <div class="info-label">
                                    <i class="fas fa-map-marker-alt me-2"></i>Địa Chỉ
                                </div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty supplier.address}">
                                            ${supplier.address}
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Chưa cập nhật</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            
                            <div class="info-row">
                                <div class="info-label">
                                    <i class="fas fa-star me-2"></i>Đánh Giá
                                </div>
                                <div class="info-value">
                                    <span class="supplier-rating">
                                        <c:choose>
                                            <c:when test="${supplier.performanceRating != null}">
                                                <fmt:formatNumber value="${supplier.performanceRating}" pattern="#0.0" />
                                                <i class="fas fa-star"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted" style="font-size: 1rem;">Chưa có đánh giá</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                            
                            <div class="info-row">
                                <div class="info-label">
                                    <i class="fas fa-calendar-plus me-2"></i>Ngày Tạo
                                </div>
                                <div class="info-value">
                                    <c:if test="${supplier.createdAt != null}">
                                        <fmt:parseDate value="${supplier.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                        <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm" />
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Action Buttons -->
        <div class="text-center mt-4">
            <button onclick="goBackToDashboard()" class="btn btn-outline-secondary me-3">
                <i class="fas fa-arrow-left me-2"></i>Quay Lại Dashboard
            </button>
            <a href="edit-profile" class="btn btn-edit-profile me-3">
                <i class="fas fa-edit me-2"></i>Chỉnh Sửa Hồ Sơ
            </a>
            <a href="change-password" class="btn btn-outline-secondary">
                <i class="fas fa-key me-2"></i>Đổi Mật Khẩu
            </a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>