<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hệ thống Quản lý Kho Thuốc Bệnh viện</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2c5282;
            --secondary-color: #3182ce;
            --success-color: #38a169;
            --warning-color: #d69e2e;
            --danger-color: #e53e3e;
            --light-bg: #f7fafc;
            --card-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        body {
            background-color: var(--light-bg);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .navbar {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            box-shadow: var(--card-shadow);
        }
        
        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
        }
        
        .hero-section {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 4rem 0;
            margin-bottom: 3rem;
        }
        
        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--card-shadow);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border-left: 5px solid var(--secondary-color);
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }
        
        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary-color);
        }
        
        .quick-action-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: var(--card-shadow);
            transition: all 0.3s ease;
            text-decoration: none;
            color: inherit;
            display: block;
        }
        
        .quick-action-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
            text-decoration: none;
            color: inherit;
        }
        
        .quick-action-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }
        
        .recent-activity {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: var(--card-shadow);
        }
        
        .activity-item {
            padding: 1rem;
            border-left: 3px solid var(--secondary-color);
            margin-bottom: 1rem;
            background: #f8f9fa;
            border-radius: 0 8px 8px 0;
        }
        
        .role-badge {
            font-size: 0.9rem;
            padding: 0.3rem 1rem;
            border-radius: 20px;
        }
        
        .alert-card {
            border-radius: 15px;
            border: none;
            box-shadow: var(--card-shadow);
        }
        
        .footer {
            background: var(--primary-color);
            color: white;
            padding: 2rem 0;
            margin-top: 3rem;
        }
        
        @media (max-width: 768px) {
            .hero-section {
                padding: 2rem 0;
            }
            .stat-number {
                font-size: 2rem;
            }
            .quick-action-icon {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="#"><i class="fas fa-hospital-symbol me-2"></i>PharmaCare</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="home.jsp"><i class="fas fa-home me-1"></i>Trang chủ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="inventory.jsp"><i class="fas fa-boxes me-1"></i>Kho thuốc</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="reports.jsp"><i class="fas fa-chart-bar me-1"></i>Báo cáo</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user me-1"></i>
                            <!-- Sử dụng JSTL để hiển thị tên user từ session -->
                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    ${sessionScope.user.fullName}
                                    <span class="role-badge bg-primary ms-2">${sessionScope.user.role}</span>
                                </c:when>
                                <c:otherwise>
                                    Người dùng
                                    <span class="role-badge bg-secondary ms-2">Admin</span>
                                </c:otherwise>
                            </c:choose>
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="profile.jsp"><i class="fas fa-user-cog me-2"></i>Hồ sơ</a></li>
                            <li><a class="dropdown-item" href="settings.jsp"><i class="fas fa-cogs me-2"></i>Cài đặt</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="logout"><i class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container text-center">
            <h1 class="display-4 fw-bold mb-3">Hệ thống Quản lý Kho Thuốc</h1>
            <p class="lead mb-4">Quản lý hiệu quả thuốc men và vật tư y tế cho bệnh viện</p>
            <div class="row">
                <div class="col-md-4">
                    <div class="d-flex align-items-center justify-content-center mb-2">
                        <i class="fas fa-shield-alt fa-2x me-3"></i>
                        <div>
                            <h5 class="mb-0">An toàn</h5>
                            <small>Đảm bảo chất lượng thuốc</small>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="d-flex align-items-center justify-content-center mb-2">
                        <i class="fas fa-chart-line fa-2x me-3"></i>
                        <div>
                            <h5 class="mb-0">Hiệu quả</h5>
                            <small>Tối ưu hóa quy trình</small>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="d-flex align-items-center justify-content-center mb-2">
                        <i class="fas fa-clock fa-2x me-3"></i>
                        <div>
                            <h5 class="mb-0">Kịp thời</h5>
                            <small>Cảnh báo hết hạn</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <div class="container">
        <!-- Statistics Cards -->
        <div class="row mb-4">
            <div class="col-lg-3 col-md-6">
                <div class="stat-card text-center">
                    <i class="fas fa-pills text-primary mb-3" style="font-size: 3rem;"></i>
                    <div class="stat-number">1,247</div>
                    <h6 class="text-muted">Tổng số thuốc</h6>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="stat-card text-center">
                    <i class="fas fa-exclamation-triangle text-warning mb-3" style="font-size: 3rem;"></i>
                    <div class="stat-number text-warning">23</div>
                    <h6 class="text-muted">Sắp hết hạn</h6>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="stat-card text-center">
                    <i class="fas fa-box-open text-danger mb-3" style="font-size: 3rem;"></i>
                    <div class="stat-number text-danger">15</div>
                    <h6 class="text-muted">Sắp hết hàng</h6>
                </div>
            </div>
            <div class="col-lg-3 col-md-6">
                <div class="stat-card text-center">
                    <i class="fas fa-truck text-success mb-3" style="font-size: 3rem;"></i>
                    <div class="stat-number text-success">8</div>
                    <h6 class="text-muted">Đang vận chuyển</h6>
                </div>
            </div>
        </div>

        <!-- Quick Actions & Recent Activity -->
        <div class="row">
            <div class="col-lg-8">
                <h4 class="mb-4"><i class="fas fa-tachometer-alt me-2"></i>Thao tác nhanh</h4>
                <div class="row">
                    <div class="col-md-4">
                        <a href="inventory.jsp" class="quick-action-card text-center">
                            <i class="fas fa-search quick-action-icon text-primary"></i>
                            <h6>Tìm kiếm thuốc</h6>
                            <small class="text-muted">Tra cứu thông tin thuốc</small>
                        </a>
                    </div>
                    <div class="col-md-4">
                        <a href="add-medicine.jsp" class="quick-action-card text-center">
                            <i class="fas fa-plus-circle quick-action-icon text-success"></i>
                            <h6>Thêm thuốc mới</h6>
                            <small class="text-muted">Nhập thuốc vào kho</small>
                        </a>
                    </div>
                    <div class="col-md-4">
                        <a href="stock-check.jsp" class="quick-action-card text-center">
                            <i class="fas fa-clipboard-check quick-action-icon text-info"></i>
                            <h6>Kiểm kê kho</h6>
                            <small class="text-muted">Thực hiện kiểm kê</small>
                        </a>
                    </div>
                    <div class="col-md-4">
                        <a href="prescriptions.jsp" class="quick-action-card text-center">
                            <i class="fas fa-prescription-bottle quick-action-icon text-warning"></i>
                            <h6>Đơn thuốc</h6>
                            <small class="text-muted">Quản lý đơn thuốc</small>
                        </a>
                    </div>
                    <div class="col-md-4">
                        <a href="suppliers.jsp" class="quick-action-card text-center">
                            <i class="fas fa-truck-loading quick-action-icon text-secondary"></i>
                            <h6>Nhà cung cấp</h6>
                            <small class="text-muted">Quản lý đối tác</small>
                        </a>
                    </div>
                    <div class="col-md-4">
                        <a href="reports.jsp" class="quick-action-card text-center">
                            <i class="fas fa-file-alt quick-action-icon text-dark"></i>
                            <h6>Báo cáo</h6>
                            <small class="text-muted">Thống kê và báo cáo</small>
                        </a>
                    </div>
                </div>
            </div>

            <div class="col-lg-4">
                <h4 class="mb-4"><i class="fas fa-history me-2"></i>Hoạt động gần đây</h4>
                <div class="recent-activity">
                    <div class="activity-item">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <strong>Nhập kho thuốc mới</strong>
                                <p class="mb-1 text-muted">Paracetamol 500mg - 100 viên</p>
                                <small class="text-muted"><i class="fas fa-clock me-1"></i>2 giờ trước</small>
                            </div>
                            <span class="badge bg-success">Hoàn thành</span>
                        </div>
                    </div>
                    
                    <div class="activity-item">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <strong>Kiểm tra hạn sử dụng</strong>
                                <p class="mb-1 text-muted">Phát hiện 5 loại thuốc sắp hết hạn</p>
                                <small class="text-muted"><i class="fas fa-clock me-1"></i>4 giờ trước</small>
                            </div>
                            <span class="badge bg-warning">Cần xử lý</span>
                        </div>
                    </div>
                    
                    <div class="activity-item">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <strong>Xuất thuốc theo đơn</strong>
                                <p class="mb-1 text-muted">Đơn thuốc #DT-2024-001</p>
                                <small class="text-muted"><i class="fas fa-clock me-1"></i>6 giờ trước</small>
                            </div>
                            <span class="badge bg-info">Đã xuất</span>
                        </div>
                    </div>
                    
                    <div class="activity-item">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <strong>Kiểm kê định kỳ</strong>
                                <p class="mb-1 text-muted">Khu vực A - Tủ thuốc 1-5</p>
                                <small class="text-muted"><i class="fas fa-clock me-1"></i>1 ngày trước</small>
                            </div>
                            <span class="badge bg-success">Hoàn thành</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Alerts Section -->
        <div class="row mt-4">
            <div class="col-12">
                <h4 class="mb-3"><i class="fas fa-bell me-2"></i>Cảnh báo hệ thống</h4>
            </div>
            <div class="col-md-4">
                <div class="alert alert-warning alert-card">
                    <h6 class="alert-heading"><i class="fas fa-exclamation-triangle me-2"></i>Thuốc sắp hết hạn</h6>
                    <p class="mb-0">23 loại thuốc sẽ hết hạn trong vòng 30 ngày tới.</p>
                    <hr>
                    <a href="expiry-check.jsp" class="btn btn-warning btn-sm">Xem chi tiết</a>
                </div>
            </div>
            <div class="col-md-4">
                <div class="alert alert-danger alert-card">
                    <h6 class="alert-heading"><i class="fas fa-box-open me-2"></i>Tồn kho thấp</h6>
                    <p class="mb-0">15 loại thuốc có số lượng dưới mức tồn kho tối thiểu.</p>
                    <hr>
                    <a href="low-stock.jsp" class="btn btn-danger btn-sm">Xem chi tiết</a>
                </div>
            </div>
            <div class="col-md-4">
                <div class="alert alert-info alert-card">
                    <h6 class="alert-heading"><i class="fas fa-clipboard-check me-2"></i>Kiểm kê định kỳ</h6>
                    <p class="mb-0">Đến hạn kiểm kê khu vực B vào tuần tới.</p>
                    <hr>
                    <a href="audit-schedule.jsp" class="btn btn-info btn-sm">Lên lịch</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer mt-5">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5><i class="fas fa-hospital-symbol me-2"></i>PharmaCare</h5>
                    <p>Hệ thống quản lý kho thuốc chuyên nghiệp cho bệnh viện</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <p>&copy; 2024 PharmaCare. Tất cả quyền được bảo lưu.</p>
                    <p><i class="fas fa-phone me-1"></i>Hotline: 1900-1234 | <i class="fas fa-envelope me-1"></i>support@pharmacare.vn</p>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
</body>
</html>