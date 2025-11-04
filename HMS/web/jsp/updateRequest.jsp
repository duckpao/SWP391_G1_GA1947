<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập Nhật Yêu Cầu Thuốc</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background: #f9fafb;
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
        }

        .header {
            background: white;
            padding: 25px 30px;
            border-radius: 15px;
            margin-bottom: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            border-bottom: 4px solid #3b82f6;
        }

        .header h1 {
            color: #1f2937;
            font-size: 26px;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-weight: bold;
        }

        .form-container {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            color: #1f2937;
            font-weight: bold;
            margin-bottom: 8px;
            font-size: 15px;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 15px;
            font-family: Arial, sans-serif;
        }

        .form-control:focus {
            outline: none;
            border-color: #3b82f6;
        }

        .medicine-list {
            margin-top: 10px;
        }

        .medicine-item {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 15px;
            border-left: 4px solid #3b82f6;
        }

        .medicine-item-header {
            font-weight: bold;
            color: #3b82f6;
            margin-bottom: 12px;
            font-size: 16px;
        }

        .medicine-row {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 15px;
            align-items: end;
        }

        select.form-control {
            cursor: pointer;
        }

        input[type="number"].form-control {
            text-align: center;
        }

        .btn-submit {
            width: 100%;
            padding: 15px;
            background: #28a745;
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            margin-top: 10px;
        }

        .btn-submit:hover {
            background: #218838;
        }

        .back-link {
            background: white;
            padding: 20px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .back-link a {
            display: inline-block;
            background: #6c757d;
            color: white;
            padding: 12px 30px;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
        }

        .back-link a:hover {
            background: #5a6268;
        }

        .field-label {
            display: block;
            font-size: 13px;
            color: #666;
            margin-bottom: 5px;
            font-weight: normal;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>✏️ Cập Nhật Yêu Cầu Thuốc</h1>
        </div>

        <c:if test="${not empty error}">
            <div class="alert-error">
                ❌ ${error}
            </div>
        </c:if>

        <div class="form-container">
            <form action="update-request" method="post">
                <input type="hidden" name="requestId" value="${request.requestId}">
                
                <div class="form-group">
                    <label>📝 Ghi chú yêu cầu:</label>
                    <input type="text" 
                           name="notes" 
                           class="form-control" 
                           value="${request.notes}" 
                           placeholder="Nhập ghi chú cho yêu cầu"
                           required>
                </div>

                <div class="form-group">
                    <label>💊 Danh sách thuốc:</label>
                    <div class="medicine-list">
                        <c:forEach var="item" items="${items}" varStatus="loop">
                            <div class="medicine-item">
                                <div class="medicine-item-header">
                                    Thuốc #${loop.index + 1}
                                </div>
                                <div class="medicine-row">
                                    <div>
                                        <span class="field-label">Tên thuốc</span>
                                        <select name="medicine_id" class="form-control" required>
                                            <option value="">-- Chọn thuốc --</option>
                                            <c:forEach var="med" items="${medicines}">
                                                <option value="${med.medicineId}" 
                                                        ${item.medicineId == med.medicineId ? 'selected' : ''}>
                                                    ${med.name}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div>
                                        <span class="field-label">Số lượng</span>
                                        <input type="number" 
                                               name="quantity" 
                                               class="form-control" 
                                               value="${item.quantity}" 
                                               min="1" 
                                               required>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <button type="submit" class="btn-submit">
                    💾 Cập Nhật Yêu Cầu
                </button>
            </form>
        </div>

        <div class="back-link">
            <a href="manage-requests">⬅️ Quay lại Quản lý Yêu cầu</a>
        </div>
    </div>
</body>
</html>
