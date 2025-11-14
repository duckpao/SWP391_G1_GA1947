<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ASN Details - PO #${po.poId}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
    <%@ include file="/admin/header.jsp" %>
    
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="bi bi-truck"></i> Advanced Shipping Notice Details</h2>
            <button onclick="window.history.back()" class="btn btn-secondary">
                <i class="bi bi-arrow-left"></i> Back
            </button>
        </div>
        
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">
                <i class="bi bi-exclamation-circle"></i> ${errorMessage}
            </div>
        </c:if>
        
        <c:if test="${not empty asn}">
            <!-- ASN Summary Card -->
            <div class="card mb-4">
                <div class="card-header bg-info text-white">
                    <h5><i class="bi bi-file-earmark-text"></i> ASN #${asn.asnId} - PO #${asn.poId}</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h6 class="text-muted mb-3">Shipping Information</h6>
                            <table class="table table-sm table-borderless">
                                <tr>
                                    <td><strong><i class="bi bi-upc"></i> Tracking Number:</strong></td>
                                    <td><code class="fs-5">${asn.trackingNumber}</code></td>
                                </tr>
                                <tr>
                                    <td><strong><i class="bi bi-truck"></i> Carrier:</strong></td>
                                    <td>${asn.carrier}</td>
                                </tr>
                                <tr>
                                    <td><strong><i class="bi bi-calendar-check"></i> Shipment Date:</strong></td>
                                    <td>${asn.shipmentDate}</td>
                                </tr>
                                <tr>
                                    <td><strong><i class="bi bi-flag"></i> ASN Status:</strong></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${asn.status == 'Pending'}">
                                                <span class="badge bg-warning">Pending</span>
                                            </c:when>
                                            <c:when test="${asn.status == 'Sent'}">
                                                <span class="badge bg-info">Shipped</span>
                                            </c:when>
                                            <c:when test="${asn.status == 'InTransit'}">
                                                <span class="badge bg-primary">In Transit</span>
                                            </c:when>
                                            <c:when test="${asn.status == 'Delivered'}">
                                                <span class="badge bg-success">Delivered</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        
                        <div class="col-md-6">
                            <h6 class="text-muted mb-3">Supplier & Timeline</h6>
                            <table class="table table-sm table-borderless">
                                <tr>
                                    <td><strong><i class="bi bi-building"></i> Supplier:</strong></td>
                                    <td>${asn.supplierName}</td>
                                </tr>
                                <tr>
                                    <td><strong><i class="bi bi-person-check"></i> Submitted By:</strong></td>
                                    <td>${asn.submittedBy}</td>
                                </tr>
                                <tr>
                                    <td><strong><i class="bi bi-clock"></i> Submitted At:</strong></td>
                                    <td>${asn.submittedAt}</td>
                                </tr>
                                <c:if test="${not empty asn.approvedBy}">
                                    <tr>
                                        <td><strong><i class="bi bi-check-circle"></i> Approved By:</strong></td>
                                        <td>${asn.approvedBy}</td>
                                    </tr>
                                    <tr>
                                        <td><strong><i class="bi bi-clock-history"></i> Approved At:</strong></td>
                                        <td>${asn.approvedAt}</td>
                                    </tr>
                                </c:if>
                            </table>
                        </div>
                    </div>
                    
                    <c:if test="${not empty asn.notes}">
                        <hr>
                        <div class="alert alert-info mb-0">
                            <strong><i class="bi bi-sticky"></i> Shipping Notes:</strong><br>
                            ${asn.notes}
                        </div>
                    </c:if>
                </div>
            </div>
            
            <!-- ASN Items -->
            <div class="card">
                <div class="card-header bg-warning">
                    <h5><i class="bi bi-box-seam"></i> Shipped Items (${asn.totalItems} items, ${asn.totalQuantity} units total)</h5>
                </div>
                <div class="card-body">
                    <c:if test="${empty asnItems}">
                        <div class="alert alert-warning">
                            <i class="bi bi-exclamation-triangle"></i> No items found in this ASN.
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty asnItems}">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Medicine Code</th>
                                        <th>Medicine Name</th>
                                        <th>Category</th>
                                        <th>Strength</th>
                                        <th>Form</th>
                                        <th>Manufacturer</th>
                                        <th>Lot Number</th>
                                        <th>Quantity</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${asnItems}" var="item" varStatus="status">
                                        <tr>
                                            <td>${status.index + 1}</td>
                                            <td><code>${item.medicineCode}</code></td>
                                            <td><strong>${item.medicineName}</strong></td>
                                            <td><span class="badge bg-secondary">${item.medicineCategory}</span></td>
                                            <td><span class="text-primary">${item.strength}</span></td>
                                            <td>${item.dosageForm}</td>
                                            <td>${item.manufacturer}</td>
                                            <td><code class="text-success">${item.lotNumber}</code></td>
                                            <td><span class="badge bg-primary fs-6">${item.quantity} ${item.unit}</span></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                                <tfoot class="table-light">
                                    <tr>
                                        <td colspan="8" class="text-end"><strong>Total Quantity:</strong></td>
                                        <td>
                                            <span class="badge bg-success fs-6">${asn.totalQuantity} units</span>
                                        </td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </c:if>
                </div>
            </div>
            
            <!-- Original PO Items Comparison -->
            <c:if test="${not empty poItems}">
                <div class="card mt-4">
                    <div class="card-header bg-secondary text-white">
                        <h5><i class="bi bi-file-earmark-check"></i> Original Purchase Order Items (For Comparison)</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-sm">
                                <thead class="table-light">
                                    <tr>
                                        <th>Medicine</th>
                                        <th>Code</th>
                                        <th>Ordered Qty</th>
                                        <th>Unit Price</th>
                                        <th>Total</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${poItems}" var="poItem">
                                        <tr>
                                            <td><strong>${poItem.medicineName}</strong></td>
                                            <td><code>${poItem.medicineCode}</code></td>
                                            <td>${poItem.quantity} units</td>
                                            <td>
                                                <c:if test="${not empty poItem.unitPrice && poItem.unitPrice > 0}">
                                                    ${poItem.unitPrice} VNĐ
                                                </c:if>
                                                <c:if test="${empty poItem.unitPrice || poItem.unitPrice == 0}">
                                                    N/A
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:if test="${not empty poItem.unitPrice && poItem.unitPrice > 0}">
                                                    <strong>${poItem.quantity * poItem.unitPrice} VNĐ</strong>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </c:if>
        </c:if>
        
        <div class="mt-4 mb-5">
            <button onclick="window.print()" class="btn btn-outline-primary">
                <i class="bi bi-printer"></i> Print ASN
            </button>
            <button onclick="window.history.back()" class="btn btn-secondary">
                <i class="bi bi-arrow-left"></i> Back
            </button>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
<%@ include file="/admin/footer.jsp" %>

</html>