<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Medication Request</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 40px 20px;
        }
        
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .header h1 {
            font-size: 28px;
            font-weight: 700;
        }
        
        .form-content {
            padding: 40px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-group label {
            display: block;
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            font-size: 15px;
        }
        
        .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 14px;
            font-family: inherit;
            transition: border-color 0.3s;
            resize: vertical;
            min-height: 100px;
        }
        
        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .medicine-section {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 25px;
        }
        
        .medicine-section h3 {
            color: #333;
            margin-bottom: 20px;
            font-size: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .medicine-item {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 15px;
            border: 2px solid #e0e0e0;
        }
        
        .medicine-item-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .medicine-item-header h4 {
            color: #667eea;
            font-size: 16px;
        }
        
        .btn-remove {
            background: #dc3545;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 13px;
            transition: all 0.3s;
        }
        
        .btn-remove:hover {
            background: #c82333;
            transform: scale(1.05);
        }
        
        .input-group {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 15px;
        }
        
        .input-group select,
        .input-group input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        .input-group select:focus,
        .input-group input:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .btn-add-medicine {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
        }
        
        .btn-add-medicine:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(79, 172, 254, 0.4);
        }
        
        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            border-left: 4px solid #dc3545;
        }
        
        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        
        .btn {
            flex: 1;
            padding: 15px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-submit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-submit:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
        }
        
        .btn-back {
            background: #6c757d;
            color: white;
        }
        
        .btn-back:hover {
            background: #5a6268;
            transform: translateY(-3px);
        }
        
        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(5px);
        }
        
        .modal-content {
            background: white;
            margin: 10% auto;
            padding: 40px;
            border-radius: 20px;
            width: 90%;
            max-width: 500px;
            text-align: center;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            animation: slideIn 0.3s ease;
        }
        
        @keyframes slideIn {
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
            color: #28a745;
            font-size: 28px;
            margin-bottom: 20px;
        }
        
        .modal-icon {
            font-size: 60px;
            margin-bottom: 20px;
        }
        
        .modal-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }
        
        .modal-buttons button,
        .modal-buttons a {
            flex: 1;
            padding: 12px 25px;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        
        .btn-continue {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-continue:hover {
            transform: scale(1.05);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
        }
        
        .btn-dashboard {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
        }
        
        .btn-dashboard:hover {
            transform: scale(1.05);
            box-shadow: 0 10px 25px rgba(245, 87, 108, 0.4);
        }
        
        @media (max-width: 768px) {
            .input-group {
                grid-template-columns: 1fr;
            }
            
            .button-group {
                flex-direction: column;
            }
            
            .modal-buttons {
                flex-direction: column;
            }
            
            .form-content {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📝 Create Medication Request</h1>
        </div>
        
        <div class="form-content">
            <c:if test="${not empty error}">
                <div class="error-message">
                    ⚠️ ${error}
                </div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/create-request" method="post" id="requestForm">
                <div class="form-group">
                    <label for="notes">📋 Notes / Additional Information</label>
                    <textarea name="notes" id="notes" placeholder="Enter any additional notes or special instructions..."></textarea>
                </div>
                
                <div class="medicine-section">
                    <h3>💊 Select Medicines</h3>
                    
                    <div id="medicineList">
                        <div class="medicine-item">
                            <div class="medicine-item-header">
                                <h4>Medicine #1</h4>
                            </div>
                            <div class="input-group">
                                <select name="medicine_id" required>
                                    <option value="">-- Select Medicine --</option>
                                    <c:forEach var="med" items="${medicines}">
                                        <option value="${med.medicineId}">${med.name} (${med.category})</option>
                                    </c:forEach>
                                </select>
                                <input type="number" name="quantity" min="1" placeholder="Quantity" required>
                            </div>
                        </div>
                    </div>
                    
                    <button type="button" class="btn-add-medicine" onclick="addMedicine()">
                        ➕ Add Another Medicine
                    </button>
                </div>
                
                <div class="button-group">
                    <button type="submit" class="btn btn-submit">✅ Submit Request</button>
                    <a href="doctor-dashboard" class="btn btn-back">🔙 Back to Dashboard</a>
                </div>
            </form>
        </div>
    </div>
    
    <!-- Success Modal -->
    <div id="successModal" class="modal">
        <div class="modal-content">
            <div class="modal-icon">✅</div>
            <h3>Request Created Successfully!</h3>
            <p style="color: #666; margin-top: 15px;">Your medication request has been submitted and is pending approval.</p>
            <div class="modal-buttons">
                <button onclick="closeModal()" class="btn-continue">Create Another Request</button>
                <a href="doctor-dashboard" class="btn-dashboard">Back to Dashboard</a>
            </div>
        </div>
    </div>
    
    <script>
        let medicineCount = 1;
        
        function addMedicine() {
            medicineCount++;
            const medicineList = document.getElementById('medicineList');
            const newItem = document.createElement('div');
            newItem.className = 'medicine-item';
            newItem.innerHTML = `
                <div class="medicine-item-header">
                    <h4>Medicine #${medicineCount}</h4>
                    <button type="button" class="btn-remove" onclick="removeMedicine(this)">🗑️ Remove</button>
                </div>
                <div class="input-group">
                    <select name="medicine_id" required>
                        <option value="">-- Select Medicine --</option>
                        <c:forEach var="med" items="${medicines}">
                            <option value="${med.medicineId}">${med.name} (${med.category})</option>
                        </c:forEach>
                    </select>
                    <input type="number" name="quantity" min="1" placeholder="Quantity" required>
                </div>
            `;
            medicineList.appendChild(newItem);
        }
        
        function removeMedicine(button) {
            const item = button.closest('.medicine-item');
            item.remove();
            updateMedicineNumbers();
        }
        
        function updateMedicineNumbers() {
            const items = document.querySelectorAll('.medicine-item');
            items.forEach((item, index) => {
                item.querySelector('h4').textContent = `Medicine #${index + 1}`;
            });
            medicineCount = items.length;
        }
        
        function closeModal() {
            document.getElementById("successModal").style.display = "none";
            document.getElementById("requestForm").reset();
            // Reset to one medicine item
            const medicineList = document.getElementById('medicineList');
            medicineList.innerHTML = `
                <div class="medicine-item">
                    <div class="medicine-item-header">
                        <h4>Medicine #1</h4>
                    </div>
                    <div class="input-group">
                        <select name="medicine_id" required>
                            <option value="">-- Select Medicine --</option>
                            <c:forEach var="med" items="${medicines}">
                                <option value="${med.medicineId}">${med.name} (${med.category})</option>
                            </c:forEach>
                        </select>
                        <input type="number" name="quantity" min="1" placeholder="Quantity" required>
                    </div>
                </div>
            `;
            medicineCount = 1;
        }
        
        <% if (request.getAttribute("success") != null) { %>
            document.addEventListener("DOMContentLoaded", function() {
                document.getElementById("successModal").style.display = "block";
            });
        <% } %>
    </script>
</body>
</html>