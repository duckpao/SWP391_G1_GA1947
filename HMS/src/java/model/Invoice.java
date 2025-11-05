package model;

import java.sql.Date;
import java.math.BigDecimal;

public class Invoice {
    private int invoiceId;
    private int poId;
    private int asnId;
    private int supplierId;
    private String invoiceNumber;
    private Date invoiceDate;
    private BigDecimal amount;
    private String status; // Pending, Paid, Disputed
    private String notes;
    private String momoTransactionId;
    private String paymentMethod;
    private String paymentUrl;
    private Date paymentDate;
    
    // Constructors
    public Invoice() {}
    
    public Invoice(int invoiceId, int poId, int asnId, int supplierId, 
                   String invoiceNumber, Date invoiceDate, BigDecimal amount, 
                   String status, String notes) {
        this.invoiceId = invoiceId;
        this.poId = poId;
        this.asnId = asnId;
        this.supplierId = supplierId;
        this.invoiceNumber = invoiceNumber;
        this.invoiceDate = invoiceDate;
        this.amount = amount;
        this.status = status;
        this.notes = notes;
    }
    
    // Getters and Setters
    public int getInvoiceId() { return invoiceId; }
    public void setInvoiceId(int invoiceId) { this.invoiceId = invoiceId; }
    
    public int getPoId() { return poId; }
    public void setPoId(int poId) { this.poId = poId; }
    
    public int getAsnId() { return asnId; }
    public void setAsnId(int asnId) { this.asnId = asnId; }
    
    public int getSupplierId() { return supplierId; }
    public void setSupplierId(int supplierId) { this.supplierId = supplierId; }
    
    public String getInvoiceNumber() { return invoiceNumber; }
    public void setInvoiceNumber(String invoiceNumber) { this.invoiceNumber = invoiceNumber; }
    
    public Date getInvoiceDate() { return invoiceDate; }
    public void setInvoiceDate(Date invoiceDate) { this.invoiceDate = invoiceDate; }
    
    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    
    public String getMomoTransactionId() { return momoTransactionId; }
    public void setMomoTransactionId(String momoTransactionId) { 
        this.momoTransactionId = momoTransactionId; 
    }
    
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { 
        this.paymentMethod = paymentMethod; 
    }
    
    public String getPaymentUrl() { return paymentUrl; }
    public void setPaymentUrl(String paymentUrl) { this.paymentUrl = paymentUrl; }
    
    public Date getPaymentDate() { return paymentDate; }
    public void setPaymentDate(Date paymentDate) { this.paymentDate = paymentDate; }
}