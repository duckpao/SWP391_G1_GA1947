<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Auditor Dashboard</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
                background: #f9fafb;
                min-height: 100vh;
                color: #374151;
            }

            .dashboard-container {
                display: flex;
                min-height: 100vh;
            }

            /* Sidebar styling - changed from purple gradient to white with border */
            .sidebar {
                width: 280px;
                background: white;
                color: #1f2937;
                padding: 30px 20px;
                box-shadow: 2px 0 10px rgba(0, 0, 0, 0.08);
                overflow-y: auto;
                border-right: 1px solid #e5e7eb;
            }

            .sidebar-header {
                margin-bottom: 30px;
            }

            .sidebar-header h4 {
                font-size: 20px;
                font-weight: 700;
                margin-bottom: 15px;
                display: flex;
                align-items: center;
                gap: 10px;
                color: #1f2937;
            }

            .sidebar-header hr {
                border: none;
                border-top: 1px solid #e5e7eb;
                margin: 15px 0;
            }

            /* Removed user-info styling as it's now in header */
            .user-info {
                display: none;
            }

            .user-info small {
                font-size: 12px;
                opacity: 0.7;
                color: #6b7280;
            }

            .user-info h6 {
                font-size: 16px;
                font-weight: 600;
                margin: 5px 0;
                color: #1f2937;
            }

            .user-badge {
                display: inline-block;
                background: #ede9fe;
                color: #7c3aed;
                padding: 4px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                margin-top: 8px;
            }

            .nav-link {
                color: #6b7280;
                text-decoration: none;
                padding: 12px 16px;
                border-radius: 10px;
                margin: 6px 0;
                display: flex;
                align-items: center;
                gap: 12px;
                transition: all 0.3s ease;
                font-size: 14px;
                font-weight: 500;
            }

            .nav-link:hover,
            .nav-link.active {
                background: #f3f4f6;
                color: #3b82f6;
                transform: translateX(4px);
            }

            .nav-divider {
                border: none;
                border-top: 1px solid #e5e7eb;
                margin: 15px 0;
            }

            /* Main content area styling */
            .main-content {
                flex: 1;
                padding: 40px;
                overflow-y: auto;
                background: #f9fafb;
            }

            .page-header {
                margin-bottom: 30px;
            }

            /* Page header text color changed from white to dark gray */
            .page-header h2 {
                font-size: 32px;
                font-weight: 700;
                color: #1f2937;
                display: flex;
                align-items: center;
                gap: 12px;
            }

            /* Stats cards with custom styling */
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            /* Stat card border color changed from purple to blue */
            .stat-card {
                background: white;
                border-radius: 15px;
                padding: 24px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
                transition: all 0.3s ease;
                border-left: 5px solid #3b82f6;
            }

            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 15px 40px rgba(0, 0, 0, 0.12);
            }

            .stat-card.primary {
                border-left-color: #3b82f6;
            }

            .stat-card.success {
                border-left-color: #10b981;
            }

            .stat-card.warning {
                border-left-color: #f59e0b;
            }

            .stat-card.info {
                border-left-color: #3b82f6;
            }

            .stat-content {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
            }

            .stat-info h6 {
                font-size: 13px;
                font-weight: 600;
                color: #9ca3af;
                margin-bottom: 8px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .stat-info h3 {
                font-size: 28px;
                font-weight: 700;
                color: #1f2937;
                margin: 0;
            }

            .stat-icon {
                font-size: 32px;
                opacity: 0.8;
            }

            /* Card styling */
            .dashboard-card {
                background: white;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
                margin-bottom: 30px;
                overflow: hidden;
            }

            .card-header {
                background: white;
                padding: 24px;
                border-bottom: 1px solid #e5e7eb;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .card-header h5 {
                font-size: 18px;
                font-weight: 700;
                color: #1f2937;
                margin: 0;
            }

            .card-body {
                padding: 24px;
            }

            /* Quick actions buttons */
            .quick-actions {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 16px;
            }

            .action-btn {
                background: white;
                border: 2px solid #e5e7eb;
                border-radius: 12px;
                padding: 24px;
                text-align: center;
                text-decoration: none;
                color: #374151;
                transition: all 0.3s ease;
                cursor: pointer;
                font-family: inherit;
            }

            /* Action button hover color changed from purple to blue */
            .action-btn:hover {
                border-color: #3b82f6;
                background: #f9fafb;
                transform: translateY(-3px);
                box-shadow: 0 10px 25px rgba(59, 130, 246, 0.15);
            }

            .action-btn i {
                font-size: 28px;
                display: block;
                margin-bottom: 12px;
                color: #3b82f6;
            }

            .action-btn strong {
                display: block;
                font-size: 15px;
                font-weight: 600;
                margin-bottom: 6px;
            }

            .action-btn small {
                display: block;
                font-size: 13px;
                color: #9ca3af;
            }

            /* Activity list styling */
            .activity-list {
                list-style: none;
            }

            .activity-item {
                padding: 16px 0;
                border-bottom: 1px solid #e5e7eb;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .activity-item:last-child {
                border-bottom: none;
            }

            .activity-content {
                display: flex;
                align-items: center;
                gap: 12px;
                flex: 1;
            }

            .activity-icon {
                font-size: 20px;
                width: 40px;
                height: 40px;
                display: flex;
                align-items: center;
                justify-content: center;
                background: #f3f4f6;
                border-radius: 8px;
            }

            .activity-text {
                font-size: 14px;
                color: #374151;
            }

            .activity-text strong {
                font-weight: 600;
                color: #1f2937;
            }

            .activity-time {
                font-size: 13px;
                color: #9ca3af;
                white-space: nowrap;
                margin-left: 16px;
            }

            /* Scrollbar styling */
            ::-webkit-scrollbar {
                width: 8px;
            }

            ::-webkit-scrollbar-track {
                background: rgba(0, 0, 0, 0.05);
            }

            ::-webkit-scrollbar-thumb {
                background: rgba(0, 0, 0, 0.2);
                border-radius: 4px;
            }

            ::-webkit-scrollbar-thumb:hover {
                background: rgba(0, 0, 0, 0.3);
            }

            /* Responsive design */
            @media (max-width: 768px) {
                .dashboard-container {
                    flex-direction: column;
                }

                .sidebar {
                    width: 100%;
                    padding: 20px;
                }

                .main-content {
                    padding: 20px;
                }

                .page-header h2 {
                    font-size: 24px;
                }

                .stats-grid {
                    grid-template-columns: 1fr;
                }

                .quick-actions {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <%@ include file="header.jsp" %>
    <body>
        
            <div class="dashboard-container">
                <!-- Sidebar -->
                <div class="sidebar">
                    <div class="sidebar-header">
                        <h4><i class="bi bi-hospital"></i> Auditor</h4>
                        <hr class="sidebar-divider">
                        <!-- Removed user-info section from sidebar -->
                    </div>

                    <nav>
                        <a class="nav-link active" href="${pageContext.request.contextPath}/auditor-dashboard">
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
                        <hr class="nav-divider">
                        <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                            <i class="bi bi-box-arrow-right"></i> Đăng xuất
                        </a>
                    </nav>
                </div>

                <!-- Main Content -->
                <div class="main-content">
                    <div class="page-header">
                        <h2><i class="bi bi-speedometer2"></i> Auditor Dashboard</h2>
                    </div>

                    <!-- Quick Stats -->
                    <div class="stats-grid">
                        <div class="stat-card primary">
                            <div class="stat-content">
                                <div class="stat-info">
                                    <h6>Total Orders</h6>
                                    <h3>156</h3>
                                </div>
                                <div class="stat-icon" style="color: #3b82f6;">
                                    <i class="bi bi-cart"></i>
                                </div>
                            </div>
                        </div>
                        <div class="stat-card success">
                            <div class="stat-content">
                                <div class="stat-info">
                                    <h6>Completed</h6>
                                    <h3>124</h3>
                                </div>
                                <div class="stat-icon" style="color: #10b981;">
                                    <i class="bi bi-check-circle"></i>
                                </div>
                            </div>
                        </div>
                        <div class="stat-card warning">
                            <div class="stat-content">
                                <div class="stat-info">
                                    <h6>Pending</h6>
                                    <h3>32</h3>
                                </div>
                                <div class="stat-icon" style="color: #f59e0b;">
                                    <i class="bi bi-clock"></i>
                                </div>
                            </div>
                        </div>
                        <div class="stat-card info">
                            <div class="stat-content">
                                <div class="stat-info">
                                    <h6>Total Value</h6>
                                    <h3>$458K</h3>
                                </div>
                                <div class="stat-icon" style="color: #3b82f6;">
                                    <i class="bi bi-cash-stack"></i>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Quick Actions -->
                    <div class="dashboard-card">
                        <div class="card-header">
                            <h5><i class="bi bi-lightning"></i> Quick Actions</h5>
                        </div>
                        <div class="card-body">
                            <div class="quick-actions">
                                <a href="${pageContext.request.contextPath}/purchase-orders" class="action-btn">
                                    <i class="bi bi-receipt"></i>
                                    <strong>View Purchase Orders</strong>
                                    <small>Check all PO records</small>
                                </a>
                                <a href="#" class="action-btn">
                                    <i class="bi bi-box-seam"></i>
                                    <strong>Inventory Audit</strong>
                                    <small>Verify stock levels</small>
                                </a>
                                <a href="#" class="action-btn">
                                    <i class="bi bi-file-earmark-text"></i>
                                    <strong>Generate Report</strong>
                                    <small>Create audit reports</small>
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Activity -->
                    <div class="dashboard-card">
                        <div class="card-header">
                            <h5><i class="bi bi-clock-history"></i> Recent Activity</h5>
                        </div>
                        <div class="card-body">
                            <ul class="activity-list">
                                <li class="activity-item">
                                    <div class="activity-content">
                                        <div class="activity-icon" style="color: #3b82f6;">
                                            <i class="bi bi-receipt"></i>
                                        </div>
                                        <div class="activity-text">
                                            <strong>PO #1234</strong> - Reviewed by Admin
                                        </div>
                                    </div>
                                    <div class="activity-time">2 hours ago</div>
                                </li>
                                <li class="activity-item">
                                    <div class="activity-content">
                                        <div class="activity-icon" style="color: #10b981;">
                                            <i class="bi bi-box-seam"></i>
                                        </div>
                                        <div class="activity-text">
                                            <strong>Inventory</strong> - Stock updated
                                        </div>
                                    </div>
                                    <div class="activity-time">5 hours ago</div>
                                </li>
                                <li class="activity-item">
                                    <div class="activity-content">
                                        <div class="activity-icon" style="color: #3b82f6;">
                                            <i class="bi bi-file-earmark-text"></i>
                                        </div>
                                        <div class="activity-text">
                                            <strong>Report</strong> - Monthly audit completed
                                        </div>
                                    </div>
                                    <div class="activity-time">1 day ago</div>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
    </body>
    <%@ include file="footer.jsp" %>
</html>
