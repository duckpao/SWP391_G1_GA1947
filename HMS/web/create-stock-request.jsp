<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Stock Request - Hospital System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .form-card {
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        .form-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
                            <i class="fas fa-plus-circle"></i> Create New Stock Request
                        </h3>
                        <p class="mb-0 mt-2">Fill in the details to create a purchase order</p>
                    </div>
                    <div class="card-body p-4">
                        <form action="create-stock" method="post" id="stockRequestForm">
                            <!-- Supplier Selection -->
                            <div class="mb-4">
                                <label for="supplierId" class="form-label">
                                    <i class="fas fa-truck"></i> Select Supplier (Optional)
                                </label>
                                <select class="form-select form-select-lg" id="supplierId" name="supplierId">
                                    <option value="">-- Choose a supplier (or leave empty to assign later) --</option>
                                    <c:forEach items="${suppliers}" var="supplier">
                                        <option value="${supplier.supplierId}">
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
                                <div class="form-text">
                                    You can select a supplier now or assign one later during approval
                                </div>
                            </div>

                            <!-- Medicine Items -->
                            <div class="mb-4" id="medicineItems">
                                <label class="form-label">
                                    <i class="fas fa-pills"></i> Medicine Items <span class="text-danger">*</span>
                                </label>
                                <div id="itemContainer">
                                    <div class="item-row">
                                        <div class="row">
                                            <div class="col-md-4 mb-3">
                                                <label class="form-label">Medicine</label>
                                                <select class="form-select" name="medicineId" required>
                                                    <option value="">-- Select Medicine --</option>
                                                    <c:forEach items="${medicines}" var="medicine">
                                                        <option value="${medicine.medicineId}">
                                                            ${medicine.name} (${medicine.category})
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="col-md-2 mb-3">
                                                <label class="form-label">Quantity</label>
                                                <select class="form-select" name="quantity" required>
                                                    <option value="">-- Select Quantity --</option>
                                                    <option value="10">10</option>
                                                    <option value="50">50</option>
                                                    <option value="100">100</option>
                                                    <option value="500">500</option>
                                                    <option value="1000">1000</option>
                                                </select>
                                            </div>
                                            <div class="col-md-2 mb-3">
                                                <label class="form-label">Priority</label>
                                                <select class="form-select" name="priority" required>
                                                    <option value="">-- Select Priority --</option>
                                                    <option value="Low">Low</option>
                                                    <option value="Medium">Medium</option>
                                                    <option value="High">High</option>
                                                    <option value="Critical">Critical</option>
                                                </select>
                                            </div>
                                            <div class="col-md-4 mb-3">
                                                <label class="form-label">Item Notes</label>
                                                <textarea class="form-control" name="itemNotes" rows="2" placeholder="Additional notes for this item..."></textarea>
                                            </div>
                                        </div>
                                        <button type="button" class="btn btn-danger btn-sm remove-item">
                                            <i class="fas fa-trash"></i> Remove
                                        </button>
                                    </div>
                                </div>
                                <button type="button" class="btn btn-success btn-sm mt-2" id="addItem">
                                    <i class="fas fa-plus"></i> Add Another Medicine
                                </button>
                            </div>

                            <!-- General Notes -->
                            <div class="mb-4">
                                <label for="notes" class="form-label">
                                    <i class="fas fa-sticky-note"></i> General Notes
                                </label>
                                <textarea class="form-control form-control-lg" 
                                          id="notes" 
                                          name="notes" 
                                          rows="4" 
                                          placeholder="Additional notes for the entire request..."></textarea>
                                <div class="form-text">
                                    Any special requirements or comments for the entire order
                                </div>
                            </div>

                            <!-- Expected Delivery Date -->
                            <div class="mb-4">
                                <label for="expectedDeliveryDate" class="form-label">
                                    <i class="fas fa-calendar-alt"></i> Expected Delivery Date <span class="text-danger">*</span>
                                </label>
                                <input type="date" 
                                       class="form-control form-control-lg" 
                                       id="expectedDeliveryDate" 
                                       name="expectedDeliveryDate" 
                                       required>
                                <div class="form-text">
                                    When do you need these medicines delivered?
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="manager-dashboard" class="btn btn-secondary btn-lg">
                                    <i class="fas fa-times"></i> Cancel
                                </a>
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="fas fa-paper-plane"></i> Create Stock Request
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
        // Set minimum date to today
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('expectedDeliveryDate').min = today;
        const nextWeek = new Date();
        nextWeek.setDate(nextWeek.getDate() + 7);
        document.getElementById('expectedDeliveryDate').value = nextWeek.toISOString().split('T')[0];

        // Add new medicine item
        document.getElementById('addItem').addEventListener('click', function() {
            const container = document.getElementById('itemContainer');
            const newRow = document.createElement('div');
            newRow.className = 'item-row';
            newRow.innerHTML = `
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Medicine</label>
                        <select class="form-select" name="medicineId" required>
                            <option value="">-- Select Medicine --</option>
                            <c:forEach items="${medicines}" var="medicine">
                                <option value="${medicine.medicineId}">${medicine.name} (${medicine.category})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2 mb-3">
                        <label class="form-label">Quantity</label>
                        <select class="form-select" name="quantity" required>
                            <option value="">-- Select Quantity --</option>
                            <option value="10">10</option>
                            <option value="50">50</option>
                            <option value="100">100</option>
                            <option value="500">500</option>
                            <option value="1000">1000</option>
                        </select>
                    </div>
                    <div class="col-md-2 mb-3">
                        <label class="form-label">Priority</label>
                        <select class="form-select" name="priority" required>
                            <option value="">-- Select Priority --</option>
                            <option value="Low">Low</option>
                            <option value="Medium">Medium</option>
                            <option value="High">High</option>
                            <option value="Critical">Critical</option>
                        </select>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Item Notes</label>
                        <textarea class="form-control" name="itemNotes" rows="2" placeholder="Additional notes for this item..."></textarea>
                    </div>
                </div>
                <button type="button" class="btn btn-danger btn-sm remove-item">
                    <i class="fas fa-trash"></i> Remove
                </button>
            `;
            container.appendChild(newRow);
        });

        // Remove medicine item
        document.addEventListener('click', function(e) {
            if (e.target.classList.contains('remove-item')) {
                e.target.closest('.item-row').remove();
            }
        });

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

            if (!confirm('Are you sure you want to create this stock request?')) {
                e.preventDefault();
                return false;
            }
        });
    </script>
</body>
</html>