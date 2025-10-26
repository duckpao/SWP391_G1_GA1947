<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Stock Request - Hospital System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .form-card {
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        .form-header {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            border-radius: 15px 15px 0 0;
            padding: 20px;
        }
        .item-row {
            border: 1px solid #dee2e6;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 8px;
            background: #f8f9fa;
        }
        .medicine-info-display {
            background: #e3f2fd;
            padding: 12px;
            border-radius: 6px;
            margin-top: 10px;
            display: none;
        }
        .medicine-info-display.show {
            display: block;
        }
        .info-label {
            font-weight: 600;
            color: #1976d2;
            font-size: 0.85rem;
            margin-bottom: 5px;
        }
        .info-value {
            color: #424242;
            font-size: 0.9rem;
            margin-bottom: 8px;
        }
        .medicine-code-badge {
            background: #1976d2;
            color: white;
            padding: 3px 8px;
            border-radius: 4px;
            font-family: monospace;
            font-size: 0.85rem;
        }
    </style>
</head>
<body class="bg-light">
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="manager-dashboard">
                <i class="fas fa-hospital"></i> Hospital Manager
            </a>
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="manager-dashboard">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </a>
                </li>
            </ul>
        </div>
    </nav>

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card form-card">
                    <div class="form-header">
                        <h3 class="mb-0">
                            <i class="fas fa-edit"></i> Edit Stock Request #${purchaseOrder.poId}
                        </h3>
                        <p class="mb-0 mt-2">Update purchase order details</p>
                    </div>
                    <div class="card-body p-4">
                        <form action="manage-stock" method="post" id="stockRequestForm">
                            <input type="hidden" name="action" value="edit">
                            <input type="hidden" name="poId" value="${purchaseOrder.poId}">
                            
                            <!-- Supplier Selection - EDITABLE -->
                            <div class="mb-4">
                                <label for="supplierId" class="form-label">
                                    <i class="fas fa-truck"></i> Select Supplier (Optional)
                                </label>
                                <select class="form-select form-select-lg" id="supplierId" name="supplierId">
                                    <option value="">-- Choose a supplier (or leave empty to assign later) --</option>
                                    <c:forEach items="${suppliers}" var="supplier">
                                        <option value="${supplier.supplierId}" 
                                                ${purchaseOrder.supplierId == supplier.supplierId ? 'selected' : ''}>
                                            ${supplier.name}
                                            <c:if test="${not empty supplier.contactPhone}">
                                                - ${supplier.contactPhone}
                                            </c:if>
                                            <c:if test="${not empty supplier.performanceRating}">
                                                (Rating: ${supplier.performanceRating}/5.0)
                                            </c:if>
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Medicine Items - FULLY EDITABLE -->
                            <div class="mb-4" id="medicineItems">
                                <label class="form-label">
                                    <i class="fas fa-pills"></i> Medicine Items <span class="text-danger">*</span>
                                </label>
                                <div id="itemContainer">
                                    <!-- Existing items will be loaded here -->
                                </div>
                                <button type="button" class="btn btn-success btn-sm mt-2" id="addItem">
                                    <i class="fas fa-plus"></i> Add Another Medicine
                                </button>
                            </div>

                            <!-- Expected Delivery Date - EDITABLE -->
                            <div class="mb-4">
                                <label for="expectedDeliveryDate" class="form-label">
                                    <i class="fas fa-calendar-alt"></i> Expected Delivery Date <span class="text-danger">*</span>
                                </label>
                                <input type="date" 
                                       class="form-control form-control-lg" 
                                       id="expectedDeliveryDate" 
                                       name="expectedDeliveryDate" 
                                       value="${purchaseOrder.expectedDeliveryDate}"
                                       required>
                            </div>

                            <!-- General Notes - EDITABLE -->
                            <div class="mb-4">
                                <label for="notes" class="form-label">
                                    <i class="fas fa-sticky-note"></i> General Notes
                                </label>
                                <textarea class="form-control form-control-lg" 
                                          id="notes" 
                                          name="notes" 
                                          rows="4" 
                                          placeholder="Additional notes for the entire request...">${purchaseOrder.notes}</textarea>
                            </div>

                            <!-- Action Buttons -->
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="manager-dashboard" class="btn btn-secondary btn-lg">
                                    <i class="fas fa-times"></i> Cancel
                                </a>
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="fas fa-save"></i> Update Stock Request
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Medicines data từ server
        const medicinesData = [
            <c:forEach items="${medicines}" var="medicine" varStatus="status">
            {
                code: '${medicine.medicineCode}',
                name: '${medicine.name}',
                category: '${medicine.category}',
                strength: '${medicine.strength}',
                dosageForm: '${medicine.dosageForm}',
                manufacturer: '${medicine.manufacturer}',
                activeIngredient: '${medicine.activeIngredient}',
                unit: '${medicine.unit}',
                description: '${medicine.description}'
            }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        // Existing items data
        const existingItems = [
            <c:forEach items="${items}" var="item" varStatus="status">
            {
                medicineCode: '${item.medicineCode}',
                quantity: ${item.quantity},
                priority: '${item.priority}',
                notes: '${item.notes}'
            }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        let itemCounter = 0;

        // Set minimum date to today
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('expectedDeliveryDate').min = today;

        // Function to create medicine options HTML
        function createMedicineOptions(selectedCode = '') {
            let html = '<option value="">-- Select Medicine --</option>';
            medicinesData.forEach(med => {
                let display = med.name;
                if (med.strength) display += ' ' + med.strength;
                if (med.dosageForm) display += ' - ' + med.dosageForm;
                display += ' [' + med.code + ']';
                const selected = (med.code === selectedCode) ? 'selected' : '';
                html += `<option value="${med.code}" ${selected}>${display}</option>`;
            });
            return html;
        }

        // Function to display medicine info
        function displayMedicineInfo(selectElement) {
            const selectedCode = selectElement.value;
            const infoDiv = selectElement.closest('.item-row').querySelector('.medicine-info-display');
            
            if (!selectedCode) {
                infoDiv.classList.remove('show');
                return;
            }

            const medicine = medicinesData.find(m => m.code === selectedCode);
            if (!medicine) {
                infoDiv.classList.remove('show');
                return;
            }

            let infoHtml = `
                <div class="row">
                    <div class="col-md-6">
                        <div class="info-label">
                            <i class="fas fa-barcode"></i> Medicine Code
                        </div>
                        <div class="info-value">
                            <span class="medicine-code-badge">${medicine.code}</span>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="info-label">
                            <i class="fas fa-tag"></i> Category
                        </div>
                        <div class="info-value">${medicine.category || 'N/A'}</div>
                    </div>
                </div>
                <div class="row mt-2">
                    <div class="col-md-6">
                        <div class="info-label">
                            <i class="fas fa-weight"></i> Strength
                        </div>
                        <div class="info-value">${medicine.strength || 'N/A'}</div>
                    </div>
                    <div class="col-md-6">
                        <div class="info-label">
                            <i class="fas fa-pills"></i> Dosage Form
                        </div>
                        <div class="info-value">${medicine.dosageForm || 'N/A'}</div>
                    </div>
                </div>
                <div class="row mt-2">
                    <div class="col-md-6">
                        <div class="info-label">
                            <i class="fas fa-industry"></i> Manufacturer
                        </div>
                        <div class="info-value">${medicine.manufacturer || 'N/A'}</div>
                    </div>
                    <div class="col-md-6">
                        <div class="info-label">
                            <i class="fas fa-flask"></i> Active Ingredient
                        </div>
                        <div class="info-value">${medicine.activeIngredient || 'N/A'}</div>
                    </div>
                </div>
            `;

            if (medicine.description) {
                infoHtml += `
                    <div class="row mt-2">
                        <div class="col-12">
                            <div class="info-label">
                                <i class="fas fa-info-circle"></i> Description
                            </div>
                            <div class="info-value">${medicine.description}</div>
                        </div>
                    </div>
                `;
            }

            infoDiv.innerHTML = infoHtml;
            infoDiv.classList.add('show');
        }

        // Function to create new item row
// Function to create new item row
function createItemRow(itemData = null) {
    itemCounter++;
    const newRow = document.createElement('div');
    newRow.className = 'item-row';
    newRow.setAttribute('data-item-id', itemCounter);
    
    const medicineCode = itemData ? itemData.medicineCode : '';
    const quantity = itemData ? itemData.quantity : 100;
    const priority = itemData ? itemData.priority : 'Medium';
    const notes = itemData ? itemData.notes : '';

    newRow.innerHTML = `
        <div class="row">
            <div class="col-md-5 mb-3">
                <label class="form-label">Medicine <span class="text-danger">*</span></label>
                <select class="form-select medicine-select" name="medicineCode" required onchange="displayMedicineInfo(this)">
                    ${createMedicineOptions(medicineCode)}
                </select>
                <div class="medicine-info-display"></div>
            </div>
            <div class="col-md-2 mb-3">
                <label class="form-label">Quantity <span class="text-danger">*</span></label>
                <input type="number" class="form-control" name="quantity" 
                       min="1" value="${quantity}" required>
            </div>
            <div class="col-md-2 mb-3">
                <label class="form-label">Priority <span class="text-danger">*</span></label>
                <select class="form-select" name="priority" required>
                    <option value="Low">Low</option>
                    <option value="Medium">Medium</option>
                    <option value="High">High</option>
                    <option value="Critical">Critical</option>
                </select>
            </div>
            <div class="col-md-3 mb-3">
                <label class="form-label">Item Notes</label>
                <textarea class="form-control" name="itemNotes" rows="2" 
                          placeholder="Additional notes...">${notes}</textarea>
            </div>
        </div>
        <button type="button" class="btn btn-danger btn-sm remove-item" onclick="removeItem(this)">
            Remove
        </button>
    `;

    // === SET SELECTED PRIORITY SAU KHI CHÈN HTML ===
    const prioritySelect = newRow.querySelector('select[name="priority"]');
    if (priority && prioritySelect) {
        prioritySelect.value = priority; // JS tự động chọn đúng option
    }

    // Auto-display medicine info
    if (medicineCode) {
        setTimeout(() => {
            const select = newRow.querySelector('.medicine-select');
            if (select) displayMedicineInfo(select);
        }, 100);
    }
    
    return newRow;
}

        // Add new medicine item
        document.getElementById('addItem').addEventListener('click', function() {
            const container = document.getElementById('itemContainer');
            container.appendChild(createItemRow());
            updateRemoveButtons();
        });

        // Remove medicine item
        function removeItem(button) {
            button.closest('.item-row').remove();
            updateRemoveButtons();
        }

        // Update remove buttons visibility
        function updateRemoveButtons() {
            const items = document.querySelectorAll('.item-row');
            items.forEach((item, index) => {
                const removeBtn = item.querySelector('.remove-item');
                if (removeBtn) {
                    removeBtn.style.display = items.length > 1 ? 'inline-block' : 'none';
                }
            });
        }

        // Form validation
        document.getElementById('stockRequestForm').addEventListener('submit', function(e) {
            const items = document.querySelectorAll('.item-row');
            if (items.length === 0) {
                e.preventDefault();
                alert('Please add at least one medicine item');
                return false;
            }

            const deliveryDate = document.getElementById('expectedDeliveryDate').value;
            if (!deliveryDate) {
                e.preventDefault();
                alert('Please select an expected delivery date');
                return false;
            }

            if (!confirm('Are you sure you want to update this stock request?')) {
                e.preventDefault();
                return false;
            }
        });

        // Initialize with existing items
        const container = document.getElementById('itemContainer');
        if (existingItems.length > 0) {
            existingItems.forEach(item => {
                container.appendChild(createItemRow(item));
            });
        } else {
            // If no items, add one empty row
            container.appendChild(createItemRow());
        }
        updateRemoveButtons();
    </script>
</body>
</html>