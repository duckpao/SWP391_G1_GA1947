<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Stock Alerts - Hospital System</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            /* [Copy all CSS from your original stock-alerts.jsp] */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            body {
                font-family: 'Inter', sans-serif;
                background: #f9fafb;
                min-height: 100vh;
                padding: 20px;
            }
            .container {
                max-width: 1200px;
                margin: 0 auto;
            }
            .page-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 40px;
                flex-wrap: wrap;
                gap: 20px;
                padding-bottom: 24px;
                border-bottom: 3px solid #e5e7eb;
            }
            .page-header h2 {
    color: #1f2937;
    font-size: 28px;
    font-weight: 700;
    display: flex;
    align-items: center;
    gap: 12px;
}

.page-header i {
    color: #3b82f6; /* Thay từ #dc3545 sang xanh */
}
            .header-actions {
                display: flex;
                gap: 12px;
                flex-wrap: wrap;
            }
            .btn {
                padding: 10px 20px;
                border: none;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                font-size: 14px;
            }
            .btn-success {
                background-color: #10b981;
                color: white;
            }
            .btn-success:hover {
                background-color: #059669;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
            }
            .btn-secondary {
                background-color: #6b7280;
                color: white;
            }
            .btn-secondary:hover {
                background-color: #4b5563;
                transform: translateY(-2px);
            }
            .btn-primary {
                background-color: #3b82f6;
                color: white;
            }
            .btn-primary:hover {
                background-color: #2563eb;
                transform: translateY(-2px);
            }
            .btn-sm {
                padding: 6px 12px;
                font-size: 12px;
            }
            .btn-lg {
                padding: 12px 24px;
                font-size: 16px;
            }
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 24px;
                margin-bottom: 0;
            }
            .stat-card {
                background: white;
                border-radius: 12px;
                padding: 24px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
                border-left: 5px solid;
                display: flex;
                justify-content: space-between;
                align-items: center;
                transition: all 0.3s ease;
            }
            .stat-card:hover {
                transform: translateY(-6px);
                box-shadow: 0 12px 24px rgba(0, 0, 0, 0.15);
            }
            .stat-card.stat-critical {
                border-left-color: #dc3545;
            }
            .stat-card.stat-high {
                border-left-color: #fd7e14;
            }
            .stat-card.stat-medium {
                border-left-color: #ffc107;
            }
            .stat-content h6 {
                color: #9ca3af;
                font-size: 12px;
                font-weight: 600;
                margin-bottom: 8px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            .stat-content h2 {
                font-size: 32px;
                font-weight: 700;
                color: #1f2937;
            }
            .stat-icon {
                font-size: 40px;
                opacity: 0.8;
            }
            .stat-card.stat-critical .stat-icon {
                color: #dc3545;
            }
            .stat-card.stat-high .stat-icon {
                color: #fd7e14;
            }
            .stat-card.stat-medium .stat-icon {
                color: #ffc107;
            }
            .alert-info-box {
    background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
    border-left: 5px solid #3b82f6; /* Thay từ #0dcaf0 sang #3b82f6 */
    border-radius: 12px;
    padding: 20px;
    margin: 0;
    box-shadow: 0 2px 8px rgba(59, 130, 246, 0.1); /* Thay shadow */
}
            .alert-info-box strong {
                color: #1f2937;
            }
            .alert-info-box small {
                color: #6b7280;
                display: block;
                margin-top: 8px;
            }
            .card {
                background: white;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
                overflow: hidden;
                margin-bottom: 0;
                border: 1px solid #e5e7eb;
            }
            .card-header {
    background: #f9fafb; /* Đổi từ gradient sang solid */
    color: #1f2937;
    padding: 20px;
    border-bottom: 2px solid #e5e7eb;
}
            .card-header h5 {
                font-size: 18px;
                font-weight: 700;
                display: flex;
                align-items: center;
                gap: 12px;
                margin: 0;
                color: #1f2937;
            }
            .badge {
    background-color: #3b82f6; /* Thay từ #dc3545 sang xanh */
    color: white;
    padding: 4px 8px;
    border-radius: 4px;
    font-size: 12px;
    font-weight: 600;
}
            .card-body {
                padding: 20px;
            }
            .alert-success {
                background-color: #d1fae5;
                border-left: 4px solid #10b981;
                color: #065f46;
                padding: 16px;
                border-radius: 8px;
                display: flex;
                align-items: center;
                gap: 12px;
            }
            .alert-success i {
                color: #10b981;
                font-size: 20px;
            }
            .table-responsive {
                overflow-x: auto;
            }
            table {
                width: 100%;
                border-collapse: collapse;
            }
            thead {
                background-color: #f3f4f6;
            }
            thead th {
                padding: 12px;
                text-align: left;
                font-weight: 600;
                color: #374151;
                font-size: 13px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                border-bottom: 2px solid #e5e7eb;
            }
            tbody td {
                padding: 12px;
                border-bottom: 1px solid #e5e7eb;
                color: #374151;
            }
            tbody tr:hover {
                background-color: #f9fafb;
            }
            tbody tr.critical-row {
                background-color: #fee2e2;
            }
            tbody tr.highlight-row {
                background-color: #fef3c7;
            }
            .quantity-critical {
                color: #dc3545;
                font-weight: 700;
            }
            .quantity-low {
                color: #fd7e14;
                font-weight: 700;
            }
            .quantity-warning {
                color: #856404;
                font-weight: 700;
            }
            .alert-badge {
                padding: 6px 12px;
                border-radius: 6px;
                font-weight: 600;
                font-size: 12px;
                display: inline-block;
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
            .badge-secondary {
                background-color: #6b7280;
                color: white;
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 12px;
                font-weight: 600;
            }
            .quick-actions {
                display: flex;
                gap: 12px;
                justify-content: center;
                margin-top: 24px;
                flex-wrap: wrap;
            }
            .recommendations-list {
                list-style: none;
                padding: 0;
            }
            .recommendations-list li {
                padding: 12px 0;
                border-bottom: 1px solid #e5e7eb;
                display: flex;
                gap: 12px;
            }
            .recommendations-list li:last-child {
                border-bottom: none;
            }
            .recommendations-list li strong {
                color: #1f2937;
            }
            .text-danger {
                color: #dc3545;
            }
            .text-warning {
                color: #fd7e14;
            }
            .text-success {
                color: #10b981;
            }
            .text-muted {
                color: #9ca3af;
            }
            .section {
    background: white;
    border-radius: 12px;
    padding: 24px;
    margin-bottom: 32px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    border-top: 4px solid #3b82f6; /* Giữ nguyên màu xanh mặc định */
    transition: all 0.3s ease;
}
            .section:hover {
                box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
            }
            .section-title {
                font-size: 18px;
                font-weight: 700;
                color: #1f2937;
                margin-bottom: 24px;
                display: flex;
                align-items: center;
                gap: 12px;
                padding-bottom: 16px;
                border-bottom: 2px solid #e5e7eb;
            }
            .section-title i {
                color: #3b82f6;
                font-size: 20px;
            }
            .section.stats-section {
                border-top-color: #10b981;
                background: linear-gradient(135deg, #ffffff 0%, #f0fdf4 100%);
            }
            .section.stats-section .section-title i {
                color: #10b981;
            }
            .section.alerts-section {
                border-top-color: #dc3545;
                background: linear-gradient(135deg, #ffffff 0%, #fef2f2 100%);
            }
            .section.alerts-section .section-title i {
                color: #dc3545;
            }
            .section.recommendations-section {
                border-top-color: #ffc107;
                background: linear-gradient(135deg, #ffffff 0%, #fffbeb 100%);
            }
            .section.recommendations-section .section-title i {
                color: #ffc107;
            }
            @media (max-width: 768px) {
                .page-header {
                    flex-direction: column;
                    align-items: flex-start;
                }
                .page-header h2 {
                    font-size: 22px;
                }
                .header-actions {
                    width: 100%;
                }
                .btn {
                    flex: 1;
                    justify-content: center;
                }
                .stats-grid {
                    grid-template-columns: 1fr;
                }
                .stat-card {
                    flex-direction: column;
                    text-align: center;
                }
                .stat-icon {
                    margin-top: 12px;
                }
                table {
                    font-size: 12px;
                }
                thead th, tbody td {
                    padding: 8px;
                }
                .quick-actions {
                    flex-direction: column;
                }
                .btn-lg {
                    width: 100%;
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <!-- Header -->
            <div class="page-header">
                <h2>
                    <i class="fas fa-exclamation-triangle"></i> 
                    Stock Alerts & Inventory Status
                </h2>
                <div class="header-actions">
                    <a href="${pageContext.request.contextPath}/create-stock" class="btn btn-success">
                        <i class="fas fa-plus-circle"></i> Create Stock Request
                    </a>
                    <a href="${pageContext.request.contextPath}/manager-dashboard" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </a>
                </div>
            </div>

            <!-- Statistics -->
            <div class="section stats-section">
                <div class="section-title">
                    <i class="fas fa-chart-bar"></i> Inventory Overview
                </div>
                <div class="stats-grid">
                    <div class="stat-card stat-critical">
                        <div class="stat-content">
                            <h6>Critical (Out of Stock)</h6>
                            <h2>
                                <c:set var="criticalCount" value="0"/>
                                <c:forEach items="${alerts}" var="alert">
                                    <c:if test="${alert.alertLevel == 'Critical'}">
                                        <c:set var="criticalCount" value="${criticalCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${criticalCount}
                            </h2>
                        </div>
                        <i class="fas fa-times-circle stat-icon"></i>
                    </div>
                    <div class="stat-card stat-high">
                        <div class="stat-content">
                            <h6>High Alert</h6>
                            <h2>
                                <c:set var="highCount" value="0"/>
                                <c:forEach items="${alerts}" var="alert">
                                    <c:if test="${alert.alertLevel == 'High'}">
                                        <c:set var="highCount" value="${highCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${highCount}
                            </h2>
                        </div>
                        <i class="fas fa-exclamation-circle stat-icon"></i>
                    </div>
                    <div class="stat-card stat-medium">
                        <div class="stat-content">
                            <h6>Medium Alert</h6>
                            <h2>
                                <c:set var="mediumCount" value="0"/>
                                <c:forEach items="${alerts}" var="alert">
                                    <c:if test="${alert.alertLevel == 'Medium'}">
                                        <c:set var="mediumCount" value="${mediumCount + 1}"/>
                                    </c:if>
                                </c:forEach>
                                ${mediumCount}
                            </h2>
                        </div>
                        <i class="fas fa-info-circle stat-icon"></i>
                    </div>
                </div>
            </div>

            <!-- Alert Info -->
            <div class="section alerts-section">
                <div class="section-title">
                    <i class="fas fa-info-circle"></i> Alert Threshold Information
                </div>
                <div class="alert-info-box" style="margin: 0; box-shadow: none; background: #f0f9ff; border-left-color: #0dcaf0;">
                    <i class="fas fa-info-circle"></i>
                    <strong>Alert Threshold:</strong> Medicines with quantity ≤ <strong>${threshold}</strong> units
                    <br>
                    <small>
                        <i class="fas fa-circle text-danger"></i> <strong>Critical:</strong> Out of stock (0 units) | 
                        <i class="fas fa-circle text-warning"></i> <strong>High:</strong> Below ${threshold / 2} units | 
                        <i class="fas fa-circle" style="color: #ffc107;"></i> <strong>Medium:</strong> Below ${threshold} units
                    </small>
                </div>
            </div>

            <!-- Stock Alerts Table -->
            <div class="section">
                <div class="section-title">
                    <i class="fas fa-list"></i> Low Stock Medicines 
                    <span class="badge">${alerts.size()}</span>
                </div>
                <div class="card">
                    <div class="card-header">
                        <h5>
                            <i class="fas fa-list"></i> Low Stock Medicines 
                            <span class="badge">${alerts.size()}</span>
                        </h5>
                    </div>
                    <div class="card-body">
                        <c:if test="${empty alerts}">
                            <div class="alert-success">
                                <i class="fas fa-check-circle"></i> 
                                <div>
                                    <strong>All Good!</strong> No stock alerts at this time. All medicines are above the threshold.
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${not empty alerts}">
                            <div class="table-responsive">
                                <table>
                                    <thead>
                                        <tr>
                                            <th>Medicine Code</th>
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
                                                <td><strong>${alert.medicineCode}</strong></td>
                                                <td>
                                                    <strong>${alert.medicineName}</strong>
                                                    <c:if test="${alert.currentQuantity == 0}">
                                                        <br><small class="text-danger">⚠️ OUT OF STOCK</small>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <span class="badge-secondary">${alert.category}</span>
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
                                                            <a href="${pageContext.request.contextPath}/create-stock?medicineCode=${alert.medicineCode}" 
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
                                    <div class="quick-actions">
                                        <a href="${pageContext.request.contextPath}/create-stock" class="btn btn-success btn-lg">
                                            <i class="fas fa-shopping-cart"></i> Create Bulk Stock Request
                                        </a>
                                        <a href="${pageContext.request.contextPath}/manager-dashboard" class="btn btn-primary btn-lg">
                                            <i class="fas fa-boxes"></i> View All Purchase Orders
                                        </a>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <!-- Recommendations -->
                    <div class="section recommendations-section">
                        <div class="section-title">
                            <i class="fas fa-lightbulb"></i> Recommendations & Actions
                        </div>
                        <div class="card">
                            <div class="card-header">
                                <h5><i class="fas fa-lightbulb"></i> Recommendations</h5>
                            </div>
                            <div class="card-body">
                                <ul class="recommendations-list">
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
                </div>
            </body>
        </html>