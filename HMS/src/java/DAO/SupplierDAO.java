package DAO;

import model.Supplier;
import model.PurchaseOrder;
import model.PurchaseOrderItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.SupplierTransaction;

public class SupplierDAO extends DBContext {

    // LẤY THÔNG TIN SUPPLIER THEO USER_ID
    public Supplier getSupplierByUserId(int userId) {
        String sql = "SELECT supplier_id, user_id, name, contact_email, contact_phone, "
                + "address, performance_rating "
                + "FROM Suppliers WHERE user_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Supplier supplier = new Supplier();
                supplier.setSupplierId(rs.getInt("supplier_id"));
                supplier.setUserId(rs.getInt("user_id"));
                supplier.setName(rs.getString("name"));
                supplier.setContactEmail(rs.getString("contact_email"));
                supplier.setContactPhone(rs.getString("contact_phone"));
                supplier.setAddress(rs.getString("address"));
                supplier.setPerformanceRating(rs.getDouble("performance_rating"));
                return supplier;
            }
        } catch (SQLException e) {
            System.err.println("Error in getSupplierByUserId: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // LẤY PURCHASE ORDERS THEO SUPPLIER VÀ STATUS (WITH ASN INFO)
    public List<PurchaseOrder> getPurchaseOrdersBySupplier(int supplierId, String status) {
        List<PurchaseOrder> orders = new ArrayList<>();
        String sql = "SELECT po.po_id, po.manager_id, po.supplier_id, po.status, "
                + "po.order_date, po.expected_delivery_date, po.notes, po.updated_at, "
                + "u.username AS manager_name, "
                + "asn.asn_id, asn.tracking_number, asn.carrier, asn.status AS asn_status "
                + "FROM PurchaseOrders po "
                + "LEFT JOIN Users u ON po.manager_id = u.user_id "
                + "LEFT JOIN AdvancedShippingNotices asn ON po.po_id = asn.po_id "
                + "WHERE po.supplier_id = ? AND po.status = ? "
                + "ORDER BY po.order_date DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
            ps.setString(2, status);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                PurchaseOrder po = new PurchaseOrder();
                po.setPoId(rs.getInt("po_id"));
                po.setManagerId(rs.getInt("manager_id"));
                po.setSupplierId(rs.getInt("supplier_id"));
                po.setStatus(rs.getString("status"));
                po.setOrderDate(rs.getTimestamp("order_date"));
                po.setExpectedDeliveryDate(rs.getDate("expected_delivery_date"));
                po.setNotes(rs.getString("notes"));
                po.setUpdatedAt(rs.getTimestamp("updated_at"));
                po.setManagerName(rs.getString("manager_name"));

                // ASN info
                int asnId = rs.getInt("asn_id");
                if (asnId > 0) {
                    po.setAsnId(asnId);
                    po.setTrackingNumber(rs.getString("tracking_number"));
                    po.setCarrier(rs.getString("carrier"));
                    po.setAsnStatus(rs.getString("asn_status"));
                    po.setHasAsn(true);
                }

                // Lấy items và set vào PO
                List<PurchaseOrderItem> items = getPurchaseOrderItems(po.getPoId());
                po.setItems(items);

                // Tính tổng tiền
                double total = items.stream()
                        .mapToDouble(item -> item.getQuantity() * item.getUnitPrice())
                        .sum();
                po.setTotalAmount(total);

                orders.add(po);
            }
        } catch (SQLException e) {
            System.err.println("Error in getPurchaseOrdersBySupplier: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    // LẤY ITEMS CỦA PO
    public List<PurchaseOrderItem> getPurchaseOrderItems(int poId) {
        List<PurchaseOrderItem> items = new ArrayList<>();
        String sql = "SELECT poi.item_id, poi.po_id, poi.medicine_code, poi.quantity, "
                + "poi.unit_price, poi.priority, poi.notes, "
                + "m.name AS medicine_name, m.category, m.strength, m.dosage_form, "
                + "m.unit, m.manufacturer, m.active_ingredient "
                + "FROM PurchaseOrderItems poi "
                + "INNER JOIN Medicines m ON poi.medicine_code = m.medicine_code "
                + "WHERE poi.po_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, poId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                PurchaseOrderItem item = new PurchaseOrderItem();
                item.setItemId(rs.getInt("item_id"));
                item.setPoId(rs.getInt("po_id"));
                item.setMedicineCode(rs.getString("medicine_code"));
                item.setQuantity(rs.getInt("quantity"));

                // Handle NULL unit_price
                double unitPrice = rs.getDouble("unit_price");
                item.setUnitPrice(rs.wasNull() ? 0.0 : unitPrice);

                item.setPriority(rs.getString("priority"));
                item.setNotes(rs.getString("notes"));

                // Thông tin thuốc
                item.setMedicineName(rs.getString("medicine_name"));
                item.setMedicineCategory(rs.getString("category"));
                item.setMedicineStrength(rs.getString("strength"));
                item.setMedicineDosageForm(rs.getString("dosage_form"));
                item.setUnit(rs.getString("unit"));
                item.setMedicineManufacturer(rs.getString("manufacturer"));
                item.setActiveIngredient(rs.getString("active_ingredient"));

                items.add(item);
            }
        } catch (SQLException e) {
            System.err.println("Error in getPurchaseOrderItems: " + e.getMessage());
            e.printStackTrace();
        }
        return items;
    }

    // THỐNG KÊ CHO SUPPLIER (FIXED - Loại bỏ Draft)
    public Map<String, Object> getSupplierStats(int supplierId) {
        Map<String, Object> stats = new HashMap<>();

        String sql = "SELECT "
                + "COUNT(CASE WHEN status = 'Sent' THEN 1 END) AS pending_count, "
                + "COUNT(CASE WHEN status = 'Approved' THEN 1 END) AS approved_count, "
                + "COUNT(CASE WHEN status = 'Completed' THEN 1 END) AS completed_count, "
                + "COUNT(CASE WHEN status IN ('Sent', 'Approved', 'Completed') THEN 1 END) AS total_orders "
                + "FROM PurchaseOrders "
                + "WHERE supplier_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                stats.put("pendingCount", rs.getInt("pending_count"));
                stats.put("approvedCount", rs.getInt("approved_count"));
                stats.put("completedCount", rs.getInt("completed_count"));
                stats.put("totalOrders", rs.getInt("total_orders"));
            } else {
                // Default values if no data
                stats.put("pendingCount", 0);
                stats.put("approvedCount", 0);
                stats.put("completedCount", 0);
                stats.put("totalOrders", 0);
            }
        } catch (SQLException e) {
            System.err.println("Error in getSupplierStats: " + e.getMessage());
            e.printStackTrace();
            stats.put("pendingCount", 0);
            stats.put("approvedCount", 0);
            stats.put("completedCount", 0);
            stats.put("totalOrders", 0);
        }

        return stats;
    }

    // XÁC NHẬN ĐƠN HÀNG (Supplier approves the PO)
    public boolean confirmPurchaseOrder(int poId, int supplierId) {
        String sql = "UPDATE PurchaseOrders SET status = 'Approved', updated_at = GETDATE() "
                + "WHERE po_id = ? AND supplier_id = ? AND status = 'Sent'";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, poId);
            ps.setInt(2, supplierId);
            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                logSupplierAction(supplierId, "CONFIRM_PO", poId, "Supplier confirmed PO #" + poId);
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error in confirmPurchaseOrder: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // TỪ CHỐI ĐƠN HÀNG (Supplier rejects the PO)
    public boolean rejectPurchaseOrder(int poId, int supplierId, String reason) {
        String sql = "UPDATE PurchaseOrders SET status = 'Rejected', "
                + "notes = CONCAT(COALESCE(notes, ''), '\n[REJECTED by Supplier]: ', ?), "
                + "updated_at = GETDATE() "
                + "WHERE po_id = ? AND supplier_id = ? AND status = 'Sent'";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, reason);
            ps.setInt(2, poId);
            ps.setInt(3, supplierId);
            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                logSupplierAction(supplierId, "REJECT_PO", poId, "Supplier rejected PO #" + poId + ": " + reason);
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error in rejectPurchaseOrder: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

