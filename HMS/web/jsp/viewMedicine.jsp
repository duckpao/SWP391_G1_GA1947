<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Medicine Details</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f5f5f5;
                padding: 20px;
            }

            .container {
                max-width: 1400px;
                margin: 0 auto;
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            h1 {
                margin-bottom: 30px;
                color: #333;
            }

            .search-container {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                border: 1px solid #ddd;
                margin-bottom: 25px;
            }

            .search-form {
                display: grid;
                grid-template-columns: 2fr 1fr 1fr auto auto;
                gap: 15px;
                align-items: end;
            }

            .form-group {
                display: flex;
                flex-direction: column;
            }

            .form-group label {
                font-weight: 600;
                margin-bottom: 5px;
                color: #555;
                font-size: 14px;
            }

            input, select, textarea {
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 5px;
                font-size: 14px;
            }

            .btn {
                padding: 10px 20px;
                border-radius: 6px;
                border: none;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s;
            }

            .btn-search {
                background: #4CAF50;
                color: #fff;
            }
            .btn-reset {
                background: #6c757d;
                color: #fff;
            }
            .btn-secondary {
                background: #2196F3;
                color: #fff;
            }
            .btn-add {
                background: #9C27B0;
                color: white;
                margin-left: auto;
            }

            .btn:hover {
                opacity: 0.9;
                transform: translateY(-2px);
            }
            .nav-links {
                display: flex;
                gap: 10px;
                margin-bottom: 20px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }

            thead {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
            }

            th, td {
                padding: 12px;
                border-bottom: 1px solid #e0e0e0;
                text-align: left;
            }

            .status-badge {
                padding: 4px 10px;
                border-radius: 20px;
                font-size: 12px;
            }

            .status-approved {
                background: #d4edda;
                color: #155724;
            }
            .empty-state {
                text-align: center;
                color: #777;
                padding: 50px;
            }
        </style>
    </head>
    <body>

        <div class="container">
            <h1>Medicine Details</h1>

            <!-- Search Form -->
            <div class="search-container">
                <form action="view-medicine" method="get" class="search-form">
                    <div class="form-group">
                        <label for="keyword">Search by Name or Description</label>
                        <input type="text" id="keyword" name="keyword"
                               placeholder="Enter medicine name or description..."
                               value="${keyword}">
                    </div>

                    <div class="form-group">
                        <label for="category">Category</label>
                        <select id="category" name="category">
                            <option value="All" ${selectedCategory == 'All' ? 'selected' : ''}>All Categories</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat}" ${selectedCategory == cat ? 'selected' : ''}>${cat}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="status">Stock Status</label>
                        <select id="status" name="status">
                            <option value="" ${selectedStatus == '' ? 'selected' : ''}>All Status</option>
                            <option value="In Stock" ${selectedStatus == 'In Stock' ? 'selected' : ''}>In Stock (&gt;50)</option>
                            <option value="Low Stock" ${selectedStatus == 'Low Stock' ? 'selected' : ''}>Low Stock (1-50)</option>
                            <option value="Out of Stock" ${selectedStatus == 'Out of Stock' ? 'selected' : ''}>Out of Stock (0)</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-search">🔍 Search</button>
                    <a href="view-medicine" class="btn btn-reset">🔄 Reset</a>
                </form>
            </div>

            <!-- Navigation Buttons -->
            <div class="nav-links">
                <a href="create-request" class="btn btn-secondary">📝 Create Medication Request</a>
                <a href="doctor-dashboard" class="btn btn-secondary">🏠 Back to Dashboard</a>
                <c:if test="${sessionScope.role eq 'pharmacist'}">
                    <button type="button" class="btn btn-add" data-bs-toggle="modal"
                            data-bs-target="#addMedicineModal">➕ Add New Medicine</button>
                </c:if>
            </div>

            <!-- Medicine Table -->
            <c:choose>
                <c:when test="${not empty medicines}">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Category</th>
                                <th>Description</th>
                                <th>Batch ID</th>
                                <th>Lot Number</th>
                                <th>Expiry Date</th>
                                <th>Current Quantity</th>
                                <th>Status</th>
                                <th>Received Date</th>
                                    <c:if test="${sessionScope.role eq 'pharmacist'}">
                                    <th>Edit</th>
                                    <th>Delete</th>
                                    </c:if>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="medicine" items="${medicines}">
                                <c:forEach var="batch" items="${medicine.batches}" varStatus="st">
                                    <tr>
                                        <c:if test="${st.first}">
                                            <td rowspan="${medicine.batches.size()}">${medicine.medicineId}</td>
                                            <td rowspan="${medicine.batches.size()}"><strong>${medicine.name}</strong></td>
                                            <td rowspan="${medicine.batches.size()}">${medicine.category}</td>
                                            <td rowspan="${medicine.batches.size()}">${medicine.description}</td>
                                        </c:if>

                                        <td>${batch.batchId}</td>
                                        <td>${batch.lotNumber}</td>
                                        <td><fmt:formatDate value="${batch.expiryDate}" pattern="dd/MM/yyyy"/></td>
                                        <td>${batch.currentQuantity}</td>
                                        <td><span class="status-badge status-approved">${batch.status}</span></td>
                                        <td><fmt:formatDate value="${batch.receivedDate}" pattern="dd/MM/yyyy"/></td>

                                        <c:if test="${sessionScope.role eq 'pharmacist'}">
                                            <td>
                                                <button type="button" class="btn btn-warning btn-sm"
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#editMedicineModal"
                                                        onclick="fillEditForm(
                                                                        '${medicine.medicineId}',
                                                                        '${medicine.name}',
                                                                        '${medicine.category}',
                                                                        '${medicine.description}',
                                                                        '${batch.batchId}',
                                                                        '${batch.lotNumber}',
                                                                        '${batch.expiryDate}',
                                                                        '${batch.currentQuantity}'
                                                                        )">
                                                    ✏️
                                                </button>

                                            </td>
                                            <td>
                                                <form action="Medicine/delete" method="post"
                                                      onsubmit="return confirm('Bạn có chắc chắn muốn xóa thuốc này?');">
                                                    <input type="hidden" name="id" value="${medicine.medicineId}">
                                                    <button type="submit" class="btn btn-danger btn-sm">🗑</button>
                                                </form>
                                            </td>
                                        </c:if>
                                    </tr>
                                </c:forEach>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <h3>No medicines found</h3>
                        <p>Try adjusting your search criteria or reset the filters.</p>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- Modal Add Medicine -->
            <div class="modal fade" id="addMedicineModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">➕ Add New Medicine</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <form method="post" action="${pageContext.request.contextPath}/Medicine/add">
                                <div class="mb-3">
                                    <label class="form-label">Medicine Name</label>
                                    <input type="text" class="form-control" name="name" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Category</label>
                                    <input type="text" class="form-control" name="category" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Description</label>
                                    <textarea class="form-control" name="description"></textarea>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Supplier ID</label>
                                    <input type="number" class="form-control" name="supplierId" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Lot Number</label>
                                    <input type="text" class="form-control" name="lotNumber" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Expiry Date</label>
                                    <input type="date" class="form-control" name="expiryDate"
                                           required min="<%= java.time.LocalDate.now() %>">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Quantity</label>
                                    <input type="number" class="form-control" name="quantity" required>
                                </div>
                                <div class="modal-footer">
                                    <button type="submit" class="btn btn-success">Save</button>
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

         <!-- Modal Edit Medicine -->
