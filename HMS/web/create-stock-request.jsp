<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Stock Request</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
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
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .container {
            width: 100%;
            max-width: 800px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            animation: slideUp 0.5s ease;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Updated header to white theme with border */
        .header {
            background: white;
            color: #1f2937;
            padding: 40px 30px;
            text-align: center;
            border-bottom: 2px solid #e5e7eb;
        }

        .header-icon {
            width: 80px;
            height: 80px;
            background: #f3f4f6;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 40px;
        }

        .header h2 {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .header p {
            font-size: 14px;
            color: #6b7280;
        }

        /* Improved form content styling */
        .form-content {
            padding: 40px 30px;
            max-height: 70vh;
            overflow-y: auto;
        }

        .form-section {
            margin-bottom: 30px;
        }

        .form-section h3 {
            color: #374151;
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e5e7eb;
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

        /* Added input wrapper for icons */
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
            padding: 14px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-size: 15px;
            font-family: inherit;
            transition: all 0.3s ease;
            background: #f9fafb;
        }

        .input-wrapper input[type="text"],
        .input-wrapper input[type="number"],
        .input-wrapper input[type="date"],
        .input-wrapper select {
            padding-left: 48px;
        }

        input[type="text"]:focus,
        input[type="number"]:focus,
        input[type="date"]:focus,
        select:focus,
        textarea:focus {
            outline: none;
            border-color: #3b82f6;
            background: white;
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
        }

        textarea {
            resize: vertical;
            min-height: 80px;
            padding: 14px 16px;
        }

        /* Improved medicine item styling */
        .medicine-item {
            background: #f9fafb;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
            transition: all 0.3s ease;
        }

        .medicine-item:hover {
            border-color: #d1d5db;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }

        .medicine-item-header {
            font-weight: 600;
            color: #374151;
            margin-bottom: 15px;
            font-size: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .medicine-item-header::before {
            content: "💊";
            font-size: 18px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        .form-row.full {
            grid-template-columns: 1fr;
        }

        .form-row.three {
            grid-template-columns: 1fr 1fr 1fr;
        }

        /* Improved button group styling */
        .button-group {
            display: flex;
            gap: 12px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #e5e7eb;
        }

        button,
        .btn-cancel {
            padding: 14px 24px;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            flex: 1;
        }

        button[type="submit"] {
            background: #3b82f6;
            color: white;
        }

        button[type="submit"]:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(59, 130, 246, 0.3);
        }

        button[type="submit"]:active {
            transform: translateY(0);
        }

        .btn-cancel {
            background: #e5e7eb;
            color: #374151;
        }

        .btn-cancel:hover {
            background: #d1d5db;
            transform: translateY(-2px);
        }

        /* Added alert styling */
        .alert {
            padding: 14px 16px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: slideUp 0.3s ease;
        }

        .alert-danger {
            background: #fee2e2;
            border: 1px solid #fca5a5;
            color: #991b1b;
        }

        .alert-success {
            background: #d1fae5;
            border: 1px solid #6ee7b7;
            color: #065f46;
        }

        /* Added footer styling */
        .footer {
            padding: 24px 30px;
            background: #f9fafb;
            border-top: 1px solid #e5e7eb;
            text-align: center;
            font-size: 13px;
            color: #6b7280;
        }

        .btn-add-medicine {
            background: #3b82f6;
            color: white;
            padding: 10px 16px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 15px;
            width: 100%;
        }

        .btn-add-medicine:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(59, 130, 246, 0.3);
        }

        .btn-remove-medicine {
            background: #fee2e2;
            color: #991b1b;
            padding: 8px 12px;
            border: 1px solid #fca5a5;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
        }

        .btn-remove-medicine:hover {
            background: #fecaca;
            transform: translateY(-1px);
        }

        .medicine-item-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #e5e7eb;
        }

        @media (max-width: 768px) {
            .form-row,
            .form-row.three {
                grid-template-columns: 1fr;
            }

            .button-group {
                flex-direction: column;
            }

            button,
            .btn-cancel {
                width: 100%;
            }

            .header {
                padding: 30px 20px;
            }

            .header h2 {
                font-size: 24px;
            }

            .form-content {
                padding: 30px 20px;
            }

            .container {
                max-width: 100%;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <!-- Updated header with icon -->
    <div class="header">
        <div class="header-icon">📦</div>
        <h2>Create Stock Request</h2>
        <p>Manage your medicine inventory</p>
    </div>

    <div class="form-content">
        <!-- Added alert messages -->
        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger">
            <span>⚠️</span>
            <span>${error}</span>
        </div>
        <% } %>

        <% if (request.getAttribute("message") != null) { %>
        <div class="alert alert-success">
            <span>✅</span>
            <span>${message}</span>
        </div>
        <% } %>

        <form action="create-stock" method="post">

            <!-- Supplier Section -->
            <div class="form-section">
                <div class="form-group">
                    <label for="supplier">Supplier</label>
                    <div class="input-wrapper">
                        <span class="input-icon">🏢</span>
                        <select id="supplier" name="supplierId">
                            <option value="">-- Choose a supplier (optional) --</option>
                            <c:forEach items="${suppliers}" var="supplier">
                                <option value="${supplier.supplierId}">
                                    ${supplier.name}
                                    <c:if test="${not empty supplier.contactPhone}"> - ${supplier.contactPhone}</c:if>
                                    <c:if test="${not empty supplier.performanceRating}">(Rating: ${supplier.performanceRating}/5.0)</c:if>
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Medicine Items Section -->
            <div class="form-section">
                <h3>Medicine Items</h3>
                <div id="medicineItemsContainer">
                    <div class="medicine-item" data-item-index="0">
                        <div class="medicine-item-header">Medicine 1</div>
                        
                        <div class="form-group">
                            <label for="medicine_0">Select Medicine</label>
                            <div class="input-wrapper">
                                <span class="input-icon">💊</span>
                                <select id="medicine_0" name="medicineCode_0" required>
                                    <option value="">-- Select Medicine --</option>
                                    <c:forEach items="${medicines}" var="m">
                                        <option value="${m.medicineCode}">${m.name} [${m.medicineCode}]</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="form-row three">
                            <div class="form-group">
                                <label for="quantity_0">Quantity</label>
                                <div class="input-wrapper">
                                    <span class="input-icon">📊</span>
                                    <input type="number" id="quantity_0" name="quantity_0" min="1" value="1" required>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="priority_0">Priority</label>
                                <div class="input-wrapper">
                                    <span class="input-icon">⚡</span>
                                    <select id="priority_0" name="priority_0" required>
                                        <option value="Low">Low</option>
                                        <option value="Medium" selected>Medium</option>
                                        <option value="High">High</option>
                                        <option value="Critical">Critical</option>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="notes_0">Notes</label>
                                <div class="input-wrapper">
                                    <span class="input-icon">📝</span>
                                    <input type="text" id="notes_0" name="itemNotes_0" placeholder="Item notes...">
                                </div>
                            </div>
                        </div>

                        <div class="medicine-item-actions">
                            <button type="button" class="btn-remove-medicine" onclick="removeMedicineItem(this)" style="display: none;">❌ Remove</button>
                        </div>
                    </div>
                </div>

                <button type="button" class="btn-add-medicine" onclick="addMedicineItem()">+ Add More Medicine</button>
            </div>

            <!-- Expected Delivery Date Section -->
            <div class="form-section">
                <div class="form-group">
                    <label for="deliveryDate">Expected Delivery Date</label>
                    <div class="input-wrapper">
                        <span class="input-icon">📅</span>
                        <input type="date" id="deliveryDate" name="expectedDeliveryDate" required>
                    </div>
                </div>
            </div>

            <!-- General Notes Section -->
            <div class="form-section">
                <div class="form-group">
                    <label for="generalNotes">General Notes</label>
                    <textarea id="generalNotes" name="notes" placeholder="Additional notes..."></textarea>
                </div>
            </div>

            <!-- Buttons -->
            <div class="button-group">
                <button type="submit">🚀 Create Stock Request</button>
                <a href="manager-dashboard" class="btn-cancel">Cancel</a>
            </div>

        </form>
    </div>

    <!-- Added footer -->
    <div class="footer">
        <p>© 2025 Pharmacy Warehouse Management System. All rights reserved.</p>
    </div>
</div>

<script>
    let medicineItemCount = 1;

    function addMedicineItem() {
        const container = document.getElementById('medicineItemsContainer');
        const newIndex = medicineItemCount;
        
        const newItem = document.createElement('div');
        newItem.className = 'medicine-item';
        newItem.setAttribute('data-item-index', newIndex);
        newItem.innerHTML = `
            <div class="medicine-item-header">Medicine ${newIndex + 1}</div>
            
            <div class="form-group">
                <label for="medicine_${newIndex}">Select Medicine</label>
                <div class="input-wrapper">
                    <span class="input-icon">💊</span>
                    <select id="medicine_${newIndex}" name="medicineCode_${newIndex}" required>
                        <option value="">-- Select Medicine --</option>
                        <c:forEach items="${medicines}" var="m">
                            <option value="${m.medicineCode}">${m.name} [${m.medicineCode}]</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="form-row three">
                <div class="form-group">
                    <label for="quantity_${newIndex}">Quantity</label>
                    <div class="input-wrapper">
                        <span class="input-icon">📊</span>
                        <input type="number" id="quantity_${newIndex}" name="quantity_${newIndex}" min="1" value="1" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="priority_${newIndex}">Priority</label>
                    <div class="input-wrapper">
                        <span class="input-icon">⚡</span>
                        <select id="priority_${newIndex}" name="priority_${newIndex}" required>
                            <option value="Low">Low</option>
                            <option value="Medium" selected>Medium</option>
                            <option value="High">High</option>
                            <option value="Critical">Critical</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label for="notes_${newIndex}">Notes</label>
                    <div class="input-wrapper">
                        <span class="input-icon">📝</span>
                        <input type="text" id="notes_${newIndex}" name="itemNotes_${newIndex}" placeholder="Item notes...">
                    </div>
                </div>
            </div>

            <div class="medicine-item-actions">
                <button type="button" class="btn-remove-medicine" onclick="removeMedicineItem(this)">❌ Remove</button>
            </div>
        `;
        
        container.appendChild(newItem);
        medicineItemCount++;
        
        // Show remove buttons if more than 1 item
        updateRemoveButtons();
    }

    function removeMedicineItem(button) {
        const item = button.closest('.medicine-item');
        item.remove();
        updateRemoveButtons();
    }

    function updateRemoveButtons() {
        const items = document.querySelectorAll('.medicine-item');
        const removeButtons = document.querySelectorAll('.btn-remove-medicine');
        
        // Show remove button only if there's more than 1 item
        removeButtons.forEach((btn, index) => {
            btn.style.display = items.length > 1 ? 'block' : 'none';
        });
    }

    // Initialize on page load
    document.addEventListener('DOMContentLoaded', function() {
        updateRemoveButtons();
    });
</script>

</body>
</html>
