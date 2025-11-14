<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Sidebar Component -->
<div class="sidebar">
    <div class="menu">
        <!-- Quản lý thuốc - Hiển thị cho tất cả roles -->
        <a href="${pageContext.request.contextPath}/view-medicine" 
           class="${pageParam == 'view-medicine' ? 'active' : ''}">
            <i class="bi bi-capsule"></i> Quản lý thuốc
        </a>

        <!-- Yêu cầu thuốc (Doctor) - Chỉ Doctor và Admin -->
        <c:if test="${sessionScope.role eq 'Doctor' or sessionScope.role eq 'Admin'}">
            <a href="${pageContext.request.contextPath}/create-request"
               class="${pageParam == 'create-request' ? 'active' : ''}">
                <i class="bi bi-file-earmark-plus"></i> Yêu cầu thuốc (Doctor)
            </a>
        </c:if>

        <!-- Các chức năng Pharmacist - Chỉ Pharmacist và Admin -->
        <c:if test="${sessionScope.role eq 'Pharmacist' or sessionScope.role eq 'Admin'}">
            <a href="${pageContext.request.contextPath}/pharmacist/View_MedicineRequest"
               class="${pageParam == 'medicine-request' ? 'active' : ''}">
                <i class="bi bi-file-earmark-text"></i> Yêu cầu thuốc (Pharmacist)
            </a>
            
            <a href="${pageContext.request.contextPath}/pharmacist/view-order-details"
               class="${pageParam == 'order-details' ? 'active' : ''}">
                <i class="bi bi-box-seam"></i> Đơn hàng đã giao
            </a>
            
            <a href="${pageContext.request.contextPath}/pharmacist/manage-batch"
               class="${pageParam == 'manage-batch' ? 'active' : ''}">
                <i class="bi bi-layers"></i> Quản lý số lô/lô hàng
            </a>
            
            <a href="${pageContext.request.contextPath}/pharmacist/recordExpiredDamaged"
               class="${pageParam == 'expired-damaged' ? 'active' : ''}">
                <i class="bi bi-exclamation-triangle"></i> Thuốc hết hạn/hư hỏng
            </a>
        </c:if>
    </div>
</div>

<!-- CSS được load từ file sidebar.css -->