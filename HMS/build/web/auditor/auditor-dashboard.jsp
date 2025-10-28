<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Auditor Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .nav-link {
            color: rgba(255,255,255,0.8);
            padding: 12px 20px;
            border-radius: 8px;
            margin: 5px 0;
            transition: all 0.3s;
        }
        .nav-link:hover, .nav-link.active {
            background: rgba(255,255,255,0.2);
            color: white;
        }
        .card-dashboard {
            border: none;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }
        .card-dashboard:hover {
            transform: translateY(-5px);
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 sidebar p-0">
                <div class="p-4">
                    <h4><i class="bi bi-hospital"></i> Pharmacy</h4>
                    <hr class="bg-white">
                    <div class="mb-3">
                        <small>Xin chào!</small>
                        <h6>${sessionScope.username}</h6>
                        <span class="badge bg-light text-dark">${sessionScope.role}</span>
                    </div>
                </div>
                
                <nav class="nav flex-column px-3">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/auditor/auditor-dashboard.jsp">
                        <i class="bi bi-speedometer2"></i> Dashboard
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/purchase-orders">
                        <i class="bi bi-receipt"></i> Purchase Orders
                    </a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/purchase-orders/history">
                        <i class="bi bi-clock-history"></i> PO History & Trends
                    </a>
                    <a class="nav-link" href="#">
                        <i class="bi bi-box-seam"></i> Inventory Audit
                    </a>
                    <a class="nav-link" href="#">
                        <i class="bi bi-graph-up"></i> Reports
                    </a>
                    <a class="nav-link" href="#">
                        <i class="bi bi-journal-text"></i> System Logs
                    </a>
                    <hr class="bg-white">
                    <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                        <i class="bi bi-box-arrow-right"></i> Đăng xuất
                    </a>
                </nav>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-10 p-4">
                <h2 class="mb-4">
                    <i class="bi bi-speedometer2"></i> Auditor Dashboard
                </h2>
                
                <!-- Quick Stats -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card card-dashboard border-start border-primary border-4">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h6 class="text-muted">Total Orders</h6>
                                        <h3 class="mb-0">156</h3>
                                    </div>
                                    <div class="text-primary">
                                        <i class="bi bi-cart fs-1"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card card-dashboard border-start border-success border-4">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h6 class="text-muted">Completed</h6>
                                        <h3 class="mb-0">124</h3>
                                    </div>
                                    <div class="text-success">
                                        <i class="bi bi-check-circle fs-1"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card card-dashboard border-start border-warning border-4">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h6 class="text-muted">Pending</h6>
                                        <h3 class="mb-0">32</h3>
                                    </div>
                                    <div class="text-warning">
                                        <i class="bi bi-clock fs-1"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card card-dashboard border-start border-info border-4">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h6 class="text-muted">Total Value</h6>
                                        <h3 class="mb-0">$458K</h3>
                                    </div>
                                    <div class="text-info">
                                        <i class="bi bi-cash-stack fs-1"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Quick Actions -->
                <div class="row mb-4">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header bg-white">
                                <h5 class="mb-0"><i class="bi bi-lightning"></i> Quick Actions</h5>
                            </div>
                            <div class="card-body">
                                <div class="row g-3">
                                    <div class="col-md-4">
                                        <a href="${pageContext.request.contextPath}/purchase-orders" 
                                           class="btn btn-outline-primary w-100 py-3">
                                            <i class="bi bi-receipt fs-4 d-block mb-2"></i>
                                            <strong>View Purchase Orders</strong>
                                            <small class="d-block text-muted">Check all PO records</small>
                                        </a>
                                    </div>
                                    <div class="col-md-4">
                                        <a href="#" class="btn btn-outline-success w-100 py-3">
                                            <i class="bi bi-box-seam fs-4 d-block mb-2"></i>
                                            <strong>Inventory Audit</strong>
                                            <small class="d-block text-muted">Verify stock levels</small>
                                        </a>
                                    </div>
                                    <div class="col-md-4">
                                        <a href="#" class="btn btn-outline-info w-100 py-3">
                                            <i class="bi bi-file-earmark-text fs-4 d-block mb-2"></i>
                                            <strong>Generate Report</strong>
                                            <small class="d-block text-muted">Create audit reports</small>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Recent Activity -->
                <div class="row">
                    <div class="col-md-12">
                        <div class="card">
                            <div class="card-header bg-white">
                                <h5 class="mb-0"><i class="bi bi-clock-history"></i> Recent Activity</h5>
                            </div>
                            <div class="card-body">
                                <div class="list-group list-group-flush">
                                    <div class="list-group-item">
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <i class="bi bi-receipt text-primary"></i>
                                                <strong>PO #1234</strong> - Reviewed by Admin
                                            </div>
                                            <small class="text-muted">2 hours ago</small>
                                        </div>
                                    </div>
                                    <div class="list-group-item">
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <i class="bi bi-box-seam text-success"></i>
                                                <strong>Inventory</strong> - Stock updated
                                            </div>
                                            <small class="text-muted">5 hours ago</small>
                                        </div>
                                    </div>
                                    <div class="list-group-item">
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <i class="bi bi-file-earmark-text text-info"></i>
                                                <strong>Report</strong> - Monthly audit completed
                                            </div>
                                            <small class="text-muted">1 day ago</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>