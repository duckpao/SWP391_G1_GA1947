<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Medication Request</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h2 {
            color: #333;
            border-bottom: 3px solid #4CAF50;
            padding-bottom: 10px;
        }
        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
            color: #555;
        }
        textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            resize: vertical;
            min-height: 80px;
            font-family: Arial, sans-serif;
        }
        .medicine-items {
            margin-top: 20px;
            border: 2px solid #e0e0e0;
            padding: 20px;
            border-radius: 8px;
            background-color: #fafafa;
        }
        .medicine-item {
            display: flex;
            gap: 15px;
            margin-bottom: 15px;
            align-items: center;
            padding: 15px;
            background: white;
            border-radius: 5px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        .medicine-item select {
            flex: 2;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        .medicine-item input[type="number"] {
            flex: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        .medicine-item button {
            padding: 10px 15px;
            background-color: #f44336;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
        }
        .medicine-item button:hover {
            background-color: #da190b;
        }
        .add-medicine-btn {
            margin-top: 15px;
            padding: 10px 20px;
            background-color: #2196F3;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
        }
        .add-medicine-btn:hover {
            background-color: #0b7dda;
        }
        .submit-btn {
            margin-top: 25px;
            padding: 12px 40px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
        }
        .submit-btn:hover {
            background-color: #45a049;
        }
        .error-msg {
            color: #f44336;
            background-color: #ffebee;
            padding: 15px;
            border-radius: 5px;
            margin-top: 15px;
            border-left: 4px solid #f44336;
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
            border: 2px solid #4CAF50;
            border-radius: 10px;
            width: 90%;
            max-width: 400px;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
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
            color: #4CAF50;
            margin-top: 0;
            font-size: 24px;
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
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            text-decoration: none;
            font-size: 14px;
        }
        .modal-content button {
            background-color: #4CAF50;
            color: white;
        }
        .modal-content button:hover {
            background-color: #45a049;
        }
        .modal-content a {
            background-color: #2196F3;
            color: white;
            display: inline-block;
        }
        .modal-content a:hover {
            background-color: #0b7dda;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>🏥 Tạo Yêu Cầu Thuốc Mới</h2>
        
        <c:if test="${not empty error}">
            <div class="error-msg">❌ ${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/create-request" method="post" id="requestForm">
            <label>📝 Ghi chú:</label>
            <textarea name="notes" placeholder="Nhập ghi chú cho yêu cầu thuốc..."></textarea>

            <div class="medicine-items">
                <h3>💊 Danh sách thuốc:</h3>
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

            <button type="submit" class="submit-btn">✅ Gửi Yêu Cầu</button>
        </form>
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

    <script>
        // Template HTML cho medicine item
        const medicineOptions = `
            <option value="">-- Chọn thuốc --</option>
            <c:forEach var="med" items="${medicines}">
                <option value="${med.medicineCode}">${med.displayName}</option>
            </c:forEach>
        `;

        // Thêm medicine item mới
        function addMedicineItem() {
            const container = document.getElementById('medicineContainer');
            const newItem = document.createElement('div');
            newItem.className = 'medicine-item';
            newItem.innerHTML = `
                <select name="medicine_code" required>
                    ${medicineOptions}
                </select>
                <input type="number" name="quantity" min="1" placeholder="Số lượng" required>
                <button type="button" onclick="removeItem(this)">🗑️ Xóa</button>
            `;
            container.appendChild(newItem);
        }

        // Xóa medicine item
        function removeItem(button) {
            const container = document.getElementById('medicineContainer');
            const items = container.getElementsByClassName('medicine-item');
            
            // Không cho xóa nếu chỉ còn 1 item
            if (items.length <= 1) {
                alert('Phải có ít nhất 1 thuốc trong yêu cầu!');
                return;
            }
            
            button.parentElement.remove();
        }

        // Đóng modal và reset form
        function continueOrder() {
            document.getElementById('successModal').style.display = 'none';
            
            // Reset form
            document.getElementById('requestForm').reset();
            
            // Reset về 1 medicine item
            const container = document.getElementById('medicineContainer');
            container.innerHTML = `
                <div class="medicine-item">
                    <select name="medicine_code" required>
                        ${medicineOptions}
                    </select>
                    <input type="number" name="quantity" min="1" placeholder="Số lượng" required>
                    <button type="button" onclick="removeItem(this)">🗑️ Xóa</button>
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