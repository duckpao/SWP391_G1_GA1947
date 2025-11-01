<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Security Alerts</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
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
        .card { background: white; border-radius: 15px; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08); margin-bottom: 30px; overflow: hidden; }
        .card-header { background: #fef3c7; padding: 24px; border-bottom: 1px solid #e5e7eb; }
        .card-header h5 { font-size: 18px; font-weight: 700; color: #1f2937; margin: 0; display: flex; align-items: center; gap: 10px; }
        .card-body { padding: 24px; }
        .form-control { width: 100%; padding: 10px 14px; border: 1px solid #e5e7eb; border-radius: 8px; font-size: 14px; }
        .alert-item { background: #fef3c7; border-left: 4px solid #f59e0b; padding: 20px; margin-bottom: 16px; border-radius: 8px; display: flex; align-items: center; gap: 20px; }
        .alert-icon { font-size: 48px; color: #f59e0b; }
        .alert-content { flex: 1; }
        .alert-content strong { font-size: 16px; color: #1f2937; }
        .btn-investigate { background: #3b82f6; color: white; padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; border: none; cursor: pointer; }
        .empty-state { text-align: center; padding: 60px 20px; }
        .empty-state i { font-size: 64px; color: #10b981; margin-bottom: 20px; }
        .empty-state h4 { font-size: 20px; font-weight: 600; color: #1f2937; margin-bottom: 10px; }
        .empty-state p { color: #9ca3af; }
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
                <a class="nav-link" href="${pageContext.request.contextPath}/auditlog?action=statistics">
                    <i class="bi bi-graph-up"></i> Statistics
                </a>
                <a class="nav-link active" href="${pageContext.request.contextPath}/auditlog?action=alerts">
                    <i class="bi bi-exclamation-triangle"></i> Security Alerts
                </a>
            </nav>
        </div>

        <div class="main-content">
            <div class="page-header">
                <h2><i class="bi bi-exclamation-triangle" style="color: #f59e0b;"></i> Security Alerts</h2>
                <a href="auditlog?action=view" class="btn btn-secondary">
                    <i class="bi bi-arrow-left"></i> Back to Logs
                </a>
            </div>
            
            <!-- Time Range Selector -->
            <div class="card">
                <div class="card-body">
                    <form action="auditlog" method="get" style="display: grid; grid-template-columns: 1fr 200px; gap: 16px; align-items: end;">
                        <input type="hidden" name="action" value="alerts">
                        <div style="margin: 0;">
                            <label style="display: block; font-size: 13px; font-weight: 600; color: #6b7280; margin-bottom: 6px;">
                                Detection Period (hours)
                            </label>
                            <select class="form-control" name="hours" onchange="this.form.submit()">
                                <option value="1" ${hours == 1 ? 'selected' : ''}>Last 1 hour</option>
                                <option value="6" ${hours == 6 ? 'selected' : ''}>Last 6 hours</option>
                                <option value="24" ${hours == 24 ? 'selected' : ''}>Last 24 hours</option>
                                <option value="72" ${hours == 72 ? 'selected' : ''}>Last 3 days</option>
                                <option value="168" ${hours == 168 ? 'selected' : ''}>Last 7 days</option>
                            </select>
                        </div>
                        <button type="submit" class="btn" style="background: #3b82f6; color: white;">
                            <i class="bi bi-arrow-clockwise"></i> Refresh
                        </button>
                    </form>
                </div>
            </div>
            
            <!-- Alerts List -->
            <div class="card">
                <div class="card-header">
                    <h5>
                        <i class="bi bi-shield-exclamation"></i>
                        Detected Suspicious Activities (${alerts.size()} alerts)
                    </h5>
                </div>
                <div class="card-body">
                    <c:forEach items="${alerts}" var="alert">
                        <div class="alert-item">
                            <div class="alert-icon">
                                <i class="bi bi-exclamation-circle"></i>
                            </div>
                            <div class="alert-content">
                                <strong>${alert}</strong>
                            </div>
                            <button class="btn-investigate" onclick="investigateAlert('${alert}')">
                                <i class="bi bi-search"></i> Investigate
                            </button>
                        </div>
                    </c:forEach>
                    
                    <c:if test="${empty alerts}">
                        <div class="empty-state">
                            <i class="bi bi-shield-check"></i>
                            <h4>No suspicious activities detected</h4>
                            <p>The system appears to be operating normally</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        function investigateAlert(alert) {
            const match = alert.match(/User: (\w+)/);
            if (match) {
                const username = match[1];
                window.location.href = 'auditlog?action=view&username=' + username;
            }
        }
    </script>
    
    <%@ include file="/admin/footer.jsp" %>
</body>
</html>