package DAO;

import DAO.DBContext;
import model.Invoice;
import model.AdvancedShippingNotice;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class InvoiceDAO {
    
    // Lấy tất cả hóa đơn
    public List<Invoice> getAllInvoices() {
        List<Invoice> invoices = new ArrayList<>();
        String sql = "SELECT * FROM Invoices ORDER BY invoice_date DESC";
        
        try (Connection conn = DBContext.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Invoice invoice = new Invoice();
                invoice.setInvoiceId(rs.getInt("invoice_id"));
                invoice.setPoId(rs.getInt("po_id"));
                invoice.setAsnId(rs.getInt("asn_id"));
                invoice.setSupplierId(rs.getInt("supplier_id"));
                invoice.setInvoiceNumber(rs.getString("invoice_number"));
                invoice.setInvoiceDate(rs.getDate("invoice_date"));
                invoice.setAmount(rs.getBigDecimal("amount"));
                invoice.setStatus(rs.getString("status"));
                invoice.setNotes(rs.getString("notes"));
                invoice.setMomoTransactionId(rs.getString("momo_transaction_id"));
                invoice.setPaymentUrl(rs.getString("payment_url"));
                invoice.setPaymentDate(rs.getDate("payment_date"));
                
                invoices.add(invoice);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return invoices;
    }
    
    // Lấy hóa đơn theo ID
    public Invoice getInvoiceById(int invoiceId) {
        String sql = "SELECT * FROM Invoices WHERE invoice_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, invoiceId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Invoice invoice = new Invoice();
                invoice.setInvoiceId(rs.getInt("invoice_id"));
                invoice.setPoId(rs.getInt("po_id"));
                invoice.setAsnId(rs.getInt("asn_id"));
                invoice.setSupplierId(rs.getInt("supplier_id"));
                invoice.setInvoiceNumber(rs.getString("invoice_number"));
                invoice.setInvoiceDate(rs.getDate("invoice_date"));
                invoice.setAmount(rs.getBigDecimal("amount"));
                invoice.setStatus(rs.getString("status"));
                invoice.setNotes(rs.getString("notes"));
                invoice.setMomoTransactionId(rs.getString("momo_transaction_id"));
                invoice.setPaymentUrl(rs.getString("payment_url"));
                invoice.setPaymentDate(rs.getDate("payment_date"));
                
                return invoice;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Cập nhật payment URL
    public boolean updatePaymentUrl(int invoiceId, String paymentUrl) {
        String sql = "UPDATE Invoices SET payment_url = ? WHERE invoice_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, paymentUrl);
            pstmt.setInt(2, invoiceId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Cập nhật trạng thái thanh toán
    public boolean updatePaymentStatus(int invoiceId, String status, String momoTransactionId) {
        String sql = "UPDATE Invoices SET status = ?, momo_transaction_id = ?, payment_date = GETDATE() WHERE invoice_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setString(2, momoTransactionId);
            pstmt.setInt(3, invoiceId);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Lấy hóa đơn chưa thanh toán
    public List<Invoice> getPendingInvoices() {
        List<Invoice> invoices = new ArrayList<>();
        String sql = "SELECT * FROM Invoices WHERE status = 'Pending' ORDER BY invoice_date DESC";
        
        try (Connection conn = DBContext.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Invoice invoice = new Invoice();
                invoice.setInvoiceId(rs.getInt("invoice_id"));
                invoice.setInvoiceNumber(rs.getString("invoice_number"));
                invoice.setInvoiceDate(rs.getDate("invoice_date"));
                invoice.setAmount(rs.getBigDecimal("amount"));
                invoice.setStatus(rs.getString("status"));
                
                invoices.add(invoice);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return invoices;
    }
    
    /**
     * Tạo Invoice cho ASN - FIXED VERSION
     */
    public int createInvoiceForASN(AdvancedShippingNotice asn, int asnId, int userId) {
        // SQL không có payment_method nữa (nếu column không tồn tại)
        String sql = "INSERT INTO Invoices (po_id, asn_id, supplier_id, invoice_number, invoice_date, amount, status, notes) " +
                     "VALUES (?, ?, ?, ?, GETDATE(), ?, 'Pending', ?)";
       
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBContext.getConnection();
            
            System.out.println("=================================================");
            System.out.println("📝 CREATING INVOICE FOR ASN #" + asnId);
            System.out.println("=================================================");
            
            // 1. Validate ASN
            if (asn == null) {
                System.err.println("❌ ASN object is NULL!");
                return -1;
            }
            
            int poId = asn.getPoId();
            int supplierId = asn.getSupplierId();
            
            System.out.println("PO ID: " + poId);
            System.out.println("Supplier ID: " + supplierId);
            System.out.println("User ID: " + userId);
            
            // 2. Validate Supplier ID
            if (supplierId <= 0) {
                System.err.println("❌ Invalid supplier ID: " + supplierId);
                System.err.println("⚠️  ASN may not have been loaded with supplier info!");
                
                // TRY TO GET SUPPLIER ID FROM PO
                supplierId = getSupplierIdFromPO(poId);
                if (supplierId <= 0) {
                    System.err.println("❌ Could not retrieve supplier ID from PO either!");
                    return -1;
                }
                System.out.println("✅ Retrieved supplier ID from PO: " + supplierId);
            }
            
            // 3. Calculate Total Amount
            BigDecimal totalAmount = calculateTotalAmount(poId);
            System.out.println("Calculated Amount: " + totalAmount);
            
            if (totalAmount == null || totalAmount.compareTo(BigDecimal.ZERO) <= 0) {
                System.err.println("❌ Invalid total amount: " + totalAmount);
                System.err.println("⚠️  PurchaseOrderItems may be empty or have invalid prices!");
                return -1;
            }
            
            // 4. Generate Invoice Number
            String invoiceNumber = "INV-" + poId + "-" + System.currentTimeMillis();
            System.out.println("Invoice Number: " + invoiceNumber);
            
            // 5. Execute Insert
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setInt(1, poId);
            pstmt.setInt(2, asnId);
            pstmt.setInt(3, supplierId);
            pstmt.setString(4, invoiceNumber);
            pstmt.setBigDecimal(5, totalAmount);
            pstmt.setString(6, "Invoice for PO #" + poId + ", confirmed by Manager ID: " + userId);
            
            int affected = pstmt.executeUpdate();
            System.out.println("Rows affected: " + affected);
            
            if (affected > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    int invoiceId = rs.getInt(1);
                    System.out.println("✅ Invoice created successfully! ID: " + invoiceId);
                    System.out.println("=================================================");
                    return invoiceId;
                } else {
                    System.err.println("❌ No generated keys returned from INSERT!");
                }
            } else {
                System.err.println("❌ No rows inserted!");
            }
           
        } catch (SQLException e) {
            System.err.println("❌ SQLException: " + e.getMessage());
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("❌ Unexpected error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        System.out.println("=================================================");
        return -1;
    }
    
    /**
     * Lấy Supplier ID từ Purchase Order (backup method)
     */
    private int getSupplierIdFromPO(int poId) {
        String sql = "SELECT supplier_id FROM PurchaseOrders WHERE po_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, poId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("supplier_id");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting supplier ID from PO: " + e.getMessage());
            e.printStackTrace();
        }
        
        return -1;
    }
    
    /**
     * Tính tổng tiền từ Purchase Order Items
     */
    private BigDecimal calculateTotalAmount(int poId) {
        String sql = "SELECT SUM(quantity * unit_price) as total FROM PurchaseOrderItems WHERE po_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, poId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                BigDecimal total = rs.getBigDecimal("total");
                System.out.println("💰 Total from PurchaseOrderItems: " + total);
                return total != null ? total : BigDecimal.ZERO;
            }
            
        } catch (SQLException e) {
            System.err.println("Error calculating total: " + e.getMessage());
            e.printStackTrace();
        }
        
        return BigDecimal.ZERO;
    }
}