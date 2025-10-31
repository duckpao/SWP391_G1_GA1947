<%-- 
    Header component for PWMS
    Encoding: UTF-8
--%>
<!-- Bootstrap CSS -->

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    .main-header {
        background: #ffffff;
        border-bottom: 1px solid #e9ecef;
        padding: 0;
        position: sticky;
        top: 0;
        z-index: 1000;
        box-shadow: 0 1px 3px rgba(0,0,0,0.02);
    }
    
    .header-container {
        max-width: 1400px;
        margin: 0 auto;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 20px 24px;
    }
    
    .header-logo {
        display: flex;
        align-items: center;
        gap: 12px;
        text-decoration: none;
        color: #2c3e50;
        transition: opacity 0.3s;
    }
    
    .header-logo:hover {
        opacity: 0.8;
    }
    
    .logo-icon {
        font-size: 28px;
    }
    
    .logo-text {
        display: flex;
        flex-direction: column;
    }
    
    .logo-title {
        font-size: 18px;
        font-weight: 700;
        color: #2c3e50;
        line-height: 1.2;
    }
    
    .logo-subtitle {
        font-size: 10px;
        color: #868e96;
        font-weight: 500;
        letter-spacing: 0.3px;
        text-transform: uppercase;
    }
    
    .header-nav {
        display: flex;
        align-items: center;
        gap: 12px;
    }
    
    .nav-btn {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 10px 20px;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
        text-decoration: none;
        transition: all 0.3s ease;
        border: 2px solid transparent;
    }
    
    .nav-btn-chat {
        background: #495057;
        color: white;
        border-color: #343a40;
    }
    
    .nav-btn-chat:hover {
        background: #343a40;
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(52, 58, 64, 0.2);
    }
    
    .nav-btn-logout {
        background: #dc3545;
        color: white;
        border-color: #c82333;
    }
    
    .nav-btn-logout:hover {
        background: #c82333;
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(220, 53, 69, 0.2);
    }
    
    .nav-btn-profile {
        background: #f8f9fa;
        color: #495057;
        border-color: #dee2e6;
        padding: 8px 16px;
    }
    
    .nav-btn-profile:hover {
        background: #e9ecef;
        border-color: #adb5bd;
        transform: translateY(-1px);
    }
    
    .user-avatar {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        background: #495057;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: 700;
        font-size: 13px;
    }
    
    .user-details {
        display: flex;
        flex-direction: column;
    }
    
    .user-name {
        font-size: 13px;
        font-weight: 600;
        color: #2c3e50;
        line-height: 1.2;
    }
    
    .user-role {
        font-size: 11px;
        color: #868e96;
        font-weight: 500;
    }
    
    @media (max-width: 768px) {
        .header-container {
            padding: 12px 16px;
        }
        
        .logo-text {
            display: none;
        }
        
        .nav-btn {
            padding: 8px 16px;
            font-size: 13px;
        }
        
        .nav-btn span {
            display: none;
        }
        
        .nav-btn-profile .user-details {
            display: none;
        }
    }
</style>


<header class="main-header">
    <div class="header-container">

        <%-- Dynamic logo redirect based on user role --%>
        <c:choose>
            <c:when test="${sessionScope.user.role == 'Admin'}">
                <a href="/HMS/admin-dashboard" class="header-logo">
            </c:when>
            <c:when test="${sessionScope.user.role == 'Doctor'}">
                <a href="/HMS/doctor-dashboard" class="header-logo">
            </c:when>
            <c:when test="${sessionScope.user.role == 'Pharmacist'}">
                <a href="/HMS/pharmacist-dashboard" class="header-logo">
            </c:when>
            <c:when test="${sessionScope.user.role == 'Manager'}">
                <a href="/HMS/manager-dashboard" class="header-logo">
            </c:when>
            <c:when test="${sessionScope.user.role == 'Auditor'}">
                <a href="/HMS/auditor-dashboard" class="header-logo">
            </c:when>
            <c:when test="${sessionScope.user.role == 'Supplier'}">
                <a href="/HMS/supplierDashboard" class="header-logo">
            </c:when>
            <c:otherwise>
                <a href="home" class="header-logo">
            </c:otherwise>
        </c:choose>

            <div class="logo-text">
                <span class="logo-title">PWMS</span>
                <span class="logo-subtitle">Pharmacy Warehouse Management</span>
            </div>
        </a>

        <div class="header-nav">
    <c:if test="${not empty sessionScope.user}">
        
        <%-- Thêm Notification Badge ? ?ây --%>
        <%@ include file="/notif/notification-badge.jsp" %>
        
        <c:if test="${sessionScope.user.role == 'Admin'}">
            <a href="/HMS/admin-dashboard" 
               class="nav-btn" 
               style="background:#6c757d;color:#fff;border-color:#5a6268;">
                <i class="fas fa-tachometer-alt"></i>
                <span>Admin Dashboard</span>
            </a>
        </c:if>

        <a href="/HMS/chat" class="nav-btn nav-btn-chat">
            <i class="fas fa-comments"></i>
            <span>Chat</span>
        </a>
        
        <a href="/HMS/logout" class="nav-btn nav-btn-logout">
            <i class="fas fa-sign-out-alt"></i>
            <span>Logout</span>
        </a>
        
        <a href="/HMS/profile" class="nav-btn nav-btn-profile">
            <div class="user-avatar">
                ${sessionScope.user.username.substring(0, 1).toUpperCase()}
            </div>
            <div class="user-details">
                <span class="user-name">${sessionScope.user.username}</span>
                <span class="user-role">${sessionScope.user.role}</span>
            </div>
        </a>
    </c:if>
</div>
    </div>
</header>