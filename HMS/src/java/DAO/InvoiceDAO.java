package DAO;

import DAO.DBContext;
import model.Invoice;
import DAO.DBContext;
import java.math.BigDecimal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.AdvancedShippingNotice;

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
        String sql = "UPDATE Invoices SET payment_url = ?, payment_method = 'MoMo' WHERE invoice_id = ?";
        
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
        public int createInvoiceForASN(AdvancedShippingNotice asn, int asnId, int userId) {
        String sql = "INSERT INTO Invoices (po_id, asn_id, supplier_id, invoice_number, invoice_date, amount, status, notes, payment_method) " +
                     "VALUES (?, ?, ?, ?, GETDATE(), ?, 'Pending', ?, 'MoMo')";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            // 1. Tính tổng tiền từ PO Items
            BigDecimal totalAmount = calculateTotalAmount(asn.getPoId());
            
            // 2. Tạo Invoice Number tự động
            String invoiceNumber = "INV-" + asn.getPoId() + "-" + System.currentTimeMillis();
            
            pstmt.setInt(1, asn.getPoId());
            pstmt.setInt(2, asnId);
            pstmt.setInt(3, asn.getSupplierId());
            pstmt.setString(4, invoiceNumber);
            pstmt.setBigDecimal(5, totalAmount);
            pstmt.setString(6, "Invoice for PO #" + asn.getPoId() + ", confirmed by Manager");
            
            int affected = pstmt.executeUpdate();
            
            if (affected > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1); // Return invoice_id
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error creating invoice: " + e.getMessage());
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
                return total != null ? total : BigDecimal.ZERO;
            }
            
        } catch (SQLException e) {
            System.err.println("Error calculating total: " + e.getMessage());
            e.printStackTrace();
        }
        
        return BigDecimal.ZERO;
    }
}