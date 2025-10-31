<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!-- ASN TRACKING TAB -->
<div id="asn-tracking-tab" class="tab-content">
    <!-- ASN Statistics Cards -->
        <!-- Notification for ASN Tab (shown when tab is active) -->
    <c:if test="${not empty param.asnSuccess}">
        <div class="notification success asn-notification" style="position: relative; margin-bottom: 20px;">
            <i class="bi bi-check-circle-fill icon"></i>
            <span class="message">${param.asnSuccess}</span>
            <button class="close-btn" onclick="this.parentElement.remove()">
                <i class="bi bi-x"></i>
            </button>
        </div>
    </c:if>
    
    <c:if test="${not empty param.asnError}">
        <div class="notification error asn-notification" style="position: relative; margin-bottom: 20px;">
            <i class="bi bi-exclamation-triangle-fill icon"></i>
            <span class="message">${param.asnError}</span>
            <button class="close-btn" onclick="this.parentElement.remove()">
                <i class="bi bi-x"></i>
            </button>
        </div>
    </c:if>
    <div class="stats-grid" style="margin-bottom: 30px;">
        <div class="stat-card" style="border-left-color: #f59e0b;">
            <h3>Pending ASNs</h3>
            <p>${asnStats.pendingCount}</p>
        </div>
        <div class="stat-card" style="border-left-color: #3b82f6;">
            <h3>Sent / Ready</h3>
            <p>${asnStats.sentCount}</p>
        </div>
        <div class="stat-card" style="border-left-color: #8b5cf6;">
            <h3>In Transit</h3>
            <p>${asnStats.inTransitCount}</p>
        </div>
        <div class="stat-card" style="border-left-color: #10b981;">
            <h3>Delivered</h3>
            <p>${asnStats.deliveredCount}</p>
        </div>
    </div>

    <!-- Filter Tabs for ASNs -->
    <div class="asn-filter-tabs" style="margin-bottom: 24px;">
        <div class="tabs">
            <button class="tab-button active" onclick="filterASNs('all')">
                <i class="bi bi-collection"></i>
                All ASNs
                <span class="tab-badge">${asnStats.totalASNs}</span>
            </button>
            <button class="tab-button" onclick="filterASNs('pending')">
                <i class="bi bi-clock-history"></i>
                Pending
                <span class="tab-badge">${asnStats.pendingCount}</span>
            </button>
            <button class="tab-button" onclick="filterASNs('sent')">
                <i class="bi bi-send-check"></i>
                Sent
                <span class="tab-badge">${asnStats.sentCount}</span>
            </button>
            <button class="tab-button" onclick="filterASNs('intransit')">
                <i class="bi bi-truck"></i>
                In Transit
                <span class="tab-badge">${asnStats.inTransitCount}</span>
            </button>
            <button class="tab-button" onclick="filterASNs('delivered')">
                <i class="bi bi-check-circle"></i>
                Delivered
                <span class="tab-badge">${asnStats.deliveredCount}</span>
            </button>
        </div>
    </div>

    <!-- ASN Cards Container -->
    <div class="asn-cards-container">
        <c:choose>
            <c:when test="${empty allASNs}">
                <div class="empty-state">
                    <div class="empty-icon">📦</div>
                    <div class="empty-title">No Shipping Notices Yet</div>
                    <div class="empty-text">
                        Create shipping notices for approved orders to track deliveries.
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="asn" items="${allASNs}">
                    <div class="asn-card" data-status="${asn.status.toLowerCase()}">
                        <!-- ASN Header -->
                        <div class="asn-header">
                            <div class="asn-title-section">
                                <div class="asn-id-badge">
                                    <i class="bi bi-file-earmark-text"></i>
                                    ASN #${asn.asnId}
                                </div>
                                <span class="asn-status-badge status-${asn.status.toLowerCase()}">
                                    <i class="bi ${asn.statusIcon}"></i>
                                    ${asn.status}
                                </span>
                            </div>
                            <div class="asn-po-link">
                                <span class="text-muted">For Order:</span>
                                <strong>PO #${asn.poId}</strong>
                            </div>
                        </div>

                        <!-- ASN Timeline/Progress -->
                        <div class="asn-timeline">
                            <div class="timeline-item ${asn.status == 'Pending' || asn.status == 'Sent' || asn.status == 'InTransit' || asn.status == 'Delivered' ? 'completed' : ''}">
                                <div class="timeline-marker"></div>
                                <div class="timeline-content">
                                    <div class="timeline-title">Created</div>
                                    <div class="timeline-date">
                                        <fmt:formatDate value="${asn.createdAt}" pattern="dd MMM, HH:mm"/>
                                    </div>
                                </div>
                            </div>
                            <div class="timeline-item ${asn.status == 'Sent' || asn.status == 'InTransit' || asn.status == 'Delivered' ? 'completed' : ''}">
                                <div class="timeline-marker"></div>
                                <div class="timeline-content">
                                    <div class="timeline-title">Sent</div>
                                    <div class="timeline-date">
                                        <c:choose>
                                            <c:when test="${not empty asn.submittedAt}">
                                                <fmt:formatDate value="${asn.submittedAt}" pattern="dd MMM, HH:mm"/>
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                            <div class="timeline-item ${asn.status == 'InTransit' || asn.status == 'Delivered' ? 'completed' : ''}">
                                <div class="timeline-marker"></div>
                                <div class="timeline-content">
                                    <div class="timeline-title">In Transit</div>
                                    <div class="timeline-date">-</div>
                                </div>
                            </div>
                            <div class="timeline-item ${asn.status == 'Delivered' ? 'completed' : ''}">
                                <div class="timeline-marker"></div>
                                <div class="timeline-content">
                                    <div class="timeline-title">Delivered</div>
                                    <div class="timeline-date">
                                        <c:choose>
                                            <c:when test="${asn.status == 'Delivered' && not empty asn.updatedAt}">
                                                <fmt:formatDate value="${asn.updatedAt}" pattern="dd MMM, HH:mm"/>
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- ASN Details Grid -->
                        <div class="asn-details-grid">
                            <div class="asn-detail-item">
                                <i class="bi bi-calendar3"></i>
                                <div>
                                    <div class="detail-label">Shipment Date</div>
                                    <div class="detail-value">
                                        <fmt:formatDate value="${asn.shipmentDate}" pattern="dd MMM yyyy"/>
                                    </div>
                                </div>
                            </div>
                            <div class="asn-detail-item">
                                <i class="bi bi-truck"></i>
                                <div>
                                    <div class="detail-label">Carrier</div>
                                    <div class="detail-value">${asn.carrier}</div>
                                </div>
                            </div>
                            <div class="asn-detail-item">
                                <i class="bi bi-hash"></i>
                                <div>
                                    <div class="detail-label">Tracking Number</div>
                                    <div class="detail-value tracking-number">
                                        ${asn.trackingNumber}
                                        <button class="copy-btn" onclick="copyTracking('${asn.trackingNumber}')" title="Copy">
                                            <i class="bi bi-clipboard"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="asn-detail-item">
                                <i class="bi bi-box"></i>
                                <div>
                                    <div class="detail-label">Total Items</div>
                                    <div class="detail-value">${asn.items.size()} items</div>
                                </div>
                            </div>
                        </div>

                        <!-- Items Preview -->
                        <div class="asn-items-preview">
                            <div class="items-preview-title">
                                <i class="bi bi-list-ul"></i>
                                Shipment Items
                            </div>
                            <div class="items-preview-list">
                                <c:forEach var="item" items="${asn.items}" end="2">
                                    <div class="item-preview-row">
                                        <span class="item-code">${item.medicineCode}</span>
                                        <span class="item-name">${item.medicineName}</span>
                                        <span class="item-qty">${item.quantity} units</span>
                                    </div>
                                </c:forEach>
                                <c:if test="${asn.items.size() > 3}">
                                    <div class="item-preview-more">
                                        + ${asn.items.size() - 3} more items
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <!-- Notes if any -->
                        <c:if test="${not empty asn.notes}">
                            <div class="asn-notes-box">
                                <i class="bi bi-sticky"></i>
                                <strong>Notes:</strong> ${asn.notes}
                            </div>
                        </c:if>

                        <!-- Action Buttons -->
                        <div class="asn-actions">
                            <c:if test="${asn.canBeEdited()}">
                                <a href="${pageContext.request.contextPath}/update-tracking?asnId=${asn.asnId}" 
                                   class="btn btn-secondary">
                                    <i class="bi bi-pencil"></i>
                                    Edit Tracking
                                </a>
                            </c:if>
                            
                            <c:if test="${asn.status == 'Pending'}">
                                <button class="btn btn-primary" onclick="markAsShipped(${asn.asnId})">
                                    <i class="bi bi-send"></i>
                                    Mark as Sent
                                </button>
                            </c:if>
                            
                            <c:if test="${asn.status == 'Sent'}">
                                <button class="btn btn-primary" onclick="markAsInTransit(${asn.asnId})">
                                    <i class="bi bi-truck"></i>
                                    Mark In Transit
                                </button>
                            </c:if>
                            
                            <button class="btn btn-view" onclick="toggleASNDetails('asn-${asn.asnId}')">
                                <i class="bi bi-eye"></i>
                                <span id="btn-text-asn-${asn.asnId}">View Full Details</span>
                            </button>
                            
                            <c:if test="${asn.canBeCancelled()}">
                                <button class="btn btn-reject" onclick="cancelASN(${asn.asnId})">
                                    <i class="bi bi-x-circle"></i>
                                    Cancel
                                </button>
                            </c:if>
                        </div>

                        <!-- Expandable Full Details -->
                        <div id="details-asn-${asn.asnId}" class="asn-full-details">
                            <div class="details-section">
                                <h6><i class="bi bi-info-circle"></i> Complete ASN Information</h6>
                                <table class="details-table">
                                    <tr>
                                        <td>ASN ID:</td>
                                        <td><strong>#${asn.asnId}</strong></td>
                                    </tr>
                                    <tr>
                                        <td>Purchase Order:</td>
                                        <td><strong>PO #${asn.poId}</strong></td>
                                    </tr>
                                    <tr>
                                        <td>Status:</td>
                                        <td><span class="asn-status-badge status-${asn.status.toLowerCase()}">${asn.status}</span></td>
                                    </tr>
                                    <tr>
                                        <td>Created:</td>
                                        <td><fmt:formatDate value="${asn.createdAt}" pattern="dd MMM yyyy, HH:mm"/></td>
                                    </tr>
                                    <tr>
                                        <td>Last Updated:</td>
                                        <td><fmt:formatDate value="${asn.updatedAt}" pattern="dd MMM yyyy, HH:mm"/></td>
                                    </tr>
                                    <tr>
                                        <td>Submitted By:</td>
                                        <td>${asn.submittedBy}</td>
                                    </tr>
                                </table>

                                <h6 style="margin-top: 24px;">
                                    <i class="bi bi-capsule"></i> All Items in Shipment
                                </h6>
                                <table class="items-table">
                                    <thead>
                                        <tr>
                                            <th>Medicine Code</th>
                                            <th>Medicine Name</th>
                                            <th>Quantity</th>
                                            <th>Lot Number</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${asn.items}">
                                            <tr>
                                                <td><strong>${item.medicineCode}</strong></td>
                                                <td>${item.medicineName}</td>
                                                <td><strong>${item.quantity}</strong> ${item.unit != null ? item.unit : ''}</td>
                                                <td>${item.lotNumber != null ? item.lotNumber : '-'}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<style>
