<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ - PWMS</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            color: #1a1a1a;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            position: relative;
        }

        /* Background Image với overlay */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: url('${pageContext.request.contextPath}/img/anhphongkhamtranghome.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            z-index: -2;
        }

        /* Overlay tối để text dễ đọc hơn */
        body::after {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(0, 0, 0, 0.7) 0%, rgba(0, 0, 0, 0.5) 100%);
            z-index: -1;
        }

        .content-wrapper {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        .container {
            max-width: 900px;
            width: 100%;
            margin: 0 auto;
        }

        .hero-card {
            background: rgba(255, 255, 255, 0.75);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            padding: 60px 50px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        .hero-icon {
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
            margin: 0 auto 30px;
            box-shadow: 0 8px 24px rgba(37, 99, 235, 0.4);
            animation: float 3s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0px);
            }
            50% {
                transform: translateY(-10px);
            }
        }

        .hero-title {
            font-size: 36px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 16px;
            line-height: 1.2;
            text-align: center;
        }

        .hero-subtitle {
            font-size: 18px;
            color: #555;
            margin-bottom: 40px;
            line-height: 1.6;
            text-align: center;
        }

        .guide-section {
            background: rgba(248, 249, 250, 0.7);
            backdrop-filter: blur(8px);
            border-radius: 16px;
            padding: 40px;
            margin-top: 30px;
            text-align: left;
            border: 2px solid rgba(233, 236, 239, 0.4);
        }

        .guide-title {
            font-size: 24px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .guide-title i {
            color: #2563eb;
        }

        .steps-container {
            display: flex;
            flex-direction: column;
            gap: 24px;
        }

        .step-card {
            background: rgba(255, 255, 255, 0.85);
            padding: 24px;
            border-radius: 12px;
            border-left: 4px solid #2563eb;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
        }

        .step-card:hover {
            transform: translateX(4px);
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.12);
            background: rgba(255, 255, 255, 0.95);
        }

        .step-header {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 12px;
        }

        .step-number {
            width: 40px;
            height: 40px;
            background: #2563eb;
            color: #ffffff;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 18px;
            flex-shrink: 0;
        }

        .step-title {
            font-size: 18px;
            font-weight: 600;
            color: #1a1a1a;
        }

        .step-description {
            font-size: 15px;
            color: #555;
            line-height: 1.6;
            margin-left: 56px;
        }

        .step-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-left: 56px;
            margin-top: 12px;
            color: #2563eb;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
        }

        .step-link:hover {
            color: #1d4ed8;
            gap: 12px;
        }

        .cta-buttons {
            display: flex;
            gap: 16px;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 40px;
        }

        .btn {
            padding: 14px 32px;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            border: none;
        }

        .btn-primary {
            background: #2563eb;
            color: #ffffff;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
        }

        .btn-primary:hover {
            background: #1d4ed8;
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(37, 99, 235, 0.5);
        }

        .btn-secondary {
            background: #ffffff;
            color: #2563eb;
            border: 2px solid #2563eb;
        }

        .btn-secondary:hover {
            background: #eff6ff;
            transform: translateY(-2px);
        }

        .info-box {
            background: rgba(239, 246, 255, 0.85);
            border: 2px solid rgba(191, 219, 254, 0.4);
            border-radius: 12px;
            padding: 20px;
            margin-top: 30px;
            display: flex;
            align-items: start;
            gap: 16px;
        }

        .info-icon {
            color: #2563eb;
            font-size: 24px;
            flex-shrink: 0;
            margin-top: 2px;
        }

        .info-content {
            flex: 1;
        }

        .info-title {
            font-weight: 600;
            color: #1e40af;
            margin-bottom: 8px;
            font-size: 16px;
        }

        .info-text {
            color: #1e40af;
            font-size: 14px;
            line-height: 1.6;
        }

        @media (max-width: 768px) {
            .hero-card {
                padding: 40px 30px;
            }

            .hero-title {
                font-size: 28px;
            }

            .guide-section {
                padding: 30px 24px;
            }

            .cta-buttons {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }

            .step-description {
                margin-left: 0;
            }

            .step-link {
                margin-left: 0;
            }
        }
    </style>
</head>
<body>
    <%@ include file="/admin/header.jsp" %>
    
    <div class="content-wrapper">
        <div class="container">
            <div class="hero-card">
                <div class="hero-icon">
                    <i class="fas fa-hospital" style="color: white;"></i>
                </div>
                
                <h1 class="hero-title">Welcome to PWMS</h1>
                <p class="hero-subtitle">Pharmacy Warehouse Management System - Hệ thống quản lý kho dược phẩm</p>
                
                <div class="guide-section">
                    <h2 class="guide-title">
                        <i class="fas fa-rocket"></i>
                        Getting Started Guide
                    </h2>
                    
                    <div class="steps-container">
                        <div class="step-card">
                            <div class="step-header">
                                <div class="step-number">1</div>
                                <div class="step-title">Create Your Account</div>
                            </div>
                            <p class="step-description">
                                If you don't have an account yet, please register to access the system. Fill in your information and create your credentials.
                            </p>
                            <c:if test="${empty sessionScope.user}">
                                <a href="${pageContext.request.contextPath}/register" class="step-link">
                                    Register Now <i class="fas fa-arrow-right"></i>
                                </a>
                            </c:if>
                        </div>
                        
                        <div class="step-card">
                            <div class="step-header">
                                <div class="step-number">2</div>
                                <div class="step-title">Submit a Support Ticket</div>
                            </div>
                            <p class="step-description">
                                After registration, go to the Support section and submit a ticket to request role assignment from the administrator. Include your desired role in the ticket.
                            </p>
                            <a href="${pageContext.request.contextPath}/ticket?action=create" class="step-link">
                                Create Support Ticket <i class="fas fa-arrow-right"></i>
                            </a>
                        </div>
                        
                        <div class="step-card">
                            <div class="step-header">
                                <div class="step-number">3</div>
                                <div class="step-title">Wait for Admin Confirmation</div>
                            </div>
                            <p class="step-description">
                                The administrator will review your request and assign the appropriate role. You'll receive a response through the ticket system once your role is confirmed.
                            </p>
                        </div>
                        
                        <div class="step-card">
                            <div class="step-header">
                                <div class="step-number">4</div>
                                <div class="step-title">Start Using the System</div>
                            </div>
                            <p class="step-description">
                                Once your role is assigned, you can log in and access all features available for your role. Explore the dashboard and manage your tasks efficiently.
                            </p>
                        </div>
                    </div>
                </div>
                
                <div class="info-box">
                    <i class="fas fa-info-circle info-icon"></i>
                    <div class="info-content">
                        <div class="info-title">Need Help?</div>
                        <p class="info-text">
                            If you have any questions or encounter any issues, please don't hesitate to contact us through the Support section. Our team is ready to assist you!
                        </p>
                    </div>
                </div>
                
                <div class="cta-buttons">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <a href="${pageContext.request.contextPath}/ticket?action=create" class="btn btn-primary">
                                <i class="fas fa-ticket-alt"></i>
                                Create Support Ticket
                            </a>
                            <a href="${pageContext.request.contextPath}/ticket?action=list" class="btn btn-secondary">
                                <i class="fas fa-list"></i>
                                View My Tickets
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">
                                <i class="fas fa-user-plus"></i>
                                Register Now
                            </a>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary">
                                <i class="fas fa-sign-in-alt"></i>
                                Login
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
    
    <%@ include file="/admin/footer.jsp" %>
</body>
</html>