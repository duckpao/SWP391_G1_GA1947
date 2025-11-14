<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Shipping Notice (ASN)</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/supplier-dashboard.css">
    
    <style>
        /* Additional styles for create-asn page */
        .create-asn-container {
            margin-left: 0;
            padding: var(--spacing-2xl);
            min-height: 100vh;
            background: var(--gray-50);
        }

        .create-asn-wrapper {
            max-width: 1200px;
            margin: 0 auto;
        }

        /* Page Header */
        .page-header {
            background: var(--white);
            border-radius: var(--radius-xl);
            padding: var(--spacing-xl) var(--spacing-2xl);
            margin-bottom: var(--spacing-2xl);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--gray-200);
            display: flex;
            align-items: center;
            gap: var(--spacing-lg);
        }

        .back-btn {
            width: 48px;
            height: 48px;
            border-radius: var(--radius-lg);
            border: 1.5px solid var(--gray-300);
            background: var(--white);
            color: var(--gray-600);
            font-size: 20px;
            cursor: pointer;
            transition: all var(--transition-base);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .back-btn:hover {
            background: var(--gray-50);
            border-color: var(--gray-400);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
            color: var(--gray-900);
        }

        .page-header-content {
            flex: 1;
        }

        .page-header h1 {
            font-size: 28px;
            color: var(--gray-900);
            font-weight: 800;
            margin-bottom: var(--spacing-xs);
            display: flex;
            align-items: center;
            gap: var(--spacing-md);
        }

        .page-header-icon {
            width: 48px;
            height: 48px;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            border-radius: var(--radius-lg);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: var(--white);
        }

        .page-subtitle {
            font-size: 15px;
            color: var(--gray-500);
            font-weight: 500;
        }

        /* Info Alert */
        .info-alert {
            background: linear-gradient(135deg, #eff6ff, #dbeafe);
            border-left: 4px solid var(--primary);
            border-radius: var(--radius-lg);
            padding: var(--spacing-lg);
            margin-bottom: var(--spacing-xl);
            display: flex;
            align-items: flex-start;
            gap: var(--spacing-md);
            border: 1px solid var(--primary-light);
        }

        .info-alert i {
            font-size: 24px;
            color: var(--primary);
            flex-shrink: 0;
            margin-top: 2px;
        }

        .info-alert-content {
            flex: 1;
        }

        .info-alert-title {
            font-size: 15px;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 6px;
        }

        .info-alert-text {
            font-size: 14px;
            color: var(--gray-700);
            line-height: 1.6;
        }

        /* PO Info Card */
        .po-info-card {
            background: var(--white);
            border-radius: var(--radius-xl);
            padding: var(--spacing-xl);
            margin-bottom: var(--spacing-xl);
            box-shadow: var(--shadow-sm);
            border: 2px solid var(--gray-200);
            border-left: 4px solid var(--primary);
        }

        .po-info-header {
            font-size: 16px;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: var(--spacing-lg);
            display: flex;
            align-items: center;
            gap: var(--spacing-sm);
            padding-bottom: var(--spacing-md);
            border-bottom: 2px solid var(--gray-100);
        }

        .po-info-header i {
            color: var(--primary);
            font-size: 20px;
        }

        .po-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: var(--spacing-lg);
        }

        .po-info-item {
            padding: var(--spacing-lg);
            background: var(--gray-50);
            border-radius: var(--radius-lg);
            border: 1px solid var(--gray-200);
            transition: all var(--transition-base);
        }

        .po-info-item:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
            border-color: var(--primary-light);
        }

        .po-info-item label {
            font-size: 11px;
            color: var(--gray-500);
            font-weight: 600;
            display: block;
            margin-bottom: 6px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .po-info-item span {
            font-size: 15px;
            color: var(--gray-900);
            font-weight: 700;
            display: block;
        }

        .po-status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            background: linear-gradient(135d, #d1fae5, #a7f3d0);
            color: #065f46;
            border-radius: var(--radius-md);
            font-size: 13px;
            font-weight: 700;
            border: 1px solid #c3e6cb;
        }

        /* Form Card */
        .form-card {
            background: var(--white);
            border-radius: var(--radius-xl);
            padding: var(--spacing-2xl);
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--gray-200);
        }

        .form-section {
            margin-bottom: var(--spacing-2xl);
        }

        .form-section:last-child {
            margin-bottom: 0;
        }

        .section-title {
            font-size: 18px;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: var(--spacing-lg);
            display: flex;
            align-items: center;
            gap: var(--spacing-sm);
            padding-bottom: var(--spacing-md);
            border-bottom: 2px solid var(--gray-100);
        }

        .section-title i {
            color: var(--primary);
            font-size: 22px;
        }

        .form-group {
            margin-bottom: var(--spacing-lg);
        }

        .form-group label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: var(--gray-700);
            margin-bottom: var(--spacing-sm);
        }

        .required {
            color: var(--danger);
            margin-left: 2px;
        }

        .form-control {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid var(--gray-200);
            border-radius: var(--radius-lg);
            font-size: 15px;
            font-family: 'Inter', sans-serif;
            transition: all var(--transition-base);
            color: var(--gray-900);
            background: var(--white);
            font-weight: 500;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
        }

        .form-control:hover {
            border-color: var(--gray-300);
        }

        select.form-control {
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 16 16'%3E%3Cpath fill='%232563eb' d='M8 11L3 6h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 14px center;
            padding-right: 44px;
        }

        textarea.form-control {
            min-height: 120px;
            resize: vertical;
            line-height: 1.6;
        }

        .form-row {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: var(--spacing-lg);
        }

        .help-text {
            font-size: 13px;
            color: var(--gray-500);
            margin-top: 6px;
            font-style: italic;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .help-text i {
            font-size: 14px;
            color: var(--info);
        }

        /* Items Table */
        .items-table-wrapper {
            border-radius: var(--radius-lg);
            overflow: hidden;
            border: 1px solid var(--gray-200);
            margin-top: var(--spacing-lg);
        }

        .items-table {
            width: 100%;
            border-collapse: collapse;
            background: var(--white);
        }

        .items-table thead {
            background: var(--gray-50);
        }

        .items-table th {
            padding: var(--spacing-md);
            text-align: left;
            font-size: 12px;
            font-weight: 700;
            color: var(--gray-600);
            border-bottom: 2px solid var(--gray-200);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .items-table td {
            padding: var(--spacing-lg) var(--spacing-md);
            border-bottom: 1px solid var(--gray-100);
            font-size: 14px;
            color: var(--gray-900);
            font-weight: 500;
        }

        .items-table tbody tr:hover {
            background: var(--gray-50);
        }

        .items-table tbody tr:last-child td {
            border-bottom: none;
        }

        .items-table code {
            padding: 4px 8px;
            background: var(--gray-100);
            border-radius: var(--radius-sm);
            font-family: 'Courier New', monospace;
            font-size: 13px;
            color: var(--gray-900);
            font-weight: 600;
            border: 1px solid var(--gray-200);
        }

        /* Form Actions */
        .form-actions {
            display: flex;
            gap: var(--spacing-md);
            margin-top: var(--spacing-2xl);
            padding-top: var(--spacing-xl);
            border-top: 2px solid var(--gray-100);
        }

        .btn {
            padding: 14px 28px;
            border: none;
            border-radius: var(--radius-lg);
            font-weight: 600;
            font-size: 15px;
            cursor: pointer;
            transition: all var(--transition-base);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: var(--spacing-sm);
            text-decoration: none;
        }

        .btn i {
            font-size: 18px;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: var(--white);
            flex: 1;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
        }

        .btn-primary:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(37, 99, 235, 0.4);
        }

        .btn-primary:active {
            transform: translateY(0);
        }

        .btn-primary:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        .btn-secondary {
            background: var(--white);
            color: var(--gray-700);
            border: 2px solid var(--gray-300);
        }

        .btn-secondary:hover {
            background: var(--gray-50);
            border-color: var(--gray-400);
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .btn-secondary:active {
            transform: translateY(0);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .create-asn-container {
                padding: var(--spacing-lg);
            }

            .page-header {
                padding: var(--spacing-lg);
            }

            .page-header h1 {
                font-size: 22px;
            }

            .form-card {
                padding: var(--spacing-lg);
            }

            .po-info-grid,
            .form-row {
                grid-template-columns: 1fr;
            }

            .form-actions {
                flex-direction: column;
            }

            .btn {
                width: 100%;
            }

            .items-table {
                font-size: 13px;
            }

            .items-table th,
            .items-table td {
                padding: var(--spacing-sm);
            }
        }
    </style>
</head>
<%@ include file="/admin/header.jsp" %>
<body>

<!-- Notifications -->
<c:if test="${not empty param.success}">
    <div class="notification success" id="notification">
        <i class="bi bi-check-circle-fill"></i>
        <div class="notification-content">
            <div class="notification-title">Success</div>
            <div class="notification-message">${param.success}</div>
        </div>
        <button class="notification-close" onclick="closeNotification()">
            <i class="bi bi-x"></i>
        </button>
    </div>
</c:if>

<c:if test="${not empty param.error}">
    <div class="notification error" id="notification">
        <i class="bi bi-exclamation-triangle-fill"></i>
        <div class="notification-content">
            <div class="notification-title">Error</div>
            <div class="notification-message">${param.error}</div>
        </div>
        <button class="notification-close" onclick="closeNotification()">
            <i class="bi bi-x"></i>
        </button>
    </div>
</c:if>

<div class="create-asn-container">
    <div class="create-asn-wrapper">
        <!-- Page Header -->
        <div class="page-header">
            <button class="back-btn" onclick="window.location.href='supplier-dashboard'">
                <i class="bi bi-arrow-left"></i>
            </button>
            <div class="page-header-content">
                <h1>
                    <span class="page-header-icon">
                        <i class="bi bi-file-earmark-plus"></i>
                    </span>
                    Create Shipping Notice
                </h1>
                <p class="page-subtitle">Notify the hospital about your upcoming shipment</p>
            </div>
        </div>

        <!-- Info Alert -->
        <div class="info-alert">
            <i class="bi bi-info-circle-fill"></i>
            <div class="info-alert-content">
                <div class="info-alert-title">About ASN (Advanced Shipping Notice)</div>
                <div class="info-alert-text">
                    An ASN is a notification sent to the hospital before your shipment arrives. It helps them prepare for receiving and ensures smooth delivery processing.
                </div>
            </div>
        </div>

        <!-- PO Information Card -->
        <div class="po-info-card">
            <div class="po-info-header">
                <i class="bi bi-clipboard-data"></i>
                Purchase Order Information
            </div>
            <div class="po-info-grid">
                <div class="po-info-item">
                    <label>Purchase Order</label>
                    <span>PO #${po.poId}</span>
                </div>
                <div class="po-info-item">
                    <label>Order Date</label>
                    <span><fmt:formatDate value="${po.orderDate}" pattern="dd MMM yyyy"/></span>
                </div>
                <div class="po-info-item">
                    <label>Expected Delivery</label>
                    <span><fmt:formatDate value="${po.expectedDeliveryDate}" pattern="dd MMM yyyy"/></span>
                </div>
                <div class="po-info-item">
                    <label>Total Items</label>
                    <span>${po.items.size()} items</span>
                </div>
                <div class="po-info-item">
                    <label>Supplier</label>
                    <span>${supplier.name}</span>
                </div>
                <div class="po-info-item">
                    <label>Status</label>
                    <span class="po-status-badge">
                        <i class="bi bi-check-circle-fill"></i>
                        Approved
                    </span>
                </div>
            </div>
        </div>

        <!-- ASN Form Card -->
        <div class="form-card">
            <form action="create-asn" method="POST" onsubmit="return validateForm()">
                <input type="hidden" name="poId" value="${po.poId}">

                <!-- Shipping Information Section -->
                <div class="form-section">
                    <div class="section-title">
                        <i class="bi bi-truck"></i>
                        Shipping Information
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Shipment Date <span class="required">*</span></label>
                            <input type="date" name="shipmentDate" class="form-control" required 
                                   min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                            <div class="help-text">
                                <i class="bi bi-info-circle"></i>
                                Select when the shipment will depart
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Carrier <span class="required">*</span></label>
                            <select name="carrier" class="form-control" required>
                                <option value="">-- Select Carrier --</option>
                                <option value="Vietnam Post">Vietnam Post</option>
                                <option value="Grab Express">Grab Express</option>
                                <option value="Shopee Express">Shopee Express</option>
                                <option value="Kerry Express">Kerry Express</option>
                                <option value="Viettel Post">Viettel Post</option>
                                <option value="DHL">DHL</option>
                                <option value="FedEx">FedEx</option>
                                <option value="UPS">UPS</option>
                                <option value="Other">Other</option>
                            </select>
                            <div class="help-text">
                                <i class="bi bi-info-circle"></i>
                                Choose the shipping carrier
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Tracking Number <span class="required">*</span></label>
                        <input type="text" name="trackingNumber" class="form-control" required 
                               placeholder="Enter the carrier's tracking number">
                        <div class="help-text">
                            <i class="bi bi-info-circle"></i>
                            Provide the tracking number for shipment monitoring
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Additional Notes</label>
                        <textarea name="notes" class="form-control" 
                                  placeholder="Enter any special handling instructions, temperature requirements, or other important information about this shipment..."></textarea>
                        <div class="help-text">
                            <i class="bi bi-info-circle"></i>
                            Optional: Add any special instructions or notes
                        </div>
                    </div>
                </div>

                <!-- Items Section -->
                <div class="form-section">
                    <div class="section-title">
                        <i class="bi bi-box-seam"></i>
                        Items Being Shipped (${po.items.size()} items)
                    </div>

                    <div class="items-table-wrapper">
                        <table class="items-table">
                            <thead>
                                <tr>
                                    <th style="width: 15%;">Code</th>
                                    <th style="width: 45%;">Medicine Name</th>
                                    <th style="width: 20%;">Quantity</th>
                                    <th style="width: 20%;">Unit</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${po.items}">
                                    <tr>
                                        <td><code>${item.medicineCode}</code></td>
                                        <td><strong>${item.medicineName}</strong></td>
                                        <td><strong>${item.quantity}</strong></td>
                                        <td>${item.unit != null ? item.unit : '-'}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" onclick="window.location.href='supplier-dashboard'">
                        <i class="bi bi-x-circle"></i>
                        Cancel
                    </button>
                    <button type="submit" class="btn btn-primary" id="submitBtn">
                        <i class="bi bi-check-circle"></i>
                        Create Shipping Notice
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Auto hide notification after 5 seconds
    document.addEventListener('DOMContentLoaded', function() {
        const notification = document.getElementById('notification');
        if (notification) {
            setTimeout(closeNotification, 5000);
        }
    });

    function closeNotification() {
        const notification = document.getElementById('notification');
        if (notification) {
            notification.style.animation = 'slideOut 0.3s ease';
            setTimeout(function() {
                notification.remove();
                
                // Remove params from URL
                const url = new URL(window.location);
                url.searchParams.delete('success');
                url.searchParams.delete('error');
                window.history.replaceState({}, '', url);
            }, 300);
        }
    }

    function validateForm() {
        const shipmentDate = document.querySelector('input[name="shipmentDate"]').value;
        const carrier = document.querySelector('select[name="carrier"]').value;
        const trackingNumber = document.querySelector('input[name="trackingNumber"]').value.trim();

        // Check required fields
        if (!shipmentDate) {
            alert('Please select a shipment date');
            return false;
        }

        if (!carrier) {
            alert('Please select a carrier');
            return false;
        }

        if (!trackingNumber) {
            alert('Please enter a tracking number');
            return false;
        }

        // Validate tracking number format (basic validation)
        if (trackingNumber.length < 5) {
            alert('Tracking number seems too short. Please verify it is correct.');
            return false;
        }

        // Confirm submission
        const confirmed = confirm('Are you sure you want to create this shipping notice?\n\nThe hospital will be notified about the shipment and tracking information.');
        
        if (confirmed) {
            // Disable submit button and show loading state
            const submitBtn = document.getElementById('submitBtn');
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="bi bi-hourglass-split"></i> Creating...';
            submitBtn.style.cursor = 'not-allowed';
            submitBtn.style.opacity = '0.6';
        }
        
        return confirmed;
    }
</script>

<%@ include file="/admin/footer.jsp" %>
</body>
</html>