/* ASN Card Styles */
.asn-card {
    background: white;
    border-radius: 16px;
    padding: 24px;
    margin-bottom: 20px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.06);
    border: 1px solid #e9ecef;
    transition: all 0.3s ease;
}

.asn-card:hover {
    box-shadow: 0 4px 16px rgba(0,0,0,0.1);
}

.asn-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 24px;
    padding-bottom: 16px;
    border-bottom: 2px solid #f3f4f6;
}

.asn-title-section {
    display: flex;
    align-items: center;
    gap: 12px;
}

.asn-id-badge {
    font-size: 18px;
    font-weight: 700;
    color: #2c3e50;
    display: flex;
    align-items: center;
    gap: 8px;
}

.asn-status-badge {
    padding: 6px 12px;
    border-radius: 6px;
    font-size: 12px;
    font-weight: 600;
    display: inline-flex;
    align-items: center;
    gap: 4px;
}

.status-pending {
    background: #fff3cd;
    color: #664d03;
    border: 1px solid #ffecb5;
}

.status-sent {
    background: #cfe2ff;
    color: #084298;
    border: 1px solid #9ec5fe;
}

.status-intransit {
    background: #e0d4f7;
    color: #6b21a8;
    border: 1px solid #d4c5f9;
}

.status-delivered {
    background: #d4edda;
    color: #155724;
    border: 1px solid #c3e6cb;
}

