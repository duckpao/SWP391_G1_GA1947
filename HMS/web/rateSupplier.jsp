<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rate Suppliers - Manager Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
    <%@ include file="/admin/header.jsp" %>
    
    <div class="container mt-5">
        <div class="row mb-4">
            <div class="col-12">
                <h1 class="display-5">
                    <i class="bi bi-star-fill text-warning"></i>
                    Rate Suppliers
                </h1>
                <p class="text-muted">Rate completed orders to help improve supplier performance</p>
            </div>
        </div>

        <!-- Notifications -->
        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill"></i>
                ${param.success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill"></i>
                ${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Unrated Orders -->
        <c:choose>
            <c:when test="${empty unratedPOs}">
                <div class="alert alert-info text-center py-5">
                    <i class="bi bi-check-circle display-1 text-info"></i>
                    <h3 class="mt-3">All Caught Up!</h3>
                    <p class="text-muted">You have rated all completed orders</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row g-4">
                    <c:forEach var="po" items="${unratedPOs}">
                        <div class="col-md-6 col-lg-4">
                            <div class="card h-100 shadow-sm">
                                <div class="card-header bg-primary text-white">
                                    <h5 class="card-title mb-0">
                                        <i class="bi bi-file-text"></i>
                                        PO #${po.poId}
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="mb-3">
                                        <label class="text-muted small">Supplier</label>
                                        <p class="mb-1 fw-bold">${po.supplierName}</p>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-6">
                                            <label class="text-muted small">Order Date</label>
                                            <p class="mb-0">
                                                <fmt:formatDate value="${po.orderDate}" pattern="dd MMM yyyy"/>
                                            </p>
                                        </div>
                                        <div class="col-6">
                                            <label class="text-muted small">Completed</label>
                                            <p class="mb-0">
                                                <fmt:formatDate value="${po.updatedAt}" pattern="dd MMM yyyy"/>
                                            </p>
                                        </div>
                                    </div>

                                    <c:if test="${not empty po.notes}">
                                        <div class="mb-3">
                                            <label class="text-muted small">Notes</label>
                                            <p class="mb-0 text-truncate" title="${po.notes}">
                                                ${po.notes}
                                            </p>
                                        </div>
                                    </c:if>

                                    <button type="button" 
                                            class="btn btn-warning w-100" 
                                            data-bs-toggle="modal" 
                                            data-bs-target="#rateModal${po.poId}">
                                        <i class="bi bi-star-fill"></i>
                                        Rate This Supplier
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Rating Modal -->
                        <div class="modal fade" id="rateModal${po.poId}" tabindex="-1">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <form method="POST" action="${pageContext.request.contextPath}/manager/rate-supplier">
                                        <input type="hidden" name="poId" value="${po.poId}">
                                        <input type="hidden" name="supplierId" value="${po.supplierId}">
                                        
                                        <div class="modal-header bg-warning">
                                            <h5 class="modal-title">
                                                <i class="bi bi-star-fill"></i>
                                                Rate Supplier
                                            </h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                        </div>
                                        
                                        <div class="modal-body">
                                            <div class="text-center mb-4">
                                                <h6 class="text-muted">Rating for</h6>
                                                <h4>${po.supplierName}</h4>
                                                <p class="text-muted">Purchase Order #${po.poId}</p>
                                            </div>

                                            <!-- Star Rating -->
                                            <div class="mb-4">
                                                <label class="form-label fw-bold">Your Rating</label>
                                                <div class="star-rating text-center" 
                                                     id="starRating${po.poId}">
                                                    <input type="hidden" name="rating" id="ratingInput${po.poId}" value="0" required>
                                                    <div class="stars">
                                                        <i class="bi bi-star rating-star" data-rating="1"></i>
                                                        <i class="bi bi-star rating-star" data-rating="2"></i>
                                                        <i class="bi bi-star rating-star" data-rating="3"></i>
                                                        <i class="bi bi-star rating-star" data-rating="4"></i>
                                                        <i class="bi bi-star rating-star" data-rating="5"></i>
                                                    </div>
                                                    <p class="mt-2 text-muted" id="ratingText${po.poId}">
                                                        Click to rate
                                                    </p>
                                                </div>
                                            </div>

                                            <!-- Review Text -->
                                            <div class="mb-3">
                                                <label class="form-label fw-bold">Review (Optional)</label>
                                                <textarea class="form-control" 
                                                          name="reviewText" 
                                                          rows="4" 
                                                          placeholder="Share your experience with this supplier..."></textarea>
                                            </div>
                                        </div>
                                        
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
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
                        </div>

                        <script>
                            // Star rating functionality for each modal
                            (function() {
                                const container = document.getElementById('starRating${po.poId}');
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
                                        
                                        // Update stars
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
                                        
                                        // Update text
                                        text.textContent = ratingLabels[rating];
                                        text.classList.add('fw-bold', 'text-warning');
                                        
                                        // Enable submit button
                                        submitBtn.disabled = false;
                                    });

                                    // Hover effect
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

    <style>
        .rating-star {
            font-size: 2.5rem;
            cursor: pointer;
            transition: all 0.2s;
            color: #ddd;
        }
        
        .rating-star:hover {
            transform: scale(1.2);
        }
        
        .stars {
            display: flex;
            justify-content: center;
            gap: 0.5rem;
        }
    </style>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <%@ include file="/admin/footer.jsp" %>
</body>
</html>