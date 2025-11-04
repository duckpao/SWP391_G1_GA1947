<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    .ticket-notification-wrapper {
        position: relative;
        display: inline-block;
    }
    
    .ticket-notification-badge {
        position: absolute;
        top: -8px;
        right: -8px;
        background: #dc3545;
        color: white;
        border-radius: 10px;
        padding: 2px 6px;
        font-size: 11px;
        font-weight: 700;
        min-width: 18px;
        height: 18px;
        display: none; /* Hidden by default */
        align-items: center;
        justify-content: center;
        border: 2px solid white;
        box-shadow: 0 2px 4px rgba(220, 53, 69, 0.3);
        animation: pulse 2s infinite;
        z-index: 10;
    }
    
    @keyframes pulse {
        0%, 100% {
            transform: scale(1);
        }
        50% {
            transform: scale(1.1);
        }
    }
</style>

<c:if test="${not empty sessionScope.user}">
    <!-- Wrap your ticket button/link with this wrapper -->
    <!-- Example usage: -->
    <!-- 
    <div class="ticket-notification-wrapper">
        <a href="ticket?action=list" class="nav-link">
            <i class="fas fa-ticket-alt"></i> Tickets
        </a>
        <span id="ticketBadge" class="ticket-notification-badge"></span>
    </div>
    -->
    
    <script>
        // Function to update ticket count
        function updateTicketCount() {
            fetch('/HMS/ticket-count')
                .then(response => response.json())
                .then(data => {
                    const badge = document.getElementById('ticketBadge');
                    if (badge && data.count > 0) {
                        badge.textContent = data.count > 99 ? '99+' : data.count;
                        badge.style.display = 'flex';
                    } else if (badge) {
                        badge.style.display = 'none';
                    }
                })
                .catch(error => console.error('Error fetching ticket count:', error));
        }
        
        // Update on page load
        document.addEventListener('DOMContentLoaded', function() {
            updateTicketCount();
        });
        
        // Update every 30 seconds
        setInterval(updateTicketCount, 30000);
    </script>
</c:if>