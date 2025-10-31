<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Shipping Notice (ASN)</title>
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
            max-width: 900px;
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
            font-size: 28px;
            color: #1f2937;
            flex: 1;
        }

        .po-info-box {
            background: #f0f9ff;
            border-left: 4px solid #3b82f6;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 32px;
        }

        .po-info-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 16px;
        }

        .po-info-item label {
            font-size: 12px;
            color: #6b7280;
            font-weight: 600;
            display: block;
            margin-bottom: 4px;
        }

        .po-info-item span {
            font-size: 15px;
            color: #1f2937;
            font-weight: 600;
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

        textarea.form-control {
            min-height: 100px;
            resize: vertical;
        }

        .form-row {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .items-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 16px;
        }

        .items-table th {
            background: #f9fafb;
            padding: 12px;
            text-align: left;
            font-size: 13px;
            font-weight: 600;
            color: #6b7280;
            border-bottom: 2px solid #e5e7eb;
        }

        .items-table td {
            padding: 14px 12px;
            border-bottom: 1px solid #f3f4f6;
            font-size: 14px;
            color: #1f2937;
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

        .help-text {
            font-size: 13px;
            color: #6b7280;
            margin-top: 6px;
        }

        @media (max-width: 768px) {
            .po-info-row,
            .form-row {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="form-card">
        <!-- Header -->
        <div class="form-header">
            <button class="back-btn" onclick="window.location.href='supplier-dashboard'">
                <i class="bi bi-arrow-left"></i>
            </button>
            <h1>
                <i class="bi bi-file-earmark-plus"></i>
                Create Advanced Shipping Notice (ASN)
            </h1>
        </div>

        <!-- PO Information -->
        <div class="po-info-box">
            <div class="po-info-row">
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
            </div>
            <div class="po-info-row">
                <div class="po-info-item">
                    <label>Total Items</label>
                    <span>${po.items.size()} items</span>
                </div>
                <div class="po-info-item">
                    <label>Supplier</label>
                    <span>${supplier.name}</span>
                </div>
            </div>
        </div>

        <!-- ASN Form -->
        <form action="create-asn" method="POST" onsubmit="return validateForm()">
            <input type="hidden" name="poId" value="${po.poId}">

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
                        <div class="help-text">When will the shipment depart?</div>
                    </div>

                    <div class="form-group">
                        <label>Carrier <span class="required">*</span></label>
                        <select name="carrier" class="form-control" required>
                            <option value="">-- Select Carrier --</option>
                            <option value="Vietnam Post">Vietnam Post</option>
                            <option value="Grab Express">Grab Express</option>
                            <option value="Shopee Express">Shopee Express</option>
                            <option value="Kerry Express">Kerry Express</option>
                            <option value="DHL">DHL</option>
                            <option value="FedEx">FedEx</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label>Tracking Number <span class="required">*</span></label>
                    <input type="text" name="trackingNumber" class="form-control" required 
                           placeholder="Enter tracking number">
                    <div class="help-text">Provide the carrier's tracking number for this shipment</div>
                </div>

                <div class="form-group">
                    <label>Additional Notes</label>
                    <textarea name="notes" class="form-control" 
                              placeholder="Any special handling instructions or notes about this shipment..."></textarea>
                </div>
            </div>

            <div class="form-section">
                <div class="section-title">
                    <i class="bi bi-box-seam"></i>
                    Items Being Shipped
                </div>

                <table class="items-table">
                    <thead>
                        <tr>
                            <th>Medicine Code</th>
                            <th>Medicine Name</th>
                            <th>Quantity</th>
                            <th>Unit</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${po.items}">
                            <tr>
                                <td><strong>${item.medicineCode}</strong></td>
                                <td>${item.medicineName}</td>
                                <td><strong>${item.quantity}</strong></td>
                                <td>${item.unit != null ? item.unit : '-'}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="form-actions">
                <button type="button" class="btn btn-secondary" onclick="window.location.href='supplier-dashboard'">
                    <i class="bi bi-x-circle"></i>
                    Cancel
                </button>
                <button type="submit" class="btn btn-primary">
                    <i class="bi bi-check-circle"></i>
                    Create Shipping Notice
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function validateForm() {
        const shipmentDate = document.querySelector('input[name="shipmentDate"]').value;
        const carrier = document.querySelector('select[name="carrier"]').value;
        const trackingNumber = document.querySelector('input[name="trackingNumber"]').value;

        if (!shipmentDate || !carrier || !trackingNumber) {
            alert('Please fill in all required fields');
            return false;
        }

        // Confirm submission
        return confirm('Are you sure you want to create this shipping notice? The hospital will be notified about the shipment.');
    }
</script>

</body>
</html>