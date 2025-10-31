<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Stock Request</title>
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
            background: #f3f4f6;
            color: #1f2937;
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .header {
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
            color: white;
            padding: 30px 40px;
        }

        .header h2 {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .header p {
            font-size: 14px;
            opacity: 0.9;
        }

        .form-content {
            padding: 40px;
        }

        .form-section {
            margin-bottom: 35px;
        }

        .section-header {
            font-size: 18px;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 2px solid #e5e7eb;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #374151;
            font-size: 14px;
        }

        label .required {
            color: #ef4444;
        }

        .input-wrapper {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 18px;
            color: #9ca3af;
            pointer-events: none;
        }

        input[type="text"],
        input[type="number"],
        input[type="date"],
        select,
        textarea {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.3s ease;
            background: #f9fafb;
        }

        .input-wrapper input,
        .input-wrapper select {
            padding-left: 48px;
        }

        input:focus,
        select:focus,
        textarea:focus {
            outline: none;
            border-color: #f59e0b;
            background: white;
            box-shadow: 0 0 0 4px rgba(245, 158, 11, 0.1);
        }

        textarea {
            resize: vertical;
            min-height: 100px;
        }

        .medicine-item {
            background: #fef3c7;
            border: 2px solid #fbbf24;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }

        .medicine-item:hover {
            border-color: #f59e0b;
            box-shadow: 0 4px 12px rgba(245, 158, 11, 0.2);
        }

        .medicine-item-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 2px solid #fbbf24;
        }

        .medicine-item-title {
            font-weight: 700;
            color: #92400e;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn-remove-medicine {
            background: #fee2e2;
            color: #991b1b;
            padding: 8px 16px;
            border: 1px solid #fca5a5;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .btn-remove-medicine:hover {
            background: #fecaca;
            transform: translateY(-2px);
        }

        .form-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
        }

        .form-row.two {
            grid-template-columns: repeat(2, 1fr);
        }

        .btn-add-medicine {
            background: #f59e0b;
            color: white;
            padding: 14px 20px;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-add-medicine:hover {
            background: #d97706;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(245, 158, 11, 0.3);
        }

        .button-group {
            display: flex;
            gap: 16px;
            margin-top: 40px;
            padding-top: 30px;
            border-top: 2px solid #e5e7eb;
        }

        .btn-submit {
            background: #10b981;
            color: white;
            padding: 16px 24px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-submit:hover {
            background: #059669;
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(16, 185, 129, 0.3);
        }

        .btn-cancel {
            background: #e5e7eb;
            color: #374151;
            padding: 16px 24px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-cancel:hover {
            background: #d1d5db;
            transform: translateY(-2px);
        }

        .alert {
            padding: 16px;
            border-radius: 10px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 14px;
            font-weight: 500;
        }

        .alert-success {
            background: #dcfce7;
            border: 1px solid #86efac;
            color: #166534;
        }

        .alert-error {
            background: #fee2e2;
            border: 1px solid #fca5a5;
            color: #991b1b;
        }

        .total-summary {
            background: #fef3c7;
            border: 2px solid #f59e0b;
            border-radius: 10px;
            padding: 20px;
            margin-top: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .total-label {
            font-size: 18px;
            font-weight: 700;
            color: #92400e;
        }

        .total-amount {
            font-size: 24px;
            font-weight: 700;
            color: #d97706;
        }

        @media (max-width: 768px) {
            .form-content {
                padding: 20px;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .button-group {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <h2><i class="bi bi-pencil-square"></i> Edit Stock Request #${purchaseOrder.poId}</h2>
        <p>Modify purchase order details and items</p>
    </div>

    <div class="form-content">
        <c:if test="${not empty message}">
            <div class="alert alert-${messageType == 'success' ? 'success' : 'error'}">
                <i class="bi bi-${messageType == 'success' ? 'check-circle' : 'exclamation-circle'}"></i>
                ${message}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/edit-stock" method="post">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="poId" value="${purchaseOrder.poId}">

            <div class="form-section">
                <div class="section-header">
                    <i class="bi bi-building"></i> Supplier Information
                </div>
                
                <div class="form-group">
                    <label for="supplier">Select Supplier (Optional)</label>
                    <div class="input-wrapper">
                        <i class="bi bi-shop input-icon"></i>
                        <select id="supplier" name="supplierId">
                            <option value="">-- Choose a supplier --</option>
                            <c:forEach items="${suppliers}" var="supplier">
                                <option value="${supplier.supplierId}" 
                                    ${purchaseOrder.supplierId == supplier.supplierId ? 'selected' : ''}>
                                    ${supplier.name}
                                    <c:if test="${not empty supplier.performanceRating}"> - Rating: ${supplier.performanceRating}/5.0</c:if>
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            </div>

            <div class="form-section">
                <div class="section-header">
                    <i class="bi bi-capsule"></i> Medicine Items
                </div>
                
                <div id="medicineItemsContainer">
                    <c:forEach items="${items}" var="item" varStatus="status">
                        <div class="medicine-item" data-index="${status.index}">
                            <div class="medicine-item-header">
                                <div class="medicine-item-title">
                                    <i class="bi bi-capsule-pill"></i> Medicine Item #${status.index + 1}
                                </div>
                                <button type="button" class="btn-remove-medicine" 
                                    onclick="removeMedicineItem(${status.index})"
                                    style="${status.index == 0 ? 'display:none;' : ''}">
                                    <i class="bi bi-trash"></i> Remove
                                </button>
                            </div>

                            <div class="form-group">
                                <label>Select Medicine <span class="required">*</span></label>
                                <div class="input-wrapper">
                                    <i class="bi bi-search input-icon"></i>
                                    <select name="medicineCode" required>
                                        <option value="">-- Select a medicine --</option>
                                        <c:forEach items="${medicines}" var="med">
                                            <option value="${med.medicineCode}" 
                                                ${item.medicineCode == med.medicineCode ? 'selected' : ''}>
                                                ${med.name} [${med.medicineCode}]
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label>Quantity <span class="required">*</span></label>
                                    <div class="input-wrapper">
                                        <i class="bi bi-box-seam input-icon"></i>
                                        <input type="number" name="quantity" min="1" 
                                            value="${item.quantity}" required onchange="calculateTotal()">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label>Unit Price (VNĐ) <span class="required">*</span></label>
                                    <div class="input-wrapper">
                                        <i class="bi bi-currency-dollar input-icon"></i>
                                        <input type="number" name="unitPrice" min="0" step="0.01" 
                                            value="${item.unitPrice}" required onchange="calculateTotal()">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label>Priority <span class="required">*</span></label>
                                    <div class="input-wrapper">
                                        <i class="bi bi-flag input-icon"></i>
                                        <select name="priority" required>
                                            <option value="Low" ${item.priority == 'Low' ? 'selected' : ''}>Low</option>
                                            <option value="Medium" ${item.priority == 'Medium' ? 'selected' : ''}>Medium</option>
                                            <option value="High" ${item.priority == 'High' ? 'selected' : ''}>High</option>
                                            <option value="Critical" ${item.priority == 'Critical' ? 'selected' : ''}>Critical</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label>Item Notes</label>
                                    <div class="input-wrapper">
                                        <i class="bi bi-sticky input-icon"></i>
                                        <input type="text" name="itemNotes" value="${item.notes}" placeholder="Optional notes...">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <button type="button" class="btn-add-medicine" onclick="addMedicineItem()">
                    <i class="bi bi-plus-lg"></i> Add Medicine Item
                </button>

                <div class="total-summary" id="totalSummary">
                    <div class="total-label">
                        <i class="bi bi-calculator"></i> Total Amount:
                    </div>
                    <div class="total-amount" id="totalAmount">0 VNĐ</div>
                </div>
            </div>

            <div class="form-section">
                <div class="section-header">
                    <i class="bi bi-calendar-check"></i> Delivery & Notes
                </div>
                
                <div class="form-row two">
                    <div class="form-group">
                        <label for="deliveryDate">Expected Delivery Date <span class="required">*</span></label>
                        <div class="input-wrapper">
                            <i class="bi bi-calendar3 input-icon"></i>
                            <input type="date" id="deliveryDate" name="expectedDeliveryDate" 
                                value="${purchaseOrder.expectedDeliveryDate}" required>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="generalNotes">General Notes</label>
                    <textarea id="generalNotes" name="notes" 
                        placeholder="Enter any additional notes...">${purchaseOrder.notes}</textarea>
                </div>
            </div>

            <div class="button-group">
                <button type="submit" class="btn-submit">
                    <i class="bi bi-check-circle"></i> Update Stock Request
                </button>
                <a href="${pageContext.request.contextPath}/manager-dashboard" class="btn-cancel">
                    <i class="bi bi-x-circle"></i> Cancel
                </a>
            </div>
        </form>
    </div>
</div>

<script>
    var medicines = [
        <c:forEach items="${medicines}" var="m" varStatus="status">
        {
            code: '<c:out value="${m.medicineCode}"/>',
            name: '<c:out value="${m.name}"/>'
        }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    var medicineItemCount = ${items.size()};

    function addMedicineItem() {
        var container = document.getElementById('medicineItemsContainer');
        var index = medicineItemCount;
        
        var newItem = document.createElement('div');
        newItem.className = 'medicine-item';
        newItem.setAttribute('data-index', index);
        
        var medicineOptions = '<option value="">-- Select a medicine --</option>';
        for (var i = 0; i < medicines.length; i++) {
            medicineOptions += '<option value="' + medicines[i].code + '">' + 
                               medicines[i].name + ' [' + medicines[i].code + ']</option>';
        }
        
        newItem.innerHTML = '<div class="medicine-item-header">' +
                '<div class="medicine-item-title">' +
                    '<i class="bi bi-capsule-pill"></i> Medicine Item #' + (index + 1) +
                '</div>' +
                '<button type="button" class="btn-remove-medicine" onclick="removeMedicineItem(' + index + ')">' +
                    '<i class="bi bi-trash"></i> Remove' +
                '</button>' +
            '</div>' +
            '<div class="form-group">' +
                '<label>Select Medicine <span class="required">*</span></label>' +
                '<div class="input-wrapper">' +
                    '<i class="bi bi-search input-icon"></i>' +
                    '<select name="medicineCode" required>' + medicineOptions + '</select>' +
                '</div>' +
            '</div>' +
            '<div class="form-row">' +
                '<div class="form-group">' +
                    '<label>Quantity <span class="required">*</span></label>' +
                    '<div class="input-wrapper">' +
                        '<i class="bi bi-box-seam input-icon"></i>' +
                        '<input type="number" name="quantity" min="1" value="1" required onchange="calculateTotal()">' +
                    '</div>' +
                '</div>' +
                '<div class="form-group">' +
                    '<label>Unit Price (VNĐ) <span class="required">*</span></label>' +
                    '<div class="input-wrapper">' +
                        '<i class="bi bi-currency-dollar input-icon"></i>' +
                        '<input type="number" name="unitPrice" min="0" step="0.01" value="0" required onchange="calculateTotal()">' +
                    '</div>' +
                '</div>' +
                '<div class="form-group">' +
                    '<label>Priority <span class="required">*</span></label>' +
                    '<div class="input-wrapper">' +
                        '<i class="bi bi-flag input-icon"></i>' +
                        '<select name="priority" required>' +
                            '<option value="Low">Low</option>' +
                            '<option value="Medium" selected>Medium</option>' +
                            '<option value="High">High</option>' +
                            '<option value="Critical">Critical</option>' +
                        '</select>' +
                    '</div>' +
                '</div>' +
                '<div class="form-group">' +
                    '<label>Item Notes</label>' +
                    '<div class="input-wrapper">' +
                        '<i class="bi bi-sticky input-icon"></i>' +
                        '<input type="text" name="itemNotes" placeholder="Optional notes...">' +
                    '</div>' +
                '</div>' +
            '</div>';
        
        container.appendChild(newItem);
        medicineItemCount++;
        updateRemoveButtons();
        calculateTotal();
    }

    function calculateTotal() {
        var items = document.querySelectorAll('.medicine-item');
        var total = 0;

        items.forEach(function(item) {
            var quantityInput = item.querySelector('input[name="quantity"]');
            var priceInput = item.querySelector('input[name="unitPrice"]');
            
            if (quantityInput && priceInput) {
                var quantity = parseFloat(quantityInput.value) || 0;
                var price = parseFloat(priceInput.value) || 0;
                total += quantity * price;
            }
        });

        document.getElementById('totalAmount').textContent = total.toLocaleString('vi-VN') + ' VNĐ';
    }

    function removeMedicineItem(index) {
        var item = document.querySelector('.medicine-item[data-index="' + index + '"]');
        if (item) {
            item.remove();
            updateRemoveButtons();
            calculateTotal();
        }
    }

    function updateRemoveButtons() {
        var items = document.querySelectorAll('.medicine-item');
        items.forEach(function(item, idx) {
            var removeBtn = item.querySelector('.btn-remove-medicine');
            if (removeBtn) {
                removeBtn.style.display = items.length > 1 ? 'flex' : 'none';
            }
        });
    }

    document.addEventListener('DOMContentLoaded', function() {
        calculateTotal();
        updateRemoveButtons();
        
        var today = new Date().toISOString().split('T')[0];
        document.getElementById('deliveryDate').setAttribute('min', today);
    });
</script>

</body>
</html>