.status-rejected {
    background: #f8d7da;
    color: #721c24;
    border: 1px solid #f5c6cb;
}

.status-cancelled {
    background: #e5e7eb;
    color: #374151;
    border: 1px solid #d1d5db;
}

.asn-po-link {
    text-align: right;
    font-size: 14px;
}

/* Timeline Styles */
.asn-timeline {
    display: flex;
    justify-content: space-between;
    margin-bottom: 24px;
    padding: 20px;
    background: #f9fafb;
    border-radius: 12px;
    position: relative;
}

.asn-timeline::before {
    content: '';
    position: absolute;
    top: 40px;
    left: 60px;
    right: 60px;
    height: 2px;
    background: #e5e7eb;
    z-index: 0;
}

.timeline-item {
    flex: 1;
    text-align: center;
    position: relative;
    z-index: 1;
}

.timeline-marker {
    width: 20px;
    height: 20px;
    border-radius: 50%;
    background: #e5e7eb;
    margin: 0 auto 8px;
    position: relative;
    border: 3px solid white;
}

.timeline-item.completed .timeline-marker {
    background: #10b981;
}

.timeline-title {
    font-size: 12px;
    font-weight: 600;
    color: #6b7280;
    margin-bottom: 4px;
}

.timeline-item.completed .timeline-title {
    color: #10b981;
}

