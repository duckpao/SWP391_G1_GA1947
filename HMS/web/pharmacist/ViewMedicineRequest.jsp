<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh sách yêu cầu thuốc</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            html, body {
                height: 100%;
            }

            body {
                display: flex;
                flex-direction: column;
                background-color: #f9fafb;
                font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
                font-size: 14px;
                line-height: 1.5;
                color: #374151;
            }

            .page-wrapper {
                display: flex;
                flex: 1;
                min-height: calc(100vh - 60px);
            }

            /* White theme sidebar */
            .sidebar {
                width: 250px;
                background-color: #ffffff;
                color: #6c757d;
                display: flex;
                flex-direction: column;
                padding-top: 15px;
                border-right: 1px solid #e5e7eb;
                box-shadow: 2px 0 10px rgba(0, 0, 0, 0.08);
            }

            .menu a {
                display: flex;
                align-items: center;
                padding: 12px 25px;
                color: #6b7280;
                text-decoration: none;
                font-size: 14px;
                font-weight: 500;
                transition: all 0.3s ease;
                border-radius: 0;
                margin: 4px 0;
            }

            .menu a i {
                width: 20px;
                margin-right: 12px;
                color: #6b7280;
            }

            .menu a:hover {
                background-color: #f3f4f6;
                color: #495057;
                transform: translateX(4px);
            }

            .menu a.active {
                background-color: #f3f4f6;
                color: #6b7280;
                font-weight: 600;
            }

            .menu a.active i {
                color: #6b7280;
            }

            /* Main content */
            .main {
                flex: 1;
                padding: 30px;
                background-color: #f9fafb;
                overflow-y: auto;
            }

            h2 {
                font-size: 28px;
                margin-bottom: 25px;
                font-weight: 700;
                color: #1f2937;
                letter-spacing: -0.5px;
            }

            /* Alert styling */
            .alert {
                border-radius: 10px;
                padding: 16px 20px;
                margin-bottom: 24px;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .alert-danger {
                background: #fee2e2;
                color: #991b1b;
                border: 1px solid #fecaca;
            }

            /* Table container */
            .table-container {
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
                overflow: hidden;
            }

            table {
                background: white;
                border-collapse: collapse;
                width: 100%;
                margin: 0;
            }

            thead {
                background: #6b7280;
                color: white;
            }

            th {
                padding: 14px 12px;
                font-weight: 600;
                font-size: 13px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                text-align: center;
            }

            td {
                padding: 12px;
                border-bottom: 1px solid #e5e7eb;
                font-size: 14px;
                text-align: center;
            }

            tbody tr:hover {
                background-color: #f9fafb;
            }

            tbody tr:last-child td {
                border-bottom: none;
            }

            /* Status badges */
            .status {
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                display: inline-block;
            }

            .status.Pending {
                background-color: #fef3c7;
                color: #92400e;
            }

            .status.Approved {
                background-color: #d1fae5;
                color: #065f46;
            }

            .status.Fulfilled {
                background-color: #dbeafe;
                color: #1e40af;
            }

            .status.Canceled {
                background-color: #fee2e2;
                color: #991b1b;
            }

            /* Gray button styling */
            .btn {
                padding: 8px 16px;
                border-radius: 8px;
                font-weight: 600;
                font-size: 13px;
                transition: all 0.3s ease;
                border: none;
                cursor: pointer;
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

            .btn-danger {
                background-color: #ef4444;
                color: white;
            }

            .btn-danger:hover {
                background-color: #dc2626;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
            }

            .btn-sm {
                padding: 6px 12px;
                font-size: 12px;
            }

            .badge {
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
            }

            .bg-secondary {
                background-color: #6b7280;
                color: white;
            }

            /* Empty state */
            .empty-state {
                text-align: center;
                color: #9ca3af;
                padding: 60px 20px;
            }

            .empty-state h3 {
                color: #6b7280;
                margin-bottom: 10px;
            }

            /* Scrollbar styling */
            ::-webkit-scrollbar {
                width: 8px;
            }

            ::-webkit-scrollbar-track {
                background: rgba(0, 0, 0, 0.05);
            }

            ::-webkit-scrollbar-thumb {
                background: rgba(0, 0, 0, 0.2);
                border-radius: 4px;
            }

            ::-webkit-scrollbar-thumb:hover {
                background: rgba(0, 0, 0, 0.3);
            }

            /* Responsive */
            @media (max-width: 768px) {
                .page-wrapper {
                    flex-direction: column;
                }

                .sidebar {
                    width: 100%;
                    border-right: none;
                    border-bottom: 1px solid #e5e7eb;
                }

                .main {
                    padding: 20px;
                }

                h2 {
                    font-size: 22px;
                }
            }
        </style>
    </head>
    <body>
        <%@ include file="/admin/header.jsp" %>

        <div class="page-wrapper">
            <!-- Sidebar -->
            <div class="sidebar">
                <div class="menu">
                    <a href="${pageContext.request.contextPath}/view-medicine">
                        <i class="fa fa-pills"></i> Quản lý thuốc
                    </a>
                    <a href="${pageContext.request.contextPath}/pharmacist/View_MedicineRequest" class="active">
                        <i class="fa fa-file-medical"></i> Yêu cầu thuốc
                    </a>
                    <a href="${pageContext.request.contextPath}/pharmacist/view-order-details">
                        <i class="bi bi-box-seam"></i> Đơn hàng đã giao
                    </a>
                    <a href="${pageContext.request.contextPath}/pharmacist/manage-batch">
                        <i class="fa fa-warehouse"></i> Quản lý số lô/lô hàng
                    </a>
                    <a href="${pageContext.request.contextPath}/pharmacist/recordExpiredDamaged">
                        <i class="fa fa-exclamation-triangle"></i> Thuốc hết hạn/hư hỏng
                    </a>
                    <a href="${pageContext.request.contextPath}/report">
                        <i class="fa fa-chart-line"></i> Báo cáo thống kê
                    </a>
                </div>
            </div>

            <!-- Main content -->
            <div class="main">
                <h2>Danh sách yêu cầu thuốc</h2>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="bi bi-exclamation-triangle-fill"></i>
                        <span>${error}</span>
                    </div>
                </c:if>

                <c:choose>
                    <c:when test="${not empty requestList}">
                        <div class="table-container">
                            <table class="table table-hover align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>Request ID</th>
                                        <th>Bác sĩ</th>
                                        <th>Trạng thái</th>
                                        <th>Ngày yêu cầu</th>
                                        <th>Tên thuốc</th>
                                        <th>Số lượng</th>
                                        <th>Ghi chú</th>
                                        <th>Thao tác</th>
                                        <th> Action</th>

                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="req" items="${requestList}">
                                        <tr>
                                            <td><strong>${req.requestId}</strong></td>
                                            <td>${req.doctorName}</td>
                                            <td><span class="status ${req.status}">${req.status}</span></td>
                                            <td>${req.requestDate}</td>
                                            <td>
                                                <c:forEach var="item" items="${req.items}">
                                                    ${item.medicineName}<br/>
                                                </c:forEach>
                                            </td>
                                            <td>
                                                <c:forEach var="item" items="${req.items}">
                                                    ${item.quantity}<br/>
                                                </c:forEach>
                                            </td>
                                            <td>${req.notes}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${req.status == 'Pending'}">
                                                        <div style="display: flex; gap: 8px; justify-content: center;">
                                                            <!-- Chấp nhận -->
                                                            <form action="${pageContext.request.contextPath}/PharmacistUpdateRequest" 
                                                                  method="get" style="display:inline;">
                                                                <input type="hidden" name="action" value="approve"/>
                                                                <input type="hidden" name="requestId" value="${req.requestId}"/>
                                                                <button type="submit" class="btn btn-success btn-sm">
                                                                    <i class="bi bi-check-circle"></i> Chấp nhận
                                                                </button>
                                                            </form>
                                                            <!-- Từ chối -->
                                                            <form action="${pageContext.request.contextPath}/PharmacistUpdateRequest" 
                                                                  method="get" style="display:inline;" 
                                                                  onsubmit="return addRejectReason(this)">
                                                                <input type="hidden" name="action" value="reject"/>
                                                                <input type="hidden" name="requestId" value="${req.requestId}"/>
                                                                <input type="hidden" name="reason" value=""/>
                                                                <button type="submit" class="btn btn-danger btn-sm">
                                                                    <i class="bi bi-x-circle"></i> Từ chối
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Đã xử lý</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td class="text-center">
                                                <c:choose>
                                                    <c:when test="${req.status == 'Approved' || req.status == 'Fulfilled'}">
                                                        <a href="${pageContext.request.contextPath}/pharmacist/viewIssueSlip?requestId=${req.requestId}"
                                                           class="btn btn-primary btn-sm" title="Xem phiếu xuất">
                                                            <i class="bi bi-eye"></i>
                                                        </a>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <!-- để trống -->
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>


                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <h3>Không có yêu cầu thuốc nào</h3>
                            <p>Chưa có yêu cầu thuốc nào được tạo.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <%@ include file="/admin/footer.jsp" %>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                                                      function addRejectReason(form) {
                                                                          var reason = prompt("Nhập lý do từ chối yêu cầu:");
                                                                          if (reason == null || reason.trim() === "") {
                                                                              alert("Bạn phải nhập lý do từ chối!");
                                                                              return false;
                                                                          }
                                                                          form.reason.value = reason;
                                                                          return true;
                                                                      }
        </script>
    </body>
</html>
