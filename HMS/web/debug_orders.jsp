<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Debug - Purchase Orders</title>
    <style>
        body {
            font-family: 'Courier New', monospace;
            background: #1e1e1e;
            color: #d4d4d4;
            padding: 20px;
            margin: 0;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: #252526;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.5);
        }
        h1 {
            color: #4ec9b0;
            border-bottom: 2px solid #4ec9b0;
            padding-bottom: 10px;
        }
        h2 {
            color: #569cd6;
            margin-top: 30px;
        }
        .success {
            background: #1e3a1e;
            border-left: 4px solid #4ec9b0;
            padding: 15px;
            margin: 10px 0;
        }
        .error {
            background: #3a1e1e;
            border-left: 4px solid #f48771;
            padding: 15px;
            margin: 10px 0;
        }
        .info {
            background: #1e2a3a;
            border-left: 4px solid #569cd6;
            padding: 15px;
            margin: 10px 0;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            background: #1e1e1e;
        }
        th {
            background: #2d2d30;
            color: #4ec9b0;
            padding: 12px;
            text-align: left;
            border: 1px solid #3e3e42;
        }
        td {
            padding: 10px 12px;
            border: 1px solid #3e3e42;
        }
        tr:nth-child(even) {
            background: #252526;
        }
        tr:hover {
            background: #2a2d2e;
        }
        .badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        .badge-success { background: #4ec9b0; color: #000; }
        .badge-warning { background: #dcdcaa; color: #000; }
        .badge-danger { background: #f48771; color: #000; }
        .badge-info { background: #569cd6; color: #000; }
        code {
            background: #1e1e1e;
            padding: 2px 6px;
            border-radius: 3px;
            color: #ce9178;
        }
        pre {
            background: #1e1e1e;
            padding: 15px;
            border-radius: 5px;
            overflow-x: auto;
            border: 1px solid #3e3e42;
            white-space: pre-wrap;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>🔍 Debug - Purchase Orders Database</h1>
    <p style="color: #858585;">Thời gian: <%= new java.util.Date() %></p>

    <%
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
            String url = "jdbc:sqlserver://localhost:1433;databaseName=SWP391";
            String username = "sa";
            String password = "123";
        
        int testNumber = 0;
    %>

    <!-- TEST 3: Kiểm tra bảng PurchaseOrders -->
    <h2>✅ TEST 3: Bảng PurchaseOrders</h2>
    <%
        testNumber++;
        String sqlCheckTable = "SELECT COUNT(*) AS total FROM PurchaseOrders";
        try {
            ps = conn.prepareStatement(sqlCheckTable);
            rs = ps.executeQuery();
            if (rs.next()) {
                int totalPO = rs.getInt("total");
    %>
        <div class="success">
            <strong>✅ PASS:</strong> Bảng PurchaseOrders tồn tại!<br>
            Tổng số đơn hàng: <code><%= totalPO %></code> đơn
        </div>
    <%
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
    %>
        <div class="error">
            <strong>❌ FAIL:</strong> Lỗi khi truy vấn bảng PurchaseOrders!<br>
            Error: <code><%= e.getMessage() %></code>
        </div>
    <%
        }
    %>

    <!-- TEST 4: Đếm đơn hàng theo status -->
    <h2>✅ TEST 4: Đếm đơn hàng theo Status</h2>
    <%
        testNumber++;
        String sqlCountStatus = "SELECT status, COUNT(*) AS count FROM PurchaseOrders GROUP BY status";
        try {
            ps = conn.prepareStatement(sqlCountStatus);
            rs = ps.executeQuery();
    %>
        <table>
            <thead>
                <tr>
                    <th>Status</th>
                    <th>Số lượng</th>
                </tr>
            </thead>
            <tbody>
    <%
            boolean hasData = false;
            while (rs.next()) {
                hasData = true;
                String status = rs.getString("status");
                int count = rs.getInt("count");
                String badgeClass = "";
                
                if ("Completed".equals(status)) {
                    badgeClass = "badge-success";
                } else if ("Sent".equals(status)) {
                    badgeClass = "badge-info";
                } else if ("Draft".equals(status)) {
                    badgeClass = "badge-warning";
                } else if ("Rejected".equals(status)) {
                    badgeClass = "badge-danger";
                } else {
                    badgeClass = "badge-info";
                }
    %>
                <tr>
                    <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
                    <td><strong><%= count %></strong> đơn</td>
                </tr>
    <%
            }
            if (!hasData) {
    %>
                <tr>
                    <td colspan="2" style="text-align: center; color: #858585;">
                        Không có dữ liệu
                    </td>
                </tr>
    <%
            }
    %>
            </tbody>
        </table>
    <%
            rs.close();
            ps.close();
        } catch (SQLException e) {
    %>
        <div class="error">
            <strong>❌ FAIL:</strong> Lỗi khi đếm status!<br>
            Error: <code><%= e.getMessage() %></code>
        </div>
    <%
        }
    %>

    <!-- TEST 5: Chi tiết đơn hàng Completed -->
    <h2>✅ TEST 5: Danh sách đơn hàng Completed</h2>
    <%
        testNumber++;
        String sqlCompleted = "SELECT po.po_id, po.status, po.order_date, " +
                              "po.expected_delivery_date, po.notes, s.name AS supplier_name " +
                              "FROM PurchaseOrders po " +
                              "LEFT JOIN Suppliers s ON po.supplier_id = s.supplier_id " +
                              "WHERE po.status = 'Completed' " +
                              "ORDER BY po.order_date DESC";
        
        try {
            ps = conn.prepareStatement(sqlCompleted);
            rs = ps.executeQuery();
    %>
        <div class="info">
            <strong>📋 SQL Query:</strong>
            <pre><%= sqlCompleted %></pre>
        </div>

        <table>
            <thead>
                <tr>
                    <th>PO ID</th>
                    <th>Status</th>
                    <th>Nhà cung cấp</th>
                    <th>Ngày đặt</th>
                    <th>Ngày giao dự kiến</th>
                    <th>Ghi chú</th>
                </tr>
            </thead>
            <tbody>
    <%
            int completedCount = 0;
            boolean hasCompleted = false;
            
            while (rs.next()) {
                hasCompleted = true;
                completedCount++;
                int poId = rs.getInt("po_id");
                String status = rs.getString("status");
                String supplierName = rs.getString("supplier_name");
                java.sql.Date orderDate = rs.getDate("order_date");
                java.sql.Date expectedDate = rs.getDate("expected_delivery_date");
                String notes = rs.getString("notes");
    %>
                <tr>
                    <td><strong>#<%= poId %></strong></td>
                    <td><span class="badge badge-success"><%= status %></span></td>
                    <td><%= supplierName != null ? supplierName : "<em>N/A</em>" %></td>
                    <td><%= orderDate != null ? orderDate.toString() : "N/A" %></td>
                    <td><%= expectedDate != null ? expectedDate.toString() : "N/A" %></td>
                    <td><%= notes != null ? notes : "" %></td>
                </tr>
    <%
            }
            
            if (!hasCompleted) {
    %>
                <tr>
                    <td colspan="6" style="text-align: center; color: #f48771;">
                        ⚠️ KHÔNG CÓ ĐƠN HÀNG NÀO CÓ STATUS = 'Completed'
                    </td>
                </tr>
    <%
            } else {
    %>
                <tr style="background: #2d2d30; font-weight: bold;">
                    <td colspan="6" style="text-align: right;">
                        Tổng cộng: <span class="badge badge-success"><%= completedCount %></span> đơn hàng
                    </td>
                </tr>
    <%
            }
    %>
            </tbody>
        </table>
    <%
            rs.close();
            ps.close();
        } catch (SQLException e) {
    %>
        <div class="error">
            <strong>❌ FAIL:</strong> Lỗi khi lấy danh sách Completed!<br>
            Error: <code><%= e.getMessage() %></code>
        </div>
    <%
        }
    %>

    <!-- TEST 6: Kiểm tra Servlet mapping -->
    <h2>✅ TEST 6: Servlet Path</h2>
    <div class="info">
        <strong>🔗 Thông tin Request:</strong><br>
        Context Path: <code><%= request.getContextPath() %></code><br>
        Servlet Path: <code><%= request.getServletPath() %></code><br>
        Request URI: <code><%= request.getRequestURI() %></code><br>
        <br>
        <strong>📍 URL cần test:</strong><br>
        <a href="<%= request.getContextPath() %>/pharmacist/ViewDeliveredOrder" 
           style="color: #4ec9b0; text-decoration: none;">
            <%= request.getScheme() %>://<%= request.getServerName() %>:<%= request.getServerPort() %><%= request.getContextPath() %>/pharmacist/ViewDeliveredOrder
        </a>
    </div>

    <!-- TEST 7: Kiểm tra có lô thuốc nào từ PO không -->
    <h2>✅ TEST 7: Kiểm tra Batches từ PO</h2>
    <%
        testNumber++;
        String sqlBatches = "SELECT b.batch_id, b.lot_number, b.quarantine_notes, b.status " +
                            "FROM Batches b " +
                            "WHERE b.quarantine_notes LIKE '%Lô từ đơn hàng%' " +
                            "ORDER BY b.batch_id DESC";
        
        try {
            ps = conn.prepareStatement(sqlBatches);
            rs = ps.executeQuery();
    %>
        <table>
            <thead>
                <tr>
                    <th>Batch ID</th>
                    <th>Lot Number</th>
                    <th>Status</th>
                    <th>Notes</th>
                </tr>
            </thead>
            <tbody>
    <%
            int batchCount = 0;
            while (rs.next()) {
                batchCount++;
                int batchId = rs.getInt("batch_id");
                String lotNumber = rs.getString("lot_number");
                String status = rs.getString("status");
                String notes = rs.getString("quarantine_notes");
    %>
                <tr>
                    <td><%= batchId %></td>
                    <td><code><%= lotNumber %></code></td>
                    <td><%= status %></td>
                    <td><%= notes %></td>
                </tr>
    <%
            }
            
            if (batchCount == 0) {
    %>
                <tr>
                    <td colspan="4" style="text-align: center; color: #858585;">
                        ℹ️ Chưa có lô thuốc nào được tạo từ đơn hàng
                    </td>
                </tr>
    <%
            }
    %>
            </tbody>
        </table>
    <%
            rs.close();
            ps.close();
        } catch (SQLException e) {
    %>
        <div class="error">
            <strong>❌ FAIL:</strong> Lỗi khi kiểm tra Batches!<br>
            Error: <code><%= e.getMessage() %></code>
        </div>
    <%
        }
    %>

    <!-- TEST 8: Kiểm tra web.xml mapping -->
    <h2>✅ TEST 8: Servlet Mapping trong web.xml</h2>
    <div class="info">
        <strong>🔍 Cần kiểm tra trong web.xml:</strong><br>
        <pre>&lt;servlet&gt;
    &lt;servlet-name&gt;ViewDeliveredOrderServlet&lt;/servlet-name&gt;
    &lt;servlet-class&gt;Controller.ViewDeliveredOrderDetailsServlet&lt;/servlet-class&gt;
&lt;/servlet&gt;
&lt;servlet-mapping&gt;
    &lt;servlet-name&gt;ViewDeliveredOrderServlet&lt;/servlet-name&gt;
    &lt;url-pattern&gt;/pharmacist/ViewDeliveredOrder&lt;/url-pattern&gt;
&lt;/servlet-mapping&gt;</pre>
        
        <strong style="color: #f48771;">⚠️ Nếu servlet không có trong web.xml → Đơn hàng sẽ không hiển thị!</strong>
    </div>

    <!-- Kết luận -->
    <h2>📊 Tóm tắt</h2>
    <div class="info">
        <strong>Kết quả kiểm tra:</strong><br>
        - Tổng số test: <code><%= testNumber %></code><br>
        - Database: <code><%= conn != null ? "✅ Connected" : "❌ Disconnected" %></code><br>
        - Project Path: <code><%= request.getContextPath() %></code><br>
        <br>
        <strong>🎯 Next steps:</strong><br>
        1. Nếu TEST 5 có đơn Completed → Vấn đề ở servlet mapping<br>
        2. Nếu TEST 5 không có đơn Completed → Chạy lại script tạo dữ liệu<br>
        3. Kiểm tra servlet có trong web.xml chưa<br>
        4. Restart Tomcat sau khi sửa web.xml
    </div>

</div>

</body>
</html>