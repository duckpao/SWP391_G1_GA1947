<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .dashboard-container {
            max-width: 1200px;
            width: 100%;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            text-align: center;
        }
        
        .header h1 {
            font-size: 36px;
            margin-bottom: 10px;
            font-weight: 700;
        }
        
        .header p {
            font-size: 16px;
            opacity: 0.9;
        }
        
        .content {
            padding: 40px;
        }
        
        .welcome-message {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 40px;
            box-shadow: 0 10px 30px rgba(240, 147, 251, 0.3);
        }
        
        .welcome-message h2 {
            font-size: 28px;
            margin-bottom: 10px;
        }
        
        .welcome-message p {
            font-size: 16px;
            opacity: 0.95;
        }
        
        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }
        
        .card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            text-align: center;
            transition: all 0.3s ease;
            border: 2px solid #f0f0f0;
            position: relative;
            overflow: hidden;
        }
        
        .card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
        }
        
        .card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
            border-color: #667eea;
        }
        
        .card-icon {
            width: 80px;
            height: 80px;
            margin: 0 auto 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
        }
        
        .card h3 {
            font-size: 22px;
            color: #333;
            margin-bottom: 15px;
        }
        
        .card p {
            color: #666;
            font-size: 14px;
            margin-bottom: 25px;
            line-height: 1.6;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }
        
        .btn:hover {
            transform: scale(1.05);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
        }
        
        .logout-section {
            text-align: center;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 15px;
        }
        
        .btn-logout {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            padding: 14px 40px;
            font-size: 16px;
        }
        
        .btn-logout:hover {
            box-shadow: 0 10px 25px rgba(245, 87, 108, 0.4);
        }
        
        @media (max-width: 768px) {
            .header h1 {
                font-size: 28px;
            }
            
            .cards-grid {
                grid-template-columns: 1fr;
            }
            
            .content {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <div class="header">
            <h1>🏥 Doctor Dashboard</h1>
            <p>Comprehensive Medical Management System</p>
        </div>
        
        <div class="content">
            <div class="welcome-message">
                <h2>👨‍⚕️ Welcome, Doctor!</h2>
                <p>Manage your medication requests, view medicine inventory, and streamline your healthcare workflow.</p>
            </div>
            
            <div class="cards-grid">
                <div class="card">
                    <div class="card-icon">📋</div>
                    <h3>Manage Requests</h3>
                    <p>View, update, and cancel medication requests. Track pending requests and request history.</p>
                    <a href="manage-requests" class="btn">Manage Requests</a>
                </div>
                
                <div class="card">
                    <div class="card-icon">💊</div>
                    <h3>View Medicines</h3>
                    <p>Browse available medicines, check stock levels, and view detailed information about each medication.</p>
                    <a href="view-medicine" class="btn">View Medicines</a>
                </div>
                
                <div class="card">
                    <div class="card-icon">➕</div>
                    <h3>Create Request</h3>
                    <p>Submit new medication requests quickly and efficiently for your patients.</p>
                    <a href="create-request" class="btn">Create Request</a>
                </div>
            </div>
            
            <div class="logout-section">
                <a href="logout" class="btn btn-logout">🚪 Logout</a>
            </div>
        </div>
    </div>
</body>
</html>