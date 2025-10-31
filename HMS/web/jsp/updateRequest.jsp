<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập Nhật Yêu Cầu Thuốc</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: #f9fafb;
            min-height: 100vh;
            padding: 40px 20px;
            color: #374151;
        }

        .container {
            max-width: 900px;
            margin: 0 auto;
        }

        /* Header Card */
        .header {
            background: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 24px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            border-left: 5px solid #6b7280;
        }

        .header h1 {
            color: #1f2937;
            font-size: 28px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        /* Alert Error */
        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 24px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.1);
        }

        /* Form Container */
        .form-container {
            background: white;
            padding: 32px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            margin-bottom: 24px;
        }

        .form-group {
            margin-bottom: 28px;
        }

        .form-group label {
            display: block;
            color: #1f2937;
            font-weight: 600;
            margin-bottom: 10px;
            font-size: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 10px;
            font-size: 15px;
            font-family: 'Inter', sans-serif;
            transition: all 0.3s ease;
            background: white;
            color: #374151;
        }

        .form-control:focus {
            outline: none;
            border-color: #6b7280;
            box-shadow: 0 0 0 3px rgba(107, 114, 128, 0.1);
        }

        .form-control::placeholder {
            color: #9ca3af;
        }

        /* Medicine List */
        .medicine-list {
            margin-top: 16px;
        }

        .medicine-item {
            background: #f9fafb;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 16px;
            border: 2px solid #e5e7eb;
            transition: all 0.3s ease;
        }

        .medicine-item:hover {
            border-color: #d1d5db;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }

        .medicine-item-header {
            font-weight: 600;
            color: #6b7280;
            margin-bottom: 16px;
            font-size: 15px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .medicine-row {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 16px;
            align-items: end;
        }

        select.form-control {
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='%236b7280' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14L2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 12px center;
            padding-right: 40px;
        }

        input[type="number"].form-control {
            text-align: center;
        }

        .field-label {
            display: block;
            font-size: 13px;
            color: #6b7280;
            margin-bottom: 6px;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        /* Buttons */
        .btn-submit {
            width: 100%;
            padding: 16px;
            background: #6b7280;
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 12px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            box-shadow: 0 4px 12px rgba(107, 114, 128, 0.2);
        }

        .btn-submit:hover {
            background: #4b5563;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(107, 114, 128, 0.3);
        }

        .btn-submit:active {
            transform: translateY(0);
        }

        /* Back Link */
        .back-link {
            background: white;
            padding: 24px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
        }

        .back-link a {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: #6b7280;
            color: white;
            padding: 14px 32px;
            text-decoration: none;
            border-radius: 10px;
            font-weight: 600;
            font-size: 15px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(107, 114, 128, 0.2);
        }

        .back-link a:hover {
            background: #4b5563;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(107, 114, 128, 0.3);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            body {
                padding: 20px 15px;
            }

            .header {
                padding: 24px 20px;
            }

            .header h1 {
                font-size: 22px;
            }

            .form-container {
                padding: 24px 20px;
            }

            .medicine-row {
                grid-template-columns: 1fr;
                gap: 12px;
            }

            .btn-submit {
                padding: 14px;
                font-size: 15px;
            }

            .back-link a {
                padding: 12px 24px;
                font-size: 14px;
            }
        }

        /* Scrollbar Styling */
        ::-webkit-scrollbar {
            width: 8px;
        }

        ::-webkit-scrollbar-track {
            background: rgba(0, 0, 0, 0.05);
        }

        ::-webkit-scrollbar-thumb {
            background: rgba(0, 0, 0, 0.2);
            border-radius: 4px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: rgba(0, 0, 0, 0.3);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="bi bi-pencil-square"></i> Cập Nhật Yêu Cầu Thuốc</h1>
        </div>

        <c:if test="${not empty error}">
            <div class="alert-error">
                <i class="bi bi-exclamation-triangle-fill"></i>
                <span>${error}</span>
            </div>
        </c:if>

        <div class="form-container">
            <form action="update-request" method="post">
                <input type="hidden" name="requestId" value="${request.requestId}">
                
                <div class="form-group">
                    <label><i class="bi bi-file-text"></i> Ghi chú yêu cầu:</label>
                    <input type="text" 
                           name="notes" 
                           class="form-control" 
                           value="${request.notes}" 
                           placeholder="Nhập ghi chú cho yêu cầu"
                           required>
                </div>

                <div class="form-group">
                    <label><i class="bi bi-capsule"></i> Danh sách thuốc:</label>
                    <div class="medicine-list">
                        <c:forEach var="item" items="${items}" varStatus="loop">
                            <div class="medicine-item">
                                <div class="medicine-item-header">
                                    <i class="bi bi-heart-pulse"></i>
                                    Thuốc #${loop.index + 1}
                                </div>
                                <div class="medicine-row">
                                    <div>
                                        <span class="field-label">Tên thuốc</span>
                                        <select name="medicine_code" class="form-control" required>
                                            <option value="">-- Chọn thuốc --</option>
                                            <c:forEach var="med" items="${medicines}">
                                                <option value="${med.medicineCode}" 
                                                        ${item.medicineCode == med.medicineCode ? 'selected' : ''}>
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
                    <i class="bi bi-check-circle"></i>
                    Cập Nhật Yêu Cầu
                </button>
            </form>
        </div>

        <div class="back-link">
            <a href="manage-requests">
                <i class="bi bi-arrow-left"></i>
                Quay lại Quản lý Yêu cầu
            </a>
        </div>
    </div>
</body>
</html>