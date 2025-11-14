<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Task Detail - Hospital System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 40px 20px;
        }
        .page-header {
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
        }
        .page-header h2 {
            font-size: 32px;
            font-weight: 700;
            color: #1f2937;
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 0;
        }
        .btn-group {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }
        /* Buttons */
        .btn {
            padding: 10px 20px;
            border-radius: 8px;
            border: none;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .btn-primary {
            background: #3b82f6;
            color: white;
        }
        .btn-primary:hover {
            background: #2563eb;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }
        .btn-success {
            background: #10b981;
            color: white;
        }
        .btn-success:hover {
            background: #059669;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
        }
        .btn-warning {
            background: #f59e0b;
            color: white;
        }
        .btn-warning:hover {
            background: #d97706;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(245, 158, 11, 0.3);
        }
        .btn-secondary {
            background: #6b7280;
            color: white;
        }
        .btn-secondary:hover {
            background: #4b5563;
        }
        /* Dashboard Card */
        .dashboard-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            margin-bottom: 30px;
            overflow: hidden;
            border-top: 3px solid #3b82f6;
        }
        .card-header {
            background: #f9fafb;
            padding: 24px;
            border-bottom: 1px solid #e5e7eb;
        }
        .card-header h5 {
            font-size: 18px;
            font-weight: 700;
            color: #1f2937;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .card-body {
            padding: 24px;
        }
        /* Status Timeline */
        .status-timeline {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            position: relative;
            padding: 20px 0;
        }
        .status-timeline::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 3px;
            background: #e5e7eb;
            transform: translateY(-50%);
            z-index: 1;
        }
        .timeline-step {
            position: relative;
            z-index: 2;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
            flex: 1;
        }
        .timeline-circle {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: white;
            border: 3px solid #e5e7eb;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            transition: all 0.3s ease;
        }
        .timeline-step.active .timeline-circle {
            background: #3b82f6;
            border-color: #3b82f6;
            color: white;
            box-shadow: 0 0 0 6px rgba(59, 130, 246, 0.1);
        }
        .timeline-step.completed .timeline-circle {
            background: #10b981;
            border-color: #10b981;
            color: white;
        }
        .timeline-label {
            font-size: 13px;
            font-weight: 600;
            color: #6b7280;
            text-align: center;
        }
        .timeline-step.active .timeline-label {
            color: #3b82f6;
        }
        .timeline-step.completed .timeline-label {
            color: #10b981;
        }
        /* Details Table */
        .details-table {
            width: 100%;
            margin-bottom: 20px;
        }
        .details-table tr {
            border-bottom: 1px solid #e5e7eb;
        }
        .details-table tr:last-child {
            border-bottom: none;
        }
        .details-table td {
            padding: 12px 0;
            font-size: 14px;
        }
        .details-table td:first-child {
            font-weight: 600;
            color: #374151;
            width: 200px;
        }
        .details-table td:last-child {
            color: #6b7280;
        }
        /* Status Badge */
        .status-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-pending {
            background: #f3f4f6;
            color: #374151;
        }
        .status-in-progress {
            background: #dbeafe;
            color: #1e40af;
        }
        .status-completed {
            background: #d1fae5;
            color: #065f46;
        }
        .status-cancelled {
            background: #fee2e2;
            color: #991b1b;
        }
        /* Item List */
        .item-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .item-list li {
            padding: 20px;
            border: 1px solid #e5e7eb;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            background: white;
            margin-bottom: 16px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }
        .item-list li:hover {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            border-color: #3b82f6;
            transform: translateX(4px);
        }
        .medicine-main-info {
            font-size: 15px;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 8px;
        }
        .medicine-detail-row {
            display: flex;
            flex-wrap: wrap;
            gap: 16px;
            margin-top: 8px;
        }
        .medicine-detail-item {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            color: #6b7280;
        }
        .medicine-code-badge {
            background: #f3f4f6;
            padding: 4px 8px;
            border-radius: 4px;
            font-family: monospace;
            font-size: 12px;
            color: #374151;
        }
        .quantity-badge {
            background: #3b82f6;
            color: white;
            padding: 8px 16px;
            border-radius: 6px;
            font-weight: 600;
        }
        /* Alert */
        .alert {
            padding: 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .alert-success {
            background: #dcfce7;
            color: #166534;
            border: 1px solid #86efac;
        }
        .alert-danger {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fca5a5;
        }
        .alert-warning {
            background: #fef3c7;
            color: #92400e;
            border: 1px solid #fcd34d;
        }
        .alert-info {
            background: #dbeafe;
            color: #1e40af;
            border: 1px solid #93c5fd;
        }
        /* Modal */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            align-items: center;
            justify-content: center;
        }
        .modal.show {
            display: flex;
        }
        .modal-content {
            background: white;
            border-radius: 12px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            max-width: 500px;
            width: 90%;
        }
        .modal-header {
            padding: 24px;
            border-bottom: 1px solid #e5e7eb;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .modal-header h5 {
            font-size: 18px;
            font-weight: 700;
            color: #1f2937;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .modal-body {
            padding: 24px;
        }
        .modal-footer {
            padding: 24px;
            border-top: 1px solid #e5e7eb;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }
        .close-btn {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: #6b7280;
        }
        /* Responsive */
        @media (max-width: 768px) {
            .container {
                padding: 20px;
            }
            .page-header {
                flex-direction: column;
                align-items: flex-start;
            }
            .page-header h2 {
                font-size: 24px;
            }
            .status-timeline {
                flex-direction: column;
                gap: 20px;
            }
            .status-timeline::before {
                width: 3px;
                height: 100%;
                left: 25px;
                top: 0;
            }
            .timeline-step {
                flex-direction: row;
                width: 100%;
                justify-content: flex-start;
            }
            .details-table td:first-child {
                width: 120px;
            }
        }
    </style>
</head>
<%@ include file="/admin/header.jsp" %>
<body>
    <div class="container">
        <div class="page-header">
            <h2>
                <i class="bi bi-clipboard-check"></i>
                Task #${task.taskId} Details
            </h2>
            <div class="btn-group">
                <a href="${pageContext.request.contextPath}/staff/tasks" class="btn btn-secondary">
                    <i class="bi bi-arrow-left"></i> Back to Tasks
                </a>
                <c:if test="${task.status == 'Pending'}">
                    <button class="btn btn-primary" onclick="updateStatus('In Progress')">
                        <i class="bi bi-play-circle"></i> Start Task
                    </button>
                </c:if>
                <c:if test="${task.status == 'In Progress'}">
                    <button class="btn btn-success" onclick="updateStatus('Completed')">
                        <i class="bi bi-check-circle"></i> Mark as Completed
                    </button>
                </c:if>
            </div>
        </div>

        <!-- Messages -->
        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success">
                <i class="bi bi-check-circle"></i>
                ${sessionScope.success}
            </div>
            <c:remove var="success" scope="session"/>
        </c:if>
        
        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger">
                <i class="bi bi-exclamation-circle"></i>
                ${sessionScope.error}
            </div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <!-- Status Timeline -->
        <div class="dashboard-card">
            <div class="card-header">
                <h5><i class="bi bi-diagram-3"></i> Task Progress</h5>
            </div>
            <div class="card-body">
                <div class="status-timeline">
                    <div class="timeline-step ${task.status == 'Pending' || task.status == 'In Progress' || task.status == 'Completed' ? 'completed' : ''}">
                        <div class="timeline-circle">
                            <i class="bi bi-clock"></i>
                        </div>
                        <div class="timeline-label">Pending</div>
                    </div>
                    
                    <div class="timeline-step ${task.status == 'In Progress' ? 'active' : task.status == 'Completed' ? 'completed' : ''}">
                        <div class="timeline-circle">
                            <i class="bi bi-arrow-repeat"></i>
                        </div>
                        <div class="timeline-label">In Progress</div>
                    </div>
                    
                    <div class="timeline-step ${task.status == 'Completed' ? 'active completed' : ''}">
                        <div class="timeline-circle">
                            <i class="bi bi-check-circle"></i>
                        </div>
                        <div class="timeline-label">Completed</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Task Information -->
        <div class="dashboard-card">
            <div class="card-header">
                <h5><i class="bi bi-info-circle"></i> Task Information</h5>
            </div>
            <div class="card-body">
                <table class="details-table">
                    <tr>
                        <td>Task ID:</td>
                        <td><strong>#${task.taskId}</strong></td>
                    </tr>
                    <tr>
                        <td>Task Type:</td>
                        <td>
                            <c:choose>
                                <c:when test="${task.taskType == 'stock_in'}">📦 Stock In Verification</c:when>
                                <c:when test="${task.taskType == 'stock_out'}">📤 Stock Out Verification</c:when>
                                <c:when test="${task.taskType == 'counting'}">🔢 Inventory Counting</c:when>
                                <c:when test="${task.taskType == 'quality_check'}">✅ Quality Check</c:when>
                                <c:when test="${task.taskType == 'expiry_audit'}">⏰ Expiry Date Audit</c:when>
                                <c:otherwise>${task.taskType}</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr>
                        <td>Current Status:</td>
                        <td>
                            <span class="status-badge status-${task.status == 'Pending' ? 'pending' : task.status == 'In Progress' ? 'in-progress' : task.status == 'Completed' ? 'completed' : 'cancelled'}">
                                ${task.status}
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <td>Assigned Staff:</td>
                        <td><strong>${task.staffName}</strong></td>
                    </tr>
                    <tr>
                        <td>Deadline:</td>
                        <td>
                            <i class="bi bi-calendar"></i> 
                            <fmt:formatDate value="${task.deadline}" pattern="dd/MM/yyyy"/>
                            <jsp:useBean id="now" class="java.util.Date"/>
                            <c:if test="${task.deadline < now && task.status != 'Completed'}">
                                <span class="status-badge" style="background: #fee2e2; color: #991b1b; margin-left: 8px;">
                                    <i class="bi bi-exclamation-triangle"></i> Overdue
                                </span>
                            </c:if>
                        </td>
                    </tr>
                    <tr>
                        <td>Created At:</td>
                        <td>
                            <i class="bi bi-clock-history"></i> 
                            <fmt:formatDate value="${task.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                        </td>
                    </tr>
                    <c:if test="${task.updatedAt != null}">
                        <tr>
                            <td>Last Updated:</td>
                            <td>
                                <i class="bi bi-arrow-clockwise"></i> 
                                <fmt:formatDate value="${task.updatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                            </td>
                        </tr>
                    </c:if>
                </table>
            </div>
        </div>

        <!-- Purchase Order Information -->
        <c:if test="${task.poId > 0 && purchaseOrder != null}">
            <div class="dashboard-card">
                <div class="card-header">
                    <h5><i class="bi bi-file-earmark-text"></i> Purchase Order Information</h5>
                </div>
                <div class="card-body">
                    <table class="details-table">
                        <tr>
                            <td>PO ID:</td>
                            <td><strong>#${purchaseOrder.poId}</strong></td>
                        </tr>
                        <tr>
                            <td>Supplier:</td>
                            <td>${purchaseOrder.supplierName}</td>
                        </tr>
                        <tr>
                            <td>Order Date:</td>
                            <td>
                                <i class="bi bi-calendar"></i> 
                                <fmt:formatDate value="${purchaseOrder.orderDate}" pattern="dd/MM/yyyy"/>
                            </td>
                        </tr>
                        <tr>
                            <td>Expected Delivery:</td>
                            <td>
                                <i class="bi bi-truck"></i> 
                                <fmt:formatDate value="${purchaseOrder.expectedDeliveryDate}" pattern="dd/MM/yyyy"/>
                            </td>
                        </tr>
                        <tr>
                            <td>PO Status:</td>
                            <td>
                                <span class="status-badge status-${purchaseOrder.status == 'Draft' ? 'pending' : purchaseOrder.status == 'Sent' ? 'in-progress' : 'completed'}">
                                    ${purchaseOrder.status}
                                </span>
                            </td>
                        </tr>
                        <c:if test="${not empty purchaseOrder.notes}">
                            <tr>
                                <td>Notes:</td>
                                <td>${purchaseOrder.notes}</td>
                            </tr>
                        </c:if>
                    </table>
                </div>
            </div>
        </c:if>

        <!-- Order Items -->
        <c:if test="${not empty poItems}">
            <div class="dashboard-card">
                <div class="card-header">
                    <h5><i class="bi bi-capsule"></i> Order Items (${poItems.size()} items)</h5>
                </div>
                <div class="card-body">
                    <ul class="item-list">
                        <c:forEach items="${poItems}" var="item">
                            <li>
                                <div style="flex: 1;">
                                    <div class="medicine-main-info">
                                        ${not empty item.medicineName ? item.medicineName : 'Unknown Medicine'}
                                        <c:if test="${not empty item.medicineStrength}">
                                            <span style="color: #3b82f6; font-weight: 600;">${item.medicineStrength}</span>
                                        </c:if>
                                        <span class="medicine-code-badge">${item.medicineCode}</span>
                                    </div>
                                    
                                    <div class="medicine-detail-row">
                                        <c:if test="${not empty item.medicineDosageForm}">
                                            <div class="medicine-detail-item">
                                                <i class="bi bi-capsule"></i> ${item.medicineDosageForm}
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty item.medicineCategory}">
                                            <div class="medicine-detail-item">
                                                <i class="bi bi-tag"></i> ${item.medicineCategory}
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty item.medicineManufacturer}">
                                            <div class="medicine-detail-item">
                                                <i class="bi bi-building"></i> ${item.medicineManufacturer}
                                            </div>
                                        </c:if>
                                    </div>
                                    
                                    <div class="medicine-detail-row" style="margin-top: 6px;">
                                        <c:if test="${not empty item.activeIngredient}">
                                            <div class="medicine-detail-item" style="color: #059669;">
                                                <i class="bi bi-droplet"></i> <strong>Active:</strong> ${item.activeIngredient}
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty item.unit}">
                                            <div class="medicine-detail-item">
                                                <i class="bi bi-box"></i> <strong>Unit:</strong> ${item.unit}
                                            </div>
                                        </c:if>
                                    </div>
                                    
                                    <c:set var="medicine" value="${medicineMap[item.medicineCode]}" />
                                    <c:if test="${not empty medicine}">
                                        <div class="medicine-detail-row" style="margin-top: 6px;">
                                            <c:if test="${not empty medicine.countryOfOrigin}">
                                                <div class="medicine-detail-item">
                                                    <i class="bi bi-globe"></i> ${medicine.countryOfOrigin}
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty medicine.drugGroup}">
                                                <div class="medicine-detail-item">
                                                    <i class="bi bi-collection"></i> ${medicine.drugGroup}
                                                </div>
                                            </c:if>
                                            <c:if test="${not empty medicine.drugType}">
                                                <div class="medicine-detail-item">
                                                    <span style="padding: 2px 8px; background: #dbeafe; color: #1e40af; border-radius: 4px; font-size: 11px;">
                                                        ${medicine.drugType}
                                                    </span>
                                                </div>
                                            </c:if>
                                        </div>
                                        
                                        <c:if test="${not empty medicine.description}">
                                            <div style="margin-top: 8px; padding: 8px; background: #f9fafb; border-radius: 6px; border-left: 3px solid #3b82f6;">
                                                <div style="font-size: 11px; font-weight: 600; color: #6b7280; margin-bottom: 4px;">
                                                    <i class="bi bi-info-circle"></i> DESCRIPTION
                                                </div>
                                                <div style="font-size: 12px; color: #374151; line-height: 1.4;">
                                                    ${medicine.description}
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:if>
                                    
                                    <div style="margin-top: 10px; display: flex; align-items: center; gap: 8px; flex-wrap: wrap;">
                                        <c:if test="${not empty item.priority}">
                                            <span class="status-badge" style="font-size: 11px;
                                                  background: ${item.priority == 'Critical' ? '#fee2e2' :
                                                               item.priority == 'High' ? '#fef3c7' :
                                                               item.priority == 'Medium' ? '#dbeafe' : '#f3f4f6'};
                                                  color: ${item.priority == 'Critical' ? '#991b1b' :
                                                          item.priority == 'High' ? '#92400e' :
                                                          item.priority == 'Medium' ? '#1e40af' : '#374151'};">
                                                <i class="bi bi-flag-fill"></i> Priority: ${item.priority}
                                            </span>
                                        </c:if>
                                        <c:if test="${not empty item.unitPrice && item.unitPrice > 0}">
                                            <span style="font-size: 11px; padding: 4px 8px; background: #dcfce7; color: #166534; border-radius: 4px; font-weight: 600;">
                                                <i class="bi bi-currency-dollar"></i> ${item.unitPrice} VNĐ/unit
                                            </span>
                                        </c:if>
                                    </div>
                                    
                                    <c:if test="${not empty item.notes}">
                                        <div style="margin-top: 8px; padding: 8px; background: #fffbeb; border-left: 3px solid #f59e0b; border-radius: 4px;">
                                            <div style="font-size: 11px; font-weight: 600; color: #92400e; margin-bottom: 4px;">
                                                <i class="bi bi-sticky"></i> NOTES
                                            </div>
                                            <div style="font-size: 12px; color: #78350f;">
                                                ${item.notes}
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                                
                                <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 8px;">
                                    <span class="quantity-badge" style="font-size: 16px; padding: 10px 18px;">
                                        ${item.quantity} units
                                    </span>
                                    <c:if test="${not empty item.unitPrice && item.unitPrice > 0}">
                                        <span style="font-size: 13px; font-weight: 600; color: #059669;">
                                            Total: <fmt:formatNumber value="${item.quantity * item.unitPrice}" type="number"/> VNĐ
                                        </span>
                                    </c:if>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                    
                    <div style="margin-top: 16px; padding: 12px; background: #f9fafb; border-radius: 8px; border: 1px solid #e5e7eb;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span style="font-weight: 600; color: #374151;">
                                <i class="bi bi-box-seam"></i> Total Items: ${poItems.size()}
                            </span>
                            <c:set var="totalQuantity" value="0" />
                            <c:forEach items="${poItems}" var="item">
                                <c:set var="totalQuantity" value="${totalQuantity + item.quantity}" />
                            </c:forEach>
                            <span style="font-weight: 600; color: #3b82f6;">
                                <i class="bi bi-boxes"></i> Total Quantity: ${totalQuantity} units
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </div>

    <!-- Status Update Modal -->
    <div id="statusModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h5><i class="bi bi-arrow-repeat"></i> Update Task Status</h5>
                <button class="close-btn" onclick="closeModal()">&times;</button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/staff/tasks">
                <input type="hidden" name="action" value="updateStatus">
                <input type="hidden" name="taskId" value="${task.taskId}">
                <input type="hidden" name="newStatus" id="newStatusInput">
                
                <div class="modal-body">
                    <p id="statusMessage"></p>
                    <p style="margin-top: 12px; color: #6b7280; font-size: 14px;">
                        <strong>Note:</strong> This action will notify the manager about the status change.
                    </p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeModal()">Cancel</button>
                    <button type="submit" class="btn btn-primary" id="confirmBtn">
                        <i class="bi bi-check"></i> Confirm
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function updateStatus(newStatus) {
            const modal = document.getElementById('statusModal');
            const statusMessage = document.getElementById('statusMessage');
            const newStatusInput = document.getElementById('newStatusInput');
            const confirmBtn = document.getElementById('confirmBtn');
            
            newStatusInput.value = newStatus;
            
            if (newStatus === 'In Progress') {
                statusMessage.innerHTML = '<strong>Are you sure you want to start this task?</strong><br>The status will be changed to "In Progress".';
                confirmBtn.className = 'btn btn-primary';
                confirmBtn.innerHTML = '<i class="bi bi-play-circle"></i> Start Task';
            } else if (newStatus === 'Completed') {
                statusMessage.innerHTML = '<strong>Are you sure you want to mark this task as completed?</strong><br>Please ensure all work has been finished and verified.';
                confirmBtn.className = 'btn btn-success';
                confirmBtn.innerHTML = '<i class="bi bi-check-circle"></i> Complete Task';
            }
            
            modal.classList.add('show');
        }
        
        function closeModal() {
            const modal = document.getElementById('statusModal');
            modal.classList.remove('show');
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('statusModal');
            if (event.target === modal) {
                closeModal();
            }
        }
        
        // Auto-hide alerts after 5 seconds
        setTimeout(() => {
            document.querySelectorAll('.alert').forEach(alert => {
                alert.style.transition = 'opacity 0.5s';
                alert.style.opacity = '0';
                setTimeout(() => alert.remove(), 500);
            });
        }, 5000);
    </script>
</body>
<%@ include file="/admin/footer.jsp" %>
</html>