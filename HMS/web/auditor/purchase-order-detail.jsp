<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    // Disable caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
        <meta http-equiv="Pragma" content="no-cache">
        <meta http-equiv="Expires" content="0">
        <title>Purchase Order Details</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            .detail-card {
                border: none;
                box-shadow: 0 0 20px rgba(0,0,0,0.1);
            }
            .info-label {
                font-weight: 600;
                color: #6c757d;
            }
            .section-title {
                border-bottom: 2px solid #0d6efd;
                padding-bottom: 10px;
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="container py-4">
            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2><i class="bi bi-receipt-cutoff"></i> Purchase Order Details</h2>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <a href="purchase-orders">Purchase Orders</a>
                            </li>
                            <li class="breadcrumb-item active">PO #${purchaseOrder.poId}</li>
                        </ol>
                    </nav>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/purchase-orders" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i> Back to List
                    </a>
                    <button class="btn btn-primary" onclick="window.print()">
                        <i class="bi bi-printer"></i> Print
                    </button>
                </div>
            </div>

            <!-- PO Information -->
            <div class="row">
                <!-- Left Column -->
                <div class="col-md-8">
                    <!-- Basic Info Card -->
                    <div class="card detail-card mb-4">
                        <div class="card-body">
                            <h5 class="section-title">
                                <i class="bi bi-info-circle"></i> Purchase Order Information
                            </h5>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <p class="info-label mb-1">PO ID:</p>
                                    <h4 class="text-primary">#${purchaseOrder.poId}</h4>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <p class="info-label mb-1">Status:</p>
                                    <span class="${purchaseOrder.statusBadgeClass} fs-5">
                                        ${purchaseOrder.status}
                                    </span>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <p class="info-label mb-1">Order Date:</p>
                                    <p class="mb-0">
                                        <i class="bi bi-calendar"></i>
                                        <fmt:formatDate value="${purchaseOrder.orderDate}" 
                                                        pattern="dd/MM/yyyy HH:mm"/>
                                    </p>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <p class="info-label mb-1">Expected Delivery:</p>
                                    <p class="mb-0">
                                        <c:choose>
                                            <c:when test="${not empty purchaseOrder.expectedDeliveryDate}">
                                                <i class="bi bi-truck"></i>
                                                <fmt:formatDate value="${purchaseOrder.expectedDeliveryDate}" 
                                                                pattern="dd/MM/yyyy"/>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">Not specified</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <p class="info-label mb-1">Manager:</p>
                                    <p class="mb-0">
                                        <i class="bi bi-person-badge"></i> ${purchaseOrder.managerName}
                                    </p>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <p class="info-label mb-1">Last Updated:</p>
                                    <p class="mb-0">
                                        <i class="bi bi-clock-history"></i>
                                        <fmt:formatDate value="${purchaseOrder.updatedAt}" 
                                                        pattern="dd/MM/yyyy HH:mm"/>
                                    </p>
                                </div>
                            </div>
                            <c:if test="${not empty purchaseOrder.notes}">
                                <hr>
                                <p class="info-label mb-1">Notes:</p>
                                <p class="mb-0">${purchaseOrder.notes}</p>
                            </c:if>
                        </div>
                    </div>

                    <!-- Items List Card -->
                    <div class="card detail-card">
                        <div class="card-body">
                            <h5 class="section-title">
                                <i class="bi bi-box-seam"></i> Order Items
                            </h5>
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead class="table-light">
                                        <tr>
                                            <th>#</th>
                                            <th>Medicine Code</th>
                                            <th>Medicine Name</th>
                                            <th>Manufacturer</th>
                                            <th>Quantity</th>
                                            <th>Unit</th>
                                            <th>Unit Price</th>
                                            <th>Subtotal</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:set var="totalAmount" value="0"/>
                                        <c:forEach var="item" items="${items}" varStatus="status">
                                            <tr>
                                                <td>${status.index + 1}</td>
                                                <td><code>${item.medicineCode}</code></td>
                                                <td><strong>${item.medicineName}</strong></td>
                                                <td>${item.medicineManufacturer}</td>
                                                <td><span class="badge bg-info">${item.quantity}</span></td>
                                                <td>${item.unit}</td>
                                                <td>
                                                    <fmt:formatNumber value="${item.unitPrice}" 
                                                                      type="currency" currencySymbol="$"/>
                                                </td>
                                                <td>
                                                    <strong>
                                                        <fmt:formatNumber value="${item.getSubTotal()}" 
                                                                          type="currency" currencySymbol="$"/>
                                                    </strong>
                                                </td>
                                            </tr>
                                            <c:set var="totalAmount" value="${totalAmount + item.getSubTotal()}"/>
                                        </c:forEach>
                                    </tbody>
                                    <tfoot class="table-light">
                                        <tr>
                                            <td colspan="7" class="text-end"><strong>Total Amount:</strong></td>
                                            <td>
                                                <strong class="text-primary fs-5">
                                                    <fmt:formatNumber value="${totalAmount}" 
                                                                      type="currency" currencySymbol="$"/>
                                                </strong>
                                            </td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Column - Supplier Info -->
                <div class="col-md-4">
                    <div class="card detail-card">
                        <div class="card-body">
                            <h5 class="section-title">
                                <i class="bi bi-building"></i> Supplier Information
                            </h5>
                            <div class="mb-3">
                                <p class="info-label mb-1">Supplier Name:</p>
                                <h5 class="text-primary">${purchaseOrder.supplierName}</h5>
                            </div>
                            <div class="mb-3">
                                <p class="info-label mb-1">Supplier ID:</p>
                                <p class="mb-0">#${purchaseOrder.supplierId}</p>
                            </div>
                        </div>
                    </div>

                    <!-- Quick Actions -->
                    <div class="card detail-card mt-4">
                        <div class="card-body">
                            <h5 class="section-title">
                                <i class="bi bi-lightning"></i> Quick Actions
                            </h5>
                            <div class="d-grid gap-2">
                                <button class="btn btn-outline-primary" onclick="viewAuditLog()">
                                    <i class="bi bi-journal-text"></i> View Audit Log
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                    // Debug info
                                    console.log('=== Purchase Order Detail Page ===');
                                    console.log('PO Object:', {
                                        poId: '${purchaseOrder.poId}',
                                        status: '${purchaseOrder.status}',
                                        supplier: '${purchaseOrder.supplierName}'
                                    });
                                    console.log('Items count:', ${not empty items ? items.size() : 0});

                                    // Check if data is loaded
                                    if (!'${purchaseOrder.poId}') {
                                        console.error('❌ Purchase Order data not loaded!');
                                        alert('Error: Purchase Order data not loaded. Redirecting to list...');
                                        window.location.href = '${pageContext.request.contextPath}/purchase-orders';
                                    } else {
                                        console.log('✅ Purchase Order loaded successfully');
                                    }

                                    function viewAuditLog() {
                                        alert('View audit log functionality to be implemented');
                                    }

                                    function viewRelatedDocs() {
                                        alert('View related documents functionality to be implemented');
                                    }

                                    function exportPDF() {
                                        alert('Export to PDF functionality to be implemented');
                                    }
        </script>
    </body>
</html>