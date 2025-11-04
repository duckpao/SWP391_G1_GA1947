package model;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;

public class AdvancedShippingNotice {

    private int asnId;
    private int poId;
    private int supplierId;
    private Date shipmentDate;
    private String carrier;
    private String trackingNumber;
    private String status; // Pending, Sent, InTransit, Delivered, Rejected, Cancelled
    private String notes;
    private String submittedBy;
    private String approvedBy;
    private Timestamp submittedAt;
    private Timestamp approvedAt;
    private String rejectionReason;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Additional fields for display
    private String supplierName;
    private String poStatus;
    private Date expectedDeliveryDate;
    private int totalQuantity;
    private int totalItems;
    private List<ASNItem> items;

    // Constructors
    public AdvancedShippingNotice() {
    }

    public Date getExpectedDeliveryDate() {
        return expectedDeliveryDate;
    }

    public void setExpectedDeliveryDate(Date expectedDeliveryDate) {
        this.expectedDeliveryDate = expectedDeliveryDate;
    }

    public int getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(int totalQuantity) {
        this.totalQuantity = totalQuantity;
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
    public String getStatusBadgeClass() {
        if (status == null) {
            return "secondary";
        }
        switch (status) {
            case "Pending":
                return "warning";
            case "Sent":
                return "info";
            case "InTransit":
                return "primary";
            case "Delivered":
                return "success";
            case "Rejected":
                return "danger";
            case "Cancelled":
                return "secondary";
            default:
                return "secondary";
        }
    }

    public String getStatusIcon() {
        if (status == null) {
            return "bi-question-circle";
        }
        switch (status) {
            case "Pending":
                return "bi-clock-history";
            case "Sent":
                return "bi-send-check";
            case "InTransit":
                return "bi-truck";
            case "Delivered":
                return "bi-check-circle-fill";
            case "Rejected":
                return "bi-x-circle-fill";
            case "Cancelled":
                return "bi-dash-circle-fill";
            default:
                return "bi-question-circle";
        }
    }

    public boolean canBeEdited() {
        return "Pending".equals(status) || "Sent".equals(status);
    }

    public boolean canBeCancelled() {
        return "Pending".equals(status) || "Sent".equals(status);
    }
}
