package model;

import java.util.Date;

public class Transaction {
    private int transactionId;
    private int batchId;
    private int userId;
    private Integer dnId; // có thể null
    private String type;  // In, Out, Expired, Damaged, Adjustment...
    private int quantity;
    private Date transactionDate;
    private String notes;

    // Getters & Setters
    public int getTransactionId() { return transactionId; }
    public void setTransactionId(int transactionId) { this.transactionId = transactionId; }

    public int getBatchId() { return batchId; }
    public void setBatchId(int batchId) { this.batchId = batchId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Integer getDnId() { return dnId; }
    public void setDnId(Integer dnId) { this.dnId = dnId; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public Date getTransactionDate() { return transactionDate; }
    public void setTransactionDate(Date transactionDate) { this.transactionDate = transactionDate; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}
