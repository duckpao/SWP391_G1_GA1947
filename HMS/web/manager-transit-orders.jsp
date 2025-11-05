<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>In Transit Orders - Manager Dashboard</title>
        <style>
            /* Minimal CSS for basic layout only */
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
                background-color: #f5f5f5;
            }
            .container {
                max-width: 1200px;
                margin: 0 auto;
                background-color: white;
                padding: 30px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            h1 {
                color: #333;
                border-bottom: 3px solid #007bff;
                padding-bottom: 10px;
            }
            .stats {
                background-color: #e7f3ff;
                padding: 15px;
                border-radius: 5px;
                margin: 20px 0;
            }
            table {
                border-collapse: collapse;
                width: 100%;
                margin: 20px 0;
                background-color: white;
            }
            th, td {
                border: 1px solid #ddd;
                padding: 12px;
                text-align: left;
            }
            th {
                background-color: #007bff;
                color: white;
                font-weight: bold;
            }
            tr:hover {
                background-color: #f5f5f5;
            }
            button {
                padding: 8px 15px;
                margin: 3px;
                cursor: pointer;
                border: none;
                border-radius: 4px;
                font-size: 14px;
                transition: all 0.3s;
            }
            button:hover {
                opacity: 0.8;
                transform: translateY(-1px);
            }
            button:disabled {
                opacity: 0.5;
                cursor: not-allowed;
            }
            .btn-details {
                background-color: #17a2b8;
                color: white;
            }
            .btn-confirm {
                background-color: #28a745;
                color: white;
            }

            /* Modal Styles */
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0,0,0,0.6);
                overflow: auto;
            }
            .modal-content {
                background-color: white;
                margin: 30px auto;
                padding: 0;
                border: 1px solid #888;
                width: 90%;
                max-width: 700px;
                border-radius: 8px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.3);
                animation: slideDown 0.3s;
            }
            @keyframes slideDown {
                from {
                    transform: translateY(-50px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }
            .modal-header {
                background-color: #007bff;
                color: white;
                padding: 20px;
                border-radius: 8px 8px 0 0;
            }
            .modal-header h2 {
                margin: 0;
                font-size: 24px;
            }
            .modal-body {
                padding: 25px;
                max-height: 500px;
                overflow-y: auto;
            }
            .modal-footer {
                padding: 15px 25px;
                background-color: #f8f9fa;
                border-radius: 0 0 8px 8px;
                text-align: right;
            }
            .close {
                color: white;
                float: right;
                font-size: 32px;
                font-weight: bold;
                cursor: pointer;
                line-height: 20px;
            }
            .close:hover {
                opacity: 0.7;
            }

            /* Info Sections */
            .info-section {
                margin: 20px 0;
                padding: 15px;
                background-color: #f8f9fa;
                border-radius: 5px;
                border-left: 4px solid #007bff;
            }
            .info-section h3 {
                margin-top: 0;
                color: #007bff;
                font-size: 18px;
            }
            .info-row {
                display: flex;
                padding: 8px 0;
                border-bottom: 1px solid #e0e0e0;
            }
            .info-row:last-child {
                border-bottom: none;
            }
            .info-label {
                font-weight: bold;
                width: 200px;
                color: #666;
            }
            .info-value {
                flex: 1;
                color: #333;
            }

            /* Items Table in Modal */
            .items-table {
                width: 100%;
                margin-top: 10px;
            }
            .items-table th {
                background-color: #6c757d;
                color: white;
            }
            .items-table td {
                padding: 10px;
            }

            /* Confirm Modal Specific */
            .confirm-modal .modal-header {
                background-color: #ffc107;
                color: #333;
            }
            .warning-icon {
                font-size: 48px;
                color: #ffc107;
                text-align: center;
                margin: 20px 0;
            }
            .confirm-details {
                background-color: #fff3cd;
                border: 1px solid #ffc107;
                border-radius: 5px;
                padding: 15px;
                margin: 20px 0;
            }

            /* Payment Modal Specific */
            .payment-modal .modal-header {
                background-color: #28a745;
            }
            .payment-icon {
                font-size: 48px;
                color: #28a745;
                text-align: center;
                margin: 20px 0;
            }
            .payment-details {
                background-color: #d4edda;
                border: 1px solid #28a745;
                border-radius: 5px;
                padding: 15px;
                margin: 20px 0;
            }

            /* Status Badges */
            .status-badge {
                padding: 6px 12px;
                border-radius: 20px;
                display: inline-block;
                font-size: 12px;
                font-weight: bold;
            }
            .status-intransit {
                background-color: #17a2b8;
                color: white;
            }

            /* Alerts */
            .error {
                color: #721c24;
                padding: 15px;
                background-color: #f8d7da;
                border: 1px solid #f5c6cb;
                border-radius: 5px;
                margin: 20px 0;
            }
            .success {
                color: #155724;
                padding: 15px;
                background-color: #d4edda;
                border: 1px solid #c3e6cb;
                border-radius: 5px;
                margin: 20px 0;
            }
            .empty-state {
                padding: 60px;
                text-align: center;
                background-color: #f8f9fa;
                border-radius: 8px;
                margin: 30px 0;
            }
            .empty-state h3 {
                color: #28a745;
                font-size: 24px;
            }

            /* Loading Spinner */
            .spinner {
                border: 4px solid #f3f3f3;
                border-top: 4px solid #007bff;
                border-radius: 50%;
                width: 40px;
                height: 40px;
                animation: spin 1s linear infinite;
                margin: 20px auto;
            }
            @keyframes spin {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>📦 Đơn Hàng Đang Vận Chuyển (In Transit)</h1>

            <div class="stats">
                <strong>📊 Tổng số đơn hàng đang vận chuyển:</strong> 
                <span style="font-size: 24px; color: #007bff; font-weight: bold;">${orderCount}</span>
            </div>

            <hr>

            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div class="error">
                    <strong>❌ Error:</strong> ${error}
                </div>
            </c:if>

            <!-- No Orders -->
            <c:if test="${empty orders}">
                <div class="empty-state">
                    <h3>✅ Không có đơn hàng đang vận chuyển</h3>
                    <p style="color: #666; font-size: 16px;">Tất cả đơn hàng đã được giao hoặc đang chờ xử lý.</p>
                </div>
            </c:if>

            <!-- Orders Table -->
            <c:if test="${not empty orders}">
                <table>
                    <thead>
                        <tr>
                            <th>ASN ID</th>
                            <th>PO ID</th>
                            <th>Supplier</th>
                            <th>Tracking Number</th>
                            <th>Carrier</th>
                            <th>Shipment Date</th>
                            <th>Expected Delivery</th>
                            <th>Items / Quantity</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${orders}">
                            <tr>
                                <td><strong>#${order.asnId}</strong></td>
                                <td>#${order.poId}</td>
                                <td><strong>${order.supplierName}</strong></td>
                                <td><code>${order.trackingNumber}</code></td>
                                <td>${order.carrier}</td>
                                <td><fmt:formatDate value="${order.shipmentDate}" pattern="dd/MM/yyyy"/></td>
                                <td><fmt:formatDate value="${order.expectedDeliveryDate}" pattern="dd/MM/yyyy"/></td>
                                <td>
                                    <strong>${order.totalItems}</strong> items / 
                                    <strong style="color: #007bff;">${order.totalQuantity}</strong> units
                                </td>
                                <td><span class="status-badge status-intransit">${order.status}</span></td>
                                <td style="white-space: nowrap;">
                                    <button class="btn-details" 
                                            onclick="viewDetails(${order.asnId})">
                                        👁️ View Details
                                    </button>
                                    <button class="btn-confirm" 
                                            onclick="confirmDelivery(${order.asnId}, ${order.poId}, '${order.supplierName}', '${order.trackingNumber}', ${order.totalQuantity})">
                                        ✅ Confirm Delivery
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>

        <!-- ==================== DETAILS MODAL ==================== -->
        <div id="detailsModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <span class="close" onclick="closeDetailsModal()">&times;</span>
                    <h2 id="detailsTitle">📋 Chi Tiết Đơn Hàng</h2>
                </div>
                <div class="modal-body" id="detailsContent">
                    <div class="spinner"></div>
                    <p style="text-align: center;">Loading...</p>
                </div>
                <div class="modal-footer">
                    <button onclick="closeDetailsModal()" style="background-color: #6c757d; color: white; padding: 10px 20px;">
                        Close
                    </button>
                </div>
            </div>
        </div>

        <!-- ==================== CONFIRM DELIVERY MODAL ==================== -->
        <div id="confirmModal" class="modal">
            <div class="modal-content confirm-modal">
                <div class="modal-header">
                    <span class="close" onclick="closeConfirmModal()">&times;</span>
                    <h2>⚠️ Xác Nhận Đã Nhận Hàng</h2>
                </div>
                <div class="modal-body">
                    <div class="warning-icon">⚠️</div>
                    <p id="confirmMessage" style="font-size: 18px; text-align: center; font-weight: bold;"></p>
                    <div class="confirm-details" id="confirmDetails"></div>
                    <p style="color: #666; text-align: center; margin-top: 20px;">
                        Sau khi xác nhận, bạn cần thanh toán cho nhà cung cấp.
                    </p>
                </div>
                <div class="modal-footer">
                    <button onclick="closeConfirmModal()" 
                            style="background-color: #6c757d; color: white; padding: 10px 20px; margin-right: 10px;">
                        ❌ Cancel
                    </button>
                    <button onclick="submitConfirmDelivery()" 
                            id="confirmBtn" 
                            style="background-color: #28a745; color: white; padding: 10px 25px; font-weight: bold;">
                        ✅ Confirm Delivery
                    </button>
                </div>
            </div>
        </div>

        <!-- ==================== PAYMENT MODAL ==================== -->

        <script>
            let currentAsnId = null;
            let currentPoId = null;
            let currentSupplierName = '';
            let currentTotalQuantity = 0;

            // ==================== VIEW DETAILS ====================
            function viewDetails(asnId) {
                console.log('📋 Opening details for ASN #' + asnId);

                document.getElementById('detailsModal').style.display = 'block';
                document.getElementById('detailsContent').innerHTML =
                        '<div class="spinner"></div><p style="text-align: center;">Loading details...</p>';

                fetch('${pageContext.request.contextPath}/manage/transit?action=details&asnId=' + asnId)
                        .then(response => {
                            console.log('Response status:', response.status);
                            if (!response.ok) {
                                throw new Error('HTTP ' + response.status);
                            }
                            return response.json();
                        })
                        .then(data => {
                            console.log('Received data:', data);
                            if (data.success) {
                                displayDetails(data);
                            } else {
                                document.getElementById('detailsContent').innerHTML =
                                        '<div class="error"><strong>Error:</strong> ' + data.message + '</div>';
                            }
                        })
                        .catch(error => {
                            console.error('Error loading details:', error);
                            document.getElementById('detailsContent').innerHTML =
                                    '<div class="error"><strong>Error:</strong> ' + error.message + '</div>';
                        });
            }

            function displayDetails(data) {
                const asn = data.asn;
                const items = data.items;

                console.log('Displaying ASN:', asn);
                console.log('Items count:', items.length);

                let html = '<div class="info-section">';
                html += '<h3>📦 Thông Tin Vận Chuyển</h3>';
                html += '<div class="info-row"><div class="info-label">ASN ID:</div><div class="info-value"><strong>#' + asn.asnId + '</strong></div></div>';
                html += '<div class="info-row"><div class="info-label">PO ID:</div><div class="info-value"><strong>#' + asn.poId + '</strong></div></div>';
                html += '<div class="info-row"><div class="info-label">Supplier:</div><div class="info-value"><strong>' + asn.supplierName + '</strong></div></div>';
                html += '<div class="info-row"><div class="info-label">Tracking Number:</div><div class="info-value"><code>' + asn.trackingNumber + '</code></div></div>';
                html += '<div class="info-row"><div class="info-label">Carrier:</div><div class="info-value">' + asn.carrier + '</div></div>';
                html += '<div class="info-row"><div class="info-label">Shipment Date:</div><div class="info-value">' + asn.shipmentDate + '</div></div>';
                html += '<div class="info-row"><div class="info-label">Status:</div><div class="info-value"><span class="status-badge status-intransit">' + asn.status + '</span></div></div>';

                if (asn.notes && asn.notes.trim() !== '') {
                    html += '<div class="info-row"><div class="info-label">Notes:</div><div class="info-value">' + asn.notes + '</div></div>';
                }
                html += '</div>';

                html += '<div class="info-section">';
                html += '<h3>💊 Danh Sách Thuốc (' + items.length + ' items)</h3>';
                html += '<table class="items-table">';
                html += '<thead><tr><th>Medicine Name</th><th>Quantity</th><th>Unit</th><th>Lot Number</th></tr></thead>';
                html += '<tbody>';

                items.forEach(item => {
                    html += '<tr>';
                    html += '<td><strong>' + item.medicineName + '</strong></td>';
                    html += '<td style="text-align: center;"><strong style="color: #007bff; font-size: 16px;">' + item.quantity + '</strong></td>';
                    html += '<td>' + (item.unit || 'N/A') + '</td>';
                    html += '<td><code>' + (item.lotNumber || 'N/A') + '</code></td>';
                    html += '</tr>';
                });

                html += '</tbody></table>';
                html += '</div>';

                document.getElementById('detailsContent').innerHTML = html;
                document.getElementById('detailsTitle').textContent = '📋 Chi Tiết Đơn Hàng - ASN #' + asn.asnId;
            }

            function closeDetailsModal() {
                document.getElementById('detailsModal').style.display = 'none';
            }

            // ==================== CONFIRM DELIVERY ====================
            function confirmDelivery(asnId, poId, supplierName, trackingNumber, totalQuantity) {
                console.log('✅ Opening confirm modal for ASN #' + asnId);

                currentAsnId = asnId;
                currentPoId = poId;
                currentSupplierName = supplierName;
                currentTotalQuantity = totalQuantity;

                document.getElementById('confirmMessage').innerHTML =
                        'Bạn xác nhận đơn hàng <strong style="color: #007bff;">ASN #' + asnId + '</strong> từ nhà cung cấp <strong style="color: #28a745;">' + supplierName + '</strong> đã được giao thành công?';

                let detailsHtml = '<div class="info-row"><div class="info-label">ASN ID:</div><div class="info-value"><strong>#' + asnId + '</strong></div></div>';
                detailsHtml += '<div class="info-row"><div class="info-label">PO ID:</div><div class="info-value"><strong>#' + poId + '</strong></div></div>';
                detailsHtml += '<div class="info-row"><div class="info-label">Tracking Number:</div><div class="info-value"><code>' + trackingNumber + '</code></div></div>';
                detailsHtml += '<div class="info-row"><div class="info-label">Supplier:</div><div class="info-value"><strong>' + supplierName + '</strong></div></div>';
                detailsHtml += '<div class="info-row"><div class="info-label">Total Quantity:</div><div class="info-value"><strong style="color: #007bff; font-size: 18px;">' + totalQuantity + '</strong> units</div></div>';

                document.getElementById('confirmDetails').innerHTML = detailsHtml;
                document.getElementById('confirmModal').style.display = 'block';
            }

            function closeConfirmModal() {
                document.getElementById('confirmModal').style.display = 'none';
            }

function submitConfirmDelivery() {
    console.log('📤 Submitting confirm delivery for ASN #' + currentAsnId);

    const btn = document.getElementById('confirmBtn');
    btn.disabled = true;
    btn.innerHTML = '<span style="display: inline-block; width: 15px; height: 15px; border: 2px solid white; border-top-color: transparent; border-radius: 50%; animation: spin 0.6s linear infinite;"></span> Processing...';

    const formData = new FormData();
    formData.append('action', 'confirmDelivery');
    formData.append('asnId', currentAsnId);

    fetch('${pageContext.request.contextPath}/manage/transit', {
        method: 'POST',
        body: formData
    })
    .then(async response => {
        const text = await response.text();
        let data;
        
        try {
            data = JSON.parse(text);
        } catch (e) {
            console.error("⚠️ Response không phải JSON:", text);
            throw new Error("Server returned invalid response");
        }
        
        if (!response.ok) {
            throw new Error(data.message || 'Server error');
        }
        
        return data;
    })
    .then(data => {
        console.log('✅ Confirm response:', data);
        
        if (data.success && data.invoiceId) {
            // ✅ REDIRECT ĐẾN TRANG THANH TOÁN MOMO
            alert('✅ Delivery confirmed!\n\nDelivery Note: #' + data.dnId + '\nInvoice: #' + data.invoiceId + '\n\n→ Redirecting to payment page...');
            
            // Redirect đến CreatePaymentServlet với invoiceId
            window.location.href = '${pageContext.request.contextPath}/create-payment?invoiceId=' + data.invoiceId;
            
        } else {
            alert('❌ Error: ' + (data.message || 'Unknown error'));
            btn.disabled = false;
            btn.innerHTML = '✅ Confirm Delivery';
        }
    })
    .catch(err => {
        console.error("❌ Error:", err);
        alert("❌ Connection Error: " + err.message);
        btn.disabled = false;
        btn.innerHTML = "✅ Confirm Delivery";
    });
}

// ✅ XÓA MODAL PAYMENT (không cần nữa)
// function showPaymentModal() { ... }
// function submitPayment() { ... }

            // ==================== PAYMENT ====================


            // Close modal when clicking outside
            window.onclick = function (event) {
                if (event.target.classList.contains('modal')) {
                    event.target.style.display = 'none';
                }
            }

            // Log page load
            console.log('===========================================');
            console.log('Manager Transit Orders Page Loaded');
            console.log('Total orders in transit: ${orderCount}');
            console.log('===========================================');
        </script>
    </body>
</html>