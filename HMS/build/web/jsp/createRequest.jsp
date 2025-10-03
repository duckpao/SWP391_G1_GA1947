<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Create Medication Request</title>
    <style>
        /* Popup overlay */
        .modal {
            display: none; 
            position: fixed;
            z-index: 1000;
            padding-top: 200px;
            left: 0; top: 0;
            width: 100%; height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.4);
        }
        /* Popup content */
        .modal-content {
            background-color: #fefefe;
            margin: auto;
            padding: 20px;
            border: 2px solid #4CAF50;
            border-radius: 10px;
            width: 400px;
            text-align: center;
            box-shadow: 0px 0px 10px #333;
        }
        .modal-content h3 {
            color: green;
        }
        .modal-content button {
            margin: 10px;
            padding: 10px 20px;
            border: none;
            background-color: #4CAF50;
            color: white;
            border-radius: 5px;
            cursor: pointer;
        }
        .modal-content button:hover {
            background-color: #45a049;
        }
        .modal-content a {
            display: inline-block;
            margin: 10px;
            padding: 10px 20px;
            border: none;
            background-color: #2196F3;
            color: white;
            border-radius: 5px;
            text-decoration: none;
        }
        .modal-content a:hover {
            background-color: #0b7dda;
        }
    </style>
</head>
<body>
    <h2>Create Medication Request</h2>
    <form action="${pageContext.request.contextPath}/create-request" method="post">
        <label>Notes:</label>
        <textarea name="notes"></textarea><br>
        <h3>Medicines:</h3>
        <div class="item">
            <select name="medicine_id">
                <c:forEach var="med" items="${medicines}">
                    <option value="${med.medicineId}">${med.name}</option>
                </c:forEach>
            </select>
            <input type="number" name="quantity" min="1" required>
        </div>
        <button type="submit">Submit Request</button>
    </form>

    <c:if test="${not empty error}">
        <p style="color:red;">${error}</p>
    </c:if>

    <!-- Popup hiển thị khi thành công -->
    <div id="successModal" class="modal">
        <div class="modal-content">
            <h3>✅ Đặt thuốc thành công!</h3>
            <button onclick="closeModal()">Đặt thuốc tiếp</button>
            <a href="doctor-dashboard">Trở về</a>
        </div>
    </div>

    <script>
        function closeModal() {
            document.getElementById("successModal").style.display = "none";
        }
        // Nếu có attribute success thì hiển thị popup
        <% if (request.getAttribute("success") != null) { %>
            document.addEventListener("DOMContentLoaded", function() {
                document.getElementById("successModal").style.display = "block";
            });
        <% } %>
    </script>
</body>
</html>
