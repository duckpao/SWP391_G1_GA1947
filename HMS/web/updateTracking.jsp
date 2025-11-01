<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="/admin/header.jsp" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Tracking Information - ASN #${asn.asnId}</title>
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
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #ffffff;
            color: #2c3e50;
            min-height: 100vh;
        }

        .main-content {
            padding: 30px;
            background: #ffffff;
            min-height: 100vh;
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
        }

        /* Header */
        .page-header {
            background: white;
            border-radius: 12px;
            padding: 28px 32px;
            margin-bottom: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            border: 1px solid #e9ecef;
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .back-btn {
            width: 48px;
            height: 48px;
            border-radius: 10px;
            border: 1.5px solid #dee2e6;
            background: white;
            color: #495057;
            font-size: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .back-btn:hover {
            background: #f8f9fa;
            border-color: #adb5bd;
            transform: translateY(-1px);
            box-shadow: 0 2px 4px rgba(0,0,0,0.08);
        }

        .page-header h1 {
            font-size: 28px;
            color: #2c3e50;
            font-weight: 700;
            flex: 1;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .header-icon {
            width: 40px;
            height: 40px;
            background: #f8f9fa;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            border: 1px solid #dee2e6;
            color: #495057;
        }

        /* ASN Info Box */
        .asn-info-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            border: 1px solid #e9ecef;
            border-left: 4px solid #495057;
        }

        .asn-info-header {
            font-size: 14px;
            font-weight: 700;
            color: #495057;
            margin-bottom: 16px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .asn-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }

        .asn-info-item {
            padding: 14px;
            background: #f9fafb;
            border-radius: 8px;
            border: 1px solid #e5e7eb;
        }

        .asn-info-item label {
            font-size: 12px;
            color: #6b7280;
            font-weight: 500;
            display: block;
            margin-bottom: 4px;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .asn-info-item span {
            font-size: 15px;
            color: #2c3e50;
            font-weight: 600;
        }

        /* Form Card */
        .form-card {
            background: white;
            border-radius: 12px;
            padding: 32px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            border: 1px solid #e9ecef;
        }

        .form-section {
            margin-bottom: 32px;
        }

        .section-title {
            font-size: 18px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            padding-bottom: 12px;
            border-bottom: 2px solid #f3f4f6;
        }

        .section-title i {
            color: #495057;
            font-size: 20px;
        }

        .form-group {
            margin-bottom: 24px;
        }

        .form-group label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }

        .required {
            color: #dc3545;
        }

        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 1.5px solid #dee2e6;
            border-radius: 8px;
            font-size: 15px;
            font-family: 'Inter', sans-serif;
            transition: all 0.2s ease;
            color: #2c3e50;
            background: white;
        }

        .form-control:focus {
            outline: none;
            border-color: #495057;
            box-shadow: 0 0 0 3px rgba(73, 80, 87, 0.1);
        }

        .form-control:hover {
            border-color: #adb5bd;
        }

        select.form-control {
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23495057' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 12px center;
            padding-right: 36px;
        }

        .help-text {
            font-size: 13px;
            color: #6b7280;
            margin-top: 6px;
            font-style: italic;
        }

        .current-value {
            background: #f9fafb;
            padding: 12px 16px;
            border-radius: 8px;
            margin-top: 8px;
            font-size: 14px;
            color: #6b7280;
            border: 1px solid #e5e7eb;
        }

        .current-value strong {
            color: #2c3e50;
            font-weight: 600;
        }

        .current-value i {
            margin-right: 4px;
            color: #495057;
        }

        /* Buttons */
        .form-actions {
            display: flex;
            gap: 12px;
            margin-top: 32px;
            padding-top: 24px;
            border-top: 2px solid #f3f4f6;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            text-decoration: none;
        }

        .btn-primary {
            background: #495057;
            color: white;
            flex: 1;
            border: 1.5px solid #343a40;
        }

        .btn-primary:hover {
            background: #343a40;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(73, 80, 87, 0.2);
        }

        .btn-primary:active {
            transform: translateY(0);
        }

        .btn-secondary {
            background: white;
            color: #495057;
            border: 1.5px solid #dee2e6;
        }

        .btn-secondary:hover {
            background: #f8f9fa;
            border-color: #adb5bd;
            transform: translateY(-1px);
            box-shadow: 0 2px 4px rgba(0,0,0,0.08);
        }

        .btn-secondary:active {
            transform: translateY(0);
        }

        .btn i {
            font-size: 16px;
        }

        /* Info Alert */
        .info-alert {
            background: #f8f9fa;
            border-left: 4px solid #495057;
            border: 1px solid #dee2e6;
            padding: 16px 20px;
            border-radius: 8px;
            margin-bottom: 24px;
            display: flex;
            align-items: start;
            gap: 12px;
        }

        .info-alert i {
            font-size: 20px;
            color: #495057;
            flex-shrink: 0;
            margin-top: 2px;
        }

        .info-alert-content {
            flex: 1;
        }

        .info-alert-title {
            font-size: 14px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 4px;
        }

        .info-alert-text {
            font-size: 13px;
            color: #6b7280;
            line-height: 1.5;
        }

        /* Notification */
        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 16px 24px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            z-index: 9999;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 600;
            animation: slideIn 0.3s ease;
            max-width: 500px;
            min-width: 300px;
        }

        .notification .message {
            flex: 1;
            line-height: 1.4;
        }

        @keyframes slideIn {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        @keyframes slideOut {
            from {
                transform: translateX(0);
                opacity: 1;
            }
            to {
                transform: translateX(100%);
                opacity: 0;
            }
        }

        .notification.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .notification.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .notification .icon {
            font-size: 24px;
        }

        .notification .close-btn {
            margin-left: auto;
            background: none;
            border: none;
            font-size: 20px;
            cursor: pointer;
            color: inherit;
            opacity: 0.7;
            transition: opacity 0.2s;
        }

        .notification .close-btn:hover {
            opacity: 1;
        }

        @media (max-width: 768px) {
            .main-content {
                padding: 15px;
            }

            .page-header {
                padding: 20px;
            }

            .page-header h1 {
                font-size: 22px;
            }

            .form-card {
                padding: 20px;
            }

            .asn-info-grid {
                grid-template-columns: 1fr;
            }

            .form-actions {
                flex-direction: column;
            }

            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>

<!-- Notifications -->
<c:if test="${not empty param.success}">
    <div class="notification success" id="notification">
        <i class="bi bi-check-circle-fill icon"></i>
        <span class="message">${param.success}</span>
        <button class="close-btn" onclick="closeNotification()">
            <i class="bi bi-x"></i>
        </button>
    </div>
</c:if>

<c:if test="${not empty param.error}">
    <div class="notification error" id="notification">
        <i class="bi bi-exclamation-triangle-fill icon"></i>
        <span class="message">${param.error}</span>
        <button class="close-btn" onclick="closeNotification()">
            <i class="bi bi-x"></i>
        </button>
    </div>
</c:if>

<div class="main-content">
    <div class="container">
        <!-- Page Header -->
        <div class="page-header">
            <button class="back-btn" onclick="window.location.href='view-asn?asnId=${asn.asnId}'">
                <i class="bi bi-arrow-left"></i>
            </button>
            <h1>
                <span class="header-icon">
                    <i class="bi bi-pencil-square"></i>
                </span>
                Update Tracking Information
            </h1>
        </div>

        <!-- Info Alert -->
        <div class="info-alert">
            <i class="bi bi-info-circle-fill"></i>
            <div class="info-alert-content">
                <div class="info-alert-title">Update Shipment Tracking</div>
                <div class="info-alert-text">
                    Update the carrier, tracking number, or status when there are changes to your shipment. The hospital will be notified of any updates.
                </div>
            </div>
        </div>

        <!-- ASN Information Card -->
        <div class="asn-info-card">
            <div class="asn-info-header">
                <i class="bi bi-file-earmark-text"></i>
                Current ASN Information
            </div>
            <div class="asn-info-grid">
                <div class="asn-info-item">
                    <label>ASN Number</label>
                    <span>ASN #${asn.asnId}</span>
                </div>
                <div class="asn-info-item">
                    <label>Purchase Order</label>
                    <span>PO #${asn.poId}</span>
                </div>
                <div class="asn-info-item">
                    <label>Shipment Date</label>
                    <span><fmt:formatDate value="${asn.shipmentDate}" pattern="dd MMM yyyy"/></span>
                </div>
                <div class="asn-info-item">
                    <label>Current Status</label>
                    <span style="color: ${asn.status == 'Delivered' ? '#28a745' : asn.status == 'InTransit' ? '#ffc107' : '#17a2b8'};">
                        <i class="bi ${asn.status == 'Delivered' ? 'bi-check-circle' : asn.status == 'InTransit' ? 'bi-arrow-repeat' : 'bi-clock'}"></i>
                        ${asn.status}
                    </span>
                </div>
            </div>
        </div>

        <!-- Update Form Card -->
        <div class="form-card">
            <form action="update-tracking" method="POST" onsubmit="return validateForm()">
                <input type="hidden" name="asnId" value="${asn.asnId}">

                <!-- Tracking Information Section -->
                <div class="form-section">
                    <div class="section-title">
                        <i class="bi bi-truck"></i>
                        Tracking Information
                    </div>

                    <div class="form-group">
                        <label>Carrier <span class="required">*</span></label>
                        <select name="carrier" class="form-control" required>
                            <option value="">-- Select Carrier --</option>
                            <option value="Vietnam Post" ${asn.carrier == 'Vietnam Post' ? 'selected' : ''}>Vietnam Post</option>
                            <option value="Grab Express" ${asn.carrier == 'Grab Express' ? 'selected' : ''}>Grab Express</option>
                            <option value="Shopee Express" ${asn.carrier == 'Shopee Express' ? 'selected' : ''}>Shopee Express</option>
                            <option value="Kerry Express" ${asn.carrier == 'Kerry Express' ? 'selected' : ''}>Kerry Express</option>
                            <option value="Viettel Post" ${asn.carrier == 'Viettel Post' ? 'selected' : ''}>Viettel Post</option>
                            <option value="DHL" ${asn.carrier == 'DHL' ? 'selected' : ''}>DHL</option>
                            <option value="FedEx" ${asn.carrier == 'FedEx' ? 'selected' : ''}>FedEx</option>
                            <option value="UPS" ${asn.carrier == 'UPS' ? 'selected' : ''}>UPS</option>
                            <option value="Other" ${asn.carrier == 'Other' ? 'selected' : ''}>Other</option>
                        </select>
                        <div class="current-value">
                            <i class="bi bi-arrow-right"></i>
                            Current: <strong>${asn.carrier}</strong>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Tracking Number <span class="required">*</span></label>
                        <input type="text" name="trackingNumber" class="form-control" 
                               value="${asn.trackingNumber}" required 
                               placeholder="Enter new tracking number">
                        <div class="help-text">Update the tracking number if it has changed</div>
                        <div class="current-value">
                            <i class="bi bi-arrow-right"></i>
                            Current: <strong>${asn.trackingNumber}</strong>
                        </div>
                    </div>
                </div>

                <!-- Status Update Section -->
                <div class="form-section">
                    <div class="section-title">
                        <i class="bi bi-flag"></i>
                        Shipment Status
                    </div>

                    <div class="form-group">
                        <label>Update Status</label>
                        <select name="status" class="form-control">
                            <option value="${asn.status}">Keep Current (${asn.status})</option>
                            <option value="Sent">Sent - Awaiting Shipment</option>
                            <option value="InTransit">In Transit - On the way</option>
                            <option value="Delivered">Delivered - Completed</option>
                        </select>
                        <div class="help-text">
                            <i class="bi bi-info-circle"></i>
                            Only update status when shipment state changes
                        </div>
                        <div class="current-value">
                            <i class="bi bi-arrow-right"></i>
                            Current Status: <strong>${asn.status}</strong>
                        </div>
                    </div>
                </div>

                <!-- Form Actions -->
                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" 
                            onclick="window.location.href='view-asn?asnId=${asn.asnId}'">
                        <i class="bi bi-x-circle"></i>
                        Cancel
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-circle"></i>
                        Update Tracking
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
            setTimeout(function() {
                closeNotification();
            }, 5000);
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
        const carrier = document.querySelector('select[name="carrier"]').value;
        const trackingNumber = document.querySelector('input[name="trackingNumber"]').value.trim();

        // Check required fields
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
        return confirm('Are you sure you want to update this tracking information?\n\nThe hospital will be notified of the changes.');
    }

    // Disable back button after form submission to prevent duplicate submissions
    let formSubmitted = false;
    document.querySelector('form').addEventListener('submit', function() {
        if (formSubmitted) {
            return false;
        }
        formSubmitted = true;
        
        // Disable submit button
        const submitBtn = document.querySelector('.btn-primary');
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<i class="bi bi-hourglass-split"></i> Updating...';
        submitBtn.style.cursor = 'not-allowed';
        submitBtn.style.opacity = '0.6';
    });
</script>

<jsp:include page="/admin/footer.jsp" />

</body>
</html>