<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>View Medicines</title>
    <style>
        .low-stock { color: red; font-weight: bold; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h1>Medicine Details</h1>
    <table>
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
        <c:forEach var="medicine" items="${medicines}">
            <c:forEach var="batch" items="${medicine.batches}">
                <tr>
                    <td>${medicine.medicineId}</td>
                    <td>${medicine.name}</td>
                    <td>${medicine.category}</td>
                    <td>${medicine.description}</td>
                    <td>${batch.batchId}</td>
                    <td>${batch.lotNumber}</td>
                    <td>${batch.expiryDate}</td>
                    <td class="${batch.currentQuantity <= 10 ? 'low-stock' : ''}">${batch.currentQuantity}</td>
                    <td>${batch.status}</td>
                    <td>${batch.receivedDate}</td>
                </tr>
            </c:forEach>
        </c:forEach>
    </table>
    <a href="doctor-dashboard">Back to Dashboard</a>
</body>
</html>