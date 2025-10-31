<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Tracking - ASN #${asn.asnId}</title>
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
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 700px;
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
        }

        .back-btn:hover {
            background: #e5e7eb;
        }

        .form-header h1 {
            font-size: 24px;
            color: #1f2937;
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

        .current-value {
            background: #f9fafb;
            padding: 12px;
            border-radius: 8px;
            margin-top: 8px;
            font-size: 14px;
            color: #6b7280;
        }

        .current-value strong {
            color: #1f2937;
        }

        .form-actions {
            display: flex;
            gap: 12px;
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
    </style>
</head>
<body>

<div class="container">
    <div class="form-card">
        <div class="form-header">
            <button class="back-btn" onclick="window.location.href='view-asn?asnId=${asn.asnId}'">
                <i class="bi bi-arrow-left"></i>
            </button>
            <h1>
                <i class="bi bi-pencil-square"></i>
                Update Tracking Information
            </h1>
        </div>

        <form action="update-tracking" method="POST">
            <input type="hidden" name="asnId" value="${asn.asnId}">

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
                <div class="current-value">
                    Current: <strong>${asn.carrier}</strong>
                </div>
            </div>

            <div class="form-group">
                <label>Tracking Number <span class="required">*</span></label>
                <input type="text" name="trackingNumber" class="form-control" 
                       value="${asn.trackingNumber}" required 
                       placeholder="Enter new tracking number">
                <div class="help-text">Update the tracking number if it has changed</div>
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
            </div>

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

</body>
</html>