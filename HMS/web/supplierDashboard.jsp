<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Supplier Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/supplier-dashboard.css">
</head>
<%@ include file="/admin/header.jsp" %>
<body>
    <!-- Mobile Menu Toggle -->
    <button class="mobile-menu-toggle" id="mobileMenuToggle">
        <i class="bi bi-list"></i>
    </button>

    <!-- Sidebar -->
    <aside class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <div class="sidebar-logo">
                <i class="bi bi-building"></i>
                <span class="sidebar-logo-text">Supplier Portal</span>
            </div>
            <button class="sidebar-close" id="sidebarClose">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>

        <div class="sidebar-profile">
            <div class="profile-avatar">
                <i class="bi bi-person-circle"></i>
            </div>
            <div class="profile-info">
                <div class="profile-name">${supplier.name}</div>
                <div class="profile-rating">
                    <i class="bi bi-star-fill"></i>
                    <span>${supplier.performanceRating}/5.0</span>
                </div>
            </div>
        </div>

        <nav class="sidebar-nav">
            <a href="#" class="nav-item active" data-tab="pending">
                <i class="bi bi-clock-history"></i>
                <span>Pending Orders</span>
                <span class="nav-badge">${stats.pendingCount}</span>
            </a>
            
            <a href="#" class="nav-item" data-tab="approved">
                <i class="bi bi-check-circle"></i>
                <span>Approved Orders</span>
                <span class="nav-badge">${stats.approvedCount}</span>
            </a>
            
            <a href="#" class="nav-item" data-tab="completed">
                <i class="bi bi-box-seam"></i>
                <span>Completed Orders</span>
                <span class="nav-badge">${stats.completedCount}</span>
            </a>
            
            <a href="#" class="nav-item" data-tab="asn-tracking">
                <i class="bi bi-truck"></i>
                <span>ASN Tracking</span>
                <span class="nav-badge">${asnStats.totalASNs}</span>
            </a>
            
            <a href="#" class="nav-item" data-tab="pending-payments">
                <i class="bi bi-cash-coin"></i>
                <span>Pending Payments</span>
                <span class="nav-badge badge-warning">${pendingTransactions.size()}</span>
            </a>
        </nav>

        <div class="sidebar-footer">
            
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <!-- Notifications -->
        <c:if test="${not empty param.success}">
            <div class="notification success" id="notification">
                <i class="bi bi-check-circle-fill"></i>
                <div class="notification-content">
                    <div class="notification-title">Success</div>
                    <div class="notification-message">${param.success}</div>
                </div>
                <button class="notification-close" onclick="closeNotification()">
                    <i class="bi bi-x"></i>
                </button>
            </div>
        </c:if>

        <c:if test="${not empty param.error}">
            <div class="notification error" id="notification">
                <i class="bi bi-exclamation-triangle-fill"></i>
                <div class="notification-content">
                    <div class="notification-title">Error</div>
                    <div class="notification-message">${param.error}</div>
                </div>
                <button class="notification-close" onclick="closeNotification()">
                    <i class="bi bi-x"></i>
                </button>
            </div>
        </c:if>

        <!-- Dashboard Header -->
        <div class="dashboard-header">
            <div class="header-title">
                <h1>Dashboard Overview</h1>
                <p>Welcome back! Here's what's happening with your orders</p>
            </div>
            <div class="header-date">
                <i class="bi bi-calendar3"></i>
                <span id="currentDate"></span>
            </div>
        </div>

        <!-- Stats Grid -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon pending">
                    <i class="bi bi-clock-history"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-label">Pending Orders</div>
                    <div class="stat-value">${stats.pendingCount}</div>
                    <div class="stat-trend">
                        <i class="bi bi-arrow-up"></i>
                        <span>Awaiting approval</span>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon approved">
                    <i class="bi bi-check-circle"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-label">Approved Orders</div>
                    <div class="stat-value">${stats.approvedCount}</div>
                    <div class="stat-trend">
                        <i class="bi bi-arrow-up"></i>
                        <span>Ready to ship</span>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon completed">
                    <i class="bi bi-box-seam"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-label">Completed Orders</div>
                    <div class="stat-value">${stats.completedCount}</div>
                    <div class="stat-trend">
                        <i class="bi bi-check"></i>
                        <span>Successfully delivered</span>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon balance">
                    <i class="bi bi-wallet2"></i>
                </div>
                <div class="stat-content">
                    <div class="stat-label">Current Balance</div>
                    <div class="stat-value">
                        <fmt:formatNumber value="${supplierBalance}" pattern="#,##0"/> VND
                    </div>
                    <div class="stat-trend">
                        <i class="bi bi-info-circle"></i>
                        <span>${pendingTransactions.size()} pending payments</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tab Content Container -->
        <div class="tab-content-wrapper">
            <!-- Pending Orders Tab -->
            <div class="tab-content active" id="pending-tab">
                <div class="tab-header">
                    <h2>Pending Orders</h2>
                    <p>Review and approve purchase orders</p>
                </div>

                <c:choose>
                    <c:when test="${empty pendingOrders}">
                        <div class="empty-state">
                            <div class="empty-icon">
                                <i class="bi bi-inbox"></i>
                            </div>
                            <h3>No Pending Orders</h3>
                            <p>You don't have any orders awaiting your approval</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="orders-grid">
                            <c:forEach var="order" items="${pendingOrders}">
                                <div class="order-card">
                                    <div class="order-card-header">
                                        <div class="order-id">
                                            <span class="order-number">PO #${order.poId}</span>
                                            <span class="status-badge pending">
                                                <i class="bi bi-clock"></i>
                                                Pending
                                            </span>
                                        </div>
                                        <button class="order-expand" onclick="toggleOrderDetails(${order.poId}, 'pending')">
                                            <i class="bi bi-chevron-down"></i>
                                        </button>
                                    </div>

                                    <div class="order-card-body">
                                        <div class="order-meta-grid">
                                            <div class="meta-item">
                                                <i class="bi bi-calendar3"></i>
                                                <div>
                                                    <span class="meta-label">Order Date</span>
                                                    <span class="meta-value">
                                                        <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy"/>
                                                    </span>
                                                </div>
                                            </div>

                                            <div class="meta-item">
                                                <i class="bi bi-truck"></i>
                                                <div>
                                                    <span class="meta-label">Expected Delivery</span>
                                                    <span class="meta-value">
                                                        <fmt:formatDate value="${order.expectedDeliveryDate}" pattern="dd MMM yyyy"/>
                                                    </span>
                                                </div>
                                            </div>

                                            <div class="meta-item">
                                                <i class="bi bi-box"></i>
                                                <div>
                                                    <span class="meta-label">Total Items</span>
                                                    <span class="meta-value">${order.items.size()} items</span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="order-items-preview">
                                            <h4>Items Preview</h4>
                                            <ul class="items-list">
                                                <c:forEach var="item" items="${order.items}" end="2">
                                                    <li>
                                                        <span class="item-name">${item.medicineName}</span>
                                                        <span class="item-quantity">${item.quantity} units</span>
                                                    </li>
                                                </c:forEach>
                                                <c:if test="${order.items.size() > 3}">
                                                    <li class="items-more">
                                                        +${order.items.size() - 3} more items
                                                    </li>
                                                </c:if>
                                            </ul>
                                        </div>

                                        <c:if test="${not empty order.notes}">
                                            <div class="order-notes">
                                                <i class="bi bi-info-circle"></i>
                                                <div>
                                                    <strong>Notes:</strong>
                                                    <p>${order.notes}</p>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>

                                    <div class="order-card-actions">
                                        <button class="btn btn-approve" onclick="confirmOrder(${order.poId})">
                                            <i class="bi bi-check-circle"></i>
                                            Approve
                                        </button>
                                        <button class="btn btn-reject" onclick="rejectOrder(${order.poId})">
                                            <i class="bi bi-x-circle"></i>
                                            Reject
                                        </button>
                                    </div>

                                    <!-- Expanded Details -->
                                    <div class="order-details-expanded" id="details-pending-${order.poId}">
                                        <div class="details-section">
                                            <h4>Complete Item List</h4>
                                            <table class="items-table">
                                                <thead>
                                                    <tr>
                                                        <th>Code</th>
                                                        <th>Medicine Name</th>
                                                        <th>Quantity</th>
                                                        <th>Priority</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="item" items="${order.items}">
                                                        <tr>
                                                            <td><code>${item.medicineCode}</code></td>
                                                            <td>${item.medicineName}</td>
                                                            <td><strong>${item.quantity}</strong></td>
                                                            <td>
                                                                <span class="priority-badge ${item.priority.toLowerCase()}">
                                                                    ${item.priority}
                                                                </span>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Approved Orders Tab -->
            <div class="tab-content" id="approved-tab">
                <div class="tab-header">
                    <h2>Approved Orders</h2>
                    <p>Orders ready for shipment</p>
                </div>

                <c:choose>
                    <c:when test="${empty approvedOrders}">
                        <div class="empty-state">
                            <div class="empty-icon">
                                <i class="bi bi-check-circle"></i>
                            </div>
                            <h3>No Approved Orders</h3>
                            <p>You don't have any approved orders ready for shipment</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="orders-grid">
                            <c:forEach var="order" items="${approvedOrders}">
                                <div class="order-card">
                                    <div class="order-card-header">
                                        <div class="order-id">
                                            <span class="order-number">PO #${order.poId}</span>
                                            <span class="status-badge approved">
                                                <i class="bi bi-check-circle"></i>
                                                Approved
                                            </span>
                                        </div>
                                        <button class="order-expand" onclick="toggleOrderDetails(${order.poId}, 'approved')">
                                            <i class="bi bi-chevron-down"></i>
                                        </button>
                                    </div>

                                    <div class="order-card-body">
                                        <div class="order-meta-grid">
                                            <div class="meta-item">
                                                <i class="bi bi-calendar3"></i>
                                                <div>
                                                    <span class="meta-label">Order Date</span>
                                                    <span class="meta-value">
                                                        <fmt:formatDate value="${order.orderDate}" pattern="dd MMM yyyy"/>
                                                    </span>
                                                </div>
                                            </div>

                                            <div class="meta-item">
                                                <i class="bi bi-truck"></i>
                                                <div>
                                                    <span class="meta-label">Expected Delivery</span>
                                                    <span class="meta-value">
                                                        <fmt:formatDate value="${order.expectedDeliveryDate}" pattern="dd MMM yyyy"/>
                                                    </span>
                                                </div>
                                            </div>

                                            <div class="meta-item">
                                                <i class="bi bi-box"></i>
                                                <div>
                                                    <span class="meta-label">Total Items</span>
                                                    <span class="meta-value">${order.items.size()} items</span>
                                                </div>
                                            </div>
                                        </div>

                                        <c:if test="${poHasASN[order.poId]}">
                                            <div class="alert alert-info">
                                                <i class="bi bi-info-circle-fill"></i>
                                                <div>
                                                    <strong>ASN Already Created</strong>
                                                    <p>A shipping notice has been created for this order</p>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>

                                    <div class="order-card-actions">
                                        <c:choose>
                                            <c:when test="${poHasASN[order.poId]}">
                                                <button class="btn btn-disabled" disabled>
                                                    <i class="bi bi-check-circle-fill"></i>
                                                    ASN Created
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/create-asn?poId=${order.poId}" 
                                                   class="btn btn-primary">
                                                    <i class="bi bi-file-earmark-plus"></i>
                                                    Create ASN
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="order-details-expanded" id="details-approved-${order.poId}">
                                        <!-- Similar structure as pending -->
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Completed Orders Tab -->
            <div class="tab-content" id="completed-tab">
                <div class="tab-header">
                    <h2>Completed Orders</h2>
                    <p>Successfully delivered orders</p>
                </div>

                <c:choose>
                    <c:when test="${empty completedOrders}">
                        <div class="empty-state">
                            <div class="empty-icon">
                                <i class="bi bi-box-seam"></i>
                            </div>
                            <h3>No Completed Orders</h3>
                            <p>You don't have any completed orders yet</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Similar structure as approved -->
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- ASN Tracking Tab -->
            <%@ include file="/asnTracking.jsp" %>

            <!-- Pending Payments Tab -->
            <div class="tab-content" id="pending-payments-tab">
                <div class="tab-header">
                    <h2>Pending Payments</h2>
                    <p>Payments awaiting your confirmation</p>
                </div>

                <c:choose>
                    <c:when test="${empty pendingTransactions}">
                        <div class="empty-state">
                            <div class="empty-icon">
                                <i class="bi bi-cash-coin"></i>
                            </div>
                            <h3>No Pending Payments</h3>
                            <p>You don't have any payments waiting for confirmation</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="payments-grid">
                            <c:forEach var="transaction" items="${pendingTransactions}">
                                <div class="payment-card">
                                    <div class="payment-header">
                                        <div class="payment-id">
                                            <span class="payment-label">Payment for</span>
                                            <span class="payment-po">PO #${transaction.poId}</span>
                                        </div>
                                        <span class="status-badge warning">
                                            <i class="bi bi-clock"></i>
                                            Pending
                                        </span>
                                    </div>

                                    <div class="payment-amount">
                                        <i class="bi bi-cash-stack"></i>
                                        <div>
                                            <span class="amount-label">Amount</span>
                                            <span class="amount-value">
                                                <fmt:formatNumber value="${transaction.amount}" pattern="#,##0.00"/> VND
                                            </span>
                                        </div>
                                    </div>

                                    <div class="payment-meta">
                                        <div class="meta-item">
                                            <i class="bi bi-calendar3"></i>
                                            <span>
                                                <fmt:formatDate value="${transaction.createdAt}" pattern="dd MMM yyyy HH:mm"/>
                                            </span>
                                        </div>
                                        <div class="meta-item">
                                            <i class="bi bi-file-text"></i>
                                            <span>${transaction.transactionType}</span>
                                        </div>
                                    </div>

                                    <c:if test="${not empty transaction.notes}">
                                        <div class="payment-notes">
                                            <i class="bi bi-info-circle"></i>
                                            <p>${transaction.notes}</p>
                                        </div>
                                    </c:if>

                                    <form method="POST" 
                                          action="${pageContext.request.contextPath}/supplier-confirm-payment"
                                          onsubmit="return confirmPayment(${transaction.amount});">
                                        <input type="hidden" name="transactionId" value="${transaction.transactionId}">
                                        <button type="submit" class="btn btn-confirm">
                                            <i class="bi bi-check-circle-fill"></i>
                                            Confirm Payment Receipt
                                        </button>
                                    </form>

                                    <div class="payment-warning">
                                        <i class="bi bi-exclamation-triangle"></i>
                                        <p>Confirming will add this amount to your balance and mark the PO as completed</p>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </main>

    <script>
        // Initialize current date
        document.addEventListener('DOMContentLoaded', function() {
            const dateElement = document.getElementById('currentDate');
            if (dateElement) {
                const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
                dateElement.textContent = new Date().toLocaleDateString('en-US', options);
            }

            // Auto-hide notification
            const notification = document.getElementById('notification');
            if (notification) {
                setTimeout(closeNotification, 5000);
            }
        });

        // Sidebar navigation
        document.querySelectorAll('.nav-item[data-tab]').forEach(item => {
            item.addEventListener('click', function(e) {
                e.preventDefault();
                const tabName = this.getAttribute('data-tab');
                
                // Update active nav item
                document.querySelectorAll('.nav-item').forEach(nav => nav.classList.remove('active'));
                this.classList.add('active');
                
                // Update active tab content
                document.querySelectorAll('.tab-content').forEach(tab => tab.classList.remove('active'));
                document.getElementById(tabName + '-tab').classList.add('active');
                
                // Close mobile menu
                if (window.innerWidth <= 768) {
                    document.getElementById('sidebar').classList.remove('active');
                }
            });
        });

        // Mobile menu toggle
        document.getElementById('mobileMenuToggle').addEventListener('click', function() {
            document.getElementById('sidebar').classList.add('active');
        });

        document.getElementById('sidebarClose').addEventListener('click', function() {
            document.getElementById('sidebar').classList.remove('active');
        });

        // Close notification
        function closeNotification() {
            const notification = document.getElementById('notification');
            if (notification) {
                notification.style.animation = 'slideOut 0.3s ease';
                setTimeout(() => {
                    notification.remove();
                    const url = new URL(window.location);
                    url.searchParams.delete('success');
                    url.searchParams.delete('error');
                    window.history.replaceState({}, '', url);
                }, 300);
            }
        }

        // Toggle order details
        function toggleOrderDetails(orderId, type) {
            const details = document.getElementById('details-' + type + '-' + orderId);
            const button = event.target.closest('.order-expand');
            
            if (details.classList.contains('active')) {
                details.classList.remove('active');
                button.innerHTML = '<i class="bi bi-chevron-down"></i>';
            } else {
                details.classList.add('active');
                button.innerHTML = '<i class="bi bi-chevron-up"></i>';
            }
        }

        // Confirm order
        function confirmOrder(poId) {
            if (confirm('Are you sure you want to approve this purchase order?')) {
                window.location.href = '${pageContext.request.contextPath}/supplier-confirm-order?poId=' + poId + '&action=approve';
            }
        }

        // Reject order
        function rejectOrder(poId) {
            const reason = prompt('Please enter the reason for rejection:');
            if (reason && reason.trim() !== '') {
                window.location.href = '${pageContext.request.contextPath}/supplier-confirm-order?poId=' + poId + '&action=reject&reason=' + encodeURIComponent(reason);
            }
        }

        // Confirm payment
        function confirmPayment(amount) {
            const formattedAmount = new Intl.NumberFormat('vi-VN').format(amount);
            return confirm('Are you sure you want to confirm receiving payment of ' + formattedAmount + ' VND?\n\nThis will:\n- Add the amount to your balance\n- Mark the purchase order as Completed\n- This action cannot be undone.');
        }
    </script>
</body>

</html><%@ include file="/admin/footer.jsp" %>
