<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stock Alerts - Hospital System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .dashboard-card {
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .alert-badge {
            padding: 5px 12px;
            border-radius: 5px;
            font-weight: 600;
            font-size: 0.85rem;
        }
        .alert-critical {
            background-color: #dc3545;
            color: white;
        }
        .alert-high {
            background-color: #fd7e14;
            color: white;
        }
        .alert-medium {
            background-color: #ffc107;
            color: #000;
        }
        .quantity-critical {
            color: #dc3545;
            font-weight: bold;
            font-size: 1.1rem;
        }
        .quantity-low {
            color: #fd7e14;
            font-weight: bold;
        }
        .quantity-warning {
            color: #856404;
            font-weight: bold;
        }
        .stat-card {
            border-left: 4px solid;
            padding: 15px;
            margin-bottom: 15px;
            background: white;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .stat-critical { border-left-color: #dc3545; }
        .stat-high { border-left-color: #fd7e14; }
        .stat-medium { border-left-color: #ffc107; }
        .highlight-row {
            background-color: #fff3cd !important;
        }
        .critical-row {
            background-color: #f8d7da !important;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>
                <i class="fas fa-exclamation-triangle text-warning"></i> 
                Stock Alerts & Inventory Status
            </h2>
            <div>
                <a href="${pageContext.request.contextPath}/create-stock" class="btn btn-success btn-lg me-2">
                    <i class="fas fa-plus-circle"></i> Create Stock Request
                </a>
                <a href="${pageContext.request.contextPath}/manager-dashboard" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
            </div>
        </div>

        <!-- Alert Statistics -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="stat-card stat-critical">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-muted mb-1">Critical (Out of Stock)</h6>
                            <h2 class="mb-0">
                                <c:set var="criticalCount" value="0"/>
                                <c:forEach items="${alerts}" var="alert">
                                    <c:if test="${alert.alertLevel == 'Critical'}">
                                        <c:set var="criticalCount" value="${criticalCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${criticalCount}
                            </h2>
                        </div>
                        <i class="fas fa-times-circle fa-3x text-danger"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card stat-high">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-muted mb-1">High Alert</h6>
                            <h2 class="mb-0">
                                <c:set var="highCount" value="0"/>
                                <c:forEach items="${alerts}" var="alert">
                                    <c:if test="${alert.alertLevel == 'High'}">
                                        <c:set var="highCount" value="${highCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${highCount}
                            </h2>
                        </div>
                        <i class="fas fa-exclamation-circle fa-3x text-warning"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="stat-card stat-medium">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-muted mb-1">Medium Alert</h6>
                            <h2 class="mb-0">
                                <c:set var="mediumCount" value="0"/>
                                <c:forEach items="${alerts}" var="alert">
                                    <c:if test="${alert.alertLevel == 'Medium'}">
                                        <c:set var="mediumCount" value="${mediumCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${mediumCount}
                            </h2>
                        </div>
                        <i class="fas fa-info-circle fa-3x" style="color: #ffc107;"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Alert Threshold Info -->
        <div class="alert alert-info">
            <i class="fas fa-info-circle"></i>
            <strong>Alert Threshold:</strong> Medicines with quantity ≤ <strong>${threshold}</strong> units
            <br>
            <small>
                <i class="fas fa-circle text-danger"></i> <strong>Critical:</strong> Out of stock (0 units) | 
                <i class="fas fa-circle text-warning"></i> <strong>High:</strong> Below ${threshold / 2} units | 
                <i class="fas fa-circle" style="color: #ffc107;"></i> <strong>Medium:</strong> Below ${threshold} units
            </small>
        </div>

        <!-- Stock Alerts Table -->
        <div class="card dashboard-card">
            <div class="card-header bg-warning">
                <h5 class="mb-0">
                    <i class="fas fa-list"></i> Low Stock Medicines 
                    <span class="badge bg-danger">${alerts.size()}</span>
                </h5>
            </div>
            <div class="card-body">
                <c:if test="${empty alerts}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i> 
                        <strong>All Good!</strong> No stock alerts at this time. All medicines are above the threshold.
                    </div>
                </c:if>

                <c:if test="${not empty alerts}">
                    <div class="table-responsive">
                        <table class="table table-hover table-striped">
                            <thead class="table-dark">
                                <tr>
                                    <th>Medicine ID</th>
                                    <th>Medicine Name</th>
                                    <th>Category</th>
                                    <th>Current Quantity</th>
                                    <th>Threshold</th>
                                    <th>Alert Level</th>
                                    <th>Nearest Expiry</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${alerts}" var="alert">
                                    <tr class="${alert.alertLevel == 'Critical' ? 'critical-row' : 
                                                 alert.alertLevel == 'High' ? 'highlight-row' : ''}">
                                        <td><strong>#${alert.medicineId}</strong></td>
                                        <td>
                                            <strong>${alert.medicineName}</strong>
                                            <c:if test="${alert.currentQuantity == 0}">
                                                <br><small class="text-danger">⚠️ OUT OF STOCK</small>
                                            </c:if>
                                        </td>
                                        <td>
                                            <span class="badge bg-secondary">${alert.category}</span>
                                        </td>
                                        <td>
                                            <span class="${alert.currentQuantity == 0 ? 'quantity-critical' : 
                                                          alert.currentQuantity < threshold / 2 ? 'quantity-low' : 'quantity-warning'}">
                                                ${alert.currentQuantity} units
                                            </span>
                                        </td>
                                        <td>${alert.threshold} units</td>
                                        <td>
                                            <span class="alert-badge ${
                                                alert.alertLevel == 'Critical' ? 'alert-critical' : 
                                                alert.alertLevel == 'High' ? 'alert-high' : 'alert-medium'}">
                                                ${alert.alertLevel}
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty alert.nearestExpiry}">
                                                    <i class="fas fa-calendar-alt"></i> ${alert.nearestExpiry}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">No batches</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/create-stock?medicineId=${alert.medicineId}" 
                                               class="btn btn-success btn-sm">
                                                <i class="fas fa-plus"></i> Order Now
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <!-- Quick Actions -->
                    <div class="mt-4 text-center">
                        <a href="${pageContext.request.contextPath}/create-stock" class="btn btn-success btn-lg">
                            <i class="fas fa-shopping-cart"></i> Create Bulk Stock Request
                        </a>
                        <a href="${pageContext.request.contextPath}/manage-stock" class="btn btn-primary btn-lg">
                            <i class="fas fa-boxes"></i> View All Purchase Orders
                        </a>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Additional Info -->
        <div class="card dashboard-card">
            <div class="card-header bg-info text-white">
                <h5 class="mb-0"><i class="fas fa-lightbulb"></i> Recommendations</h5>
            </div>
            <div class="card-body">
                <ul>
                    <c:if test="${criticalCount > 0}">
                        <li class="text-danger">
                            <strong>Urgent:</strong> ${criticalCount} medicine(s) are completely out of stock. 
                            Create purchase orders immediately to prevent service disruption.
                        </li>
                    </c:if>
                    <c:if test="${highCount > 0}">
                        <li class="text-warning">
                            <strong>High Priority:</strong> ${highCount} medicine(s) are critically low. 
                            Consider expedited ordering.
                        </li>
                    </c:if>
                    <c:if test="${mediumCount > 0}">
                        <li style="color: #856404;">
                            <strong>Monitor:</strong> ${mediumCount} medicine(s) are below threshold. 
                            Plan restocking in the near future.
                        </li>
                    </c:if>
                    <c:if test="${empty alerts}">
                        <li class="text-success">
                            <strong>Status:</strong> All medicines are adequately stocked. 
                            Continue regular monitoring.
                        </li>
                    </c:if>
                </ul>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>