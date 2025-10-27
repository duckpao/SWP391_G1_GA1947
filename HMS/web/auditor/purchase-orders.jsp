<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Purchase Orders - Auditor</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .stats-card {
            border-left: 4px solid;
            transition: transform 0.2s;
        }
        .stats-card:hover {
            transform: translateY(-5px);
        }
        .filter-section {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .table-actions {
            white-space: nowrap;
        }
    </style>
</head>
<body>
    <div class="container-fluid py-4">
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="bi bi-receipt"></i> Purchase Orders Management</h2>
            <div>
                <span class="badge bg-info">Auditor: ${sessionScope.user}</span>
            </div>
        </div>

        <!-- Statistics Cards -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card stats-card border-primary">
                    <div class="card-body">
                        <h6 class="text-muted">Total Orders</h6>
                        <h3 class="mb-0">${totalOrders}</h3>
                        <small class="text-muted"><i class="bi bi-cart"></i> All time</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card border-success">
                    <div class="card-body">
                        <h6 class="text-muted">Completed</h6>
                        <h3 class="mb-0 text-success">${completedOrders}</h3>
                        <small class="text-muted"><i class="bi bi-check-circle"></i> Finished</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card border-warning">
                    <div class="card-body">
                        <h6 class="text-muted">Pending</h6>
                        <h3 class="mb-0 text-warning">${pendingOrders}</h3>
                        <small class="text-muted"><i class="bi bi-clock"></i> In progress</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card border-info">
                    <div class="card-body">
                        <h6 class="text-muted">Total Amount</h6>
                        <h3 class="mb-0 text-info">
                            <fmt:formatNumber value="${totalAmount}" type="currency" currencySymbol="$"/>
                        </h3>
                        <small class="text-muted"><i class="bi bi-cash-stack"></i> All orders</small>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filter Section -->
        <div class="filter-section">
            <form method="get" action="purchase-orders" id="filterForm">
                <input type="hidden" name="action" value="list">
                <div class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label">Status</label>
                        <select name="status" class="form-select">
                            <option value="">All Statuses</option>
                            <c:forEach var="status" items="${statuses}">
                                <option value="${status}" ${selectedStatus == status ? 'selected' : ''}>
                                    ${status}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Supplier</label>
                        <select name="supplierId" class="form-select">
                            <option value="">All Suppliers</option>
                            <c:forEach var="supplier" items="${suppliers}">
                                <option value="${supplier.supplierId}" 
                                        ${selectedSupplierId == supplier.supplierId ? 'selected' : ''}>
                                    ${supplier.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">From Date</label>
                        <input type="date" name="fromDate" class="form-control" value="${fromDate}">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">To Date</label>
                        <input type="date" name="toDate" class="form-control" value="${toDate}">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Search</label>
                        <input type="text" name="search" class="form-control" 
                               placeholder="PO ID, Supplier..." value="${searchKeyword}">
                    </div>
                </div>
                <div class="row mt-3">
                    <div class="col-12">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-search"></i> Filter
                        </button>
                        <button type="button" class="btn btn-secondary" onclick="clearFilters()">
                            <i class="bi bi-x-circle"></i> Clear
                        </button>
                        <button type="button" class="btn btn-success" onclick="exportToExcel()">
                            <i class="bi bi-file-earmark-excel"></i> Export Excel
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Purchase Orders Table -->
        <div class="card">
            <div class="card-header bg-white">
                <h5 class="mb-0"><i class="bi bi-list-ul"></i> Purchase Orders List</h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>PO ID</th>
                                <th>Order Date</th>
                                <th>Supplier</th>
                                <th>Manager</th>
                                <th>Status</th>
                                <th>Items</th>
                                <th>Total Amount</th>
                                <th>Expected Delivery</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty purchaseOrders}">
                                    <tr>
                                        <td colspan="9" class="text-center py-4">
                                            <i class="bi bi-inbox" style="font-size: 3rem; color: #ccc;"></i>
                                            <p class="text-muted mt-2">No purchase orders found</p>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="po" items="${purchaseOrders}">
                                        <tr>
                                            <td><strong>#${po.poId}</strong></td>
                                            <td>
                                                <fmt:formatDate value="${po.orderDate}" pattern="dd/MM/yyyy"/>
                                            </td>
                                            <td>${po.supplierName}</td>
                                            <td>${po.managerName}</td>
                                            <td>
                                                <span class="${po.statusBadgeClass}">${po.status}</span>
                                            </td>
                                            <td>
                                                <span class="badge bg-secondary">${po.itemCount} items</span>
                                            </td>
                                            <td>
                                                <fmt:formatNumber value="${po.totalAmount}" 
                                                                type="currency" currencySymbol="$"/>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty po.expectedDeliveryDate}">
                                                        <fmt:formatDate value="${po.expectedDeliveryDate}" 
                                                                      pattern="dd/MM/yyyy"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">N/A</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="table-actions">
                                                <a href="purchase-orders?action=view&id=${po.poId}" 
                                                   class="btn btn-sm btn-info" title="View Details">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function clearFilters() {
            window.location.href = 'purchase-orders?action=list';
        }

        function exportToExcel() {
            alert('Export functionality to be implemented');
            // TODO: Implement Excel export
        }
    </script>
</body>
</html>