.timeline-date {
    font-size: 11px;
    color: #9ca3af;
}

/* ASN Details Grid */
.asn-details-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 16px;
    margin-bottom: 20px;
}

.asn-detail-item {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px;
    background: #f9fafb;
    border-radius: 8px;
    border: 1px solid #e5e7eb;
}

.asn-detail-item i {
    font-size: 20px;
    color: #6b7280;
}

.detail-label {
    font-size: 11px;
    color: #6b7280;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.detail-value {
    font-size: 14px;
    color: #2c3e50;
    font-weight: 600;
}

.tracking-number {
    display: flex;
    align-items: center;
    gap: 8px;
    font-family: monospace;
}

.copy-btn {
    background: none;
    border: none;
    color: #6b7280;
    cursor: pointer;
    padding: 4px;
    border-radius: 4px;
    transition: all 0.2s;
}

.copy-btn:hover {
    background: #e5e7eb;
    color: #2c3e50;
}

/* Items Preview */
.asn-items-preview {
    margin-bottom: 20px;
}

.items-preview-title {
    font-size: 14px;
    font-weight: 700;
    color: #2c3e50;
    margin-bottom: 12px;
    display: flex;
    align-items: center;
    gap: 8px;
}

.items-preview-list {
    background: #f9fafb;
    border-radius: 8px;
    padding: 12px;
    border: 1px solid #e5e7eb;
}

.item-preview-row {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 8px 0;
    border-bottom: 1px solid #e5e7eb;
}

.item-preview-row:last-child {
    border-bottom: none;
}

