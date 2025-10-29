package model;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;

public class AdvancedShippingNotice {
    // Primary fields
    private int asnId;
    private int poId;
    private int supplierId;
    private Date shipmentDate;
    private String carrier;
    private String trackingNumber;
    private String status; // Sent, InTransit, Delivered
    private String notes;
    
    // Workflow fields
    private String submittedBy;
    private String approvedBy;
    private Timestamp submittedAt;
    private Timestamp approvedAt;
    private String rejectionReason;
    
    // Timestamp fields
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Additional fields for display (joined data)
    private String supplierName;
    private String poStatus;
    private int totalItems;
    
    // Items list
    private List<ASNItem> items;
    
    // Constructors
    public AdvancedShippingNotice() {
    }
    
    public AdvancedShippingNotice(int poId, int supplierId, Date shipmentDate, 
                                 String carrier, String trackingNumber) {
        this.poId = poId;
        this.supplierId = supplierId;
        this.shipmentDate = shipmentDate;
        this.carrier = carrier;
        this.trackingNumber = trackingNumber;
        this.status = "Sent"; // Default status
    }
    
    // Getters and Setters
    public int getAsnId() {
        return asnId;
    }
    
    public void setAsnId(int asnId) {
        this.asnId = asnId;
    }
    
    public int getPoId() {
        return poId;
    }
    
    public void setPoId(int poId) {
        this.poId = poId;
    }
    
    public int getSupplierId() {
        return supplierId;
    }
    
    public void setSupplierId(int supplierId) {
        this.supplierId = supplierId;
    }
    
    public Date getShipmentDate() {
        return shipmentDate;
    }
    
    public void setShipmentDate(Date shipmentDate) {
        this.shipmentDate = shipmentDate;
    }
    
    public String getCarrier() {
        return carrier;
    }
    
    public void setCarrier(String carrier) {
        this.carrier = carrier;
    }
    
    public String getTrackingNumber() {
        return trackingNumber;
    }
    
    public void setTrackingNumber(String trackingNumber) {
        this.trackingNumber = trackingNumber;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    // Workflow getters/setters
    public String getSubmittedBy() {
        return submittedBy;
    }
    
    public void setSubmittedBy(String submittedBy) {
        this.submittedBy = submittedBy;
    }
    
    public String getApprovedBy() {
        return approvedBy;
    }
    
    public void setApprovedBy(String approvedBy) {
        this.approvedBy = approvedBy;
    }
    
    public Timestamp getSubmittedAt() {
        return submittedAt;
    }
    
    public void setSubmittedAt(Timestamp submittedAt) {
        this.submittedAt = submittedAt;
    }
    
    public Timestamp getApprovedAt() {
        return approvedAt;
    }
    
    public void setApprovedAt(Timestamp approvedAt) {
        this.approvedAt = approvedAt;
    }
    
    public String getRejectionReason() {
        return rejectionReason;
    }
    
    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }
    
    // Timestamp getters/setters
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    // Additional fields getters/setters
    public String getSupplierName() {
        return supplierName;
    }
    
    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }
    
    public String getPoStatus() {
        return poStatus;
    }
    
    public void setPoStatus(String poStatus) {
        this.poStatus = poStatus;
    }
    
    public int getTotalItems() {
        return totalItems;
    }
    
    public void setTotalItems(int totalItems) {
        this.totalItems = totalItems;
    }
    
    // Items list getter/setter
    public List<ASNItem> getItems() {
        return items;
    }
    
    public void setItems(List<ASNItem> items) {
        this.items = items;
        if (items != null) {
            this.totalItems = items.size();
        }
    }
    
    // Helper methods
    public boolean isSent() {
        return "Sent".equals(status);
    }
    
    public boolean isInTransit() {
        return "InTransit".equals(status);
    }
    
    public boolean isDelivered() {
        return "Delivered".equals(status);
    }
    
    public String getStatusBadgeClass() {
        switch (status) {
            case "Sent":
                return "badge bg-warning";
            case "InTransit":
                return "badge bg-info";
            case "Delivered":
                return "badge bg-success";
            default:
                return "badge bg-secondary";
        }
    }
    
    public String getStatusDisplay() {
        switch (status) {
            case "Sent":
                return "Awaiting Shipment";
            case "InTransit":
                return "In Transit";
            case "Delivered":
                return "Delivered";
            default:
                return status;
        }
    }
    
    @Override
    public String toString() {
        return "AdvancedShippingNotice{" +
                "asnId=" + asnId +
                ", poId=" + poId +
                ", supplierId=" + supplierId +
                ", shipmentDate=" + shipmentDate +
                ", carrier='" + carrier + '\'' +
                ", trackingNumber='" + trackingNumber + '\'' +
                ", status='" + status + '\'' +
                ", submittedBy='" + submittedBy + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}