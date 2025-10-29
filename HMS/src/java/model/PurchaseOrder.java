package model;

import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

public class PurchaseOrder {
    private int poId;
    private int managerId;
    private int supplierId;
    private String status;
    private Timestamp orderDate;  // Changed from Date to Timestamp
    private Date expectedDeliveryDate;
    private String notes;
    private Timestamp updatedAt;  // Changed from Date to Timestamp
    
    // Additional fields for display
    private String supplierName;
    private String managerName;
    private double totalAmount;
    private int itemCount;
    
    // ASN information
    private int asnId;
    private String trackingNumber;
    private String carrier;
    private String asnStatus;
    private boolean hasAsn;
    
    // IMPORTANT: Add list of items
    private List<PurchaseOrderItem> items;
    
    public PurchaseOrder() {
    }
    
    public PurchaseOrder(int poId, Integer managerId, int supplierId, String status, 
                        Timestamp orderDate, Date expectedDeliveryDate, String notes, 
                        Timestamp updatedAt) {
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
    
    public Timestamp getOrderDate() {
        return orderDate;
    }
    
    public void setOrderDate(Timestamp orderDate) {
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
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
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
    
    // NEW: Getter/Setter for items list
    public List<PurchaseOrderItem> getItems() {
        return items;
    }
    
    public void setItems(List<PurchaseOrderItem> items) {
        this.items = items;
        this.itemCount = items != null ? items.size() : 0;
    }
    
    public String getStatusBadgeClass() {
        switch (status) {
            case "Draft":
                return "badge bg-secondary";
            case "Sent":
                return "badge bg-warning";
            case "Approved":
                return "badge bg-success";
            case "Rejected":
                return "badge bg-danger";
            case "Received":
                return "badge bg-info";
            case "Completed":
                return "badge bg-primary";
            default:
                return "badge bg-secondary";
        }
    }
    // ASN Getters and Setters
public int getAsnId() {
    return asnId;
}

public void setAsnId(int asnId) {
    this.asnId = asnId;
}

public String getTrackingNumber() {
    return trackingNumber;
}

public void setTrackingNumber(String trackingNumber) {
    this.trackingNumber = trackingNumber;
}

public String getCarrier() {
    return carrier;
}

public void setCarrier(String carrier) {
    this.carrier = carrier;
}

public String getAsnStatus() {
    return asnStatus;
}

public void setAsnStatus(String asnStatus) {
    this.asnStatus = asnStatus;
}

public boolean isHasAsn() {
    return hasAsn;
}

public void setHasAsn(boolean hasAsn) {
    this.hasAsn = hasAsn;
}

// Helper methods for JSP display
public String getAsnStatusDisplay() {
    if (asnStatus == null) return "N/A";
    switch (asnStatus) {
        case "Sent":
            return "Shipped";
        case "In Transit":
            return "In Transit";
        case "Delivered":
            return "Delivered";
        case "Received":
            return "Received";
        default:
            return asnStatus;
    }
}

public String getAsnStatusBadgeClass() {
    if (asnStatus == null) return "status-badge";
    switch (asnStatus) {
        case "Sent":
            return "sent";
        case "In Transit":
            return "approved";
        case "Delivered":
        case "Received":
            return "completed";
        default:
            return "sent";
    }
}
}