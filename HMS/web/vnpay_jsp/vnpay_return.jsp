<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>KẾT QUẢ THANH TOÁN</title>
    <link href="${pageContext.request.contextPath}/vnpay_jsp/assets/bootstrap.min.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/vnpay_jsp/assets/jumbotron-narrow.css" rel="stylesheet">
    <script src="${pageContext.request.contextPath}/vnpay_jsp/assets/jquery-1.11.3.min.js"></script>
    <style>
        .success-box {
            background-color: #d4edda;
            border: 2px solid #28a745;
            border-radius: 8px;
            padding: 30px;
            margin: 20px 0;
            text-align: center;
        }
        .success-box h2 {
            color: #28a745;
            margin: 10px 0;
        }
        .error-box {
            background-color: #f8d7da;
            border: 2px solid #dc3545;
            border-radius: 8px;
            padding: 30px;
            margin: 20px 0;
            text-align: center;
        }
        .error-box h2 {
            color: #dc3545;
            margin: 10px 0;
        }
        .icon {
            font-size: 64px;
            margin-bottom: 15px;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin: 10px;
        }
        .btn-success {
            background-color: #28a745;
        }
        .btn-secondary {
            background-color: #6c757d;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header clearfix">
            <h3 class="text-muted">KẾT QUẢ THANH TOÁN</h3>
        </div>

        <c:choose>
            <c:when test="${paymentSuccess}">
                <!-- Thanh toán thành công -->
                <div class="success-box">
                    <div class="icon">✅</div>
                    <h2>THANH TOÁN THÀNH CÔNG!</h2>
                    <p style="font-size: 18px; margin-top: 15px;">${message}</p>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Thanh toán thất bại -->
                <div class="error-box">
                    <div class="icon">❌</div>
                    <h2>THANH TOÁN THẤT BẠI</h2>
                    <p style="font-size: 18px; margin-top: 15px;">${message}</p>
                </div>
            </c:otherwise>
        </c:choose>

        <div class="table-responsive">
            <div class="form-group">
                <label>ASN ID:</label>
                <label><strong>#${asnId}</strong></label>
            </div>
            
            <div class="form-group">
                <label>PO ID:</label>
                <label><strong>#${poId}</strong></label>
            </div>
            
            <div class="form-group">
                <label>Mã giao dịch thanh toán:</label>
                <label><code>${txnRef}</code></label>
            </div>
            
            <div class="form-group">
                <label>Số tiền:</label>
                <label>
                    <strong style="color: #28a745; font-size: 20px;">
                        <fmt:formatNumber value="${amount}" type="number" maxFractionDigits="0"/> VNĐ
                    </strong>
                </label>
            </div>
            
            <div class="form-group">
                <label>Mã giao dịch tại VNPAY:</label>
                <label><code>${transactionNo}</code></label>
            </div>
            
            <div class="form-group">
                <label>Mã lỗi thanh toán:</label>
                <label>
                    <c:choose>
                        <c:when test="${responseCode == '00'}">
                            <span style="color: #28a745; font-weight: bold;">00 - Thành công</span>
                        </c:when>
                        <c:otherwise>
                            <span style="color: #dc3545; font-weight: bold;">${responseCode}</span>
                        </c:otherwise>
                    </c:choose>
                </label>
            </div>
            
            <div class="form-group">
                <label>Tình trạng giao dịch:</label>
                <label>
                    <c:choose>
                        <c:when test="${paymentSuccess}">
                            <span style="color: #28a745; font-weight: bold;">✅ Thành công</span>
                        </c:when>
                        <c:when test="${!isValidSignature}">
                            <span style="color: #dc3545; font-weight: bold;">❌ Chữ ký không hợp lệ</span>
                        </c:when>
                        <c:otherwise>
                            <span style="color: #dc3545; font-weight: bold;">❌ Không thành công</span>
                        </c:otherwise>
                    </c:choose>
                </label>
            </div>
        </div>

        <!-- Buttons -->
        <div style="text-align: center; margin-top: 30px;">
            <c:choose>
                <c:when test="${paymentSuccess}">
                    <a href="${pageContext.request.contextPath}/manage/transit" class="btn-primary btn-success">
                        ✅ Quay lại danh sách đơn hàng
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/manage/transit" class="btn-primary">
                        🔄 Quay lại
                    </a>
                </c:otherwise>
            </c:choose>
        </div>

        <footer class="footer">
            <p>&copy; VNPAY 2025 | Hospital Management System</p>
        </footer>
    </div>
</body>
</html>