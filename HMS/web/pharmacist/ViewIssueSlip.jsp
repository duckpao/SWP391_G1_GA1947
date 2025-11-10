<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Phiếu Xuất Thuốc | Pharmacy Admin</title>
    <link rel="stylesheet" href="<c:url value='/assets/css/bootstrap.min.css'/>">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .page-wrapper {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .main-content {
            flex: 1;
            padding: 40px 20px;
            display: flex;
            justify-content: center;
        }

        .slip-card {
            background-color: #fff;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 1100px;
        }

        /* Thanh tiêu đề */
        .header-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px solid #e9ecef;
            margin-bottom: 20px;
            padding-bottom: 10px;
        }

        .header-section h4 {
            margin: 0;
            font-weight: 600;
            color: #212529;
        }

        .header-section nav {
            font-size: 14px;
        }

        .header-section nav a {
            color: #0d6efd;
            text-decoration: none;
        }

        .header-section nav span {
            color: #6c757d;
        }

        /* Nút hành động */
        .action-buttons {
            display: flex;
            gap: 8px;
        }

        .btn-custom {
            border: none;
            border-radius: 8px;
            padding: 8px 18px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: 0.2s;
        }

        .btn-back {
            background-color: #6c757d;
            color: white;
        }

        .btn-back:hover {
            background-color: #5c636a;
        }

        .btn-print {
            background-color: #3b82f6;
            color: white;
        }

        .btn-print:hover {
            background-color: #2563eb;
        }

        /* Phần tiêu đề phiếu xuất */
        .slip-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .slip-header h2 {
            color: #0d6efd;
            font-weight: 700;
        }

        .slip-header .text-muted {
            font-size: 15px;
        }

        /* Thông tin phiếu */
        .info-section {
            text-align: left;
            width: 95%;
            margin: 0 auto 30px;
        }

        .info-section h5 {
            margin-left: 5px;
            color: #495057;
            font-weight: 600;
        }

        .info-table {
            width: 100%;
            border: none;
        }

        .info-table th {
            font-weight: 600;
            color: #212529;
            text-align: left;
            padding: 5px 10px;
            width: 180px;
        }

        .info-table td {
            color: #000;
            padding: 5px 10px;
        }

        /* Danh sách thuốc */
        .table {
            width: 95%;
            margin: 0 auto;
            border: 1px solid #dee2e6;
        }

        .table thead {
            background: linear-gradient(90deg, #0d6efd, #4dabf7);
            color: white;
            font-weight: 600;
        }

        .table tbody tr:nth-child(even) {
            background-color: #f8faff;
        }

        .table tbody tr:hover {
            background-color: #eef5ff;
        }

        /* Chữ ký */
        .signature-section {
            display: flex;
            justify-content: space-between;
            margin-top: 40px;
            text-align: center;
            width: 95%;
            margin-left: auto;
            margin-right: auto;
        }

        .signature {
            width: 45%;
        }

        .signature p {
            margin-bottom: 60px;
            font-style: italic;
        }

        .signature strong {
            border-top: 1px solid #000;
            display: inline-block;
            padding-top: 5px;
        }

        /* Khi in */
        @media print {
            body {
                background: white;
            }
            body * {
                visibility: hidden;
            }
            #printArea, #printArea * {
                visibility: visible;
            }
            #printArea {
                position: absolute;
                left: 0;
                top: 0;
                width: 100%;
                margin: 0 auto;
                padding: 20px 40px;
            }
            .header-section {
                display: none !important;
            }
            .slip-card {
                box-shadow: none;
                border: none;
                padding: 0;
            }
        }
    </style>

    <script>
        function printSlip() {
            window.print();
        }
    </script>
</head>

<body>
<div class="page-wrapper">

    <!-- Nội dung -->
    <div class="main-content">
        <div class="slip-card">

            <!-- Thanh tiêu đề -->
            <div class="header-section">
                <div>
                    <h1><i class="bi bi-list-ul me-2"></i> Phiếu Xuất Thuốc - Quản Lý Kho Dược</h1>
                    <nav>
                        <a href="<c:url value='/pharmacist/View_MedicineRequest'/>">Phiếu Xuất Thuốc :</a>
                         <span>PX #${slip.slipCode}</span>
                    </nav>
                </div>
                <div class="action-buttons">
                    <a href="<c:url value='/pharmacist/View_MedicineRequest'/>" class="btn-custom btn-back">
                        <i class="bi bi-arrow-left"></i> Back to List
                    </a>
                    <button class="btn-custom btn-print" onclick="printSlip()">
                        <i class="bi bi-printer"></i> Print
                    </button>
                </div>
            </div>

            <!-- Nội dung in -->
            <div id="printArea">

                <!-- Header phiếu -->
                <div class="slip-header">
                  <img src="https://phuhieuhocsinh.com/wp-content/uploads/2024/07/logo-benh-vien-phong-kham-6GgxWu.webp"alt="Hospital Logo"width="120" height="120"class="mb-2">

                    <h1 class="text-uppercase">Phiếu Xuất Thuốc</h1>
                    <div class="text-muted fst-italic">Mã phiếu: ${slip.slipCode}</div>
                </div>

                <!-- Thông tin phiếu -->
                <div class="info-section">
                    <h3 class="fw-semibold text-secondary mb-3 text-center">Thông tin phiếu</h3>
                    <table class="info-table">
                        <tbody>
                            <tr>
                                <th>Ngày tạo:</th>
                                <td>${slip.createdDate}</td>
                            </tr>
                            <tr>
                                <th>Dược sĩ xuất:</th>
                                <td>${slip.pharmacistName}</td>
                            </tr>
                            <tr>
                                <th>Bác sĩ yêu cầu:</th>
                                <td>${slip.doctorName}</td>
                            </tr>
                            <tr>
                                <th>Ghi chú:</th>
                                <td>${slip.notes}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Danh sách thuốc -->
                <h3 class="fw-semibold text-secondary mb-3 text-center">Danh sách thuốc</h3>
                <table class="table table-striped table-bordered table-hover text-center align-middle">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Mã thuốc</th>
                            <th>Tên thuốc</th>
                            <th>Số lượng</th>
                            <th>Đơn vị</th>
                            <th>Mã lô</th>
                            <th>Hạn sử dụng</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${items}" varStatus="status">
                            <tr>
                                <td>${status.count}</td>
                                <td>${item.medicineCode}</td>
                                <td class="text-start">${item.medicineName}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.quantity <= 5}">
                                            <span class="badge bg-danger fs-6">${item.quantity}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="fw-semibold">${item.quantity}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${item.unit}</td>
                                <td><c:out value="${item.batchId != null ? item.batchId : '-'}"/></td>
                                <td><c:out value="${item.expiryDate}"/></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <!-- Chữ ký -->
                <div class="signature-section">
                    <div class="signature">
                        <p>Ngày ..... tháng ..... năm .......</p>
                        <strong>Dược sĩ xuất</strong>
                    </div>
                    <div class="signature">
                        <p>Ngày ..... tháng ..... năm .......</p>
                        <strong>Bác sĩ yêu cầu</strong>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
