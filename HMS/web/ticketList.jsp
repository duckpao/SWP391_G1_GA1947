<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Ticket" %>
<!DOCTYPE html>
<html>
<head>
    
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <title>Support Tickets</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
            color: #333;
            line-height: 1.6;
        }
        
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }
        
        h1 {
            color: #1a1a1a;
            margin-bottom: 30px;
            font-size: 2rem;
            border-bottom: 2px solid #e0e0e0;
            padding-bottom: 10px;
        }
        
        .alert {
            padding: 12px 20px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-weight: 500;
        }
        
        .alert-success {
            background-color: #d1fae5;
            color: #065f46;
            border: 1px solid #10b981;
        }
        
        .alert-error {
            background-color: #fee2e2;
            color: #991b1b;
            border: 1px solid #ef4444;
        }
        
        .toolbar {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            align-items: center;
            margin-bottom: 25px;
            padding: 15px;
            background-color: #ffffff;
            border-radius: 8px;
            border: 1px solid #e0e0e0;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }
        
        .filter-label {
            color: #666;
            font-weight: 500;
            margin-left: 20px;
        }
        
        button, .btn {
            background-color: #ffffff;
            color: #333;
            border: 1px solid #d0d0d0;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        
        button:hover, .btn:hover {
            background-color: #f9f9f9;
            border-color: #b0b0b0;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }
        
        button:active, .btn:active {
            transform: translateY(0);
        }
        
        .btn-primary {
            background-color: #2563eb;
            border-color: #2563eb;
            color: #ffffff;
        }
        
        .btn-primary:hover {
            background-color: #1d4ed8;
            border-color: #1d4ed8;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #ffffff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }
        
        thead {
            background-color: #f8f9fa;
        }
        
        th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #1a1a1a;
            border-bottom: 2px solid #e0e0e0;
        }
        
        td {
            padding: 12px 15px;
            border-bottom: 1px solid #f0f0f0;
        }
        
        tbody tr {
            transition: background-color 0.2s ease;
        }
        
        tbody tr:hover {
            background-color: #f8f9fa;
        }
        
        tbody tr:last-child td {
            border-bottom: none;
        }
        
        .no-data {
            text-align: center;
            color: #999;
            font-style: italic;
            padding: 30px !important;
        }
        
        .actions a {
            color: #2563eb;
            text-decoration: none;
            margin: 0 5px;
            transition: color 0.2s ease;
        }
        
        .actions a:hover {
            color: #1d4ed8;
            text-decoration: underline;
        }
        
        .actions a.delete {
            color: #dc2626;
        }
        
        .actions a.delete:hover {
            color: #b91c1c;
        }
        
        .badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .badge-open { background-color: #dbeafe; color: #1e40af; }
        .badge-inprogress { background-color: #fef3c7; color: #92400e; }
        .badge-resolved { background-color: #d1fae5; color: #065f46; }
        .badge-closed { background-color: #f3f4f6; color: #374151; }
        
        .badge-high { background-color: #fee2e2; color: #991b1b; }
        .badge-medium { background-color: #fef3c7; color: #92400e; }
        .badge-low { background-color: #d1fae5; color: #065f46; }
    </style>
</head>
<body>
    <%@ include file="/admin/header.jsp" %>
    
    <div class="container">
        <h1>Support Tickets</h1>
        
        <% 
            String role = (String) request.getAttribute("role");
            boolean isAdmin = "Admin".equals(role);
        %>
        
        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success"><%= request.getAttribute("success") %></div>
        <% } %>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("error") %></div>
        <% } %>
        
        <div class="toolbar">
            <a href="ticket?action=create" class="btn btn-primary">+ Create New Ticket</a>
            
            <% if (isAdmin) { %>
                <span class="filter-label">Filter by Status:</span>
                <a href="ticket?action=list" class="btn">All</a>
                <a href="ticket?action=list&filter=Open" class="btn">Open</a>
                <a href="ticket?action=list&filter=InProgress" class="btn">In Progress</a>
                <a href="ticket?action=list&filter=Resolved" class="btn">Resolved</a>
                <a href="ticket?action=list&filter=Closed" class="btn">Closed</a>
            <% } %>
        </div>
        
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <% if (isAdmin) { %>
                        <th>User</th>
                        <th>Email</th>
                    <% } %>
                    <th>Subject</th>
                    <th>Category</th>
                    <th>Priority</th>
                    <th>Status</th>
                    <th>Created</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Ticket> tickets = (List<Ticket>) request.getAttribute("tickets");
                    if (tickets != null && !tickets.isEmpty()) {
                        for (Ticket ticket : tickets) {
                            String statusClass = ticket.getStatus().toLowerCase().replace(" ", "");
                            String priorityClass = ticket.getPriority().toLowerCase();
                %>
                <tr>
                    <td><strong>#<%= ticket.getTicketId() %></strong></td>
                    <% if (isAdmin) { %>
                        <td><%= ticket.getUsername() %></td>
                        <td><%= ticket.getUserEmail() %></td>
                    <% } %>
                    <td><%= ticket.getSubject() %></td>
                    <td><%= ticket.getCategory() %></td>
                    <td><span class="badge badge-<%= priorityClass %>"><%= ticket.getPriority() %></span></td>
                    <td><span class="badge badge-<%= statusClass %>"><%= ticket.getStatus() %></span></td>
                    <td><%= ticket.getCreatedAt() %></td>
                    <td class="actions">
                        <a href="ticket?action=view&id=<%= ticket.getTicketId() %>">View</a>
                        <% if (isAdmin) { %>
                            <a href="ticket?action=delete&id=<%= ticket.getTicketId() %>" 
                               class="delete"
                               onclick="return confirm('Are you sure you want to delete this ticket?')">Delete</a>
                        <% } %>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="<%= isAdmin ? "9" : "7" %>" class="no-data">No tickets found</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
    
    <%@ include file="/admin/footer.jsp" %>
</body>
</html>