
page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Stock Request</title>
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
            background: white;
            color: #1f2937;
            padding: 30px 40px;
            border-bottom: 2px solid #e5e7eb;
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
            color: #6b7280;
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
            border-color: #3b82f6;
            background: white;
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
        }

        textarea {
            resize: vertical;
            min-height: 100px;
        }

        /* Medicine Item Card */
        .medicine-item {
            background: #f9fafb;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }

        .medicine-item:hover {
            border-color: #3b82f6;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.1);
        }

        .medicine-item-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 2px solid #e5e7eb;
        }

        .medicine-item-title {
            font-weight: 700;
            color: #1f2937;
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

        /* Medicine Details Display */
        .medicine-details {
            background: white;
            border: 2px solid #dbeafe;
            border-radius: 10px;
            padding: 16px;
            margin-top: 12px;
            display: none;
        }

        .medicine-details.show {
            display: block;
            animation: slideDown 0.3s ease;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .medicine-info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 12px;
            margin-top: 12px;
        }

        .medicine-info-item {
            display: flex;
            align-items: flex-start;
            gap: 8px;
            font-size: 13px;
        }

        .medicine-info-label {
            font-weight: 600;
            color: #6b7280;
            min-width: 100px;
        }

        .medicine-info-value {
            color: #1f2937;
            flex: 1;
        }

        .medicine-badge {
            display: inline-block;
            padding: 4px 10px;
            background: #dbeafe;
            color: #1e40af;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
        }

        .form-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
        }

        .form-row.two {
            grid-template-columns: repeat(2, 1fr);
        }

        /* Total Summary Box */
        .total-summary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            padding: 24px;
            margin-top: 24px;
            display: none;
            animation: fadeIn 0.3s ease;
        }

        .total-summary.show {
            display: block;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .total-label {
            color: rgba(255, 255, 255, 0.9);
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .total-amount {
            color: white;
            font-size: 32px;
            font-weight: 700;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .btn-add-medicine {
            background: #3b82f6;
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
            background: #2563eb;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(59, 130, 246, 0.3);
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

        @media (max-width: 768px) {
            .form-content {
                padding: 20px;
            }

            .form-row,
            .medicine-info-grid {
                grid-template-columns: 1fr;
            }

            .button-group {
                flex-direction: column;
            }

            .total-amount {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2><i class="bi bi-plus-circle"></i> Create Stock Request</h2>
            <p>Create a new purchase order for medicine inventory</p>
        </div>

        <div class="form-content">
            <c:if test="${not empty message}">
                <div class="alert alert-${messageType == 'success' ? 'success' : 'error'}">
                    <i class="bi bi-${messageType == 'success' ? 'check-circle' : 'exclamation-circle'}"></i>
                    ${message}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/create-stock" method="post" id="createStockForm">
                <!-- Supplier Section -->
                <div class="form-section">
                    <div class="section-header">
                        <i class="bi bi-building"></i>
                        Supplier Information
                    </div>

                    <div class="form-group">
                        <label for="supplier">Select Supplier (Optional)</label>
                        <div class="input-wrapper">
                            <i class="bi bi-shop input-icon"></i>
                            <select id="supplier" name="supplierId">
                                <option value="">-- Choose a supplier --</option>
                                <c:forEach items="${suppliers}" var="supplier">
                                    <option value="${supplier.supplierId}">
                                        ${supplier.name}
                                        <c:if test="${not empty supplier.performanceRating}">
                                            - Rating: ${supplier.performanceRating}/5.0</c:if>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                </div>

                <!-- Medicine Items Section -->
                <div class="form-section">
                    <div class="section-header">
                        <i class="bi bi-capsule"></i>
                        Medicine Items
                    </div>

                    <div id="medicineItemsContainer">
                        <!-- Items will be added by JavaScript -->
                    </div>

                    <!-- Total Summary Box -->
                    <div id="totalSummary" class="total-summary">
                        <div class="total-label">Total Amount:</div>
                        <div class="total-amount" id="totalAmount">0 VN?</div>
                    </div>

                    <button type="button" class="btn-add-medicine" onclick="addMedicineItem()">
                        <i class="bi bi-plus-lg"></i>
                        Add Medicine Item
                    </button>
                </div>

                <!-- Delivery & Notes Section -->
                <div class="form-section">
                    <div class="section-header">
                        <i class="bi bi-calendar-check"></i>
                        Delivery & Notes
                    </div>

                    <div class="form-row two">
                        <div class="form-group">
                            <label for="deliveryDate">
                                Expected Delivery Date <span class="required">*</span>
                            </label>
                            <div class="input-wrapper">
                                <i class="bi bi-calendar3 input-icon"></i>
                                <input type="date" id="deliveryDate" name="expectedDeliveryDate" required>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="generalNotes">General Notes</label>
                        <textarea id="generalNotes" name="notes" placeholder="Enter any additional notes or special instructions..."></textarea>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="button-group">
                    <button type="submit" class="btn-submit">
                        <i class="bi bi-check-circle"></i>
                        Create Stock Request
                    </button>
                    <a href="${pageContext.request.contextPath}/manager-dashboard" class="btn-cancel">
                        <i class="bi bi-x-circle"></i>
                        Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Medicine data from server
        var medicines = [
            <c:forEach items="${medicines}" var="m" varStatus="status">
            {
                code: '<c:out value="${m.medicineCode}"/>',
                name: '<c:out value="${m.name}"/>',
                category: '<c:out value="${m.category}"/>',
                strength: '<c:out value="${m.strength}"/>',
                dosageForm: '<c:out value="${m.dosageForm}"/>',
                manufacturer: '<c:out value="${m.manufacturer}"/>',
                activeIngredient: '<c:out value="${m.activeIngredient}"/>',
                unit: '<c:out value="${m.unit}"/>',
                countryOfOrigin: '<c:out value="${m.countryOfOrigin}"/>',
                drugGroup: '<c:out value="${m.drugGroup}"/>',
                drugType: '<c:out value="${m.drugType}"/>',
                description: '<c:out value="${m.description}"/>'
            }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        var medicineItemCount = 0;

        function addMedicineItem() {
            var container = document.getElementById('medicineItemsContainer');
            var index = medicineItemCount;
            var newItem = document.createElement('div');
            newItem.className = 'medicine-item';
            newItem.setAttribute('data-index', index);

            // Build medicine options
            var medicineOptions = '<option value="">-- Select a medicine --</option>';
            for (var i = 0; i < medicines.length; i++) {
                medicineOptions += '<option value="' + medicines[i].code + '">' +
                    medicines[i].name + ' [' + medicines[i].code + ']</option>';
            }

            var itemHTML = '<div class="medicine-item-header">' +
                '<div class="medicine-item-title">' +
                '<i class="bi bi-capsule-pill"></i> Medicine Item #' + (index + 1) +
                '</div>' +
                '<button type="button" class="btn-remove-medicine" onclick="removeMedicineItem(' + index + ')" ' +
                (index === 0 ? 'style="display:none;"' : '') + '>' +
                '<i class="bi bi-trash"></i> Remove' +
                '</button>' +
                '</div>' +

                '<div class="form-group">' +
                '<label for="medicine_' + index + '">' +
                'Select Medicine <span class="required">*</span>' +
                '</label>' +
                '<div class="input-wrapper">' +
                '<i class="bi bi-search input-icon"></i>' +
                '<select id="medicine_' + index + '" name="medicineCode" required onchange="showMedicineDetails(' + index + ', this.value)">' +
                medicineOptions +
                '</select>' +
                '</div>' +
                '</div>' +

                '<div id="medicineDetails_' + index + '" class="medicine-details">' +
                '</div>' +

                '<div class="form-row">' +
                // Quantity
                '<div class="form-group">' +
                '<label for="quantity_' + index + '">' +
                'Quantity <span class="required">*</span>' +
                '</label>' +
                '<div class="input-wrapper">' +
                '<i class="bi bi-box-seam input-icon"></i>' +
                '<input type="number" id="quantity_' + index + '" name="quantity" min="1" value="1" required onchange="calculateTotal()">' +
                '</div>' +
                '</div>' +

                // Unit Price (NEW)
                '<div class="form-group">' +
                '<label for="unitPrice_' + index + '">' +
                'Unit Price (VN?) <span class="required">*</span>' +
                '</label>' +
                '<div class="input-wrapper">' +
                '<i class="bi bi-currency-dollar input-icon"></i>' +
                '<input type="number" id="unitPrice_' + index + '" name="unitPrice" min="0" step="0.01" required onchange="calculateTotal()">' +
                '</div>' +
                '</div>' +

                // Priority
                '<div class="form-group">' +
                '<label for="priority_' + index + '">' +
                'Priority <span class="required">*</span>' +
                '</label>' +
                '<div class="input-wrapper">' +
                '<i class="bi bi-flag input-icon"></i>' +
                '<select id="priority_' + index + '" name="priority" required>' +
                '<option value="Low">Low</option>' +
                '<option value="Medium" selected>Medium</option>' +
                '<option value="High">High</option>' +
                '<option value="Critical">Critical</option>' +
                '</select>' +
                '</div>' +
                '</div>' +

                // Item Notes
                '<div class="form-group">' +
                '<label for="notes_' + index + '">Item Notes</label>' +
                '<div class="input-wrapper">' +
                '<i class="bi bi-sticky input-icon"></i>' +
                '<input type="text" id="notes_' + index + '" name="itemNotes" placeholder="Optional notes...">' +
                '</div>' +
                '</div>' +
                '</div>';

            newItem.innerHTML = itemHTML;
            container.appendChild(newItem);
            medicineItemCount++;
            updateRemoveButtons();
            calculateTotal();
        }

        function calculateTotal() {
            var items = document.querySelectorAll('.medicine-item');
            var total = 0;
            var hasItems = false;

            for (var i = 0; i < items.length; i++) {
                var index = items[i].getAttribute('data-index');
                var quantityInput = document.getElementById('quantity_' + index);
                var unitPriceInput = document.getElementById('unitPrice_' + index);

                if (quantityInput && unitPriceInput) {
                    var quantity = parseFloat(quantityInput.value) || 0;
                    var unitPrice = parseFloat(unitPriceInput.value) || 0;
                    total += quantity * unitPrice;
                    
                    if (quantity > 0 && unitPrice > 0) {
                        hasItems = true;
                    }
                }
            }

            // Format number with Vietnamese currency format
            var formattedTotal = total.toLocaleString('vi-VN') + ' VN?';
            document.getElementById('totalAmount').textContent = formattedTotal;

            // Show/hide summary box
            var summaryBox = document.getElementById('totalSummary');
            if (hasItems) {
                summaryBox.classList.add('show');
            } else {
                summaryBox.classList.remove('show');
            }
        }

        function showMedicineDetails(index, medicineCode) {
            var detailsDiv = document.getElementById('medicineDetails_' + index);

            if (!medicineCode) {
                detailsDiv.classList.remove('show');
                return;
            }

            var medicine = null;
            for (var i = 0; i < medicines.length; i++) {
                if (medicines[i].code === medicineCode) {
                    medicine = medicines[i];
                    break;
                }
            }

            if (!medicine) return;

            var detailsHTML = '<div style="margin-bottom: 12px;">' +
                '<strong style="color: #1f2937; font-size: 15px;">' +
                escapeHtml(medicine.name) + '</strong> ' +
                '<span class="medicine-badge">' + escapeHtml(medicine.code) + '</span>' +
                '</div>' +
                '<div class="medicine-info-grid">';

            if (medicine.category) {
                detailsHTML += '<div class="medicine-info-item">' +
                    '<i class="bi bi-tag" style="color: #3b82f6;"></i>' +
                    '<div>' +
                    '<div class="medicine-info-label">Category:</div>' +
                    '<div class="medicine-info-value">' + escapeHtml(medicine.category) + '</div>' +
                    '</div>' +
                    '</div>';
            }

            if (medicine.strength) {
                detailsHTML += '<div class="medicine-info-item">' +
                    '<i class="bi bi-speedometer2" style="color: #10b981;"></i>' +
                    '<div>' +
                    '<div class="medicine-info-label">Strength:</div>' +
                    '<div class="medicine-info-value">' + escapeHtml(medicine.strength) + '</div>' +
                    '</div>' +
                    '</div>';
            }

            if (medicine.dosageForm) {
                detailsHTML += '<div class="medicine-info-item">' +
                    '<i class="bi bi-capsule" style="color: #8b5cf6;"></i>' +
                    '<div>' +
                    '<div class="medicine-info-label">Dosage Form:</div>' +
                    '<div class="medicine-info-value">' + escapeHtml(medicine.dosageForm) + '</div>' +
                    '</div>' +
                    '</div>';
            }

            if (medicine.manufacturer) {
                detailsHTML += '<div class="medicine-info-item">' +
                    '<i class="bi bi-building" style="color: #f59e0b;"></i>' +
                    '<div>' +
                    '<div class="medicine-info-label">Manufacturer:</div>' +
                    '<div class="medicine-info-value">' + escapeHtml(medicine.manufacturer) + '</div>' +
                    '</div>' +
                    '</div>';
            }

            if (medicine.activeIngredient) {
                detailsHTML += '<div class="medicine-info-item">' +
                    '<i class="bi bi-droplet" style="color: #06b6d4;"></i>' +
                    '<div>' +
                    '<div class="medicine-info-label">Active Ingredient:</div>' +
                    '<div class="medicine-info-value">' + escapeHtml(medicine.activeIngredient) + '</div>' +
                    '</div>' +
                    '</div>';
            }

            if (medicine.unit) {
                detailsHTML += '<div class="medicine-info-item">' +
                    '<i class="bi bi-box" style="color: #64748b;"></i>' +
                    '<div>' +
                    '<div class="medicine-info-label">Unit:</div>' +
                    '<div class="medicine-info-value">' + escapeHtml(medicine.unit) + '</div>' +
                    '</div>' +
                    '</div>';
            }

            if (medicine.countryOfOrigin) {
                detailsHTML += '<div class="medicine-info-item">' +
                    '<i class="bi bi-globe" style="color: #14b8a6;"></i>' +
                    '<div>' +
                    '<div class="medicine-info-label">Origin:</div>' +
                    '<div class="medicine-info-value">' + escapeHtml(medicine.countryOfOrigin) + '</div>' +
                    '</div>' +
                    '</div>';
            }

            if (medicine.drugType) {
                detailsHTML += '<div class="medicine-info-item">' +
                    '<i class="bi bi-shield-check" style="color: #ec4899;"></i>' +
                    '<div>' +
                    '<div class="medicine-info-label">Drug Type:</div>' +
                    '<div class="medicine-info-value">' + escapeHtml(medicine.drugType) + '</div>' +
                    '</div>' +
                    '</div>';
            }

            detailsHTML += '</div>';

            if (medicine.description) {
                detailsHTML += '<div style="margin-top: 12px; padding: 12px; background: #f0f9ff; border-left: 3px solid #3b82f6; border-radius: 6px;">' +
                    '<div style="font-size: 12px; font-weight: 600; color: #1e40af; margin-bottom: 4px;">' +
                    '<i class="bi bi-info-circle"></i> DESCRIPTION' +
                    '</div>' +
                    '<div style="font-size: 13px; color: #374151;">' +
                    escapeHtml(medicine.description) +
                    '</div>' +
                    '</div>';
            }

            detailsDiv.innerHTML = detailsHTML;
            detailsDiv.classList.add('show');
        }

        function escapeHtml(text) {
            if (!text) return '';
            var map = {
                '&': '&amp;',
                '<': '&lt;',
                '>': '&gt;',
                '"': '&quot;',
                "'": '&#039;'
            };
            return text.toString().replace(/[&<>"']/g, function(m) { return map[m]; });
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
            for (var i = 0; i < items.length; i++) {
                var removeBtn = items[i].querySelector('.btn-remove-medicine');
                if (removeBtn) {
                    removeBtn.style.display = items.length > 1 ? 'flex' : 'none';
                }
            }
        }

        // Initialize with one item
        document.addEventListener('DOMContentLoaded', function() {
            addMedicineItem();

            // Set minimum date to today
            var today = new Date().toISOString().split('T')[0];
            document.getElementById('deliveryDate').setAttribute('min', today);
        });
    </script>
</body>
</html>