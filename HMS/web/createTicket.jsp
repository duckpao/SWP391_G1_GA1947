<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Create Support Ticket</title>
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
            max-width: 800px;
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
        
        .alert-error {
            background-color: #fee2e2;
            color: #991b1b;
            border: 1px solid #ef4444;
        }
        
        .card {
            background-color: #ffffff;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            font-weight: 600;
            color: #555;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        label i {
            color: #2563eb;
            width: 18px;
        }
        
        input[type="text"],
        select,
        textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #d0d0d0;
            border-radius: 6px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }
        
        input[type="text"]:focus,
        select:focus,
        textarea:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }
        
        select {
            cursor: pointer;
            background-color: #ffffff;
        }
        
        textarea {
            resize: vertical;
            min-height: 150px;
        }
        
        .form-actions {
            display: flex;
            gap: 10px;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
        }
        
        .btn {
            padding: 12px 24px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: 1px solid;
        }
        
        .btn:hover {
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
        
        .btn-secondary {
            background-color: #ffffff;
            border-color: #d0d0d0;
            color: #333;
        }
        
        .btn-secondary:hover {
            background-color: #f9f9f9;
            border-color: #b0b0b0;
        }
        
        .form-hint {
            font-size: 13px;
            color: #666;
            margin-top: 5px;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .form-hint i {
            color: #999;
        }
        
        .priority-info {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            margin-top: 8px;
            font-size: 12px;
        }
        
        .priority-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 8px;
            border-radius: 4px;
        }
        
        .priority-badge.low { background-color: #d1fae5; color: #065f46; }
        .priority-badge.normal { background-color: #dbeafe; color: #1e40af; }
        .priority-badge.high { background-color: #fef3c7; color: #92400e; }
        .priority-badge.urgent { background-color: #fee2e2; color: #991b1b; }
    </style>
</head>
<body>
    <%@ include file="/admin/header.jsp" %>
    
    <div class="container">
        <h1>
            <i class="fas fa-plus-circle"></i>
            Create Support Ticket
        </h1>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <div class="card">
            <form action="ticket" method="post">
                <input type="hidden" name="action" value="create">
                
                <div class="form-group">
                    <label for="subject">
                        <i class="fas fa-heading"></i>
                        Subject:
                    </label>
                    <input type="text" id="subject" name="subject" required 
                           placeholder="Brief description of your issue">
                    <div class="form-hint">
                        <i class="fas fa-info-circle"></i>
                        Enter a clear and concise subject for your ticket
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="category">
                        <i class="fas fa-folder"></i>
                        Category:
                    </label>
                    <select id="category" name="category">
                        <option value="Technical">Technical Issue</option>
                        <option value="Account">Account Problem</option>
                        <option value="Feature">Feature Request</option>
                        <option value="Bug">Bug Report</option>
                        <option value="Other">Other</option>
                    </select>
                    <div class="form-hint">
                        <i class="fas fa-info-circle"></i>
                        Select the category that best describes your issue
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="priority">
                        <i class="fas fa-exclamation-triangle"></i>
                        Priority:
                    </label>
                    <select id="priority" name="priority">
                        <option value="Low">Low</option>
                        <option value="Normal" selected>Normal</option>
                        <option value="High">High</option>
                        <option value="Urgent">Urgent</option>
                    </select>
                    <div class="priority-info">
                        <span class="priority-badge low">
                            <i class="fas fa-circle"></i> Low - Minor issues
                        </span>
                        <span class="priority-badge normal">
                            <i class="fas fa-circle"></i> Normal - Standard requests
                        </span>
                        <span class="priority-badge high">
                            <i class="fas fa-circle"></i> High - Important issues
                        </span>
                        <span class="priority-badge urgent">
                            <i class="fas fa-circle"></i> Urgent - Critical problems
                        </span>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="message">
                        <i class="fas fa-comment-dots"></i>
                        Message:
                    </label>
                    <textarea id="message" name="message" required 
                              placeholder="Describe your issue in detail. Include any relevant information such as error messages, steps to reproduce, or screenshots descriptions."></textarea>
                    <div class="form-hint">
                        <i class="fas fa-info-circle"></i>
                        Provide as much detail as possible to help us resolve your issue quickly
                    </div>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-paper-plane"></i>
                        Submit Ticket
                    </button>
                    <a href="ticket?action=list" class="btn btn-secondary">
                        <i class="fas fa-times"></i>
                        Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>
    
    <%@ include file="/admin/footer.jsp" %>
</body>
</html>