package model;

import java.sql.Timestamp;

public class SupplierTransaction {
    private int transactionId;
    private int supplierId;
    private int poId;
    private int invoiceId;
    private double amount;
    private String transactionType; // Credit, Debit, Pending, Confirmed
    private String status; // Pending, Confirmed, Rejected
    private int confirmedBy;
    private Timestamp confirmedAt;
    private String notes;
    private Timestamp createdAt;
    
    // Additional fields for display
    private String supplierName;
    private String invoiceNumber;
    
    public SupplierTransaction() {
    }
    
    // Getters and Setters
    public int getTransactionId() {
        return transactionId;
    }
    
    public void setTransactionId(int transactionId) {
        this.transactionId = transactionId;
    }
    
    public int getSupplierId() {
        return supplierId;
    }
    
    public void setSupplierId(int supplierId) {
        this.supplierId = supplierId;
    }
    
    public int getPoId() {
        return poId;
    }
    
    public void setPoId(int poId) {
        this.poId = poId;
    }
    
    public int getInvoiceId() {
        return invoiceId;
    }
    
    public void setInvoiceId(int invoiceId) {
        this.invoiceId = invoiceId;
    }
    
    public double getAmount() {
        return amount;
    }
    
    public void setAmount(double amount) {
        this.amount = amount;
    }
    
    public String getTransactionType() {
        return transactionType;
    }
    
    public void setTransactionType(String transactionType) {
        this.transactionType = transactionType;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public int getConfirmedBy() {
        return confirmedBy;
    }
    
    public void setConfirmedBy(int confirmedBy) {
        this.confirmedBy = confirmedBy;
    }
    
    public Timestamp getConfirmedAt() {
        return confirmedAt;
    }
    
    public void setConfirmedAt(Timestamp confirmedAt) {
        this.confirmedAt = confirmedAt;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public String getSupplierName() {
        return supplierName;
    }
    
    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }
    
    public String getInvoiceNumber() {
        return invoiceNumber;
    }
    
    public void setInvoiceNumber(String invoiceNumber) {
        this.invoiceNumber = invoiceNumber;
    }
    
    public String getStatusBadgeClass() {
        if (status == null) return "badge bg-secondary";
        switch (status) {
            case "Pending":
                return "badge bg-warning";
            case "Confirmed":
                return "badge bg-success";
            case "Rejected":
                return "badge bg-danger";
            default:
                return "badge bg-secondary";
        }
    }
}