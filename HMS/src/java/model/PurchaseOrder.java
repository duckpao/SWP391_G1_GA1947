package model;

import java.sql.Timestamp;
import java.sql.Date;

public class PurchaseOrder {

    private int poId;
    private int managerId;
    private int supplierId;
    private String status;
    private Date orderDate;
    private Date expectedDeliveryDate;
    private String notes;
    private Date updatedAt;

    // Additional fields for display
    private String supplierName;
    private String managerName;
    private double totalAmount;
    private int itemCount;

    public PurchaseOrder() {
    }

    
    
    public PurchaseOrder(int poId, Integer managerId, int supplierId, String status, 
                        Date orderDate, Date expectedDeliveryDate, String notes, 
                        Date updatedAt) {
        this.poId = poId;
        this.managerId = managerId;
        this.supplierId = supplierId;
        this.status = status;
        this.orderDate = orderDate;
        this.expectedDeliveryDate = expectedDeliveryDate;
        this.notes = notes;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public int getPoId() {
        return poId;
    }

    public void setPoId(int poId) {
        this.poId = poId;
    }

    public int getManagerId() {
        return managerId;
    }

    public void setManagerId(int managerId) {
        this.managerId = managerId;
    }

    public int getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(int supplierId) {
        this.supplierId = supplierId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }

    public Date getExpectedDeliveryDate() {
        return expectedDeliveryDate;
    }

    public void setExpectedDeliveryDate(Date expectedDeliveryDate) {
        this.expectedDeliveryDate = expectedDeliveryDate;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public String getManagerName() {
        return managerName;
    }

    public void setManagerName(String managerName) {
        this.managerName = managerName;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public int getItemCount() {
        return itemCount;
    }

    public void setItemCount(int itemCount) {
        this.itemCount = itemCount;
    }

    
    
    public String getStatusBadgeClass() {
        switch (status) {
            case "Draft":
                return "badge bg-secondary";
            case "Sent":
                return "badge bg-warning";
            case "Approved":
                return "badge bg-success";
            case "Cancelled":
                return "badge bg-danger";
            case "Delivered":
                return "badge bg-primary";
            default:
                return "badge bg-secondary";
        }
    }
}
