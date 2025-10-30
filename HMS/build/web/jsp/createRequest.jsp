<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Medication Request</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html, body {
            height: 100%;
        }

        body {
            display: flex;
            flex-direction: column;
            background-color: #ffffff;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            font-size: 14px;
            line-height: 1.5;
            color: #333;
        }

        .page-wrapper {
            display: flex;
            flex: 1;
            min-height: calc(100vh - 60px);
        }

        /* White theme sidebar with light border, similar to Auditor design */
        .sidebar {
            width: 250px;
            background-color: #ffffff;
            color: #6c757d;
            display: flex;
            flex-direction: column;
            padding-top: 15px;
            border-right: 1px solid #e9ecef;
            box-shadow: none;
        }

        .menu a {
            display: flex;
            align-items: center;
            padding: 12px 25px;
            color: #6c757d;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
            border-radius: 0;
        }

        .menu a i {
            width: 20px;
            margin-right: 10px;
            color: #6c757d;
        }

        .menu a:hover {
            background-color: #f0f7ff;
            color: #495057;
            border-left-color: transparent;
            padding-left: 25px;
        }

        .menu a.active {
            background-color: #e7f1ff;
            color: #0066cc;
            border-left-color: #0066cc;
            padding-left: 22px;
        }

        .menu a.active i {
            color: #0066cc;
        }

        .main {
            flex: 1;
            padding: 30px;
            background-color: #ffffff;
            overflow-y: auto;
        }

        h2 {
            font-size: 28px;
            margin-bottom: 25px;
            font-weight: 700;
            color: #1a1a1a;
            letter-spacing: -0.5px;
        }

        label {
            display: block;
            margin-top: 15px;
            font-weight: 600;
            color: #495057;
            font-size: 14px;
        }

        textarea, input[type="number"], select {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            resize: vertical;
            min-height: 80px;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        textarea:focus, input[type="number"]:focus, select:focus {
            border-color: #6c757d;
            box-shadow: 0 0 0 3px rgba(108, 117, 125, 0.1);
            outline: none;
        }

        .medicine-items {
            margin-top: 20px;
            border: 1px solid #e9ecef;
            padding: 20px;
            border-radius: 8px;
            background-color: #f8f9fa;
        }

        .medicine-items h3 {
            font-size: 16px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 15px;
        }

        .medicine-item {
            display: flex;
            gap: 15px;
            margin-bottom: 15px;
            align-items: center;
            padding: 15px;
            background: white;
            border-radius: 6px;
            border: 1px solid #e0e0e0;
            box-shadow: 0 1px 3px rgba(0,0,0,0.08);
        }

        .medicine-item select {
            flex: 2;
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            width: auto;
            min-height: auto;
        }

        .medicine-item input[type="number"] {
            flex: 1;
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            width: auto;
            min-height: auto;
        }

        /* Gray button styling for remove button */
        .medicine-item button {
            padding: 10px 15px;
            background-color: #6c757d;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            white-space: nowrap;
        }

        .medicine-item button:hover {
            background-color: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(108, 117, 125, 0.2);
        }

        /* Gray button styling for add medicine button */
        .add-medicine-btn {
            margin-top: 15px;
            padding: 10px 20px;
            background-color: #6c757d;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .add-medicine-btn:hover {
            background-color: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(108, 117, 125, 0.2);
        }

        /* Gray button styling for submit button */
        .submit-btn {
            margin-top: 25px;
            padding: 12px 40px;
            background-color: #6c757d;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .submit-btn:hover {
            background-color: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(108, 117, 125, 0.2);
        }

        .error-msg {
            color: #721c24;
            background-color: #f8d7da;
            padding: 15px;
            border-radius: 6px;
            margin-top: 15px;
            border-left: 4px solid #f5c6cb;
            border: 1px solid #f5c6cb;
        }

        /* Modal styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            padding-top: 100px;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.5);
        }

        .modal-content {
            background-color: white;
            margin: auto;
            padding: 30px;
            border: 1px solid #e0e0e0;
            border-radius: 10px;
            width: 90%;
            max-width: 400px;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            animation: slideDown 0.3s ease-out;
        }

        @keyframes slideDown {
            from {
                transform: translateY(-50px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .modal-content h3 {
            color: #1a1a1a;
            margin-top: 0;
            font-size: 24px;
            font-weight: 700;
        }

        .modal-content p {
            color: #6c757d;
            margin: 15px 0;
        }

        .modal-buttons {
            margin-top: 20px;
            display: flex;
            gap: 10px;
            justify-content: center;
        }

        .modal-content button, .modal-content a {
            padding: 12px 25px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            text-decoration: none;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        /* Gray button styling for modal buttons */
        .modal-content button {
            background-color: #6c757d;
            color: white;
        }

        .modal-content button:hover {
            background-color: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(108, 117, 125, 0.2);
        }

        .modal-content a {
            background-color: #e9ecef;
            color: #495057;
            display: inline-block;
        }

        .modal-content a:hover {
            background-color: #dee2e6;
            color: #495057;
        }

        .container {
            max-width: 100%;
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>

    <div class="page-wrapper">
        <div class="sidebar">
            <div class="menu">
                <a href="${pageContext.request.contextPath}/view-medicine"><i class="fa fa-pills"></i> Quản lý thuốc</a>
                <a href="${pageContext.request.contextPath}/create-request" class="active"><i class="fa fa-file-medical"></i> Yêu cầu thuốc</a>
                <a href="${pageContext.request.contextPath}/pharmacist/manage-batch"><i class="fa fa-warehouse"></i> Quản lý số lô/lô hàng</a>
                <a href="${pageContext.request.contextPath}/pharmacist/recordExpiredDamaged"><i class="fa fa-user-md"></i> thuốc hết hạn/hư hỏng</a>
                <a href="${pageContext.request.contextPath}/report"><i class="fa fa-chart-line"></i> Báo cáo thống kê</a>
            </div>
        </div>

        <div class="main">
            <h2>Tạo Yêu Cầu Thuốc Mới</h2>

            <c:if test="${not empty error}">
                <div class="error-msg">❌ ${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/create-request" method="post" id="requestForm">
                <label>Ghi chú:</label>
                <textarea name="notes" placeholder="Nhập ghi chú cho yêu cầu thuốc..."></textarea>

                <div class="medicine-items">
                    <h3>Danh sách thuốc:</h3>
                    <div id="medicineContainer">
                        <!-- Item đầu tiên -->
                        <div class="medicine-item">
                            <select name="medicine_code" required>
                                <option value="">-- Chọn thuốc --</option>
                                <c:forEach var="med" items="${medicines}">
                                    <option value="${med.medicineCode}">${med.displayName}</option>
                                </c:forEach>
                            </select>
                            <input type="number" name="quantity" min="1" placeholder="Số lượng" required>
                            <button type="button" onclick="removeItem(this)">🗑️ Xóa</button>
                        </div>
                    </div>
                    <button type="button" class="add-medicine-btn" onclick="addMedicineItem()">➕ Thêm thuốc</button>
                </div>

                <button type="submit" class="submit-btn">📤 Gửi Yêu Cầu</button>
            </form>
        </div>
    </div>

    <!-- Success Modal -->
    <div id="successModal" class="modal">
        <div class="modal-content">
            <h3>✅ Đặt thuốc thành công!</h3>
            <p>Yêu cầu của bạn đã được ghi nhận.</p>
            <div class="modal-buttons">
                <button onclick="continueOrder()">Đặt thuốc tiếp</button>
                <a href="${pageContext.request.contextPath}/doctor-dashboard">Trở về Dashboard</a>
            </div>
        </div>
    </div>

    <%@ include file="footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Lấy options từ select đầu tiên làm template
        let medicineOptionsHTML = '';
        
        // Chờ DOM load xong
        document.addEventListener('DOMContentLoaded', function() {
            const firstSelect = document.querySelector('select[name="medicine_code"]');
            if (firstSelect) {
                medicineOptionsHTML = firstSelect.innerHTML;
            }
        });

        // Thêm medicine item mới
        function addMedicineItem() {
            const container = document.getElementById('medicineContainer');
            const newItem = document.createElement('div');
            newItem.className = 'medicine-item';
            newItem.innerHTML = `
                <select name="medicine_code" required>
                    ` + medicineOptionsHTML + `
                </select>
                <input type="number" name="quantity" min="1" placeholder="Số lượng" required>
                <button type="button" onclick="removeItem(this)">Xóa</button>
            `;
            container.appendChild(newItem);
        }

        // Xóa medicine item
        function removeItem(button) {
            const container = document.getElementById('medicineContainer');
            const items = container.getElementsByClassName('medicine-item');
            
            if (items.length <= 1) {
                alert('Phải có ít nhất 1 thuốc trong yêu cầu!');
                return;
            }
            
            button.parentElement.remove();
        }

        // Đóng modal và reset form
        function continueOrder() {
            document.getElementById('successModal').style.display = 'none';
            document.getElementById('requestForm').reset();
            
            const container = document.getElementById('medicineContainer');
            container.innerHTML = `
                <div class="medicine-item">
                    <select name="medicine_code" required>
                        ` + medicineOptionsHTML + `
                    </select>
                    <input type="number" name="quantity" min="1" placeholder="Số lượng" required>
                    <button type="button" onclick="removeItem(this)">Xóa</button>
                </div>
            `;
        }

        // Hiển thị modal khi thành công
        <c:if test="${not empty success}">
            document.addEventListener('DOMContentLoaded', function() {
                document.getElementById('successModal').style.display = 'block';
            });
        </c:if>

        // Đóng modal khi click bên ngoài
        window.onclick = function(event) {
            const modal = document.getElementById('successModal');
            if (event.target === modal) {
                continueOrder();
            }
        }
    </script>
</body>
</html>