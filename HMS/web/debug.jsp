<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="DAO.ManagerDAO" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Debug Approve Function</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .log-box { 
            background: #f8f9fa; 
            padding: 15px; 
            border-radius: 5px; 
            font-family: monospace;
            white-space: pre-wrap;
            margin: 10px 0;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <h2>🔍 Debug Approve Function</h2>
        
        <%
        // Lấy thông tin từ session
        Integer sessionUserId = (Integer) session.getAttribute("userId");
        String sessionRole = (String) session.getAttribute("role");
        
        out.println("<div class='alert alert-info'>");
        out.println("<h5>Session Information:</h5>");
        out.println("<ul>");
        out.println("<li><strong>User ID:</strong> " + sessionUserId + "</li>");
        out.println("<li><strong>Role:</strong> " + sessionRole + "</li>");
        out.println("</ul>");
        out.println("</div>");
        
        // Test với PO #2
        int testPoId = 2;
        int testManagerId = (sessionUserId != null) ? sessionUserId : 1;
        
        out.println("<div class='card mt-3'>");
        out.println("<div class='card-header bg-primary text-white'>");
        out.println("<h5>Test Approve PO #" + testPoId + " with Manager #" + testManagerId + "</h5>");
        out.println("</div>");
        out.println("<div class='card-body'>");
        
        Connection conn = null;
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://localhost:1433;databaseName=SWP391;encrypt=true;trustServerCertificate=true";
            String user = "sa";
            String pass = "123";
            conn = DriverManager.getConnection(url, user, pass);
            
            // Step 1: Check current status
            out.println("<h6>Step 1: Check Current Status</h6>");
            String checkQuery = "SELECT po_id, status, manager_id FROM PurchaseOrders WHERE po_id = ?";
            PreparedStatement psCheck = conn.prepareStatement(checkQuery);
            psCheck.setInt(1, testPoId);
            ResultSet rsCheck = psCheck.executeQuery();
            
            if (rsCheck.next()) {
                String currentStatus = rsCheck.getString("status");
                int currentManagerId = rsCheck.getInt("manager_id");
                
                out.println("<div class='log-box'>");
                out.println("PO #" + testPoId + " found!");
                out.println("Current Status: [" + currentStatus + "]");
                out.println("Current Manager ID: " + currentManagerId);
                out.println("</div>");
                
                // Step 2: Check if status matches
                out.println("<h6>Step 2: Check Status Match</h6>");
                out.println("<div class='log-box'>");
                if ("Sent".equals(currentStatus)) {
                    out.println("✓ Status matches 'Sent' - Can proceed with approve");
                } else {
                    out.println("✗ Status is '" + currentStatus + "' - Cannot approve (must be 'Sent')");
                }
                out.println("</div>");
                
                // Step 3: Simulate UPDATE
                out.println("<h6>Step 3: Simulate UPDATE Query</h6>");
                String updateQuery = "UPDATE PurchaseOrders SET status = N'Approved', manager_id = ?, updated_at = GETDATE() WHERE po_id = ?";
                PreparedStatement psUpdate = conn.prepareStatement(updateQuery);
                psUpdate.setInt(1, testManagerId);
                psUpdate.setInt(2, testPoId);
                
                out.println("<div class='log-box'>");
                out.println("Query: " + updateQuery);
                out.println("Param 1 (manager_id): " + testManagerId);
                out.println("Param 2 (po_id): " + testPoId);
                out.println("\n<strong>Executing UPDATE... (DRY RUN - Will rollback)</strong>");
                
                conn.setAutoCommit(false);
                int rowsAffected = psUpdate.executeUpdate();
                
                out.println("\nRows Affected: " + rowsAffected);
                
                if (rowsAffected > 0) {
                    out.println("\n✓ SUCCESS: Update would work!");
                    
                    // Check new values
                    PreparedStatement psVerify = conn.prepareStatement(checkQuery);
                    psVerify.setInt(1, testPoId);
                    ResultSet rsVerify = psVerify.executeQuery();
                    
                    if (rsVerify.next()) {
                        out.println("\nNew Status: [" + rsVerify.getString("status") + "]");
                        out.println("New Manager ID: " + rsVerify.getInt("manager_id"));
                    }
                    rsVerify.close();
                    psVerify.close();
                } else {
                    out.println("\n✗ FAILED: No rows updated!");
                    out.println("\nPossible reasons:");
                    out.println("- PO ID doesn't exist");
                    out.println("- Status is not 'Sent'");
                    out.println("- Database constraint issue");
                }
                
                conn.rollback();
                out.println("\n(Changes rolled back - no actual update)");
                out.println("</div>");
                
                psUpdate.close();
            } else {
                out.println("<div class='alert alert-danger'>PO #" + testPoId + " not found!</div>");
            }
            
            rsCheck.close();
            psCheck.close();
            
            // Step 4: Test with ManagerDAO
            out.println("<h6>Step 4: Test with ManagerDAO.approveStockRequest()</h6>");
            out.println("<div class='log-box'>");
            out.println("Calling: dao.approveStockRequest(" + testPoId + ", " + testManagerId + ")");
            out.println("\nCheck Tomcat console for detailed logs from ManagerDAO...");
            out.println("</div>");
            
            // Note about actual test
            out.println("<div class='alert alert-warning mt-3'>");
            out.println("<strong>Note:</strong> To test the actual ManagerDAO.approveStockRequest() method, ");
            out.println("use the Approve button on the dashboard and check the Tomcat console logs.");
            out.println("</div>");
            
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>");
            out.println("<strong>ERROR:</strong> " + e.getMessage());
            out.println("</div>");
            out.println("<pre>");
            e.printStackTrace(new java.io.PrintWriter(out));
            out.println("</pre>");
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        
        out.println("</div></div>");
        %>
        
        <div class="mt-4">
            <a href="manager-dashboard" class="btn btn-primary">← Back to Dashboard</a>
            <a href="debug-po.jsp" class="btn btn-secondary">View PO Debug</a>
        </div>
    </div>
</body>
</html>