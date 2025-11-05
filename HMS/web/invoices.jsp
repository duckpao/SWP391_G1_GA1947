<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Hóa đơn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .invoice-card {
            transition: transform 0.2s;
        }
        .invoice-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 500;
        }
        .momo-btn {
            background: linear-gradient(135deg, #a0006d 0%, #d5007f 100%);
            border: none;
            color: white;
            padding: 0.6rem 1.5rem;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s;
        }
        .momo-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(160, 0, 109, 0.3);
            color: white;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="row mb-4">
            <div class="col-md-8">
                <h2><i class="bi bi-receipt"></i> Quản lý Hóa đơn</h2>
            </div>
            <div class="col-md-4 text-end">
                <a href="invoices?action=list" class="btn btn-outline-primary">
                    <i class="bi bi-list"></i> Tất cả
                </a>
                <a href="invoices?action=pending" class="btn btn-outline-warning">
                    <i class="bi bi-clock"></i> Chờ thanh toán
                </a>
            </div>
        </div>

        <div class="card shadow-sm">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead class="table-light">
                            <tr>
                                <th>Mã HĐ</th>
                                <th>Số hóa đơn</th>
                                <th>Ngày lập</th>
                                <th>Số tiền</th>
                                <th>Trạng thái</th>
                                <th>Phương thức TT</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="invoice" items="${invoices}">
                                <tr>
                                    <td>#${invoice.invoiceId}</td>
                                    <td><strong>${invoice.invoiceNumber}</strong></td>
                                    <td>
                                        <fmt:formatDate value="${invoice.invoiceDate}" pattern="dd/MM/yyyy"/>
                                    </td>
                                    <td>
                                        <strong><fmt:formatNumber value="${invoice.amount}" pattern="#,###"/> VNĐ</strong>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${invoice.status == 'Paid'}">
                                                <span class="badge bg-success">
                                                    <i class="bi bi-check-circle"></i> Đã thanh toán
                                                </span>
                                            </c:when>
                                            <c:when test="${invoice.status == 'Pending'}">
                                                <span class="badge bg-warning text-dark">
                                                    <i class="bi bi-clock"></i> Chờ thanh toán
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger">
                                                    <i class="bi bi-exclamation-circle"></i> ${invoice.status}
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:if test="${invoice.paymentMethod != null}">
                                            <span class="badge bg-info">${invoice.paymentMethod}</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${invoice.status == 'Pending'}">
                                                <form action="create-payment" method="post" class="d-inline">
                                                    <input type="hidden" name="invoiceId" value="${invoice.invoiceId}">
                                                    <button type="submit" class="btn momo-btn btn-sm">
                                                        <i class="bi bi-wallet2"></i> Thanh toán MoMo
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:when test="${invoice.status == 'Paid'}">
                                                <button class="btn btn-sm btn-outline-success" disabled>
                                                    <i class="bi bi-check-all"></i> Đã thanh toán
                                                </button>
                                            </c:when>
                                        </c:choose>
                                        
                                        <a href="invoices?action=view&id=${invoice.invoiceId}" 
                                           class="btn btn-sm btn-outline-primary ms-2">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <c:if test="${empty invoices}">
                                <tr>
                                    <td colspan="7" class="text-center py-4">
                                        <i class="bi bi-inbox" style="font-size: 3rem; color: #ccc;"></i>
                                        <p class="text-muted mt-2">Không có hóa đơn nào</p>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Statistics Cards -->
        <div class="row mt-4">
            <div class="col-md-4">
                <div class="card text-white bg-primary">
                    <div class="card-body">
                        <h5><i class="bi bi-receipt"></i> Tổng hóa đơn</h5>
                        <h2>${invoices.size()}</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-white bg-warning">
                    <div class="card-body">
                        <h5><i class="bi bi-clock"></i> Chờ thanh toán</h5>
                        <h2>
                            <c:set var="pendingCount" value="0"/>
                            <c:forEach var="invoice" items="${invoices}">
                                <c:if test="${invoice.status == 'Pending'}">
                                    <c:set var="pendingCount" value="${pendingCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${pendingCount}
                        </h2>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-white bg-success">
                    <div class="card-body">
                        <h5><i class="bi bi-check-circle"></i> Đã thanh toán</h5>
                        <h2>
                            <c:set var="paidCount" value="0"/>
                            <c:forEach var="invoice" items="${invoices}">
                                <c:if test="${invoice.status == 'Paid'}">
                                    <c:set var="paidCount" value="${paidCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${paidCount}
                        </h2>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>