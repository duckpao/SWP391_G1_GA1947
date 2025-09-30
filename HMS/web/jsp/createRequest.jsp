<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Create Medication Request</title>
</head>
<body>
    <h2>Create Medication Request</h2>
    <form action="/create-request" method="post">
        <label>Notes:</label>
        <textarea name="notes"></textarea><br>

        <h3>Medicines:</h3>
        <!-- Có thể dùng JS để add row động -->
        <div class="item">
            <select name="medicine_id">
                <c:forEach var="med" items="${medicines}">
                    <option value="${med.medicineId}">${med.name}</option>
                </c:forEach>
            </select>
            <input type="number" name="quantity" min="1" required>
        </div>
        <!-- Add more items button (JS) -->

        <button type="submit">Submit Request</button>
    </form>
    <c:if test="${not empty error}"><p style="color:red;">${error}</p></c:if>
</body>
</html>