<div class="modal fade" id="editMedicineModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">✏ Edit Medicine</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form method="post" action="${pageContext.request.contextPath}/Medicine/update">
                    <input type="hidden" name="id" id="edit-id">
                    <input type="hidden" name="batchId" id="edit-batchId">
                    <input type="hidden" name="supplierId" id="edit-supplierId"> <!-- Thêm dòng này -->

                    <div class="mb-3">
                        <label class="form-label">Medicine Name</label>
                        <input type="text" class="form-control" name="name" id="edit-name" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Category</label>
                        <input type="text" class="form-control" name="category" id="edit-category" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <textarea class="form-control" name="description" id="edit-description"></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Batch ID</label>
                        <input type="text" class="form-control" name="batchId" id="edit-batchId" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Lot Number</label>
                        <input type="text" class="form-control" name="lotNumber" id="edit-lotNumber" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Expiry Date</label>
                        <input type="date" class="form-control" name="expiryDate" id="edit-expiryDate" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Quantity</label>
                        <input type="number" class="form-control" name="quantity" id="edit-quantity" required>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-success">Update</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>


        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
function fillEditForm(id, name, category, description, batchId, lotNumber, expiryDate, quantity, supplierId) {
    document.getElementById('edit-id').value = id;
    document.getElementById('edit-name').value = name;
    document.getElementById('edit-category').value = category;
    document.getElementById('edit-description').value = description;
    document.getElementById('edit-batchId').value = batchId;
    document.getElementById('edit-lotNumber').value = lotNumber;
    document.getElementById('edit-expiryDate').value = expiryDate;
    document.getElementById('edit-quantity').value = quantity;
    document.getElementById('edit-supplierId').value = supplierId; // Thêm dòng này
}
</script>


    </body>
</html>
