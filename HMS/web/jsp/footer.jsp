<%-- 
    Footer component for PWMS
    Encoding: UTF-8
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
    .main-footer {
        background: #ffffff;
        border-top: 1px solid #e9ecef;
        margin-top: 60px;
        padding: 50px 0 30px;
    }
    
    .footer-container {
        max-width: 1400px;
        margin: 0 auto;
        padding: 0 24px;
    }
    
    .footer-content {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 40px;
        margin-bottom: 30px;
    }
    
    .footer-section h3 {
        color: #2c3e50;
        font-size: 15px;
        font-weight: 700;
        margin-bottom: 18px;
        display: flex;
        align-items: center;
        gap: 8px;
        text-transform: uppercase;
        letter-spacing: 0.3px;
    }
    
    .footer-section p, .footer-section li {
        color: #868e96;
        font-size: 13px;
        line-height: 1.8;
        margin-bottom: 8px;
    }
    
    .footer-section ul {
        list-style: none;
        padding: 0;
    }
    
    .footer-section a {
        color: #868e96;
        text-decoration: none;
        transition: color 0.3s;
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 13px;
    }
    
    .footer-section a:hover {
        color: #2c3e50;
    }
    
    .contact-item {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-bottom: 12px;
    }
    
    .contact-icon {
        width: 36px;
        height: 36px;
        background: #f8f9fa;
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #495057;
        border: 1px solid #dee2e6;
    }
    
    .footer-brand {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-bottom: 16px;
    }
    
    .footer-brand-icon {
        font-size: 24px;
    }
    
    .footer-brand-text {
        font-size: 16px;
        font-weight: 700;
        color: #2c3e50;
    }
    
    .footer-bottom {
        border-top: 1px solid #e9ecef;
        padding-top: 20px;
        text-align: center;
    }
    
    .footer-bottom p {
        color: #868e96;
        font-size: 12px;
        margin: 0;
    }
    
    .footer-links {
        display: flex;
        justify-content: center;
        gap: 20px;
        margin-top: 12px;
    }
    
    .footer-links a {
        color: #868e96;
        font-size: 12px;
        text-decoration: none;
        transition: color 0.3s;
    }
    
    .footer-links a:hover {
        color: #2c3e50;
    }
    
    .social-links {
        display: flex;
        gap: 12px;
        margin-top: 16px;
    }
    
    .social-btn {
        width: 40px;
        height: 40px;
        background: #f8f9fa;
        border: 1px solid #dee2e6;
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #495057;
        text-decoration: none;
        transition: all 0.3s;
    }
    
    .social-btn:hover {
        background: #495057;
        color: white;
        border-color: #495057;
        transform: translateY(-2px);
    }
    
    @media (max-width: 768px) {
        .footer-content {
            grid-template-columns: 1fr;
            gap: 30px;
        }
        
        .footer-links {
            flex-direction: column;
            gap: 10px;
        }
    }
</style>

<footer class="main-footer">
    <div class="footer-container">
        <div class="footer-content">
            <!-- About Section -->
            <div class="footer-section">
                <div class="footer-brand">
                    <span class="footer-brand-icon">?</span>
                    <span class="footer-brand-text">PWMS</span>
                </div>
                <p>
                    Modern pharmacy warehouse management system, helping to optimize 
                    medicine and medical supply management processes efficiently and safely.
                </p>
                <div class="social-links">
                    <a href="#" class="social-btn" title="Facebook">
                        <i class="fab fa-facebook-f"></i>
                    </a>
                    <a href="#" class="social-btn" title="Twitter">
                        <i class="fab fa-twitter"></i>
                    </a>
                    <a href="#" class="social-btn" title="LinkedIn">
                        <i class="fab fa-linkedin-in"></i>
                    </a>
                    <a href="#" class="social-btn" title="Instagram">
                        <i class="fab fa-instagram"></i>
                    </a>
                </div>
            </div>
            
            <!-- Quick Links Section -->
            <div class="footer-section">
                <h3><i class="fas fa-link"></i> Quick Links</h3>
                <ul>
                    <li><a href="profile"><i class="fas fa-user"></i> My Profile</a></li>
                    <li><a href="chat"><i class="fas fa-comments"></i> Chat Support</a></li>
                    <li><a href="#"><i class="fas fa-file-alt"></i> User Guide</a></li>
                    <li><a href="#"><i class="fas fa-question-circle"></i> FAQ</a></li>
                </ul>
            </div>
            
            <!-- Contact Section -->
            <div class="footer-section">
                <h3><i class="fas fa-envelope"></i> Contact</h3>
                <div class="contact-item">
                    <div class="contact-icon">
                        <i class="fas fa-envelope"></i>
                    </div>
                    <div>
                        <strong>Email</strong><br>
                        <a href="mailto:admin@example.com">admin@example.com</a>
                    </div>
                </div>
                <div class="contact-item">
                    <div class="contact-icon">
                        <i class="fas fa-phone"></i>
                    </div>
                    <div>
                        <strong>Phone</strong><br>
                        <a href="tel:+84987654321">+84 987 654 321</a>
                    </div>
                </div>
                <div class="contact-item">
                    <div class="contact-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div>
                        <strong>Working Hours</strong><br>
                        Monday - Friday: 8:00 AM - 5:00 PM
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Footer Bottom -->
        <div class="footer-bottom">
            <p>
                &copy; 2025 Pharmacy Warehouse Management System. All rights reserved.
            </p>
            <div class="footer-links">
                <a href="#">Privacy Policy</a>
                <a href="#">Terms of Service</a>
                <a href="#">Data Security</a>
            </div>
        </div>
    </div>
</footer>