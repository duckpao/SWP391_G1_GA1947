<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Ticket" %>
<!DOCTYPE html>
<html>
<head>
    <title>Ticket Details</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        h1 {
            color: #1a1a1a;
            margin-bottom: 25px;
            font-size: 1.8rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        h1 i {
            color: #2563eb;
        }
        
        h2 {
            color: #1a1a1a;
            margin: 30px 0 15px 0;
            font-size: 1.3rem;
            padding-bottom: 8px;
            border-bottom: 2px solid #e0e0e0;
        }
        
        .alert {
            padding: 12px 20px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .alert i {
            font-size: 1.2rem;
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
        
        .btn {
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
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 20px;
        }
        
        .btn:hover {
            background-color: #f9f9f9;
            border-color: #b0b0b0;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
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
        
        .card {
            background-color: #ffffff;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        td {
            padding: 12px 15px;
            border-bottom: 1px solid #f0f0f0;
        }
        
        td:first-child {
            font-weight: 600;
            color: #555;
            width: 200px;
            vertical-align: top;
        }
        
        tr:last-child td {
            border-bottom: none;
        }
        
        pre {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 6px;
            border: 1px solid #e0e0e0;
            white-space: pre-wrap;
            word-wrap: break-word;
            font-family: 'Consolas', 'Monaco', monospace;
            font-size: 14px;
            line-height: 1.5;
            margin: 0;
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
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-inline {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        label {
            font-weight: 500;
            color: #555;
        }
        
        select {
            padding: 8px 12px;
            border: 1px solid #d0d0d0;
            border-radius: 6px;
            background-color: #ffffff;
            font-size: 14px;
            cursor: pointer;
        }
        
        select:focus {
            outline: none;
            border-color: #2563eb;
        }
        
        textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #d0d0d0;
            border-radius: 6px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            font-size: 14px;
            resize: vertical;
        }
        
        textarea:focus {
            outline: none;
            border-color: #2563eb;
        }
        
        .response-section {
            background-color: #f8f9fa;
            border-left: 4px solid #2563eb;
            padding: 20px;
            border-radius: 6px;
        }
        
        .admin-actions {
            background-color: #fff7ed;
            border-left: 4px solid #f59e0b;
            padding: 20px;
            border-radius: 6px;
        }
        
        .form-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <%@ include file="/admin/header.jsp" %>
    
    <div class="container">
        <%
            Ticket ticket = (Ticket) request.getAttribute("ticket");
            String role = (String) request.getAttribute("role");
            boolean isAdmin = "Admin".equals(role);
            
            String statusClass = ticket.getStatus().toLowerCase().replace(" ", "");
            String priorityClass = ticket.getPriority().toLowerCase();
        %>
        
        <h1>
            <i class="fas fa-ticket-alt"></i>
            Ticket #<%= ticket.getTicketId() %> - <%= ticket.getSubject() %>
        </h1>
        
        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <%= request.getAttribute("success") %>
            </div>
        <% } %>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <a href="ticket?action=list" class="btn">
            <i class="fas fa-arrow-left"></i>
            Back to List
        </a>
        
        <div class="card">
            <h2><i class="fas fa-info-circle"></i> Ticket Information</h2>
            <table>
                <tr>
                    <td>Ticket ID:</td>
                    <td><strong>#<%= ticket.getTicketId() %></strong></td>
                </tr>
                <% if (isAdmin) { %>
                <tr>
                    <td>Submitted by:</td>
                    <td>
                        <i class="fas fa-user"></i> <%= ticket.getUsername() %> 
                        (<i class="fas fa-envelope"></i> <%= ticket.getUserEmail() %>)
                    </td>
                </tr>
                <% } %>
                <tr>
                    <td>Subject:</td>
                    <td><%= ticket.getSubject() %></td>
                </tr>
                <tr>
                    <td>Category:</td>
                    <td><i class="fas fa-folder"></i> <%= ticket.getCategory() %></td>
                </tr>
                <tr>
                    <td>Priority:</td>
                    <td><span class="badge badge-<%= priorityClass %>"><%= ticket.getPriority() %></span></td>
                </tr>
                <tr>
                    <td>Status:</td>
                    <td><span class="badge badge-<%= statusClass %>"><%= ticket.getStatus() %></span></td>
                </tr>
                <tr>
                    <td>Created:</td>
                    <td><i class="fas fa-clock"></i> <%= ticket.getCreatedAt() %></td>
                </tr>
                <tr>
                    <td>Last Updated:</td>
                    <td><i class="fas fa-sync-alt"></i> <%= ticket.getUpdatedAt() %></td>
                </tr>
                <tr>
                    <td>Message:</td>
                    <td><pre><%= ticket.getMessage() %></pre></td>
                </tr>
            </table>
        </div>
        
        <% if (ticket.getAdminResponse() != null && !ticket.getAdminResponse().isEmpty()) { %>
        <div class="card response-section">
            <h2><i class="fas fa-reply"></i> Admin Response</h2>
            <table>
                <tr>
                    <td>Responded by:</td>
                    <td><i class="fas fa-user-shield"></i> <%= ticket.getAdminUsername() %></td>
                </tr>
                <tr>
                    <td>Response time:</td>
                    <td><i class="fas fa-clock"></i> <%= ticket.getRespondedAt() %></td>
                </tr>
                <tr>
                    <td>Response:</td>
                    <td><pre><%= ticket.getAdminResponse() %></pre></td>
                </tr>
            </table>
        </div>
        <% } %>
        
        <% if (isAdmin) { %>
        <div class="card admin-actions">
            <h2><i class="fas fa-tools"></i> Admin Actions</h2>
            
            <!-- Update Status -->
            <form action="ticket" method="post" class="form-inline">
                <input type="hidden" name="action" value="updateStatus">
                <input type="hidden" name="ticketId" value="<%= ticket.getTicketId() %>">
                <label><i class="fas fa-exchange-alt"></i> Change Status:</label>
                <select name="status">
                    <option value="Open" <%= "Open".equals(ticket.getStatus()) ? "selected" : "" %>>Open</option>
                    <option value="InProgress" <%= "InProgress".equals(ticket.getStatus()) ? "selected" : "" %>>In Progress</option>
                    <option value="Resolved" <%= "Resolved".equals(ticket.getStatus()) ? "selected" : "" %>>Resolved</option>
                    <option value="Closed" <%= "Closed".equals(ticket.getStatus()) ? "selected" : "" %>>Closed</option>
                </select>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i>
                    Update Status
                </button>
            </form>
            
            <hr style="margin: 20px 0; border: none; border-top: 1px solid #e0e0e0;">
            
            <!-- Respond to Ticket -->
            <form action="ticket" method="post">
                <input type="hidden" name="action" value="respond">
                <input type="hidden" name="ticketId" value="<%= ticket.getTicketId() %>">
                
                <div class="form-group">
                    <label for="adminResponse"><i class="fas fa-comment-dots"></i> Your Response:</label>
                    <textarea id="adminResponse" name="adminResponse" rows="6" required placeholder="Enter your response to the customer..."></textarea>
                </div>
                
                <div class="form-group">
                    <label for="status"><i class="fas fa-flag"></i> Set Status:</label>
                    <select id="status" name="status">
                        <option value="InProgress">In Progress</option>
                        <option value="Resolved" selected>Resolved</option>
                        <option value="Closed">Closed</option>
                    </select>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-paper-plane"></i>
                        Send Response
                    </button>
                </div>
            </form>
        </div>
        <% } %>
    </div>
    
    <%@ include file="/admin/footer.jsp" %>
</body>
</html>