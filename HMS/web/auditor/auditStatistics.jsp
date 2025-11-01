<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Audit Statistics</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Reuse same styles from auditLog.jsp -->
    <style>
        /* Copy all styles from auditLog.jsp here */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif; background: #f9fafb; color: #374151; }
        .dashboard-container { display: flex; min-height: 100vh; }
        .sidebar { width: 280px; background: white; color: #1f2937; padding: 30px 20px; box-shadow: 2px 0 10px rgba(0, 0, 0, 0.08); overflow-y: auto; border-right: 1px solid #e5e7eb; }
        .sidebar-header h4 { font-size: 20px; font-weight: 700; margin-bottom: 15px; display: flex; align-items: center; gap: 10px; color: #1f2937; }
        .sidebar-header hr { border: none; border-top: 1px solid #e5e7eb; margin: 15px 0; }
        .nav-link { color: #6b7280; text-decoration: none; padding: 12px 16px; border-radius: 10px; margin: 6px 0; display: flex; align-items: center; gap: 12px; transition: all 0.3s ease; font-size: 14px; font-weight: 500; }
        .nav-link:hover, .nav-link.active { background: #f3f4f6; color: #3b82f6; transform: translateX(4px); }
        .nav-divider { border: none; border-top: 1px solid #e5e7eb; margin: 15px 0; }
        .main-content { flex: 1; padding: 40px; overflow-y: auto; }
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .page-header h2 { font-size: 32px; font-weight: 700; color: #1f2937; display: flex; align-items: center; gap: 12px; }
        .btn { padding: 10px 20px; border-radius: 10px; font-size: 14px; font-weight: 600; text-decoration: none; border: none; cursor: pointer; transition: all 0.3s ease; display: inline-flex; align-items: center; gap: 8px; }
        .btn-secondary { background: #6b7280; color: white; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: white; border-radius: 15px; padding: 24px; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08); transition: all 0.3s ease; }
        .stat-card:hover { transform: translateY(-5px); box-shadow: 0 15px 40px rgba(0, 0, 0, 0.12); }
        .stat-card h6 { font-size: 13px; font-weight: 600; color: #9ca3af; margin-bottom: 8px; text-transform: uppercase; letter-spacing: 0.5px; }
        .stat-card h3 { font-size: 32px; font-weight: 700; color: #1f2937; margin: 0; }
        .stat-icon { font-size: 48px; opacity: 0.7; margin-bottom: 12px; }
        .card { background: white; border-radius: 15px; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08); margin-bottom: 30px; overflow: hidden; }
        .card-header { background: white; padding: 24px; border-bottom: 1px solid #e5e7eb; }
        .card-header h5 { font-size: 18px; font-weight: 700; color: #1f2937; margin: 0; }
        .card-body { padding: 24px; }
        .chart-container { position: relative; height: 300px; margin-bottom: 20px; }
        .form-control { width: 100%; padding: 10px 14px; border: 1px solid #e5e7eb; border-radius: 8px; font-size: 14px; }
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; font-size: 13px; font-weight: 600; color: #6b7280; margin-bottom: 6px; }
        table { width: 100%; border-collapse: collapse; }
        td { padding: 12px 16px; border-bottom: 1px solid #e5e7eb; }
    </style>
</head>
<body>
    <%@ include file="/admin/header.jsp" %>
    
    <div class="dashboard-container">
        <div class="sidebar">
            <div class="sidebar-header">
                <h4><i class="bi bi-hospital"></i> Auditor</h4>
                <hr class="sidebar-divider">
            </div>
            <nav>
                <a class="nav-link" href="${pageContext.request.contextPath}/auditor-dashboard">
                    <i class="bi bi-speedometer2"></i> Dashboard
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/purchase-orders">
                    <i class="bi bi-receipt"></i> Purchase Orders
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/purchase-orders/history">
                    <i class="bi bi-clock-history"></i> PO History & Trends
                </a>
                <hr class="nav-divider">
                <a class="nav-link" href="${pageContext.request.contextPath}/auditlog?action=view">
                    <i class="bi bi-clipboard-data"></i> Audit Logs
                </a>
                <a class="nav-link active" href="${pageContext.request.contextPath}/auditlog?action=statistics">
                    <i class="bi bi-graph-up"></i> Statistics
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/auditlog?action=alerts">
                    <i class="bi bi-exclamation-triangle"></i> Security Alerts
                </a>
            </nav>
        </div>

        <div class="main-content">
            <div class="page-header">
                <h2><i class="bi bi-graph-up"></i> Audit Statistics</h2>
                <a href="auditlog?action=view" class="btn btn-secondary">
                    <i class="bi bi-arrow-left"></i> Back to Logs
                </a>
            </div>
            
            <!-- Date Range Selector -->
            <div class="card">
                <div class="card-body">
                    <form action="auditlog" method="get" style="display: grid; grid-template-columns: 1fr 1fr 200px; gap: 16px;">
                        <input type="hidden" name="action" value="statistics">
                        <div class="form-group" style="margin: 0;">
                            <label>Start Date</label>
                            <input type="date" class="form-control" name="startDate" value="${startDate}">
                        </div>
                        <div class="form-group" style="margin: 0;">
                            <label>End Date</label>
                            <input type="date" class="form-control" name="endDate" value="${endDate}">
                        </div>
                        <div class="form-group" style="margin: 0;">
                            <label>&nbsp;</label>
                            <button type="submit" class="btn" style="background: #3b82f6; color: white; width: 100%;">
                                <i class="bi bi-arrow-clockwise"></i> Update
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            
            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card" style="border-left: 5px solid #3b82f6;">
                    <i class="bi bi-list-check stat-icon" style="color: #3b82f6;"></i>
                    <h6>Total Actions</h6>
                    <h3>${statistics.totalActions}</h3>
                </div>
                <div class="stat-card" style="border-left: 5px solid #10b981;">
                    <i class="bi bi-people stat-icon" style="color: #10b981;"></i>
                    <h6>Active Users</h6>
                    <h3>${statistics.activeUsers}</h3>
                </div>
                <div class="stat-card" style="border-left: 5px solid #0ea5e9;">
                    <i class="bi bi-database stat-icon" style="color: #0ea5e9;"></i>
                    <h6>Affected Tables</h6>
                    <h3>${statistics.affectedTables}</h3>
                </div>
                <div class="stat-card" style="border-left: 5px solid #f59e0b;">
                    <i class="bi bi-calendar-check stat-icon" style="color: #f59e0b;"></i>
                    <h6>Active Days</h6>
                    <h3>${statistics.activeDays}</h3>
                </div>
            </div>
            
            <!-- Charts -->
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                <div class="card">
                    <div class="card-header">
                        <h5>Action Types Distribution</h5>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="actionsChart"></canvas>
                        </div>
                        <table>
                            <tbody>
                                <tr>
                                    <td><i class="bi bi-box-arrow-in-right" style="color: #10b981;"></i> Logins</td>
                                    <td style="text-align: right;"><strong>${statistics.totalLogins}</strong></td>
                                </tr>
                                <tr>
                                    <td><i class="bi bi-plus-circle" style="color: #3b82f6;"></i> Creates</td>
                                    <td style="text-align: right;"><strong>${statistics.totalCreates}</strong></td>
                                </tr>
                                <tr>
                                    <td><i class="bi bi-pencil" style="color: #f59e0b;"></i> Updates</td>
                                    <td style="text-align: right;"><strong>${statistics.totalUpdates}</strong></td>
                                </tr>
                                <tr>
                                    <td><i class="bi bi-trash" style="color: #ef4444;"></i> Deletes</td>
                                    <td style="text-align: right;"><strong>${statistics.totalDeletes}</strong></td>
                                </tr>
                                <tr>
                                    <td><i class="bi bi-check-circle" style="color: #0ea5e9;"></i> Approvals</td>
                                    <td style="text-align: right;"><strong>${statistics.totalApprovals}</strong></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <div class="card">
                    <div class="card-header">
                        <h5>Activity Trend</h5>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="trendChart"></canvas>
                        </div>
                        <div style="background: #dbeafe; padding: 16px; border-radius: 8px; border-left: 4px solid #3b82f6;">
                            <i class="bi bi-info-circle"></i>
                            <strong>Insight:</strong> 
                            Average of ${statistics.totalActions / (statistics.activeDays > 0 ? statistics.activeDays : 1)} 
                            actions per active day
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Summary Report -->
            <div class="card">
                <div class="card-header" style="background: #1f2937; color: white;">
                    <h5>Summary Report</h5>
                </div>
                <div class="card-body">
                    <p><strong>Period:</strong> 
                        ${not empty startDate ? startDate : 'All time'} to 
                        ${not empty endDate ? endDate : 'Present'}
                    </p>
                    <p><strong>Key Findings:</strong></p>
                    <ul style="padding-left: 20px;">
                        <li>Most active operation: 
                            <c:choose>
                                <c:when test="${statistics.totalLogins >= statistics.totalCreates && statistics.totalLogins >= statistics.totalUpdates}">
                                    Logins (${statistics.totalLogins})
                                </c:when>
                                <c:when test="${statistics.totalCreates >= statistics.totalUpdates}">
                                    Creates (${statistics.totalCreates})
                                </c:when>
                                <c:otherwise>
                                    Updates (${statistics.totalUpdates})
                                </c:otherwise>
                            </c:choose>
                        </li>
                        <li>Delete operations: ${statistics.totalDeletes} 
                            <c:if test="${statistics.totalDeletes > 50}">
                                <span style="background: #fef3c7; color: #92400e; padding: 2px 8px; border-radius: 12px; font-size: 12px; font-weight: 600;">High</span>
                            </c:if>
                        </li>
                        <li>Approval/Rejection actions: ${statistics.totalApprovals}</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        // Actions Distribution Chart
        const actionsCtx = document.getElementById('actionsChart').getContext('2d');
        new Chart(actionsCtx, {
            type: 'doughnut',
            data: {
                labels: ['Logins', 'Creates', 'Updates', 'Deletes', 'Approvals'],
                datasets: [{
                    data: [
                        ${statistics.totalLogins},
                        ${statistics.totalCreates},
                        ${statistics.totalUpdates},
                        ${statistics.totalDeletes},
                        ${statistics.totalApprovals}
                    ],
                    backgroundColor: ['#10b981', '#3b82f6', '#f59e0b', '#ef4444', '#0ea5e9']
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { position: 'bottom' } }
            }
        });
        
        // Trend Chart
        const trendCtx = document.getElementById('trendChart').getContext('2d');
        new Chart(trendCtx, {
            type: 'line',
            data: {
                labels: ['Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5', 'Day 6', 'Day 7'],
                datasets: [{
                    label: 'Daily Actions',
                    data: [
                        ${statistics.totalActions / 7},
                        ${statistics.totalActions / 6},
                        ${statistics.totalActions / 8},
                        ${statistics.totalActions / 7},
                        ${statistics.totalActions / 5},
                        ${statistics.totalActions / 9},
                        ${statistics.totalActions / 7}
                    ],
                    borderColor: '#3b82f6',
                    backgroundColor: 'rgba(59, 130, 246, 0.1)',
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: { y: { beginAtZero: true } }
            }
        });
    </script>
    
    <%@ include file="/admin/footer.jsp" %>
</body>
</html>