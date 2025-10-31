<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Tracking Information - ASN #${asn.asnId}</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
        }

        .form-card {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
        }

        .form-header {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 32px;
            padding-bottom: 24px;
            border-bottom: 2px solid #f3f4f6;
        }

        .back-btn {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            border: none;
            background: #f3f4f6;
            color: #374151;
            font-size: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .back-btn:hover {
            background: #e5e7eb;
            transform: translateY(-2px);
        }

        .form-header h1 {
            font-size: 24px;
            color: #1f2937;
            flex: 1;
        }

        .asn-info-box {
            background: #f0f9ff;
            border-left: 4px solid #3b82f6;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 32px;
        }

        .info-row {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 12px;
        }

        .info-row:last-child {
            margin-bottom: 0;
        }

        .info-item label {
            font-size: 12px;
            color: #6b7280;
            font-weight: 600;
            display: block;
            margin-bottom: 4px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .info-item span {
            font-size: 15px;
            color: #1f2937;
            font-weight: 600;
        }

        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
        }

        .status-pending {
            background: #fff3cd;
            color: #664d03;
            border: 1px solid #ffecb5;
        }

        .status-sent {
            background: #cfe2ff;
            color: #084298;
            border: 1px solid #9ec5fe;
        }

        .form-section {
            margin-bottom: 32px;
        }

        .section-title {
            font-size: 18px;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }

        .required {
            color: #ef4444;
        }

        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-size: 15px;
            font-family: 'Inter', sans-serif;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .help-text {
            font-size: 13px;
            color: #6b7280;
            margin-top: 6px;
        }

        .form-actions {
            display: flex;
            gap: 16px;
            margin-top: 32px;
            padding-top: 24px;
            border-top: 2px solid #f3f4f6;
        }

        .btn {
            padding: 14px 28px;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            font-size: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            flex: 1;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: #f3f4f6;
            color: #374151;
        }

        .btn-secondary:hover {
            background: #e5e7eb;
        }

        /* Notification Styles */
        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 16px 24px;
            border-radius: 12px;
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
            border: 2px solid #c3e6cb;
        }

        .notification.error {
            background: #f8d7da;
            color: #721c24;
            border: 2px solid #f5c6cb;
        }

        .notification .icon {
            font-size: 24px;
            flex-shrink: 0;
        }

        .notification .message {
            flex: 1;
            line-height: 1.4;
        }

        .notification .close-btn {
            background: none;
            border: none;
            font-size: 20px;
            cursor: pointer;
            color: inherit;
            opacity: 0.7;
            transition: opacity 0.2s;
            padding: 0;
            width: 24px;
            height: 24px;
        }

        .notification .close-btn:hover {
            opacity: 1;
        }

        @media (max-width: 768px) {
            .info-row {
                grid-template-columns: 1fr;
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

<div class="container">
    <div class="form-card">
        <!-- Header -->
        <div class="form-header">
            <button class="back-btn" onclick="window.location.href='supplier-dashboard'">
                <i class="bi bi-arrow-left"></i>
            </button>
            <h1>
                <i class="bi bi-pencil-square"></i>
                Update Tracking Information
            </h1>
        </div>

        <!-- ASN Information -->
        <div class="asn-info-box">
            <div class="info-row">
                <div class="info-item">
                    <label>ASN ID</label>
                    <span>ASN #${asn.asnId}</span>
                </div>
                <div class="info-item">
                    <label>Purchase Order</label>
                    <span>PO #${asn.poId}</span>
                </div>
            </div>
            <div class="info-row">
                <div class="info-item">
                    <label>Current Status</label>
                    <span class="status-badge status-${asn.status.toLowerCase()}">
                        ${asn.status}
                    </span>
                </div>
                <div class="info-item">
                    <label>Created</label>
                    <span><fmt:formatDate value="${asn.createdAt}" pattern="dd MMM yyyy, HH:mm"/></span>
                </div>
            </div>
        </div>

        <!-- Edit Form -->
        <form action="update-tracking" method="POST" onsubmit="return validateForm()">
            <input type="hidden" name="asnId" value="${asn.asnId}">

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
                        <option value="DHL" ${asn.carrier == 'DHL' ? 'selected' : ''}>DHL</option>
                        <option value="FedEx" ${asn.carrier == 'FedEx' ? 'selected' : ''}>FedEx</option>
                        <option value="Other" ${asn.carrier == 'Other' ? 'selected' : ''}>Other</option>
                    </select>
                    <div class="help-text">Current: ${asn.carrier}</div>
                </div>

                <div class="form-group">
                    <label>Tracking Number <span class="required">*</span></label>
                    <input type="text" name="trackingNumber" class="form-control" 
                           value="${asn.trackingNumber}" required 
                           placeholder="Enter new tracking number">
                    <div class="help-text">Update the carrier's tracking number if it has changed</div>
                </div>
            </div>

            <div class="form-actions">
                <button type="button" class="btn btn-secondary" onclick="window.location.href='supplier-dashboard'">
                    <i class="bi bi-x-circle"></i>
                    Cancel
                </button>
                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-check-circle"></i>
                    Update Tracking Info
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    // Auto hide notification
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
                
                const url = new URL(window.location);
                url.searchParams.delete('success');
                url.searchParams.delete('error');
                window.history.replaceState({}, '', url);
            }, 300);
        }
    }

    function validateForm() {
        const carrier = document.querySelector('select[name="carrier"]').value;
        const trackingNumber = document.querySelector('input[name="trackingNumber"]').value;

        if (!carrier || !trackingNumber) {
            alert('Please fill in all required fields');
            return false;
        }

        return confirm('Are you sure you want to update the tracking information for this shipment?');
    }
</script>

</body>
</html>