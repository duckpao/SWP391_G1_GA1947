<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Medicine Details</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
            padding: 20px;
        }
        
        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        h1 {
            color: #333;
            margin-bottom: 30px;
            font-size: 28px;
        }
        
        /* Search Form Styles */
        .search-container {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            border: 1px solid #e0e0e0;
        }
        
        .search-form {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr auto;
            gap: 15px;
            align-items: end;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
        }
        
        .form-group label {
            font-weight: 600;
            margin-bottom: 5px;
            color: #555;
            font-size: 14px;
        }
        
        .form-group input,
        .form-group select {
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            transition: border-color 0.3s;
        }
        
        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #4CAF50;
        }
        
        .btn {
            padding: 10px 25px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .btn-search {
            background: #4CAF50;
            color: white;
        }
        
        .btn-search:hover {
            background: #45a049;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(76, 175, 80, 0.3);
        }
        
        .btn-reset {
            background: #6c757d;
            color: white;
            margin-left: 10px;
        }
        
        .btn-reset:hover {
            background: #5a6268;
        }
        
        /* Results Info */
        .results-info {
            margin-bottom: 20px;
            padding: 10px 15px;
            background: #e7f3ff;
            border-left: 4px solid #2196F3;
            border-radius: 4px;
            color: #0d47a1;
        }
        
        /* Navigation Links */
        .nav-links {
            margin-bottom: 20px;
        }
        
        .nav-links a {
            display: inline-block;
            padding: 10px 20px;
            margin-right: 10px;
            background: #2196F3;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s;
        }
        
        .nav-links a:hover {
            background: #1976D2;
        }
        
        /* Table Styles */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: white;
        }
        
        thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        td {
            padding: 12px 15px;
            border-bottom: 1px solid #e0e0e0;
            font-size: 14px;
            color: #333;
        }
        
        tbody tr {
            transition: background-color 0.3s;
        }
        
        tbody tr:hover {
            background-color: #f5f5f5;
        }
        
        /* Status Badge */
        .status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }
        
        .status-approved {
            background: #d4edda;
            color: #155724;
        }
        
        .status-low {
            background: #fff3cd;
            color: #856404;
        }
        
        .status-out {
            background: #f8d7da;
            color: #721c24;
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }
        
        .empty-state svg {
            width: 100px;
            height: 100px;
            margin-bottom: 20px;
            opacity: 0.5;
        }
        
        .empty-state h3 {
            font-size: 20px;
            margin-bottom: 10px;
        }
        
        .empty-state p {
            font-size: 14px;
        }
        
        @media (max-width: 1024px) {
            .search-form {
                grid-template-columns: 1fr;
            }
            
            .btn-reset {
                margin-left: 0;
                margin-top: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Medicine Details</h1>
        
        <!-- Search Form -->
        <div class="search-container">
            <form action="view-medicine" method="get" class="search-form">
                <div class="form-group">
                    <label for="keyword">Search by Name or Description</label>
                    <input type="text" 
                           id="keyword" 
                           name="keyword" 
                           placeholder="Enter medicine name or description..."
                           value="${keyword}">
                </div>
                
                <div class="form-group">
                    <label for="category">Category</label>
                    <select id="category" name="category">
                        <option value="All" ${selectedCategory == 'All' ? 'selected' : ''}>All Categories</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat}" ${selectedCategory == cat ? 'selected' : ''}>${cat}</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="status">Stock Status</label>
                    <select id="status" name="status">
                        <option value="" ${selectedStatus == '' ? 'selected' : ''}>All Status</option>
                        <option value="In Stock" ${selectedStatus == 'In Stock' ? 'selected' : ''}>In Stock (&gt;50)</option>
                        <option value="Low Stock" ${selectedStatus == 'Low Stock' ? 'selected' : ''}>Low Stock (1-50)</option>
                        <option value="Out of Stock" ${selectedStatus == 'Out of Stock' ? 'selected' : ''}>Out of Stock (0)</option>
                    </select>
                </div>
                
                <div class="form-group" style="flex-direction: row; align-items: center;">
                    <button type="submit" class="btn btn-search">🔍 Search</button>
                    <a href="view-medicine" class="btn btn-reset">🔄 Reset</a>
                </div>
            </form>
        </div>
        
        <!-- Results Info -->
        <c:if test="${not empty keyword or selectedCategory != 'All' or not empty selectedStatus}">
            <div class="results-info">
                <strong>Search Results:</strong> Found ${medicines.size()} medicine(s)
                <c:if test="${not empty keyword}"> matching "${keyword}"</c:if>
                <c:if test="${selectedCategory != 'All'}"> in category "${selectedCategory}"</c:if>
                <c:if test="${not empty selectedStatus}"> with status "${selectedStatus}"</c:if>
            </div>
        </c:if>
        
        <!-- Navigation Links -->
        <div class="nav-links">
            <a href="create-request">📝 Create Medication Request</a>
            <a href="doctor-dashboard">🏠 Back to Dashboard</a>
        </div>
        
        <!-- Medicine Table -->
        <c:choose>
            <c:when test="${not empty medicines}">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Category</th>
                            <th>Description</th>
                            <th>Batch ID</th>
                            <th>Lot Number</th>
                            <th>Expiry Date</th>
                            <th>Current Quantity</th>
                            <th>Status</th>
                            <th>Received Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="medicine" items="${medicines}">
                            <c:forEach var="batch" items="${medicine.batches}" varStatus="batchStatus">
                                <tr>
                                    <c:if test="${batchStatus.first}">
                                        <td rowspan="${medicine.batches.size()}">${medicine.medicineId}</td>
                                        <td rowspan="${medicine.batches.size()}"><strong>${medicine.name}</strong></td>
                                        <td rowspan="${medicine.batches.size()}">${medicine.category}</td>
                                        <td rowspan="${medicine.batches.size()}">${medicine.description}</td>
                                    </c:if>
                                    <td>${batch.batchId}</td>
                                    <td>${batch.lotNumber}</td>
                                    <td><fmt:formatDate value="${batch.expiryDate}" pattern="dd/MM/yyyy"/></td>
                                    <td>
                                        <strong>${batch.currentQuantity}</strong>
                                        <c:choose>
                                            <c:when test="${batch.currentQuantity == 0}">
                                                <span class="status-badge status-out">Out</span>
                                            </c:when>
                                            <c:when test="${batch.currentQuantity <= 50}">
                                                <span class="status-badge status-low">Low</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td><span class="status-badge status-approved">${batch.status}</span></td>
                                    <td><fmt:formatDate value="${batch.receivedDate}" pattern="dd/MM/yyyy"/></td>
                                </tr>
                            </c:forEach>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                    <h3>No medicines found</h3>
                    <p>Try adjusting your search criteria or reset the filters.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>