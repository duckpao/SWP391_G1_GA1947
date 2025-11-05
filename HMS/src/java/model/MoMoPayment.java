package model;

import java.math.BigDecimal;
import java.util.Date;

public class MoMoPayment {
    private int invoiceId;
    private String orderId;
    private String requestId;
    private BigDecimal amount;
    private String orderInfo;
    private String transId; // MoMo transaction ID
    private String resultCode;
    private String message;
    private String payUrl;
    private Date createdAt;
    private Date completedAt;
    private String status; // PENDING, SUCCESS, FAILED
    
    // Constructors
    public MoMoPayment() {}
    
    public MoMoPayment(int invoiceId, String orderId, BigDecimal amount, String orderInfo) {
        this.invoiceId = invoiceId;
        this.orderId = orderId;
        this.amount = amount;
        this.orderInfo = orderInfo;
        this.status = "PENDING";
        this.createdAt = new Date();
    }
    
    // Getters and Setters
    public int getInvoiceId() { return invoiceId; }
    public void setInvoiceId(int invoiceId) { this.invoiceId = invoiceId; }
    
    public String getOrderId() { return orderId; }
    public void setOrderId(String orderId) { this.orderId = orderId; }
    
    public String getRequestId() { return requestId; }
    public void setRequestId(String requestId) { this.requestId = requestId; }
    
    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }
    
    public String getOrderInfo() { return orderInfo; }
    public void setOrderInfo(String orderInfo) { this.orderInfo = orderInfo; }
    
    public String getTransId() { return transId; }
    public void setTransId(String transId) { this.transId = transId; }
    
    public String getResultCode() { return resultCode; }
    public void setResultCode(String resultCode) { this.resultCode = resultCode; }
    
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    
    public String getPayUrl() { return payUrl; }
    public void setPayUrl(String payUrl) { this.payUrl = payUrl; }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    
    public Date getCompletedAt() { return completedAt; }
    public void setCompletedAt(Date completedAt) { this.completedAt = completedAt; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    // Helper method
    public boolean isSuccess() {
        return "0".equals(resultCode);
    }
}