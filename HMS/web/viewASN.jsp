<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Shipping Notice - ASN #${asn.asnId}</title>
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
            max-width: 1000px;
            margin: 0 auto;
        }

        .detail-card {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .detail-header {
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

        .header-content {
            flex: 1;
        }

        .header-content h1 {
            font-size: 28px;
            color: #1f2937;
            margin-bottom: 8px;
        }

        .header-content p {
            color: #6b7280;
            font-size: 14px;
        }

        .status-badge-large {
            padding: 10px 20px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
        }

        .status-badge-large.sent {
            background: #fef3c7;
            color: #92400e;
        }

        .status-badge-large.intransit {
            background: #dbeafe;
            color: #1e40af;
        }

        .status-badge-large.delivered {
            background: #d1fae5;
            color: #065f46;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 24px;
            margin-bottom: 32px;
        }

        .info-section {
            background: #f9fafb;
            padding: 20px;
            border-radius: 12px;
        }

        .info-section-title {
            font-size: 14px;
            font-weight: 700;
            color: #6b7280;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .info-item {
            margin-bottom: 16px;
        }

        .info-item:last-child {
            margin-bottom: 0;
        }

        .info-label {
            font-size: 13px;
            color: #6b7280;
            font-weight: 500;
            margin-bottom: 4px;
        }

        .info-value {
            font-size: 16px;
            color: #1f2937;
            font-weight: 600;
        }

        .tracking-highlight {
            background: linear-gradient(135deg, #e0f2fe 0%, #dbeafe 100%);
            padding: 24px;
            border-radius: 12px;
            border-left: 4px solid #3b82f6;
            margin-bottom: 32px;
        }

        .tracking-title {
            font-size: 16px;
            font-weight: 700;
            color: #1e40af;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .tracking-number {
            font-size: 24px;
            font-weight: 700;
            color: #1f2937;
            font-family: 'Courier New', monospace;
            letter-spacing: 2px;
        }

        .items-section-title {
            font-size: 20px;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 24px;
        }

        .items-table th {
            background: #f9fafb;
            padding: 14px;
            text-align: left;
            font-size: 13px;
            font-weight: 600;
            color: #6b7280;
            border-bottom: 2px solid #e5e7eb;
        }

        .items-table td {
            padding: 16px 14px;
            border-bottom: 1px solid #f3f4f6;
            font-size: 14px;
            color: #1f2937;
        }

        .lot-badge {
            background: #e0e7ff;
            color: #4338ca;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
        }

        .action-buttons {
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
            text-decoration: none;
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

        .timeline {
            margin-top: 32px;
        }

        .timeline-item {
            display: flex;
            gap: 16px;
            margin-bottom: 20px;
        }

        .timeline-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #dbeafe;
            color: #3b82f6;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            flex-shrink: 0;
        }

        .timeline-content {
            flex: 1;
        }

        .timeline-title {
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 4px;
        }

        .timeline-date {
            font-size: 13px;
            color: #6b7280;
        }

        @media (max-width: 768px) {
            .info-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="detail-card">
        <!-- Header -->
        <div class="detail-header">
            <button class="back-btn" onclick="window.location.href='supplierDashboard'">
                <i class="bi bi-arrow-left"></i>
            </button>
            <div class="header-content">
                <h1>
                    <i class="bi bi-file-earmark-text"></i>
                    Shipping Notice #${asn.asnId}
                </h1>
                <p>Purchase Order #${asn.poId}</p>
            </div>
            <span class="status-badge-large ${asn.status.toLowerCase()}">
                <c:choose>
                    <c:when test="${asn.status == 'Sent'}">
                        <i class="bi bi-send"></i> Awaiting Shipment
                    </c:when>
                    <c:when test="${asn.status == 'InTransit'}">
                        <i class="bi bi-truck"></i> In Transit
                    </c:when>
                    <c:when test="${asn.status == 'Delivered'}">
                        <i class="bi bi-check-circle"></i> Delivered
                    </c:when>
                </c:choose>
            </span>
        </div>

        <!-- Tracking Highlight -->
        <div class="tracking-highlight">
            <div class="tracking-title">
                <i class="bi bi-upc-scan"></i>
                Tracking Number
            </div>
            <div class="tracking-number">${asn.trackingNumber}</div>
            <div style="margin-top: 12px; color: #1e40af; font-weight: 600;">
                <i class="bi bi-truck"></i> ${asn.carrier}
            </div>
        </div>

        <!-- Info Grid -->
        <div class="info-grid">
            <div class="info-section">
                <div class="info-section-title">
                    <i class="bi bi-calendar3"></i>
                    Shipment Information
                </div>
                <div class="info-item">
                    <div class="info-label">Shipment Date</div>
                    <div class="info-value">
                        <fmt:formatDate value="${asn.shipmentDate}" pattern="dd MMM yyyy"/>
                    </div>
                </div>
                <div class="info-item">
                    <div class="info-label">Created At</div>
                    <div class="info-value">
                        <fmt:formatDate value="${asn.createdAt}" pattern="dd MMM yyyy HH:mm"/>
                    </div>
                </div>
            </div>

            <div class="info-section">
                <div class="info-section-title">
                    <i class="bi bi-building"></i>
                    Supplier Information
                </div>
                <div class="info-item">
                    <div class="info-label">Submitted By</div>
                    <div class="info-value">${asn.submittedBy}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Supplier</div>
                    <div class="info-value">${supplier.name}</div>
                </div>
            </div>
        </div>

        <!-- Items -->
        <div class="items-section-title">
            <i class="bi bi-box-seam"></i>
            Shipped Items
        </div>
        <table class="items-table">
            <thead>
                <tr>
                    <th>Medicine Code</th>
                    <th>Medicine Name</th>
                    <th>Quantity</th>
                    <th>Lot Number</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${asn.items}">
                    <tr>
                        <td><strong>${item.medicineCode}</strong></td>
                        <td>
                            ${item.medicineName}
                            <c:if test="${not empty item.strength}">
                                <br><small style="color: #6b7280;">${item.strength}</small>
                            </c:if>
                        </td>
                        <td><strong>${item.quantity}</strong> ${item.unit != null ? item.unit : ''}</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty item.lotNumber}">
                                    <span class="lot-badge">${item.lotNumber}</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #9ca3af;">Not assigned</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <!-- Notes -->
        <c:if test="${not empty asn.notes}">
            <div class="info-section">
                <div class="info-section-title">
                    <i class="bi bi-sticky"></i>
                    Notes
                </div>
                <div class="info-value" style="font-weight: 400; line-height: 1.6;">
                    ${asn.notes}
                </div>
            </div>
        </c:if>

        <!-- Action Buttons -->
        <div class="action-buttons">
            <button class="btn btn-secondary" onclick="window.location.href='supplierDashboard'">
                <i class="bi bi-arrow-left"></i>
                Back to Dashboard
            </button>
            
            <c:if test="${asn.status == 'Sent'}">
                <a href="update-tracking?asnId=${asn.asnId}" class="btn btn-primary">
                    <i class="bi bi-pencil"></i>
                    Update Tracking Info
                </a>
            </c:if>
            
            <button class="btn btn-secondary" onclick="window.print()">
                <i class="bi bi-printer"></i>
                Print
            </button>
        </div>
    </div>
</div>

</body>
</html>