.item-code {
    font-family: monospace;
    background: white;
    padding: 4px 8px;
    border-radius: 4px;
    font-size: 12px;
    font-weight: 600;
    color: #495057;
}

.item-name {
    flex: 1;
    font-size: 13px;
    color: #2c3e50;
}

.item-qty {
    font-size: 13px;
    font-weight: 600;
    color: #6b7280;
}

.item-preview-more {
    text-align: center;
    padding: 8px;
    font-size: 12px;
    color: #6b7280;
    font-style: italic;
}

/* ASN Notes */
.asn-notes-box {
    background: #fff3cd;
    border-left: 4px solid #ffc107;
    padding: 12px;
    border-radius: 8px;
    margin-bottom: 20px;
    font-size: 13px;
    color: #664d03;
}

/* ASN Actions */
.asn-actions {
    display: flex;
    gap: 12px;
    flex-wrap: wrap;
}

/* Full Details Expansion */
.asn-full-details {
    display: none;
    margin-top: 24px;
    padding: 24px;
    background: #f9fafb;
    border-radius: 12px;
    border: 1px solid #e5e7eb;
}

.asn-full-details.show {
    display: block;
    animation: slideDown 0.3s ease;
}

@media (max-width: 768px) {
    .asn-timeline {
        flex-direction: column;
        gap: 16px;
    }
    
    .asn-timeline::before {
        display: none;
    }
    
    .asn-details-grid {
        grid-template-columns: 1fr;
    }
    
    .asn-actions {
        flex-direction: column;
    }
    
    .asn-actions .btn {
        width: 100%;
    }
}
</style>

<script>
// Filter ASNs by status
function filterASNs(status) {
    const cards = document.querySelectorAll('.asn-card');
    const buttons = document.querySelectorAll('.asn-filter-tabs .tab-button');
    
    // Update active button
    buttons.forEach(btn => btn.classList.remove('active'));
    event.target.closest('.tab-button').classList.add('active');
    
    // Filter cards
    cards.forEach(card => {
        if (status === 'all') {
            card.style.display = 'block';
        } else {
            const cardStatus = card.getAttribute('data-status');
            card.style.display = cardStatus === status ? 'block' : 'none';
        }
    });
}

// Toggle ASN full details
function toggleASNDetails(detailsId) {
    const detailsDiv = document.getElementById('details-' + detailsId);
    const btnText = document.getElementById('btn-text-' + detailsId);
    
    if (detailsDiv.classList.contains('show')) {
        detailsDiv.classList.remove('show');
        btnText.textContent = 'View Full Details';
    } else {
        detailsDiv.classList.add('show');
        btnText.textContent = 'Hide Details';
    }
}

// Copy tracking number
function copyTracking(trackingNumber) {
    navigator.clipboard.writeText(trackingNumber).then(() => {
        showNotification('Tracking number copied!', 'success');
    });
}

// Mark ASN as shipped
function markAsShipped(asnId) {
    if (confirm('Mark this shipment as SENT? This will notify the hospital.')) {
        window.location.href = '${pageContext.request.contextPath}/update-asn-status?asnId=' + asnId + '&status=Sent';
    }
}

// Mark ASN as in transit
function markAsInTransit(asnId) {
    if (confirm('Mark this shipment as IN TRANSIT?')) {
        window.location.href = '${pageContext.request.contextPath}/update-asn-status?asnId=' + asnId + '&status=InTransit';
    }
}

// Cancel ASN
function cancelASN(asnId) {
    const reason = prompt('Please enter the reason for cancellation:');
    if (reason && reason.trim() !== '') {
        window.location.href = '${pageContext.request.contextPath}/cancel-asn?asnId=' + asnId + '&reason=' + encodeURIComponent(reason);
    }
}

// Notification helper
function showNotification(message, type) {
    const notification = document.createElement('div');
    notification.className = 'notification ' + type;
    notification.innerHTML = `
       
        <span>${message}</span>
    `;
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.remove();
    }, 3000);
}
</script>