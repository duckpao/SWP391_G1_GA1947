<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rate Suppliers - Manager Dashboard</title>
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
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: #f9fafb;
            min-height: 100vh;
            color: #374151;
        }
        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }
        /* Sidebar styling */
        .sidebar {
            width: 280px;
            background: white;
            color: #1f2937;
            padding: 30px 20px;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.08);
            overflow-y: auto;
            border-right: 1px solid #e5e7eb;
        }
        .sidebar-header {
            margin-bottom: 30px;
        }
        .sidebar-header h4 {
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
            color: #1f2937;
        }
        .sidebar-header hr {
            border: none;
            border-top: 1px solid #e5e7eb;
            margin: 15px 0;
        }
        .nav-link {
            color: #6b7280;
            text-decoration: none;
            padding: 12px 16px;
            border-radius: 10px;
            margin: 6px 0;
            display: flex;
            align-items: center;
            gap: 12px;
            transition: all 0.3s ease;
            font-size: 14px;
            font-weight: 500;
        }
        .nav-link:hover,
        .nav-link.active {
            background: #f3f4f6;
            color: #3b82f6;
            transform: translateX(4px);
        }
        .nav-divider {
            border: none;
            border-top: 1px solid #e5e7eb;
            margin: 15px 0;
        }
        .nav-section-title {
            font-size: 11px;
            font-weight: 600;
            color: #9ca3af;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding-left: 16px;
        }
        .main-content {
            flex: 1;
            padding: 40px;
            overflow-y: auto;
            background: #f9fafb;
            min-height: 100vh;
        }
        .page-header {
            margin-bottom: 30px;
        }
        .page-header h1 {
            font-size: 32px;
            font-weight: 700;
            color: #1f2937;
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 8px;
        }
        .page-header p {
            color: #6b7280;
            font-size: 14px;
        }
        .alert {
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 14px;
        }
        .alert-success {
            background: #dcfce7;
            color: #166534;
            border: 1px solid #86efac;
        }
        .alert-danger {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fca5a5;
        }
        .alert-info {
            background: #dbeafe;
            color: #1e40af;
            border: 1px solid #93c5fd;
            text-align: center;
            flex-direction: column;
            padding: 48px 24px;
        }
        .alert-info i {
            font-size: 64px;
            margin-bottom: 16px;
        }
        .alert-info h3 {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 8px;
        }
        .rating-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 24px;
        }
        .rating-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            transition: all 0.3s ease;
            border-top: 3px solid #3b82f6;
        }
        .rating-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.12);
        }
        .card-header {
            background: #3b82f6;
            color: white;
            padding: 20px;
        }
        .card-header h5 {
            margin: 0;
            font-size: 16px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .card-body {
            padding: 24px;
        }
        .info-row {
            margin-bottom: 16px;
        }
        .info-label {
            font-size: 12px;
            font-weight: 600;
            color: #9ca3af;
            text-transform: uppercase;
            margin-bottom: 4px;
        }
        .info-value {
            font-size: 14px;
            font-weight: 600;
            color: #1f2937;
        }
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 16px;
        }
        .btn {
            padding: 12px 20px;
            border-radius: 10px;
            border: none;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            width: 100%;
        }
        .btn-warning {
            background: #f59e0b;
            color: white;
        }
        .btn-warning:hover {
            background: #d97706;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(245, 158, 11, 0.3);
        }
        .btn-secondary {
            background: #6b7280;
            color: white;
        }
        .btn-secondary:hover {
            background: #4b5563;
        }
        /* Modal styling */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(4px);
        }
        .modal.show {
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .modal-content {
            background: white;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            max-width: 500px;
            width: 90%;
            max-height: 90vh;
            overflow-y: auto;
        }
        .modal-header {
            background: #f59e0b;
            color: white;
            padding: 24px;
            border-radius: 16px 16px 0 0;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .modal-header h5 {
            margin: 0;
            font-size: 18px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .close-btn {
            background: none;
            border: none;
            color: white;
            font-size: 28px;
            cursor: pointer;
            line-height: 1;
            transition: all 0.2s;
        }
        .close-btn:hover {
            transform: rotate(90deg);
        }
        .modal-body {
            padding: 32px;
        }
        .modal-footer {
            padding: 24px;
            border-top: 1px solid #e5e7eb;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }
        .rating-info {
            text-align: center;
            margin-bottom: 32px;
        }
        .rating-info h6 {
            font-size: 13px;
            color: #9ca3af;
            margin-bottom: 8px;
        }
        .rating-info h4 {
            font-size: 20px;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 4px;
        }
        .rating-info p {
            font-size: 14px;
            color: #6b7280;
        }
        .star-rating {
            text-align: center;
            margin-bottom: 32px;
        }
        .form-label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 8px;
        }
        .stars {
            display: flex;
            justify-content: center;
            gap: 8px;
            margin-bottom: 12px;
        }
        .rating-star {
            font-size: 40px;
            cursor: pointer;
            transition: all 0.2s;
            color: #ddd;
        }
        .rating-star:hover {
            transform: scale(1.2);
        }
        .rating-star.text-warning {
            color: #f59e0b;
        }
        .rating-text {
            font-size: 16px;
            font-weight: 600;
            color: #6b7280;
            margin-top: 8px;
        }
        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-family: inherit;
            font-size: 14px;
            transition: all 0.3s;
            resize: vertical;
        }
        .form-control:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        /* Scrollbar styling */
        ::-webkit-scrollbar {
            width: 8px;
        }
        ::-webkit-scrollbar-track {
            background: rgba(0, 0, 0, 0.05);
        }
        ::-webkit-scrollbar-thumb {
            background: rgba(0, 0, 0, 0.2);
            border-radius: 4px;
        }
        ::-webkit-scrollbar-thumb:hover {
            background: rgba(0, 0, 0, 0.3);
        }
        /* Responsive */
        @media (max-width: 768px) {
            .dashboard-container {
                flex-direction: column;
            }
            .sidebar {
                width: 100%;
                padding: 20px;
            }
            .main-content {
                padding: 20px;
            }
            .rating-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <%@ include file="/admin/header.jsp" %>
    
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <h4><i class="bi bi-hospital"></i> Manager</h4>
                <hr class="sidebar-divider">
            </div>
            <nav>
                <a class="nav-link" href="${pageContext.request.contextPath}/manager-dashboard">
                    <i class="bi bi-speedometer2"></i> Dashboard
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/create-stock">
                    <i class="bi bi-plus-circle"></i> New Stock Request
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/cancelled-tasks">
                    <i class="bi bi-ban"></i> Cancelled Orders
                </a>
                
                <hr class="nav-divider">
                
                <!-- Order History Section -->
                <h6 class="nav-section-title">ORDER HISTORY</h6>
                <a class="nav-link" href="${pageContext.request.contextPath}/manager/sent-orders">
                    <i class="bi bi-send-check"></i> Sent Orders
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/manager/intransit-orders">
                    <i class="bi bi-truck"></i> In Transit
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/manager/completed-orders">
                    <i class="bi bi-check-circle"></i> Completed
                </a>
               
                <hr class="nav-divider">
               
                <!-- Reports Section -->
                <a class="nav-link" href="${pageContext.request.contextPath}/inventory-report">
                    <i class="bi bi-boxes"></i> Inventory Report
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/expiry-report?days=30">
                    <i class="bi bi-calendar-times"></i> Expiry Report
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/stock-alerts">
                    <i class="bi bi-exclamation-triangle"></i> Stock Alerts
                </a>
               
                <hr class="nav-divider">
               
                <!-- Management Section -->
                <a class="nav-link" href="${pageContext.request.contextPath}/tasks/assign">
                    <i class="bi bi-pencil"></i> Assign Tasks
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/manage/transit">
                    <i class="bi bi-truck"></i> Transit Orders
                </a>
                <a class="nav-link active" href="${pageContext.request.contextPath}/manager/rate-supplier">
                    <i class="bi bi-star-fill"></i> Rate Suppliers
                    <c:if test="${unratedCount > 0}">
                        <span style="margin-left: auto; background: #f59e0b; color: white; padding: 2px 8px; border-radius: 12px; font-size: 11px; font-weight: 700;">
                            ${unratedCount}
                        </span>
                    </c:if>
                </a>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="page-header">
                <h1>
                    <i class="bi bi-star-fill text-warning"></i>
                    Rate Suppliers
                </h1>
                <p class="text-muted">Rate completed orders to help improve supplier performance</p>
            </div>

            <!-- Notifications -->
            <c:if test="${not empty param.success}">
                <div class="alert alert-success">
                    <i class="bi bi-check-circle-fill"></i>
                    ${param.success}
                </div>
            </c:if>

            <c:if test="${not empty param.error}">
                <div class="alert alert-danger">
                    <i class="bi bi-exclamation-triangle-fill"></i>
                    ${param.error}
                </div>
            </c:if>

            <!-- Unrated Orders -->
            <c:choose>
                <c:when test="${empty unratedPOs}">
                    <div class="alert alert-info">
                        <i class="bi bi-check-circle"></i>
                        <h3>All Caught Up!</h3>
                        <p>You have rated all completed orders</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="rating-grid">
                        <c:forEach var="po" items="${unratedPOs}">
                            <div class="rating-card">
                                <div class="card-header">
                                    <h5>
                                        <i class="bi bi-file-text"></i>
                                        PO #${po.poId}
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="info-row">
                                        <div class="info-label">Supplier</div>
                                        <div class="info-value">${po.supplierName}</div>
                                    </div>

                                    <div class="info-grid">
                                        <div>
                                            <div class="info-label">Order Date</div>
                                            <div class="info-value">
                                                <fmt:formatDate value="${po.orderDate}" pattern="dd MMM yyyy"/>
                                            </div>
                                        </div>
                                        <div>
                                            <div class="info-label">Completed</div>
                                            <div class="info-value">
                                                <fmt:formatDate value="${po.updatedAt}" pattern="dd MMM yyyy"/>
                                            </div>
                                        </div>
                                    </div>

                                    <c:if test="${not empty po.notes}">
                                        <div class="info-row">
                                            <div class="info-label">Notes</div>
                                            <div class="info-value" style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis;" title="${po.notes}">
                                                ${po.notes}
                                            </div>
                                        </div>
                                    </c:if>

                                    <button type="button" 
                                            class="btn btn-warning" 
                                            onclick="openModal('rateModal${po.poId}')">
                                        <i class="bi bi-star-fill"></i>
                                        Rate This Supplier
                                    </button>
                                </div>
                            </div>

                            <!-- Rating Modal -->
                            <div class="modal" id="rateModal${po.poId}">
                                <div class="modal-content">
                                    <form method="POST" action="${pageContext.request.contextPath}/manager/rate-supplier">
                                        <input type="hidden" name="poId" value="${po.poId}">
                                        <input type="hidden" name="supplierId" value="${po.supplierId}">
                                        
                                        <div class="modal-header">
                                            <h5>
                                                <i class="bi bi-star-fill"></i>
                                                Rate Supplier
                                            </h5>
                                            <button type="button" class="close-btn" onclick="closeModal('rateModal${po.poId}')">&times;</button>
                                        </div>
                                        
                                        <div class="modal-body">
                                            <div class="rating-info">
                                                <h6>Rating for</h6>
                                                <h4>${po.supplierName}</h4>
                                                <p>Purchase Order #${po.poId}</p>
                                            </div>

                                            <!-- Star Rating -->
                                            <div class="star-rating">
                                                <label class="form-label">Your Rating</label>
                                                <input type="hidden" name="rating" id="ratingInput${po.poId}" value="0" required>
                                                <div class="stars" id="starContainer${po.poId}">
                                                    <i class="bi bi-star rating-star" data-rating="1"></i>
                                                    <i class="bi bi-star rating-star" data-rating="2"></i>
                                                    <i class="bi bi-star rating-star" data-rating="3"></i>
                                                    <i class="bi bi-star rating-star" data-rating="4"></i>
                                                    <i class="bi bi-star rating-star" data-rating="5"></i>
                                                </div>
                                                <p class="rating-text" id="ratingText${po.poId}">Click to rate</p>
                                            </div>

                                            <!-- Review Text -->
                                            <div>
                                                <label class="form-label">Review (Optional)</label>
                                                <textarea class="form-control" 
                                                          name="reviewText" 
                                                          rows="4" 
                                                          placeholder="Share your experience with this supplier..."></textarea>
                                            </div>
                                        </div>
                                        
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" onclick="closeModal('rateModal${po.poId}')">
                                                Cancel
                                            </button>
                                            <button type="submit" class="btn btn-warning" id="submitBtn${po.poId}" disabled>
                                                <i class="bi bi-check-circle"></i>
                                                Submit Rating
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <script>
                                // Star rating functionality
                                (function() {
                                    const container = document.getElementById('starContainer${po.poId}');
                                    const stars = container.querySelectorAll('.rating-star');
                                    const input = document.getElementById('ratingInput${po.poId}');
                                    const text = document.getElementById('ratingText${po.poId}');
                                    const submitBtn = document.getElementById('submitBtn${po.poId}');
                                    
                                    const ratingLabels = {
                                        1: 'Poor',
                                        2: 'Fair',
                                        3: 'Good',
                                        4: 'Very Good',
                                        5: 'Excellent'
                                    };

                                    stars.forEach(star => {
                                        star.addEventListener('click', function() {
                                            const rating = parseInt(this.dataset.rating);
                                            input.value = rating;
                                            
                                            stars.forEach(s => {
                                                const starRating = parseInt(s.dataset.rating);
                                                if (starRating <= rating) {
                                                    s.classList.remove('bi-star');
                                                    s.classList.add('bi-star-fill', 'text-warning');
                                                } else {
                                                    s.classList.remove('bi-star-fill', 'text-warning');
                                                    s.classList.add('bi-star');
                                                }
                                            });
                                            
                                            text.textContent = ratingLabels[rating];
                                            text.style.color = '#f59e0b';
                                            submitBtn.disabled = false;
                                        });

                                        star.addEventListener('mouseenter', function() {
                                            const rating = parseInt(this.dataset.rating);
                                            stars.forEach(s => {
                                                const starRating = parseInt(s.dataset.rating);
                                                if (starRating <= rating) {
                                                    s.classList.add('text-warning');
                                                } else {
                                                    s.classList.remove('text-warning');
                                                }
                                            });
                                        });

                                        star.addEventListener('mouseleave', function() {
                                            const currentRating = parseInt(input.value) || 0;
                                            stars.forEach(s => {
                                                const starRating = parseInt(s.dataset.rating);
                                                if (starRating > currentRating) {
                                                    s.classList.remove('text-warning');
                                                }
                                            });
                                        });
                                    });
                                })();
                            </script>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        function openModal(modalId) {
            document.getElementById(modalId).classList.add('show');
        }

        function closeModal(modalId) {
            document.getElementById(modalId).classList.remove('show');
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            if (event.target.classList.contains('modal')) {
                event.target.classList.remove('show');
            }
        }
    </script>

    <%@ include file="/admin/footer.jsp" %>
</body>
</html>