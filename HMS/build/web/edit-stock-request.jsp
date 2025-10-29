<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Stock Request</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: #f9fafb;
            min-height: 100vh;
            padding: 40px 20px;
        }

        .container {
            max-width: 700px;
            margin: 0 auto;
        }

        .header {
            background: white;
            color: #1f2937;
            padding: 30px;
            border-radius: 12px 12px 0 0;
            margin-bottom: 0;
            border-bottom: 4px solid #3b82f6;
        }

        .header h1 {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .header p {
            font-size: 14px;
            color: #6b7280;
        }

        .form-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .form-content {
            padding: 30px;
        }

        .form-section {
            margin-bottom: 30px;
        }

        .form-section:last-child {
            margin-bottom: 0;
        }

        .section-title {
            font-size: 16px;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-size: 14px;
            font-weight: 500;
            color: #1f2937;
            margin-bottom: 8px;
        }

        .form-group label .required {
            color: #ef4444;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            font-family: inherit;
            font-size: 14px;
            transition: all 0.3s ease;
            background: white;
            color: #1f2937;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .medicine-item {
            background: #f3f4f6;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .medicine-item-header {
            font-size: 14px;
            font-weight: 600;
            color: #3b82f6;
            margin-bottom: 15px;
        }

        .medicine-item-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 15px;
        }

        .medicine-item-row.full {
            grid-template-columns: 1fr;
        }

        .divider {
            height: 1px;
            background: #e5e7eb;
            margin: 30px 0;
        }

        .form-actions {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            padding-top: 20px;
            border-top: 1px solid #e5e7eb;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: #3b82f6;
            color: white;
        }

        .btn-primary:hover {
            background: #2563eb;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(59, 130, 246, 0.3);
        }

        .btn-secondary {
            background: #e5e7eb;
            color: #1f2937;
        }

        .btn-secondary:hover {
            background: #d1d5db;
        }

        .back-link {
            color: #1f2937;
            text-decoration: none;
            font-size: 16px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 20px;
            padding: 12px 20px;
            background: white;
            border-radius: 8px;
            border: 2px solid #e5e7eb;
            transition: all 0.3s ease;
        }

        .back-link:hover {
            background: #f3f4f6;
            border-color: #3b82f6;
            color: #3b82f6;
            transform: translateX(-4px);
        }

        @media (max-width: 600px) {
            .medicine-item-row {
                grid-template-columns: 1fr;
            }

            .form-actions {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                justify-content: center;
            }

            .header h1 {
                font-size: 22px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="manager-dashboard" class="back-link">← Back to Dashboard</a>

        <div class="form-card">
            <div class="header">
                <h1>✏️ Edit Stock Request #${purchaseOrder.poId}</h1>
                <p>Update purchase order details</p>
            </div>

            <div class="form-content">
                <form action="manage-stock" method="post">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="poId" value="${purchaseOrder.poId}">

                    <!-- Supplier Section -->
                    <div class="form-section">
                        <div class="form-group">
                            <label>🏢 Select Supplier (Optional)</label>
                            <select name="supplierId">
                                <option value="">-- Choose a supplier (or leave empty to assign later) --</option>
                                <c:forEach items="${suppliers}" var="supplier">
                                    <option value="${supplier.supplierId}"
                                        <c:if test="${purchaseOrder.supplierId == supplier.supplierId}">selected</c:if>>
                                        ${supplier.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="divider"></div>

                    <!-- Medicine Items Section -->
                    <div class="form-section">
                        <div class="section-title">💊 Medicine Items <span class="required">*</span></div>

                        <c:forEach items="${items}" var="item" varStatus="s">
                            <div class="medicine-item">
                                <div class="medicine-item-header">Medicine ${s.index + 1}</div>

                                <div class="medicine-item-row full">
                                    <div class="form-group">
                                        <label>Medicine <span class="required">*</span></label>
                                        <select name="medicineCode_${s.index}" required>
                                            <option value="">-- Select Medicine --</option>
                                            <c:forEach items="${medicines}" var="m">
                                                <option value="${m.medicineCode}"
                                                    <c:if test="${m.medicineCode == item.medicineCode}">selected</c:if>>
                                                    ${m.name} [${m.medicineCode}]
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>

                                <div class="medicine-item-row">
                                    <div class="form-group">
                                        <label>Quantity <span class="required">*</span></label>
                                        <input type="number" name="quantity_${s.index}" min="1" value="${item.quantity}" required>
                                    </div>
                                    <div class="form-group">
                                        <label>Priority <span class="required">*</span></label>
                                        <select name="priority_${s.index}" required>
                                            <option value="Low" <c:if test="${item.priority == 'Low'}">selected</c:if>>Low</option>
                                            <option value="Medium" <c:if test="${item.priority == 'Medium'}">selected</c:if>>Medium</option>
                                            <option value="High" <c:if test="${item.priority == 'High'}">selected</c:if>>High</option>
                                            <option value="Critical" <c:if test="${item.priority == 'Critical'}">selected</c:if>>Critical</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="medicine-item-row full">
                                    <div class="form-group">
                                        <label>Item Notes</label>
                                        <input type="text" name="itemNotes_${s.index}" value="${item.notes}" placeholder="Additional notes...">
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="divider"></div>

                    <!-- Expected Delivery Date -->
                    <div class="form-section">
                        <div class="form-group">
                            <label>📅 Expected Delivery Date <span class="required">*</span></label>
                            <input type="date" name="expectedDeliveryDate" value="${purchaseOrder.expectedDeliveryDate}" required>
                        </div>
                    </div>

                    <!-- Request Notes -->
                    <div class="form-section">
                        <div class="form-group">
                            <label>📝 Request Notes</label>
                            <textarea name="notes" placeholder="Any special requirements or comments for the entire order...">${purchaseOrder.notes}</textarea>
                        </div>
                    </div>

                    <!-- Form Actions -->
                    <div class="form-actions">
                        <a href="manager-dashboard" class="btn btn-secondary">✕ Cancel</a>
                        <button type="submit" class="btn btn-primary">💾 Update Stock Request</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
