package model;

import java.sql.Date;

public class PurchaseOrder {
    private int poId;
    private int managerId;
    private int supplierId;
    private String status;
    private Date orderDate;
    private Date expectedDeliveryDate;
    private String notes;
    
    // Additional fields for display
    private String supplierName;
    private String managerName;

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