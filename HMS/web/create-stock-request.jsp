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
            <div class="col-lg-8">
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

                            <!-- Supplier Details Display -->
                            <div id="supplierDetails" class="alert alert-info d-none mb-4">
                                <h6><i class="fas fa-info-circle"></i> Supplier Information</h6>
                                <div id="supplierInfo"></div>
                            </div>

                            <!-- Medicine Details -->
                            <div class="mb-4">
                                <label for="notes" class="form-label">
                                    <i class="fas fa-pills"></i> Medicine Details & Notes <span class="text-danger">*</span>
                                </label>
                                <textarea class="form-control form-control-lg" 
                                          id="notes" 
                                          name="notes" 
                                          rows="8" 
                                          placeholder="Enter medicine details, quantities, and any special requirements..."
                                          required></textarea>
                                <div class="form-text">
                                    Provide detailed information about medicines needed
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

                            <!-- Sample Format Helper -->
                            <div class="card bg-light mb-4">
                                <div class="card-body">
                                    <h6 class="card-title">
                                        <i class="fas fa-lightbulb"></i> Sample Format for Medicine Details:
                                    </h6>
                                    <pre class="mb-0" style="font-size: 12px;">Medicine: Paracetamol 500mg
Quantity: 1000 tablets
Priority: High

Medicine: Amoxicillin 250mg
Quantity: 500 capsules
Priority: Medium

Medicine: Ibuprofen 400mg
Quantity: 750 tablets
Priority: Low

Additional Notes:
- Urgent need for Paracetamol due to low stock alert
- Prefer batch expiry date minimum 2 years from delivery
- Require proper documentation and certificates</pre>
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

                <!-- Help Card -->
                <div class="card mt-4">
                    <div class="card-body">
                        <h6><i class="fas fa-question-circle"></i> Need Help?</h6>
                        <ul class="mb-0">
                            <li>Be specific about medicine names, dosages, and quantities</li>
                            <li>Set realistic delivery expectations</li>
                            <li>Mark urgent requests clearly with priority levels</li>
                            <li>Include any special requirements or certifications needed</li>
                            <li>Note: Supplier will be assigned during approval process</li>
                        </ul>
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
        
        // Set default to 7 days from now
        const nextWeek = new Date();
        nextWeek.setDate(nextWeek.getDate() + 7);
        document.getElementById('expectedDeliveryDate').value = nextWeek.toISOString().split('T')[0];

        // Form validation
        document.getElementById('stockRequestForm').addEventListener('submit', function(e) {
            const medicineDetails = document.getElementById('medicineDetails').value.trim();
            const deliveryDate = document.getElementById('expectedDeliveryDate').value;

            if (!medicineDetails) {
                e.preventDefault();
                alert('Please enter medicine details');
                return false;
            }

            if (medicineDetails.length < 20) {
                e.preventDefault();
                alert('Please provide more detailed information about the medicines needed');
                return false;
            }

            if (!deliveryDate) {
                e.preventDefault();
                alert('Please select an expected delivery date');
                return false;
            }

            // Confirm submission
            if (!confirm('Are you sure you want to create this stock request?\n\nNote: This request will be sent for approval.')) {
                e.preventDefault();
                return false;
            }
        });
    </script>
</body>
</html>