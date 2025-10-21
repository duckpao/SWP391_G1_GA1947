<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Record Expired/Damaged Medicines</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: Arial, sans-serif;
        }
        .container {
            margin-top: 50px;
            max-width: 600px;
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            padding: 30px;
        }
        table {
            width: 100%;
        }
        th {
            width: 35%;
            text-align: left;
            padding: 8px;
        }
        td {
            padding: 8px;
        }
        .btn-submit {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
        }
        .btn-submit:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

<div class="container">
    <h3 class="text-center mb-4">Record Expired or Damaged Medicines</h3>

    <% if (request.getAttribute("message") != null) { %>
        <p class="text-success text-center"><%= request.getAttribute("message") %></p>
    <% } %>

    <% if (request.getAttribute("error") != null) { %>
        <p class="text-danger text-center"><%= request.getAttribute("error") %></p>
    <% } %>

    <form action="recordExpiredDamaged" method="post">
        <table class="table table-borderless">
            <tr>
                <th>Batch ID:</th>
                <td><input type="number" name="batchId" class="form-control" required></td>
            </tr>
            <tr>
                <th>User ID:</th>
                <td><input type="number" name="userId" class="form-control" required></td>
            </tr>
            <tr>
                <th>Quantity:</th>
                <td><input type="number" name="quantity" min="1" class="form-control" required></td>
            </tr>
            <tr>
                <th>Reason:</th>
                <td>
                    <select name="reason" class="form-select" required>
                        <option value="Expired">Expired</option>
                        <option value="Damaged">Damaged</option>
                    </select>
                </td>
            </tr>
            <tr>
                <th>Notes:</th>
                <td><textarea name="notes" rows="3" class="form-control"></textarea></td>
            </tr>
        </table>

        <div class="text-center mt-3">
            <button type="submit" class="btn-submit">Record</button>
        </div>
    </form>
</div>

</body>
</html>
