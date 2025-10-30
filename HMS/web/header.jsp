<%-- 
    Header component for PWMS
    Encoding: UTF-8
--%>
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
    
    .nav-btn-profile {
        background: #f8f9fa;
        color: #495057;
        border-color: #dee2e6;
    }
    
    .nav-btn-profile:hover {
        background: #e9ecef;
        border-color: #adb5bd;
        transform: translateY(-1px);
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
    
    .user-info {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 8px 16px;
        background: #f8f9fa;
        border-radius: 8px;
        border: 1px solid #dee2e6;
        margin-right: 12px;
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
        
        .user-info {
            display: none;
        }
        
        .nav-btn {
            padding: 8px 16px;
            font-size: 13px;
        }
        
        .nav-btn span {
            display: none;
        }
    }
</style>

<header class="main-header">
    <div class="header-container">
        <a href="javascript:history.back()" class="header-logo">
            <span class="logo-icon">?</span>
            <div class="logo-text">
                <span class="logo-title">PWMS</span>
                <span class="logo-subtitle">Pharmacy Warehouse Management</span>
            </div>
        </a>
        
        <div class="header-nav">
            <c:if test="${not empty sessionScope.user}">
                <div class="user-info">
                    <div class="user-avatar">
                        ${sessionScope.user.username.substring(0, 1).toUpperCase()}
                    </div>
                    <div class="user-details">
                        <span class="user-name">${sessionScope.user.username}</span>
                        <span class="user-role">${sessionScope.user.role}</span>
                    </div>
                </div>
                
                <a href="profile" class="nav-btn nav-btn-profile">
                    <i class="fas fa-user"></i>
                    <span>Profile</span>
                </a>
                
                <a href="chat" class="nav-btn nav-btn-chat">
                    <i class="fas fa-comments"></i>
                    <span>Chat</span>
                </a>
            </c:if>
        </div>
    </div>
</header>