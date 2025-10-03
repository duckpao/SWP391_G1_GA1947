
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Doctor Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        .dashboard {
            max-width: 800px;
            margin: auto;
        }
        .dashboard h2 {
            color: #2c3e50;
        }
        .menu {
            list-style-type: none;
            padding: 0;
        }
        .menu li {
            margin: 10px 0;
        }
        .menu li a {
            text-decoration: none;
            color: #2980b9;
            font-size: 18px;
        }
        .menu li a:hover {
            color: #3498db;
            text-decoration: underline;
        }
        .logout {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="dashboard">
        <h2>Welcome, Doctor!</h2>
        <p>Manage your medication requests and medicine information.</p>
        
        <ul class="menu">
            <li><a href="create-request">Create Medication Request</a></li>
            <li><a href="requests/update">Update Medication Request</a></li>
            <li><a href="requests/cancel">Cancel Medication Request</a></li>
            <li><a href="requests/history">View Request History</a></li>
            <li><a href="medicines">View Medicine Information</a></li>
            <li><a href="medicines/search">Search Medicine by Name</a></li>
            <li><a href="medicines/search?category">Search Medicine by Category</a></li>
            <li><a href="medicines/advanced-search">Advanced Medicine Search</a></li>
            <li><a href="medicines/stock">Check Stock Availability</a></li>
        </ul>

        <div class="logout">
            <a href="logout">Logout</a>
        </div>
    </div>
</body>
</html>