// LẤY CHI TIẾT MỘT PO (for detail page & ASN creation) - FIXED TO INCLUDE ASN INFO
    public PurchaseOrder getPurchaseOrderById(int poId, int supplierId) {
        String sql = "SELECT po.po_id, po.manager_id, po.supplier_id, po.status, "
                + "po.order_date, po.expected_delivery_date, po.notes, po.updated_at, "
                + "u.username AS manager_name, s.name AS supplier_name, "
                + "asn.asn_id, asn.tracking_number, asn.carrier, asn.status AS asn_status "
                + "FROM PurchaseOrders po "
                + "LEFT JOIN Users u ON po.manager_id = u.user_id "
                + "LEFT JOIN Suppliers s ON po.supplier_id = s.supplier_id "
                + "LEFT JOIN AdvancedShippingNotices asn ON po.po_id = asn.po_id "
                + "WHERE po.po_id = ? AND po.supplier_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, poId);
            ps.setInt(2, supplierId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                PurchaseOrder po = new PurchaseOrder();
                po.setPoId(rs.getInt("po_id"));
                po.setManagerId(rs.getInt("manager_id"));
                po.setSupplierId(rs.getInt("supplier_id"));
                po.setStatus(rs.getString("status"));
                po.setOrderDate(rs.getTimestamp("order_date"));
                po.setExpectedDeliveryDate(rs.getDate("expected_delivery_date"));
                po.setNotes(rs.getString("notes"));
                po.setUpdatedAt(rs.getTimestamp("updated_at"));
                po.setManagerName(rs.getString("manager_name"));
                po.setSupplierName(rs.getString("supplier_name"));

                // ASN INFO - SAME AS getPurchaseOrdersBySupplier()
                int asnId = rs.getInt("asn_id");
                if (asnId > 0) {
                    po.setAsnId(asnId);
                    po.setTrackingNumber(rs.getString("tracking_number"));
                    po.setCarrier(rs.getString("carrier"));
                    po.setAsnStatus(rs.getString("asn_status"));
                    po.setHasAsn(true);
                }

                // Get items
                List<PurchaseOrderItem> items = getPurchaseOrderItems(po.getPoId());
                po.setItems(items);

                // Calculate total
                double total = items.stream()
                        .mapToDouble(item -> item.getQuantity() * item.getUnitPrice())
                        .sum();
                po.setTotalAmount(total);

                return po;
            }
        } catch (SQLException e) {
            System.err.println("Error in getPurchaseOrderById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // CHECK IF ASN EXISTS FOR PO
    public boolean hasASNForPO(int poId) {
        String sql = "SELECT COUNT(*) FROM AdvancedShippingNotices WHERE po_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, poId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error in hasASNForPO: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // CREATE ASN (COMPLETE VERSION)
    public boolean createASN(int poId, int supplierId, Date shipmentDate,
            String carrier, String trackingNumber, String notes,
            String submittedBy) {
        String sql = "INSERT INTO AdvancedShippingNotices "
                + "(po_id, supplier_id, shipment_date, carrier, tracking_number, "
                + "status, notes, submitted_by, submitted_at, created_at, updated_at) "
                + "VALUES (?, ?, ?, ?, ?, 'Sent', ?, ?, GETDATE(), GETDATE(), GETDATE())";

        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, poId);
            ps.setInt(2, supplierId);
            ps.setDate(3, shipmentDate);
            ps.setString(4, carrier);
            ps.setString(5, trackingNumber);
            ps.setString(6, notes);
            ps.setString(7, submittedBy);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int asnId = generatedKeys.getInt(1);

                    // Copy items from PO to ASN
                    boolean itemsCopied = copyPOItemsToASN(poId, asnId);

                    if (itemsCopied) {
                        logSupplierAction(supplierId, "CREATE_ASN", poId, "Created ASN #" + asnId + " for PO #" + poId);
                        return true;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in createASN: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // COPY PO ITEMS TO ASN ITEMS
    private boolean copyPOItemsToASN(int poId, int asnId) {
        String sql = "INSERT INTO ASNItems (asn_id, medicine_code, quantity, lot_number) "
                + "SELECT ?, medicine_code, quantity, NULL "
                + "FROM PurchaseOrderItems "
                + "WHERE po_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, asnId);
            ps.setInt(2, poId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error copying PO items to ASN: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // LOG SUPPLIER ACTIONS
    private void logSupplierAction(int supplierId, String action, int poId, String details) {
        String sql = "INSERT INTO SystemLogs (user_id, action, table_name, record_id, details, ip_address, log_date) "
                + "SELECT u.user_id, ?, 'PurchaseOrders', ?, ?, '0.0.0.0', GETDATE() "
                + "FROM Suppliers s "
                + "INNER JOIN Users u ON s.user_id = u.user_id "
                + "WHERE s.supplier_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, action);
            ps.setInt(2, poId);
            ps.setString(3, details);
            ps.setInt(4, supplierId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error logging supplier action: " + e.getMessage());
        }
    }

    // GET ALL POs FOR SUPPLIER (all valid statuses, excluding Draft)
    public List<PurchaseOrder> getAllPurchaseOrdersBySupplier(int supplierId) {
        List<PurchaseOrder> orders = new ArrayList<>();
        String sql = "SELECT po.po_id, po.manager_id, po.supplier_id, po.status, "
                + "po.order_date, po.expected_delivery_date, po.notes, po.updated_at, "
                + "u.username AS manager_name "
                + "FROM PurchaseOrders po "
                + "LEFT JOIN Users u ON po.manager_id = u.user_id "
                + "WHERE po.supplier_id = ? AND po.status IN ('Sent', 'Approved', 'Received', 'Completed') "
                + "ORDER BY po.order_date DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                PurchaseOrder po = new PurchaseOrder();
                po.setPoId(rs.getInt("po_id"));
                po.setManagerId(rs.getInt("manager_id"));
                po.setSupplierId(rs.getInt("supplier_id"));
                po.setStatus(rs.getString("status"));
                po.setOrderDate(rs.getTimestamp("order_date"));
                po.setExpectedDeliveryDate(rs.getDate("expected_delivery_date"));
                po.setNotes(rs.getString("notes"));
                po.setUpdatedAt(rs.getTimestamp("updated_at"));
                po.setManagerName(rs.getString("manager_name"));

                List<PurchaseOrderItem> items = getPurchaseOrderItems(po.getPoId());
                po.setItems(items);

                double total = items.stream()
                        .mapToDouble(item -> item.getQuantity() * item.getUnitPrice())
                        .sum();
                po.setTotalAmount(total);

                orders.add(po);
            }
        } catch (SQLException e) {
            System.err.println("Error in getAllPurchaseOrdersBySupplier: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }
    // LẤY TẤT CẢ SUPPLIERS

    public List<Supplier> getAllSuppliers() {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT s.supplier_id, s.user_id, s.name, s.contact_email, "
                + "s.contact_phone, s.address, s.performance_rating, "
                + "s.created_at, s.updated_at, u.username "
                + "FROM Suppliers s "
                + "LEFT JOIN Users u ON s.user_id = u.user_id "
                + "ORDER BY s.name ASC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Supplier supplier = new Supplier();
                supplier.setSupplierId(rs.getInt("supplier_id"));
                supplier.setUserId(rs.getInt("user_id"));
                supplier.setName(rs.getString("name"));
                supplier.setContactEmail(rs.getString("contact_email"));
                supplier.setContactPhone(rs.getString("contact_phone"));
                supplier.setAddress(rs.getString("address"));

                // Handle NULL performance_rating
                Double rating = rs.getDouble("performance_rating");
                supplier.setPerformanceRating(rs.wasNull() ? null : rating);

                // Handle timestamps
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    supplier.setCreatedAt(createdAt.toLocalDateTime());
                }

                Timestamp updatedAt = rs.getTimestamp("updated_at");
                if (updatedAt != null) {
                    supplier.setUpdatedAt(updatedAt.toLocalDateTime());
                }

                suppliers.add(supplier);
            }
        } catch (SQLException e) {
            System.err.println("Error in getAllSuppliers: " + e.getMessage());
            e.printStackTrace();
        }
        return suppliers;
    }

    public boolean createPendingSupplierTransaction(int poId, Integer asnId, double amount) {
        String sql = "INSERT INTO SupplierTransactions "
                + "(supplier_id, po_id, invoice_id, amount, transaction_type, status, notes) "
                + "SELECT po.supplier_id, po.po_id, inv.invoice_id, inv.amount, 'Credit', 'Pending', "
                + "'Payment received from Manager via VNPay, awaiting supplier confirmation' "
                + "FROM PurchaseOrders po "
                + "INNER JOIN Invoices inv ON po.po_id = inv.po_id "
                + "WHERE po.po_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, poId);
            int rows = ps.executeUpdate();

            if (rows > 0) {
                System.out.println("✅ Created pending transaction for PO #" + poId);
                return true;
            } else {
                System.err.println("⚠️ Failed to create pending transaction for PO #" + poId);
                return false;
            }

        } catch (SQLException e) {
            System.err.println("❌ Error creating pending transaction: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get pending transactions for supplier
     */
    public List<SupplierTransaction> getPendingTransactions(int supplierId) {
        List<SupplierTransaction> transactions = new ArrayList<>();
        String sql = "SELECT st.transaction_id, st.supplier_id, st.po_id, st.invoice_id, "
                + "st.amount, st.transaction_type, st.status, st.notes, st.created_at, "
                + "po.order_date, inv.invoice_number, s.name as supplier_name "
                + "FROM SupplierTransactions st "
                + "INNER JOIN PurchaseOrders po ON st.po_id = po.po_id "
                + "INNER JOIN Invoices inv ON st.invoice_id = inv.invoice_id "
                + "INNER JOIN Suppliers s ON st.supplier_id = s.supplier_id "
                + "WHERE st.supplier_id = ? AND st.status = 'Pending' "
                + "ORDER BY st.created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                SupplierTransaction trans = new SupplierTransaction();
                trans.setTransactionId(rs.getInt("transaction_id"));
                trans.setSupplierId(rs.getInt("supplier_id"));
                trans.setPoId(rs.getInt("po_id"));
                trans.setInvoiceId(rs.getInt("invoice_id"));
                trans.setAmount(rs.getDouble("amount"));
                trans.setTransactionType(rs.getString("transaction_type"));
                trans.setStatus(rs.getString("status"));
                trans.setNotes(rs.getString("notes"));
                trans.setCreatedAt(rs.getTimestamp("created_at"));
                trans.setSupplierName(rs.getString("supplier_name"));
                trans.setInvoiceNumber(rs.getString("invoice_number"));
                transactions.add(trans);
            }
        } catch (SQLException e) {
            System.err.println("Error getting pending transactions: " + e.getMessage());
            e.printStackTrace();
        }

        return transactions;
    }

    /**
     * Confirm transaction and credit supplier balance Also updates PO status
     * from 'Paid' to 'Completed'
     */
    public boolean confirmTransaction(int transactionId, int supplierId, int userId) {
        System.out.println("=== Confirming Transaction ===");
        System.out.println("Transaction ID: " + transactionId);
        System.out.println("Supplier ID: " + supplierId);
        System.out.println("User ID: " + userId);

        Connection conn = null;
        try {
            conn = connection;
            conn.setAutoCommit(false);

            // 1. Get transaction details AND current balance
            String getInfoSql = "SELECT st.amount, st.po_id, ISNULL(s.balance, 0) as current_balance "
                    + "FROM SupplierTransactions st "
                    + "INNER JOIN Suppliers s ON st.supplier_id = s.supplier_id "
                    + "WHERE st.transaction_id = ? AND st.supplier_id = ? AND st.status = 'Pending'";

            double amount = 0;
            int poId = 0;
            double currentBalance = 0;

            try (PreparedStatement ps = conn.prepareStatement(getInfoSql)) {
                ps.setInt(1, transactionId);
                ps.setInt(2, supplierId);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    amount = rs.getDouble("amount");
                    poId = rs.getInt("po_id");
                    currentBalance = rs.getDouble("current_balance");

                    System.out.println("   Transaction found:");
                    System.out.println("   - Amount: " + amount);
                    System.out.println("   - PO ID: " + poId);
                    System.out.println("   - Current Balance: " + currentBalance);
                    System.out.println("   - New Balance will be: " + (currentBalance + amount));
                } else {
                    conn.rollback();
                    System.err.println("⚠️ Transaction #" + transactionId + " not found or already confirmed");
                    return false;
                }
            }

            // 2. Update transaction status first
            String updateTrans = "UPDATE SupplierTransactions "
                    + "SET status = 'Confirmed', confirmed_by = ?, confirmed_at = GETDATE() "
                    + "WHERE transaction_id = ? AND supplier_id = ? AND status = 'Pending'";

            try (PreparedStatement ps = conn.prepareStatement(updateTrans)) {
                ps.setInt(1, userId);
                ps.setInt(2, transactionId);
                ps.setInt(3, supplierId);
                int rows = ps.executeUpdate();

                if (rows == 0) {
                    conn.rollback();
                    System.err.println("⚠️ Failed to update transaction status - may already be confirmed");
                    return false;
                }
                System.out.println("✅ Step 1/3: Updated transaction status to Confirmed");
            }

            // 3. Update supplier balance - MOST IMPORTANT PART
            // Using direct calculation instead of relying on subquery
            String updateBalance = "UPDATE Suppliers "
                    + "SET balance = ISNULL(balance, 0) + ? "
                    + "WHERE supplier_id = ?";

            try (PreparedStatement ps = conn.prepareStatement(updateBalance)) {
                ps.setDouble(1, amount);
                ps.setInt(2, supplierId);
                int rows = ps.executeUpdate();

                if (rows == 0) {
                    conn.rollback();
                    System.err.println("❌ Failed to update supplier balance - supplier not found!");
                    return false;
                }

                System.out.println("✅ Step 2/3: Updated supplier balance");
                System.out.println("   - Old balance: " + currentBalance);
                System.out.println("   - Added: " + amount);
                System.out.println("   - New balance should be: " + (currentBalance + amount));
                System.out.println("   - Rows affected: " + rows);
            }

            // 4. Verify balance was actually updated
            String verifyBalanceSql = "SELECT balance FROM Suppliers WHERE supplier_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(verifyBalanceSql)) {
                ps.setInt(1, supplierId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    double newBalance = rs.getDouble("balance");
                    System.out.println("   - Verified new balance in DB: " + newBalance);

                    if (newBalance != (currentBalance + amount)) {
                        System.err.println("⚠️ WARNING: Balance mismatch!");
                        System.err.println("   Expected: " + (currentBalance + amount));
                        System.err.println("   Got: " + newBalance);
                    }
                }
            }

            // 5. Update Purchase Order status to Completed
            String updatePO = "UPDATE PurchaseOrders "
                    + "SET status = 'Completed', updated_at = GETDATE() "
                    + "WHERE po_id = ? AND status = 'Paid'";

            try (PreparedStatement ps = conn.prepareStatement(updatePO)) {
                ps.setInt(1, poId);
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    System.out.println("✅ Step 3/3: Updated PO #" + poId + " status from 'Paid' to 'Completed'");
                } else {
                    System.out.println("⚠️ PO #" + poId + " was not in 'Paid' status (may already be Completed)");
                }
            }

            // Commit all changes
            conn.commit();
            System.out.println("✅ Transaction committed successfully!");

            // Log action
            logSupplierAction(supplierId, "CONFIRM_PAYMENT", transactionId,
                    "Supplier confirmed payment receipt for transaction #" + transactionId
                    + " - Amount: " + amount + " - New Balance: " + (currentBalance + amount));

            System.out.println("✅ Successfully confirmed transaction #" + transactionId);
            return true;

        } catch (SQLException e) {
            try {
                if (conn != null) {
                    conn.rollback();
                    System.err.println("❌ Transaction rolled back due to error");
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            System.err.println("❌ Error confirming transaction: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Get supplier current balance
     */
    public double getSupplierBalance(int supplierId) {
        String sql = "SELECT ISNULL(balance, 0) as balance FROM Suppliers WHERE supplier_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, supplierId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getDouble("balance");
            }
        } catch (SQLException e) {
            System.err.println("Error getting supplier balance: " + e.getMessage());
            e.printStackTrace();
        }

        return 0.0;
    }
    
    // ===================================================================
// THÊM METHOD NÀY VÀO CLASS SupplierDAO 
// (Thêm sau method getSupplierByUserId, trước getPurchaseOrdersBySupplier)
// ===================================================================

/**
 * Get supplier by supplier ID (not user ID)
 * Used for notifications and other operations that reference supplier_id
 * @param supplierId The supplier ID
 * @return Supplier object or null if not found
 */
public Supplier getSupplierById(int supplierId) {
    String sql = "SELECT supplier_id, user_id, name, contact_email, contact_phone, " +
                 "address, performance_rating, created_at, updated_at " +
                 "FROM Suppliers WHERE supplier_id = ?";
    
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, supplierId);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            Supplier supplier = new Supplier();
            supplier.setSupplierId(rs.getInt("supplier_id"));
            supplier.setUserId(rs.getInt("user_id"));
            supplier.setName(rs.getString("name"));
            supplier.setContactEmail(rs.getString("contact_email"));
            supplier.setContactPhone(rs.getString("contact_phone"));
            supplier.setAddress(rs.getString("address"));
            
            // Handle NULL performance_rating
            Double rating = rs.getDouble("performance_rating");
            supplier.setPerformanceRating(rs.wasNull() ? null : rating);
            
            // Handle timestamps
            Timestamp createdAt = rs.getTimestamp("created_at");
            if (createdAt != null) {
                supplier.setCreatedAt(createdAt.toLocalDateTime());
            }
            
            Timestamp updatedAt = rs.getTimestamp("updated_at");
            if (updatedAt != null) {
                supplier.setUpdatedAt(updatedAt.toLocalDateTime());
            }
            
            System.out.println("✓ Found supplier by ID " + supplierId + ": " + supplier.getName());
            return supplier;
        } else {
            System.out.println("⚠️ Supplier not found for ID: " + supplierId);
        }
    } catch (SQLException e) {
        System.err.println("❌ Error in getSupplierById: " + e.getMessage());
        e.printStackTrace();
    }
    return null;
}

/**
 * Get COMPLETED orders for supplier
 * Includes both 'Completed' and 'BatchCreated' statuses
 * @param supplierId The supplier ID
 * @return List of completed purchase orders with full details
 */
public List<PurchaseOrder> getCompletedOrdersBySupplier(int supplierId) {
    List<PurchaseOrder> orders = new ArrayList<>();
    String sql = "SELECT po.po_id, po.manager_id, po.supplier_id, po.status, "
            + "po.order_date, po.expected_delivery_date, po.notes, po.updated_at, "
            + "u.username AS manager_name, "
            + "asn.asn_id, asn.tracking_number, asn.carrier, asn.status AS asn_status, "
            + "asn.shipment_date, "
            + "(SELECT COUNT(*) FROM Batches b WHERE b.medicine_code IN "
            + "  (SELECT medicine_code FROM PurchaseOrderItems WHERE po_id = po.po_id)) AS batch_count "
            + "FROM PurchaseOrders po "
            + "LEFT JOIN Users u ON po.manager_id = u.user_id "
            + "LEFT JOIN AdvancedShippingNotices asn ON po.po_id = asn.po_id "
            + "WHERE po.supplier_id = ? "
            + "AND po.status IN ('Completed', 'BatchCreated') "
            + "ORDER BY po.updated_at DESC";

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, supplierId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            PurchaseOrder po = new PurchaseOrder();
            po.setPoId(rs.getInt("po_id"));
            po.setManagerId(rs.getInt("manager_id"));
            po.setSupplierId(rs.getInt("supplier_id"));
            po.setStatus(rs.getString("status"));
            po.setOrderDate(rs.getTimestamp("order_date"));
            po.setExpectedDeliveryDate(rs.getDate("expected_delivery_date"));
            po.setNotes(rs.getString("notes"));
            po.setUpdatedAt(rs.getTimestamp("updated_at"));
            po.setManagerName(rs.getString("manager_name"));

            // ASN info
            int asnId = rs.getInt("asn_id");
            if (asnId > 0) {
                po.setAsnId(asnId);
                po.setTrackingNumber(rs.getString("tracking_number"));
                po.setCarrier(rs.getString("carrier"));
                po.setAsnStatus(rs.getString("asn_status"));
                po.setHasAsn(true);
            }
            
            // Batch info
            int batchCount = rs.getInt("batch_count");
            po.setBatchCount(batchCount); // Add this field to PurchaseOrder model

            // Get items
            List<PurchaseOrderItem> items = getPurchaseOrderItems(po.getPoId());
            po.setItems(items);

            // Calculate total
            double total = items.stream()
                    .mapToDouble(item -> item.getQuantity() * item.getUnitPrice())
                    .sum();
            po.setTotalAmount(total);

            orders.add(po);
        }
        
        System.out.println("✅ Loaded " + orders.size() + " completed/batchCreated orders for Supplier #" + supplierId);
    } catch (SQLException e) {
        System.err.println("Error in getCompletedOrdersBySupplier: " + e.getMessage());
        e.printStackTrace();
    }
    return orders;
}

}
