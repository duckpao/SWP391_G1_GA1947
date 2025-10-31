<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assign Auditor Tasks - Hospital System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .dashboard-card {
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .status-badge {
            padding: 4px 12px;
            border-radius: 4px;
            font-size: 0.85rem;
            font-weight: 500;
        }
        .status-pending { background-color: #6c757d; color: white; }
        .status-in-progress { background-color: #0dcaf0; color: white; }
        .status-completed { background-color: #28a745; color: white; }
        .status-cancelled { background-color: #dc3545; color: white; }
        .btn-action { margin: 2px; }
        .info-row {
            padding: 8px 0;
            border-bottom: 1px solid #e9ecef;
        }
        .info-row:last-child { border-bottom: none; }
        .info-label {
            font-weight: 600;
            color: #495057;
            display: inline-block;
            width: 180px;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <!-- Message Alert -->
        <c:if test="${not empty message}">
            <div class="alert alert-${messageType == 'success' ? 'success' : 'danger'} alert-dismissible fade show">
                <i class="fas fa-${messageType == 'success' ? 'check-circle' : 'exclamation-circle'}"></i>
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="fas fa-tasks"></i> Assign Auditor Tasks</h2>
            <a href="${pageContext.request.contextPath}/manager-dashboard" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
        </div>
        
        <!-- Task Assignment Form -->
        <div class="card dashboard-card">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0"><i class="fas fa-plus"></i> New Task Assignment</h5>
            </div>
            <div class="card-body">
                <form method="post">
                    <div class="row g-3">
                        <div class="col-md-12">
                            <label class="form-label fw-bold">
                                <i class="fas fa-file-invoice"></i> Purchase Order *
                            </label>
                            <select class="form-select" name="poId" required id="poSelect">
                                <option value="">-- Select Purchase Order --</option>
                                <c:forEach items="${pendingOrders}" var="po">
                                    <option value="${po.poId}" 
                                            data-supplier="${po.supplierName}" 
                                            data-date="${po.orderDate}"
                                            data-delivery="${po.expectedDeliveryDate}"
                                            data-status="${po.status}"
                                            data-notes="${po.notes}">
                                        PO #${po.poId} - ${po.supplierName} | 
                                        Order: ${po.orderDate} | 
                                        Delivery: ${po.expectedDeliveryDate} | 
                                        Status: ${po.status}
                                        <c:if test="${not empty po.notes}"> | Notes: ${po.notes}</c:if>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <!-- Selected PO Details -->
                    <div id="poDetails" class="alert alert-info mt-3" style="display: none;">
                        <h6><i class="fas fa-info-circle"></i> Selected PO Details:</h6>
                        <div class="row">
                            <div class="col-md-3">
                                <strong>Supplier:</strong>
                                <p id="poSupplier">-</p>
                            </div>
                            <div class="col-md-3">
                                <strong>Order Date:</strong>
                                <p id="poDate">-</p>
                            </div>
                            <div class="col-md-3">
                                <strong>Expected Delivery:</strong>
                                <p id="poDelivery">-</p>
                            </div>
                            <div class="col-md-3">
                                <strong>Status:</strong>
                                <p id="poStatus">-</p>
                            </div>
                        </div>
                        <div class="row mt-2" id="poNotesRow" style="display: none;">
                            <div class="col-md-12">
                                <strong>Notes:</strong>
                                <p id="poNotes" class="text-muted">-</p>
                            </div>
                        </div>
                    </div>

                    <div class="row g-3 mt-2">
                        <div class="col-md-4">
                            <label class="form-label fw-bold">
                                <i class="fas fa-user-shield"></i> Auditor *
                            </label>
                            <select class="form-select" name="auditorId" required>
                                <option value="">-- Select Auditor --</option>
                                <c:forEach items="${auditors}" var="a">
                                    <option value="${a.userId}">
                                        ${a.username} - ${a.email}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold">
                                <i class="fas fa-clipboard-list"></i> Task Type *
                            </label>
                            <select class="form-select" name="taskType" required>
                                <option value="">-- Select Type --</option>
                                <option value="stock_in">📦 Stock In Verification</option>
                                <option value="stock_out">📤 Stock Out Verification</option>
                                <option value="counting">🔢 Inventory Counting</option>
                                <option value="quality_check">✅ Quality Check</option>
                                <option value="expiry_audit">⏰ Expiry Date Audit</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold">
                                <i class="fas fa-calendar-alt"></i> Deadline *
                            </label>
                            <input type="date" class="form-control" name="deadline" required 
                                   min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                        </div>
                    </div>

                    <div class="mt-4">
                        <button type="submit" class="btn btn-primary btn-lg">
                            <i class="fas fa-save"></i> Assign Task
                        </button>
                        <button type="reset" class="btn btn-secondary btn-lg">
                            <i class="fas fa-redo"></i> Reset
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Task List -->
        <div class="card dashboard-card">
            <div class="card-header bg-secondary text-white">
                <h5 class="mb-0"><i class="fas fa-list"></i> Assigned Tasks</h5>
            </div>
            <div class="card-body">
                <c:if test="${empty tasks}">
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle"></i> No tasks have been assigned yet.
                    </div>
                </c:if>
                <c:if test="${not empty tasks}">
                    <div class="table-responsive">
                        <table class="table table-hover table-striped">
                            <thead class="table-dark">
                                <tr>
                                    <th>Task ID</th>
                                    <th>Purchase Order</th>
                                    <th>Auditor</th>
                                    <th>Task Type</th>
                                    <th>Deadline</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${tasks}" var="task">
                                    <tr>
                                        <td><strong>#${task.taskId}</strong></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty task.poId && task.poId > 0}">
                                                    <strong>PO #${task.poId}</strong>
                                                    <c:if test="${not empty task.poNotes}">
                                                        <br><small class="text-muted">${task.poNotes}</small>
                                                    </c:if>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">N/A</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><i class="fas fa-user-shield"></i> ${task.staffName}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${task.taskType == 'stock_in'}">📦 Stock In</c:when>
                                                <c:when test="${task.taskType == 'stock_out'}">📤 Stock Out</c:when>
                                                <c:when test="${task.taskType == 'counting'}">🔢 Counting</c:when>
                                                <c:when test="${task.taskType == 'quality_check'}">✅ Quality</c:when>
                                                <c:when test="${task.taskType == 'expiry_audit'}">⏰ Expiry</c:when>
                                                <c:otherwise>${task.taskType}</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><i class="fas fa-calendar"></i> ${task.deadline}</td>
                                        <td>
                                            <span class="status-badge ${
                                                task.status == 'Pending' ? 'status-pending' : 
                                                task.status == 'In Progress' ? 'status-in-progress' : 
                                                task.status == 'Completed' ? 'status-completed' : 'status-cancelled'}">
                                                ${task.status}
                                            </span>
                                        </td>
                                        <td>
                                            <button class="btn btn-info btn-sm btn-action" 
                                                    onclick="viewTask(${task.taskId})">
                                                <i class="fas fa-eye"></i> View
                                            </button>
                                            <c:if test="${task.status == 'Pending'}">
                                                <button class="btn btn-warning btn-sm btn-action" 
                                                        onclick="editTask(${task.taskId})">
                                                    <i class="fas fa-edit"></i> Edit
                                                </button>
                                                <button class="btn btn-danger btn-sm btn-action" 
                                                        onclick="cancelTask(${task.taskId})">
                                                    <i class="fas fa-times"></i> Cancel
                                                </button>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- View Task Modal -->
    <div class="modal fade" id="viewModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-info text-white">
                    <h5 class="modal-title"><i class="fas fa-eye"></i> Task Details</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="viewModalBody">
                    <div class="text-center">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Task Modal -->
    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-warning">
                    <h5 class="modal-title"><i class="fas fa-edit"></i> Edit Task</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="post" id="editForm">
                    <div class="modal-body" id="editModalBody">
                        <div class="text-center">
                            <div class="spinner-border text-warning" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-warning">
                            <i class="fas fa-save"></i> Update Task
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Cancel Confirmation Modal -->
    <div class="modal fade" id="cancelModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title"><i class="fas fa-exclamation-triangle"></i> Cancel Task</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="cancel">
                        <input type="hidden" name="taskId" id="cancelTaskId">
                        <p>Are you sure you want to cancel this task?</p>
                        <p class="text-danger"><strong>This action cannot be undone.</strong></p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No, Keep It</button>
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-times"></i> Yes, Cancel Task
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Dynamic PO Details Display
        document.getElementById('poSelect').addEventListener('change', function() {
            const selectedOption = this.options[this.selectedIndex];
            const poDetails = document.getElementById('poDetails');
            const poNotesRow = document.getElementById('poNotesRow');
            
            if (this.value) {
                document.getElementById('poSupplier').textContent = selectedOption.getAttribute('data-supplier') || '-';
                document.getElementById('poDate').textContent = selectedOption.getAttribute('data-date') || '-';
                document.getElementById('poDelivery').textContent = selectedOption.getAttribute('data-delivery') || '-';
                document.getElementById('poStatus').textContent = selectedOption.getAttribute('data-status') || '-';
                
                const notes = selectedOption.getAttribute('data-notes');
                if (notes && notes.trim() !== '' && notes !== 'null') {
                    document.getElementById('poNotes').textContent = notes;
                    poNotesRow.style.display = 'block';
                } else {
                    poNotesRow.style.display = 'none';
                }
                
                poDetails.style.display = 'block';
            } else {
                poDetails.style.display = 'none';
                poNotesRow.style.display = 'none';
            }
        });

        // View Task
        function viewTask(taskId) {
            const modal = new bootstrap.Modal(document.getElementById('viewModal'));
            modal.show();
            
            fetch('${pageContext.request.contextPath}/tasks/assign?viewId=' + taskId)
                .then(response => response.text())
                .then(html => {
                    const parser = new DOMParser();
                    const doc = parser.parseFromString(html, 'text/html');
                    const viewTask = doc.querySelector('[data-task-view]');
                    
                    if (viewTask) {
                        document.getElementById('viewModalBody').innerHTML = viewTask.innerHTML;
                    } else {
                        document.getElementById('viewModalBody').innerHTML = 
                            '<div class="alert alert-danger">Error loading task details.</div>';
                    }
                })
                .catch(error => {
                    document.getElementById('viewModalBody').innerHTML = 
                        '<div class="alert alert-danger">Error loading task details.</div>';
                });
        }

        // Edit Task
        function editTask(taskId) {
            const modal = new bootstrap.Modal(document.getElementById('editModal'));
            modal.show();
            
            fetch('${pageContext.request.contextPath}/tasks/assign?viewId=' + taskId)
                .then(response => response.text())
                .then(html => {
                    const parser = new DOMParser();
                    const doc = parser.parseFromString(html, 'text/html');
                    const editForm = doc.querySelector('[data-task-edit]');
                    
                    if (editForm) {
                        document.getElementById('editModalBody').innerHTML = editForm.innerHTML;
                    } else {
                        document.getElementById('editModalBody').innerHTML = 
                            '<div class="alert alert-danger">Error loading task for editing.</div>';
                    }
                })
                .catch(error => {
                    document.getElementById('editModalBody').innerHTML = 
                        '<div class="alert alert-danger">Error loading task details.</div>';
                });
        }

        // Cancel Task
        function cancelTask(taskId) {
            document.getElementById('cancelTaskId').value = taskId;
            const modal = new bootstrap.Modal(document.getElementById('cancelModal'));
            modal.show();
        }

        // Auto-dismiss alerts
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert-dismissible');
            alerts.forEach(function(alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>

    <!-- Hidden content for AJAX loading -->
    <c:if test="${not empty viewTask}">
        <div style="display: none;" data-task-view>
            <div class="row">
                <div class="col-md-6">
                    <div class="info-row">
                        <span class="info-label">Task ID:</span>
                        <span>#${viewTask.taskId}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Task Type:</span>
                        <span>
                            <c:choose>
                                <c:when test="${viewTask.taskType == 'stock_in'}">📦 Stock In Verification</c:when>
                                <c:when test="${viewTask.taskType == 'stock_out'}">📤 Stock Out Verification</c:when>
                                <c:when test="${viewTask.taskType == 'counting'}">🔢 Inventory Counting</c:when>
                                <c:when test="${viewTask.taskType == 'quality_check'}">✅ Quality Check</c:when>
                                <c:when test="${viewTask.taskType == 'expiry_audit'}">⏰ Expiry Date Audit</c:when>
                                <c:otherwise>${viewTask.taskType}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Status:</span>
                        <span class="status-badge ${
                            viewTask.status == 'Pending' ? 'status-pending' : 
                            viewTask.status == 'In Progress' ? 'status-in-progress' : 
                            viewTask.status == 'Completed' ? 'status-completed' : 'status-cancelled'}">
                            ${viewTask.status}
                        </span>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="info-row">
                        <span class="info-label">Assigned Auditor:</span>
                        <span><i class="fas fa-user-shield"></i> ${viewTask.staffName}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Deadline:</span>
                        <span><i class="fas fa-calendar-alt"></i> ${viewTask.deadline}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Created At:</span>
                        <span><i class="fas fa-clock"></i> ${viewTask.createdAt}</span>
                    </div>
                </div>
            </div>
            
            <c:if test="${viewTask.poId > 0}">
                <hr>
                <h6 class="mt-3"><i class="fas fa-file-invoice"></i> Purchase Order Details</h6>
                <div class="info-row">
                    <span class="info-label">PO ID:</span>
                    <span>#${viewTask.poId}</span>
                </div>
                <c:if test="${not empty viewTask.poNotes}">
                    <div class="info-row">
                        <span class="info-label">PO Notes:</span>
                        <span>${viewTask.poNotes}</span>
                    </div>
                </c:if>
                
                <c:if test="${not empty poItems}">
                    <h6 class="mt-3"><i class="fas fa-pills"></i> Order Items</h6>
                    <div class="table-responsive">
                        <table class="table table-sm table-bordered">
                            <thead class="table-light">
                                <tr>
                                    <th>Medicine ID</th>
                                    <th>Quantity</th>
                                    <th>Priority</th>
                                    <th>Notes</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${poItems}" var="item">
                                    <tr>
                                        <td>#${item.medicineId}</td>
                                        <td>${item.quantity} units</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${item.priority == 'High'}">
                                                    <span class="badge bg-danger">High</span>
                                                </c:when>
                                                <c:when test="${item.priority == 'Medium'}">
                                                    <span class="badge bg-warning text-dark">Medium</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-success">Low</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${not empty item.notes ? item.notes : '-'}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>
            </c:if>
        </div>

        <div style="display: none;" data-task-edit>
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="taskId" value="${viewTask.taskId}">
            
            <div class="mb-3">
                <label class="form-label fw-bold">Auditor</label>
                <select class="form-select" name="auditorId" required>
                    <c:forEach items="${auditors}" var="a">
                        <option value="${a.userId}" ${a.userId == viewTask.staffId ? 'selected' : ''}>
                            ${a.username} - ${a.email}
                        </option>
                    </c:forEach>
                </select>
            </div>
            
            <div class="mb-3">
                <label class="form-label fw-bold">Task Type</label>
                <select class="form-select" name="taskType" required>
                    <option value="stock_in" ${viewTask.taskType == 'stock_in' ? 'selected' : ''}>📦 Stock In Verification</option>
                    <option value="stock_out" ${viewTask.taskType == 'stock_out' ? 'selected' : ''}>📤 Stock Out Verification</option>
                    <option value="counting" ${viewTask.taskType == 'counting' ? 'selected' : ''}>🔢 Inventory Counting</option>
                    <option value="quality_check" ${viewTask.taskType == 'quality_check' ? 'selected' : ''}>✅ Quality Check</option>
                    <option value="expiry_audit" ${viewTask.taskType == 'expiry_audit' ? 'selected' : ''}>⏰ Expiry Date Audit</option>
                </select>
            </div>
            
            <div class="mb-3">
                <label class="form-label fw-bold">Deadline</label>
                <input type="date" class="form-control" name="deadline" value="${viewTask.deadline}" required
                       min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
            </div>
        </div>
    </c:if>
</body>
</html>