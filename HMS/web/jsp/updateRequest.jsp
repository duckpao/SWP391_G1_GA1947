<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Medicine Request</title>
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
            padding: 30px 20px;
        }
        
        .container {
            max-width: 900px;
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
            font-size: 32px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .content {
            padding: 30px;
        }
        
        /* Alert Messages */
        .alert {
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 25px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }
        
        /* Form Styles */
        .form-section {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 25px;
            border: 2px solid #e0e0e0;
        }
        
        .section-title {
            font-size: 20px;
            color: #333;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            color: #555;
            font-size: 14px;
        }
        
        .form-group input[type="text"],
        .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #ddd;
            border-radius: 10px;
            font-size: 14px;
            font-family: inherit;
            transition: border-color 0.3s;
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 80px;
        }
        
        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
        }
        
        /* Medicine Items */
        .medicine-items-list {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .medicine-item {
            background: white;
            padding: 20px;
            border-radius: 12px;
            border: 2px solid #e0e0e0;
            transition: all 0.3s;
        }
        
        .medicine-item:hover {
            border-color: #667eea;
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.1);
        }
        
        .medicine-item-header {
            font-weight: 600;
            color: #667eea;
            margin-bottom: 15px;
            font-size: 15px;
        }
        
        .medicine-row {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 15px;
            align-items: start;
        }
        
        .medicine-item select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #ddd;
            border-radius: 10px;
            font-size: 14px;
            background: white;
            cursor: pointer;
            transition: border-color 0.3s;
        }
        
        .medicine-item select:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .medicine-item input[type="number"] {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #ddd;
            border-radius: 10px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        .medicine-item input[type="number"]:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .field-label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #666;
            margin-bottom: 8px;
        }
        
        /* Buttons */
        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 14px 30px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 600;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            justify-content: center;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            flex: 1;
            min-width: 150px;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
            flex: 1;
            min-width: 150px;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
        
        /* Info Box */
        .info-box {
            background: #e7f3ff;
            border-left: 4px solid #2196F3;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            color: #0d47a1;
            font-size: 14px;
        }
        
        .info-box strong {
            display: block;
            margin-bottom: 5px;
        }
        
        @media (max-width: 768px) {
            .content {
                padding: 20px;
            }
            
            .medicine-row {
                grid-template-columns: 1fr;
            }
            
            .button-group {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>✏️ Cập Nhật Yêu Cầu Thuốc</h1>
        </div>
        
        <div class="content">
            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    ⚠️ ${error}
                </div>
            </c:if>
            
            <!-- Info Box -->
            <div class="info-box">
                <strong>📋 Request ID: #${request.requestId}</strong>
                Please update the information below and click the Update button to save changes.
            </div>
            
            <!-- Update Form -->
            <form action="update-request" method="post">
                <input type="hidden" name="requestId" value="${request.requestId}">
                
                <!-- Notes Section -->
                <div class="form-section">
                    <h2 class="section-title">📝 Ghi Chú</h2>
                    <div class="form-group">
                        <label for="notes">Notes / Remarks</label>
                        <textarea id="notes" 
                                  name="notes" 
                                  placeholder="Enter any notes or remarks about this request..."
                                  required>${request.notes}</textarea>
                    </div>
                </div>
                
                <!-- Medicine Items Section -->
                <div class="form-section">
                    <h2 class="section-title">💊 Danh Sách Thuốc</h2>
                    <div class="medicine-items-list">
                        <c:forEach var="item" items="${items}" varStatus="loop">
                            <div class="medicine-item">
                                <div class="medicine-item-header">
                                    Medicine #${loop.index + 1}
                                </div>
                                <div class="medicine-row">
                                    <div>
                                        <label class="field-label">Medicine Name</label>
                                        <select name="medicine_id" required>
                                            <option value="">-- Select Medicine --</option>
                                            <c:forEach var="med" items="${medicines}">
                                                <option value="${med.medicineId}" 
                                                        ${item.medicineId == med.medicineId ? 'selected' : ''}>
                                                    ${med.name}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div>
                                        <label class="field-label">Quantity</label>
                                        <input type="number" 
                                               name="quantity" 
                                               value="${item.quantity}" 
                                               min="1" 
                                               placeholder="0"
                                               required>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                
                <!-- Action Buttons -->
                <div class="button-group">
                    <button type="submit" class="btn btn-primary">
                        💾 Cập Nhật
                    </button>
                    <a href="manage-requests" class="btn btn-secondary">
                        ❌ Hủy Bỏ
                    </a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>